///|
priv struct AppState {
  mut started : Bool
  mut markdown : String
  mut root : OutlineNode
  mut collapsed : Array[Int]
  mut selected_node : Int
  mut editing_node : Int
  mut layout_mode : String
  mut style_mode : String
  mut detail_level : String
  mut detail_customized : Bool
  mut left_panel_percent : Int
  mut drag_source_index : Int
  mut drag_source_parent : Int
}

///|
let app_state : AppState = AppState::{
  started: false,
  markdown: "",
  root: empty_outline(),
  collapsed: [],
  selected_node: -2,
  editing_node: -2,
  layout_mode: "horizontal",
  style_mode: "line",
  detail_level: "all",
  detail_customized: false,
  left_panel_percent: 33,
  drag_source_index: -1,
  drag_source_parent: -2,
}

///|
pub fn start_web_app() -> Unit {
  if app_state.started {
    render_ui()
    return
  }
  app_state.started = true
  set_app_html(render_app_shell_html())
  bind_static_ui(
    on_new_click, on_sample_click, on_upload_click, on_download_markdown_click, on_layout_change,
    on_style_change, on_detail_change, on_export_change, on_toolbar_action,
  )
  bind_splitter_ui(on_splitter_change)
  bind_input_listener(on_input_change)
  bind_mindmap_ui(
    on_mindmap_click, on_mindmap_dblclick, on_mindmap_keydown, on_mindmap_focusout,
    on_mindmap_dragstart, on_mindmap_dragend, on_mindmap_dragover, on_mindmap_drop,
  )
  load_markdown(sample_markdown(), true)
}

///|
fn on_new_click() -> Unit {
  load_markdown("", true)
}

///|
fn on_sample_click() -> Unit {
  load_markdown(sample_markdown(), true)
}

///|
fn on_upload_click() -> Unit {
  pick_markdown_file(on_upload_loaded)
}

///|
fn on_upload_loaded(markdown : String) -> Unit {
  load_markdown(markdown, true)
}

///|
fn on_download_markdown_click() -> Unit {
  download_text("moonmarkmind.md", app_state.markdown)
}

///|
fn on_input_change() -> Unit {
  load_markdown(get_input_value(), true)
}

///|
fn on_layout_change(mode : String) -> Unit {
  app_state.layout_mode = normalize_layout_mode(mode)
  render_ui()
}

///|
fn on_style_change(mode : String) -> Unit {
  app_state.style_mode = normalize_style_mode(mode)
  render_ui()
}

///|
fn on_detail_change(level : String) -> Unit {
  app_state.detail_level = normalize_detail_level(level)
  apply_detail_preset()
  sync_detail_customized()
  render_ui()
}

///|
fn on_export_change(kind : String) -> Unit {
  match kind {
    "png" => download_mindmap_png("moonmarkmind.png")
    "svg" => download_mindmap_svg("moonmarkmind.svg")
    "html" => download_current_page_html("moonmarkmind.html")
    _ => ()
  }
  set_select_value("export-select", "")
}

///|
fn on_splitter_change(percent : Int) -> Unit {
  app_state.left_panel_percent = normalize_split_percent(percent)
  set_workspace_split(app_state.left_panel_percent)
}

///|
fn on_mindmap_click(event : BrowserEvent) -> Unit {
  let action = event_action(event)
  let node_index = event_node_index(event)
  if node_index >= 0 && app_state.selected_node != node_index {
    app_state.selected_node = node_index
  } else if node_index < 0 && action == "" && app_state.selected_node != -2 {
    app_state.selected_node = -2
  }
  match action {
    "add" => {
      stop_event(event)
      handle_add_child(node_index)
    }
    "delete" => {
      stop_event(event)
      handle_delete(node_index)
    }
    "toggle" => {
      stop_event(event)
      toggle_collapsed(node_index)
      sync_detail_customized()
      render_ui()
    }
    "toggle-card" => {
      toggle_collapsed(node_index)
      sync_detail_customized()
      render_ui()
    }
    _ => if action == "" { render_ui() }
  }
}

///|
fn on_toolbar_action(action : String) -> Unit {
  if app_state.selected_node < 0 {
    return
  }
  match action {
    "new-branch" => handle_add_sibling(app_state.selected_node, true)
    "new-child" => handle_add_child(app_state.selected_node)
    "delete-node" => handle_delete(app_state.selected_node)
    "edit-node" => start_edit_selected()
    "move-up" => handle_move_selected(false)
    "move-down" => handle_move_selected(true)
    "toggle-node" => {
      toggle_collapsed(app_state.selected_node)
      sync_detail_customized()
      render_ui()
    }
    "insert-node" => handle_add_sibling(app_state.selected_node, false)
    _ => ()
  }
}

///|
fn on_mindmap_dblclick(event : BrowserEvent) -> Unit {
  if event_action(event) != "edit-title" {
    return
  }
  stop_event(event)
  let node_index = event_node_index(event)
  if node_index < 0 {
    return
  }
  app_state.selected_node = node_index
  app_state.editing_node = node_index
  render_ui()
}

///|
fn on_mindmap_keydown(event : BrowserEvent) -> Unit {
  let node_index = event_editor_index(event)
  if node_index < 0 {
    return
  }
  match event_key(event) {
    "Enter" => {
      prevent_event_default(event)
      save_editor(node_index, event_editor_value(event))
    }
    "Escape" => {
      app_state.editing_node = -2
      render_ui()
    }
    _ => ()
  }
}

///|
fn on_mindmap_focusout(event : BrowserEvent) -> Unit {
  let node_index = event_editor_index(event)
  if node_index < 0 {
    return
  }
  save_editor(node_index, event_editor_value(event))
}

///|
fn on_mindmap_dragstart(event : BrowserEvent) -> Unit {
  let node_index = event_drag_source_index(event)
  if node_index < 0 {
    return
  }
  app_state.drag_source_index = node_index
  app_state.drag_source_parent = event_drag_parent(event)
  set_drag_text(event, node_index.to_string())
}

///|
fn on_mindmap_dragend(_event : BrowserEvent) -> Unit {
  app_state.drag_source_index = -1
  app_state.drag_source_parent = -2
  clear_drop_highlights()
}

///|
fn on_mindmap_dragover(event : BrowserEvent) -> Unit {
  let target_index = event_drop_target_index(event)
  let parent_index = event_drop_parent_index(event)
  if !is_valid_drop_target(target_index, parent_index) {
    clear_drop_highlights()
    return
  }
  prevent_event_default(event)
  highlight_drop_target(target_index, event_drop_place_after(event))
}

///|
fn on_mindmap_drop(event : BrowserEvent) -> Unit {
  let target_index = event_drop_target_index(event)
  let parent_index = event_drop_parent_index(event)
  if !is_valid_drop_target(target_index, parent_index) {
    clear_drop_highlights()
    return
  }
  prevent_event_default(event)
  clear_drop_highlights()
  let next_markdown = move_heading(
    app_state.markdown,
    app_state.drag_source_index,
    target_index,
    event_drop_place_after(event),
  )
  app_state.drag_source_index = -1
  app_state.drag_source_parent = -2
  load_markdown(next_markdown, false)
}

///|
fn handle_add_child(node_index : Int) -> Unit {
  let title = prompt_text("New node title", "New node")
  if title.length() == 0 {
    return
  }
  let next_markdown = add_child_heading(app_state.markdown, node_index, title)
  load_markdown(next_markdown, false)
  expand_node(node_index)
  sync_detail_customized()
  render_ui()
}

///|
fn handle_add_sibling(node_index : Int, place_after : Bool) -> Unit {
  let title = prompt_text("New node title", "New node")
  if title.length() == 0 {
    return
  }
  let next_markdown = add_sibling_heading(
    app_state.markdown,
    node_index,
    title,
    place_after,
  )
  if !place_after {
    app_state.selected_node = node_index + 1
  }
  load_markdown(next_markdown, false)
}

///|
fn handle_delete(node_index : Int) -> Unit {
  if node_index < 0 {
    return
  }
  match find_node(app_state.root, node_index) {
    Some(node) => {
      let message = "Delete \"\{node.title}\" and its children?"
      if !confirm_text(message) {
        return
      }
      let next_markdown = delete_heading(app_state.markdown, node_index)
      app_state.selected_node = -2
      load_markdown(next_markdown, false)
    }
    None => ()
  }
}

///|
fn save_editor(node_index : Int, title : String) -> Unit {
  let next_markdown = rename_heading(app_state.markdown, node_index, title)
  app_state.selected_node = node_index
  app_state.editing_node = -2
  load_markdown(next_markdown, false)
}

///|
fn start_edit_selected() -> Unit {
  if app_state.selected_node < 0 {
    return
  }
  app_state.editing_node = app_state.selected_node
  render_ui()
}

///|
fn handle_move_selected(move_down : Bool) -> Unit {
  if app_state.selected_node < 0 {
    return
  }
  let next_markdown = move_heading_among_siblings(
    app_state.markdown,
    app_state.selected_node,
    move_down,
  )
  load_markdown(next_markdown, false)
}

///|
fn load_markdown(markdown : String, reset_ui : Bool) -> Unit {
  if reset_ui {
    app_state.editing_node = -2
    app_state.selected_node = -2
  }
  app_state.markdown = markdown
  app_state.root = build_outline(markdown)
  if reset_ui {
    apply_detail_preset()
  } else {
    sanitize_collapsed_state()
    sanitize_selected_state()
  }
  if get_input_value() != markdown {
    set_input_value(markdown)
  }
  set_output_text(render_ascii_mindmap(markdown))
  sync_detail_customized()
  render_ui()
}

///|
fn render_ui() -> Unit {
  set_select_value("layout-select", app_state.layout_mode)
  set_select_value("style-select", app_state.style_mode)
  let detail_select_value = if app_state.detail_customized {
    "custom-\{app_state.detail_level}"
  } else {
    app_state.detail_level
  }
  set_select_value("detail-select", detail_select_value)
  set_select_muted("detail-select", app_state.detail_customized)
  set_toolbar_selection_enabled(app_state.selected_node >= 0)
  set_workspace_split(app_state.left_panel_percent)
  set_mindmap_html(render_mindmap_html())
  if app_state.editing_node >= 0 {
    focus_editor(app_state.editing_node)
  }
}

///|
fn sync_detail_customized() -> Unit {
  app_state.detail_customized = !same_collapse_state(
    app_state.collapsed,
    preset_collapsed_for_level(app_state.root, app_state.detail_level),
  )
}

///|
fn render_mindmap_html() -> String {
  let stage_class = render_stage_class()
  match app_state.layout_mode {
    "vertical" => render_vertical_mindmap(app_state.root, stage_class)
    "single-right" => render_single_right_mindmap(app_state.root, stage_class)
    _ => render_horizontal_mindmap(app_state.root, stage_class)
  }
}

///|
fn render_horizontal_mindmap(
  center : OutlineNode,
  stage_class : String,
) -> String {
  let left_parts = []
  let right_parts = []
  if should_render_children(center) {
    for index in 0..<center.children.length() {
      let child = center.children[index]
      if index % 2 == 0 {
        right_parts.push(render_branch_node(child, center.flat_index, "right"))
      } else {
        left_parts.push(render_branch_node(child, center.flat_index, "left"))
      }
    }
  }
  let left_html = left_parts.join("")
  let center_html = render_node_card(center, -1, true)
  let right_html = right_parts.join("")
  "<div class=\"\{stage_class}\"><div class=\"branch-column branch-column--left\">\{left_html}</div><div class=\"center-wrap\">\{center_html}</div><div class=\"branch-column branch-column--right\">\{right_html}</div></div>"
}

///|
fn render_branch_node(
  node : OutlineNode,
  parent_index : Int,
  direction : String,
) -> String {
  let before_slot = render_drop_slot(node.flat_index, parent_index, "before")
  let card = render_node_card(node, parent_index, false)
  let after_slot = render_drop_slot(node.flat_index, parent_index, "after")
  let children_html = render_branch_children(node, direction)
  "<div class=\"branch-item branch-item--\{direction}\">\{before_slot}\{card}\{after_slot}\{children_html}</div>"
}

///|
fn render_branch_children(node : OutlineNode, direction : String) -> String {
  if !should_render_children(node) {
    return ""
  }
  let child_parts = []
  for child in node.children {
    child_parts.push(render_branch_node(child, node.flat_index, direction))
  }
  let body = child_parts.join("")
  "<div class=\"branch-children branch-children--\{direction}\">\{body}</div>"
}

///|
fn render_vertical_mindmap(
  center : OutlineNode,
  stage_class : String,
) -> String {
  let tree_html = render_vertical_tree(center, -1, true)
  "<div class=\"\{stage_class} mindmap-stage--vertical\"><div class=\"vertical-root\">\{tree_html}</div></div>"
}

///|
fn render_vertical_tree(
  node : OutlineNode,
  parent_index : Int,
  is_root : Bool,
) -> String {
  let before_slot = render_drop_slot(node.flat_index, parent_index, "before")
  let card = render_node_card(node, parent_index, is_root)
  let after_slot = render_drop_slot(node.flat_index, parent_index, "after")
  let children_html = render_vertical_children(node)
  "<div class=\"vertical-tree\">\{before_slot}\{card}\{after_slot}\{children_html}</div>"
}

///|
fn render_vertical_children(node : OutlineNode) -> String {
  if !should_render_children(node) {
    return ""
  }
  let child_parts = []
  for child in node.children {
    let child_html = render_vertical_tree(child, node.flat_index, false)
    child_parts.push("<div class=\"vertical-tree__child\">\{child_html}</div>")
  }
  let body = child_parts.join("")
  "<div class=\"vertical-tree__children\">\{body}</div>"
}

///|
fn render_single_right_mindmap(
  center : OutlineNode,
  stage_class : String,
) -> String {
  let tree_html = render_single_right_tree(center, -1, true)
  "<div class=\"\{stage_class} mindmap-stage--single-right\"><div class=\"single-right-tree\">\{tree_html}</div></div>"
}

///|
fn render_single_right_tree(
  node : OutlineNode,
  parent_index : Int,
  is_root : Bool,
) -> String {
  let before_slot = render_drop_slot(node.flat_index, parent_index, "before")
  let card = render_node_card(node, parent_index, is_root)
  let after_slot = render_drop_slot(node.flat_index, parent_index, "after")
  let children_html = render_single_right_children(node)
  "<div class=\"single-right-tree__node\">\{before_slot}\{card}\{after_slot}\{children_html}</div>"
}

///|
fn render_single_right_children(node : OutlineNode) -> String {
  if !should_render_children(node) {
    return ""
  }
  let child_parts = []
  for child in node.children {
    child_parts.push(render_single_right_tree(child, node.flat_index, false))
  }
  let body = child_parts.join("")
  "<div class=\"single-right-tree__children\">\{body}</div>"
}

///|
fn render_node_card(
  node : OutlineNode,
  parent_index : Int,
  is_center : Bool,
) -> String {
  let has_children = node.children.length() > 0
  let editable = !node.synthetic
  let is_editing = app_state.editing_node == node.flat_index
  let is_draggable = editable && !is_center && !is_editing
  let classes = ["node"]
  if is_center {
    classes.push("node--center")
  }
  if app_state.selected_node == node.flat_index {
    classes.push("is-selected")
  }
  classes.push(render_node_style_class())
  if has_children {
    classes.push("is-clickable")
  }
  if is_draggable {
    classes.push("is-draggable")
  }
  let class_name = classes.join(" ")
  let title_html = render_node_title(node, editable, is_editing)
  let action_html = render_node_actions(node, has_children, editable, is_center)
  let drag_attrs = render_drag_attrs(node, parent_index, is_draggable)
  let toggle_attr = if has_children {
    " data-action=\"toggle-card\""
  } else {
    ""
  }
  "<div class=\"\{class_name}\" data-level=\"\{node.level}\" data-node-index=\"\{node.flat_index}\" data-parent-index=\"\{parent_index}\"\{drag_attrs}\{toggle_attr}><small>Level \{node.level}</small>\{title_html}\{action_html}</div>"
}

///|
fn render_drag_attrs(
  node : OutlineNode,
  parent_index : Int,
  is_draggable : Bool,
) -> String {
  if !is_draggable {
    return ""
  }
  " draggable=\"true\" data-drag-index=\"\{node.flat_index}\" data-drag-parent=\"\{parent_index}\""
}

///|
fn render_node_title(
  node : OutlineNode,
  editable : Bool,
  is_editing : Bool,
) -> String {
  if is_editing {
    let value = escape_html_attribute(node.title)
    return "<input class=\"node-editor\" data-editor-for=\"\{node.flat_index}\" type=\"text\" value=\"\{value}\" />"
  }
  let action_attr = if editable { " data-action=\"edit-title\"" } else { "" }
  let title = escape_html(node.title)
  "<strong\{action_attr}>\{title}</strong>"
}

///|
fn render_node_actions(
  node : OutlineNode,
  has_children : Bool,
  editable : Bool,
  is_center : Bool,
) -> String {
  let items = []
  items.push(
    "<button type=\"button\" class=\"node-action\" data-action=\"add\" title=\"Add child node\">+</button>",
  )
  if editable && !is_center {
    items.push(
      "<button type=\"button\" class=\"node-action node-action--danger\" data-action=\"delete\" title=\"Delete node\">x</button>",
    )
  }
  if has_children {
    let collapsed = is_collapsed(node.flat_index)
    let label = if collapsed { "+" } else { "-" }
    let title = if collapsed { "Expand node" } else { "Collapse node" }
    let expanded = (!collapsed).to_string()
    items.push(
      "<button type=\"button\" class=\"node-action\" data-action=\"toggle\" title=\"\{title}\" aria-label=\"\{title}\" aria-expanded=\"\{expanded}\">\{label}</button>",
    )
  }
  let body = items.join("")
  "<div class=\"node-actions\">\{body}</div>"
}

///|
fn render_drop_slot(
  node_index : Int,
  parent_index : Int,
  position : String,
) -> String {
  if node_index < 0 {
    return ""
  }
  "<div class=\"drop-slot\" data-drop-target=\"\{node_index}\" data-drop-parent=\"\{parent_index}\" data-drop-position=\"\{position}\"></div>"
}

///|
fn toggle_collapsed(node_index : Int) -> Unit {
  if node_index < 0 {
    return
  }
  if is_collapsed(node_index) {
    app_state.collapsed = remove_int(app_state.collapsed, node_index)
  } else {
    app_state.collapsed.push(node_index)
  }
}

///|
fn expand_node(node_index : Int) -> Unit {
  if node_index < 0 {
    return
  }
  app_state.collapsed = remove_int(app_state.collapsed, node_index)
}

///|
fn is_collapsed(node_index : Int) -> Bool {
  contains_int(app_state.collapsed, node_index)
}

///|
fn contains_int(values : Array[Int], target : Int) -> Bool {
  for value in values {
    if value == target {
      return true
    }
  }
  false
}

///|
fn remove_int(values : Array[Int], target : Int) -> Array[Int] {
  let next = []
  for value in values {
    if value != target {
      next.push(value)
    }
  }
  next
}

///|
fn normalize_layout_mode(mode : String) -> String {
  match mode {
    "vertical" => "vertical"
    "single-right" => "single-right"
    _ => "horizontal"
  }
}

///|
fn normalize_style_mode(mode : String) -> String {
  match mode {
    "fill" => "fill"
    _ => "line"
  }
}

///|
fn normalize_detail_level(level : String) -> String {
  match level {
    "small" => "small"
    "custom-small" => "small"
    "custom-all" => "all"
    "custom-medium" => "medium"
    "all" => "all"
    _ => "medium"
  }
}

///|
fn render_stage_class() -> String {
  let classes = ["mindmap-stage"]
  if app_state.style_mode == "fill" {
    classes.push("mindmap-stage--fill")
  } else {
    classes.push("mindmap-stage--line")
  }
  classes.join(" ")
}

///|
fn render_node_style_class() -> String {
  if app_state.style_mode == "fill" {
    "node--fill"
  } else {
    "node--line"
  }
}

///|
fn should_render_children(node : OutlineNode) -> Bool {
  node.children.length() > 0 && !is_collapsed(node.flat_index)
}

///|
fn node_depth(node : OutlineNode) -> Int {
  node.level - app_state.root.level + 1
}

///|
fn apply_detail_preset() -> Unit {
  app_state.collapsed = preset_collapsed_for_level(
    app_state.root,
    app_state.detail_level,
  )
}

///|
fn preset_collapsed_for_level(
  root : OutlineNode,
  detail_level : String,
) -> Array[Int] {
  let threshold = match detail_level {
    "small" => 1
    "all" => 1000
    _ => 3
  }
  let collapsed = []
  collect_preset_collapsed(root, threshold, collapsed)
  collapsed
}

///|
fn collect_preset_collapsed(
  node : OutlineNode,
  threshold : Int,
  collapsed : Array[Int],
) -> Unit {
  let should_collapse = !node.synthetic &&
    node.children.length() > 0 &&
    node_depth(node) >= threshold
  if should_collapse {
    collapsed.push(node.flat_index)
  }
  for child in node.children {
    collect_preset_collapsed(child, threshold, collapsed)
  }
}

///|
fn sanitize_collapsed_state() -> Unit {
  let next = []
  for node_index in app_state.collapsed {
    if is_collapsible_node(app_state.root, node_index) {
      next.push(node_index)
    }
  }
  app_state.collapsed = next
}

///|
fn sanitize_selected_state() -> Unit {
  if app_state.selected_node < 0 {
    return
  }
  match find_node(app_state.root, app_state.selected_node) {
    Some(_) => ()
    None => app_state.selected_node = -2
  }
}

///|
fn is_collapsible_node(node : OutlineNode, target : Int) -> Bool {
  if node.flat_index == target {
    return !node.synthetic && node.children.length() > 0
  }
  for child in node.children {
    if is_collapsible_node(child, target) {
      return true
    }
  }
  false
}

///|
fn same_collapse_state(left : Array[Int], right : Array[Int]) -> Bool {
  if left.length() != right.length() {
    return false
  }
  for value in left {
    if !contains_int(right, value) {
      return false
    }
  }
  true
}

///|
fn normalize_split_percent(percent : Int) -> Int {
  if percent < 28 {
    28
  } else if percent > 58 {
    58
  } else {
    percent
  }
}

///|
fn is_valid_drop_target(target_index : Int, parent_index : Int) -> Bool {
  if app_state.drag_source_index < 0 || target_index < 0 {
    return false
  }
  if app_state.drag_source_index == target_index {
    return false
  }
  app_state.drag_source_parent == parent_index
}

///|
fn find_node(node : OutlineNode, target : Int) -> OutlineNode? {
  if node.flat_index == target {
    return Some(node)
  }
  for child in node.children {
    match find_node(child, target) {
      Some(found) => return Some(found)
      None => ()
    }
  }
  None
}

///|
fn escape_html(source : String) -> String {
  source
  .replace(old="&", new="&amp;")
  .replace(old="<", new="&lt;")
  .replace(old=">", new="&gt;")
  .replace(old="\"", new="&quot;")
}

///|
fn escape_html_attribute(source : String) -> String {
  escape_html(source).replace(old="'", new="&#39;")
}

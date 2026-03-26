///|
priv struct AppState {
  mut started : Bool
  mut markdown : String
  mut document_name : String
  mut root : OutlineNode
  mut collapsed : Array[Int]
  mut hidden_nodes : Array[Int]
  mut undo_stack : Array[String]
  mut redo_stack : Array[String]
  mut selected_node : Int
  mut selected_nodes : Array[Int]
  mut selection_anchor_node : Int
  mut editing_node : Int
  mut layout_mode : String
  mut style_mode : String
  mut detail_level : String
  mut detail_customized : Bool
  mut left_panel_percent : Int
  mut root_split_count : Int
  mut reveal_selected_line : Bool
  mut drag_source_index : Int
  mut drag_source_parent : Int
}

///|
let app_state : AppState = AppState::{
  started: false,
  markdown: "",
  document_name: "notes.md",
  root: empty_outline(),
  collapsed: [],
  hidden_nodes: [],
  undo_stack: [],
  redo_stack: [],
  selected_node: -2,
  selected_nodes: [],
  selection_anchor_node: -2,
  editing_node: -2,
  layout_mode: "horizontal",
  style_mode: "line",
  detail_level: "all",
  detail_customized: false,
  left_panel_percent: 33,
  root_split_count: 0,
  reveal_selected_line: false,
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
  mount_app_shell()
  bind_static_ui(
    on_new_click, on_sample_click, on_upload_click, on_download_markdown_click, on_layout_change,
    on_style_change, on_detail_change, on_export_change, on_toolbar_action,
  )
  bind_splitter_ui(on_splitter_change)
  bind_mindmap_ui(
    on_mindmap_click, on_mindmap_dblclick, on_mindmap_keydown, on_mindmap_focusout,
    on_mindmap_dragstart, on_mindmap_dragend, on_mindmap_dragover, on_mindmap_drop,
  )
  bind_input_listener(on_input_change, on_input_selected_headings_change)
  load_markdown(sample_markdown(), true)
}

///|
fn on_new_click() -> Unit {
  reset_history()
  app_state.document_name = "notes.md"
  load_markdown("", true)
}

///|
fn on_sample_click() -> Unit {
  reset_history()
  app_state.document_name = "notes.md"
  load_markdown(sample_markdown(), true)
}

///|
fn on_upload_click() -> Unit {
  pick_markdown_file(on_upload_loaded)
}

///|
fn on_upload_loaded(filename : String, markdown : String) -> Unit {
  reset_history()
  app_state.document_name = normalize_document_name(filename)
  load_markdown(markdown, true)
}

///|
fn on_download_markdown_click() -> Unit {
  download_text(app_state.document_name, app_state.markdown)
}

///|
fn on_input_change() -> Unit {
  apply_markdown_change(get_input_value(), true)
}

///|
fn on_input_selected_headings_change(serialized : String) -> Unit {
  if serialized.length() == 0 {
    return
  }
  let next_selected_nodes = parse_selection_indices(serialized)
  if same_int_set(app_state.selected_nodes, next_selected_nodes) {
    return
  }
  apply_selected_nodes(next_selected_nodes, false)
  render_ui()
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
fn on_mindmap_click(event : @dom.MouseEvent) -> Unit {
  let action = event_action_from_point(event)
  let node_index = event_node_index_from_point(event)
  if node_index >= 0 {
    if event_shift_key(event) {
      select_node_range(node_index, true)
    } else if event_multi_select_key(event) {
      toggle_node_selection(node_index, true)
    } else if !is_single_selected_node(node_index) {
      select_single_node(node_index, true)
    }
  } else if action == "" && has_selected_nodes() {
    clear_selected_nodes()
  }
  match action {
    "add" => {
      event.stopPropagation()
      handle_add_child(node_index)
    }
    "delete" => {
      event.stopPropagation()
      handle_delete(node_index)
    }
    "toggle" => {
      event.stopPropagation()
      toggle_collapsed(node_index)
      sync_detail_customized()
      render_ui()
    }
    "toggle-hide" => {
      event.stopPropagation()
      toggle_hidden_node(node_index)
      render_ui()
    }
    _ => if action == "" { render_ui() }
  }
}

///|
fn on_toolbar_action(action : String) -> Unit {
  if !can_toolbar_action(action) {
    return
  }
  match action {
    "undo" => handle_undo()
    "redo" => handle_redo()
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
fn on_mindmap_dblclick(event : @dom.MouseEvent) -> Unit {
  if event_editor_index_from_target(event.target()) >= 0 {
    return
  }
  let node_index = event_node_index_from_point(event)
  if node_index < 0 {
    return
  }
  match find_node(app_state.root, node_index) {
    Some(node) => if node.synthetic { return }
    None => return
  }
  event.stopPropagation()
  select_single_node(node_index, true)
  app_state.editing_node = node_index
  render_ui()
}

///|
fn on_mindmap_keydown(event : @dom.KeyboardEvent) -> Unit {
  let editor_index = event_editor_index_from_target(event.target())
  if editor_index >= 0 {
    match event_key(event) {
      "Enter" => {
        event.preventDefault()
        save_editor(
          editor_index,
          event_editor_value_from_target(event.target()),
        )
      }
      "Escape" => {
        app_state.editing_node = -2
        render_ui()
      }
      _ => ()
    }
    return
  }
  let node_index = event_keyboard_node_index(event)
  if node_index < 0 {
    return
  }
  match event_key(event) {
    "Enter" => {
      event.preventDefault()
      event.stopPropagation()
      handle_add_sibling(node_index, true)
    }
    _ => ()
  }
}

///|
fn on_mindmap_focusout(event : @dom.FocusEvent) -> Unit {
  let node_index = event_editor_index_from_target(event.target())
  if node_index < 0 {
    return
  }
  save_editor(node_index, event_editor_value_from_target(event.target()))
}

///|
fn on_mindmap_dragstart(event : @dom.DragEvent) -> Unit {
  let node_index = event_drag_source_index(event)
  if node_index < 0 {
    return
  }
  app_state.drag_source_index = node_index
  app_state.drag_source_parent = event_drag_parent(event)
  match get_element("[data-drag-index=\"\{node_index}\"]") {
    Some(node) => toggle_class(node, "is-dragging", true)
    None => ()
  }
  set_drag_text(event, node_index.to_string())
}

///|
fn on_mindmap_dragend(_event : @dom.DragEvent) -> Unit {
  if app_state.drag_source_index >= 0 {
    match get_element("[data-drag-index=\"\{app_state.drag_source_index}\"]") {
      Some(node) => toggle_class(node, "is-dragging", false)
      None => ()
    }
  }
  app_state.drag_source_index = -1
  app_state.drag_source_parent = -2
  clear_drop_highlights()
}

///|
fn on_mindmap_dragover(event : @dom.DragEvent) -> Unit {
  let target_index = event_drop_target_index(event)
  let parent_index = event_drop_parent_index(event)
  if !is_valid_drop_target(target_index, parent_index) {
    clear_drop_highlights()
    return
  }
  event.preventDefault()
  highlight_drop_target(target_index, event_drop_place_after(event))
}

///|
fn on_mindmap_drop(event : @dom.DragEvent) -> Unit {
  let target_index = event_drop_target_index(event)
  let parent_index = event_drop_parent_index(event)
  if !is_valid_drop_target(target_index, parent_index) {
    clear_drop_highlights()
    return
  }
  event.preventDefault()
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
  let title = "New node"
  let target_index = target_index_after_add_child(node_index)
  let next_markdown = add_child_heading(app_state.markdown, node_index, title)
  apply_markdown_change(next_markdown, false)
  expand_node(node_index)
  if target_index >= 0 {
    select_single_node(target_index, false)
    app_state.editing_node = target_index
  }
  sync_detail_customized()
  render_ui()
}

///|
fn handle_add_sibling(node_index : Int, place_after : Bool) -> Unit {
  let title = "New node"
  let target_index = target_index_after_add_sibling(node_index, place_after)
  bump_root_split_after_insert(node_index)
  let next_markdown = add_sibling_heading(
    app_state.markdown,
    node_index,
    title,
    place_after,
  )
  apply_markdown_change(next_markdown, false)
  if target_index >= 0 {
    select_single_node(target_index, false)
    app_state.editing_node = target_index
  }
  render_ui()
}

///|
fn handle_delete(node_index : Int) -> Unit {
  if node_index < 0 {
    return
  }
  shrink_root_split_after_delete(node_index)
  let next_markdown = delete_heading(app_state.markdown, node_index)
  clear_selected_nodes()
  app_state.editing_node = -2
  apply_markdown_change(next_markdown, false)
}

///|
fn target_index_after_add_child(parent_index : Int) -> Int {
  if parent_index < 0 {
    return count_subtree_nodes(app_state.root) - 1
  }
  match find_node(app_state.root, parent_index) {
    Some(node) => parent_index + count_subtree_nodes(node)
    None => -1
  }
}

///|
fn target_index_after_add_sibling(node_index : Int, place_after : Bool) -> Int {
  if node_index < 0 {
    return -1
  }
  if !place_after {
    return node_index
  }
  match find_node(app_state.root, node_index) {
    Some(node) => node_index + count_subtree_nodes(node)
    None => -1
  }
}

///|
fn bump_root_split_after_insert(node_index : Int) -> Unit {
  let root_child_position = root_child_index(node_index)
  if root_child_position < 0 {
    return
  }
  if root_child_position < app_state.root_split_count {
    app_state.root_split_count += 1
  }
}

///|
fn shrink_root_split_after_delete(node_index : Int) -> Unit {
  let root_child_position = root_child_index(node_index)
  if root_child_position < 0 {
    return
  }
  if root_child_position < app_state.root_split_count &&
    app_state.root_split_count > 0 {
    app_state.root_split_count -= 1
  }
}

///|
fn root_child_index(node_index : Int) -> Int {
  let child_count = app_state.root.children.length()
  for index in 0..<child_count {
    if app_state.root.children[index].flat_index == node_index {
      return index
    }
  }
  -1
}

///|
fn default_root_split_count(root : OutlineNode) -> Int {
  (root.children.length() + 1) / 2
}

///|
fn save_editor(node_index : Int, title : String) -> Unit {
  let next_markdown = rename_heading(app_state.markdown, node_index, title)
  select_single_node(node_index, false)
  app_state.editing_node = -2
  apply_markdown_change(next_markdown, false)
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
  apply_markdown_change(next_markdown, false)
}

///|
fn handle_undo() -> Unit {
  if app_state.undo_stack.length() == 0 {
    return
  }
  let last_index = app_state.undo_stack.length() - 1
  let previous = app_state.undo_stack[last_index]
  app_state.undo_stack = slice_strings(app_state.undo_stack, 0, last_index)
  app_state.redo_stack.push(app_state.markdown)
  load_markdown(previous, false)
}

///|
fn handle_redo() -> Unit {
  if app_state.redo_stack.length() == 0 {
    return
  }
  let last_index = app_state.redo_stack.length() - 1
  let next_markdown = app_state.redo_stack[last_index]
  app_state.redo_stack = slice_strings(app_state.redo_stack, 0, last_index)
  app_state.undo_stack.push(app_state.markdown)
  load_markdown(next_markdown, false)
}

///|
fn apply_markdown_change(markdown : String, reset_ui : Bool) -> Unit {
  if markdown == app_state.markdown {
    if reset_ui {
      load_markdown(markdown, true)
    }
    return
  }
  if app_state.markdown.length() > 0 || markdown.length() > 0 {
    app_state.undo_stack.push(app_state.markdown)
  }
  app_state.redo_stack = []
  load_markdown(markdown, reset_ui)
}

///|
fn reset_history() -> Unit {
  app_state.undo_stack = []
  app_state.redo_stack = []
}

///|
fn selected_node_exists() -> Bool {
  if app_state.selected_node < 0 {
    return false
  }
  match find_node(app_state.root, app_state.selected_node) {
    Some(_) => true
    None => false
  }
}

///|
fn selected_has_children() -> Bool {
  if app_state.selected_node < 0 {
    return false
  }
  match find_node(app_state.root, app_state.selected_node) {
    Some(node) => node.children.length() > 0
    None => false
  }
}

///|
fn can_add_sibling_selected() -> Bool {
  if app_state.selected_node < 0 {
    return false
  }
  app_state.root.synthetic ||
  app_state.selected_node != app_state.root.flat_index
}

///|
fn can_move_selected(move_down : Bool) -> Bool {
  if app_state.selected_node < 0 {
    return false
  }
  move_heading_among_siblings(
    app_state.markdown,
    app_state.selected_node,
    move_down,
  ) !=
  app_state.markdown
}

///|
fn load_markdown(markdown : String, reset_ui : Bool) -> Unit {
  if reset_ui {
    app_state.editing_node = -2
    clear_selected_nodes()
    app_state.hidden_nodes = []
  }
  app_state.markdown = markdown
  app_state.root = build_outline(markdown)
  if reset_ui {
    apply_detail_preset()
    app_state.root_split_count = default_root_split_count(app_state.root)
  } else {
    sanitize_collapsed_state()
    sanitize_hidden_state()
    sanitize_selected_state()
    if app_state.root_split_count <= 0 ||
      app_state.root_split_count > app_state.root.children.length() {
      app_state.root_split_count = default_root_split_count(app_state.root)
    }
  }
  if get_input_value() != markdown {
    set_input_value(markdown)
  }
  sync_detail_customized()
  render_ui()
}

///|
fn normalize_document_name(filename : String) -> String {
  let trimmed = filename.trim()
  if trimmed.length() == 0 {
    return "notes.md"
  }
  trimmed.to_string()
}

///|
fn current_document_name() -> String {
  app_state.document_name
}

///|
fn render_ui() -> Unit {
  set_select_value("layout-select", app_state.layout_mode)
  set_select_value("style-select", app_state.style_mode)
  set_editor_document_name(app_state.document_name)
  let detail_select_value = if app_state.detail_customized {
    "custom-\{app_state.detail_level}"
  } else {
    app_state.detail_level
  }
  set_select_value("detail-select", detail_select_value)
  set_select_muted("detail-select", app_state.detail_customized)
  let has_selection = has_selected_nodes()
  set_toolbar_selection_enabled(has_selection)
  if has_selection {
    set_toolbar_action_enabled("new-branch", can_toolbar_action("new-branch"))
    set_toolbar_action_enabled("new-child", can_toolbar_action("new-child"))
    set_toolbar_action_enabled("delete-node", can_toolbar_action("delete-node"))
    set_toolbar_action_enabled("edit-node", can_toolbar_action("edit-node"))
    set_toolbar_action_enabled("move-up", can_toolbar_action("move-up"))
    set_toolbar_action_enabled("move-down", can_toolbar_action("move-down"))
    set_toolbar_action_enabled("toggle-node", can_toolbar_action("toggle-node"))
    set_toolbar_action_enabled("insert-node", can_toolbar_action("insert-node"))
  }
  set_aux_action_enabled("undo-action", app_state.undo_stack.length() > 0)
  set_aux_action_enabled("redo-action", app_state.redo_stack.length() > 0)
  set_workspace_split(app_state.left_panel_percent)
  set_mindmap_dom(build_mindmap_dom())
  if app_state.editing_node >= 0 &&
    (app_state.editing_node == app_state.selected_node || !has_selected_nodes()) {
    focus_editor(app_state.editing_node)
  }
  let linked_lines = selected_markdown_lines()
  set_input_linked_lines(ints_to_csv(linked_lines))
  let primary_linked_line = selected_markdown_line()
  if app_state.reveal_selected_line && primary_linked_line >= 0 {
    reveal_input_line(primary_linked_line)
  }
  app_state.reveal_selected_line = false
}

///|
fn has_selected_nodes() -> Bool {
  app_state.selected_nodes.length() > 0
}

///|
fn is_selected_node(node_index : Int) -> Bool {
  contains_int(app_state.selected_nodes, node_index)
}

///|
fn is_single_selected_node(node_index : Int) -> Bool {
  app_state.selected_nodes.length() == 1 &&
  app_state.selected_node == node_index
}

///|
fn clear_selected_nodes() -> Unit {
  app_state.selected_node = -2
  app_state.selected_nodes = []
  app_state.selection_anchor_node = -2
  app_state.reveal_selected_line = false
}

///|
fn select_single_node(node_index : Int, reveal_line : Bool) -> Unit {
  apply_selected_nodes([node_index], reveal_line)
  app_state.selection_anchor_node = node_index
}

///|
fn toggle_node_selection(node_index : Int, reveal_line : Bool) -> Unit {
  if contains_int(app_state.selected_nodes, node_index) {
    let next = remove_int(app_state.selected_nodes, node_index)
    if next.length() == 0 {
      clear_selected_nodes()
      return
    }
    apply_selected_nodes(next, reveal_line)
    app_state.selection_anchor_node = node_index
  } else {
    let next = append_unique_int(app_state.selected_nodes, node_index)
    apply_selected_nodes(next, reveal_line)
    app_state.selection_anchor_node = node_index
  }
}

///|
fn select_node_range(node_index : Int, reveal_line : Bool) -> Unit {
  let anchor = if app_state.selection_anchor_node >= 0 {
    app_state.selection_anchor_node
  } else if app_state.selected_node >= 0 {
    app_state.selected_node
  } else {
    node_index
  }
  apply_selected_nodes(int_range(anchor, node_index), reveal_line)
}

///|
fn apply_selected_nodes(nodes : Array[Int], reveal_line : Bool) -> Unit {
  let next = unique_nonnegative_ints(nodes)
  if next.length() == 0 {
    clear_selected_nodes()
    return
  }
  app_state.selected_nodes = next
  app_state.selected_node = next[next.length() - 1]
  app_state.reveal_selected_line = reveal_line
}

///|
fn selected_markdown_line() -> Int {
  markdown_line_for_flat_index(app_state.markdown, app_state.selected_node)
}

///|
fn selected_markdown_lines() -> Array[Int] {
  let lines = []
  for node_index in app_state.selected_nodes {
    let line = markdown_line_for_flat_index(app_state.markdown, node_index)
    if line >= 0 && !contains_int(lines, line) {
      lines.push(line)
    }
  }
  lines
}

///|
fn ints_to_csv(values : Array[Int]) -> String {
  let items = []
  for value in values {
    items.push(value.to_string())
  }
  items.join(",")
}

///|
fn unique_nonnegative_ints(values : Array[Int]) -> Array[Int] {
  let next = []
  for value in values {
    if value >= 0 && !contains_int(next, value) {
      next.push(value)
    }
  }
  next
}

///|
fn append_unique_int(values : Array[Int], target : Int) -> Array[Int] {
  if contains_int(values, target) {
    return values
  }
  let next = copy_ints(values)
  next.push(target)
  next
}

///|
fn copy_ints(values : Array[Int]) -> Array[Int] {
  let next = []
  for value in values {
    next.push(value)
  }
  next
}

///|
fn int_range(start : Int, stop : Int) -> Array[Int] {
  let next = []
  if start <= stop {
    for value in start..<=stop {
      next.push(value)
    }
  } else {
    for value in stop..<=start {
      next.push(value)
    }
  }
  next
}

///|
fn same_int_set(left : Array[Int], right : Array[Int]) -> Bool {
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
fn markdown_line_for_flat_index(markdown : String, flat_index : Int) -> Int {
  if flat_index < 0 {
    return -1
  }
  let nodes = parse_markdown_nodes(markdown)
  let lines = markdown.split("\n").to_array()
  let mut node_index = 0
  for line_index in 0..<lines.length() {
    match parse_heading_line(lines[line_index]) {
      Some(_) => {
        if node_index < nodes.length() && node_index == flat_index {
          return line_index
        }
        node_index += 1
      }
      None =>
        match parse_list_line(lines[line_index]) {
          Some(_) => {
            if node_index < nodes.length() && node_index == flat_index {
              return line_index
            }
            node_index += 1
          }
          None => ()
        }
    }
  }
  -1
}

///|
fn can_toolbar_action(action : String) -> Bool {
  if app_state.selected_node < 0 {
    return false
  }
  match action {
    "new-branch" => can_add_sibling_selected()
    "new-child" => selected_node_exists()
    "delete-node" => selected_node_exists()
    "edit-node" => selected_node_exists()
    "move-up" => can_move_selected(false)
    "move-down" => can_move_selected(true)
    "toggle-node" => selected_has_children()
    "insert-node" => can_add_sibling_selected()
    _ => false
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
fn build_mindmap_dom() -> @dom.Element {
  let content = create_element("div", "mindmap-content")
  let stage_class = render_stage_class()
  let stage = match app_state.layout_mode {
    "vertical" => build_vertical_mindmap_dom(app_state.root, stage_class)
    "single-right" =>
      build_single_right_mindmap_dom(app_state.root, stage_class)
    _ => build_horizontal_mindmap_dom(app_state.root, stage_class)
  }
  append_child(content, stage)
  content
}

///|
fn build_horizontal_mindmap_dom(
  center : OutlineNode,
  stage_class : String,
) -> @dom.Element {
  let stage = create_element("div", "\{stage_class} mindmap-stage--radial")
  let left_column = create_element(
    "div", "branch-column branch-column--left branch-column--root",
  )
  let center_wrap = create_element("div", "center-wrap")
  let right_column = create_element(
    "div", "branch-column branch-column--right branch-column--root",
  )
  if should_render_children(center) {
    let left_count = root_branch_left_count(center)
    let left_total_weight = root_branch_total_span(center, 0, left_count)
    let right_total_weight = root_branch_total_span(
      center,
      left_count,
      center.children.length(),
    )
    let mut left_offset = 0
    let mut right_offset = 0
    for index in 0..<center.children.length() {
      let child = center.children[index]
      let tone_index = fill_tone_index(index)
      let child_weight = root_branch_span(child)
      if index < left_count {
        append_child(
          left_column,
          build_root_branch_node_dom(
            child,
            center.flat_index,
            "left",
            tone_index,
            left_offset,
            child_weight,
            left_total_weight,
          ),
        )
        left_offset += child_weight
      } else {
        append_child(
          right_column,
          build_root_branch_node_dom(
            child,
            center.flat_index,
            "right",
            tone_index,
            right_offset,
            child_weight,
            right_total_weight,
          ),
        )
        right_offset += child_weight
      }
    }
  }
  append_child(center_wrap, build_node_card_dom(center, -1, true, -1))
  append_child(stage, left_column)
  append_child(stage, center_wrap)
  append_child(stage, right_column)
  stage
}

///|
fn build_root_branch_node_dom(
  node : OutlineNode,
  parent_index : Int,
  direction : String,
  tone_index : Int,
  offset : Int,
  weight : Int,
  total_weight : Int,
) -> @dom.Element {
  let branch = create_element(
    "div",
    "branch-item branch-item--\{direction} branch-item--root",
  )
  branch.setAttribute("data-node-index", node.flat_index.to_string())
  branch.setAttribute("data-parent-index", parent_index.to_string())
  apply_node_visual_attrs(branch, node, tone_index)
  apply_root_weight_style(branch, offset, weight, total_weight)
  append_child(
    branch,
    build_drop_slot_dom(node.flat_index, parent_index, "before"),
  )
  append_child(
    branch,
    build_branch_row_dom(node, parent_index, false, direction, tone_index),
  )
  append_child(
    branch,
    build_drop_slot_dom(node.flat_index, parent_index, "after"),
  )
  branch
}

///|
fn build_branch_row_dom(
  node : OutlineNode,
  parent_index : Int,
  is_root : Bool,
  direction : String,
  tone_index : Int,
) -> @dom.Element {
  let row = create_element("div", "branch-item__row")
  let head = create_element("div", "branch-item__head")
  let card = build_node_card_dom(node, parent_index, is_root, tone_index)
  if direction == "left" {
    append_child(row, build_branch_children_dom(node, direction, tone_index))
    append_child(head, card)
    append_child(row, head)
  } else {
    append_child(head, card)
    append_child(row, head)
    append_child(row, build_branch_children_dom(node, direction, tone_index))
  }
  row
}

///|
fn build_branch_node_dom(
  node : OutlineNode,
  parent_index : Int,
  direction : String,
  tone_index : Int,
) -> @dom.Element {
  let branch = create_element("div", "branch-item branch-item--\{direction}")
  branch.setAttribute("data-node-index", node.flat_index.to_string())
  branch.setAttribute("data-parent-index", parent_index.to_string())
  apply_node_visual_attrs(branch, node, tone_index)
  append_child(
    branch,
    build_drop_slot_dom(node.flat_index, parent_index, "before"),
  )
  append_child(
    branch,
    build_branch_row_dom(node, parent_index, false, direction, tone_index),
  )
  append_child(
    branch,
    build_drop_slot_dom(node.flat_index, parent_index, "after"),
  )
  branch
}

///|
fn build_hidden_branch_node_dom(
  node : OutlineNode,
  direction : String,
  tone_index : Int,
) -> @dom.Element {
  let branch = create_element(
    "div",
    "branch-item branch-item--\{direction} branch-item--hidden",
  )
  branch.setAttribute("data-node-index", node.flat_index.to_string())
  branch.setAttribute("data-parent-index", "-1")
  apply_node_visual_attrs(branch, node, tone_index)
  let row = create_element("div", "branch-item__row")
  let head = create_element("div", "branch-item__head")
  append_child(head, build_hidden_marker_dom(node, tone_index))
  append_child(row, head)
  append_child(branch, row)
  branch
}

///|
fn build_branch_children_dom(
  node : OutlineNode,
  direction : String,
  tone_index : Int,
) -> @dom.Element {
  let children = create_element(
    "div",
    "branch-children branch-children--\{direction}",
  )
  apply_node_visual_attrs(children, node, tone_index)
  if !should_render_children(node) {
    return children
  }
  for child in node.children {
    if is_hidden_node(child.flat_index) {
      append_child(
        children,
        build_hidden_branch_node_dom(child, direction, tone_index),
      )
    } else {
      append_child(
        children,
        build_branch_node_dom(child, node.flat_index, direction, tone_index),
      )
    }
  }
  children
}

///|
fn build_vertical_mindmap_dom(
  center : OutlineNode,
  stage_class : String,
) -> @dom.Element {
  let stage = create_element("div", "\{stage_class} mindmap-stage--vertical")
  let root = create_element("div", "vertical-root")
  append_child(root, build_vertical_tree_dom(center, -1, true, -1))
  append_child(stage, root)
  stage
}

///|
fn build_vertical_tree_dom(
  node : OutlineNode,
  parent_index : Int,
  is_root : Bool,
  tone_index : Int,
) -> @dom.Element {
  let tree = create_element("div", "vertical-tree")
  tree.setAttribute("data-node-index", node.flat_index.to_string())
  tree.setAttribute("data-parent-index", parent_index.to_string())
  append_child(
    tree,
    build_drop_slot_dom(node.flat_index, parent_index, "before"),
  )
  append_child(
    tree,
    build_node_card_dom(node, parent_index, is_root, tone_index),
  )
  append_child(
    tree,
    build_drop_slot_dom(node.flat_index, parent_index, "after"),
  )
  append_child(tree, build_vertical_children_dom(node, tone_index))
  tree
}

///|
fn build_vertical_children_dom(
  node : OutlineNode,
  tone_index : Int,
) -> @dom.Element {
  let children = create_element("div", "vertical-tree__children")
  let child_tone = if relative_node_depth(node) == 0 { -1 } else { tone_index }
  apply_node_visual_attrs(children, node, child_tone)
  if !should_render_children(node) {
    return children
  }
  for index in 0..<node.children.length() {
    let child = node.children[index]
    let next_tone = if relative_node_depth(node) == 0 {
      fill_tone_index(index)
    } else {
      tone_index
    }
    let child_wrap = create_element("div", "vertical-tree__child")
    apply_node_visual_attrs(child_wrap, child, next_tone)
    append_child(
      child_wrap,
      build_vertical_tree_dom(child, node.flat_index, false, next_tone),
    )
    append_child(children, child_wrap)
  }
  children
}

///|
fn build_single_right_mindmap_dom(
  center : OutlineNode,
  stage_class : String,
) -> @dom.Element {
  let stage = create_element(
    "div",
    "\{stage_class} mindmap-stage--single-right",
  )
  let tree = create_element("div", "single-right-tree")
  append_child(tree, build_single_right_tree_dom(center, -1, true, -1))
  append_child(stage, tree)
  stage
}

///|
fn build_single_right_tree_dom(
  node : OutlineNode,
  parent_index : Int,
  is_root : Bool,
  tone_index : Int,
) -> @dom.Element {
  let tree = create_element("div", "single-right-tree__node")
  tree.setAttribute("data-node-index", node.flat_index.to_string())
  tree.setAttribute("data-parent-index", parent_index.to_string())
  apply_node_visual_attrs(tree, node, tone_index)
  append_child(
    tree,
    build_drop_slot_dom(node.flat_index, parent_index, "before"),
  )
  let head = create_element("div", "single-right-tree__head")
  append_child(
    head,
    build_node_card_dom(node, parent_index, is_root, tone_index),
  )
  append_child(tree, head)
  append_child(
    tree,
    build_drop_slot_dom(node.flat_index, parent_index, "after"),
  )
  append_child(tree, build_single_right_children_dom(node, tone_index))
  tree
}

///|
fn build_single_right_children_dom(
  node : OutlineNode,
  tone_index : Int,
) -> @dom.Element {
  let children = create_element("div", "single-right-tree__children")
  let wrapper_tone = if relative_node_depth(node) == 0 {
    -1
  } else {
    tone_index
  }
  apply_node_visual_attrs(children, node, wrapper_tone)
  if !should_render_children(node) {
    return children
  }
  for index in 0..<node.children.length() {
    let child = node.children[index]
    let next_tone = if relative_node_depth(node) == 0 {
      fill_tone_index(index)
    } else {
      tone_index
    }
    append_child(
      children,
      build_single_right_tree_dom(child, node.flat_index, false, next_tone),
    )
  }
  children
}

///|
fn build_node_card_dom(
  node : OutlineNode,
  parent_index : Int,
  is_center : Bool,
  tone_index : Int,
) -> @dom.Element {
  let has_children = node.children.length() > 0
  let editable = !node.synthetic
  let is_editing = app_state.editing_node == node.flat_index
  let is_draggable = editable && !is_center && !is_editing
  let classes = ["node"]
  if is_center {
    classes.push("node--center")
  }
  if is_selected_node(node.flat_index) {
    classes.push("is-selected")
  }
  classes.push(render_node_style_class())
  if is_draggable {
    classes.push("is-draggable")
  }
  let card = create_element("div", classes.iter().join(" "))
  card.setAttribute("data-level", node.level.to_string())
  card.setAttribute("data-node-index", node.flat_index.to_string())
  card.setAttribute("data-parent-index", parent_index.to_string())
  apply_node_visual_attrs(card, node, tone_index)
  apply_drag_attrs(card, node, parent_index, is_draggable)
  append_child(card, build_text_span("small", "", "Level \{node.level}"))
  append_child(card, build_node_title_dom(node, is_editing))
  if has_children && !is_center {
    match build_node_actions_dom(node, editable, is_center) {
      Some(actions) => append_child(card, actions)
      None => ()
    }
  }
  card
}

///|
fn build_node_title_dom(node : OutlineNode, is_editing : Bool) -> @dom.Element {
  if is_editing {
    let input = create_element("input", "node-editor")
    input.setAttribute("data-editor-for", node.flat_index.to_string())
    input.setAttribute("type", "text")
    @dom.HTMLInputElement::cast_from_element(input).value = node.title
    input
  } else {
    let title = create_element("strong", "")
    title.setTextContent(node.title)
    title
  }
}

///|
fn build_node_actions_dom(
  node : OutlineNode,
  editable : Bool,
  is_center : Bool,
) -> @dom.Element? {
  let _ = editable
  if is_center || node.children.length() == 0 {
    return None
  }
  let collapsed = is_collapsed(node.flat_index)
  let hidden_count = count_hidden_descendants(node)
  let label = if collapsed { hidden_count.to_string() } else { "" }
  let title = if collapsed {
    "Expand node (\{hidden_count} hidden)"
  } else {
    "Collapse node"
  }
  let expanded = (!collapsed).to_string()
  let state_class = if collapsed { " node-action--collapsed" } else { "" }
  let actions = create_element("div", "node-actions")
  let button = create_element(
    "button",
    "node-action node-action--toggle\{state_class}",
  )
  button.setAttribute("type", "button")
  button.setAttribute("data-action", "toggle")
  button.setAttribute("title", title)
  button.setAttribute("aria-label", title)
  button.setAttribute("aria-expanded", expanded)
  button.setTextContent(label)
  append_child(actions, button)
  Some(actions)
}

///|
fn build_hidden_marker_dom(
  node : OutlineNode,
  tone_index : Int,
) -> @dom.Element {
  let marker = create_element("button", "node collapsed-node")
  marker.setAttribute("type", "button")
  marker.setAttribute("data-action", "toggle-hide")
  marker.setAttribute("data-node-index", node.flat_index.to_string())
  apply_node_visual_attrs(marker, node, tone_index)
  marker.setTextContent(count_subtree_nodes(node).to_string())
  marker
}

///|
fn build_drop_slot_dom(
  node_index : Int,
  parent_index : Int,
  position : String,
) -> @dom.Element {
  let slot = create_element("div", "drop-slot")
  slot.setAttribute("data-drop-target", node_index.to_string())
  slot.setAttribute("data-drop-parent", parent_index.to_string())
  slot.setAttribute("data-drop-position", position)
  slot
}

///|
fn apply_node_visual_attrs(
  element : @dom.Element,
  node : OutlineNode,
  tone_index : Int,
) -> Unit {
  element.setAttribute("data-depth", relative_node_depth(node).to_string())
  element.setAttribute("data-tone", tone_index.to_string())
  element.setAttribute(
    "data-has-children",
    (node.children.length() > 0).to_string(),
  )
  element.setAttribute("data-child-count", node.children.length().to_string())
  element.setAttribute(
    "data-collapsed",
    is_collapsed(node.flat_index).to_string(),
  )
  element.setAttribute(
    "data-hidden-count",
    count_subtree_nodes(node).to_string(),
  )
  element.setAttribute(
    "data-hidden-node",
    is_hidden_node(node.flat_index).to_string(),
  )
}

///|
fn apply_drag_attrs(
  element : @dom.Element,
  node : OutlineNode,
  parent_index : Int,
  is_draggable : Bool,
) -> Unit {
  if !is_draggable {
    return
  }
  element.setAttribute("draggable", "true")
  element.setAttribute("data-drag-index", node.flat_index.to_string())
  element.setAttribute("data-drag-parent", parent_index.to_string())
}

///|
fn apply_root_weight_style(
  element : @dom.Element,
  offset : Int,
  weight : Int,
  total_weight : Int,
) -> Unit {
  let safe_total = if total_weight > 0 { total_weight } else { 1 }
  let safe_weight = if weight > 0 { weight } else { 1 }
  let center_bp = (offset * 1000 + safe_weight * 500) / safe_total
  let whole = center_bp / 10
  let frac = center_bp % 10
  let style = @dom.css_style_from_val(element.as_any()._get("style").cast())
  style.set_property("top", "\{whole}.\{frac}%")
}

///|
fn root_branch_left_count(center : OutlineNode) -> Int {
  let child_count = center.children.length()
  if child_count == 0 {
    return 0
  }
  let split_count = clamp_int(app_state.root_split_count, 0, child_count)
  if split_count == 0 {
    return default_root_split_count(center)
  }
  split_count
}

///|
fn root_branch_total_span(center : OutlineNode, start : Int, stop : Int) -> Int {
  let mut total = 0
  for index in start..<stop {
    total += root_branch_span(center.children[index])
  }
  if total <= 0 {
    1
  } else {
    total
  }
}

///|
fn root_branch_span(node : OutlineNode) -> Int {
  count_subtree_nodes(node) * 2 + node.children.length() * 6 + 10
}

///|
fn clamp_int(value : Int, min_value : Int, max_value : Int) -> Int {
  if value < min_value {
    return min_value
  }
  if value > max_value {
    return max_value
  }
  value
}

///|
fn render_branch_node(
  node : OutlineNode,
  parent_index : Int,
  direction : String,
  tone_index : Int,
) -> String {
  let before_slot = render_drop_slot(node.flat_index, parent_index, "before")
  let card = render_node_card(node, parent_index, false, tone_index)
  let after_slot = render_drop_slot(node.flat_index, parent_index, "after")
  let children_html = render_branch_children(node, direction, tone_index)
  let branch_attrs = render_node_visual_attrs(node, tone_index)
  let row_html = if direction == "left" {
    "<div class=\"branch-item__row\">\{children_html}<div class=\"branch-item__head\">\{card}</div></div>"
  } else {
    "<div class=\"branch-item__row\"><div class=\"branch-item__head\">\{card}</div>\{children_html}</div>"
  }
  "<div class=\"branch-item branch-item--\{direction}\" data-node-index=\"\{node.flat_index}\" data-parent-index=\"\{parent_index}\"\{branch_attrs}>\{before_slot}\{row_html}\{after_slot}</div>"
}

///|
fn render_branch_children(
  node : OutlineNode,
  direction : String,
  tone_index : Int,
) -> String {
  if !should_render_children(node) {
    return ""
  }
  let child_parts = []
  for child in node.children {
    if is_hidden_node(child.flat_index) {
      child_parts.push(render_hidden_branch_node(child, direction, tone_index))
    } else {
      child_parts.push(
        render_branch_node(child, node.flat_index, direction, tone_index),
      )
    }
  }
  let body = child_parts.join("")
  let branch_attrs = render_node_visual_attrs(node, tone_index)
  "<div class=\"branch-children branch-children--\{direction}\"\{branch_attrs}>\{body}</div>"
}

///|
fn render_hidden_branch_node(
  node : OutlineNode,
  direction : String,
  tone_index : Int,
) -> String {
  let marker = render_hidden_marker(node, tone_index)
  let attrs = render_node_visual_attrs(node, tone_index)
  let row_html = "<div class=\"branch-item__row\"><div class=\"branch-item__head\">\{marker}</div></div>"
  "<div class=\"branch-item branch-item--\{direction} branch-item--hidden\" data-node-index=\"\{node.flat_index}\" data-parent-index=\"-1\"\{attrs}>\{row_html}</div>"
}

///|
fn render_vertical_tree(
  node : OutlineNode,
  parent_index : Int,
  is_root : Bool,
  tone_index : Int,
) -> String {
  let before_slot = render_drop_slot(node.flat_index, parent_index, "before")
  let card = render_node_card(node, parent_index, is_root, tone_index)
  let after_slot = render_drop_slot(node.flat_index, parent_index, "after")
  let children_html = render_vertical_children(node, tone_index)
  "<div class=\"vertical-tree\" data-node-index=\"\{node.flat_index}\" data-parent-index=\"\{parent_index}\">\{before_slot}\{card}\{after_slot}\{children_html}</div>"
}

///|
fn render_vertical_children(node : OutlineNode, tone_index : Int) -> String {
  if !should_render_children(node) {
    return ""
  }
  let child_parts = []
  let child_tone = if relative_node_depth(node) == 0 { -1 } else { tone_index }
  let wrapper_attrs = render_node_visual_attrs(node, child_tone)
  for index in 0..<node.children.length() {
    let child = node.children[index]
    let next_tone = if relative_node_depth(node) == 0 {
      fill_tone_index(index)
    } else {
      tone_index
    }
    let child_html = render_vertical_tree(
      child,
      node.flat_index,
      false,
      next_tone,
    )
    let child_attrs = render_node_visual_attrs(child, next_tone)
    child_parts.push(
      "<div class=\"vertical-tree__child\"\{child_attrs}>\{child_html}</div>",
    )
  }
  let body = child_parts.join("")
  "<div class=\"vertical-tree__children\"\{wrapper_attrs}>\{body}</div>"
}

///|
fn render_single_right_tree(
  node : OutlineNode,
  parent_index : Int,
  is_root : Bool,
  tone_index : Int,
) -> String {
  let before_slot = render_drop_slot(node.flat_index, parent_index, "before")
  let card = render_node_card(node, parent_index, is_root, tone_index)
  let after_slot = render_drop_slot(node.flat_index, parent_index, "after")
  let children_html = render_single_right_children(node, tone_index)
  let node_attrs = render_node_visual_attrs(node, tone_index)
  "<div class=\"single-right-tree__node\" data-node-index=\"\{node.flat_index}\" data-parent-index=\"\{parent_index}\"\{node_attrs}>\{before_slot}<div class=\"single-right-tree__head\">\{card}</div>\{after_slot}\{children_html}</div>"
}

///|
fn render_single_right_children(node : OutlineNode, tone_index : Int) -> String {
  if !should_render_children(node) {
    return ""
  }
  let child_parts = []
  let wrapper_tone = if relative_node_depth(node) == 0 {
    -1
  } else {
    tone_index
  }
  let wrapper_attrs = render_node_visual_attrs(node, wrapper_tone)
  for index in 0..<node.children.length() {
    let child = node.children[index]
    let next_tone = if relative_node_depth(node) == 0 {
      fill_tone_index(index)
    } else {
      tone_index
    }
    child_parts.push(
      render_single_right_tree(child, node.flat_index, false, next_tone),
    )
  }
  let body = child_parts.join("")
  "<div class=\"single-right-tree__children\"\{wrapper_attrs}>\{body}</div>"
}

///|
fn render_node_card(
  node : OutlineNode,
  parent_index : Int,
  is_center : Bool,
  tone_index : Int,
) -> String {
  let has_children = node.children.length() > 0
  let editable = !node.synthetic
  let is_editing = app_state.editing_node == node.flat_index
  let is_draggable = editable && !is_center && !is_editing
  let classes = ["node"]
  if is_center {
    classes.push("node--center")
  }
  if is_selected_node(node.flat_index) {
    classes.push("is-selected")
  }
  classes.push(render_node_style_class())
  if is_draggable {
    classes.push("is-draggable")
  }
  let class_name = classes.join(" ")
  let title_html = render_node_title(node, is_editing)
  let action_html = render_node_actions(node, has_children, editable, is_center)
  let drag_attrs = render_drag_attrs(node, parent_index, is_draggable)
  let visual_attrs = render_node_visual_attrs(node, tone_index)
  "<div class=\"\{class_name}\" data-level=\"\{node.level}\" data-node-index=\"\{node.flat_index}\" data-parent-index=\"\{parent_index}\"\{visual_attrs}\{drag_attrs}><small>Level \{node.level}</small>\{title_html}\{action_html}</div>"
}

///|
fn render_node_visual_attrs(node : OutlineNode, tone_index : Int) -> String {
  let has_children = node.children.length() > 0
  let child_count = node.children.length()
  let collapsed = is_collapsed(node.flat_index)
  let hidden_count = count_subtree_nodes(node)
  let hidden_node = is_hidden_node(node.flat_index)
  " data-depth=\"\{relative_node_depth(node)}\" data-tone=\"\{tone_index}\" data-has-children=\"\{has_children}\" data-child-count=\"\{child_count}\" data-collapsed=\"\{collapsed}\" data-hidden-count=\"\{hidden_count}\" data-hidden-node=\"\{hidden_node}\""
}

///|
fn render_hidden_marker(node : OutlineNode, tone_index : Int) -> String {
  let attrs = render_node_visual_attrs(node, tone_index)
  let count = count_subtree_nodes(node)
  "<button type=\"button\" class=\"node collapsed-node\" data-action=\"toggle-hide\" data-node-index=\"\{node.flat_index}\"\{attrs}>\{count}</button>"
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
fn render_node_title(node : OutlineNode, is_editing : Bool) -> String {
  if is_editing {
    let value = escape_html_attribute(node.title)
    return "<input class=\"node-editor\" data-editor-for=\"\{node.flat_index}\" type=\"text\" value=\"\{value}\" />"
  }
  let title = escape_html(node.title)
  "<strong>\{title}</strong>"
}

///|
fn render_node_actions(
  node : OutlineNode,
  has_children : Bool,
  editable : Bool,
  is_center : Bool,
) -> String {
  let _ = editable
  if !has_children || is_center {
    return ""
  }
  let collapsed = is_collapsed(node.flat_index)
  let hidden_count = count_hidden_descendants(node)
  let label = if collapsed { hidden_count.to_string() } else { "" }
  let title = if collapsed {
    "Expand node (\{hidden_count} hidden)"
  } else {
    "Collapse node"
  }
  let expanded = (!collapsed).to_string()
  let state_class = if collapsed { " node-action--collapsed" } else { "" }
  "<div class=\"node-actions\"><button type=\"button\" class=\"node-action node-action--toggle\{state_class}\" data-action=\"toggle\" title=\"\{title}\" aria-label=\"\{title}\" aria-expanded=\"\{expanded}\">\{label}</button></div>"
}

///|
fn count_hidden_descendants(node : OutlineNode) -> Int {
  let mut count = 0
  for child in node.children {
    count += 1 + count_hidden_descendants(child)
  }
  count
}

///|
fn count_subtree_nodes(node : OutlineNode) -> Int {
  1 + count_hidden_descendants(node)
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
fn toggle_hidden_node(node_index : Int) -> Unit {
  if node_index < 0 {
    return
  }
  if is_hidden_node(node_index) {
    app_state.hidden_nodes = remove_int(app_state.hidden_nodes, node_index)
  } else {
    app_state.hidden_nodes.push(node_index)
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
fn is_hidden_node(node_index : Int) -> Bool {
  contains_int(app_state.hidden_nodes, node_index)
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
fn relative_node_depth(node : OutlineNode) -> Int {
  node.level - app_state.root.level
}

///|
fn fill_tone_index(index : Int) -> Int {
  index % 5
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
fn sanitize_hidden_state() -> Unit {
  let next = []
  for node_index in app_state.hidden_nodes {
    match find_node(app_state.root, node_index) {
      Some(node) => if !node.synthetic { next.push(node_index) }
      None => ()
    }
  }
  app_state.hidden_nodes = next
}

///|
fn sanitize_selected_state() -> Unit {
  if app_state.selected_nodes.length() == 0 {
    app_state.selected_node = -2
    app_state.selection_anchor_node = -2
    return
  }
  let next = []
  for node_index in app_state.selected_nodes {
    match find_node(app_state.root, node_index) {
      Some(_) => next.push(node_index)
      None => ()
    }
  }
  app_state.selected_nodes = next
  if next.length() == 0 {
    app_state.selected_node = -2
    app_state.selection_anchor_node = -2
  } else {
    if !contains_int(next, app_state.selected_node) {
      app_state.selected_node = next[next.length() - 1]
    }
    if !contains_int(next, app_state.selection_anchor_node) {
      app_state.selection_anchor_node = app_state.selected_node
    }
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
fn slice_strings(
  values : Array[String],
  start : Int,
  end_ : Int,
) -> Array[String] {
  let sliced = []
  for index in start..<end_ {
    sliced.push(values[index])
  }
  sliced
}

///|
fn normalize_split_percent(percent : Int) -> Int {
  if percent < 18 {
    18
  } else if percent > 82 {
    82
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

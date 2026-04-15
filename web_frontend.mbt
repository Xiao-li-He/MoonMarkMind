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
  mut editing_note_node : Int
  mut layout_mode : String
  mut style_mode : String
  mut detail_level : String
  mut detail_customized : Bool
  mut left_panel_percent : Int
  mut root_split_count : Int
  mut reveal_selected_line : Bool
  mut drag_source_index : Int
  mut drag_source_parent : Int
  mut sample_variant : String
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
  editing_note_node: -2,
  layout_mode: "logic",
  style_mode: "line",
  detail_level: "all",
  detail_customized: false,
  left_panel_percent: 33,
  root_split_count: 0,
  reveal_selected_line: false,
  drag_source_index: -1,
  drag_source_parent: -2,
  sample_variant: rules_sample_default_id(),
}

///|
let canceled_editor_node : @ref.Ref[Int] = @ref.Ref(-1)

///|
let canceled_note_editor_node : @ref.Ref[Int] = @ref.Ref(-1)

///|
let editor_snapshot_node : @ref.Ref[Int] = @ref.Ref(-1)

///|
let editor_snapshot_markdown : @ref.Ref[String] = @ref.Ref("")

///|
let editor_draft_markdown : @ref.Ref[String] = @ref.Ref("")

///|
let editor_undo_stack : @ref.Ref[Array[String]] = @ref.Ref([])

///|
let editor_redo_stack : @ref.Ref[Array[String]] = @ref.Ref([])

///|
let note_editor_snapshot_node : @ref.Ref[Int] = @ref.Ref(-1)

///|
let note_editor_snapshot_markdown : @ref.Ref[String] = @ref.Ref("")

///|
let note_editor_draft_markdown : @ref.Ref[String] = @ref.Ref("")

///|
pub fn start_web_app() -> Unit {
  match get_element("#mindmap-export") {
    Some(export_root) => {
      bind_export_mindmap_ui(export_root)
      return
    }
    None => ()
  }
  if app_state.started {
    render_ui()
    return
  }
  app_state.started = true
  mount_app_shell()
  bind_static_ui(
    on_new_click, on_sample_select_change, on_upload_click, on_download_markdown_click,
    on_layout_change, on_style_change, on_detail_change, on_export_change, on_toolbar_action,
  )
  bind_tooltip_ui()
  bind_splitter_ui(on_splitter_change)
  bind_mindmap_ui(
    on_mindmap_click, on_mindmap_dblclick, on_mindmap_keydown, on_mindmap_focusout,
    on_mindmap_editor_input, on_mindmap_dragstart, on_mindmap_dragend, on_mindmap_dragover,
    on_mindmap_drop,
  )
  bind_input_listener(on_input_change, on_input_selected_headings_change)
  load_rules_sample(rules_sample_default_id(), true)
}

///|
fn on_new_click() -> Unit {
  reset_history()
  app_state.document_name = "notes.md"
  app_state.sample_variant = "custom"
  load_markdown("", true)
}

///|
fn on_sample_select_change(sample_variant : String) -> Unit {
  load_rules_sample(sample_variant, true)
}

///|
fn on_upload_click() -> Unit {
  pick_markdown_file(on_upload_loaded)
}

///|
fn on_upload_loaded(filename : String, markdown : String) -> Unit {
  reset_history()
  app_state.document_name = normalize_document_name(filename)
  app_state.sample_variant = "custom"
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
  sync_selection_ui()
}

///|
fn on_layout_change(mode : String) -> Unit {
  app_state.layout_mode = normalize_layout_mode(mode)
  render_ui()
  schedule_mindmap_recenter_current_view()
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
  if event_editor_index_from_target(event.target()) >= 0 ||
    event_note_editor_index_from_target(event.target()) >= 0 {
    return
  }
  if is_blank_mindmap_click_target(event.target()) {
    if has_selected_nodes() {
      clear_editing_session()
      app_state.editing_node = -2
      clear_selected_nodes()
      sync_selection_ui()
    }
    focus_mindmap()
    return
  }
  let action = event_action_from_point(event)
  let node_index = event_node_index_from_point(event)
  if action == "" && node_index >= 0 {
    if event_click_count(event) >= 2 &&
      !event_shift_key(event) &&
      !event_multi_select_key(event) {
      match find_node(app_state.root, node_index) {
        Some(node) => if node.synthetic { return }
        None => return
      }
      event.stopPropagation()
      select_single_node(node_index, true)
      begin_edit_node(node_index)
      return
    }
    clear_editing_session()
    app_state.editing_node = -2
    if event_shift_key(event) {
      select_node_range(node_index, true)
    } else if event_multi_select_key(event) {
      toggle_node_selection(node_index, true)
    } else if !is_single_selected_node(node_index) {
      select_single_node(node_index, true)
    }
    focus_mindmap()
    sync_selection_ui()
    return
  }
  let cleared_selection = action == "" && has_selected_nodes()
  if cleared_selection {
    clear_editing_session()
    app_state.editing_node = -2
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
      focus_mindmap()
      render_ui()
    }
    "toggle-hide" => {
      event.stopPropagation()
      toggle_hidden_node(node_index)
      focus_mindmap()
      render_ui()
    }
    "toggle-note" => {
      event.stopPropagation()
      toggle_note_editor(node_index)
    }
    _ =>
      if cleared_selection {
        focus_mindmap()
        sync_selection_ui()
      }
  }
}

///|
fn is_blank_mindmap_click_target(target : @dom.Element) -> Bool {
  match target.closest(".mindmap, .mindmap-content, .mindmap-stage") {
    Some(_) =>
      target.closest(
        "[data-node-index], [data-action], [data-editor-for], [data-note-editor-for], [data-drop-target], [data-drop-parent]",
      )
      is None
    None => false
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
    "indent-node" => handle_relevel_selected(true)
    "promote-node" => handle_relevel_selected(false)
    "toggle-node" => {
      toggle_collapsed(app_state.selected_node)
      sync_detail_customized()
      render_ui()
    }
    "insert-note" => handle_insert_note()
    "insert-link" => insert_node_body_template("link")
    "insert-image" => insert_node_body_template("image")
    "insert-formula" => insert_node_body_template("formula")
    "insert-code" => insert_node_body_template("code")
    "insert-table" => insert_node_body_template("table")
    _ => ()
  }
}

///|
fn on_mindmap_dblclick(event : @dom.MouseEvent) -> Unit {
  let node_index = event_node_index_from_point(event)
  if node_index < 0 {
    event.stopPropagation()
    return
  }
  let target = event.target()
  if event_note_preview_from_target(target) {
    match target.closest("a") {
      Some(_) => ()
      None => {
        event.stopPropagation()
        select_single_node(node_index, true)
        begin_note_edit_node(node_index)
      }
    }
    return
  }
  match find_node(app_state.root, node_index) {
    Some(node) => {
      if node.synthetic {
        event.stopPropagation()
        return
      }
      event.stopPropagation()
      select_single_node(node_index, true)
      begin_edit_node(node_index)
    }
    None => event.stopPropagation()
  }
}

///|
fn on_mindmap_keydown(event : @dom.KeyboardEvent) -> Unit {
  let note_editor_index = event_note_editor_index_from_target(event.target())
  if note_editor_index >= 0 {
    let command_key = event.ctrlKey || event.metaKey
    if command_key &&
      (event_key(event) == "Enter" || event_key(event) == "enter") {
      event.preventDefault()
      save_note_editor(
        note_editor_index,
        event_note_editor_value_from_target(event.target()),
      )
    } else if event_key(event) == "Escape" {
      event.preventDefault()
      canceled_note_editor_node.val = note_editor_index
      cancel_note_editor(note_editor_index)
    }
    return
  }
  let editor_index = event_editor_index_from_target(event.target())
  if editor_index >= 0 {
    let command_key = event.ctrlKey || event.metaKey
    if command_key &&
      !event.shiftKey &&
      (event_key(event) == "z" || event_key(event) == "Z") {
      event.preventDefault()
      editor_undo(editor_index)
    } else if command_key &&
      (event_key(event) == "y" || event_key(event) == "Y") {
      event.preventDefault()
      editor_redo(editor_index)
    } else {
      match event_key(event) {
        "Enter" => {
          event.preventDefault()
          save_editor(
            editor_index,
            event_editor_value_from_target(event.target()),
          )
        }
        "Escape" => {
          canceled_editor_node.val = editor_index
          cancel_editor(editor_index)
        }
        _ => ()
      }
    }
    return
  }
  let node_index = event_keyboard_node_index(event)
  let target_node_index = if app_state.selected_node >= 0 {
    app_state.selected_node
  } else {
    node_index
  }
  let command_key = event.ctrlKey || event.metaKey
  if command_key &&
    !event.shiftKey &&
    (event_key(event) == "z" || event_key(event) == "Z") {
    event.preventDefault()
    event.stopPropagation()
    handle_undo()
    return
  }
  if command_key && (event_key(event) == "y" || event_key(event) == "Y") {
    event.preventDefault()
    event.stopPropagation()
    handle_redo()
    return
  }
  if target_node_index < 0 {
    return
  }
  match event_key(event) {
    "ArrowLeft" => {
      event.preventDefault()
      event.stopPropagation()
      if handle_tree_navigation("ArrowLeft", target_node_index) {
        render_ui()
      }
    }
    "ArrowRight" => {
      event.preventDefault()
      event.stopPropagation()
      if handle_tree_navigation("ArrowRight", target_node_index) {
        render_ui()
      }
    }
    "ArrowUp" => {
      event.preventDefault()
      event.stopPropagation()
      if handle_tree_navigation("ArrowUp", target_node_index) {
        render_ui()
      }
    }
    "ArrowDown" => {
      event.preventDefault()
      event.stopPropagation()
      if handle_tree_navigation("ArrowDown", target_node_index) {
        render_ui()
      }
    }
    "Enter" => {
      event.preventDefault()
      event.stopPropagation()
      if can_add_sibling_selected() {
        handle_add_sibling(target_node_index, true)
      }
    }
    "Tab" => {
      event.preventDefault()
      event.stopPropagation()
      if event.shiftKey {
        handle_relevel_selected(false)
      } else {
        handle_add_child(target_node_index)
      }
    }
    "Delete" => {
      event.preventDefault()
      event.stopPropagation()
      handle_delete(target_node_index)
    }
    _ => ()
  }
}

///|
fn on_mindmap_focusout(event : @dom.FocusEvent) -> Unit {
  let note_editor_index = event_note_editor_index_from_target(event.target())
  if note_editor_index >= 0 {
    if canceled_note_editor_node.val == note_editor_index {
      canceled_note_editor_node.val = -1
      return
    }
    save_note_editor(
      note_editor_index,
      event_note_editor_value_from_target(event.target()),
    )
    return
  }
  let node_index = event_editor_index_from_target(event.target())
  if node_index < 0 {
    return
  }
  if canceled_editor_node.val == node_index {
    canceled_editor_node.val = -1
    return
  }
  save_editor(node_index, event_editor_value_from_target(event.target()))
}

///|
fn on_mindmap_editor_input(event : @dom.Event) -> Unit {
  let note_editor_index = event_note_editor_index_from_target(event.target())
  if note_editor_index >= 0 {
    sync_note_editor_draft(
      note_editor_index,
      event_note_editor_value_from_target(event.target()),
    )
    return
  }
  let node_index = event_editor_index_from_target(event.target())
  if node_index < 0 {
    return
  }
  sync_editor_draft(node_index, event_editor_value_from_target(event.target()))
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
  let (next_markdown, target_index) = if should_balance_first_layer_insert(
      node_index,
    ) {
    add_balanced_first_layer_heading(title)
  } else {
    (
      add_child_heading(app_state.markdown, node_index, title),
      target_index_after_add_child(node_index),
    )
  }
  apply_markdown_change(next_markdown, false)
  expand_node(node_index)
  if target_index >= 0 {
    select_single_node(target_index, false)
    begin_edit_node(target_index)
    return
  }
  sync_detail_customized()
  render_ui()
}

///|
fn handle_add_sibling(node_index : Int, place_after : Bool) -> Unit {
  let title = "New node"
  if should_balance_first_layer_sibling_insert(node_index) {
    let (next_markdown, target_index) = add_balanced_first_layer_heading(title)
    apply_markdown_change(next_markdown, false)
    if target_index >= 0 {
      select_single_node(target_index, false)
      begin_edit_node(target_index)
      return
    }
    render_ui()
    return
  }
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
    begin_edit_node(target_index)
    return
  }
  render_ui()
}

///|
fn should_balance_first_layer_insert(node_index : Int) -> Bool {
  app_state.layout_mode == "mindmap" &&
  !app_state.root.synthetic &&
  node_index == app_state.root.flat_index
}

///|
fn should_balance_first_layer_sibling_insert(node_index : Int) -> Bool {
  app_state.layout_mode == "mindmap" && root_child_index(node_index) >= 0
}

///|
fn add_balanced_first_layer_heading(title : String) -> (String, Int) {
  let child_count = app_state.root.children.length()
  let split = root_branch_left_count(app_state.root)
  let left_total = root_branch_total_span(app_state.root, 0, split)
  let right_total = root_branch_total_span(app_state.root, split, child_count)
  let add_left = left_total <= right_total
  let parent_index = if app_state.root.synthetic {
    -1
  } else {
    app_state.root.flat_index
  }
  let appended_markdown = add_child_heading(
    app_state.markdown,
    parent_index,
    title,
  )
  let appended_index = if app_state.root.synthetic {
    count_hidden_descendants(app_state.root)
  } else {
    app_state.root.flat_index + count_subtree_nodes(app_state.root)
  }
  if !add_left {
    app_state.root_split_count = split
    return (appended_markdown, appended_index)
  }
  app_state.root_split_count = split + 1
  if split >= child_count {
    return (appended_markdown, appended_index)
  }
  let boundary_index = app_state.root.children[split].flat_index
  (
    move_heading(appended_markdown, appended_index, boundary_index, false),
    boundary_index,
  )
}

///|
fn handle_delete(node_index : Int) -> Unit {
  if node_index < 0 {
    return
  }
  shrink_root_split_after_delete(node_index)
  let next_markdown = delete_heading(app_state.markdown, node_index)
  clear_editing_session()
  clear_selected_nodes()
  app_state.editing_node = -2
  apply_markdown_change(next_markdown, false)
}

///|
fn handle_tree_navigation(
  direction : String,
  fallback_node_index : Int,
) -> Bool {
  let current_index = if app_state.selected_node >= 0 {
    app_state.selected_node
  } else {
    fallback_node_index
  }
  if current_index < 0 {
    return false
  }
  match direction {
    "ArrowLeft" =>
      match locate_tree_context(app_state.root, current_index) {
        Some((parent_index, _, _)) =>
          if parent_index >= 0 {
            select_single_node(parent_index, false)
            true
          } else {
            false
          }
        None => false
      }
    "ArrowRight" =>
      match find_node(app_state.root, current_index) {
        Some(node) => {
          if node.children.length() == 0 {
            return false
          }
          if is_collapsed(current_index) {
            expand_node(current_index)
            sync_detail_customized()
          }
          select_single_node(node.children[0].flat_index, false)
          true
        }
        None => false
      }
    "ArrowUp" => move_to_tree_sibling(current_index, false)
    "ArrowDown" => move_to_tree_sibling(current_index, true)
    _ => false
  }
}

///|
fn move_to_tree_sibling(node_index : Int, move_next : Bool) -> Bool {
  match locate_tree_context(app_state.root, node_index) {
    Some((_, siblings, sibling_index)) => {
      if siblings.length() == 0 {
        return false
      }
      if move_next {
        let next_index = (sibling_index + 1) % siblings.length()
        select_single_node(siblings[next_index].flat_index, false)
        true
      } else {
        let prev_index = if sibling_index == 0 {
          siblings.length() - 1
        } else {
          sibling_index - 1
        }
        select_single_node(siblings[prev_index].flat_index, false)
        true
      }
    }
    None => false
  }
}

///|
fn locate_tree_context(
  node : OutlineNode,
  target : Int,
) -> (Int, Array[OutlineNode], Int)? {
  if node.flat_index == target {
    return Some((-1, [], -1))
  }
  let mut child_index = 0
  for child in node.children {
    if child.flat_index == target {
      return Some((node.flat_index, node.children, child_index))
    }
    match locate_tree_context(child, target) {
      Some(context) => return Some(context)
      None => ()
    }
    child_index += 1
  }
  None
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
  let child_count = root.children.length()
  if child_count <= 1 {
    return child_count
  }
  let split = child_count / 2
  if split <= 0 {
    1
  } else if split >= child_count {
    child_count - 1
  } else {
    split
  }
}

///|
fn save_editor(node_index : Int, title : String) -> Unit {
  let next_markdown = rename_heading(
    editor_draft_markdown.val,
    node_index,
    title,
  )
  if next_markdown != editor_draft_markdown.val {
    apply_editor_draft_markdown(next_markdown)
  }
  if editor_snapshot_markdown.val != app_state.markdown {
    app_state.undo_stack.push(editor_snapshot_markdown.val)
    app_state.redo_stack = []
  }
  select_single_node(node_index, false)
  clear_editing_session()
  app_state.editing_node = -2
  render_ui()
}

///|
fn handle_insert_note() -> Unit {
  if app_state.selected_node < 0 {
    return
  }
  match find_node(app_state.root, app_state.selected_node) {
    Some(node) => {
      if node.synthetic {
        return
      }
      begin_note_edit_node(app_state.selected_node)
    }
    None => ()
  }
}

///|
fn start_edit_selected() -> Unit {
  if app_state.selected_node < 0 {
    return
  }
  begin_edit_node(app_state.selected_node)
}

///|
fn begin_edit_node(node_index : Int) -> Unit {
  clear_note_editing_session()
  editor_snapshot_node.val = node_index
  editor_snapshot_markdown.val = app_state.markdown
  editor_draft_markdown.val = app_state.markdown
  editor_undo_stack.val = []
  editor_redo_stack.val = []
  app_state.editing_node = node_index
  render_ui()
}

///|
fn begin_note_edit_node(node_index : Int) -> Unit {
  clear_editing_session()
  note_editor_snapshot_node.val = node_index
  note_editor_snapshot_markdown.val = app_state.markdown
  note_editor_draft_markdown.val = app_state.markdown
  app_state.editing_note_node = node_index
  render_ui()
}

///|
fn clear_editing_session() -> Unit {
  editor_snapshot_node.val = -1
  editor_snapshot_markdown.val = ""
  editor_draft_markdown.val = ""
  editor_undo_stack.val = []
  editor_redo_stack.val = []
  clear_note_editing_session()
}

///|
fn clear_note_editing_session() -> Unit {
  note_editor_snapshot_node.val = -1
  note_editor_snapshot_markdown.val = ""
  note_editor_draft_markdown.val = ""
  app_state.editing_note_node = -2
}

///|
fn cancel_editor(node_index : Int) -> Unit {
  if editor_snapshot_node.val == node_index {
    apply_editor_draft_markdown(editor_snapshot_markdown.val)
  }
  clear_editing_session()
  app_state.editing_node = -2
  render_ui()
}

///|
fn cancel_note_editor(node_index : Int) -> Unit {
  if note_editor_snapshot_node.val == node_index {
    apply_note_editor_draft_markdown(note_editor_snapshot_markdown.val)
  }
  clear_note_editing_session()
  render_ui()
}

///|
fn sync_note_editor_draft(node_index : Int, body_text : String) -> Unit {
  let current_markdown = note_editor_draft_markdown.val
  let next_markdown = update_node_body(current_markdown, node_index, body_text)
  if next_markdown == current_markdown {
    return
  }
  apply_note_editor_draft_markdown(next_markdown)
}

///|
fn save_note_editor(node_index : Int, body_text : String) -> Unit {
  sync_note_editor_draft(node_index, body_text)
  if note_editor_snapshot_markdown.val != app_state.markdown {
    app_state.undo_stack.push(note_editor_snapshot_markdown.val)
    app_state.redo_stack = []
  }
  clear_note_editing_session()
  render_ui()
}

///|
fn sync_editor_draft(node_index : Int, title : String) -> Unit {
  let current_markdown = editor_draft_markdown.val
  let next_markdown = rename_heading(current_markdown, node_index, title)
  if next_markdown == current_markdown {
    return
  }
  let next_undo = slice_strings(
    editor_undo_stack.val,
    0,
    editor_undo_stack.val.length(),
  )
  next_undo.push(current_markdown)
  editor_undo_stack.val = next_undo
  editor_redo_stack.val = []
  apply_editor_draft_markdown(next_markdown)
}

///|
fn toggle_note_editor(node_index : Int) -> Unit {
  if node_index < 0 {
    return
  }
  if app_state.editing_note_node == node_index {
    canceled_note_editor_node.val = node_index
    match find_node(app_state.root, node_index) {
      Some(node) => save_note_editor(node_index, node.body.join("\n\n"))
      None => ()
    }
    return
  }
  select_single_node(node_index, true)
  begin_note_edit_node(node_index)
}

///|
fn editor_undo(node_index : Int) -> Unit {
  if app_state.editing_node != node_index || editor_undo_stack.val.length() == 0 {
    return
  }
  let last_index = editor_undo_stack.val.length() - 1
  let previous = editor_undo_stack.val[last_index]
  let next_redo = slice_strings(
    editor_redo_stack.val,
    0,
    editor_redo_stack.val.length(),
  )
  next_redo.push(editor_draft_markdown.val)
  editor_redo_stack.val = next_redo
  editor_undo_stack.val = slice_strings(editor_undo_stack.val, 0, last_index)
  apply_editor_draft_markdown(previous)
  sync_editor_input_value(node_index)
}

///|
fn editor_redo(node_index : Int) -> Unit {
  if app_state.editing_node != node_index || editor_redo_stack.val.length() == 0 {
    return
  }
  let last_index = editor_redo_stack.val.length() - 1
  let next_markdown = editor_redo_stack.val[last_index]
  let next_undo = slice_strings(
    editor_undo_stack.val,
    0,
    editor_undo_stack.val.length(),
  )
  next_undo.push(editor_draft_markdown.val)
  editor_undo_stack.val = next_undo
  editor_redo_stack.val = slice_strings(editor_redo_stack.val, 0, last_index)
  apply_editor_draft_markdown(next_markdown)
  sync_editor_input_value(node_index)
}

///|
fn apply_editor_draft_markdown(markdown : String) -> Unit {
  editor_draft_markdown.val = markdown
  apply_markdown_state(markdown, false, true)
}

///|
fn apply_note_editor_draft_markdown(markdown : String) -> Unit {
  note_editor_draft_markdown.val = markdown
  apply_markdown_state(markdown, false, true)
}

///|
fn sync_editor_input_value(node_index : Int) -> Unit {
  if !app_state.started {
    return
  }
  match get_element("[data-editor-for=\"\{node_index}\"]") {
    Some(element) => {
      let title = match find_node(app_state.root, node_index) {
        Some(node) => node.title
        None => ""
      }
      @dom.HTMLInputElement::cast_from_element(element).value = title
    }
    None => ()
  }
}

///|
fn handle_move_selected(move_down : Bool) -> Unit {
  if app_state.selected_node < 0 {
    return
  }
  let (next_markdown, next_selected_node) = if move_down {
    move_heading_next_with_selection(
      app_state.markdown,
      app_state.selected_node,
    )
  } else {
    move_heading_prev_with_selection(
      app_state.markdown,
      app_state.selected_node,
    )
  }
  apply_markdown_change(next_markdown, false)
  if next_selected_node >= 0 {
    select_single_node(next_selected_node, false)
    render_ui()
  }
}

///|
fn handle_relevel_selected(indent : Bool) -> Unit {
  if app_state.selected_node < 0 {
    return
  }
  let next_markdown = if indent {
    indent_heading(app_state.markdown, app_state.selected_node)
  } else {
    promote_heading(app_state.markdown, app_state.selected_node)
  }
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
      apply_markdown_state(markdown, true, false)
    }
    return
  }
  if app_state.markdown.length() > 0 || markdown.length() > 0 {
    app_state.undo_stack.push(app_state.markdown)
  }
  app_state.redo_stack = []
  apply_markdown_state(markdown, reset_ui, false)
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
  let next_markdown = if move_down {
    move_heading_next(app_state.markdown, app_state.selected_node)
  } else {
    move_heading_prev(app_state.markdown, app_state.selected_node)
  }
  next_markdown != app_state.markdown
}

///|
fn load_rules_sample(sample_variant : String, reset_ui : Bool) -> Unit {
  let normalized = normalize_rules_sample_variant(sample_variant)
  if normalized == "custom" {
    return
  }
  reset_history()
  app_state.document_name = "notes.md"
  app_state.sample_variant = normalized
  load_rules_sample_markdown(normalized, fn(markdown) {
    if app_state.sample_variant != normalized {
      return
    }
    load_markdown(markdown, reset_ui)
  })
}

///|
fn normalize_rules_sample_variant(sample_variant : String) -> String {
  match sample_variant {
    "part2" => "part2"
    "part3" => "part3"
    "part4" => "part4"
    "custom" => "custom"
    _ => "part1"
  }
}

///|
fn load_markdown(markdown : String, reset_ui : Bool) -> Unit {
  apply_markdown_state(markdown, reset_ui, false)
}

///|
fn apply_markdown_state(
  markdown : String,
  reset_ui : Bool,
  preserve_editing_session : Bool,
) -> Unit {
  if !preserve_editing_session {
    clear_editing_session()
  }
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
  if app_state.started && get_input_value() != markdown {
    set_input_value(markdown)
  }
  sync_detail_customized()
  if !preserve_editing_session && app_state.started {
    render_ui()
    if reset_ui {
      schedule_mindmap_recenter_current_view()
    }
  }
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
  if !app_state.started {
    return
  }
  set_select_value("sample-select", app_state.sample_variant)
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
  sync_selection_toolbar()
  set_aux_action_enabled("undo-action", app_state.undo_stack.length() > 0)
  set_aux_action_enabled("redo-action", app_state.redo_stack.length() > 0)
  set_mindmap_dom(build_mindmap_dom())
  if app_state.editing_node >= 0 &&
    (app_state.editing_node == app_state.selected_node || !has_selected_nodes()) {
    focus_editor(app_state.editing_node)
  }
  if app_state.editing_note_node >= 0 {
    focus_note_editor(app_state.editing_note_node)
  }
  let linked_lines = selected_markdown_lines()
  set_input_linked_lines(ints_to_csv(linked_lines))
  let primary_linked_line = selected_markdown_line()
  if app_state.reveal_selected_line && primary_linked_line >= 0 {
    reveal_input_line(primary_linked_line)
  }
  app_state.reveal_selected_line = false
  schedule_mindmap_reveal_node(app_state.selected_node)
}

///|
fn sync_selection_ui() -> Unit {
  if !app_state.started {
    return
  }
  sync_selection_toolbar()
  sync_mindmap_selected_nodes()
  let linked_lines = selected_markdown_lines()
  set_input_linked_lines(ints_to_csv(linked_lines))
  let primary_linked_line = selected_markdown_line()
  if app_state.reveal_selected_line && primary_linked_line >= 0 {
    reveal_input_line(primary_linked_line)
  }
  app_state.reveal_selected_line = false
  schedule_mindmap_reveal_node(app_state.selected_node)
}

///|
fn sync_selection_toolbar() -> Unit {
  let has_selection = has_selected_nodes()
  set_toolbar_selection_enabled(has_selection)
  set_select_disabled("insert-select", !has_selection)
  if has_selection {
    set_toolbar_action_enabled("new-branch", can_toolbar_action("new-branch"))
    set_toolbar_action_enabled("new-child", can_toolbar_action("new-child"))
    set_toolbar_action_enabled("delete-node", can_toolbar_action("delete-node"))
    set_toolbar_action_enabled("edit-node", can_toolbar_action("edit-node"))
    set_toolbar_action_enabled("move-up", can_toolbar_action("move-up"))
    set_toolbar_action_enabled("move-down", can_toolbar_action("move-down"))
    set_toolbar_action_enabled("indent-node", can_toolbar_action("indent-node"))
    set_toolbar_action_enabled(
      "promote-node",
      can_toolbar_action("promote-node"),
    )
    set_toolbar_action_enabled("toggle-node", can_toolbar_action("toggle-node"))
  }
}

///|
fn sync_mindmap_selected_nodes() -> Unit {
  match get_element("#mindmap") {
    Some(mindmap) =>
      for node in mindmap.querySelectorAll(".node[data-node-index]") {
        let node_index = parse_int_or_default(
          node.getAttribute("data-node-index").unwrap_or("-1"),
          -1,
        )
        toggle_class(node, "is-selected", is_selected_node(node_index))
      }
    None => ()
  }
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
  source_line_for_flat_index(app_state.root, app_state.selected_node)
}

///|
fn selected_markdown_lines() -> Array[Int] {
  let lines = []
  for node_index in app_state.selected_nodes {
    let line = source_line_for_flat_index(app_state.root, node_index)
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
fn source_line_for_flat_index(root : OutlineNode, flat_index : Int) -> Int {
  if flat_index < 0 {
    return -1
  }
  match find_node(root, flat_index) {
    Some(node) => node.source_line
    None => -1
  }
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
    "indent-node" =>
      selected_node_exists() &&
      indent_heading(app_state.markdown, app_state.selected_node) !=
      app_state.markdown
    "promote-node" =>
      selected_node_exists() &&
      promote_heading(app_state.markdown, app_state.selected_node) !=
      app_state.markdown
    "toggle-node" => selected_has_children()
    "insert-note" => selected_node_exists()
    "insert-link" => selected_node_exists()
    "insert-image" => selected_node_exists()
    "insert-formula" => selected_node_exists()
    "insert-code" => selected_node_exists()
    "insert-table" => selected_node_exists()
    _ => false
  }
}

///|
fn insert_node_body_template(kind : String) -> Unit {
  if app_state.selected_node < 0 {
    return
  }
  let body_lines = if kind == "note" {
    ["笔记："]
  } else if kind == "link" {
    ["[链接文字](https://example.com)"]
  } else if kind == "image" {
    ["![图片说明](image.png)"]
  } else if kind == "formula" {
    ["$$", "x = 1", "$$"]
  } else if kind == "code" {
    ["```ts", "const value = 1", "```"]
  } else if kind == "table" {
    ["| Column | Value |", "|---|---|", "| A | 1 |"]
  } else {
    []
  }
  let template_body = normalize_markdown_body_lines(body_lines)
  if template_body.length() == 0 {
    return
  }
  let nodes = parse_markdown_nodes(app_state.markdown)
  if app_state.selected_node >= nodes.length() {
    return
  }
  let updated = []
  for index in 0..<nodes.length() {
    let node = nodes[index]
    if index == app_state.selected_node {
      let next_body = slice_strings(node.body, 0, node.body.length())
      for line in template_body {
        next_body.push(line)
      }
      updated.push(MarkdownNode::{
        kind: node.kind,
        level: node.level,
        title: node.title,
        marker: node.marker,
        body: next_body,
        body_blank_lines: default_body_blank_lines(next_body),
        leading_blank_lines: node.leading_blank_lines,
        source_line: node.source_line,
      })
    } else {
      updated.push(node)
    }
  }
  apply_markdown_change(render_markdown_nodes(updated), false)
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
    "tree" => build_vertical_mindmap_dom(app_state.root, stage_class)
    "logic" => build_single_right_mindmap_dom(app_state.root, stage_class)
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
  append_child(
    center_wrap,
    build_node_card_dom(center, -1, true, -1, "node-actions--corner"),
  )
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
    "branch-item branch-item--\{direction} branch-item--root single-right-tree__node single-right-tree__node--\{direction}",
  )
  branch.setAttribute("data-node-index", node.flat_index.to_string())
  branch.setAttribute("data-parent-index", parent_index.to_string())
  apply_node_visual_attrs(branch, node, tone_index)
  apply_root_weight_style(branch, offset, weight, total_weight)
  append_child(
    branch,
    build_drop_slot_dom(node.flat_index, parent_index, "before"),
  )
  append_branch_logic_parts(
    branch, node, parent_index, false, direction, tone_index,
  )
  append_child(
    branch,
    build_drop_slot_dom(node.flat_index, parent_index, "after"),
  )
  branch
}

///|
fn append_branch_logic_parts(
  branch : @dom.Element,
  node : OutlineNode,
  parent_index : Int,
  is_root : Bool,
  direction : String,
  tone_index : Int,
) -> Unit {
  let head = create_element(
    "div",
    "single-right-tree__head single-right-tree__head--\{direction}",
  )
  let card = build_node_card_dom(
    node,
    parent_index,
    is_root,
    tone_index,
    if direction == "left" {
      "node-actions--left-mid"
    } else {
      "node-actions--right-mid"
    },
  )
  if direction == "left" {
    append_child(head, card)
    append_child(branch, build_branch_children_dom(node, direction, tone_index))
    append_child(branch, head)
  } else {
    append_child(head, card)
    append_child(branch, head)
    append_child(branch, build_branch_children_dom(node, direction, tone_index))
  }
}

///|
fn build_branch_node_dom(
  node : OutlineNode,
  parent_index : Int,
  direction : String,
  tone_index : Int,
) -> @dom.Element {
  let branch = create_element(
    "div",
    "branch-item branch-item--\{direction} single-right-tree__node single-right-tree__node--\{direction}",
  )
  branch.setAttribute("data-node-index", node.flat_index.to_string())
  branch.setAttribute("data-parent-index", parent_index.to_string())
  apply_node_visual_attrs(branch, node, tone_index)
  append_child(
    branch,
    build_drop_slot_dom(node.flat_index, parent_index, "before"),
  )
  append_branch_logic_parts(
    branch, node, parent_index, false, direction, tone_index,
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
    "single-right-tree__children single-right-tree__children--\{direction}",
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
    build_node_card_dom(
      node, parent_index, is_root, tone_index, "node-actions--bottom-center",
    ),
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
    build_node_card_dom(
      node, parent_index, is_root, tone_index, "node-actions--right-mid",
    ),
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
  action_anchor : String,
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
  append_child(card, build_node_title_dom(node, is_editing))
  match build_node_note_dom(node) {
    Some(note) => append_child(card, note)
    None => ()
  }
  if has_children && !is_center {
    match build_node_actions_dom(node, editable, is_center, action_anchor) {
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
    let title = create_element("strong", "node-title")
    append_child(title, build_markdown_title_dom(node.title))
    title
  }
}

///|
fn build_node_body_dom(node : OutlineNode) -> @dom.Element? {
  if !node_has_note(node) {
    return None
  }
  let body = create_element("div", "node-body")
  if app_state.editing_note_node == node.flat_index {
    let textarea = create_element("textarea", "node-note-editor")
    textarea.setAttribute("data-note-editor-for", node.flat_index.to_string())
    textarea.setAttribute("rows", "4")
    @dom.HTMLTextAreaElement::cast_from_element(textarea).value = node.body.join(
      "\n\n",
    )
    append_child(body, textarea)
  } else {
    body.setClassName("node-body node-body-preview")
    apply_theme_to_element(body)
    body.setAttribute("data-note-preview-for", node.flat_index.to_string())
    body.setAttribute("data-tip", "Double-click to edit note")
    append_child(body, build_markdown_blocks_dom(node.body))
  }
  Some(body)
}

///|
fn build_node_note_dom(node : OutlineNode) -> @dom.Element? {
  if !node_has_note(node) {
    return None
  }
  let rail = create_element("div", "node-note-rail")
  let button = create_element("button", "node-action node-action--note")
  button.setAttribute("type", "button")
  button.setAttribute("data-action", "toggle-note")
  button.setAttribute("data-tip", "Note")
  button.setAttribute("aria-label", "Note")
  button.setTextContent("N")
  append_child(rail, button)
  match build_node_body_dom(node) {
    Some(body) => append_child(rail, body)
    None => ()
  }
  Some(rail)
}

///|
fn build_node_actions_dom(
  node : OutlineNode,
  editable : Bool,
  is_center : Bool,
  action_anchor : String,
) -> @dom.Element? {
  let _ = editable
  if is_center || node.children.length() == 0 {
    return None
  }
  let actions = create_element("div", "node-actions \{action_anchor}")
  let collapsed = is_collapsed(node.flat_index)
  let hidden_count = count_hidden_descendants(node)
  let label = if collapsed { hidden_count.to_string() } else { "" }
  let title = if collapsed {
    "\{hidden_count} hidden children"
  } else {
    "Collapse"
  }
  let expanded = (!collapsed).to_string()
  let state_class = if collapsed { " node-action--collapsed" } else { "" }
  let button = create_element(
    "button",
    "node-action node-action--toggle\{state_class}",
  )
  button.setAttribute("type", "button")
  button.setAttribute("data-action", "toggle")
  button.setAttribute("data-tip", title)
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
  marker.setAttribute("data-tip", "展开折叠节点")
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
  let class_name = if app_state.layout_mode == "logic" {
    "drop-slot drop-slot--single-right"
  } else {
    "drop-slot"
  }
  let slot = create_element("div", class_name)
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
    count_hidden_descendants(node).to_string(),
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
  let style = @dom.css_style_from_val(element.as_any()._get("style").cast())
  style.set_property(
    "top",
    format_percentage_from_basis_points(
      (offset * 10000 + safe_weight * 5000) / safe_total,
    ),
  )
}

///|
fn format_percentage_from_basis_points(value : Int) -> String {
  let whole = value / 100
  let frac = value % 100
  let frac_text = if frac < 10 { "0\{frac}" } else { frac.to_string() }
  "\{whole}.\{frac_text}%"
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
  contour_subtree_span(node)
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
  let body = if direction == "left" {
    "\{children_html}<div class=\"single-right-tree__head single-right-tree__head--left\">\{card}</div>"
  } else {
    "<div class=\"single-right-tree__head single-right-tree__head--right\">\{card}</div>\{children_html}"
  }
  "<div class=\"branch-item branch-item--\{direction} single-right-tree__node single-right-tree__node--\{direction}\" data-node-index=\"\{node.flat_index}\" data-parent-index=\"\{parent_index}\"\{branch_attrs}>\{before_slot}\{body}\{after_slot}</div>"
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
  "<div class=\"single-right-tree__children single-right-tree__children--\{direction}\"\{branch_attrs}>\{body}</div>"
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
  let note_html = render_node_note(node)
  let action_html = render_node_actions_with_note(
    node, has_children, editable, is_center,
  )
  let drag_attrs = render_drag_attrs(node, parent_index, is_draggable)
  let visual_attrs = render_node_visual_attrs(node, tone_index)
  "<div class=\"\{class_name}\" data-level=\"\{node.level}\" data-node-index=\"\{node.flat_index}\" data-parent-index=\"\{parent_index}\"\{visual_attrs}\{drag_attrs}>\{title_html}\{note_html}\{action_html}</div>"
}

///|
fn render_node_visual_attrs(node : OutlineNode, tone_index : Int) -> String {
  let has_children = node.children.length() > 0
  let child_count = node.children.length()
  let collapsed = is_collapsed(node.flat_index)
  let hidden_count = count_hidden_descendants(node)
  let hidden_node = is_hidden_node(node.flat_index)
  " data-depth=\"\{relative_node_depth(node)}\" data-tone=\"\{tone_index}\" data-has-children=\"\{has_children}\" data-child-count=\"\{child_count}\" data-collapsed=\"\{collapsed}\" data-hidden-count=\"\{hidden_count}\" data-hidden-node=\"\{hidden_node}\""
}

///|
fn render_hidden_marker(node : OutlineNode, tone_index : Int) -> String {
  build_hidden_marker_dom(node, tone_index).outerHTML()
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
  let title = render_markdown_title_html(node.title)
  "<strong>\{title}</strong>"
}

///|
fn render_node_note(node : OutlineNode) -> String {
  render_node_body(node)
}

///|
fn render_node_body(node : OutlineNode) -> String {
  if !node_has_note(node) {
    return ""
  }
  let note_button = "<button type=\"button\" class=\"node-action node-action--note\" data-action=\"toggle-note\" data-tip=\"Note\" aria-label=\"Note\">N</button>"
  let body = if app_state.editing_note_node == node.flat_index {
    let value = escape_html(node.body.join("\n\n"))
    "<div class=\"node-body\"><textarea class=\"node-note-editor\" data-note-editor-for=\"\{node.flat_index}\" rows=\"4\">\{value}</textarea></div>"
  } else {
    "<div class=\"node-body node-body-preview\" data-note-preview-for=\"\{node.flat_index}\" data-tip=\"Double-click to edit note\"><div class=\"markdown-blocks\">\{render_markdown_blocks_html(node.body)}</div></div>"
  }
  "<div class=\"node-note-rail\">\{note_button}\{body}</div>"
}

///|
fn render_node_actions_with_note(
  node : OutlineNode,
  has_children : Bool,
  editable : Bool,
  is_center : Bool,
) -> String {
  let _ = editable
  if is_center || !has_children {
    return ""
  }
  let collapsed = is_collapsed(node.flat_index)
  let hidden_count = count_hidden_descendants(node)
  let label = if collapsed { hidden_count.to_string() } else { "" }
  let title = if collapsed {
    "\{hidden_count} hidden children"
  } else {
    "Collapse"
  }
  let expanded = (!collapsed).to_string()
  let state_class = if collapsed { " node-action--collapsed" } else { "" }
  "<div class=\"node-actions\"><button type=\"button\" class=\"node-action node-action--toggle\{state_class}\" data-action=\"toggle\" data-tip=\"\{title}\" aria-label=\"\{title}\" aria-expanded=\"\{expanded}\">\{label}</button></div>"
}

///|
fn node_has_note(node : OutlineNode) -> Bool {
  node.body.length() > 0 || app_state.editing_note_node == node.flat_index
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
fn contour_subtree_span(node : OutlineNode) -> Int {
  if is_hidden_node(node.flat_index) {
    return 24
  }
  let own_height = contour_node_height(node)
  if !should_render_children(node) {
    return own_height
  }
  let mut total_children = 0
  for child in node.children {
    total_children += contour_subtree_span(child)
  }
  let child_count = node.children.length()
  if child_count == 0 {
    own_height
  } else {
    own_height + 16 + total_children + (child_count - 1) * 16
  }
}

///|
fn contour_node_height(node : OutlineNode) -> Int {
  let is_center = node.flat_index == app_state.root.flat_index
  let base_height = if is_center {
    72
  } else if node.level <= app_state.root.level + 1 {
    60
  } else {
    54
  }
  let title_chars = if is_center {
    15
  } else if app_state.style_mode == "fill" {
    18
  } else {
    20
  }
  let title_line_height = if is_center {
    22
  } else if node.level <= app_state.root.level + 1 {
    20
  } else {
    19
  }
  let title_lines = contour_wrap_lines(node.title, title_chars)
  let note_height = contour_note_height(node)
  base_height + title_lines * title_line_height + note_height
}

///|
fn contour_note_height(node : OutlineNode) -> Int {
  if !node_has_note(node) {
    return 0
  }
  let mut line_count = 0
  let wrap_chars = if app_state.style_mode == "fill" { 22 } else { 20 }
  for block in node.body {
    let wrapped = contour_wrap_lines(block, wrap_chars)
    line_count += if wrapped > 0 { wrapped } else { 1 }
  }
  if line_count == 0 && app_state.editing_note_node == node.flat_index {
    line_count = 4
  }
  let line_height = if app_state.editing_note_node == node.flat_index {
    18
  } else {
    17
  }
  let raw_height = line_count * line_height + 24
  if raw_height > 120 {
    120
  } else {
    raw_height
  }
}

///|
fn contour_wrap_lines(text : String, chars_per_line : Int) -> Int {
  let safe_chars = if chars_per_line <= 1 { 1 } else { chars_per_line }
  let length = text.length()
  if length <= 0 {
    1
  } else {
    (length + safe_chars - 1) / safe_chars
  }
}

///|
fn contour_pack_positions(
  heights : Array[Int],
  available_span : Int,
  gap : Int,
) -> Array[Int] {
  let positions = []
  if heights.length() == 0 {
    return positions
  }
  let mut total = 0
  for height in heights {
    total += contour_max_int(1, height)
  }
  total += gap * (heights.length() - 1)
  let mut cursor = 0
  if available_span > total {
    cursor = (available_span - total) / 2
  }
  for height in heights {
    positions.push(cursor)
    cursor += contour_max_int(1, height) + gap
  }
  positions
}

///|
fn contour_anchor_pack_positions(
  heights : Array[Int],
  anchor_center : Int,
  available_span : Int,
  gap : Int,
) -> Array[Int] {
  let positions = contour_pack_positions(heights, available_span, gap)
  if positions.length() == 0 {
    return positions
  }
  let mut total = 0
  for height in heights {
    total += contour_max_int(1, height)
  }
  total += gap * (heights.length() - 1)
  let expected_start = anchor_center - total / 2
  let shift = expected_start - positions[0]
  if shift == 0 {
    return positions
  }
  let adjusted = []
  for position in positions {
    adjusted.push(position + shift)
  }
  adjusted
}

///|
fn contour_max_int(left : Int, right : Int) -> Int {
  if left > right {
    left
  } else {
    right
  }
}

///|
fn single_child_chain_length(node : OutlineNode) -> Int {
  if !should_render_children(node) || node.children.length() != 1 {
    1
  } else {
    1 + single_child_chain_length(node.children[0])
  }
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
  let class_name = if app_state.layout_mode == "logic" {
    "drop-slot drop-slot--single-right"
  } else {
    "drop-slot"
  }
  "<div class=\"\{class_name}\" data-drop-target=\"\{node_index}\" data-drop-parent=\"\{parent_index}\" data-drop-position=\"\{position}\"></div>"
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
    "horizontal" => "mindmap"
    "vertical" => "tree"
    "single-right" => "logic"
    "logic" => "logic"
    "tree" => "tree"
    _ => "mindmap"
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
  .replace_all(old="&", new="&amp;")
  .replace_all(old="<", new="&lt;")
  .replace_all(old=">", new="&gt;")
  .replace_all(old="\"", new="&quot;")
}

///|
fn escape_html_attribute(source : String) -> String {
  escape_html(source).replace_all(old="'", new="&#39;")
}

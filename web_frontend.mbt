///|
priv struct NodeWidthOverride {
  node_index : Int
  width : Int
}

///|
priv struct HistorySnapshot {
  markdown : String
  node_width_overrides : Array[NodeWidthOverride]
  selected_node : Int
}

///|
priv struct AppState {
  mut started : Bool
  mut markdown : String
  mut document_name : String
  mut root : OutlineNode
  mut collapsed : Array[Int]
  mut collapsed_note_nodes : Array[Int]
  mut hidden_nodes : Array[Int]
  mut undo_stack : Array[HistorySnapshot]
  mut redo_stack : Array[HistorySnapshot]
  mut selected_node : Int
  mut selected_nodes : Array[Int]
  mut selection_anchor_node : Int
  mut editing_node : Int
  mut editing_note_node : Int
  mut editing_body_node : Int
  mut editing_body_block : Int
  mut layout_mode : String
  mut style_mode : String
  mut detail_level : String
  mut detail_customized : Bool
  mut left_panel_percent : Int
  mut root_split_count : Int
  mut reveal_selected_line : Bool
  mut sample_variant : String
  mut node_width_overrides : Array[NodeWidthOverride]
}

///|
let app_state : AppState = AppState::{
  started: false,
  markdown: "",
  document_name: "notes.md",
  root: empty_outline(),
  collapsed: [],
  collapsed_note_nodes: [],
  hidden_nodes: [],
  undo_stack: [],
  redo_stack: [],
  selected_node: -2,
  selected_nodes: [],
  selection_anchor_node: -2,
  editing_node: -2,
  editing_note_node: -2,
  editing_body_node: -2,
  editing_body_block: -1,
  layout_mode: "logic",
  style_mode: "full",
  detail_level: "all",
  detail_customized: false,
  left_panel_percent: 33,
  root_split_count: 0,
  reveal_selected_line: false,
  sample_variant: rules_sample_default_id(),
  node_width_overrides: [],
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
let note_editor_undo_stack : @ref.Ref[Array[String]] = @ref.Ref([])

///|
let note_editor_redo_stack : @ref.Ref[Array[String]] = @ref.Ref([])

///|
let undo_expand_node : @ref.Ref[Int] = @ref.Ref(-2)

///|
let redo_expand_node : @ref.Ref[Int] = @ref.Ref(-2)

///|
let undo_expand_stack : @ref.Ref[Array[Int]] = @ref.Ref([])

///|
let undo_redo_expand_stack : @ref.Ref[Array[Int]] = @ref.Ref([])

///|
let redo_expand_stack : @ref.Ref[Array[Int]] = @ref.Ref([])

///|
let redo_undo_expand_stack : @ref.Ref[Array[Int]] = @ref.Ref([])

///|
let editor_created_node : @ref.Ref[Int] = @ref.Ref(-2)

///|
let suppress_next_render_mindmap_reveal : @ref.Ref[Bool] = @ref.Ref(false)

///|
let suppress_next_mindmap_click : @ref.Ref[Bool] = @ref.Ref(false)

///|
let drag_source_node : @ref.Ref[Int] = @ref.Ref(-1)

///|
let drag_start_x : @ref.Ref[Int] = @ref.Ref(0)

///|
let drag_start_y : @ref.Ref[Int] = @ref.Ref(0)

///|
let drag_last_x : @ref.Ref[Int] = @ref.Ref(0)

///|
let drag_last_y : @ref.Ref[Int] = @ref.Ref(0)

///|
let drag_active : @ref.Ref[Bool] = @ref.Ref(false)

///|
let drag_drop_kind : @ref.Ref[String] = @ref.Ref("")

///|
let drag_drop_target : @ref.Ref[Int] = @ref.Ref(-2)

///|
let drag_auto_pan_frame : @ref.Ref[Int] = @ref.Ref(0)

///|
let drag_snapshot_selected_node : @ref.Ref[Int] = @ref.Ref(-2)

///|
let drag_snapshot_selected_nodes : @ref.Ref[Array[Int]] = @ref.Ref([])

///|
let drag_snapshot_selection_anchor_node : @ref.Ref[Int] = @ref.Ref(-2)

///|
let drag_snapshot_reveal_selected_line : @ref.Ref[Bool] = @ref.Ref(false)

///|
let resize_width_node_index : @ref.Ref[Int] = @ref.Ref(-1)

///|
let resize_width_start_x : @ref.Ref[Int] = @ref.Ref(0)

///|
let resize_width_start_width : @ref.Ref[Int] = @ref.Ref(0)

///|
let resize_width_active : @ref.Ref[Bool] = @ref.Ref(false)

///|
let resize_width_snapshot : @ref.Ref[HistorySnapshot?] = @ref.Ref(None)

///|
let resize_width_connector_frame : @ref.Ref[Int] = @ref.Ref(0)

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
    on_mindmap_editor_input,
  )
  bind_node_drag_ui()
  bind_native_text_selection_clear_ui()
  bind_input_listener(on_input_change, on_input_selected_headings_change)
  load_rules_sample(rules_sample_default_id(), true)
}

///|
fn bind_native_text_selection_clear_ui() -> Unit {
  @dom.window()
  .as_event_target()
  .addEventListener("mousedown", fn(raw) {
    let event : @dom.MouseEvent = raw.cast()
    if should_keep_native_text_selection(event.target()) {
      return
    }
    clear_native_text_selection()
  })
}

///|
fn should_keep_native_text_selection(target : @dom.Element) -> Bool {
  target.closest(
    ".node, input, textarea, select, [contenteditable], [data-editor-for], [data-note-editor-for], [data-body-editor-for]",
  )
  is Some(_)
}

///|
fn clear_native_text_selection() -> Unit {
  @dom.window().as_any()._call("getSelection", [])._call("removeAllRanges", [])
  |> ignore
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
  let preserve_node = app_state.selected_node
  let node_origin = capture_mindmap_node_origin(preserve_node)
  suppress_next_render_mindmap_reveal.val = true
  apply_markdown_change(get_input_value(), false)
  schedule_mindmap_preserve_node_origin(preserve_node, node_origin)
}

///|
fn on_input_selected_headings_change(serialized : String) -> Unit {
  if serialized.length() == 0 {
    return
  }
  let next_selected_nodes = parse_selection_indices(serialized)
  if same_int_set(app_state.selected_nodes, next_selected_nodes) {
    if next_selected_nodes.length() > 0 {
      schedule_mindmap_reveal_node(
        next_selected_nodes[next_selected_nodes.length() - 1],
      )
    }
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
  let root_anchor = capture_mindmap_current_root_anchor()
  app_state.style_mode = normalize_style_mode(mode)
  render_ui()
  schedule_mindmap_preserve_root_anchor(root_anchor)
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
  if suppress_next_mindmap_click.val {
    suppress_next_mindmap_click.val = false
    event.preventDefault()
    event.stopPropagation()
    return
  }
  let action = event_action_from_point(event)
  if action != "save-body-block" &&
    action != "cancel-body-block" &&
    (
      event_editor_index_from_target(event.target()) >= 0 ||
      event_note_editor_index_from_target(event.target()) >= 0 ||
      event_body_editor_index_from_target(event.target()) >= 0
    ) {
    return
  }
  match event.target().closest(".markdown-image") {
    Some(image) => {
      event.preventDefault()
      event.stopPropagation()
      show_markdown_image_preview(image)
      return
    }
    None => ()
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
      toggle_note_body(node_index)
    }
    "edit-body-block" => {
      event.stopPropagation()
      begin_body_block_edit_node(
        node_index,
        event_body_block_index_from_target(event.target()),
      )
    }
    "delete-body-block" => {
      event.stopPropagation()
      delete_body_block(
        node_index,
        event_body_block_index_from_target(event.target()),
      )
    }
    "save-body-block" => {
      event.stopPropagation()
      save_body_block_editor(
        node_index,
        event_body_block_index_from_target(event.target()),
        body_block_editor_value_from_target(event.target()),
      )
    }
    "cancel-body-block" => {
      event.stopPropagation()
      cancel_body_block_editor()
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
        "[data-node-index], [data-action], [data-editor-for], [data-note-editor-for], [data-body-editor-for]",
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
    "undo" => handle_undo_action()
    "redo" => handle_redo_action()
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
    "insert-image" => insert_node_body_template("image")
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
    event.stopPropagation()
    select_single_node(node_index, true)
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
  if drag_source_node.val >= 0 && event_key(event) == "Escape" {
    event.preventDefault()
    cancel_node_drag()
    return
  }
  let body_editor_index = event_body_editor_index_from_target(event.target())
  if body_editor_index >= 0 {
    if event_key(event) == "Escape" {
      event.preventDefault()
      cancel_body_block_editor()
    }
    return
  }
  let note_editor_index = event_note_editor_index_from_target(event.target())
  if note_editor_index >= 0 {
    let command_key = event.ctrlKey || event.metaKey
    let key = event_key(event)
    if is_undo_shortcut(command_key, event.shiftKey, key) {
      event.preventDefault()
      note_editor_undo(note_editor_index)
    } else if is_redo_shortcut(command_key, event.shiftKey, key) {
      event.preventDefault()
      note_editor_redo(note_editor_index)
    } else if command_key && (key == "Enter" || key == "enter") {
      event.preventDefault()
      save_note_editor(
        note_editor_index,
        event_note_editor_value_from_target(event.target()),
      )
    } else if key == "Escape" {
      event.preventDefault()
      canceled_note_editor_node.val = note_editor_index
      cancel_note_editor(note_editor_index)
    }
    return
  }
  let editor_index = event_editor_index_from_target(event.target())
  if editor_index >= 0 {
    let command_key = event.ctrlKey || event.metaKey
    let key = event_key(event)
    if is_undo_shortcut(command_key, event.shiftKey, key) {
      event.preventDefault()
      editor_undo(editor_index)
    } else if is_redo_shortcut(command_key, event.shiftKey, key) {
      event.preventDefault()
      editor_redo(editor_index)
    } else {
      match key {
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
  let key = event_key(event)
  if is_undo_shortcut(command_key, event.shiftKey, key) {
    event.preventDefault()
    event.stopPropagation()
    handle_undo()
    return
  }
  if is_redo_shortcut(command_key, event.shiftKey, key) {
    event.preventDefault()
    event.stopPropagation()
    handle_redo()
    return
  }
  if handle_mindmap_move_shortcut(command_key, key) {
    event.preventDefault()
    event.stopPropagation()
    return
  }
  if target_node_index < 0 {
    return
  }
  match event_key(event) {
    "ArrowLeft" => {
      event.preventDefault()
      event.stopPropagation()
      handle_keyboard_tree_navigation("ArrowLeft", target_node_index)
    }
    "ArrowRight" => {
      event.preventDefault()
      event.stopPropagation()
      handle_keyboard_tree_navigation("ArrowRight", target_node_index)
    }
    "ArrowUp" => {
      event.preventDefault()
      event.stopPropagation()
      handle_keyboard_tree_navigation("ArrowUp", target_node_index)
    }
    "ArrowDown" => {
      event.preventDefault()
      event.stopPropagation()
      handle_keyboard_tree_navigation("ArrowDown", target_node_index)
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
fn is_undo_shortcut(command_key : Bool, shift_key : Bool, key : String) -> Bool {
  command_key && !shift_key && (key == "z" || key == "Z")
}

///|
fn is_redo_shortcut(command_key : Bool, shift_key : Bool, key : String) -> Bool {
  if !command_key {
    return false
  }
  if shift_key {
    key == "z" || key == "Z"
  } else {
    key == "y" || key == "Y"
  }
}

///|
fn handle_mindmap_move_shortcut(command_key : Bool, key : String) -> Bool {
  if !command_key || app_state.selected_node < 0 {
    return false
  }
  match key {
    "ArrowUp" => {
      handle_move_selected(false)
      true
    }
    "ArrowDown" => {
      handle_move_selected(true)
      true
    }
    _ => false
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
fn bind_node_drag_ui() -> Unit {
  match get_element("#mindmap") {
    Some(mindmap) => {
      let window = @dom.window()
      mindmap
      .as_event_target()
      .on("mousedown", fn(raw) {
        let event : @dom.MouseEvent = raw.cast()
        if start_node_width_resize_candidate(event) {
          return
        }
        start_node_drag_candidate(event)
      })
      window
      .as_event_target()
      .on("mousemove", fn(raw) {
        let event : @dom.MouseEvent = raw.cast()
        if update_node_width_resize(event) {
          return
        }
        update_node_drag(event)
      })
      window
      .as_event_target()
      .on("mouseup", fn(raw) {
        let event : @dom.MouseEvent = raw.cast()
        if finish_node_width_resize(event) {
          return
        }
        finish_node_drag(event)
      })
    }
    None => ()
  }
}

///|
fn start_node_width_resize_candidate(event : @dom.MouseEvent) -> Bool {
  if mouse_event_button(event) != 0 {
    return false
  }
  match event.target().closest(".node-width-resize-handle") {
    Some(handle) => {
      let node_index = parse_int_or_default(
        handle.getAttribute("data-resize-node-index").unwrap_or("-1"),
        -1,
      )
      if node_index < 0 || !is_selected_node(node_index) {
        return false
      }
      match handle.closest(".node[data-node-index]") {
        Some(node) => {
          event.preventDefault()
          event.stopPropagation()
          resize_width_node_index.val = node_index
          resize_width_start_x.val = event.clientX.to_int()
          resize_width_start_width.val = current_node_width_for_resize(node)
          resize_width_active.val = true
          resize_width_snapshot.val = Some(current_history_snapshot())
          mindmap_set_body_user_select("none")
          set_body_drag_style("ew-resize", "none")
          true
        }
        None => false
      }
    }
    None => false
  }
}

///|
fn update_node_width_resize(event : @dom.MouseEvent) -> Bool {
  if !resize_width_active.val || resize_width_node_index.val < 0 {
    return false
  }
  event.preventDefault()
  let width = normalize_node_width(
    resize_width_start_width.val +
    event.clientX.to_int() -
    resize_width_start_x.val,
  )
  set_node_width_override(resize_width_node_index.val, width)
  apply_node_width_to_dom(resize_width_node_index.val, width)
  schedule_node_width_resize_layout()
  true
}

///|
fn finish_node_width_resize(event : @dom.MouseEvent) -> Bool {
  if !resize_width_active.val || resize_width_node_index.val < 0 {
    return false
  }
  event.preventDefault()
  let node_index = resize_width_node_index.val
  let width = node_width_override_value(node_index).unwrap_or(
    resize_width_start_width.val,
  )
  match resize_width_snapshot.val {
    Some(snapshot) =>
      if width != resize_width_start_width.val {
        push_undo_snapshot(snapshot, node_index, node_index)
        clear_redo_history()
      }
    None => ()
  }
  reset_node_width_resize_state()
  mindmap_clear_body_user_select()
  clear_body_drag_style()
  schedule_node_width_resize_layout()
  sync_selection_toolbar()
  true
}

///|
fn reset_node_width_resize_state() -> Unit {
  resize_width_node_index.val = -1
  resize_width_start_x.val = 0
  resize_width_start_width.val = 0
  resize_width_active.val = false
  resize_width_snapshot.val = None
}

///|
fn current_node_width_for_resize(node : @dom.Element) -> Int {
  match
    node_width_override_value(
      parse_int_or_default(
        node.getAttribute("data-node-index").unwrap_or("-1"),
        -1,
      ),
    ) {
    Some(width) => width
    None => normalize_node_width(element_rect(node).width.round().to_int())
  }
}

///|
fn schedule_node_width_resize_layout() -> Unit {
  schedule_render_mindmap_connectors_soon()
  schedule_contour_layout()
}

///|
fn schedule_render_mindmap_connectors_soon() -> Unit {
  let window = @dom.window()
  if resize_width_connector_frame.val != 0 {
    window.cancelAnimationFrame(resize_width_connector_frame.val)
  }
  resize_width_connector_frame.val = window.requestAnimationFrame(fn(_) {
    resize_width_connector_frame.val = 0
    render_mindmap_connectors()
  })
}

///|
fn cancel_node_width_resize_connector_frame() -> Unit {
  if resize_width_connector_frame.val != 0 {
    @dom.window().cancelAnimationFrame(resize_width_connector_frame.val)
    resize_width_connector_frame.val = 0
  }
}

///|
fn start_node_drag_candidate(event : @dom.MouseEvent) -> Unit {
  if mouse_event_button(event) != 0 {
    return
  }
  let node_index = drag_source_index_from_target(event.target())
  if !can_start_node_drag(node_index) {
    return
  }
  event.preventDefault()
  drag_source_node.val = node_index
  drag_start_x.val = event.clientX.to_int()
  drag_start_y.val = event.clientY.to_int()
  drag_last_x.val = drag_start_x.val
  drag_last_y.val = drag_start_y.val
  drag_active.val = false
  drag_drop_kind.val = ""
  drag_drop_target.val = -2
  capture_node_drag_selection()
  focus_mindmap()
}

///|
fn update_node_drag(event : @dom.MouseEvent) -> Unit {
  if drag_source_node.val < 0 {
    return
  }
  drag_last_x.val = event.clientX.to_int()
  drag_last_y.val = event.clientY.to_int()
  if !drag_active.val {
    if !mouse_delta_exceeds_pan_threshold(
        drag_start_x.val,
        drag_start_y.val,
        event.clientX.to_int(),
        event.clientY.to_int(),
      ) {
      return
    }
    clear_editing_session()
    clear_note_editing_session()
    clear_body_block_editing_session()
    select_single_node(drag_source_node.val, false)
    sync_selection_ui()
    drag_active.val = true
    suppress_next_mindmap_click.val = true
    set_dragging_source_class(true)
    ensure_node_drag_ghost()
    schedule_node_drag_auto_pan()
    mindmap_set_body_user_select("none")
  }
  event.preventDefault()
  update_node_drag_target_at(event.clientX, event.clientY)
  update_node_drag_ghost()
}

///|
fn finish_node_drag(event : @dom.MouseEvent) -> Unit {
  if drag_source_node.val < 0 {
    return
  }
  let was_active = drag_active.val
  let placement = current_node_drag_placement()
  if was_active {
    event.preventDefault()
  }
  clear_node_drag_visuals()
  let mut moved = false
  if was_active {
    suppress_next_mindmap_click.val = true
    match placement {
      Some(drop) => moved = apply_node_drag_drop(drop)
      None => ()
    }
  }
  if was_active && !moved {
    select_node_drag_source()
  }
  reset_node_drag_state()
  mindmap_clear_body_user_select()
}

///|
fn cancel_node_drag() -> Unit {
  let was_active = drag_active.val
  clear_node_drag_visuals()
  if was_active {
    restore_node_drag_selection()
  }
  reset_node_drag_state()
  mindmap_clear_body_user_select()
}

///|
fn reset_node_drag_state() -> Unit {
  cancel_node_drag_auto_pan()
  cancel_node_width_resize_connector_frame()
  drag_source_node.val = -1
  drag_start_x.val = 0
  drag_start_y.val = 0
  drag_last_x.val = 0
  drag_last_y.val = 0
  drag_active.val = false
  drag_drop_kind.val = ""
  drag_drop_target.val = -2
  drag_snapshot_selected_node.val = -2
  drag_snapshot_selected_nodes.val = []
  drag_snapshot_selection_anchor_node.val = -2
  drag_snapshot_reveal_selected_line.val = false
  reset_node_width_resize_state()
}

///|
fn capture_node_drag_selection() -> Unit {
  drag_snapshot_selected_node.val = app_state.selected_node
  drag_snapshot_selected_nodes.val = copy_ints(app_state.selected_nodes)
  drag_snapshot_selection_anchor_node.val = app_state.selection_anchor_node
  drag_snapshot_reveal_selected_line.val = app_state.reveal_selected_line
}

///|
fn restore_node_drag_selection() -> Unit {
  app_state.selected_node = drag_snapshot_selected_node.val
  app_state.selected_nodes = copy_ints(drag_snapshot_selected_nodes.val)
  app_state.selection_anchor_node = drag_snapshot_selection_anchor_node.val
  app_state.reveal_selected_line = drag_snapshot_reveal_selected_line.val
  sync_selection_ui()
}

///|
fn select_node_drag_source() -> Unit {
  if drag_source_node.val < 0 {
    return
  }
  select_single_node(drag_source_node.val, false)
  sync_selection_ui()
}

///|
fn drag_source_index_from_target(target : @dom.Element) -> Int {
  if target.closest(node_drag_blocked_target_selector()) is Some(_) {
    return -1
  }
  match target.closest(".node[data-node-index]") {
    Some(node) =>
      parse_int_or_default(
        node.getAttribute("data-node-index").unwrap_or("-1"),
        -1,
      )
    None => -1
  }
}

///|
fn node_drag_blocked_target_selector() -> String {
  "button, input, textarea, select, [data-action], [data-editor-for], [data-note-editor-for], [data-body-editor-for], .node-width-resize-handle, .node-body, .node-note-rail, .markdown-image"
}

///|
fn can_start_node_drag(node_index : Int) -> Bool {
  if node_index < 0 || node_index == app_state.root.flat_index {
    return false
  }
  match find_node(app_state.root, node_index) {
    Some(node) => !node.synthetic
    None => false
  }
}

///|
fn mouse_event_button(event : @dom.MouseEvent) -> Int {
  parse_int_or_default(event.as_any()._get("button").to_string(), 0)
}

///|
fn ensure_node_drag_ghost() -> Unit {
  match get_element(".node-drag-ghost") {
    Some(_) => ()
    None => {
      let ghost = create_element("div", "node-drag-ghost")
      ghost.setTextContent("")
      let style = style_of(ghost)
      style.set_property("position", "fixed")
      style.set_property("left", "0")
      style.set_property("top", "0")
      style.set_property("z-index", "9999")
      style.set_property("pointer-events", "none")
      style.set_property("transform", "translate(-9999px, -9999px)")
      style.set_property("padding", "8px 12px")
      style.set_property("border-radius", "10px")
      style.set_property("background", "rgba(35, 56, 77, 0.92)")
      style.set_property("color", "#ffffff")
      style.set_property("font-size", "13px")
      style.set_property("font-weight", "800")
      style.set_property("box-shadow", "0 12px 28px rgba(66, 86, 108, 0.22)")
      match @dom.document().body() {
        Some(body) => append_child(body.as_element(), ghost)
        None => append_child(@dom.document().documentElement(), ghost)
      }
    }
  }
}

///|
fn update_node_drag_ghost() -> Unit {
  match get_element(".node-drag-ghost") {
    Some(ghost) => {
      let label = node_drag_ghost_label(drag_drop_kind.val)
      let style = style_of(ghost)
      if label.length() == 0 || drag_drop_target.val < 0 {
        style.set_property("visibility", "hidden")
        return
      }
      ghost.setTextContent(label)
      match get_element(".node[data-node-index=\"\{drag_drop_target.val}\"]") {
        Some(target) => {
          let rect = element_rect(target)
          let x = rect.left + rect.width + 18.0
          let y = match drag_drop_kind.val {
            "before" => rect.top - 30.0
            "after" => rect.top + rect.height + 10.0
            _ => rect.top + rect.height / 2.0 - 17.0
          }
          style.set_property("visibility", "visible")
          style.set_property("transform", "translate(\{x}px, \{y}px)")
        }
        None => style.set_property("visibility", "hidden")
      }
    }
    None => ()
  }
}

///|
fn node_drag_ghost_label(kind : String) -> String {
  match kind {
    "before" => "插入到上方"
    "after" => "插入到下方"
    "inside" => "作为子节点"
    _ => ""
  }
}

///|
fn schedule_node_drag_auto_pan() -> Unit {
  if drag_auto_pan_frame.val != 0 {
    return
  }
  let window = @dom.window()
  drag_auto_pan_frame.val = window.requestAnimationFrame(fn(_) {
    drag_auto_pan_frame.val = 0
    if drag_active.val && drag_source_node.val >= 0 {
      apply_node_drag_auto_pan()
      schedule_node_drag_auto_pan()
    }
  })
}

///|
fn cancel_node_drag_auto_pan() -> Unit {
  if drag_auto_pan_frame.val != 0 {
    @dom.window().cancelAnimationFrame(drag_auto_pan_frame.val)
    drag_auto_pan_frame.val = 0
  }
}

///|
fn apply_node_drag_auto_pan() -> Unit {
  match get_element("#mindmap") {
    Some(mindmap) => {
      let rect = element_rect(mindmap)
      let delta_x = node_drag_auto_pan_delta(
        drag_last_x.val.to_double(),
        rect.left,
        rect.right,
      )
      let delta_y = node_drag_auto_pan_delta(
        drag_last_y.val.to_double(),
        rect.top,
        rect.bottom,
      )
      if delta_x == 0 && delta_y == 0 {
        return
      }
      let current_pan_x = parse_int_or_default(
        mindmap.getAttribute("data-pan-x").unwrap_or("0"),
        0,
      )
      let current_pan_y = parse_int_or_default(
        mindmap.getAttribute("data-pan-y").unwrap_or("0"),
        0,
      )
      mindmap.setAttribute("data-pan-x", (current_pan_x + delta_x).to_string())
      mindmap.setAttribute("data-pan-y", (current_pan_y + delta_y).to_string())
      mindmap_sync_view(
        mindmap,
        get_element("#zoom-value"),
        get_element("#zoom-edit"),
      )
      update_node_drag_target_at(
        drag_last_x.val.to_double(),
        drag_last_y.val.to_double(),
      )
      update_node_drag_ghost()
    }
    None => ()
  }
}

///|
fn node_drag_auto_pan_delta(
  pointer : Double,
  start : Double,
  end : Double,
) -> Int {
  let margin = 72.0
  let min_speed = 2.0
  let max_speed = 18.0
  if end <= start || pointer != pointer {
    return 0
  }
  if pointer < start + margin {
    let intensity = min_double(
      1.0,
      max_double(0.0, (start + margin - pointer) / margin),
    )
    return (min_speed + (max_speed - min_speed) * intensity).round().to_int()
  }
  if pointer > end - margin {
    let intensity = min_double(
      1.0,
      max_double(0.0, (pointer - (end - margin)) / margin),
    )
    return -(min_speed + (max_speed - min_speed) * intensity).round().to_int()
  }
  0
}

///|
fn update_node_drag_target_at(client_x : Double, client_y : Double) -> Unit {
  match drag_target_node_from_point_at(client_x, client_y) {
    Some(target) => {
      let target_index = parse_int_or_default(
        target.getAttribute("data-node-index").unwrap_or("-2"),
        -2,
      )
      let kind = drag_drop_kind_for_point(target, client_x, client_y)
      if is_valid_drag_drop_target(target_index, kind) {
        set_current_drag_drop(kind, target_index)
        render_node_drag_feedback(target_index, kind)
      } else {
        clear_current_drag_drop()
        clear_node_drop_feedback()
      }
    }
    None => {
      clear_current_drag_drop()
      clear_node_drop_feedback()
    }
  }
}

///|
fn drag_target_node_from_point_at(
  client_x : Double,
  client_y : Double,
) -> @dom.Element? {
  for element in @dom.document().elementsFromPoint(client_x, client_y) {
    match element.closest(".node[data-node-index]") {
      Some(node) => return Some(node)
      None => ()
    }
  }
  None
}

///|
fn drag_drop_kind_for_point(
  node : @dom.Element,
  client_x : Double,
  client_y : Double,
) -> String {
  let rect = element_rect(node)
  if app_state.layout_mode == "tree" {
    let ratio = if rect.width <= 0.0 {
      0.5
    } else {
      (client_x - rect.left) / rect.width
    }
    drag_drop_kind_from_ratio(ratio)
  } else {
    let ratio = if rect.height <= 0.0 {
      0.5
    } else {
      (client_y - rect.top) / rect.height
    }
    drag_drop_kind_from_ratio(ratio)
  }
}

///|
fn drag_drop_kind_from_ratio(ratio : Double) -> String {
  if ratio < 0.30 {
    "before"
  } else if ratio > 0.70 {
    "after"
  } else {
    "inside"
  }
}

///|
fn is_valid_drag_drop_target(target_index : Int, kind : String) -> Bool {
  if drag_source_node.val < 0 {
    return false
  }
  if kind != "inside" && target_index < 0 {
    return false
  }
  if kind != "inside" && is_fixed_root_node(target_index) {
    return false
  }
  if target_index == drag_source_node.val {
    return false
  }
  if target_index >= 0 && drag_target_inside_source_subtree(target_index) {
    return false
  }
  kind == "before" || kind == "after" || kind == "inside"
}

///|
fn is_fixed_root_node(node_index : Int) -> Bool {
  !app_state.root.synthetic && node_index == app_state.root.flat_index
}

///|
fn drag_target_inside_source_subtree(target_index : Int) -> Bool {
  match find_node(app_state.root, drag_source_node.val) {
    Some(source) => outline_contains_node(source, target_index)
    None => false
  }
}

///|
fn outline_contains_node(node : OutlineNode, target_index : Int) -> Bool {
  if node.flat_index == target_index {
    return true
  }
  for child in node.children {
    if outline_contains_node(child, target_index) {
      return true
    }
  }
  false
}

///|
fn set_current_drag_drop(kind : String, target_index : Int) -> Unit {
  drag_drop_kind.val = kind
  drag_drop_target.val = target_index
}

///|
fn clear_current_drag_drop() -> Unit {
  drag_drop_kind.val = ""
  drag_drop_target.val = -2
}

///|
fn current_node_drag_placement() -> DropPlacement? {
  match drag_drop_kind.val {
    "before" => Some(DropBefore(drag_drop_target.val))
    "after" => Some(DropAfter(drag_drop_target.val))
    "inside" => Some(DropInside(drag_drop_target.val))
    _ => None
  }
}

///|
fn render_node_drag_feedback(target_index : Int, kind : String) -> Unit {
  clear_node_drop_feedback()
  match get_element(".node[data-node-index=\"\{target_index}\"]") {
    Some(node) => {
      let class_name = match kind {
        "before" => "drop-before"
        "after" => "drop-after"
        "inside" => "drop-inside"
        _ => ""
      }
      if class_name.length() > 0 {
        toggle_class(node, class_name, true)
      }
    }
    None => ()
  }
}

///|
fn clear_node_drop_feedback() -> Unit {
  for
    node in @dom.document().querySelectorAll(
      ".node.drop-before, .node.drop-after, .node.drop-inside",
    ) {
    toggle_class(node, "drop-before", false)
    toggle_class(node, "drop-after", false)
    toggle_class(node, "drop-inside", false)
    restore_node_drag_visual_style(node)
  }
}

///|
fn clear_node_drag_visuals() -> Unit {
  set_dragging_source_class(false)
  clear_node_drop_feedback()
  match get_element(".node-drag-ghost") {
    Some(ghost) => ghost.remove()
    None => ()
  }
}

///|
fn set_dragging_source_class(enabled : Bool) -> Unit {
  if drag_source_node.val < 0 {
    return
  }
  match get_element(".node[data-node-index=\"\{drag_source_node.val}\"]") {
    Some(node) => {
      toggle_class(node, "is-dragging", enabled)
      if !enabled {
        restore_node_drag_visual_style(node)
      }
    }
    None => ()
  }
}

///|
fn restore_node_drag_visual_style(node : @dom.Element) -> Unit {
  style_of(node).set_property("opacity", "1")
  apply_theme_to_element(node)
  let node_index = parse_int_or_default(
    node.getAttribute("data-node-index").unwrap_or("-1"),
    -1,
  )
  restore_node_width_override_style(node, node_index)
}

///|
fn apply_node_drag_drop(placement : DropPlacement) -> Bool {
  let source_index = drag_source_node.val
  if source_index < 0 {
    return false
  }
  let drop_kind = drag_drop_kind.val
  let drop_target = drag_drop_target.val
  let result = move_node_to_drop_placement(
    app_state.markdown,
    source_index,
    placement,
  )
  if !result.changed {
    return false
  }
  suppress_next_render_mindmap_reveal.val = true
  apply_markdown_change(result.markdown, false)
  select_single_node(result.selected_node, false)
  if drop_kind == "inside" && drop_target >= 0 {
    let mapped_target = result.index_map.get(drop_target).unwrap_or(drop_target)
    expand_node(mapped_target)
  }
  expand_node_path(result.selected_node)
  render_ui()
  true
}

///|
fn handle_add_child(node_index : Int) -> Unit {
  let title = "New node"
  undo_expand_node.val = node_index
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
  redo_expand_node.val = target_index
  apply_markdown_change(next_markdown, false)
  expand_node(node_index)
  if target_index >= 0 {
    select_single_node(target_index, false)
    begin_edit_node(target_index)
    editor_created_node.val = target_index
    return
  }
  sync_detail_customized()
  render_ui()
}

///|
fn handle_add_sibling(node_index : Int, place_after : Bool) -> Unit {
  let title = "New node"
  let undo_expand_target = match
    locate_tree_context(app_state.root, node_index) {
    Some((parent_index, _, _)) =>
      if parent_index >= 0 {
        parent_index
      } else {
        node_index
      }
    None => node_index
  }
  undo_expand_node.val = undo_expand_target
  if should_balance_first_layer_sibling_insert(node_index) {
    let (next_markdown, target_index) = add_balanced_first_layer_heading(title)
    redo_expand_node.val = target_index
    apply_markdown_change(next_markdown, false)
    if target_index >= 0 {
      select_single_node(target_index, false)
      begin_edit_node(target_index)
      editor_created_node.val = target_index
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
  redo_expand_node.val = target_index
  apply_markdown_change(next_markdown, false)
  if target_index >= 0 {
    select_single_node(target_index, false)
    begin_edit_node(target_index)
    editor_created_node.val = target_index
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
  if !can_delete_node(node_index) {
    return
  }
  undo_expand_node.val = match locate_tree_context(app_state.root, node_index) {
    Some((parent_index, _, _)) =>
      if parent_index >= 0 {
        parent_index
      } else {
        node_index
      }
    None => node_index
  }
  redo_expand_node.val = undo_expand_node.val
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
fn handle_keyboard_tree_navigation(
  direction : String,
  fallback_node_index : Int,
) -> Unit {
  let needs_render = tree_navigation_needs_render(
    direction, fallback_node_index,
  )
  if handle_tree_navigation(direction, fallback_node_index) {
    app_state.reveal_selected_line = true
    if needs_render {
      render_ui()
    } else {
      sync_selection_ui()
    }
  }
}

///|
fn tree_navigation_needs_render(
  direction : String,
  fallback_node_index : Int,
) -> Bool {
  if direction != "ArrowRight" {
    return false
  }
  let current_index = if app_state.selected_node >= 0 {
    app_state.selected_node
  } else {
    fallback_node_index
  }
  if current_index < 0 || !is_collapsed(current_index) {
    return false
  }
  match find_node(app_state.root, current_index) {
    Some(node) => node.children.length() > 0
    None => false
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
  if editor_snapshot_node.val != node_index {
    return
  }
  let next_markdown = rename_heading(
    editor_draft_markdown.val,
    node_index,
    title,
  )
  if next_markdown != editor_draft_markdown.val {
    apply_editor_draft_markdown(next_markdown)
  }
  if editor_snapshot_markdown.val != app_state.markdown &&
    editor_created_node.val != node_index {
    push_undo_history(editor_snapshot_markdown.val, node_index, node_index)
    clear_redo_history()
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
    Some(node) =>
      if node.body.length() > 0 {
        begin_body_block_edit_node(app_state.selected_node, 0)
        return
      }
    None => return
  }
  insert_node_body_template("note")
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
fn clear_editing_session() -> Unit {
  editor_snapshot_node.val = -1
  editor_snapshot_markdown.val = ""
  editor_draft_markdown.val = ""
  editor_undo_stack.val = []
  editor_redo_stack.val = []
  editor_created_node.val = -2
  clear_note_editing_session()
  clear_body_block_editing_session()
}

///|
fn clear_note_editing_session() -> Unit {
  note_editor_snapshot_node.val = -1
  note_editor_snapshot_markdown.val = ""
  note_editor_draft_markdown.val = ""
  note_editor_undo_stack.val = []
  note_editor_redo_stack.val = []
  app_state.editing_note_node = -2
}

///|
fn clear_body_block_editing_session() -> Unit {
  app_state.editing_body_node = -2
  app_state.editing_body_block = -1
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
  let next_undo = slice_strings(
    note_editor_undo_stack.val,
    0,
    note_editor_undo_stack.val.length(),
  )
  next_undo.push(current_markdown)
  note_editor_undo_stack.val = next_undo
  note_editor_redo_stack.val = []
  apply_note_editor_draft_markdown(next_markdown)
}

///|
fn save_note_editor(node_index : Int, body_text : String) -> Unit {
  if note_editor_snapshot_node.val != node_index {
    return
  }
  sync_note_editor_draft(node_index, body_text)
  if note_editor_snapshot_markdown.val != app_state.markdown {
    push_undo_history(note_editor_snapshot_markdown.val, node_index, node_index)
    clear_redo_history()
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
fn toggle_note_body(node_index : Int) -> Unit {
  if node_index < 0 {
    return
  }
  clear_body_block_editing_session()
  if is_note_body_collapsed(node_index) {
    app_state.collapsed_note_nodes = remove_int(
      app_state.collapsed_note_nodes,
      node_index,
    )
  } else {
    app_state.collapsed_note_nodes = append_unique_int(
      app_state.collapsed_note_nodes,
      node_index,
    )
  }
  select_single_node(node_index, false)
  render_ui()
}

///|
fn is_note_body_collapsed(node_index : Int) -> Bool {
  contains_int(app_state.collapsed_note_nodes, node_index)
}

///|
fn markdown_body_block_line_count(block : String) -> Int {
  block.split("\n").to_array().length()
}

///|
fn is_single_line_body_block(block : String) -> Bool {
  markdown_body_block_line_count(block) <= 1
}

///|
fn body_block_uses_centered_actions(block : String) -> Bool {
  is_single_line_body_block(block) && body_block_kind(block) != "image"
}

///|
fn body_block_compact_action_height_threshold() -> Double {
  52.0
}

///|
fn node_body_block_layout_class(block : String) -> String {
  if body_block_uses_centered_actions(block) {
    " node-body-block--single-line"
  } else {
    ""
  }
}

///|
fn node_body_block_actions_class(block : String) -> String {
  if body_block_uses_centered_actions(block) {
    "node-body-block-actions node-body-block-actions--single-line"
  } else {
    "node-body-block-actions"
  }
}

///|
fn markdown_node_body_block_line_range(
  node : MarkdownNode,
  block_index : Int,
) -> (Int, Int)? {
  if block_index < 0 ||
    block_index >= node.body.length() ||
    node.source_line < 0 {
    return None
  }
  let mut line = node.source_line + 1
  for index in 0..<block_index {
    line += node.body_blank_lines
      .get(index)
      .unwrap_or(default_body_blank_line_count(index))
    line += markdown_body_block_line_count(node.body[index])
  }
  line += node.body_blank_lines
    .get(block_index)
    .unwrap_or(default_body_blank_line_count(block_index))
  let block_line_count = markdown_body_block_line_count(node.body[block_index])
  let end_line = line + block_line_count - 1
  Some((line, end_line))
}

///|
fn node_body_block_line_range(
  node : OutlineNode,
  block_index : Int,
) -> (Int, Int)? {
  let nodes = parse_markdown_nodes(app_state.markdown)
  if node.flat_index < 0 || node.flat_index >= nodes.length() {
    return None
  }
  markdown_node_body_block_line_range(nodes[node.flat_index], block_index)
}

///|
fn begin_body_block_edit_node(node_index : Int, block_index : Int) -> Unit {
  if node_index < 0 || block_index < 0 {
    return
  }
  match find_node(app_state.root, node_index) {
    Some(node) => {
      if block_index >= node.body.length() {
        return
      }
      if body_block_kind(node.body[block_index]) == "image" {
        clear_editing_session()
        app_state.editing_node = -2
        clear_note_editing_session()
        app_state.collapsed_note_nodes = remove_int(
          app_state.collapsed_note_nodes,
          node_index,
        )
        app_state.editing_body_node = node_index
        app_state.editing_body_block = block_index
        select_single_node(node_index, false)
        render_ui()
        return
      }
      clear_editing_session()
      app_state.editing_node = -2
      clear_note_editing_session()
      clear_body_block_editing_session()
      select_single_node(node_index, false)
      sync_selection_ui()
      if app_state.started {
        match node_body_block_line_range(node, block_index) {
          Some((start_line, end_line)) =>
            focus_input_line_range(start_line, end_line)
          None => ()
        }
      }
    }
    None => ()
  }
}

///|
fn cancel_body_block_editor() -> Unit {
  clear_body_block_editing_session()
  render_ui()
}

///|
fn save_body_block_editor(
  node_index : Int,
  block_index : Int,
  block_text : String,
) -> Unit {
  if app_state.editing_body_node != node_index ||
    app_state.editing_body_block != block_index {
    return
  }
  let next_markdown = update_node_body_block(
    app_state.markdown,
    node_index,
    block_index,
    block_text,
  )
  clear_body_block_editing_session()
  if next_markdown != app_state.markdown {
    apply_markdown_change(next_markdown, false)
    select_single_node(node_index, false)
  } else {
    render_ui()
  }
}

///|
fn delete_body_block(node_index : Int, block_index : Int) -> Unit {
  if node_index < 0 || block_index < 0 {
    return
  }
  let next_markdown = delete_node_body_block(
    app_state.markdown,
    node_index,
    block_index,
  )
  clear_body_block_editing_session()
  if next_markdown != app_state.markdown {
    apply_markdown_change(next_markdown, false)
    match find_node(app_state.root, node_index) {
      Some(node) =>
        if node_has_note(node) {
          select_single_node(node_index, false)
        }
      None => ()
    }
  }
}

///|
fn note_editor_undo(node_index : Int) -> Unit {
  if app_state.editing_note_node != node_index ||
    note_editor_undo_stack.val.length() == 0 {
    return
  }
  let last_index = note_editor_undo_stack.val.length() - 1
  let previous = note_editor_undo_stack.val[last_index]
  let next_redo = slice_strings(
    note_editor_redo_stack.val,
    0,
    note_editor_redo_stack.val.length(),
  )
  next_redo.push(note_editor_draft_markdown.val)
  note_editor_redo_stack.val = next_redo
  note_editor_undo_stack.val = slice_strings(
    note_editor_undo_stack.val,
    0,
    last_index,
  )
  apply_note_editor_draft_markdown(previous)
  sync_note_editor_input_value(node_index)
}

///|
fn note_editor_redo(node_index : Int) -> Unit {
  if app_state.editing_note_node != node_index ||
    note_editor_redo_stack.val.length() == 0 {
    return
  }
  let last_index = note_editor_redo_stack.val.length() - 1
  let next_markdown = note_editor_redo_stack.val[last_index]
  let next_undo = slice_strings(
    note_editor_undo_stack.val,
    0,
    note_editor_undo_stack.val.length(),
  )
  next_undo.push(note_editor_draft_markdown.val)
  note_editor_undo_stack.val = next_undo
  note_editor_redo_stack.val = slice_strings(
    note_editor_redo_stack.val,
    0,
    last_index,
  )
  apply_note_editor_draft_markdown(next_markdown)
  sync_note_editor_input_value(node_index)
}

///|
fn editor_undo(node_index : Int) -> Unit {
  if app_state.editing_node != node_index {
    return
  }
  if editor_undo_stack.val.length() == 0 {
    if editor_created_node.val == node_index {
      clear_editing_session()
      app_state.editing_node = -2
      handle_undo()
    }
    return
  }
  let last_index = editor_undo_stack.val.length() - 1
  let previous = editor_undo_stack.val[last_index]
  if editor_created_node.val == node_index &&
    previous == editor_snapshot_markdown.val {
    clear_editing_session()
    app_state.editing_node = -2
    handle_undo()
    return
  }
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
fn sync_note_editor_input_value(node_index : Int) -> Unit {
  if !app_state.started {
    return
  }
  match get_element("[data-note-editor-for=\"\{node_index}\"]") {
    Some(element) => {
      let body_text = match find_node(app_state.root, node_index) {
        Some(node) => node.body.join("\n\n")
        None => ""
      }
      @dom.HTMLTextAreaElement::cast_from_element(element).value = body_text
    }
    None => ()
  }
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
  if next_markdown == app_state.markdown {
    return
  }
  suppress_next_render_mindmap_reveal.val = true
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
  let expanded_node = undo_expand_stack.val[last_index]
  let redo_expanded_node = undo_redo_expand_stack.val[last_index]
  app_state.undo_stack = slice_history_snapshots(
    app_state.undo_stack,
    0,
    last_index,
  )
  undo_expand_stack.val = slice_ints(undo_expand_stack.val, 0, last_index)
  undo_redo_expand_stack.val = slice_ints(
    undo_redo_expand_stack.val,
    0,
    last_index,
  )
  push_redo_snapshot(
    current_history_snapshot(),
    redo_expanded_node,
    expanded_node,
  )
  restore_history_snapshot(previous, expanded_node)
  expand_node_path(expanded_node)
  sync_detail_customized()
  if app_state.started {
    render_ui()
  }
}

///|
fn handle_redo() -> Unit {
  if app_state.redo_stack.length() == 0 {
    return
  }
  let last_index = app_state.redo_stack.length() - 1
  let next_snapshot = app_state.redo_stack[last_index]
  let expanded_node = redo_expand_stack.val[last_index]
  let undo_expanded_node = redo_undo_expand_stack.val[last_index]
  app_state.redo_stack = slice_history_snapshots(
    app_state.redo_stack,
    0,
    last_index,
  )
  redo_expand_stack.val = slice_ints(redo_expand_stack.val, 0, last_index)
  redo_undo_expand_stack.val = slice_ints(
    redo_undo_expand_stack.val,
    0,
    last_index,
  )
  push_undo_snapshot(
    current_history_snapshot(),
    undo_expanded_node,
    expanded_node,
  )
  restore_history_snapshot(next_snapshot, expanded_node)
  expand_node_path(expanded_node)
  sync_detail_customized()
  if app_state.started {
    render_ui()
  }
}

///|
fn handle_undo_action() -> Unit {
  if app_state.editing_node >= 0 {
    editor_undo(app_state.editing_node)
    return
  }
  if app_state.editing_note_node >= 0 {
    note_editor_undo(app_state.editing_note_node)
    return
  }
  handle_undo()
}

///|
fn handle_redo_action() -> Unit {
  if app_state.editing_node >= 0 {
    editor_redo(app_state.editing_node)
    return
  }
  if app_state.editing_note_node >= 0 {
    note_editor_redo(app_state.editing_note_node)
    return
  }
  handle_redo()
}

///|
fn apply_markdown_change(markdown : String, reset_ui : Bool) -> Unit {
  if markdown == app_state.markdown {
    if reset_ui {
      apply_markdown_state(markdown, true, false)
    }
    clear_pending_history_targets()
    return
  }
  if app_state.markdown.length() > 0 || markdown.length() > 0 {
    let undo_target = consume_pending_undo_expand(app_state.selected_node)
    let redo_target = consume_pending_redo_expand(undo_target)
    push_undo_history(app_state.markdown, undo_target, redo_target)
  } else {
    clear_pending_history_targets()
  }
  clear_redo_history()
  apply_markdown_state(markdown, reset_ui, false)
}

///|
fn reset_history() -> Unit {
  app_state.undo_stack = []
  app_state.redo_stack = []
  undo_expand_stack.val = []
  undo_redo_expand_stack.val = []
  redo_expand_stack.val = []
  redo_undo_expand_stack.val = []
  undo_expand_node.val = -2
  redo_expand_node.val = -2
}

///|
fn push_undo_history(
  markdown : String,
  undo_expand_target : Int,
  redo_expand_target : Int,
) -> Unit {
  push_undo_snapshot(
    HistorySnapshot::{
      markdown,
      node_width_overrides: copy_node_width_overrides(
        app_state.node_width_overrides,
      ),
      selected_node: app_state.selected_node,
    },
    undo_expand_target,
    redo_expand_target,
  )
}

///|
fn push_undo_snapshot(
  snapshot : HistorySnapshot,
  undo_expand_target : Int,
  redo_expand_target : Int,
) -> Unit {
  app_state.undo_stack.push(copy_history_snapshot(snapshot))
  undo_expand_stack.val = append_int(undo_expand_stack.val, undo_expand_target)
  undo_redo_expand_stack.val = append_int(
    undo_redo_expand_stack.val,
    redo_expand_target,
  )
}

///|
fn push_redo_snapshot(
  snapshot : HistorySnapshot,
  redo_expand_target : Int,
  undo_expand_target : Int,
) -> Unit {
  app_state.redo_stack.push(copy_history_snapshot(snapshot))
  redo_expand_stack.val = append_int(redo_expand_stack.val, redo_expand_target)
  redo_undo_expand_stack.val = append_int(
    redo_undo_expand_stack.val,
    undo_expand_target,
  )
}

///|
fn clear_redo_history() -> Unit {
  app_state.redo_stack = []
  redo_expand_stack.val = []
  redo_undo_expand_stack.val = []
}

///|
fn current_history_snapshot() -> HistorySnapshot {
  HistorySnapshot::{
    markdown: app_state.markdown,
    node_width_overrides: copy_node_width_overrides(
      app_state.node_width_overrides,
    ),
    selected_node: app_state.selected_node,
  }
}

///|
fn copy_history_snapshot(snapshot : HistorySnapshot) -> HistorySnapshot {
  HistorySnapshot::{
    markdown: snapshot.markdown,
    node_width_overrides: copy_node_width_overrides(
      snapshot.node_width_overrides,
    ),
    selected_node: snapshot.selected_node,
  }
}

///|
fn restore_history_snapshot(
  snapshot : HistorySnapshot,
  fallback_selected : Int,
) -> Unit {
  load_markdown(snapshot.markdown, false)
  app_state.node_width_overrides = sanitize_node_width_overrides(
    snapshot.node_width_overrides,
  )
  let selected = if snapshot.selected_node >= 0 {
    snapshot.selected_node
  } else {
    fallback_selected
  }
  if selected >= 0 && find_node(app_state.root, selected) is Some(_) {
    select_single_node(selected, false)
  } else {
    clear_selected_nodes()
  }
}

///|
fn consume_pending_undo_expand(fallback : Int) -> Int {
  let target = if undo_expand_node.val >= 0 {
    undo_expand_node.val
  } else {
    fallback
  }
  undo_expand_node.val = -2
  target
}

///|
fn consume_pending_redo_expand(fallback : Int) -> Int {
  let target = if redo_expand_node.val >= 0 {
    redo_expand_node.val
  } else {
    fallback
  }
  redo_expand_node.val = -2
  target
}

///|
fn clear_pending_history_targets() -> Unit {
  undo_expand_node.val = -2
  redo_expand_node.val = -2
}

///|
fn can_undo_action() -> Bool {
  if app_state.editing_node >= 0 {
    return editor_undo_stack.val.length() > 0 ||
      editor_created_node.val == app_state.editing_node
  }
  if app_state.editing_note_node >= 0 {
    return note_editor_undo_stack.val.length() > 0
  }
  app_state.undo_stack.length() > 0
}

///|
fn can_redo_action() -> Bool {
  if app_state.editing_node >= 0 {
    return editor_redo_stack.val.length() > 0
  }
  if app_state.editing_note_node >= 0 {
    return note_editor_redo_stack.val.length() > 0
  }
  app_state.redo_stack.length() > 0
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
fn can_delete_selected() -> Bool {
  can_delete_node(app_state.selected_node)
}

///|
fn can_delete_node(node_index : Int) -> Bool {
  if node_index < 0 {
    return false
  }
  if !app_state.root.synthetic && node_index == app_state.root.flat_index {
    return false
  }
  match find_node(app_state.root, node_index) {
    Some(node) => !node.synthetic
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
    app_state.collapsed_note_nodes = []
  }
  app_state.markdown = markdown
  app_state.root = build_outline(markdown)
  if reset_ui {
    app_state.node_width_overrides = []
  }
  app_state.node_width_overrides = sanitize_node_width_overrides(
    app_state.node_width_overrides,
  )
  if reset_ui {
    apply_detail_preset()
    app_state.root_split_count = default_root_split_count(app_state.root)
  } else {
    sanitize_collapsed_state()
    sanitize_note_collapsed_state()
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
    suppress_next_render_mindmap_reveal.val = false
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
  set_aux_action_enabled("undo-action", can_undo_action())
  set_aux_action_enabled("redo-action", can_redo_action())
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
  if suppress_next_render_mindmap_reveal.val {
    suppress_next_render_mindmap_reveal.val = false
  } else {
    schedule_mindmap_reveal_node(app_state.selected_node)
  }
}

///|
fn sync_selection_ui() -> Unit {
  if !app_state.started {
    return
  }
  sync_selection_toolbar()
  set_aux_action_enabled("undo-action", can_undo_action())
  set_aux_action_enabled("redo-action", can_redo_action())
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
        let selected = is_selected_node(node_index)
        toggle_class(node, "is-selected", selected)
        restore_node_width_override_style(node, node_index)
        sync_node_width_resize_handle(node, node_index, selected)
      }
    None => ()
  }
}

///|
fn sync_node_width_resize_handle(
  node : @dom.Element,
  node_index : Int,
  selected : Bool,
) -> Unit {
  match node.querySelector(".node-width-resize-handle") {
    Some(handle) =>
      if !should_show_node_width_resize_handle(node_index, selected) {
        handle.remove()
      }
    None =>
      if should_show_node_width_resize_handle(node_index, selected) {
        append_child(node, build_node_width_resize_handle_dom(node_index))
      }
  }
}

///|
fn should_show_node_width_resize_handle(
  node_index : Int,
  selected : Bool,
) -> Bool {
  selected && node_index >= 0 && app_state.editing_node != node_index
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
fn copy_node_width_overrides(
  values : Array[NodeWidthOverride],
) -> Array[NodeWidthOverride] {
  let next = []
  for value in values {
    next.push(NodeWidthOverride::{
      node_index: value.node_index,
      width: value.width,
    })
  }
  next
}

///|
fn sanitize_node_width_overrides(
  values : Array[NodeWidthOverride],
) -> Array[NodeWidthOverride] {
  let next = []
  for value in values {
    if find_node(app_state.root, value.node_index) is Some(_) {
      next.push(NodeWidthOverride::{
        node_index: value.node_index,
        width: normalize_node_width(value.width),
      })
    }
  }
  next
}

///|
fn normalize_node_width(width : Int) -> Int {
  if width < 96 {
    96
  } else if width > 520 {
    520
  } else {
    width
  }
}

///|
fn node_width_override_value(node_index : Int) -> Int? {
  for value in app_state.node_width_overrides {
    if value.node_index == node_index {
      return Some(value.width)
    }
  }
  None
}

///|
fn set_node_width_override(node_index : Int, width : Int) -> Unit {
  let normalized = normalize_node_width(width)
  let next = []
  let mut found = false
  for value in app_state.node_width_overrides {
    if value.node_index == node_index {
      next.push(NodeWidthOverride::{ node_index, width: normalized })
      found = true
    } else {
      next.push(value)
    }
  }
  if !found {
    next.push(NodeWidthOverride::{ node_index, width: normalized })
  }
  app_state.node_width_overrides = next
}

///|
fn apply_node_width_to_dom(node_index : Int, width : Int) -> Unit {
  match get_element(".node[data-node-index=\"\{node_index}\"]") {
    Some(node) => apply_node_width_style(node, width)
    None => ()
  }
}

///|
fn restore_node_width_override_style(
  element : @dom.Element,
  node_index : Int,
) -> Unit {
  match node_width_override_value(node_index) {
    Some(width) => apply_node_width_style(element, width)
    None => ()
  }
}

///|
fn apply_node_width_style(element : @dom.Element, width : Int) -> Unit {
  let style = style_of(element)
  let value = "\{normalize_node_width(width)}px"
  style.set_property("width", value)
  style.set_property("min-width", value)
  style.set_property("max-width", value)
}

///|
fn render_node_width_style_attr(node_index : Int) -> String {
  match node_width_override_value(node_index) {
    Some(width) => {
      let value = "\{normalize_node_width(width)}px"
      " style=\"width:\{value};min-width:\{value};max-width:\{value};\""
    }
    None => ""
  }
}

///|
fn append_int(values : Array[Int], target : Int) -> Array[Int] {
  let next = copy_ints(values)
  next.push(target)
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
  match action {
    "undo" => can_undo_action()
    "redo" => can_redo_action()
    _ =>
      if app_state.selected_node < 0 {
        false
      } else {
        match action {
          "new-branch" => can_add_sibling_selected()
          "new-child" => selected_node_exists()
          "delete-node" => can_delete_selected()
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
          "insert-image" => selected_node_exists()
          "insert-code" => selected_node_exists()
          "insert-table" => selected_node_exists()
          _ => false
        }
      }
  }
}

///|
fn insert_node_body_template(kind : String) -> Unit {
  if app_state.selected_node < 0 {
    return
  }
  let node_index = app_state.selected_node
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
  if node_index >= nodes.length() {
    return
  }
  let inserted_block_index = nodes[node_index].body.length()
  let updated = []
  for index in 0..<nodes.length() {
    let node = nodes[index]
    if index == node_index {
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
  app_state.collapsed_note_nodes = remove_int(
    app_state.collapsed_note_nodes,
    node_index,
  )
  apply_markdown_change(render_markdown_nodes(updated), false)
  begin_body_block_edit_node(node_index, inserted_block_index)
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
  append_child(branch, build_node_spacing_slot_dom())
  append_branch_logic_parts(
    branch, node, parent_index, false, direction, tone_index,
  )
  append_child(branch, build_node_spacing_slot_dom())
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
  append_child(branch, build_node_spacing_slot_dom())
  append_branch_logic_parts(
    branch, node, parent_index, false, direction, tone_index,
  )
  append_child(branch, build_node_spacing_slot_dom())
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
  let tree = create_element("div", vertical_tree_class(node))
  tree.setAttribute("data-node-index", node.flat_index.to_string())
  tree.setAttribute("data-parent-index", parent_index.to_string())
  append_child(tree, build_node_spacing_slot_dom())
  append_child(
    tree,
    build_node_card_dom(
      node, parent_index, is_root, tone_index, "node-actions--bottom-center",
    ),
  )
  append_child(tree, build_node_spacing_slot_dom())
  append_child(tree, build_vertical_children_dom(node, tone_index))
  tree
}

///|
fn build_vertical_children_dom(
  node : OutlineNode,
  tone_index : Int,
) -> @dom.Element {
  let children = create_element("div", vertical_tree_children_class())
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
    let child_wrap = create_element("div", vertical_tree_child_class(child))
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
  append_child(tree, build_node_spacing_slot_dom())
  let head = create_element("div", "single-right-tree__head")
  append_child(
    head,
    build_node_card_dom(
      node, parent_index, is_root, tone_index, "node-actions--right-mid",
    ),
  )
  append_child(tree, head)
  append_child(tree, build_node_spacing_slot_dom())
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
  let classes = ["node"]
  if is_center {
    classes.push("node--center")
  }
  if is_selected_node(node.flat_index) {
    classes.push("is-selected")
  }
  classes.push(render_node_style_class())
  if is_branch_line_tree_note(node) {
    classes.push("node--line-tree-note")
  }
  let card = create_element("div", classes.iter().join(" "))
  card.setAttribute("data-level", node.level.to_string())
  card.setAttribute("data-node-index", node.flat_index.to_string())
  card.setAttribute("data-parent-index", parent_index.to_string())
  apply_node_visual_attrs(card, node, tone_index)
  match node_width_override_value(node.flat_index) {
    Some(width) => apply_node_width_style(card, width)
    None => ()
  }
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
  if should_show_node_width_resize_handle(
      node.flat_index,
      is_selected_node(node.flat_index),
    ) &&
    !is_editing {
    append_child(card, build_node_width_resize_handle_dom(node.flat_index))
  }
  card
}

///|
fn build_node_width_resize_handle_dom(node_index : Int) -> @dom.Element {
  let handle = create_element("span", "node-width-resize-handle")
  handle.setAttribute("data-resize-node-index", node_index.to_string())
  handle.setAttribute("aria-hidden", "true")
  handle
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
    let title = create_element("strong", node_title_class())
    title.setAttribute(
      "data-title-depth",
      relative_node_depth(node).to_string(),
    )
    title.setAttribute(
      "data-title-center",
      (node.flat_index == app_state.root.flat_index).to_string(),
    )
    apply_theme_to_element(title)
    append_child(title, build_markdown_title_dom(node.title))
    title
  }
}

///|
fn node_title_class() -> String {
  if app_state.style_mode == "line" {
    "node-title node-title--scaled node-title--line"
  } else {
    "node-title node-title--scaled node-title--fill"
  }
}

///|
fn is_branch_line_tree_mode() -> Bool {
  app_state.style_mode == "line" && app_state.layout_mode == "tree"
}

///|
fn is_branch_line_tree_note(node : OutlineNode) -> Bool {
  is_branch_line_tree_mode() && node_has_note(node)
}

///|
fn vertical_tree_class(node : OutlineNode) -> String {
  if is_branch_line_tree_note(node) {
    "vertical-tree vertical-tree--line-note"
  } else {
    "vertical-tree"
  }
}

///|
fn vertical_tree_children_class() -> String {
  if is_branch_line_tree_mode() {
    "vertical-tree__children vertical-tree__children--line-tree"
  } else {
    "vertical-tree__children"
  }
}

///|
fn vertical_tree_child_class(node : OutlineNode) -> String {
  if is_branch_line_tree_note(node) {
    "vertical-tree__child vertical-tree__child--line-note"
  } else {
    "vertical-tree__child"
  }
}

///|
fn build_node_body_dom(node : OutlineNode) -> @dom.Element? {
  if !node_has_note(node) {
    return None
  }
  if is_note_body_collapsed(node.flat_index) {
    return None
  }
  let line_tree_class = if is_branch_line_tree_mode() {
    " node-body--line-tree"
  } else {
    ""
  }
  let image_only_class = if node_body_is_image_only(node) {
    " node-body--image-only"
  } else {
    ""
  }
  let body = create_element(
    "div",
    "node-body node-body-preview\{line_tree_class}\{image_only_class}",
  )
  apply_theme_to_element(body)
  body.setAttribute("data-note-preview-for", node.flat_index.to_string())
  for index in 0..<node.body.length() {
    append_child(body, build_node_body_block_dom(node, index))
  }
  Some(body)
}

///|
fn node_body_is_image_only(node : OutlineNode) -> Bool {
  if node.body.length() != 1 {
    return false
  }
  body_block_kind(node.body[0]) == "image"
}

///|
fn build_node_body_block_dom(
  node : OutlineNode,
  block_index : Int,
) -> @dom.Element {
  let block = node.body[block_index]
  let kind = body_block_kind(block)
  let is_editing = app_state.editing_body_node == node.flat_index &&
    app_state.editing_body_block == block_index
  let wrap = create_element(
    "div",
    "node-body-block node-body-block--\{kind}\{node_body_block_layout_class(block)}",
  )
  wrap.setAttribute("data-body-block-index", block_index.to_string())
  wrap.setAttribute("data-body-block-kind", kind)
  if is_editing {
    append_child(
      wrap,
      build_body_block_editor_dom(node, block_index, block, kind),
    )
  } else {
    let controls = build_body_block_controls_dom(block_index, block)
    bind_body_block_hover_controls(wrap, controls)
    append_child(wrap, controls)
    append_child(wrap, build_markdown_blocks_dom([block]))
  }
  wrap
}

///|
fn bind_body_block_hover_controls(
  block : @dom.Element,
  controls : @dom.Element,
) -> Unit {
  let show = fn() {
    update_body_block_controls_position(block, controls)
    let style = style_of(controls)
    style.set_property("opacity", "1")
    style.set_property("pointer-events", "auto")
  }
  let hide = fn() {
    let style = style_of(controls)
    style.set_property("opacity", "0")
    style.set_property("pointer-events", "none")
  }
  block.as_event_target().on("mouseenter", fn(_) { show() })
  block.as_event_target().on("mouseleave", fn(_) { hide() })
  controls.as_event_target().on("focusin", fn(_) { show() })
  controls.as_event_target().on("focusout", fn(_) { hide() })
}

///|
fn update_body_block_controls_position(
  block : @dom.Element,
  controls : @dom.Element,
) -> Unit {
  let kind = block.getAttribute("data-body-block-kind").unwrap_or("")
  let height = element_rect(block).height
  let compact = kind != "image" &&
    height > 0.0 &&
    height <= body_block_compact_action_height_threshold()
  let style = style_of(controls)
  if compact {
    style.set_property("top", "50%")
    style.set_property("bottom", "auto")
    style.set_property("transform", "translate(-50%, -50%)")
  } else {
    style.set_property("top", "auto")
    style.set_property("bottom", "8px")
    style.set_property("transform", "translateX(-50%)")
  }
}

///|
fn build_body_block_controls_dom(
  block_index : Int,
  block : String,
) -> @dom.Element {
  let controls = create_element("div", node_body_block_actions_class(block))
  controls.setAttribute("data-body-block-index", block_index.to_string())
  let edit = create_element("button", "node-body-block-action")
  edit.setAttribute("type", "button")
  edit.setAttribute("data-action", "edit-body-block")
  edit.setAttribute("data-body-block-index", block_index.to_string())
  edit.setAttribute("data-tip", "Edit")
  edit.setAttribute("aria-label", "Edit")
  edit.setInnerHTML(body_block_action_icon_html("edit"))
  let delete = create_element(
    "button", "node-body-block-action node-body-block-action--delete",
  )
  delete.setAttribute("type", "button")
  delete.setAttribute("data-action", "delete-body-block")
  delete.setAttribute("data-body-block-index", block_index.to_string())
  delete.setAttribute("data-tip", "Delete")
  delete.setAttribute("aria-label", "Delete")
  delete.setInnerHTML(body_block_action_icon_html("delete"))
  append_child(controls, edit)
  append_child(controls, delete)
  controls
}

///|
fn body_block_action_icon_html(kind : String) -> String {
  match kind {
    "delete" => {
      let common = "class=\"node-body-block-action-icon\" viewBox=\"0 0 24 24\" width=\"18\" height=\"18\" aria-hidden=\"true\" focusable=\"false\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.9\" stroke-linecap=\"round\" stroke-linejoin=\"round\""
      "<svg \{common}><circle cx=\"12\" cy=\"12\" r=\"9\"/><path d=\"M8.5 8.5l7 7\"/><path d=\"M15.5 8.5l-7 7\"/></svg>"
    }
    _ => {
      let common = "class=\"node-body-block-action-icon\" viewBox=\"0 0 24 24\" width=\"18\" height=\"18\" aria-hidden=\"true\" focusable=\"false\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.9\" stroke-linecap=\"round\" stroke-linejoin=\"round\""
      "<svg \{common}><path d=\"M5.5 18.5L6.5 14.7L15.8 5.4L18.6 8.2L9.3 17.5L5.5 18.5Z\"/><path d=\"M14.9 6.3L17.7 9.1\"/></svg>"
    }
  }
}

///|
fn build_body_block_editor_dom(
  node : OutlineNode,
  block_index : Int,
  block : String,
  kind : String,
) -> @dom.Element {
  let editor = create_element(
    "div",
    "node-body-block-editor node-body-block-editor--\{kind}",
  )
  editor.setAttribute("data-body-editor-for", node.flat_index.to_string())
  editor.setAttribute("data-body-editor-block", block_index.to_string())
  editor.setAttribute("data-body-editor-kind", kind)
  match kind {
    "image" => append_body_image_editor_fields(editor, block)
    "code" => append_body_code_editor_fields(editor, block)
    _ => append_body_text_editor_field(editor, block)
  }
  append_child(editor, build_body_block_editor_actions(block_index))
  editor
}

///|
fn append_body_text_editor_field(editor : @dom.Element, block : String) -> Unit {
  let textarea = create_element("textarea", "node-body-block-textarea")
  textarea.setAttribute("data-body-editor-value", "raw")
  textarea.setAttribute("rows", "4")
  @dom.HTMLTextAreaElement::cast_from_element(textarea).value = block
  append_child(editor, textarea)
}

///|
fn append_body_code_editor_fields(
  editor : @dom.Element,
  block : String,
) -> Unit {
  let parsed = parse_code_body_block(block)
  let lang = create_element("input", "node-body-block-input")
  lang.setAttribute("type", "text")
  lang.setAttribute("data-body-editor-value", "code-lang")
  lang.setAttribute("placeholder", "language")
  @dom.HTMLInputElement::cast_from_element(lang).value = parsed.0
  let textarea = create_element("textarea", "node-body-block-textarea")
  textarea.setAttribute("data-body-editor-value", "code-text")
  textarea.setAttribute("rows", "5")
  @dom.HTMLTextAreaElement::cast_from_element(textarea).value = parsed.1
  append_child(editor, lang)
  append_child(editor, textarea)
}

///|
fn append_body_image_editor_fields(
  editor : @dom.Element,
  block : String,
) -> Unit {
  let parsed = parse_image_body_block(block)
  let alt = create_element("input", "node-body-block-input")
  alt.setAttribute("type", "text")
  alt.setAttribute("data-body-editor-value", "image-alt")
  alt.setAttribute("placeholder", "alt")
  @dom.HTMLInputElement::cast_from_element(alt).value = parsed.0
  let url = create_element("input", "node-body-block-input")
  url.setAttribute("type", "text")
  url.setAttribute("data-body-editor-value", "image-url")
  url.setAttribute("placeholder", "url")
  @dom.HTMLInputElement::cast_from_element(url).value = parsed.1
  append_child(editor, alt)
  append_child(editor, url)
}

///|
fn build_body_block_editor_actions(block_index : Int) -> @dom.Element {
  let actions = create_element("div", "node-body-block-editor-actions")
  let save = create_element(
    "button", "node-body-block-editor-action node-body-block-editor-action--save",
  )
  save.setAttribute("type", "button")
  save.setAttribute("data-action", "save-body-block")
  save.setAttribute("data-body-block-index", block_index.to_string())
  save.setAttribute("aria-label", "Save")
  save.setTextContent("✔")
  let cancel = create_element(
    "button", "node-body-block-editor-action node-body-block-editor-action--secondary",
  )
  cancel.setAttribute("type", "button")
  cancel.setAttribute("data-action", "cancel-body-block")
  cancel.setAttribute("data-body-block-index", block_index.to_string())
  cancel.setAttribute("aria-label", "Cancel")
  cancel.setTextContent("❌")
  append_child(actions, save)
  append_child(actions, cancel)
  actions
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
  button.setAttribute(
    "aria-expanded",
    (!is_note_body_collapsed(node.flat_index)).to_string(),
  )
  button.setTextContent("...")
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
  let branch_line_actions_class = if app_state.style_mode == "line" {
    " node-actions--branch-line"
  } else {
    ""
  }
  let actions = create_element(
    "div",
    "node-actions \{action_anchor}\{branch_line_actions_class}",
  )
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
  let branch_line_class = if app_state.style_mode == "line" {
    " node-action--branch-line"
  } else {
    ""
  }
  let button = create_element(
    "button",
    "node-action node-action--toggle\{state_class}\{branch_line_class}",
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
fn body_block_editor_value_from_target(target : @dom.Element) -> String {
  match target.closest(".node-body-block-editor") {
    Some(editor) => {
      let kind = editor.getAttribute("data-body-editor-kind").unwrap_or("note")
      match kind {
        "image" => {
          let alt = editor_text_input_value(editor, "image-alt")
          let url = editor_text_input_value(editor, "image-url")
          "![\{alt}](\{url})"
        }
        "code" => {
          let lang = editor_text_input_value(editor, "code-lang")
          let code = editor_textarea_value(editor, "code-text")
          "```\{lang}\n\{code}\n```"
        }
        _ => editor_textarea_value(editor, "raw")
      }
    }
    None => ""
  }
}

///|
fn editor_textarea_value(editor : @dom.Element, field : String) -> String {
  match editor.querySelector("[data-body-editor-value=\"\{field}\"]") {
    Some(element) => @dom.HTMLTextAreaElement::cast_from_element(element).value
    None => ""
  }
}

///|
fn editor_text_input_value(editor : @dom.Element, field : String) -> String {
  match editor.querySelector("[data-body-editor-value=\"\{field}\"]") {
    Some(element) => @dom.HTMLInputElement::cast_from_element(element).value
    None => ""
  }
}

///|
fn body_block_kind(block : String) -> String {
  let trimmed = block.trim().to_string()
  if parse_image_body_block(trimmed).2 {
    "image"
  } else if parse_code_body_block(trimmed).2 {
    "code"
  } else if parse_markdown_table(trimmed) is Some(_) {
    "table"
  } else {
    "note"
  }
}

///|
fn parse_code_body_block(block : String) -> (String, String, Bool) {
  let trimmed = block.trim().to_string()
  if !trimmed.has_prefix("```") {
    return ("", block, false)
  }
  let lines = trimmed.split("\n").map(line => line.to_string()).to_array()
  if lines.length() < 2 ||
    !lines[lines.length() - 1].trim().to_string().has_prefix("```") {
    return ("", block, false)
  }
  let lang = lines[0][3:].to_string().trim().to_string()
  let code = []
  for index in 1..<(lines.length() - 1) {
    code.push(lines[index])
  }
  (lang, code.join("\n"), true)
}

///|
fn parse_image_body_block(block : String) -> (String, String, Bool) {
  let trimmed = block.trim().to_string()
  if !trimmed.has_prefix("![") || !trimmed.has_suffix(")") {
    return ("", "", false)
  }
  match find_markdown_from(trimmed, "](", 2) {
    Some(close_alt) => {
      let alt = trimmed[2:close_alt].to_string()
      let url_start = close_alt + 2
      if url_start > trimmed.length() - 1 {
        ("", "", false)
      } else {
        (alt, trimmed[url_start:trimmed.length() - 1].to_string(), true)
      }
    }
    None => ("", "", false)
  }
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
fn build_node_spacing_slot_dom() -> @dom.Element {
  let class_name = if app_state.layout_mode == "logic" {
    "node-spacing-slot node-spacing-slot--single-right"
  } else {
    "node-spacing-slot"
  }
  create_element("div", class_name)
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
  let before_slot = render_node_spacing_slot()
  let card = render_node_card(node, parent_index, false, tone_index)
  let after_slot = render_node_spacing_slot()
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
  let before_slot = render_node_spacing_slot()
  let card = render_node_card(node, parent_index, is_root, tone_index)
  let after_slot = render_node_spacing_slot()
  let children_html = render_vertical_children(node, tone_index)
  let class_name = vertical_tree_class(node)
  "<div class=\"\{class_name}\" data-node-index=\"\{node.flat_index}\" data-parent-index=\"\{parent_index}\">\{before_slot}\{card}\{after_slot}\{children_html}</div>"
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
    let class_name = vertical_tree_child_class(child)
    child_parts.push(
      "<div class=\"\{class_name}\"\{child_attrs}>\{child_html}</div>",
    )
  }
  let body = child_parts.join("")
  let class_name = vertical_tree_children_class()
  "<div class=\"\{class_name}\"\{wrapper_attrs}>\{body}</div>"
}

///|
fn render_single_right_tree(
  node : OutlineNode,
  parent_index : Int,
  is_root : Bool,
  tone_index : Int,
) -> String {
  let before_slot = render_node_spacing_slot()
  let card = render_node_card(node, parent_index, is_root, tone_index)
  let after_slot = render_node_spacing_slot()
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
  let classes = ["node"]
  if is_center {
    classes.push("node--center")
  }
  if is_selected_node(node.flat_index) {
    classes.push("is-selected")
  }
  classes.push(render_node_style_class())
  if is_branch_line_tree_note(node) {
    classes.push("node--line-tree-note")
  }
  let class_name = classes.join(" ")
  let title_html = render_node_title(node, is_editing)
  let note_html = render_node_note(node)
  let action_html = render_node_actions_with_note(
    node, has_children, editable, is_center,
  )
  let visual_attrs = render_node_visual_attrs(node, tone_index)
  let width_style = render_node_width_style_attr(node.flat_index)
  let resize_handle = if should_show_node_width_resize_handle(
      node.flat_index,
      is_selected_node(node.flat_index),
    ) &&
    !is_editing {
    render_node_width_resize_handle(node.flat_index)
  } else {
    ""
  }
  "<div class=\"\{class_name}\" data-level=\"\{node.level}\" data-node-index=\"\{node.flat_index}\" data-parent-index=\"\{parent_index}\"\{visual_attrs}\{width_style}>\{title_html}\{note_html}\{action_html}\{resize_handle}</div>"
}

///|
fn render_node_width_resize_handle(node_index : Int) -> String {
  "<span class=\"node-width-resize-handle\" data-resize-node-index=\"\{node_index}\" aria-hidden=\"true\"></span>"
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
fn render_node_title(node : OutlineNode, is_editing : Bool) -> String {
  if is_editing {
    let value = escape_html_attribute(node.title)
    return "<input class=\"node-editor\" data-editor-for=\"\{node.flat_index}\" type=\"text\" value=\"\{value}\" />"
  }
  let title = render_markdown_title_html(node.title)
  let class_name = node_title_class()
  let depth = relative_node_depth(node)
  let center = node.flat_index == app_state.root.flat_index
  "<strong class=\"\{class_name}\" data-title-depth=\"\{depth}\" data-title-center=\"\{center}\">\{title}</strong>"
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
  let expanded = (!is_note_body_collapsed(node.flat_index)).to_string()
  let note_button = "<button type=\"button\" class=\"node-action node-action--note\" data-action=\"toggle-note\" data-tip=\"Note\" aria-label=\"Note\" aria-expanded=\"\{expanded}\">...</button>"
  let body = if is_note_body_collapsed(node.flat_index) {
    ""
  } else {
    let line_tree_class = if is_branch_line_tree_mode() {
      " node-body--line-tree"
    } else {
      ""
    }
    let image_only_class = if node_body_is_image_only(node) {
      " node-body--image-only"
    } else {
      ""
    }
    let blocks = []
    for index in 0..<node.body.length() {
      blocks.push(render_node_body_block(node, index))
    }
    let blocks_html = blocks.join("")
    "<div class=\"node-body node-body-preview\{line_tree_class}\{image_only_class}\" data-note-preview-for=\"\{node.flat_index}\">\{blocks_html}</div>"
  }
  "<div class=\"node-note-rail\">\{note_button}\{body}</div>"
}

///|
fn render_node_body_block(node : OutlineNode, block_index : Int) -> String {
  let block = node.body[block_index]
  let kind = body_block_kind(block)
  if app_state.editing_body_node == node.flat_index &&
    app_state.editing_body_block == block_index {
    render_body_block_editor(node, block_index, block, kind)
  } else {
    let edit_icon = body_block_action_icon_html("edit")
    let delete_icon = body_block_action_icon_html("delete")
    let controls_class = node_body_block_actions_class(block)
    let controls = "<div class=\"\{controls_class}\" data-body-block-index=\"\{block_index}\"><button type=\"button\" class=\"node-body-block-action\" data-action=\"edit-body-block\" data-body-block-index=\"\{block_index}\" data-tip=\"Edit\" aria-label=\"Edit\">\{edit_icon}</button><button type=\"button\" class=\"node-body-block-action node-body-block-action--delete\" data-action=\"delete-body-block\" data-body-block-index=\"\{block_index}\" data-tip=\"Delete\" aria-label=\"Delete\">\{delete_icon}</button></div>"
    "<div class=\"node-body-block node-body-block--\{kind}\{node_body_block_layout_class(block)}\" data-body-block-index=\"\{block_index}\" data-body-block-kind=\"\{kind}\">\{controls}<div class=\"markdown-blocks\">\{render_markdown_blocks_html([block])}</div></div>"
  }
}

///|
fn render_body_block_editor(
  node : OutlineNode,
  block_index : Int,
  block : String,
  kind : String,
) -> String {
  let fields = match kind {
    "image" => {
      let parsed = parse_image_body_block(block)
      "<input class=\"node-body-block-input\" type=\"text\" data-body-editor-value=\"image-alt\" placeholder=\"alt\" value=\"\{escape_html_attribute(parsed.0)}\" /><input class=\"node-body-block-input\" type=\"text\" data-body-editor-value=\"image-url\" placeholder=\"url\" value=\"\{escape_html_attribute(parsed.1)}\" />"
    }
    "code" => {
      let parsed = parse_code_body_block(block)
      "<input class=\"node-body-block-input\" type=\"text\" data-body-editor-value=\"code-lang\" placeholder=\"language\" value=\"\{escape_html_attribute(parsed.0)}\" /><textarea class=\"node-body-block-textarea\" data-body-editor-value=\"code-text\" rows=\"5\">\{escape_html(parsed.1)}</textarea>"
    }
    _ =>
      "<textarea class=\"node-body-block-textarea\" data-body-editor-value=\"raw\" rows=\"4\">\{escape_html(block)}</textarea>"
  }
  let actions = "<div class=\"node-body-block-editor-actions\"><button type=\"button\" class=\"node-body-block-editor-action node-body-block-editor-action--save\" data-action=\"save-body-block\" data-body-block-index=\"\{block_index}\" aria-label=\"Save\">✔</button><button type=\"button\" class=\"node-body-block-editor-action node-body-block-editor-action--secondary\" data-action=\"cancel-body-block\" data-body-block-index=\"\{block_index}\" aria-label=\"Cancel\">❌</button></div>"
  "<div class=\"node-body-block node-body-block--\{kind}\" data-body-block-index=\"\{block_index}\" data-body-block-kind=\"\{kind}\"><div class=\"node-body-block-editor node-body-block-editor--\{kind}\" data-body-editor-for=\"\{node.flat_index}\" data-body-editor-block=\"\{block_index}\" data-body-editor-kind=\"\{kind}\">\{fields}\{actions}</div></div>"
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
  let branch_line_class = if app_state.style_mode == "line" {
    " node-action--branch-line"
  } else {
    ""
  }
  let branch_line_actions_class = if app_state.style_mode == "line" {
    " node-actions--branch-line"
  } else {
    ""
  }
  "<div class=\"node-actions\{branch_line_actions_class}\"><button type=\"button\" class=\"node-action node-action--toggle\{state_class}\{branch_line_class}\" data-action=\"toggle\" data-tip=\"\{title}\" aria-label=\"\{title}\" aria-expanded=\"\{expanded}\">\{label}</button></div>"
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
  } else if app_state.style_mode == "line" {
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
  if !node_has_note(node) || is_note_body_collapsed(node.flat_index) {
    return 0
  }
  let mut line_count = 0
  let wrap_chars = if app_state.style_mode == "line" { 22 } else { 20 }
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
fn render_node_spacing_slot() -> String {
  let class_name = if app_state.layout_mode == "logic" {
    "node-spacing-slot node-spacing-slot--single-right"
  } else {
    "node-spacing-slot"
  }
  "<div class=\"\{class_name}\"></div>"
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
fn expand_node_path(node_index : Int) -> Unit {
  if node_index < 0 {
    return
  }
  expand_node(node_index)
  ignore(expand_ancestors_to_node(app_state.root, node_index))
}

///|
fn expand_ancestors_to_node(node : OutlineNode, target : Int) -> Bool {
  if node.flat_index == target {
    return true
  }
  for child in node.children {
    if expand_ancestors_to_node(child, target) {
      expand_node(node.flat_index)
      return true
    }
  }
  false
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
    "line" => "line"
    "full" | "fill" => "full"
    _ => "full"
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
  if app_state.style_mode == "line" {
    classes.push("mindmap-stage--fill")
    classes.push("mindmap-stage--branch-line")
  } else {
    classes.push("mindmap-stage--line")
  }
  classes.join(" ")
}

///|
fn render_node_style_class() -> String {
  if app_state.style_mode == "line" {
    if app_state.layout_mode == "tree" {
      "node--fill node--branch-line node--line-tree"
    } else {
      "node--fill node--branch-line"
    }
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
fn sanitize_note_collapsed_state() -> Unit {
  let next = []
  for node_index in app_state.collapsed_note_nodes {
    match find_node(app_state.root, node_index) {
      Some(node) => if node_has_note(node) { next.push(node_index) }
      None => ()
    }
  }
  app_state.collapsed_note_nodes = next
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
fn slice_history_snapshots(
  values : Array[HistorySnapshot],
  start : Int,
  end_ : Int,
) -> Array[HistorySnapshot] {
  let sliced = []
  for index in start..<end_ {
    sliced.push(copy_history_snapshot(values[index]))
  }
  sliced
}

///|
fn slice_ints(values : Array[Int], start : Int, end_ : Int) -> Array[Int] {
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

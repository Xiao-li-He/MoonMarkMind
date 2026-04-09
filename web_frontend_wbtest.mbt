///|
fn frontend_test_markdown() -> String {
  "# Root\n## Alpha\n## Beta"
}

///|
fn navigation_test_markdown() -> String {
  "# Root\n## Parent\n### Child A\n### Child B\n## Other"
}

///|
fn reset_frontend_test_state() -> Unit {
  reset_history()
  clear_editing_session()
  app_state.started = false
  app_state.document_name = "notes.md"
  app_state.collapsed = []
  app_state.hidden_nodes = []
  app_state.selected_node = -2
  app_state.selected_nodes = []
  app_state.selection_anchor_node = -2
  app_state.editing_node = -2
  app_state.root_split_count = 0
  app_state.reveal_selected_line = false
  app_state.drag_source_index = -1
  app_state.drag_source_parent = -2
  app_state.sample_variant = "custom"
  load_markdown(frontend_test_markdown(), true)
}

///|
fn reset_navigation_test_state() -> Unit {
  reset_history()
  clear_editing_session()
  app_state.started = false
  app_state.document_name = "notes.md"
  app_state.collapsed = []
  app_state.hidden_nodes = []
  app_state.selected_node = -2
  app_state.selected_nodes = []
  app_state.selection_anchor_node = -2
  app_state.editing_node = -2
  app_state.root_split_count = 0
  app_state.reveal_selected_line = false
  app_state.drag_source_index = -1
  app_state.drag_source_parent = -2
  app_state.sample_variant = "custom"
  load_markdown(navigation_test_markdown(), true)
}

///|
fn title_at(node_index : Int) -> String {
  match find_node(app_state.root, node_index) {
    Some(node) => node.title
    None => ""
  }
}

///|
test "node editor undo stays local until commit" {
  reset_frontend_test_state()
  begin_edit_node(1)

  sync_editor_draft(1, "Alpha1")
  sync_editor_draft(1, "Alpha12")
  assert_eq(title_at(1), "Alpha12")
  assert_eq(app_state.undo_stack.length(), 0)

  editor_undo(1)
  assert_eq(title_at(1), "Alpha1")
  assert_eq(app_state.markdown.contains("## Alpha1"), true)
  assert_eq(app_state.undo_stack.length(), 0)

  editor_redo(1)
  assert_eq(title_at(1), "Alpha12")
  assert_eq(app_state.markdown.contains("## Alpha12"), true)
  assert_eq(app_state.undo_stack.length(), 0)
}

///|
test "node editor commit adds single global undo entry" {
  reset_frontend_test_state()
  begin_edit_node(1)

  sync_editor_draft(1, "Alpha1")
  sync_editor_draft(1, "Alpha12")
  save_editor(1, "Alpha12")

  assert_eq(app_state.editing_node, -2)
  assert_eq(title_at(1), "Alpha12")
  assert_eq(app_state.undo_stack.length(), 1)
  assert_eq(app_state.undo_stack[0].contains("## Alpha"), true)

  handle_undo()
  assert_eq(title_at(1), "Alpha")
  assert_eq(app_state.markdown.contains("## Alpha12"), false)
  assert_eq(app_state.markdown.contains("## Alpha"), true)
}

///|
test "node editor cancel restores original markdown without global history" {
  reset_frontend_test_state()
  begin_edit_node(1)
  sync_editor_draft(1, "Alpha1")
  sync_editor_draft(1, "Alpha12")
  cancel_editor(1)

  assert_eq(app_state.editing_node, -2)
  assert_eq(title_at(1), "Alpha")
  assert_eq(app_state.markdown.contains("## Alpha12"), false)
  assert_eq(app_state.undo_stack.length(), 0)
}

///|
test "tree navigation moves between parents children and siblings" {
  reset_navigation_test_state()

  select_single_node(2, false)
  assert_eq(handle_tree_navigation("ArrowLeft", 2), true)
  assert_eq(app_state.selected_node, 1)

  assert_eq(handle_tree_navigation("ArrowDown", 1), true)
  assert_eq(app_state.selected_node, 4)

  assert_eq(handle_tree_navigation("ArrowUp", 4), true)
  assert_eq(app_state.selected_node, 1)
}

///|
test "tree navigation loops through siblings" {
  reset_navigation_test_state()

  select_single_node(1, false)
  assert_eq(handle_tree_navigation("ArrowUp", 1), true)
  assert_eq(app_state.selected_node, 4)

  assert_eq(handle_tree_navigation("ArrowDown", 4), true)
  assert_eq(app_state.selected_node, 1)
}

///|
test "tree navigation right expands collapsed node and selects first child" {
  reset_navigation_test_state()
  select_single_node(1, false)
  app_state.collapsed = [1]

  assert_eq(handle_tree_navigation("ArrowRight", 1), true)
  assert_eq(app_state.selected_node, 2)
  assert_eq(is_collapsed(1), false)
}

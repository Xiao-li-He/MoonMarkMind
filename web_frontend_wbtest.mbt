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
fn outline_flat_index_by_title(node : OutlineNode, title : String) -> Int {
  if node.title == title {
    return node.flat_index
  }
  for child in node.children {
    let found = outline_flat_index_by_title(child, title)
    if found >= 0 {
      return found
    }
  }
  -1
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

///|
test "move heading prev keeps sibling subtree stable" {
  let markdown = "# Root\n\nThis is the root note.\n\n## Section A\n\nIntro text.\n\n- title list entry\n- sibling list entry\n- another list entry\n### Section A1\n#### Section A1-1\n##### Section A1-1-1\n###### Section A1-1-1-1\n\nmore text\n\n- deep list a\n  - deep list b\n    - deep list c\n\n### Section A2\n\n- list A2-1\n- list A2-2\n  - child A2-2-1\n    - child A2-2-1-1"
  let outline = build_outline(markdown)
  let a2_index = outline_flat_index_by_title(outline, "Section A2")
  assert_eq(a2_index >= 0, true)

  let moved_up = move_heading_prev(markdown, a2_index)
  assert_eq(moved_up.contains("### Section A2"), true)
  assert_eq(moved_up.contains("- Section A2"), false)
  assert_eq(moved_up.contains("### Section A1"), true)
}

///|
test "moving selected node keeps it selected" {
  reset_navigation_test_state()
  select_single_node(1, false)

  handle_move_selected(true)

  assert_eq(app_state.selected_node, 2)
  assert_eq(title_at(app_state.selected_node), "Parent")
}

///|
test "move heading prev stops before document root" {
  let markdown = "# Root\n## Child"

  let moved = move_heading_prev(markdown, 1)
  assert_eq(moved, markdown)

  let moved_with_selection = move_heading_prev_with_selection(markdown, 1)
  assert_eq(moved_with_selection.0, markdown)
  assert_eq(moved_with_selection.1, 1)
}

///|
test "moving list item stays within list siblings" {
  let markdown = "# Root\n## Parent\n- list a\n- list b\n- list c"
  let outline = build_outline(markdown)
  let list_b_index = outline_flat_index_by_title(outline, "list b")
  assert_eq(list_b_index >= 0, true)

  let moved_up = move_heading_prev(markdown, list_b_index)
  assert_eq(moved_up, "# Root\n## Parent\n- list b\n- list a\n- list c")

  let moved_down = move_heading_next(markdown, list_b_index)
  assert_eq(moved_down, "# Root\n## Parent\n- list a\n- list c\n- list b")
}

///|
test "boundary list item promotes to parent level" {
  let markdown = "# Root\n## Parent\n- list a\n- list b\n- list c"
  let outline = build_outline(markdown)
  let list_a_index = outline_flat_index_by_title(outline, "list a")
  assert_eq(list_a_index >= 0, true)

  let moved_up = move_heading_prev(markdown, list_a_index)
  assert_eq(moved_up, "# Root\n## Parent\n- list b\n- list c\n## list a")
}

///|
test "same level list item can move down into heading sibling" {
  let markdown = "# Root\n\n## Section A\n\n- list intro\n- sibling order\n### Sub A1\n#### Sub A1-1\n##### Sub A1-1-1\n###### Sub A1-1-1-1\n\nmore text\n\n- deep list a\n  - deep list b\n    - deep list c"
  let outline = build_outline(markdown)
  let list_index = outline_flat_index_by_title(outline, "sibling order")
  assert_eq(list_index >= 0, true)

  let moved = move_heading_next(markdown, list_index)
  assert_eq(moved.contains("### sibling order"), true)
  assert_eq(moved.contains("- sibling order"), false)
  assert_eq(moved.contains("### Sub A1"), true)
}

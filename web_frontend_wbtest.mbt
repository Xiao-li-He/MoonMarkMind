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
  let markdown = "# 根节点\n\n这是根节点的说明文本，用来测试标题后的正文是否会被保留。\n\n## 一层分支 A\n\n这一节用来测试标题下面直接接列表、正文和同级顺序。\n\n- 标题下面直接接列表\n- 列表项可以作为子节点\n- 同级兄弟节点的顺序\n\n### 二层分支 A1\n\n#### 三层分支 A1-1\n\n##### 四层分支 A1-1-1\n\n###### 五层分支 A1-1-1-1\n\n超过 `######` 以后继续使用列表表示更深层级。\n\n- 六层分支 A1-1-1-1-1\n  - 七层分支 A1-1-1-1-1-1\n    - 八层分支 A1-1-1-1-1-1-1\n\n### 二层分支 A2\n\n- 同级列表 A2-1\n- 同级列表 A2-2\n  - 子列表 A2-2-1\n    - 子列表 A2-2-1-1"
  let outline = build_outline(markdown)
  let a2_index = outline_flat_index_by_title(outline, "二层分支 A2")
  assert_eq(a2_index >= 0, true)

  let moved_up = move_heading_prev(markdown, a2_index)
  assert_eq(
    moved_up, "# 根节点\n\n这是根节点的说明文本，用来测试标题后的正文是否会被保留。\n\n## 一层分支 A\n\n这一节用来测试标题下面直接接列表、正文和同级顺序。\n\n- 标题下面直接接列表\n- 列表项可以作为子节点\n- 同级兄弟节点的顺序\n### 二层分支 A2\n- 同级列表 A2-1\n- 同级列表 A2-2\n  - 子列表 A2-2-1\n    - 子列表 A2-2-1-1\n### 二层分支 A1\n#### 三层分支 A1-1\n##### 四层分支 A1-1-1\n###### 五层分支 A1-1-1-1\n\n超过 `######` 以后继续使用列表表示更深层级。\n\n- 六层分支 A1-1-1-1-1\n  - 七层分支 A1-1-1-1-1-1\n    - 八层分支 A1-1-1-1-1-1-1",
  )
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
test "moving heading into list domain keeps following list sibling" {
  let markdown = "# Root\n## Parent\n- one\n- two\n### Child\n- three"

  let moved = move_heading_prev(markdown, 4)
  assert_eq(moved, "# Root\n## Parent\n- one\n- Child\n  - three\n- two")
}

///|
test "moving list item into heading domain keeps heading sibling" {
  let markdown = "# Root\n## Parent\n- list a\n### Head A\n### Head B"

  let moved = move_heading_next(markdown, 2)
  assert_eq(moved, "# Root\n## Parent\n### Head A\n### list a\n### Head B")
}

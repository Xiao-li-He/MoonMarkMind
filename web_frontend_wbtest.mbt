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
test "contour pack positions centers siblings without overlap" {
  let positions = contour_pack_positions([40, 60, 50], 220, 24)
  assert_eq(positions.length(), 3)
  assert_eq(positions[0], 11)
  assert_eq(positions[1], 75)
  assert_eq(positions[2], 159)
}

///|
test "contour pack positions keeps single and paired children centered" {
  assert_eq(contour_pack_positions([80], 120, 24), [20])
  assert_eq(contour_pack_positions([40, 40], 140, 20), [20, 80])
}

///|
test "contour anchor pack positions centers odd and even siblings around the parent axis" {
  assert_eq(
    contour_anchor_pack_positions([20, 20, 20, 20, 20, 20, 20], 100, 200, 10),
    [0, 30, 60, 90, 120, 150, 180],
  )
  assert_eq(
    contour_anchor_pack_positions([20, 20, 20, 20, 20, 20], 100, 170, 10),
    [15, 45, 75, 105, 135, 165],
  )
}

///|
test "single child chain length follows recursive single-child nodes" {
  load_markdown("# Root\n## Alpha\n### Beta\n#### Gamma\n## Delta", true)
  match find_node(app_state.root, 1) {
    Some(alpha) => {
      assert_eq(single_child_chain_length(alpha), 3)
      match find_node(app_state.root, 2) {
        Some(beta) => assert_eq(single_child_chain_length(beta), 2)
        None => fail("missing beta node")
      }
    }
    None => fail("missing alpha node")
  }
}

///|
test "contour subtree span grows with nested children and notes" {
  load_markdown(
    "# Root\n## Alpha\nAlpha note line one\n\nAlpha note line two\n### Child A\n#### Grandchild\n## Beta",
    true,
  )
  match find_node(app_state.root, 1) {
    Some(alpha) => {
      let beta_index = outline_flat_index_by_title(app_state.root, "Beta")
      match find_node(app_state.root, beta_index) {
        Some(beta) => {
          assert_true(contour_subtree_span(alpha) > contour_subtree_span(beta))
          assert_true(contour_subtree_span(alpha) > 100)
        }
        None => fail("missing beta node")
      }
    }
    None => fail("missing alpha node")
  }
}

///|
test "root split count follows contour balance rather than node count" {
  load_markdown(
    "# Root\n## One\n## Two\n## Three\n## Four\n## Five\n## Six\n## Seven", true,
  )
  assert_eq(default_root_split_count(app_state.root), 3)
}

///|
test "balanced first layer insert adds to left when left side is shorter" {
  reset_frontend_test_state()
  app_state.layout_mode = "mindmap"
  load_markdown("# Root\n## Light\n## Heavy\n### Child A\n### Child B", true)
  let (next_markdown, target_index) = add_balanced_first_layer_heading(
    "New node",
  )
  assert_eq(next_markdown.contains("## Light\n## New node\n## Heavy"), true)
  assert_eq(app_state.root_split_count, 2)
  assert_eq(target_index, 2)
}

///|
test "balanced first layer insert adds to right when right side is shorter" {
  reset_frontend_test_state()
  app_state.layout_mode = "mindmap"
  load_markdown("# Root\n## Heavy\n### Child A\n### Child B\n## Light", true)
  let (next_markdown, target_index) = add_balanced_first_layer_heading(
    "New node",
  )
  assert_eq(next_markdown.contains("## Light\n## New node"), true)
  assert_eq(app_state.root_split_count, 1)
  assert_eq(target_index, 5)
}

///|
test "root branch visual radii ignore single chains and count sibling groups" {
  reset_frontend_test_state()
  load_markdown(
    "# Root\n## Chain\n### Chain 2\n#### Chain 3\n## Branch\n### A\n### B", true,
  )
  match find_node(app_state.root, 1) {
    Some(chain) => assert_eq(root_branch_visual_radii(chain, 60), (30, 30))
    None => fail("missing chain")
  }
  match find_node(app_state.root, 4) {
    Some(branch) => {
      let (top_radius, bottom_radius) = root_branch_visual_radii(branch, 60)
      assert_true(top_radius > 30)
      assert_true(bottom_radius > 30)
    }
    None => fail("missing branch")
  }
}

///|
test "root branch visual radii ignore nested descendants after sibling fork" {
  reset_frontend_test_state()
  load_markdown(
    "# Root\n## Deep\n### A1\n#### X1\n#### X2\n#### X3\n### A2\n#### Y1\n#### Y2\n#### Y3\n## Flat\n### B1\n### B2",
    true,
  )
  let deep_radii = match find_node(app_state.root, 1) {
    Some(deep) => root_branch_visual_radii(deep, 60)
    None => fail("missing deep branch")
  }
  let flat_radii = match find_node(app_state.root, 10) {
    Some(flat) => root_branch_visual_radii(flat, 60)
    None => fail("missing flat branch")
  }
  assert_eq(deep_radii, flat_radii)
}

///|
test "root branch packing uses local upper and lower visual radii" {
  let centers = root_branch_collision_adjusted_centers(
    [100, 180, 260, 340],
    [30, 68, 68, 30],
    [140, 68, 68, 30],
    220,
    16,
  )
  assert_eq(centers[1] - centers[0], 224)
  assert_eq(centers[2] - centers[1], 152)
  assert_eq(centers[3] - centers[2], 114)
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
test "double click intent edits node title instead of note body" {
  reset_frontend_test_state()
  select_single_node(1, true)
  begin_edit_node(1)

  assert_eq(app_state.editing_node, 1)
  assert_eq(app_state.editing_note_node, -2)
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
test "heading can promote one level when moving up" {
  let markdown = "# Root\n## Section A\n### Sub A1\n#### Sub A1-1"
  let outline = build_outline(markdown)
  let sub_index = outline_flat_index_by_title(outline, "Sub A1-1")
  assert_eq(sub_index >= 0, true)

  let moved = move_heading_prev(markdown, sub_index)
  assert_eq(moved.contains("### Sub A1-1"), true)
  assert_eq(moved.contains("#### Sub A1-1"), false)
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
test "list item does not cross into heading sibling" {
  let markdown = "# Root\n## Parent\n- list a\n### Head A\n### Head B"
  let outline = build_outline(markdown)
  let list_a_index = outline_flat_index_by_title(outline, "list a")
  assert_eq(list_a_index >= 0, true)

  let moved_up = move_heading_prev(markdown, list_a_index)
  assert_eq(moved_up, markdown)

  let moved_down = move_heading_next(markdown, list_a_index)
  assert_eq(moved_down, markdown)
}

///|
test "markdown body preserves blank-only lines on render" {
  let markdown = "# Root\n  \n\t\nFirst line\nSecond line\n\nThird line\n## Child"
  let nodes = parse_markdown_nodes(markdown)

  assert_eq(nodes.length(), 2)
  assert_eq(nodes[0].body.length(), 2)
  assert_eq(nodes[0].body[0], "First line\nSecond line")
  assert_eq(nodes[0].body[1], "Third line")
  assert_eq(
    render_markdown_nodes(nodes),
    "# Root\n\n\nFirst line\nSecond line\n\nThird line\n## Child",
  )
}

///|
test "rename heading preserves original blank lines" {
  let markdown = "# Root\n\n\n## Alpha\n\nAlpha note\n\n\n## Beta"

  assert_eq(
    rename_heading(markdown, 1, "Renamed"),
    "# Root\n\n\n## Renamed\n\nAlpha note\n\n\n## Beta",
  )
}

///|
test "new sibling text is inserted before next node spacing" {
  let markdown = "# Root\n## Alpha\n\n\n## Beta"

  assert_eq(
    add_sibling_heading(markdown, 1, "New", true),
    "# Root\n## Alpha\n\n\n## New\n## Beta",
  )
}

///|
test "moving heading carries surrounding blank lines with subtree" {
  let markdown = "# Root\n\n## Alpha\n\nAlpha note\n\n### Child\n\nChild note\n\n\n## Beta"

  assert_eq(
    move_heading_next(markdown, 1),
    "# Root\n\n\n## Beta\n\n## Alpha\n\nAlpha note\n\n### Child\n\nChild note",
  )
}

///|
test "node body preview keeps paragraph spacing" {
  let node = OutlineNode::{
    flat_index: 0,
    source_line: 0,
    level: 1,
    title: "Root",
    marker: "",
    body: ["First line\nSecond line", "Third line"],
    kind: MarkdownNodeKind::Heading,
    synthetic: false,
    children: [],
  }
  app_state.editing_note_node = 0

  assert_eq(
    render_node_body(node),
    "<div class=\"node-note-rail\"><button type=\"button\" class=\"node-action node-action--note\" data-action=\"toggle-note\" data-tip=\"Note\" aria-label=\"Note\">N</button><div class=\"node-body\"><textarea class=\"node-note-editor\" data-note-editor-for=\"0\" rows=\"4\">First line\nSecond line\n\nThird line</textarea></div></div>",
  )
}

///|
test "root branch split balances siblings by count" {
  let markdown = "# Root\n## One\n## Two\n## Three\n## Four\n## Five\n## Six\n## Seven"
  let outline = build_outline(markdown)

  assert_eq(default_root_split_count(outline), 3)
}

///|
test "root branch weight style keeps hundredth precision" {
  assert_eq(format_percentage_from_basis_points(1666), "16.66%")
}

///|
test "normalize markdown body lines collapses blank separators" {
  let normalized = normalize_markdown_body_lines([
    "  ", "First line", "Second line", "\t", "Third line", "", "", "Fourth line",
  ])

  assert_eq(normalized.length(), 3)
  assert_eq(normalized[0], "First line\nSecond line")
  assert_eq(normalized[1], "Third line")
  assert_eq(normalized[2], "Fourth line")
}

///|
test "insert body template appends a markdown paragraph block" {
  reset_frontend_test_state()
  select_single_node(1, false)

  insert_node_body_template("formula")

  assert_eq(app_state.markdown, "# Root\n## Alpha\n$$\nx = 1\n$$\n## Beta")
}

///|
test "insert note opens editor and commits heading markdown body" {
  reset_frontend_test_state()
  select_single_node(1, false)

  handle_insert_note()
  assert_eq(app_state.editing_note_node, 1)

  sync_note_editor_draft(1, "Alpha note")
  assert_eq(app_state.markdown, "# Root\n## Alpha\nAlpha note\n## Beta")

  save_note_editor(1, "Alpha note")
  assert_eq(app_state.editing_note_node, -2)
  assert_eq(app_state.undo_stack.length(), 1)
}

///|
test "note editor newline becomes markdown blank separator" {
  reset_frontend_test_state()
  select_single_node(1, false)

  handle_insert_note()
  sync_note_editor_draft(1, "First line\nSecond line")

  assert_eq(
    app_state.markdown,
    "# Root\n## Alpha\nFirst line\n\nSecond line\n## Beta",
  )
}

///|
test "insert note on list node preserves markdown indentation" {
  load_markdown("# Root\n## Parent\n- item\n## Next", true)
  let outline = build_outline(app_state.markdown)
  let list_index = outline_flat_index_by_title(outline, "item")
  assert_eq(list_index >= 0, true)

  select_single_node(list_index, false)
  handle_insert_note()
  sync_note_editor_draft(list_index, "List note")
  save_note_editor(list_index, "List note")

  assert_eq(
    app_state.markdown,
    "# Root\n## Parent\n- item\n  List note\n## Next",
  )
}

///|
test "direct markdown edit roundtrips note bodies for heading and list nodes" {
  let markdown = "# Root\n## Alpha\nAlpha note\n## Parent\n- item\n  List note\n## Next"
  let nodes = parse_markdown_nodes(markdown)

  assert_eq(nodes.length(), 5)
  assert_eq(nodes[1].body.length(), 1)
  assert_eq(nodes[1].body[0], "Alpha note")
  assert_eq(nodes[3].body.length(), 1)
  assert_eq(nodes[3].body[0], "List note")
  assert_eq(render_markdown_nodes(nodes), markdown)
}

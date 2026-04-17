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
  app_state.collapsed_note_nodes = []
  app_state.hidden_nodes = []
  app_state.selected_node = -2
  app_state.selected_nodes = []
  app_state.selection_anchor_node = -2
  app_state.editing_node = -2
  app_state.editing_note_node = -2
  app_state.editing_body_node = -2
  app_state.editing_body_block = -1
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
  app_state.collapsed_note_nodes = []
  app_state.hidden_nodes = []
  app_state.selected_node = -2
  app_state.selected_nodes = []
  app_state.selection_anchor_node = -2
  app_state.editing_node = -2
  app_state.editing_note_node = -2
  app_state.editing_body_node = -2
  app_state.editing_body_block = -1
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
fn mark_body_block_editing(node_index : Int, block_index : Int) -> Unit {
  app_state.editing_body_node = node_index
  app_state.editing_body_block = block_index
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
test "markdown inline renderer covers sample part two styles" {
  let html = render_markdown_inline_html(
    "[Link](https://example.com) **Bold** _Italic_ *Star Italic* `Code` ~~Gone~~",
  )
  assert_eq(html.contains("class=\"markdown-link\""), true)
  assert_eq(html.contains("href=\"https://example.com\""), true)
  assert_eq(html.contains("class=\"markdown-strong\""), true)
  assert_eq(html.contains("class=\"markdown-emphasis\""), true)
  assert_eq(
    html.contains("<em class=\"markdown-emphasis\">Star Italic</em>"),
    true,
  )
  assert_eq(html.contains("class=\"markdown-inline-code\""), true)
  assert_eq(html.contains("class=\"markdown-strike\""), true)
}

///|
test "markdown inline renderer degrades unsafe links to text" {
  let html = render_markdown_inline_html("[Bad](javascript:alert(1))")
  assert_eq(html.contains("href="), false)
  assert_eq(html.contains("Bad"), true)
  assert_eq(html.contains("javascript:"), false)
}

///|
test "markdown inline renderer previews image syntax" {
  let html = render_markdown_inline_html("![Logo](image.png)")
  assert_eq(html.contains("class=\"markdown-image\""), true)
  assert_eq(html.contains("src=\"image.png\""), true)
  assert_eq(html.contains("alt=\"Logo\""), true)
  assert_eq(html.contains("markdown-link"), false)
}

///|
test "markdown inline renderer previews image with empty alt" {
  let html = render_markdown_inline_html(
    "![](https://markmap.js.org/favicon.png)",
  )
  assert_eq(html.contains("class=\"markdown-image\""), true)
  assert_eq(html.contains("src=\"https://markmap.js.org/favicon.png\""), true)
  assert_eq(html.contains("alt=\"\""), true)
  assert_eq(html.contains("markdown-link"), false)
}

///|
test "image-only node body uses non scrolling body class" {
  let node = OutlineNode::{
    flat_index: 0,
    source_line: 0,
    level: 1,
    title: "Image",
    marker: "",
    body: ["![](https://markmap.js.org/favicon.png)"],
    kind: MarkdownNodeKind::Heading,
    synthetic: false,
    children: [],
  }
  let html = render_node_body(node)
  assert_eq(html.contains("node-body--image-only"), true)
  assert_eq(html.contains("markdown-image"), true)
}

///|
test "markdown inline renderer degrades unsafe image sources" {
  let html = render_markdown_inline_html("![Bad](javascript:alert(1))")
  assert_eq(html.contains("<img"), false)
  assert_eq(html.contains("src="), false)
  assert_eq(html.contains("Bad"), true)
  assert_eq(html.contains("javascript:"), false)
}

///|
test "markdown inline renderer renders latex math" {
  let html = render_markdown_inline_html("Value $x^2 + \\alpha$")
  assert_eq(
    html.contains("class=\"markdown-math markdown-math--inline\""),
    true,
  )
  assert_eq(html.contains("<sup>2</sup>"), true)
  assert_eq(html.contains("&alpha;"), true)
}

///|
test "markdown inline renderer renders common latex formula subset" {
  let html = render_markdown_inline_html(
    "Formula $x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}$ and $x_i^2$",
  )
  assert_eq(html.contains("class=\"markdown-math-frac\""), true)
  assert_eq(html.contains("class=\"markdown-math-sqrt\""), true)
  assert_eq(html.contains("markdown-math-sqrt__radical"), true)
  assert_eq(html.contains("markdown-math-sqrt__svg"), true)
  assert_eq(html.contains("markdown-math-sqrt__path"), true)
  assert_eq(html.contains("markdown-math-sqrt__radicand"), true)
  assert_eq(html.contains("&radic;"), false)
  assert_eq(html.contains("&plusmn;"), true)
  assert_eq(html.contains("<sub>i</sub>"), true)
  assert_eq(html.contains("<sup>2</sup>"), true)
}

///|
test "markdown inline renderer renders latex over fractions" {
  let html = render_markdown_inline_html(
    "Formula $x = {-b \\pm \\sqrt{b^2-4ac} \\over 2a}$",
  )
  assert_eq(html.contains("class=\"markdown-math-frac\""), true)
  assert_eq(html.contains("class=\"markdown-math-sqrt\""), true)
  assert_eq(html.contains("&plusmn;"), true)
  assert_eq(html.contains("\\over"), false)
}

///|
test "markdown inline renderer exposes latex math subtree classes" {
  let html0 = render_markdown_inline_html(
    "公式 $x = {-b \\pm \\sqrt{b^2-4ac} \\over 2a}$",
  )
  let _ = html0
  let html = render_markdown_inline_html(
    "Formula $x = {-b \\pm \\sqrt{b^2-4ac} \\over 2a}$",
  )
  assert_eq(html.contains("markdown-math-frac"), true)
  assert_eq(html.contains("markdown-math-sqrt"), true)
  assert_eq(html.contains("markdown-math-frac__num"), true)
  assert_eq(html.contains("markdown-math-frac__den"), true)
  assert_eq(html.contains("\\over"), false)
}

///|
test "markdown inline renderer keeps invalid math delimiters as text" {
  let unclosed = render_markdown_inline_html("Value $x^2")
  assert_eq(unclosed.contains("markdown-math"), false)
  assert_eq(unclosed.contains("$x^2"), true)
  let empty = render_markdown_inline_html("Value $ $")
  assert_eq(empty.contains("markdown-math"), false)
  assert_eq(empty.contains("$ $"), true)
  let code = render_markdown_inline_html("`$x^2$`")
  assert_eq(code.contains("markdown-math"), false)
  assert_eq(code.contains("markdown-inline-code"), true)
}

///|
test "markdown inline renderer escapes latex math text" {
  let html = render_markdown_inline_html(
    "$<img src=x onerror=alert(1)> + \\text{<script>}$",
  )
  assert_eq(html.contains("<img"), false)
  assert_eq(html.contains("<script>"), false)
  assert_eq(html.contains("&lt;img src=x onerror=alert(1)&gt;"), true)
  assert_eq(html.contains("&lt;script&gt;"), true)
}

///|
test "markdown renderer escapes html and attributes" {
  let html = render_markdown_blocks_html([
    "[<img src=x onerror=alert(1)>](https://example.com/?q=\"x\")", "```html\n<script>alert(1)</script>\n```",
  ])
  assert_eq(html.contains("<script>alert(1)</script>"), false)
  assert_eq(html.contains("<img src=x"), false)
  assert_eq(html.contains("href=\"https://example.com/?q="), true)
  assert_eq(html.contains("&lt;script&gt;alert(1)&lt;/script&gt;"), true)
  assert_eq(html.contains("&lt;img src=x onerror=alert(1)&gt;"), true)
}

///|
test "markdown title renderer turns task markers into disabled checks" {
  let html = render_markdown_title_html("[x] Done")
  assert_eq(html.contains("markdown-task--title"), true)
  assert_eq(html.contains("checked=\"true\""), true)
  assert_eq(html.contains("Done"), true)
}

///|
test "markdown block renderer covers code task and table blocks" {
  let html = render_markdown_blocks_html([
    "```ts\nconst title = \"code block\";\n```", "- [ ] Todo\n- [x] Done", "| Feature | Status |\n|------|------|\n| Editor | ok |",
  ])
  assert_eq(html.contains("class=\"markdown-code-block\""), true)
  assert_eq(html.contains("data-lang=\"ts\""), true)
  assert_eq(html.contains("class=\"markdown-task\""), true)
  assert_eq(html.contains("checked=\"true\""), true)
  assert_eq(html.contains("class=\"markdown-table\""), true)
  assert_eq(html.contains("<th>Feature</th>"), true)
}

///|
test "markdown block renderer renders latex math" {
  let html = render_markdown_blocks_html(["$$\\frac{a_1}{b^2} + \\sqrt{x}$$"])
  assert_eq(html.contains("class=\"markdown-math markdown-math--block\""), true)
  assert_eq(html.contains("class=\"markdown-math-frac\""), true)
  assert_eq(html.contains("<sub>1</sub>"), true)
  assert_eq(html.contains("<sup>2</sup>"), true)
  assert_eq(html.contains("markdown-math-sqrt__radical"), true)
  assert_eq(html.contains("markdown-math-sqrt__svg"), true)
  assert_eq(html.contains("markdown-math-sqrt__path"), true)
  assert_eq(html.contains("markdown-math-sqrt__radicand"), true)
  assert_eq(html.contains("&radic;"), false)
}

///|
test "markdown block renderer exposes latex math subtree classes" {
  let html = render_markdown_blocks_html(["$$\\frac{a}{b} + \\sqrt[n]{x}$$"])
  let _ = html
  assert_eq(html.contains("markdown-math-frac"), true)
  assert_eq(html.contains("markdown-math-frac__num"), true)
  assert_eq(html.contains("markdown-math-frac__den"), true)
  assert_eq(html.contains("markdown-math-sqrt__index"), true)
  assert_eq(html.contains("markdown-math-sqrt__radical"), true)
  assert_eq(html.contains("markdown-math-sqrt__svg"), true)
  assert_eq(html.contains("markdown-math-sqrt__path"), true)
}

///|
test "markdown block renderer preserves latex math rows and alignment" {
  let html = render_markdown_blocks_html([
    "$$\na &= b + c \\\\\nx &= {-b \\pm \\sqrt{b^2-4ac} \\over 2a}\n$$",
  ])
  assert_eq(html.contains("class=\"markdown-math-lines\""), true)
  assert_eq(html.contains("markdown-math-row--aligned"), true)
  assert_eq(html.contains("markdown-math-align-cell"), true)
  assert_eq(html.contains("class=\"markdown-math-frac\""), true)
  assert_eq(html.contains("class=\"markdown-math-sqrt\""), true)
  assert_eq(html.contains("\\over"), false)
}

///|
test "sample part two nodes expose body preview html" {
  load_markdown(
    "# Root\n## Code\n```ts\nconst title = \"code block\";\n```\n## Table\n| A | B |\n|---|---|\n| 1 | 2 |",
    true,
  )
  let code_index = outline_flat_index_by_title(app_state.root, "Code")
  match find_node(app_state.root, code_index) {
    Some(code_node) => {
      assert_eq(node_has_note(code_node), true)
      let html = render_node_body(code_node)
      assert_eq(html.contains("node-body-preview"), true)
      assert_eq(html.contains("markdown-code-block"), true)
    }
    None => fail("missing code node")
  }
  let table_index = outline_flat_index_by_title(app_state.root, "Table")
  match find_node(app_state.root, table_index) {
    Some(table_node) => {
      let html = render_node_body(table_node)
      assert_eq(html.contains("markdown-table"), true)
    }
    None => fail("missing table node")
  }
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
test "tree line style marks nodes with compact line tree class" {
  reset_frontend_test_state()
  app_state.layout_mode = "tree"
  app_state.style_mode = "line"
  assert_true(render_node_style_class().contains("node--branch-line"))
  assert_true(render_node_style_class().contains("node--line-tree"))
  app_state.layout_mode = "mindmap"
  assert_eq(render_node_style_class().contains("node--line-tree"), false)
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
test "root branch packing keeps first layer gaps independent of children" {
  let centers = root_branch_collision_adjusted_centers(
    [100, 180, 260, 340],
    [30, 30, 30, 30],
    [30, 30, 30, 30],
    220,
    16,
  )
  assert_eq(centers[1] - centers[0], 80)
  assert_eq(centers[2] - centers[1], 80)
  assert_eq(centers[3] - centers[2], 80)
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
test "redo shortcut helper accepts y and shift z" {
  assert_eq(is_redo_shortcut(true, false, "y"), true)
  assert_eq(is_redo_shortcut(true, false, "Y"), true)
  assert_eq(is_redo_shortcut(true, true, "z"), true)
  assert_eq(is_redo_shortcut(true, true, "Z"), true)
  assert_eq(is_redo_shortcut(true, true, "y"), false)
  assert_eq(is_redo_shortcut(false, false, "y"), false)
}

///|
test "redo tooltip helper mentions shift z" {
  let tip = redo_action_tip()
  assert_true(tip.contains("Ctrl+Y"))
  assert_true(tip.contains("Ctrl+Shift+Z"))
}

///|
test "body block edit save pushes one global undo entry" {
  reset_frontend_test_state()
  load_markdown("# Root\n## Alpha\nOld note\n\nSecond block\n## Beta", true)
  select_single_node(1, false)
  mark_body_block_editing(1, 0)

  save_body_block_editor(1, 0, "New note")

  assert_eq(
    app_state.markdown,
    "# Root\n## Alpha\nNew note\n\nSecond block\n## Beta",
  )
  assert_eq(app_state.editing_body_node, -2)
  assert_eq(app_state.undo_stack.length(), 1)
  handle_undo()
  assert_eq(
    app_state.markdown,
    "# Root\n## Alpha\nOld note\n\nSecond block\n## Beta",
  )
  handle_redo()
  assert_eq(
    app_state.markdown,
    "# Root\n## Alpha\nNew note\n\nSecond block\n## Beta",
  )
}

///|
test "body block edit cancel and unchanged save do not push undo" {
  reset_frontend_test_state()
  load_markdown("# Root\n## Alpha\nSame note\n## Beta", true)
  select_single_node(1, false)

  mark_body_block_editing(1, 0)
  cancel_body_block_editor()
  assert_eq(app_state.markdown, "# Root\n## Alpha\nSame note\n## Beta")
  assert_eq(app_state.undo_stack.length(), 0)

  mark_body_block_editing(1, 0)
  save_body_block_editor(1, 0, "Same note")
  assert_eq(app_state.markdown, "# Root\n## Alpha\nSame note\n## Beta")
  assert_eq(app_state.undo_stack.length(), 0)
}

///|
test "body block delete removes only one block and is undoable" {
  reset_frontend_test_state()
  load_markdown("# Root\n## Alpha\nFirst block\n\nSecond block\n## Beta", true)
  select_single_node(1, false)

  delete_body_block(1, 0)

  assert_eq(app_state.markdown, "# Root\n## Alpha\nSecond block\n## Beta")
  assert_eq(app_state.undo_stack.length(), 1)
  handle_undo()
  assert_eq(
    app_state.markdown,
    "# Root\n## Alpha\nFirst block\n\nSecond block\n## Beta",
  )
  handle_redo()
  assert_eq(app_state.markdown, "# Root\n## Alpha\nSecond block\n## Beta")
}

///|
test "body note button toggles collapsed body instead of editing" {
  reset_frontend_test_state()
  load_markdown("# Root\n## Alpha\nAlpha note\n## Beta", true)

  assert_eq(is_note_body_collapsed(1), false)
  toggle_note_body(1)
  assert_eq(is_note_body_collapsed(1), true)
  assert_eq(app_state.editing_note_node, -2)
  match find_node(app_state.root, 1) {
    Some(node) => assert_eq(render_node_body(node).contains("node-body"), false)
    None => fail("missing alpha node")
  }
  toggle_note_body(1)
  assert_eq(is_note_body_collapsed(1), false)
}

///|
test "body block edit button selects node without inline editor" {
  reset_frontend_test_state()
  load_markdown("# Root\n## Alpha\nAlpha note\n## Beta", true)
  app_state.editing_node = 1
  app_state.editing_note_node = 1
  app_state.editing_body_node = 1
  app_state.editing_body_block = 0

  begin_body_block_edit_node(1, 0)

  assert_eq(app_state.selected_node, 1)
  assert_eq(app_state.editing_node, -2)
  assert_eq(app_state.editing_note_node, -2)
  assert_eq(app_state.editing_body_node, -2)
  assert_eq(app_state.editing_body_block, -1)
}

///|
test "body block image edit keeps inline image editor" {
  reset_frontend_test_state()
  load_markdown("# Root\n## Alpha\n![old](old.png)\n## Beta", true)

  begin_body_block_edit_node(1, 0)

  assert_eq(app_state.selected_node, 1)
  assert_eq(app_state.editing_body_node, 1)
  assert_eq(app_state.editing_body_block, 0)
}

///|
test "body block edit line range points to markdown source block" {
  reset_frontend_test_state()
  load_markdown(
    "# Root\n## Alpha\nFirst line\n\n```ts\nconst a = 1\n```\n## Beta", true,
  )

  match find_node(app_state.root, 1) {
    Some(node) =>
      match node_body_block_line_range(node, 1) {
        Some((start_line, end_line)) => {
          assert_eq(start_line, 4)
          assert_eq(end_line, 6)
        }
        None => fail("missing body block range")
      }
    None => fail("missing alpha node")
  }
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
test "undo after renaming newly added node deletes the node" {
  reset_frontend_test_state()
  select_single_node(1, false)
  handle_add_child(1)
  let new_index = app_state.selected_node

  sync_editor_draft(new_index, "Gamma")
  save_editor(new_index, "Gamma")
  handle_undo()

  assert_eq(app_state.markdown, frontend_test_markdown())
  assert_eq(outline_flat_index_by_title(app_state.root, "Gamma"), -1)
  assert_eq(outline_flat_index_by_title(app_state.root, "New node"), -1)
}

///|
test "local undo while editing newly added node deletes the node" {
  reset_frontend_test_state()
  select_single_node(1, false)
  handle_add_child(1)
  let new_index = app_state.selected_node

  sync_editor_draft(new_index, "Gamma")
  editor_undo(new_index)

  assert_eq(app_state.markdown, frontend_test_markdown())
  assert_eq(app_state.editing_node, -2)
  assert_eq(outline_flat_index_by_title(app_state.root, "Gamma"), -1)
  assert_eq(outline_flat_index_by_title(app_state.root, "New node"), -1)
}

///|
test "undo newly added child expands collapsed parent path" {
  load_markdown("# Root\n## Parent\n### Child\n## Other", true)
  handle_add_child(2)
  let new_index = app_state.selected_node
  save_editor(new_index, "New node")
  app_state.collapsed = [1, 2]

  handle_undo()

  assert_eq(outline_flat_index_by_title(app_state.root, "New node"), -1)
  assert_eq(is_collapsed(1), false)
  assert_eq(is_collapsed(2), false)
}

///|
test "local undo newly added child expands collapsed parent path" {
  load_markdown("# Root\n## Parent\n### Child\n## Other", true)
  handle_add_child(2)
  let new_index = app_state.selected_node
  app_state.collapsed = [1, 2]

  editor_undo(new_index)

  assert_eq(outline_flat_index_by_title(app_state.root, "New node"), -1)
  assert_eq(app_state.editing_node, -2)
  assert_eq(is_collapsed(1), false)
  assert_eq(is_collapsed(2), false)
}

///|
test "undo expands collapsed selected node after edit commit" {
  reset_navigation_test_state()
  begin_edit_node(1)
  sync_editor_draft(1, "Parent2")
  save_editor(1, "Parent2")
  app_state.collapsed = [1]

  handle_undo()

  assert_eq(title_at(1), "Parent")
  assert_eq(is_collapsed(1), false)
}

///|
test "undo expands collapsed ancestors of selected edited node" {
  reset_navigation_test_state()
  begin_edit_node(2)
  sync_editor_draft(2, "Child A2")
  save_editor(2, "Child A2")
  app_state.collapsed = [1, 2]

  handle_undo()

  assert_eq(title_at(2), "Child A")
  assert_eq(is_collapsed(1), false)
  assert_eq(is_collapsed(2), false)
}

///|
test "undo expands edited node path even after selecting another node" {
  reset_navigation_test_state()
  begin_edit_node(2)
  sync_editor_draft(2, "Child A2")
  save_editor(2, "Child A2")
  select_single_node(4, false)
  app_state.collapsed = [1, 2]

  handle_undo()

  assert_eq(title_at(2), "Child A")
  assert_eq(is_collapsed(1), false)
  assert_eq(is_collapsed(2), false)
}

///|
test "undo keeps collapsed descendants of selected edited node collapsed" {
  load_markdown("# Root\n## Parent\n### Child\n#### Grandchild\n## Other", true)
  begin_edit_node(1)
  sync_editor_draft(1, "Parent2")
  save_editor(1, "Parent2")
  app_state.collapsed = [1, 2]

  handle_undo()

  assert_eq(title_at(1), "Parent")
  assert_eq(is_collapsed(1), false)
  assert_eq(is_collapsed(2), true)
}

///|
test "redo expands parent path and keeps collapsed descendants collapsed" {
  load_markdown("# Root\n## Parent\n### Child\n#### Grandchild\n## Other", true)
  begin_edit_node(1)
  sync_editor_draft(1, "Parent2")
  save_editor(1, "Parent2")

  handle_undo()
  app_state.collapsed = [1, 2]
  handle_redo()

  assert_eq(title_at(1), "Parent2")
  assert_eq(is_collapsed(1), false)
  assert_eq(is_collapsed(2), true)
}

///|
test "redo expands edited node path even after selecting another node" {
  reset_navigation_test_state()
  begin_edit_node(2)
  sync_editor_draft(2, "Child A2")
  save_editor(2, "Child A2")

  handle_undo()
  select_single_node(4, false)
  app_state.collapsed = [1, 2]
  handle_redo()

  assert_eq(title_at(2), "Child A2")
  assert_eq(is_collapsed(1), false)
  assert_eq(is_collapsed(2), false)
}

///|
test "undo after delete expands collapsed parent of restored node" {
  load_markdown("# Root\n## Parent\n### Child\n## Other", true)

  handle_delete(2)
  app_state.collapsed = [1]
  handle_undo()

  assert_eq(outline_flat_index_by_title(app_state.root, "Child"), 2)
  assert_eq(is_collapsed(1), false)
}

///|
test "redo newly added node expands restored node by default" {
  load_markdown("# Root\n## Parent\n### Child\n## Other", true)
  handle_add_child(2)
  let new_index = app_state.selected_node
  save_editor(new_index, "New node")

  handle_undo()
  app_state.collapsed = [1, 2, new_index]
  handle_redo()

  assert_eq(outline_flat_index_by_title(app_state.root, "New node"), new_index)
  assert_eq(is_collapsed(1), false)
  assert_eq(is_collapsed(2), false)
  assert_eq(is_collapsed(new_index), false)
}

///|
test "node editor duplicate save after commit does not push empty undo state" {
  reset_frontend_test_state()
  begin_edit_node(1)

  sync_editor_draft(1, "Alpha12")
  save_editor(1, "Alpha12")
  save_editor(1, "Alpha12")

  assert_eq(app_state.undo_stack.length(), 1)
  handle_undo()
  assert_eq(app_state.markdown.length() > 0, true)
  assert_eq(title_at(1), "Alpha")
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
test "mindmap ctrl arrow shortcut moves selected node before navigation" {
  reset_navigation_test_state()
  select_single_node(1, false)

  assert_eq(handle_mindmap_move_shortcut(true, "ArrowDown"), true)

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
test "heading inserted after list sibling keeps list block separator" {
  let markdown = "# Root\n## Parent\n- list item\n## Next"
  let outline = build_outline(markdown)
  let parent_index = outline_flat_index_by_title(outline, "Parent")
  assert_eq(parent_index >= 0, true)

  assert_eq(
    add_child_heading(markdown, parent_index, "New heading"),
    "# Root\n## Parent\n- list item\n\n### New heading\n## Next",
  )
}

///|
test "list inserted after list sibling stays in same list block" {
  let markdown = "# Root\n## Parent\n- list item\n\n## Next"
  let outline = build_outline(markdown)
  let list_index = outline_flat_index_by_title(outline, "list item")
  assert_eq(list_index >= 0, true)

  assert_eq(
    add_sibling_heading(markdown, list_index, "New item", true),
    "# Root\n## Parent\n- list item\n- New item\n\n## Next",
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

  let html = render_node_body(node)
  assert_eq(html.contains("aria-expanded=\"true\""), true)
  assert_eq(html.contains("data-body-block-index=\"0\""), true)
  assert_eq(html.contains("data-body-block-index=\"1\""), true)
  assert_eq(html.contains("First line"), true)
  assert_eq(html.contains("Second line"), true)
  assert_eq(html.contains("Third line"), true)
}

///|
test "node body block editor renders one active block editor" {
  let node = OutlineNode::{
    flat_index: 0,
    source_line: 0,
    level: 1,
    title: "Root",
    marker: "",
    body: ["First line", "Second line"],
    kind: MarkdownNodeKind::Heading,
    synthetic: false,
    children: [],
  }
  app_state.editing_body_node = 0
  app_state.editing_body_block = 1

  let html = render_node_body(node)
  assert_eq(html.contains("data-body-editor-for=\"0\""), true)
  assert_eq(html.contains("data-body-editor-block=\"1\""), true)
  assert_eq(html.contains("data-action=\"save-body-block\""), true)
  assert_eq(html.contains("data-action=\"cancel-body-block\""), true)
  assert_eq(html.contains("✔"), true)
  assert_eq(html.contains("❌"), true)
}

///|
test "node body block actions render svg icons" {
  let node = OutlineNode::{
    flat_index: 0,
    source_line: 0,
    level: 1,
    title: "Root",
    marker: "",
    body: ["First line"],
    kind: MarkdownNodeKind::Heading,
    synthetic: false,
    children: [],
  }
  app_state.editing_body_node = -2
  app_state.editing_body_block = -1

  let html = render_node_body(node)
  assert_eq(html.contains("node-body-block-action-icon"), true)
  assert_eq(html.contains(">E<"), false)
  assert_eq(html.contains(">X<"), false)
}

///|
test "single line body block actions get centered layout class" {
  let node = OutlineNode::{
    flat_index: 0,
    source_line: 0,
    level: 1,
    title: "Root",
    marker: "",
    body: ["First line", "Second line\nThird line"],
    kind: MarkdownNodeKind::Heading,
    synthetic: false,
    children: [],
  }
  app_state.editing_body_node = -2
  app_state.editing_body_block = -1

  let html = render_node_body(node)
  assert_eq(html.contains("node-body-block--single-line"), true)
  assert_eq(html.contains("node-body-block-actions--single-line"), true)
  assert_eq(
    html.contains(
      "node-body-block-actions node-body-block-actions--single-line\" data-body-block-index=\"1\"",
    ),
    false,
  )
}

///|
test "image body block actions keep bottom layout" {
  let node = OutlineNode::{
    flat_index: 0,
    source_line: 0,
    level: 1,
    title: "Root",
    marker: "",
    body: ["![Logo](image.png)"],
    kind: MarkdownNodeKind::Heading,
    synthetic: false,
    children: [],
  }
  app_state.editing_body_node = -2
  app_state.editing_body_block = -1

  let html = render_node_body(node)
  assert_eq(html.contains("node-body-block--image"), true)
  assert_eq(html.contains("node-body-block--single-line"), false)
  assert_eq(html.contains("node-body-block-actions--single-line"), false)
}

///|
test "node visual hidden count excludes the current node" {
  reset_navigation_test_state()
  let parent_index = outline_flat_index_by_title(app_state.root, "Parent")
  let parent = find_node(app_state.root, parent_index).unwrap()

  assert_eq(count_hidden_descendants(parent), 2)
  assert_eq(count_subtree_nodes(parent), 3)
  assert_eq(
    render_node_visual_attrs(parent, 0).contains("data-hidden-count=\"2\""),
    true,
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
test "insert body template appends a markdown image block" {
  reset_frontend_test_state()
  select_single_node(1, false)

  insert_node_body_template("image")

  assert_eq(
    app_state.markdown.contains("![") &&
    app_state.markdown.contains("](image.png)"),
    true,
  )
}

///|
test "body block image edit saves markdown image syntax" {
  reset_frontend_test_state()
  load_markdown("# Root\n## Alpha\n![old](old.png)\n## Beta", true)
  select_single_node(1, false)
  begin_body_block_edit_node(1, 0)

  save_body_block_editor(1, 0, "![new alt](new.png)")

  assert_eq(
    app_state.markdown,
    "# Root\n## Alpha\n![new alt](new.png)\n## Beta",
  )
  assert_eq(body_block_kind("![new alt](new.png)"), "image")
  handle_undo()
  assert_eq(app_state.markdown, "# Root\n## Alpha\n![old](old.png)\n## Beta")
}

///|
test "insert body template appends a markdown code block" {
  reset_frontend_test_state()
  select_single_node(1, false)

  insert_node_body_template("code")

  assert_eq(
    app_state.markdown,
    "# Root\n## Alpha\n```ts\nconst value = 1\n```\n## Beta",
  )
}

///|
test "insert body template appends a markdown table block" {
  reset_frontend_test_state()
  select_single_node(1, false)

  insert_node_body_template("table")

  assert_eq(
    app_state.markdown,
    "# Root\n## Alpha\n| Column | Value |\n|---|---|\n| A | 1 |\n## Beta",
  )
}

///|
test "insert note appends note block without entering body editor" {
  reset_frontend_test_state()
  select_single_node(1, false)

  handle_insert_note()
  match find_node(app_state.root, 1) {
    Some(node) => assert_eq(node.body.length(), 1)
    None => fail("missing alpha node")
  }
  assert_eq(app_state.editing_note_node, -2)
  assert_eq(app_state.editing_body_node, -2)
  assert_eq(app_state.undo_stack.length(), 1)
}

///|
test "body block duplicate save after commit does not push empty undo state" {
  reset_frontend_test_state()
  select_single_node(1, false)
  handle_insert_note()

  mark_body_block_editing(1, 0)
  save_body_block_editor(1, 0, "Alpha note")
  mark_body_block_editing(1, 0)
  save_body_block_editor(1, 0, "Alpha note")

  assert_eq(app_state.undo_stack.length(), 2)
  handle_undo()
  assert_eq(app_state.markdown.length() > 0, true)
  match find_node(app_state.root, 1) {
    Some(node) => assert_eq(node.body[0] != "Alpha note", true)
    None => fail("missing alpha node")
  }
}

///|
test "body block edit preserves textarea newlines in one block" {
  reset_frontend_test_state()
  select_single_node(1, false)

  handle_insert_note()
  mark_body_block_editing(1, 0)
  save_body_block_editor(1, 0, "First line\nSecond line")

  assert_eq(
    app_state.markdown,
    "# Root\n## Alpha\nFirst line\nSecond line\n## Beta",
  )
}

///|
test "body block edit preserves code block single newlines" {
  reset_frontend_test_state()
  select_single_node(1, false)

  insert_node_body_template("code")
  mark_body_block_editing(1, 0)
  save_body_block_editor(1, 0, "```ts\nconst a = 1\nconst b = 2\n```")

  assert_eq(
    app_state.markdown,
    "# Root\n## Alpha\n```ts\nconst a = 1\nconst b = 2\n```\n## Beta",
  )
}

///|
test "body block edit preserves table single newlines" {
  reset_frontend_test_state()
  select_single_node(1, false)

  insert_node_body_template("table")
  mark_body_block_editing(1, 0)
  save_body_block_editor(1, 0, "| A | B |\n|---|---|\n| 1 | 2 |")

  assert_eq(
    app_state.markdown,
    "# Root\n## Alpha\n| A | B |\n|---|---|\n| 1 | 2 |\n## Beta",
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
  mark_body_block_editing(list_index, 0)
  save_body_block_editor(list_index, 0, "List note")

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

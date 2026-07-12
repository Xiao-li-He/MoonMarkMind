///|
fn rich_markdown() -> String {
  (
    #|# Root
    #|Root note with $x^2$.
    #|
    #|## Alpha
    #|Alpha paragraph.
    #|
    #|```mbt
    #|fn main { println("hi") }
    #|```
    #|
    #|## Beta
    #|![Alt](https://example.com/image.png)
    #|
    #|### Beta Child
    #|| A | B |
    #|| - | - |
    #|| 1 | 2 |
    #|
  )
}

///|
test "render layouts expose static mindmap structure" {
  let logic = render_markdown_html(rich_markdown(), options={
    layout: Logic,
    style: Full,
    layer: Full,
  })
  let mindmap = render_markdown_html(rich_markdown(), options={
    layout: Mindmap,
    style: Full,
    layer: Full,
  })
  let tree = render_markdown_html(rich_markdown(), options={
    layout: Tree,
    style: Full,
    layer: Full,
  })
  assert_eq(logic.contains("mindmap-stage--single-right"), true)
  assert_eq(mindmap.contains("mindmap-stage--radial"), true)
  assert_eq(tree.contains("mindmap-stage--vertical"), true)
  assert_eq(logic.contains("data-parent-index=\"0\""), true)
  assert_eq(logic.contains("mindmap-connector-layer"), true)
}

///|
fn interactive_test_hooks() -> InteractiveRenderHooks {
  {
    render_node_card: fn(
      node,
      parent_index,
      center,
      tone_index,
      depth,
      action_anchor,
    ) {
      "<article class=\"hook-card\" data-node-index=\"\{node.flat_index}\" data-parent-index=\"\{parent_index}\" data-center=\"\{center}\" data-tone=\"\{tone_index}\" data-depth=\"\{depth}\" data-action-anchor=\"\{action_anchor}\">\{node.title}</article>"
    },
    should_render_children: fn(node) { node.title != "Collapsed" },
    is_hidden_node: fn(index) { index == 2 },
    render_hidden_marker: fn(node, direction, tone_index) {
      "<button class=\"hook-hidden\" data-node-index=\"\{node.flat_index}\" data-direction=\"\{direction}\" data-tone=\"\{tone_index}\">hidden</button>"
    },
    root_left_count: fn(_root) { 1 },
    root_branch_span: fn(_node) { 10 },
  }
}

///|
test "interactive renderer delegates cards through hooks across layouts" {
  let root = @outline.build_outline(
    "# Root\n## Left\n### Hidden\n### Visible\n## Right\n### Child\n## Collapsed\n### Omitted",
  )
  let logic = render_interactive_content_html(
    root,
    { layout: Logic, style: Full, layer: Full },
    interactive_test_hooks(),
  )
  let mindmap = render_interactive_content_html(
    root,
    { layout: Mindmap, style: Full, layer: Full },
    interactive_test_hooks(),
  )
  let tree = render_interactive_content_html(
    root,
    { layout: Tree, style: Line, layer: Full },
    interactive_test_hooks(),
  )
  assert_eq(logic.contains("mindmap-stage--single-right"), true)
  assert_eq(mindmap.contains("mindmap-stage--radial"), true)
  assert_eq(tree.contains("mindmap-stage--vertical"), true)
  assert_eq(logic.contains("mindmap-connector-layer"), true)
  assert_eq(mindmap.contains("mindmap-connector-layer"), true)
  assert_eq(tree.contains("mindmap-connector-layer"), true)
  assert_eq(logic.contains("data-parent-index=\"0\""), true)
  assert_eq(
    mindmap.contains("data-action-anchor=\"node-actions--left-mid\""),
    true,
  )
  assert_eq(
    tree.contains("data-action-anchor=\"node-actions--bottom-center\""),
    true,
  )
  assert_eq(mindmap.contains("hook-hidden"), true)
  assert_eq(tree.contains("Omitted"), false)
}

///|
test "render style and layer options" {
  let line = render_markdown_html(rich_markdown(), options={
    layout: Tree,
    style: Line,
    layer: Layer2,
  })
  let root_only = render_markdown_html(rich_markdown(), options={
    layout: Logic,
    style: Full,
    layer: Root,
  })
  assert_eq(line.contains("moonmarkmind-export--line"), true)
  assert_eq(line.contains("node--branch-line"), true)
  assert_eq(line.contains("node--fill node--branch-line"), true)
  assert_eq(line.contains("node--line-tree"), true)
  assert_eq(line.contains("vertical-tree__children--line-tree"), true)
  assert_eq(root_only.contains("moonmarkmind-export--full"), true)
  assert_eq(root_only.contains("node--line"), true)
  assert_eq(line.contains("Beta Child"), false)
  assert_eq(root_only.contains("Alpha"), false)
  assert_eq(root_only.contains("Beta Child"), false)
}

///|
test "render export node actions and attrs" {
  let html = render_markdown_html(rich_markdown(), options={
    layout: Logic,
    style: Full,
    layer: Full,
  })
  assert_eq(html.contains("node-action--toggle"), true)
  assert_eq(html.contains("node-actions--right-mid"), true)
  assert_eq(html.contains("data-action=\"toggle\""), true)
  assert_eq(html.contains("data-hidden-count=\"1\""), true)
  assert_eq(html.contains("aria-expanded=\"true\""), true)
  assert_eq(html.contains("node-action--note"), true)
  assert_eq(html.contains("data-action=\"toggle-note\""), true)
}

///|
test "render tree line keeps app web action placement classes" {
  let html = render_markdown_html(rich_markdown(), options={
    layout: Tree,
    style: Line,
    layer: Full,
  })
  assert_eq(html.contains("node-actions--bottom-center"), true)
  assert_eq(html.contains("node-actions--branch-line"), true)
  assert_eq(html.contains("node-actions--right-mid"), false)
  assert_eq(html.contains("node-body--line-tree"), true)
  assert_eq(html.contains("node--line-tree-note"), true)
}

///|
test "render markdown body and full svg export" {
  let html = render_markdown_html(rich_markdown(), options={
    layout: Mindmap,
    style: Full,
    layer: Full,
  })
  let svg = render_markdown_svg(rich_markdown(), options={
    layout: Mindmap,
    style: Full,
    layer: Full,
  })
  assert_eq(html.contains("markdown-code-block"), true)
  assert_eq(html.contains("markdown-table"), true)
  assert_eq(html.contains("markdown-image"), true)
  assert_eq(html.contains("markdown-math"), true)
  assert_eq(html.contains("<style>"), false)
  assert_eq(svg.contains("<foreignObject"), true)
  assert_eq(svg.contains("<style>"), true)
  assert_eq(svg.contains("<script"), false)
  assert_eq(svg.contains("renderConnectors"), false)
  assert_eq(svg.contains("resizeSvgCanvas"), false)
  assert_eq(svg.contains("data-static-connectors=\"true\""), true)
  assert_eq(svg.contains(".node"), true)
  assert_eq(svg.contains("mindmap-connector-layer"), true)
  assert_eq(svg.contains("<path"), true)
}

///|
test "render markdown svg normalizes html math entities for xml" {
  let svg = render_markdown_svg(
    (
      #|# Formula
      #|Use $x \pm \alpha \le y$.
      #|
    ),
    options={ layout: Logic, style: Full, layer: Full },
  )
  assert_eq(svg.contains("&plusmn;"), false)
  assert_eq(svg.contains("&alpha;"), false)
  assert_eq(svg.contains("&le;"), false)
  assert_eq(svg.contains("&#177;"), true)
  assert_eq(svg.contains("&#945;"), true)
  assert_eq(svg.contains("&#8804;"), true)
}

///|
test "render markdown svg uses static connector spacing" {
  let logic = render_markdown_svg("# Root\n## Child", options={
    layout: Logic,
    style: Full,
    layer: Full,
  })
  let tree = render_markdown_svg("# Root\n## Child", options={
    layout: Tree,
    style: Full,
    layer: Full,
  })
  assert_eq(logic.contains("M 270"), true)
  assert_eq(logic.contains(" 370 "), true)
  assert_eq(tree.contains("M 179 158 C 179 202"), true)
  assert_eq(tree.contains("155 308"), true)
}

///|
fn mindmap_style_rules_contain_class(class_name : String) -> Bool {
  for rule in mindmap_style_rules() {
    if rule.class_name == class_name {
      return true
    }
  }
  false
}

///|
test "mindmap style rules expose shared static classes" {
  assert_eq(mindmap_style_rules_contain_class("mindmap-stage"), true)
  assert_eq(mindmap_style_rules_contain_class("node"), true)
  assert_eq(mindmap_style_rules_contain_class("node--center"), true)
  assert_eq(mindmap_style_rules_contain_class("node-body"), true)
  assert_eq(mindmap_style_rules_contain_class("node-action--toggle"), true)
  assert_eq(mindmap_style_rules_contain_class("node-actions--right-mid"), true)
  assert_eq(
    mindmap_style_rules_contain_class("node-actions--bottom-center"),
    true,
  )
  assert_eq(mindmap_style_rules_contain_class("node--line-tree"), true)
  assert_eq(mindmap_style_rules_contain_class("node-body--line-tree"), true)
  assert_eq(mindmap_style_rules_contain_class("mindmap-connector-layer"), true)
  assert_eq(
    mindmap_style_rules_contain_class("single-right-tree__children"),
    true,
  )
  assert_eq(mindmap_style_rules_contain_class("vertical-tree__children"), true)
}

///|
test "mindmap style css serializes shared static classes" {
  let css = mindmap_style_css()
  assert_eq(css.contains(".moonmarkmind-export"), true)
  assert_eq(css.contains("display: inline-block;"), true)
  assert_eq(css.contains("width: max-content;"), true)
  assert_eq(css.contains("background: transparent;"), true)
  assert_eq(css.contains(".mindmap-stage"), true)
  assert_eq(css.contains("min-width: 1120px;"), true)
  assert_eq(css.contains("min-width: 960px;"), true)
  assert_eq(css.contains("gap: 100px;"), true)
  assert_eq(css.contains("padding: 56px 32px 48px;"), true)
  assert_eq(css.contains("padding: 42px 32px 48px;"), true)
  assert_eq(css.contains(".node"), true)
  assert_eq(css.contains(".node-title--scaled"), true)
  assert_eq(css.contains(".node-title--scaled.node-title--line"), true)
  assert_eq(css.contains("line-height: 1.18;"), true)
  assert_eq(css.contains(".node-title--scaled.node-title--fill"), true)
  assert_eq(css.contains("line-height: 1.28;"), true)
  assert_eq(
    css.contains(
      ".node-title--scaled[data-title-center=\"true\"] { font-size: 22px; font-weight: 700; }",
    ),
    true,
  )
  assert_eq(
    css.contains(
      ".node-title--scaled[data-title-depth=\"1\"][data-title-center=\"false\"] { font-size: 20px; }",
    ),
    true,
  )
  assert_eq(css.contains("user-select: text;"), true)
  assert_eq(
    css.contains(
      ".branch-item { position: relative; display: flex; align-items: center; gap: 40px; }",
    ),
    true,
  )
  assert_eq(
    css.contains(
      ".single-right-tree { display: flex; align-items: center; gap: 100px; }",
    ),
    true,
  )
  assert_eq(
    css.contains(
      ".single-right-tree__node { position: relative; display: flex; align-items: center; gap: 60px; }",
    ),
    true,
  )
  assert_eq(
    css.contains(
      ".vertical-tree { position: relative; display: flex; flex-direction: column; align-items: center; gap: 28px; }",
    ),
    true,
  )
  assert_eq(css.contains("padding-top: 28px;"), true)
  assert_eq(css.contains(".node-actions--right-mid"), true)
  assert_eq(css.contains(".node-actions--bottom-center"), true)
  assert_eq(css.contains(".vertical-tree__children--line-tree"), true)
  assert_eq(
    css.contains(".vertical-tree__children--line-tree { gap: 32px; }"),
    true,
  )
  assert_eq(
    css.contains(".vertical-tree--line-note { width: fit-content;"),
    true,
  )
  assert_eq(css.contains("min-width: 180px; max-width: 320px;"), true)
  assert_eq(css.contains(".node--line-tree"), true)
  assert_eq(
    css.contains(
      "border-bottom: 1.4px solid var(--mindmap-connector-color, #94b6db);",
    ),
    true,
  )
  assert_eq(css.contains("max-width: 180px;"), true)
  assert_eq(css.contains("min-width: 160px; max-width: 320px;"), true)
  assert_eq(css.contains(".node-body--line-tree"), true)
  assert_eq(css.contains(".node-body--line-tree { width: fit-content;"), true)
  assert_eq(css.contains("top: calc(100% + 15px);"), true)
  assert_eq(css.contains("transform: translate(50%, -50%);"), true)
  assert_eq(css.contains(".node-note-rail"), true)
  assert_eq(css.contains("gap: 6px;"), true)
  assert_eq(css.contains("margin-top: 8px;"), true)
  assert_eq(css.contains(".node-body"), true)
  assert_eq(css.contains("box-sizing: border-box;"), true)
  assert_eq(css.contains("max-width: 100%;"), true)
  assert_eq(css.contains(".node-action--note { position: absolute"), false)
  assert_eq(css.contains("text-indent: -999px;"), true)
  assert_eq(css.contains("border-left: 2px"), false)
  assert_eq(css.contains("border-top: 2px"), false)
  assert_eq(css.contains("[hidden]"), true)
}

///|
test "svg export is static and contains no script runtime" {
  let svg = render_markdown_svg("# Root\n## Child")
  assert_false(svg.contains("<script"))
  assert_false(svg.contains("javascript:"))
  assert_false(svg.contains("CDATA"))
  assert_true(svg.contains("data-static-connectors=\"true\""))
}

///|
test "structured markup serializer escapes text and attributes" {
  let node = html_element(
    "div",
    attributes=[markup_attribute("data-value", "\" onerror=\"alert(1)")],
    children=[markup_text("<script>alert(1)</script></style>")],
  )
  let html = serialize_markup(node)
  assert_false(html.contains("<script>"))
  assert_false(html.contains(" onerror=\"alert(1)\""))
  assert_true(html.contains("&lt;script&gt;alert(1)&lt;/script&gt;"))
  assert_true(html.contains("&quot; onerror=&quot;alert(1)"))
}

///|
test "structured documents cover layouts and stay script free" {
  let markdown = "# Root\nRoot note\n## Child"
  let layouts : Array[MindmapLayout] = [Logic, Mindmap, Tree]
  for layout in layouts {
    let tree = build_markdown_document(markdown, options={
      layout,
      style: Full,
      layer: Full,
    })
    let html = serialize_markup(tree)
    assert_true(html.contains("moonmarkmind-export"))
    assert_true(html.contains("Root"))
    assert_true(html.contains("Child"))
    assert_false(html.contains("<script"))
  }
  let svg = serialize_markup(build_markdown_svg_document(markdown))
  assert_true(svg.contains("<svg"))
  assert_true(svg.contains("<foreignObject"))
  assert_false(svg.contains("<script"))
}

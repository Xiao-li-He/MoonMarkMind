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
  assert_eq(svg.contains("<script><![CDATA["), true)
  assert_eq(svg.contains("renderConnectors"), true)
  assert_eq(svg.contains("resizeSvgCanvas"), true)
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
      ".single-right-tree { display: flex; align-items: center; gap: 56px; }",
    ),
    true,
  )
  assert_eq(css.contains(".node-actions--right-mid"), true)
  assert_eq(css.contains(".node-actions--bottom-center"), true)
  assert_eq(css.contains(".vertical-tree__children--line-tree"), true)
  assert_eq(
    css.contains(".vertical-tree__children--line-tree { gap: 56px; }"),
    true,
  )
  assert_eq(css.contains(".vertical-tree--line-note { width: 360px;"), true)
  assert_eq(css.contains(".node--line-tree"), true)
  assert_eq(
    css.contains(
      "border-bottom: 1.4px solid var(--mindmap-connector-color, #94b6db);",
    ),
    true,
  )
  assert_eq(css.contains("max-width: 130px;"), true)
  assert_eq(css.contains(".node-body--line-tree"), true)
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
test "export runtime hides node containers with display override" {
  let script = render_export_runtime_script()
  assert_eq(script.contains("setHidden"), true)
  assert_eq(script.contains("display\", \"none\", \"important"), true)
  assert_eq(script.contains("hasAttribute(\"hidden\")"), true)
  assert_eq(script.contains("ensureHtmlVisibleBounds"), true)
  assert_eq(script.contains("visibleNodeBounds"), true)
  assert_eq(script.contains("root.style.paddingLeft"), true)
}

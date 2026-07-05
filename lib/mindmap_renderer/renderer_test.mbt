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
  assert_eq(line.contains("Beta Child"), false)
  assert_eq(root_only.contains("Alpha"), false)
  assert_eq(root_only.contains("Beta Child"), false)
}

///|
test "render markdown body and svg shell" {
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
  assert_eq(svg.contains("<style>"), false)
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
  assert_eq(
    mindmap_style_rules_contain_class("single-right-tree__children"),
    true,
  )
  assert_eq(mindmap_style_rules_contain_class("vertical-tree__children"), true)
}

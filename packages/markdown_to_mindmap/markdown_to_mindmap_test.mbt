///|
fn sample_markdown() -> String {
  (
    #|# Root
    #|Root note with $x^2$.
    #|
    #|## Alpha
    #|Alpha paragraph.
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
test "render markdown to mindmap html fragment" {
  let html = render(sample_markdown())
  assert_eq(html.contains("moonmarkmind-export"), true)
  assert_eq(html.contains("mindmap-stage--single-right"), true)
  assert_eq(html.contains("Root"), true)
  assert_eq(html.contains("<style>"), false)
}

///|
test "render markdown to mindmap svg" {
  let svg = render_svg(sample_markdown(), options={
    layout: Mindmap,
    style: Full,
    layer: Full,
  })
  assert_eq(svg.contains("<svg"), true)
  assert_eq(svg.contains("<foreignObject"), true)
  assert_eq(svg.contains("Root"), true)
}

///|
test "render complete html document with shared styles" {
  let html = render_html_document(sample_markdown())
  assert_eq(html.contains("<!doctype html>"), true)
  assert_eq(html.contains("<style>"), true)
  assert_eq(html.contains(".moonmarkmind-export"), true)
  assert_eq(html.contains(".markdown-math"), true)
  assert_eq(html.contains(".markdown-heading"), true)
}

///|
test "render options control layout style and layer" {
  let html = render(sample_markdown(), options={
    layout: Tree,
    style: Line,
    layer: Root,
  })
  assert_eq(html.contains("mindmap-stage--vertical"), true)
  assert_eq(html.contains("moonmarkmind-export--line"), true)
  assert_eq(html.contains("node--fill node--branch-line"), true)
  assert_eq(html.contains("Alpha"), false)
  assert_eq(html.contains("Beta Child"), false)
}

///|
test "normalize option helpers are re-exported" {
  let options : RenderOptions = {
    layout: normalize_layout("tree"),
    style: normalize_style("line"),
    layer: normalize_layer("layer2"),
  }
  let html = render(sample_markdown(), options~)
  assert_eq(html.contains("mindmap-stage--vertical"), true)
  assert_eq(html.contains("Beta Child"), false)
}

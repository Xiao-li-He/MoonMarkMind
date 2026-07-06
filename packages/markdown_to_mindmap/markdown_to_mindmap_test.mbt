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
  assert_eq(html.contains("mindmap-connector-layer"), true)
  assert_eq(html.contains("node-action--toggle"), true)
  assert_eq(html.contains("data-action=\"toggle\""), true)
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
  assert_eq(svg.contains("<style>"), true)
  assert_eq(svg.contains("<script><![CDATA["), true)
  assert_eq(svg.contains("renderConnectors"), true)
  assert_eq(svg.contains("data-static-connectors=\"true\""), true)
  assert_eq(svg.contains(".node"), true)
  assert_eq(svg.contains("mindmap-connector-layer"), true)
  assert_eq(svg.contains("<path"), true)
  assert_eq(svg.contains("Root"), true)
}

///|
test "render complete html document with shared styles and runtime" {
  let html = render_html_document(sample_markdown())
  assert_eq(html.contains("<!doctype html>"), true)
  assert_eq(html.contains("<style>"), true)
  assert_eq(html.contains(".moonmarkmind-export"), true)
  assert_eq(html.contains(".markdown-math"), true)
  assert_eq(html.contains(".markdown-heading"), true)
  assert_eq(html.contains("<script>"), true)
  assert_eq(html.contains("renderConnectors"), true)
  assert_eq(html.contains("node-action--toggle"), true)
  assert_eq(html.contains("data-action=\"toggle\""), true)
}

///|
test "render export runtime can be embedded separately" {
  let script = render_export_runtime_script()
  assert_eq(script.contains("<script>"), true)
  assert_eq(script.contains("data-action"), true)
  assert_eq(script.contains("mindmap-connector-layer"), true)
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

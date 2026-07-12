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
  assert_eq(svg.contains("<script"), false)
  assert_eq(svg.contains("renderConnectors"), false)
  assert_eq(svg.contains("resizeSvgCanvas"), false)
  assert_eq(svg.contains("data-static-connectors=\"true\""), true)
  assert_eq(svg.contains(".node"), true)
  assert_eq(svg.contains("mindmap-connector-layer"), true)
  assert_eq(svg.contains("<path"), true)
  assert_eq(svg.contains("Root"), true)
}

///|
test "render markdown to mindmap svg is xml safe for math entities" {
  let svg = render_svg(
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
  assert_eq(svg.contains("<foreignObject"), true)
  assert_eq(svg.contains("data-static-connectors=\"true\""), true)
  assert_eq(svg.contains("resizeSvgCanvas"), false)
}

///|
test "render complete static html document with shared styles" {
  let html = render_html_document(sample_markdown())
  assert_eq(html.contains("<!doctype html>"), true)
  assert_eq(html.contains("<style>"), true)
  assert_eq(html.contains(".moonmarkmind-export"), true)
  assert_eq(html.contains(".markdown-math"), true)
  assert_eq(html.contains(".markdown-heading"), true)
  assert_eq(html.contains("<script>"), false)
  assert_eq(html.contains("renderConnectors"), false)
  assert_eq(html.contains("node-action--toggle"), true)
  assert_eq(html.contains("data-action=\"toggle\""), true)
}

///|
test "render svg is a static document" {
  let svg = render_svg(sample_markdown())
  assert_false(svg.contains("<script"))
  assert_false(svg.contains("javascript:"))
  assert_false(svg.contains("CDATA"))
}

///|
test "build structured documents without raw script nodes" {
  let document : MarkupNode = build_document(sample_markdown())
  let svg_document : MarkupNode = build_svg_document(sample_markdown())
  let _ = document
  let _ = svg_document
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
  assert_eq(html.contains("node--line-tree"), true)
  assert_eq(html.contains("Alpha"), false)
  assert_eq(html.contains("Beta Child"), false)
}

///|
test "render tree line svg keeps web line classes" {
  let svg = render_svg(sample_markdown(), options={
    layout: Tree,
    style: Line,
    layer: Full,
  })
  assert_eq(svg.contains("node--line-tree"), true)
  assert_eq(svg.contains("vertical-tree__children--line-tree"), true)
  assert_eq(svg.contains("node-actions--bottom-center"), true)
  assert_eq(svg.contains("node-body--line-tree"), true)
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

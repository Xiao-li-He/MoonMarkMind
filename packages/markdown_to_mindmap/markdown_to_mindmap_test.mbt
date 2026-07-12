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
  assert_eq(svg.contains("javascript:"), false)
  assert_eq(svg.contains("renderConnectors"), false)
  assert_eq(svg.contains("resizeSvgCanvas"), false)
  assert_eq(svg.contains("data-static-connectors=\"true\""), true)
  assert_eq(svg.contains(".node"), true)
  assert_eq(svg.contains(".markdown-math"), true)
  assert_eq(svg.contains(".markdown-heading"), true)
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
test "render svg is a static document" {
  let svg = render_svg(sample_markdown())
  assert_false(svg.contains("<script"))
  assert_false(svg.contains("javascript:"))
  assert_false(svg.contains("CDATA"))
}

///|
test "build structured svg document without raw script nodes" {
  let svg_document : MarkupNode = build_svg_document(sample_markdown())
  let _ = svg_document
}

///|
test "render options control layout style and layer" {
  let svg = render_svg(sample_markdown(), options={
    layout: Tree,
    style: Line,
    layer: Root,
  })
  assert_eq(svg.contains("mindmap-stage--vertical"), true)
  assert_eq(svg.contains("moonmarkmind-export--line"), true)
  assert_eq(svg.contains("node--fill node--branch-line"), true)
  assert_eq(svg.contains("node--line-tree"), true)
  assert_eq(svg.contains("Alpha"), false)
  assert_eq(svg.contains("Beta Child"), false)
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
  let svg = render_svg(sample_markdown(), options~)
  assert_eq(svg.contains("mindmap-stage--vertical"), true)
  assert_eq(svg.contains("Beta Child"), false)
}

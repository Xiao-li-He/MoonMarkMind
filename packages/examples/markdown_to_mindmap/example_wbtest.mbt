///|
test "sample renderer produces standalone html and svg" {
  let markdown = "# Root\n\nRoot body.\n\n## Child"
  let html = render_sample_html(markdown, layout="tree", style="line")
  let svg = render_sample_svg(markdown, layout="tree", style="line")
  assert_true(html.contains("<!doctype html>"))
  assert_true(html.contains("<style>"))
  assert_true(html.contains("moonmarkmind-export"))
  assert_true(html.contains("mindmap-stage--vertical"))
  assert_true(html.contains("moonmarkmind-export--line"))
  assert_true(html.contains("node--line-tree"))
  assert_true(html.contains("node-actions--bottom-center"))
  assert_false(html.contains("<script>"))
  assert_true(html.contains("node-action--toggle"))
  assert_false(html.contains("data-action=\"toggle\""))
  assert_true(html.contains("mindmap-connector-layer"))
  assert_true(svg.contains("<svg"))
  assert_true(svg.contains("<foreignObject"))
  assert_true(svg.contains("<style>"))
  assert_false(svg.contains("<script"))
  assert_false(svg.contains("renderConnectors"))
  assert_false(svg.contains("resizeSvgCanvas"))
  assert_true(svg.contains("data-static-connectors=\"true\""))
  assert_true(svg.contains("node--line-tree"))
  assert_true(svg.contains("node-actions--bottom-center"))
  assert_true(svg.contains("node-action--toggle"))
  assert_true(svg.contains("mindmap-connector-layer"))
  assert_true(svg.contains("<path"))
  assert_true(svg.contains("Child"))
}

///|
test "sample svg output keeps math entities xml safe" {
  let markdown = "# Formula\n\nUse $x \\pm \\alpha \\le y$."
  let svg = render_sample_svg(markdown)
  assert_eq(svg.contains("&plusmn;"), false)
  assert_eq(svg.contains("&alpha;"), false)
  assert_eq(svg.contains("&le;"), false)
  assert_true(svg.contains("&#177;"))
  assert_true(svg.contains("&#945;"))
  assert_true(svg.contains("&#8804;"))
  assert_false(svg.contains("resizeSvgCanvas"))
}

///|
test "sample svg output self closes markdown line breaks" {
  let markdown = "# Root\n\nValue $x^2$  \nnext"
  let svg = render_sample_svg(markdown, layout="logic", style="line")
  assert_true(svg.contains("<br class=\"markdown-line-break\" />"))
  assert_false(svg.contains("<br class=\"markdown-line-break\">"))
}

///|
test "sample tree line output uses compact adaptive note nodes" {
  let markdown = "# Root\n\n## Note\nBody text\n\n## Table\n| A | B |\n|---|---|\n| 1 | 2 |"
  let html = render_sample_html(markdown, layout="tree", style="line")
  assert_true(
    html.contains(".vertical-tree__children--line-tree { gap: 32px; }"),
  )
  assert_true(html.contains(".vertical-tree--line-note { width: fit-content;"))
  assert_true(html.contains(".node--line-tree-note"))
  assert_true(html.contains(".node-body--line-tree { width: fit-content;"))
  assert_false(html.contains(".vertical-tree--line-note { width: 360px;"))
}

///|
test "example paths cover sample markdown files" {
  let names = sample_names()
  let variants = example_variants()
  assert_eq(names.length(), 4)
  assert_eq(variants.length(), 6)
  assert_eq(sample_input_path(names[0]), "samples/example1.md")
  assert_eq(variants[0].layout, "logic")
  assert_eq(variants[0].style, "full")
  assert_eq(variants[5].layout, "tree")
  assert_eq(variants[5].style, "line")
  assert_eq(
    html_output_path(names[3], variants[5]),
    "packages/examples/markdown_to_mindmap/output/example4.tree.line.html",
  )
  assert_eq(
    svg_output_path(names[3], variants[5]),
    "packages/examples/markdown_to_mindmap/output/example4.tree.line.svg",
  )
}

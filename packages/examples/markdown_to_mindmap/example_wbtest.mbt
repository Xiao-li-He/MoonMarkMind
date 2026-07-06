///|
test "sample renderer produces standalone html and svg" {
  let markdown = "# Root\n\nRoot body.\n\n## Child"
  let html = render_sample_html(markdown)
  let svg = render_sample_svg(markdown)
  assert_true(html.contains("<!doctype html>"))
  assert_true(html.contains("<style>"))
  assert_true(html.contains("moonmarkmind-export"))
  assert_true(html.contains("<script>"))
  assert_true(html.contains("node-action--toggle"))
  assert_true(html.contains("data-action=\"toggle\""))
  assert_true(html.contains("mindmap-connector-layer"))
  assert_true(svg.contains("<svg"))
  assert_true(svg.contains("<foreignObject"))
  assert_true(svg.contains("<style>"))
  assert_true(svg.contains("node-action--toggle"))
  assert_true(svg.contains("mindmap-connector-layer"))
  assert_true(svg.contains("<path"))
  assert_true(svg.contains("Child"))
}

///|
test "example paths cover sample markdown files" {
  let names = sample_names()
  assert_eq(names.length(), 4)
  assert_eq(sample_input_path(names[0]), "samples/example1.md")
  assert_eq(
    html_output_path(names[3]),
    "packages/examples/markdown_to_mindmap/output/example4.html",
  )
  assert_eq(
    svg_output_path(names[3]),
    "packages/examples/markdown_to_mindmap/output/example4.svg",
  )
}

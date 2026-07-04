# mindmap_renderer

Pure string HTML/SVG rendering helpers for MoonMarkMind outlines.

```mbt check
///|
test {
  let html = render_markdown_html(
    "# Root\n## Child",
    options=default_render_options(),
  )
  assert_true(html.contains("moonmarkmind-node"))
}
```

# markdown_to_mindmap

`markdown_to_mindmap` is the public Markdown-to-mind-map package. It renders
static HTML/SVG strings without depending on the browser DOM, Canvas, downloads,
or the web editor state.

## Import

```text
import {
  "Xiao-li-He/MoonMarkMind/packages/markdown_to_mindmap" @to_mindmap
}
```

## Quick Start

```mbt check
///|
test {
  let html = render("# Root\n## Child")
  assert_true(html.contains("moonmarkmind-export"))

  let svg = render_svg("# Root\n## Child")
  assert_true(svg.contains("<foreignObject"))

  let document = render_html_document("# Root\n## Child")
  assert_true(document.contains("<style>"))
}
```

## Options

```mbt check
///|
test {
  let html = render("# Root\n## Child", options={
    layout: Tree,
    style: Line,
    layer: Full,
  })
  assert_true(html.contains("mindmap-stage--vertical"))
}
```

Use `render_style_css()` or `render_style_element()` when embedding the fragment
into your own page. Use `render_html_document()` when you want a complete
standalone static document.

PNG export is intentionally not exposed here. PNG generation needs a browser or
another rasterizer to lay out HTML/SVG and draw to pixels; the MoonMarkMind web
app keeps that browser-only path in `app/web`.

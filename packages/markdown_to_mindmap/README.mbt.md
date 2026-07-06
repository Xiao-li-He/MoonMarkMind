# markdown_to_mindmap

`markdown_to_mindmap` is the public Markdown-to-mind-map package. It renders
HTML/SVG strings without depending on Canvas, downloads, or the web editor
state. Complete HTML documents include the small export runtime that draws
connectors from browser DOM measurements and handles node/note collapse.

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

Use `render_style_css()`, `render_style_element()`, and
`render_export_runtime_script()` when embedding the fragment into your own page.
Use `render_html_document()` when you want a complete standalone interactive
document.

SVG export embeds styles, nodes, and a static connector layer. Without launching
a browser it cannot read the same DOM rectangles used by the web app download
path, so SVG paths are visually aligned with the shared export contract rather
than guaranteed to be pixel-identical to browser-generated SVG.

PNG export is intentionally not exposed here. PNG generation needs a browser or
another rasterizer to lay out HTML/SVG and draw to pixels; the MoonMarkMind web
app keeps that browser-only path in `app/web`.

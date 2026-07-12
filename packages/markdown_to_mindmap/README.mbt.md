# markdown_to_mindmap

`markdown_to_mindmap` is the public Markdown-to-mind-map package. It renders
structured markup plus serialized HTML/SVG exports without depending on Canvas,
downloads, or the web editor state. SVG and complete HTML documents are static
reading artifacts and contain no embedded script runtime.

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

  let tree = build_document("# Root\n## Child")
  let _ : MarkupNode = tree
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

Use `build_document()` or `build_svg_document()` when adapting the output to a
native DOM API. Use `render_style_css()` and `render_style_element()` only at a
file serialization boundary. `render_html_document()` creates a complete static
document.

SVG export embeds styles, nodes, and static connector paths. It deliberately
contains no JavaScript, event attributes, or runtime-generated connector code.

PNG export is intentionally not exposed here. PNG generation needs a browser or
another rasterizer to lay out HTML/SVG and draw to pixels; the MoonMarkMind web
app keeps that browser-only path in `app/web`.

# markdown_to_mindmap

`markdown_to_mindmap` is the public Markdown-to-mind-map package. It renders
static SVG exports without depending on Canvas, downloads, or the web editor
state. SVG documents are static reading artifacts and contain no embedded script
runtime.

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
  let svg = render_svg("# Root\n## Child")
  assert_true(svg.contains("<foreignObject"))

  let tree = build_svg_document("# Root\n## Child")
  let _ : MarkupNode = tree
}
```

## Options

```mbt check
///|
test {
  let svg = render_svg("# Root\n## Child", options={
    layout: Tree,
    style: Line,
    layer: Full,
  })
  assert_true(svg.contains("mindmap-stage--vertical"))
}
```

SVG export embeds styles, nodes, and static connector paths. It deliberately
contains no JavaScript, event attributes, or runtime-generated connector code.
Use `build_svg_document()` when adapting the SVG output to a native DOM API.

PNG export is intentionally not exposed here. PNG generation needs a browser or
another rasterizer to lay out HTML/SVG and draw to pixels; the MoonMarkMind web
app keeps that browser-only path in `app/web`.

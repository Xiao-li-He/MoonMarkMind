# mindmap_render

`mindmap_render` is the pure string renderer for MoonMarkMind. It turns
Markdown or an `OutlineNode` into static mind-map HTML/SVG without depending on
browser DOM measurement, Canvas, downloads, or editor interactions.

## Import

```text
import {
  "Xiao-li-He/MoonMarkMind/lib/mindmap_render" @mindmap
}
```

## Quick Start

```mbt check
///|
test {
  let html = render_markdown_html(
    "# Root\n## Child",
    options=default_render_options(),
  )
  assert_true(html.contains("moonmarkmind-export"))
  assert_true(html.contains("mindmap-stage--single-right"))
  assert_true(html.contains("Root"))
}
```

## Core APIs

```mbt check
///|
test {
  let outline = @outline.build_outline("# Root\n## Child")
  let html = render_outline_html(outline)
  let svg = render_outline_svg(outline)
  assert_true(html.contains("data-node-index=\"1\""))
  assert_true(svg.contains("<foreignObject"))
}
```

`RenderOptions` controls the static view:

- `layout`: `Logic`, `Mindmap`, or `Tree`
- `style`: `Full` or `Line`
- `layer`: `Root`, `Layer2`, or `Full`

```mbt check
///|
test {
  assert_eq(layer_to_detail_select(Root), "small")
  assert_eq(layer_to_detail_select(Layer2), "medium")
  assert_eq(layer_to_detail_select(Full), "all")
}
```

Use `mindmap_style_rules()` when embedding the renderer into a larger page.
The renderer does not generate or inject `<style>` tags; CLI or Web callers can
decide explicitly how to apply or serialize the structured declarations.

## Notes

- The package renders static reading/export artifacts only.
- Browser-only behavior remains in `app/web`: editing, drag and drop, zoom,
  DOM measurement, Canvas PNG export, and downloads.
- PNG generation for command-line use should rasterize the generated SVG/HTML in
  a separate CLI layer.

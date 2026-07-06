# markdown_to_mindmap example

This example renders the repository sample Markdown files to interactive
mind-map HTML and standalone SVG using `packages/markdown_to_mindmap`.

## Run

From the repository root:

```powershell
moon run packages/examples/markdown_to_mindmap
```

It reads:

```text
samples/example1.md
samples/example2.md
samples/example3.md
samples/example4.md
```

and writes:

```text
packages/examples/markdown_to_mindmap/output/example1.html
packages/examples/markdown_to_mindmap/output/example1.svg
packages/examples/markdown_to_mindmap/output/example2.html
packages/examples/markdown_to_mindmap/output/example2.svg
packages/examples/markdown_to_mindmap/output/example3.html
packages/examples/markdown_to_mindmap/output/example3.svg
packages/examples/markdown_to_mindmap/output/example4.html
packages/examples/markdown_to_mindmap/output/example4.svg
```

PNG export is not part of this package example because PNG generation needs a
browser or another rasterizer to convert the HTML/SVG layout into pixels.

The HTML output includes the same export node attributes, toggle buttons,
connector layer, and runtime contract used by the web export path. The SVG
output embeds styles, nodes, static fallback connector paths, and the browser
measurement runtime; when opened directly in a browser it redraws connectors
from the actual node rectangles. In script-disabled SVG contexts, the static
fallback remains visible.

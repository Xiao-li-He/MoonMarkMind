# markdown_to_mindmap example

This example renders the repository sample Markdown files to standalone SVG
using `packages/markdown_to_mindmap`.

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

and writes every `layout × style` combination:

```text
layouts: logic, mindmap, tree
styles: full, line
layer: full
format: svg
```

The output file name includes the selected layout and style:

```text
packages/examples/markdown_to_mindmap/output/example1.logic.full.svg
packages/examples/markdown_to_mindmap/output/example1.mindmap.line.svg
packages/examples/markdown_to_mindmap/output/example1.tree.line.svg
```

The command generates 24 files in total: 4 samples, 3 layouts, 2 styles, and
the SVG format.

PNG export is not part of this package example because PNG generation needs a
browser or another rasterizer to convert the HTML/SVG layout into pixels.

The SVG output embeds styles, nodes, and static connector paths. It contains no
embedded script runtime.

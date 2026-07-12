# moonmarkmind CLI

Export one Markdown outline to one PNG, SVG, or standalone HTML file through
the MoonMarkMind browser renderer.

The shortest invocation uses PNG, logic layout, full style, full detail, and
writes `output/example1.png`:

```powershell
moon run cmd/cli samples/example1.md
```

Choose a format or rendering options explicitly:

```powershell
moon run cmd/cli samples/example1.md --format svg --layout mindmap --style line --layer layer2
moon run cmd/cli samples/example1.md --format html -o dist/map.html
```

`-o`/`--output` is an optional output file path. A `.png`, `.svg`, or `.html`
extension infers the format, so this also exports SVG:

```powershell
moon run cmd/cli samples/example1.md -o dist/map.svg
```

When both `--format` and an output extension are present, they must agree. The
CLI accepts exactly one Markdown file and one format per invocation; directory
inputs, multiple files, and comma-separated formats are rejected.

Defaults:

- `--format png`
- `--layout logic`
- `--style full`
- `--layer full`
- `--output output/<input-stem>.<format>`

PNG, SVG, and HTML are all exported through Chrome or Edge in headless mode.
Pass `--browser <path>` when the browser cannot be detected automatically.

`--layer` controls how much node detail is included in the export. It maps to the Web app detail selector:

- `root`: compact view, emphasizing the main structure
- `layer2`: medium view, showing content up to the second level
- `full`: full view, showing all node content

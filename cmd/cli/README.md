# moonmarkmind CLI

Batch export Markdown outlines from a local terminal.

```powershell
moon run cmd/cli -- ./samples --output png,svg,html --layout mindmap --style full --layer full
moon run cmd/cli -- ./samples/example1.md ./samples/example2.md --output html --layout tree --style line --layer layer2 -o output
```

By default, exported files are written to `output/` and `--output` defaults to
`png,svg,html`:

- `output/example1.png`
- `output/example1.svg`
- `output/example1.html`

Inputs may be Markdown files or directories. Directory inputs scan first-level
`.md` files only. Duplicate output stems fail early to avoid overwriting files.

All formats are exported through the Web app renderer. PNG requires Chrome or
Edge in headless mode; pass `--browser <path>` when it cannot be detected.

`--layer` maps to the Web app detail selector:

- `root` -> `small`
- `layer2` -> `medium`
- `full` -> `all`

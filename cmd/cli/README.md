# moonmarkmind CLI

Batch export Markdown outlines from a local terminal.

```powershell
moon run cmd/cli -- ./samples/example1.md --output svg --layout logic --style full --layer full
moon run cmd/cli -- ./samples/example1.md --output html --layout tree --style line --layer layer2 -o output
```

By default, exported files are written to `output/`:

- `output/example1.svg`
- `output/example1.html`

`--layer` maps to the Web app detail selector:

- `root` -> `small`
- `layer2` -> `medium`
- `full` -> `all`

PNG and XMind export are reserved for later work.

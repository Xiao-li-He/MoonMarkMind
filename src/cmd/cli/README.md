# moonmarkmind CLI

Batch export Markdown outlines from a local terminal.

```powershell
moon run cmd/cli -- ./samples/part1.md --output svg --layout logic --style full --layer full
moon run cmd/cli -- ./samples/part1.md --output html --layout tree --style line --layer layer2
```

`--layer` maps to the Web app detail selector:

- `root` -> `small`
- `layer2` -> `medium`
- `full` -> `all`

PNG export is reserved for the browser Canvas pipeline.

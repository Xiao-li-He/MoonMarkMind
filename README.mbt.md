# MindDown

MindDown is a MoonBit-first Markdown mindmap demo.

It takes a heading-based Markdown outline, renders an ASCII mindmap with MoonBit, and exposes a browser UI that supports:

- center-out mindmap layout
- collapse and expand
- inline node rename
- sibling drag-and-drop reorder
- add child node
- delete node

The important part is that the core document operations are implemented in MoonBit, not in the browser layer.

## Architecture

The project is split into two layers:

- MoonBit core:
  parses heading outlines, exports tree JSON, renames nodes, reorders sibling subtrees, adds nodes, deletes nodes, and serializes Markdown back out
- Web UI:
  renders the mindmap, handles drag/edit button events, and calls the MoonBit-generated JS bundle

Main MoonBit files:

- `heading_parser.mbt`
- `mindmap_renderer.mbt`
- `outline_model.mbt`
- `web_api.mbt`

Main web files:

- `web/index.html`
- `web/app.js`
- `build-web.ps1`

## MoonBit APIs

The browser currently calls these MoonBit APIs:

- `outline_json(markdown)`
- `render_ascii_mindmap(markdown)`
- `rename_heading(markdown, flat_index, title)`
- `move_heading(markdown, from_flat_index, to_flat_index, place_after)`
- `add_child_heading(markdown, parent_flat_index, title)`
- `delete_heading(markdown, flat_index)`

## Local Development

Install MoonBit first, then run:

```powershell
moon check
moon test
```

Run the CLI demo:

```powershell
moon run cmd/main
```

Build the browser bundle:

```powershell
powershell -ExecutionPolicy Bypass -File .\build-web.ps1
```

Serve the web folder locally:

```powershell
python -m http.server 8080 -d web
```

Open:

```text
http://localhost:8080
```

## Current Interaction Model

In the browser demo:

- double-click a title to rename a node
- click `+` to add a child node
- click `×` to delete a node subtree
- drag a node onto a sibling to reorder within the same parent
- click a node or collapse button to fold or expand a subtree

After each operation, the Markdown source and ASCII preview are regenerated from MoonBit output.

## Validation

Core checks:

```powershell
moon check
moon test
moon info
```

Web bundle:

- generated from `moon build --target js --release`
- bridged through `build-web.ps1`

## Notes

- The current Markdown model is heading-only.
- Rich text blocks, lists, and arbitrary Markdown body content are not preserved yet.
- Cross-parent drag-to-change-depth is not implemented yet.

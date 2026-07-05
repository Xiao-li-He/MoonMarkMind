# markdown_to_html example

This example demonstrates how to pass Markdown text to `packages/markdown_to_html` and receive safe HTML. The generated `example1.html` uses native collapsible heading sections.

The sample document `example1.md` intentionally covers rich syntax: paragraphs, emphasis, strike-through, inline code, links, images, tasks, tables, fenced code, inline math, block math, and unsafe HTML escaping.

## Run

From the repository root:

```powershell
moon run packages/examples/markdown_to_html
```

This reads:

```text
packages/examples/markdown_to_html/example1.md
```

and writes:

```text
packages/examples/markdown_to_html/example1.html
```

## Quick Start

```moonbit
test {
  let html = render_rich_markdown_html()
  assert_true(html.contains("markdown-strong"))
  assert_true(html.contains("markdown-table"))
  assert_true(html.contains("markdown-math--block"))

  let collapsible = render_rich_markdown_collapsible_html()
  assert_true(collapsible.contains("markdown-section"))
}
```

## Use the Package Directly

```moonbit
test {
  let html = @to_html.render("Hello **MoonBit**\n\n$$x^2$$")
  assert_true(html.contains("markdown-strong"))
  assert_true(html.contains("markdown-math--block"))

  let collapsible = @to_html.render_collapsible("# Title\nBody")
  assert_true(collapsible.contains("<details"))
}
```

## Notes

- `render_rich_markdown_html()` returns an HTML fragment for tests and documentation.
- Running the example package writes a minimal complete HTML document with native collapsible heading sections and shared style rules.
- Browser DOM rendering and export behavior remain in `app/web`.

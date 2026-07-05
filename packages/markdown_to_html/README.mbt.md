# markdown_to_html

User-facing MoonMarkMind package for rendering Markdown text to safe HTML fragments.

This package is a small facade over `lib/markdown_render`. Use it when you want a simple programmable API: input Markdown text, output HTML text.

## Install / Import

Add the package in `moon.pkg`:

```text
import {
  "Xiao-li-He/MoonMarkMind/packages/markdown_to_html" @markdown_to_html
}
```

## Quick Start

```mbt check
///|
test {
  let html = render("Hello **MoonBit**\n\n$$x^2$$")
  assert_true(html.contains("markdown-strong"))
  assert_true(html.contains("markdown-math--block"))
}
```

Inline and title rendering:

```mbt check
///|
test {
  let inline = render_inline("Value $x^2$ and `code`")
  let title = render_title("[x] Done")
  assert_true(inline.contains("markdown-math--inline"))
  assert_true(title.contains("markdown-task--title"))
}
```

## Core APIs

- `render(markdown : String) -> String`: render Markdown body text to an HTML fragment.
- `render_inline(source : String) -> String`: render inline Markdown to an HTML fragment.
- `render_title(source : String) -> String`: render a node title, including task markers.
- `render_blocks(blocks : Array[String]) -> String`: render pre-split Markdown body blocks.
- `render_math_style_css() -> String`: render the shared math visual rules as CSS.
- `render_style_element() -> String`: render a `<style>` element for standalone HTML documents.

## Notes

- The output is an HTML fragment, not a complete HTML document.
- This package covers the Markdown subset used by MoonMarkMind nodes.
- Text is escaped, and unsafe links or image sources degrade to safe text.
- LaTeX formulas are rendered through `lib/latex_math_render`.
- Standalone HTML documents can include `render_style_element()` so fractions, radicals, and scripts use the same visual rules as the Web mind map.

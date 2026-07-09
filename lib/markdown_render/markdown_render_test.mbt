///|
test "inline markdown renders rich html and math" {
  let html = render_markdown_inline_html(
    "[Link](https://example.com) **Bold** _Italic_ `Code` ~~Gone~~ ==Hot== $x^2$",
  )
  assert_eq(html.contains("class=\"markdown-link\""), true)
  assert_eq(html.contains("href=\"https://example.com\""), true)
  assert_eq(html.contains("class=\"markdown-strong\""), true)
  assert_eq(html.contains("class=\"markdown-emphasis\""), true)
  assert_eq(html.contains("class=\"markdown-inline-code\""), true)
  assert_eq(html.contains("class=\"markdown-strike\""), true)
  assert_eq(
    html.contains("<mark class=\"markdown-highlight\">Hot</mark>"),
    true,
  )
  assert_eq(
    html.contains("class=\"markdown-math markdown-math--inline\""),
    true,
  )
  assert_eq(html.contains("<sup>2</sup>"), true)
}

///|
test "backslash escapes inline markdown markers" {
  let html = render_markdown_inline_html(
    "\\**not bold\\** and \\$not math\\$ and \\==not highlight\\==",
  )
  assert_eq(html.contains("markdown-strong"), false)
  assert_eq(html.contains("markdown-math"), false)
  assert_eq(html.contains("markdown-highlight"), false)
  assert_eq(html.contains("**not bold**"), true)
  assert_eq(html.contains("$not math$"), true)
  assert_eq(html.contains("==not highlight=="), true)
}

///|
test "highlight markdown keeps incomplete empty and unsafe content literal safe" {
  let unclosed = render_markdown_inline_html("A ==hot")
  assert_eq(unclosed.contains("markdown-highlight"), false)
  assert_eq(unclosed.contains("A ==hot"), true)
  let empty = render_markdown_inline_html("A ==== B")
  assert_eq(empty.contains("markdown-highlight"), false)
  assert_eq(empty.contains("A ==== B"), true)
  let escaped = render_markdown_inline_html("A ==<script>== B")
  assert_eq(
    escaped.contains("<mark class=\"markdown-highlight\">&lt;script&gt;</mark>"),
    true,
  )
  assert_eq(escaped.contains("<script>"), false)
}

///|
test "soft line break renders as a space" {
  let html = render_markdown_inline_html("Alpha\nBeta")
  assert_eq(html, "Alpha Beta")
  assert_eq(html.contains("markdown-line-break"), false)
}

///|
test "two trailing spaces render a hard line break" {
  let html = render_markdown_inline_html("Alpha  \nBeta")
  assert_eq(
    html.contains("Alpha<br class=\"markdown-line-break\" />Beta"),
    true,
  )
}

///|
test "trailing backslash renders a hard line break" {
  let html = render_markdown_inline_html("Alpha\\\nBeta")
  assert_eq(
    html.contains("Alpha<br class=\"markdown-line-break\" />Beta"),
    true,
  )
}

///|
test "block markdown renders code task table and math" {
  let html = render_markdown_blocks_html([
    "```mbt\nlet answer = 42\n```", "- [ ] Todo\n- [x] Done", "| Feature | Status |\n|---|---|\n| Editor | ok |",
    "$$\\frac{a}{b} + \\sqrt{x}$$",
  ])
  assert_eq(html.contains("class=\"markdown-code-block\""), true)
  assert_eq(html.contains("data-lang=\"mbt\""), true)
  assert_eq(html.contains("class=\"markdown-task\""), true)
  assert_eq(html.contains("checked=\"true\""), true)
  assert_eq(html.contains("class=\"markdown-table\""), true)
  assert_eq(html.contains("class=\"markdown-math markdown-math--block\""), true)
  assert_eq(html.contains("class=\"markdown-math-frac\""), true)
}

///|
test "block markdown renders unordered and ordered lists" {
  let unordered = render_markdown_blocks_html([
    "- **Bold** item\n- Math $x^2$ item\n- ==Marked== item",
  ])
  assert_eq(
    unordered.contains("<ul class=\"markdown-list markdown-list--unordered\">"),
    true,
  )
  assert_eq(unordered.contains("class=\"markdown-list__item\""), true)
  assert_eq(unordered.contains("class=\"markdown-strong\""), true)
  assert_eq(
    unordered.contains("class=\"markdown-math markdown-math--inline\""),
    true,
  )
  assert_eq(unordered.contains("class=\"markdown-highlight\""), true)

  let ordered = render_markdown_blocks_html(["1. First\n2. Second"])
  assert_eq(
    ordered.contains("<ol class=\"markdown-list markdown-list--ordered\">"),
    true,
  )
  assert_eq(
    ordered.contains("<li class=\"markdown-list__item\">First</li>"),
    true,
  )

  let mixed = render_markdown_blocks_html(["1. First\n  - Nested-ish\n3. Third"])
  assert_eq(mixed.contains("markdown-list--ordered"), true)
  assert_eq(mixed.contains("markdown-list--unordered"), true)
  assert_eq(
    mixed.contains(
      "<li class=\"markdown-list__item\">First<ul class=\"markdown-list markdown-list--unordered\">",
    ),
    true,
  )
  assert_eq(mixed.contains("Nested-ish"), true)
}

///|
test "highlight markdown renders in document headings lists and tables" {
  let html = render_markdown_html(
    "# ==Title==\n\n- ==Item==\n\n| A | B |\n|---|---|\n| ==Cell== | ok |",
  )
  assert_true(
    html.contains(
      "<h1 class=\"markdown-heading markdown-heading--h1\"><mark class=\"markdown-highlight\">Title</mark></h1>",
    ),
  )
  assert_true(html.contains("<mark class=\"markdown-highlight\">Item</mark>"))
  assert_true(html.contains("<mark class=\"markdown-highlight\">Cell</mark>"))
}

///|
test "markdown html escapes unsafe input" {
  let html = render_markdown_html(
    "[<img src=x onerror=alert(1)>](javascript:alert(1))\n\n```html\n<script>alert(1)</script>\n```",
  )
  assert_eq(html.contains("href="), false)
  assert_eq(html.contains("<img src=x"), false)
  assert_eq(html.contains("<script>alert(1)</script>"), false)
  assert_eq(html.contains("&lt;img src=x onerror=alert(1)&gt;"), true)
  assert_eq(html.contains("&lt;script&gt;alert(1)&lt;/script&gt;"), true)
}

///|
test "whole markdown input splits paragraphs without breaking fenced code" {
  let html = render_markdown_html("Alpha\n\n```txt\nA\n\nB\n```\n\nBeta")
  assert_eq(html.contains("Alpha"), true)
  assert_eq(html.contains("Beta"), true)
  assert_eq(html.contains("A\n\nB"), true)
}

///|
test "document markdown renders heading blocks" {
  let html = render_markdown_html("# Title\nBody text\n\n## Section")
  assert_true(
    html.contains(
      "<h1 class=\"markdown-heading markdown-heading--h1\">Title</h1>",
    ),
  )
  assert_true(html.contains("<p class=\"markdown-paragraph\">Body text</p>"))
  assert_true(
    html.contains(
      "<h2 class=\"markdown-heading markdown-heading--h2\">Section</h2>",
    ),
  )
}

///|
test "body block renderer keeps hash text as paragraph" {
  let html = render_markdown_blocks_html(["# Body heading"])
  assert_false(html.contains("markdown-heading"))
  assert_true(
    html.contains("<p class=\"markdown-paragraph\"># Body heading</p>"),
  )
}

///|
test "collapsible markdown nests heading sections" {
  let html = render_markdown_collapsible_html(
    "Intro\n\n# A **bold** ==marked== $x^2$\nText\n## B\nMore\n# C",
  )
  assert_true(html.contains("<p class=\"markdown-paragraph\">Intro</p>"))
  assert_true(
    html.contains(
      "<details class=\"markdown-section markdown-section--h1\" open>",
    ),
  )
  assert_true(
    html.contains(
      "<summary class=\"markdown-section__summary markdown-heading markdown-heading--h1\">A <span class=\"markdown-strong\">bold</span> <mark class=\"markdown-highlight\">marked</mark> <span class=\"markdown-math markdown-math--inline\">",
    ),
  )
  assert_true(html.contains("<mark class=\"markdown-highlight\">marked</mark>"))
  assert_true(
    html.contains(
      "<div class=\"markdown-section__body\"><p class=\"markdown-paragraph\">Text</p><details class=\"markdown-section markdown-section--h2\" open>",
    ),
  )
  assert_true(
    html.contains(
      "<summary class=\"markdown-section__summary markdown-heading markdown-heading--h2\">B</summary>",
    ),
  )
  assert_true(
    html.contains(
      "<summary class=\"markdown-section__summary markdown-heading markdown-heading--h1\">C</summary>",
    ),
  )
}

///|
test "collapsible markdown supports all heading levels and escapes titles" {
  let html = render_markdown_collapsible_html(
    "# <script>\n## H2\n### H3\n#### H4\n##### H5\n###### H6",
  )
  assert_false(html.contains("<script>"))
  assert_true(html.contains("&lt;script&gt;"))
  for level in 1..<=6 {
    assert_true(html.contains("markdown-section--h\{level}"))
    assert_true(html.contains("markdown-heading--h\{level}"))
  }
}

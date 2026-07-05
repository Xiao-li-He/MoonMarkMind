///|
test "inline markdown renders rich html and math" {
  let html = render_markdown_inline_html(
    "[Link](https://example.com) **Bold** _Italic_ `Code` ~~Gone~~ $x^2$",
  )
  assert_eq(html.contains("class=\"markdown-link\""), true)
  assert_eq(html.contains("href=\"https://example.com\""), true)
  assert_eq(html.contains("class=\"markdown-strong\""), true)
  assert_eq(html.contains("class=\"markdown-emphasis\""), true)
  assert_eq(html.contains("class=\"markdown-inline-code\""), true)
  assert_eq(html.contains("class=\"markdown-strike\""), true)
  assert_eq(
    html.contains("class=\"markdown-math markdown-math--inline\""),
    true,
  )
  assert_eq(html.contains("<sup>2</sup>"), true)
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

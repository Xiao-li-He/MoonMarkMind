///|
test "render markdown body to html" {
  let html = render("# Title\n\nHello **MoonBit**\n\n$$x^2$$")
  assert_true(html.contains("markdown-heading--h1"))
  assert_true(html.contains("markdown-strong"))
  assert_true(html.contains("markdown-math--block"))
}

///|
test "render heading followed by text without blank line" {
  let html = render("# Title\nBody text")
  assert_true(
    html.contains(
      "<h1 class=\"markdown-heading markdown-heading--h1\">Title</h1>",
    ),
  )
  assert_true(html.contains("<p class=\"markdown-paragraph\">Body text</p>"))
}

///|
test "render inline markdown to html" {
  let html = render_inline("Value $x^2$ and `code`")
  assert_true(html.contains("markdown-math--inline"))
  assert_true(html.contains("markdown-inline-code"))
}

///|
test "render title task marker" {
  let html = render_title("[x] Done **today**")
  assert_true(html.contains("markdown-task--title"))
  assert_true(html.contains("checked=\"true\""))
  assert_true(html.contains("markdown-strong"))
}

///|
test "render blocks keeps unsafe html escaped" {
  let html = render_blocks([
    "[<img src=x onerror=alert(1)>](javascript:alert(1))", "```html\n<script>alert(1)</script>\n```",
  ])
  assert_false(html.contains("href="))
  assert_false(html.contains("<script>alert(1)</script>"))
  assert_false(html.contains("<img src=x"))
  assert_true(html.contains("&lt;script&gt;alert(1)&lt;/script&gt;"))
  assert_true(html.contains("&lt;img src=x onerror=alert(1)&gt;"))
}

///|
test "render math style css for standalone documents" {
  let css = render_math_style_css()
  assert_true(css.contains(".markdown-math-frac"))
  assert_true(css.contains(".markdown-math-sqrt__svg"))
  assert_true(css.contains(".markdown-math--block"))
  let style = render_style_element()
  assert_true(style.contains("<style>"))
  assert_true(style.contains(".markdown-strong"))
  assert_true(style.contains(".markdown-table th"))
  assert_true(style.contains(".markdown-list"))
  assert_true(style.contains(".markdown-image"))
  assert_true(style.contains("margin: 0;"))
  assert_true(style.contains("white-space: normal"))
  assert_true(style.contains(".markdown-math sup"))
}

///|
test "render escaped markdown markers literally" {
  let html = render(
    "\\**not bold\\**\n\n| A | B |\n|---|---|\n| \\$x\\$ | \\**text\\** |",
  )
  assert_false(html.contains("markdown-strong"))
  assert_false(html.contains("markdown-math"))
  assert_true(html.contains("**not bold**"))
  assert_true(html.contains("$x$"))
  assert_true(html.contains("**text**"))
}

///|
test "render standard markdown line breaks" {
  let soft = render("Alpha\nBeta")
  assert_true(soft.contains("Alpha Beta"))
  assert_false(soft.contains("markdown-line-break"))
  let hard = render("Alpha  \nBeta\n\nGamma\\\nDelta")
  assert_true(hard.contains("Alpha<br class=\"markdown-line-break\">Beta"))
  assert_true(hard.contains("Gamma<br class=\"markdown-line-break\">Delta"))
}

///|
test "render normal lists" {
  let html = render("- Item **one**\n- Item $x^2$\n\n1. First\n2. Second")
  assert_true(html.contains("markdown-list--unordered"))
  assert_true(html.contains("markdown-list--ordered"))
  assert_true(html.contains("markdown-strong"))
  assert_true(html.contains("markdown-math--inline"))
}

///|
test "render nested lists from indentation" {
  let html = render("1. first\n  - child\n    1. grandchild\n2. second")
  assert_true(html.contains("markdown-list--ordered"))
  assert_true(html.contains("markdown-list--unordered"))
  assert_true(
    html.contains(
      "<li class=\"markdown-list__item\">first<ul class=\"markdown-list markdown-list--unordered\">",
    ),
  )
  assert_true(html.contains("grandchild"))
}

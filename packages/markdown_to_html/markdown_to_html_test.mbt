///|
test "render markdown body to html" {
  let html = render("# Title\n\nHello **MoonBit**\n\n$$x^2$$")
  assert_true(html.contains("markdown-heading--h1"))
  assert_true(html.contains("markdown-strong"))
  assert_true(html.contains("markdown-math--block"))
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

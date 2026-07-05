///|
test "example document includes shared math styles" {
  let body = @to_html.render("Inline $x^2$.\n\n$$\\frac{a}{\\sqrt{b}}$$")
  let document = render_html_document(body)
  assert_true(document.contains("<style>"))
  assert_true(document.contains(".markdown-math-frac"))
  assert_true(document.contains(".markdown-math-sqrt__svg"))
  assert_true(document.contains("markdown-math--block"))
}

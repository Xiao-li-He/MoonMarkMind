# latex_math_render

Small LaTeX math renderer used by MoonMarkMind. It covers common inline and
block math constructs and emits escaped HTML fragments.

```mbt check
///|
test {
  let html = render_latex_math_inline_html("\\frac{x}{y}")
  assert_true(html.contains("markdown-math-frac"))
}
```

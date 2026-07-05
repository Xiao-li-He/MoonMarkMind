///|
test "math style rules include formula structures" {
  let rules = math_style_rules()
  let mut has_frac = false
  let mut has_sqrt_svg = false
  let mut has_tall_sqrt_svg = false
  let mut has_block = false
  let mut has_sup = false
  for rule in rules {
    if rule.class_name == "markdown-math-frac" {
      has_frac = true
    }
    if rule.class_name == "markdown-math-sqrt__svg" {
      has_sqrt_svg = true
      match rule.ancestor_class {
        Some("markdown-math-sqrt--tall") => has_tall_sqrt_svg = true
        _ => ()
      }
    }
    if rule.class_name == "markdown-math--block" {
      has_block = true
    }
    if rule.class_name == "sup" {
      has_sup = true
    }
  }
  assert_true(has_frac)
  assert_true(has_sqrt_svg)
  assert_true(has_tall_sqrt_svg)
  assert_true(has_block)
  assert_true(has_sup)
}

///|
test "math style css renders standalone selectors" {
  let css = math_style_css()
  assert_true(css.contains(".markdown-math-frac"))
  assert_true(css.contains(".markdown-math-sqrt__svg"))
  assert_true(
    css.contains(".markdown-math-sqrt--tall .markdown-math-sqrt__svg"),
  )
  assert_true(css.contains(".markdown-math--block"))
  assert_true(css.contains(".markdown-math sup"))
}

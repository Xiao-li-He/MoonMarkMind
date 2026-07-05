///|
test "markdown style rules expose common classes" {
  let rules = markdown_style_rules()
  let mut has_heading = false
  let mut has_strong = false
  let mut has_image = false
  let mut has_nested_list = false
  let mut has_table_header = false
  let mut has_section = false
  let mut has_section_body = false
  for rule in rules {
    if rule.class_name == "markdown-heading" {
      has_heading = true
    }
    if rule.class_name == "markdown-strong" {
      has_strong = true
    }
    if rule.class_name == "markdown-image" {
      has_image = true
    }
    if rule.selector == ".markdown-list .markdown-list" {
      has_nested_list = true
    }
    if rule.class_name == "markdown-section" {
      has_section = true
    }
    if rule.class_name == "markdown-section__body" {
      has_section_body = true
    }
    match rule.tag_name {
      Some("TH") =>
        if rule.selector == ".markdown-table th" {
          has_table_header = true
        }
      _ => ()
    }
  }
  assert_true(has_heading)
  assert_true(has_strong)
  assert_true(has_image)
  assert_true(has_nested_list)
  assert_true(has_table_header)
  assert_true(has_section)
  assert_true(has_section_body)
}

///|
test "markdown style css is generated from rules" {
  let css = markdown_style_css()
  assert_true(css.contains(".markdown-heading"))
  assert_true(css.contains(".markdown-strong"))
  assert_true(css.contains(".markdown-image"))
  assert_true(css.contains(".markdown-section"))
  assert_true(css.contains(".markdown-section__summary"))
  assert_true(css.contains(".markdown-list .markdown-list"))
  assert_true(css.contains(".markdown-table th"))
  assert_true(css.contains("font-weight: 800;"))
  assert_true(css.contains("white-space: normal;"))
}

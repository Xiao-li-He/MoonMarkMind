///|
test "rules sample paths use markdown assets only" {
  assert_eq(rules_sample_markdown_path("part1"), "samples/example1.md")
  assert_eq(rules_sample_markdown_path("part2"), "samples/example2.md")
  assert_eq(rules_sample_markdown_path("part3"), "samples/example3.md")
  assert_eq(rules_sample_markdown_path("part4"), "samples/example4.md")
}

///|
test "rules sample fallback is a simple missing asset document" {
  assert_eq(
    rules_sample_fallback_markdown("part4"),
    "# Sample failed to load\n\nMissing markdown asset: samples/example4.md",
  )
}

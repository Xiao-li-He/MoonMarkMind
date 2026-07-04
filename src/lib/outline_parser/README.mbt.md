# outline_parser

Markdown outline parsing, tree construction, structural editing, and Markdown
round-trip rendering for MoonMarkMind.

```mbt check
///|
test {
  let markdown = "# Project\n## Goal\n## Plan"
  let headings = parse_headings(markdown)
  guard headings.length() == 3 else { fail("expected three headings") }
  guard headings[0] == (1, "Project") else { fail("unexpected root heading") }
  guard headings[2] == (2, "Plan") else { fail("unexpected final heading") }
  let outline = outline_json(markdown)
  assert_true(outline.contains("\"title\":\"Project\""))
}
```

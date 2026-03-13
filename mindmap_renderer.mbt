///|
pub fn render_ascii_mindmap(markdown : String) -> String {
  let rendered = []
  for heading in parse_headings(markdown) {
    rendered.push(render_heading(heading))
  }
  rendered.join("\n")
}

///|
fn render_heading(heading : (Int, String)) -> String {
  let (level, title) = heading
  let indent = make_indent(level - 1)
  "\{indent}- \{title}"
}

///|
fn make_indent(level : Int) -> String {
  let spaces = []
  for _ in 0..<level {
    spaces.push("  ")
  }
  spaces.join("")
}

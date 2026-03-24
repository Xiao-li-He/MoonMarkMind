///|
pub fn render_ascii_mindmap(markdown : String) -> String {
  let rendered = []
  for node in parse_markdown_nodes(markdown) {
    rendered.push(render_markdown_node(node))
  }
  rendered.join("\n")
}

///|
fn render_markdown_node(node : MarkdownNode) -> String {
  let indent = make_indent(node.level - 1)
  "\{indent}- \{node.title}"
}

///|
fn make_indent(level : Int) -> String {
  let spaces = []
  for _ in 0..<level {
    spaces.push("  ")
  }
  spaces.join("")
}

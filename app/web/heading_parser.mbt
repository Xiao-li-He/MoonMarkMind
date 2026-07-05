///|
/// Compatibility aliases for the reusable outline parser package.
pub type MarkdownNodeKind = @outline_parser.MarkdownNodeKind

///|
pub type MarkdownNode = @outline_parser.MarkdownNode

///|
pub fn parse_headings(markdown : String) -> Array[(Int, String)] {
  @outline_parser.parse_headings(markdown)
}

///|
fn parse_markdown_nodes(markdown : String) -> Array[MarkdownNode] {
  @outline_parser.parse_markdown_nodes(markdown)
}

///|
fn normalize_markdown_body_lines(lines : Array[String]) -> Array[String] {
  @outline_parser.normalize_markdown_body_lines(lines)
}

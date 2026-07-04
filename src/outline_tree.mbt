///|
/// Compatibility alias for the reusable outline parser tree type.
pub type OutlineNode = @outline_parser.OutlineNode

///|
fn build_outline(markdown : String) -> OutlineNode {
  @outline_parser.build_outline(markdown)
}

///|
fn empty_outline() -> OutlineNode {
  @outline_parser.empty_outline()
}

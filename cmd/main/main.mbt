///|
/// JavaScript export shim for the built-in demo Markdown.
pub fn sample_markdown() -> String {
  @lib.sample_markdown()
}

///|
/// JavaScript export shim for converting Markdown to outline JSON.
pub fn outline_json(markdown : String) -> String {
  @lib.outline_json(markdown)
}

///|
/// JavaScript export shim for renaming a flat-indexed outline node.
pub fn rename_heading(
  markdown : String,
  flat_index : Int,
  title : String,
) -> String {
  @lib.rename_heading(markdown, flat_index, title)
}

///|
/// JavaScript export shim for drag/drop-style subtree movement.
pub fn move_heading(
  markdown : String,
  from_flat_index : Int,
  to_flat_index : Int,
  place_after : Bool,
) -> String {
  @lib.move_heading(markdown, from_flat_index, to_flat_index, place_after)
}

///|
/// JavaScript export shim for keyboard sibling movement.
pub fn move_heading_among_siblings(
  markdown : String,
  flat_index : Int,
  move_down : Bool,
) -> String {
  @lib.move_heading_among_siblings(markdown, flat_index, move_down)
}

///|
/// JavaScript export shim for adding a child heading/list node.
pub fn add_child_heading(
  markdown : String,
  parent_flat_index : Int,
  title : String,
) -> String {
  @lib.add_child_heading(markdown, parent_flat_index, title)
}

///|
/// JavaScript export shim for adding a sibling node.
pub fn add_sibling_heading(
  markdown : String,
  flat_index : Int,
  title : String,
  place_after : Bool,
) -> String {
  @lib.add_sibling_heading(markdown, flat_index, title, place_after)
}

///|
/// JavaScript export shim for heading extraction.
pub fn parse_headings(markdown : String) -> Array[(Int, String)] {
  @lib.parse_headings(markdown)
}

///|
/// JavaScript export shim for demoting a node under its previous sibling.
pub fn indent_heading(markdown : String, flat_index : Int) -> String {
  @lib.indent_heading(markdown, flat_index)
}

///|
/// JavaScript export shim for promoting a node toward its grandparent.
pub fn promote_heading(markdown : String, flat_index : Int) -> String {
  @lib.promote_heading(markdown, flat_index)
}

///|
/// JavaScript export shim for deleting a node subtree.
pub fn delete_heading(markdown : String, flat_index : Int) -> String {
  @lib.delete_heading(markdown, flat_index)
}

///|
/// JavaScript export shim that starts the browser application.
pub fn start_web_app() -> Unit {
  @lib.start_web_app()
}

///|
fn main {
  println("Markdown input:")
  println(sample_markdown())
  println("")
  println("Outline JSON:")
  println(outline_json(sample_markdown()))
}

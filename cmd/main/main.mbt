///|
pub fn sample_markdown() -> String {
  @lib.sample_markdown()
}

///|
pub fn outline_json(markdown : String) -> String {
  @lib.outline_json(markdown)
}

///|
pub fn rename_heading(
  markdown : String,
  flat_index : Int,
  title : String,
) -> String {
  @lib.rename_heading(markdown, flat_index, title)
}

///|
pub fn move_heading(
  markdown : String,
  from_flat_index : Int,
  to_flat_index : Int,
  place_after : Bool,
) -> String {
  @lib.move_heading(markdown, from_flat_index, to_flat_index, place_after)
}

///|
pub fn add_child_heading(
  markdown : String,
  parent_flat_index : Int,
  title : String,
) -> String {
  @lib.add_child_heading(markdown, parent_flat_index, title)
}

///|
pub fn delete_heading(markdown : String, flat_index : Int) -> String {
  @lib.delete_heading(markdown, flat_index)
}

///|
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

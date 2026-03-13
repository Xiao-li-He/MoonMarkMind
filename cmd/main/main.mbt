///|
fn keep_web_api() -> Unit {
  let markdown = @lib.sample_markdown()
  let _ = @lib.outline_json(markdown)
  let _ = @lib.rename_heading(markdown, 0, "MindDown Demo")
  let _ = @lib.move_heading(markdown, 1, 4, true)
  let _ = @lib.add_child_heading(markdown, 4, "Export")
  let _ = @lib.delete_heading(markdown, 1)
}

///|
fn main {
  keep_web_api()
  println("Markdown input:")
  println(@lib.sample_markdown())
  println("")
  println("ASCII mindmap:")
  println(@lib.demo_output())
}

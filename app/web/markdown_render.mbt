///|
pub fn render_markdown_html(markdown : String) -> String {
  @markdown_render.render_markdown_html(markdown)
}

///|
pub fn render_markdown_inline_html(source : String) -> String {
  @markdown_render.render_markdown_inline_html(source)
}

///|
pub fn render_markdown_title_html(source : String) -> String {
  @markdown_render.render_markdown_title_html(source)
}

///|
fn apply_theme_to_subtree(root : @dom.Element) -> Unit {
  apply_theme_to_element(root)
  for element in root.querySelectorAll("*") {
    apply_theme_to_element(element)
  }
}

///|
pub fn render_markdown_blocks_html(blocks : Array[String]) -> String {
  @markdown_render.render_markdown_blocks_html(blocks)
}

///|
fn parse_markdown_table(block : String) -> @markdown_render.MarkdownBlock? {
  @markdown_render.parse_markdown_table(block)
}

///|
fn find_markdown_from(source : String, needle : String, start : Int) -> Int? {
  @markdown_render.find_markdown_from(source, needle, start)
}

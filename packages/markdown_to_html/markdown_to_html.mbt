///|
/// Render a Markdown body fragment to a safe HTML fragment.
pub fn render(markdown : String) -> String {
  @markdown.render_markdown_html(markdown)
}

///|
/// Render Markdown as a collapsible HTML fragment grouped by headings.
pub fn render_collapsible(markdown : String) -> String {
  @markdown.render_markdown_collapsible_html(markdown)
}

///|
/// Render inline Markdown to a safe HTML fragment.
pub fn render_inline(source : String) -> String {
  @markdown.render_markdown_inline_html(source)
}

///|
/// Render a mind-map node title to a safe HTML fragment.
pub fn render_title(source : String) -> String {
  @markdown.render_markdown_title_html(source)
}

///|
/// Render Markdown body blocks that have already been split by blank lines.
pub fn render_blocks(blocks : Array[String]) -> String {
  @markdown.render_markdown_blocks_html(blocks)
}

///|
/// Render the CSS needed by math fragments emitted from this package.
pub fn render_math_style_css() -> String {
  @math.math_style_css()
}

///|
/// Render CSS for the Markdown structural classes emitted from this package.
pub fn render_markdown_style_css() -> String {
  @markdown.markdown_style_css()
}

///|
/// Render a style element for standalone HTML documents.
pub fn render_style_element() -> String {
  "<style>\{render_markdown_style_css()}\n\{render_math_style_css()}</style>"
}

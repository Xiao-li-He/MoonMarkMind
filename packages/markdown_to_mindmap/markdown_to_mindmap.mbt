///|
pub type MindmapLayout = @mindmap.MindmapLayout

///|
pub type MindmapStyle = @mindmap.MindmapStyle

///|
pub type MindmapLayer = @mindmap.MindmapLayer

///|
pub type RenderOptions = @mindmap.RenderOptions

///|
/// Return default static mind-map render options.
pub fn default_render_options() -> RenderOptions {
  @mindmap.default_render_options()
}

///|
/// Normalize a layout string into a render option.
pub fn normalize_layout(value : String) -> MindmapLayout {
  @mindmap.normalize_layout(value)
}

///|
/// Normalize a style string into a render option.
pub fn normalize_style(value : String) -> MindmapStyle {
  @mindmap.normalize_style(value)
}

///|
/// Normalize a layer string into a render option.
pub fn normalize_layer(value : String) -> MindmapLayer {
  @mindmap.normalize_layer(value)
}

///|
/// Render Markdown to a static mind-map HTML fragment.
pub fn render(
  markdown : String,
  options? : RenderOptions = default_render_options(),
) -> String {
  @mindmap.render_markdown_html(markdown, options~)
}

///|
/// Render Markdown to a static SVG string.
pub fn render_svg(
  markdown : String,
  options? : RenderOptions = default_render_options(),
) -> String {
  @mindmap.render_markdown_svg(markdown, options~)
}

///|
/// Render the CSS needed by mind-map, Markdown, and math fragments.
pub fn render_style_css() -> String {
  "\{@mindmap.mindmap_style_css()}\n\{@markdown.markdown_style_css()}\n\{@math.math_style_css()}"
}

///|
/// Render a style element for standalone HTML documents.
pub fn render_style_element() -> String {
  "<style>\{render_style_css()}</style>"
}

///|
/// Render the small export runtime used by standalone interactive HTML.
pub fn render_export_runtime_script() -> String {
  @mindmap.render_export_runtime_script()
}

///|
/// Render Markdown to a complete standalone interactive HTML document.
pub fn render_interactive_html_document(
  markdown : String,
  options? : RenderOptions = default_render_options(),
) -> String {
  let out = StringBuilder()
  out.write_string("<!doctype html><html lang=\"en\"><head>")
  out.write_string("<meta charset=\"utf-8\">")
  out.write_string(
    "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">",
  )
  out.write_string("<title>MoonMarkMind Export</title>")
  out.write_string(render_style_element())
  out.write_string("</head><body>")
  out.write_string(render(markdown, options~))
  out.write_string(render_export_runtime_script())
  out.write_string("</body></html>")
  out.to_string()
}

///|
/// Render Markdown to a complete standalone HTML document.
pub fn render_html_document(
  markdown : String,
  options? : RenderOptions = default_render_options(),
) -> String {
  render_interactive_html_document(markdown, options~)
}

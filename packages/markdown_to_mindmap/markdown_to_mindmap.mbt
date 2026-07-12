///|
pub type MindmapLayout = @mindmap.MindmapLayout

///|
pub type MindmapStyle = @mindmap.MindmapStyle

///|
pub type MindmapLayer = @mindmap.MindmapLayer

///|
pub type RenderOptions = @mindmap.RenderOptions

///|
pub type MarkupNode = @mindmap.MarkupNode

///|
pub type MarkupElement = @mindmap.MarkupElement

///|
pub type MarkupAttribute = @mindmap.MarkupAttribute

///|
pub type MarkupNamespace = @mindmap.MarkupNamespace

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
/// Build a structured mind-map document for native DOM adapters.
pub fn build_document(
  markdown : String,
  options? : RenderOptions = default_render_options(),
) -> MarkupNode {
  @mindmap.build_markdown_document(markdown, options~)
}

///|
/// Build a structured, static SVG document without script content.
pub fn build_svg_document(
  markdown : String,
  options? : RenderOptions = default_render_options(),
) -> MarkupNode {
  @mindmap.build_markdown_svg_document(markdown, options~)
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
/// Render Markdown to a complete standalone HTML document.
pub fn render_html_document(
  markdown : String,
  options? : RenderOptions = default_render_options(),
) -> String {
  let content = render(markdown, options~)
  "<!doctype html><html lang=\"en\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><title>MoonMarkMind Export</title>\{render_style_element()}</head><body>\{content}</body></html>"
}

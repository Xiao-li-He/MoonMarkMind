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
/// Render Markdown to a static SVG string.
pub fn render_svg(
  markdown : String,
  options? : RenderOptions = default_render_options(),
) -> String {
  @mindmap.render_markdown_svg(markdown, options~)
}

///|
/// Build a structured, static SVG document without script content.
pub fn build_svg_document(
  markdown : String,
  options? : RenderOptions = default_render_options(),
) -> MarkupNode {
  @mindmap.build_markdown_svg_document(markdown, options~)
}

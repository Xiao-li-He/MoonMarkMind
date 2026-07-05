///|
pub fn render_markdown_html(
  markdown : String,
  options? : RenderOptions = default_render_options(),
) -> String {
  render_outline_html(@outline.build_outline(markdown), options~)
}

///|
pub fn render_markdown_svg(
  markdown : String,
  options? : RenderOptions = default_render_options(),
) -> String {
  render_outline_svg(@outline.build_outline(markdown), options~)
}

///|
pub fn render_outline_html(
  root : @outline.OutlineNode,
  options? : RenderOptions = default_render_options(),
) -> String {
  let classes = [
    "moonmarkmind-export",
    "moonmarkmind-export--\{layout_class(options.layout)}",
    "moonmarkmind-export--\{style_class(options.style)}",
    "moonmarkmind-export--\{layer_to_detail_select(options.layer)}",
  ]
  (
    $|<main class="\{classes.join(" ")}">
    $|  <div class="mindmap">
    $|    <div class="mindmap-content">
    $|      \{render_stage(root, options)}
    $|    </div>
    $|  </div>
    $|</main>
  )
}

///|
pub fn render_outline_svg(
  root : @outline.OutlineNode,
  options? : RenderOptions = default_render_options(),
) -> String {
  let html = render_outline_html(root, options~)
  (
    $|<svg xmlns="http://www.w3.org/2000/svg" width="1280" height="760" viewBox="0 0 1280 760">
    $|<foreignObject x="0" y="0" width="1280" height="760">
    $|<div xmlns="http://www.w3.org/1999/xhtml">
    $|\{html}
    $|</div>
    $|</foreignObject>
    $|</svg>
  )
}

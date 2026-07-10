///|
fn main {
  let markdown = "# Root\n## Child"
  println(@outline_parser.outline_json(markdown))
  println(@mindmap_render.render_markdown_html(markdown))
  println(@latex_math_render.render_latex_math_inline_html("\\frac{x}{y}"))
}

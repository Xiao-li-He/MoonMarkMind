///|
fn write_node_card(
  out : StringBuilder,
  node : @outline.OutlineNode,
  parent_index~ : Int,
  center~ : Bool,
  tone_index~ : Int,
  options~ : RenderOptions,
  depth~ : Int,
) -> Unit {
  let class_name = if center {
    "node node--center \{node_style_class(options.style)}"
  } else {
    "node \{node_style_class(options.style)}"
  }
  write_str(out, "<article")
  write_class_attr(out, class_name)
  write_int_attr(out, "data-level", node.level)
  write_int_attr(out, "data-depth", depth)
  write_int_attr(out, "data-tone", tone_index)
  write_int_attr(out, "data-node-index", node.flat_index)
  write_int_attr(out, "data-parent-index", parent_index)
  write_int_attr(out, "data-child-count", node.children.length())
  write_bool_attr(out, "data-synthetic", node.synthetic)
  write_str(out, "><strong")
  write_class_attr(out, node_title_class(options.style))
  write_int_attr(out, "data-title-depth", depth)
  write_bool_attr(out, "data-title-center", center)
  write_str(out, ">")
  write_str(out, @markdown_render.render_markdown_title_html(node.title))
  write_str(out, "</strong>")
  write_node_body(out, node, options)
  write_str(out, "</article>")
}

///|
fn write_node_body(
  out : StringBuilder,
  node : @outline.OutlineNode,
  options : RenderOptions,
) -> Unit {
  if node.body.length() == 0 || !is_full_layer(options.layer) {
    return
  }
  write_str(
    out, "<div class=\"node-note-rail\"><div class=\"node-body node-body-preview\"><div class=\"markdown-blocks\">",
  )
  write_str(out, @markdown_render.render_markdown_blocks_html(node.body))
  write_str(out, "</div></div></div>")
}

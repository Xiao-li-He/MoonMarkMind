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
  let style_class = node_style_class_for_options(options)
  let note_class = if is_tree_line_style(options) &&
    node.body.length() > 0 &&
    is_full_layer(options.layer) {
    " node--line-tree-note"
  } else {
    ""
  }
  let class_name = if center {
    "node node--center \{style_class}\{note_class}"
  } else {
    "node \{style_class}\{note_class}"
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
  write_node_export_attrs(out, node, depth, options.layer)
  write_str(out, "><strong")
  write_class_attr(out, node_title_class(options.style))
  write_int_attr(out, "data-title-depth", depth)
  write_bool_attr(out, "data-title-center", center)
  write_str(out, ">")
  write_str(out, @markdown_render.render_markdown_title_html(node.title))
  write_str(out, "</strong>")
  write_node_body(out, node, options)
  write_node_toggle_action(out, node, center, options)
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
  write_str(out, "<div class=\"node-note-rail\">")
  write_note_toggle_action(out, node)
  let body_class = if is_tree_line_style(options) {
    "node-body node-body-preview node-body--line-tree"
  } else {
    "node-body node-body-preview"
  }
  write_str(out, "<div")
  write_class_attr(out, body_class)
  write_int_attr(out, "data-note-preview-for", node.flat_index)
  write_str(out, "><div class=\"markdown-blocks\">")
  write_str(out, @markdown_render.render_markdown_blocks_html(node.body))
  write_str(out, "</div></div></div>")
}

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
  write_str(out, "<article class=\"node")
  if center {
    write_str(out, " node--center")
  }
  write_str(out, " ")
  write_node_style_class(out, options.style)
  write_str(out, "\"")
  write_int_attr(out, "data-level", node.level)
  write_int_attr(out, "data-depth", depth)
  write_int_attr(out, "data-tone", tone_index)
  write_int_attr(out, "data-node-index", node.flat_index)
  write_int_attr(out, "data-parent-index", parent_index)
  write_int_attr(out, "data-child-count", node.children.length())
  write_bool_attr(out, "data-synthetic", node.synthetic)
  write_str(out, "><strong class=\"")
  write_node_title_class(out, options.style)
  write_str(out, "\"")
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

///|
fn write_stage_class(
  out : StringBuilder,
  options : RenderOptions,
  extra : String,
) -> Unit {
  write_str(out, "mindmap-stage ")
  write_str(out, extra)
  match options.style {
    Line => write_str(out, " mindmap-stage--branch-line")
    Full => write_str(out, " mindmap-stage--fill")
  }
}

///|
fn is_full_layer(layer : MindmapLayer) -> Bool {
  match layer {
    Full => true
    _ => false
  }
}

///|
fn write_node_style_class(out : StringBuilder, style : MindmapStyle) -> Unit {
  match style {
    Line => write_str(out, "node--fill node--branch-line")
    Full => write_str(out, "node--line")
  }
}

///|
fn write_node_title_class(out : StringBuilder, style : MindmapStyle) -> Unit {
  match style {
    Line => write_str(out, "node-title node-title--scaled node-title--line")
    Full => write_str(out, "node-title node-title--scaled node-title--fill")
  }
}

///|
fn should_render_children(depth : Int, layer : MindmapLayer) -> Bool {
  match layer {
    Root => false
    Layer2 => depth < 1
    Full => true
  }
}

///|
fn fill_tone_index(index : Int) -> Int {
  index % 5
}

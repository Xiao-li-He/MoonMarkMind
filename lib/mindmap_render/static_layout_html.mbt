///|
fn write_static_stage(
  out : StringBuilder,
  root : @outline.OutlineNode,
  options : RenderOptions,
  boxes : Array[StaticNodeBox],
  width : Int,
  height : Int,
) -> Unit {
  write_str(out, "<div")
  write_class_attr(out, static_stage_class(options))
  write_static_stage_style_attr(out, width, height)
  write_str(out, ">")
  write_static_connector_layer_for_boxes(out, boxes, options, width, height)
  write_static_node_tree(out, root, -1, -1, options, boxes)
  write_str(out, "</div>")
}

///|
fn static_stage_class(options : RenderOptions) -> String {
  let layout_marker = match options.layout {
    Logic => "mindmap-stage--single-right single-right-tree"
    Mindmap => "mindmap-stage--radial"
    Tree => "mindmap-stage--vertical vertical-tree__children--line-tree"
  }
  stage_class(options, "\{layout_marker} mindmap-stage--static")
}

///|
fn write_static_stage_style_attr(
  out : StringBuilder,
  width : Int,
  height : Int,
) -> Unit {
  write_attr(
    out,
    "style",
    "position:relative;display:block;width:\{width}px;height:\{height}px;min-width:\{width}px;min-height:\{height}px;padding:0;overflow:visible;",
  )
}

///|
fn write_static_node_tree(
  out : StringBuilder,
  node : @outline.OutlineNode,
  parent_index : Int,
  tone_index : Int,
  options : RenderOptions,
  boxes : Array[StaticNodeBox],
) -> Unit {
  match find_static_box(boxes, node.flat_index) {
    Some(box) => {
      write_static_node(out, node, parent_index, tone_index, options, box)
      if should_render_layer_children(box.depth, options.layer) {
        for index in 0..<node.children.length() {
          let next_tone = if box.depth == 0 {
            fill_tone_index(index)
          } else {
            tone_index
          }
          write_static_node_tree(
            out,
            node.children[index],
            node.flat_index,
            next_tone,
            options,
            boxes,
          )
        }
      }
    }
    None => ()
  }
}

///|
fn write_static_node(
  out : StringBuilder,
  node : @outline.OutlineNode,
  parent_index : Int,
  tone_index : Int,
  options : RenderOptions,
  box : StaticNodeBox,
) -> Unit {
  write_str(out, "<div")
  write_class_attr(out, "mindmap-static-node")
  write_int_attr(out, "data-node-index", node.flat_index)
  write_int_attr(out, "data-parent-index", parent_index)
  write_static_node_style_attr(out, box)
  write_str(out, ">")
  write_node_card(
    out,
    node,
    parent_index~,
    center=box.center,
    tone_index~,
    options~,
    depth=box.depth,
  )
  write_str(out, "</div>")
}

///|
fn write_static_node_style_attr(
  out : StringBuilder,
  box : StaticNodeBox,
) -> Unit {
  write_attr(
    out,
    "style",
    "position:absolute;left:\{double_to_svg_number(box.x)}px;top:\{double_to_svg_number(box.y)}px;width:\{double_to_svg_number(box.width)}px;height:\{double_to_svg_number(box.height)}px;display:flex;align-items:stretch;justify-content:stretch;z-index:1;",
  )
}

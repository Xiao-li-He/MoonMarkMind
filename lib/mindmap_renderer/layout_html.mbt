///|
fn write_stage(
  out : StringBuilder,
  root : @outline.OutlineNode,
  options : RenderOptions,
) -> Unit {
  match options.layout {
    Logic => write_single_right_mindmap(out, root, options)
    Mindmap => write_horizontal_mindmap(out, root, options)
    Tree => write_vertical_mindmap(out, root, options)
  }
}

///|
fn write_horizontal_mindmap(
  out : StringBuilder,
  root : @outline.OutlineNode,
  options : RenderOptions,
) -> Unit {
  let split = (root.children.length() + 1) / 2
  write_str(out, "<div class=\"")
  write_stage_class(out, options, "mindmap-stage--radial")
  write_str(out, "\"><div class=\"branch-column branch-column--left\">")
  for index in 0..<root.children.length() {
    if index < split {
      write_branch_node(
        out,
        root.children[index],
        root.flat_index,
        "left",
        fill_tone_index(index),
        options,
        1,
      )
    }
  }
  write_str(out, "</div><div class=\"center-wrap\">")
  write_node_card(
    out,
    root,
    parent_index=-1,
    center=true,
    tone_index=-1,
    options~,
    depth=0,
  )
  write_str(out, "</div><div class=\"branch-column branch-column--right\">")
  for index in 0..<root.children.length() {
    if index >= split {
      write_branch_node(
        out,
        root.children[index],
        root.flat_index,
        "right",
        fill_tone_index(index),
        options,
        1,
      )
    }
  }
  write_str(out, "</div></div>")
}

///|
fn write_branch_node(
  out : StringBuilder,
  node : @outline.OutlineNode,
  parent_index : Int,
  direction : String,
  tone_index : Int,
  options : RenderOptions,
  depth : Int,
) -> Unit {
  write_str(out, "<div class=\"branch-item branch-item--")
  write_str(out, direction)
  write_str(out, "\"")
  write_int_attr(out, "data-node-index", node.flat_index)
  write_int_attr(out, "data-parent-index", parent_index)
  write_str(out, ">")
  if direction == "left" {
    if should_render_children(depth, options.layer) {
      write_branch_children(out, node, direction, tone_index, options, depth)
    }
    write_branch_head(out, node, parent_index, tone_index, options, depth)
  } else {
    write_branch_head(out, node, parent_index, tone_index, options, depth)
    if should_render_children(depth, options.layer) {
      write_branch_children(out, node, direction, tone_index, options, depth)
    }
  }
  write_str(out, "</div>")
}

///|
fn write_branch_head(
  out : StringBuilder,
  node : @outline.OutlineNode,
  parent_index : Int,
  tone_index : Int,
  options : RenderOptions,
  depth : Int,
) -> Unit {
  write_str(out, "<div class=\"branch-item__head\">")
  write_node_card(
    out,
    node,
    parent_index~,
    center=false,
    tone_index~,
    options~,
    depth~,
  )
  write_str(out, "</div>")
}

///|
fn write_branch_children(
  out : StringBuilder,
  node : @outline.OutlineNode,
  direction : String,
  tone_index : Int,
  options : RenderOptions,
  depth : Int,
) -> Unit {
  if node.children.length() == 0 {
    return
  }
  write_str(out, "<div class=\"branch-children branch-children--")
  write_str(out, direction)
  write_str(out, "\">")
  for child in node.children {
    write_branch_node(
      out,
      child,
      node.flat_index,
      direction,
      tone_index,
      options,
      depth + 1,
    )
  }
  write_str(out, "</div>")
}

///|
fn write_single_right_mindmap(
  out : StringBuilder,
  root : @outline.OutlineNode,
  options : RenderOptions,
) -> Unit {
  write_str(out, "<div class=\"")
  write_stage_class(out, options, "mindmap-stage--single-right")
  write_str(out, "\"><div class=\"single-right-tree\">")
  write_single_right_tree(out, root, -1, true, -1, options, 0)
  write_str(out, "</div></div>")
}

///|
fn write_single_right_tree(
  out : StringBuilder,
  node : @outline.OutlineNode,
  parent_index : Int,
  center : Bool,
  tone_index : Int,
  options : RenderOptions,
  depth : Int,
) -> Unit {
  write_str(out, "<div class=\"single-right-tree__node\"")
  write_int_attr(out, "data-node-index", node.flat_index)
  write_int_attr(out, "data-parent-index", parent_index)
  write_str(out, "><div class=\"single-right-tree__head\">")
  write_node_card(
    out,
    node,
    parent_index~,
    center~,
    tone_index~,
    options~,
    depth~,
  )
  write_str(out, "</div>")
  if should_render_children(depth, options.layer) {
    write_single_right_children(out, node, tone_index, options, depth)
  }
  write_str(out, "</div>")
}

///|
fn write_single_right_children(
  out : StringBuilder,
  node : @outline.OutlineNode,
  tone_index : Int,
  options : RenderOptions,
  depth : Int,
) -> Unit {
  if node.children.length() == 0 {
    return
  }
  write_str(out, "<div class=\"single-right-tree__children\">")
  for index in 0..<node.children.length() {
    let next_tone = if depth == 0 { fill_tone_index(index) } else { tone_index }
    write_single_right_tree(
      out,
      node.children[index],
      node.flat_index,
      false,
      next_tone,
      options,
      depth + 1,
    )
  }
  write_str(out, "</div>")
}

///|
fn write_vertical_mindmap(
  out : StringBuilder,
  root : @outline.OutlineNode,
  options : RenderOptions,
) -> Unit {
  write_str(out, "<div class=\"")
  write_stage_class(out, options, "mindmap-stage--vertical")
  write_str(out, "\"><div class=\"vertical-root\">")
  write_vertical_tree(out, root, -1, true, -1, options, 0)
  write_str(out, "</div></div>")
}

///|
fn write_vertical_tree(
  out : StringBuilder,
  node : @outline.OutlineNode,
  parent_index : Int,
  center : Bool,
  tone_index : Int,
  options : RenderOptions,
  depth : Int,
) -> Unit {
  write_str(out, "<div class=\"vertical-tree\"")
  write_int_attr(out, "data-node-index", node.flat_index)
  write_int_attr(out, "data-parent-index", parent_index)
  write_str(out, ">")
  write_node_card(
    out,
    node,
    parent_index~,
    center~,
    tone_index~,
    options~,
    depth~,
  )
  if should_render_children(depth, options.layer) {
    write_vertical_children(out, node, tone_index, options, depth)
  }
  write_str(out, "</div>")
}

///|
fn write_vertical_children(
  out : StringBuilder,
  node : @outline.OutlineNode,
  tone_index : Int,
  options : RenderOptions,
  depth : Int,
) -> Unit {
  if node.children.length() == 0 {
    return
  }
  write_str(out, "<div class=\"vertical-tree__children\">")
  for index in 0..<node.children.length() {
    let next_tone = if depth == 0 { fill_tone_index(index) } else { tone_index }
    write_str(out, "<div class=\"vertical-tree__child\">")
    write_vertical_tree(
      out,
      node.children[index],
      node.flat_index,
      false,
      next_tone,
      options,
      depth + 1,
    )
    write_str(out, "</div>")
  }
  write_str(out, "</div>")
}

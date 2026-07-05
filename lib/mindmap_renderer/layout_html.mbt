///|
fn render_stage(root : @outline.OutlineNode, options : RenderOptions) -> String {
  match options.layout {
    Logic => render_single_right_mindmap(root, options)
    Mindmap => render_horizontal_mindmap(root, options)
    Tree => render_vertical_mindmap(root, options)
  }
}

///|
fn render_horizontal_mindmap(
  root : @outline.OutlineNode,
  options : RenderOptions,
) -> String {
  let left = []
  let right = []
  let split = (root.children.length() + 1) / 2
  for index in 0..<root.children.length() {
    if index < split {
      left.push(root.children[index])
    } else {
      right.push(root.children[index])
    }
  }
  (
    $|<div class="\{stage_class(options, "mindmap-stage--radial")}">
    $|  <div class="branch-column branch-column--left">\{render_branch_column(left, "left", root.flat_index, options, 0)}</div>
    $|  <div class="center-wrap">\{render_node_card(root, parent_index=-1, center=true, tone_index=-1, options~, depth=0)}</div>
    $|  <div class="branch-column branch-column--right">\{render_branch_column(right, "right", root.flat_index, options, 0)}</div>
    $|</div>
  )
}

///|
fn render_branch_column(
  nodes : Array[@outline.OutlineNode],
  direction : String,
  parent_index : Int,
  options : RenderOptions,
  depth : Int,
) -> String {
  let rendered = []
  for index in 0..<nodes.length() {
    rendered.push(
      render_branch_node(
        nodes[index],
        parent_index,
        direction,
        fill_tone_index(index),
        options,
        depth + 1,
      ),
    )
  }
  rendered.join("")
}

///|
fn render_branch_node(
  node : @outline.OutlineNode,
  parent_index : Int,
  direction : String,
  tone_index : Int,
  options : RenderOptions,
  depth : Int,
) -> String {
  let children = if should_render_children(depth, options.layer) {
    render_branch_children(node, direction, tone_index, options, depth)
  } else {
    ""
  }
  let head = "<div class=\"branch-item__head\">\{render_node_card(node, parent_index~, center=false, tone_index~, options~, depth~)}</div>"
  if direction == "left" {
    "<div class=\"branch-item branch-item--left\" data-node-index=\"\{node.flat_index}\" data-parent-index=\"\{parent_index}\">\{children}\{head}</div>"
  } else {
    "<div class=\"branch-item branch-item--right\" data-node-index=\"\{node.flat_index}\" data-parent-index=\"\{parent_index}\">\{head}\{children}</div>"
  }
}

///|
fn render_branch_children(
  node : @outline.OutlineNode,
  direction : String,
  tone_index : Int,
  options : RenderOptions,
  depth : Int,
) -> String {
  if node.children.length() == 0 {
    return ""
  }
  let children = []
  for child in node.children {
    children.push(
      render_branch_node(
        child,
        node.flat_index,
        direction,
        tone_index,
        options,
        depth + 1,
      ),
    )
  }
  "<div class=\"branch-children branch-children--\{direction}\">\{children.join("")}</div>"
}

///|
fn render_single_right_mindmap(
  root : @outline.OutlineNode,
  options : RenderOptions,
) -> String {
  (
    $|<div class="\{stage_class(options, "mindmap-stage--single-right")}">
    $|  <div class="single-right-tree">\{render_single_right_tree(root, -1, true, -1, options, 0)}</div>
    $|</div>
  )
}

///|
fn render_single_right_tree(
  node : @outline.OutlineNode,
  parent_index : Int,
  center : Bool,
  tone_index : Int,
  options : RenderOptions,
  depth : Int,
) -> String {
  let children = if should_render_children(depth, options.layer) {
    render_single_right_children(node, tone_index, options, depth)
  } else {
    ""
  }
  (
    $|<div class="single-right-tree__node" data-node-index="\{node.flat_index}" data-parent-index="\{parent_index}">
    $|  <div class="single-right-tree__head">\{render_node_card(node, parent_index~, center~, tone_index~, options~, depth~)}</div>
    $|  \{children}
    $|</div>
  )
}

///|
fn render_single_right_children(
  node : @outline.OutlineNode,
  tone_index : Int,
  options : RenderOptions,
  depth : Int,
) -> String {
  if node.children.length() == 0 {
    return ""
  }
  let rendered = []
  for index in 0..<node.children.length() {
    let next_tone = if depth == 0 { fill_tone_index(index) } else { tone_index }
    rendered.push(
      render_single_right_tree(
        node.children[index],
        node.flat_index,
        false,
        next_tone,
        options,
        depth + 1,
      ),
    )
  }
  "<div class=\"single-right-tree__children\">\{rendered.join("")}</div>"
}

///|
fn render_vertical_mindmap(
  root : @outline.OutlineNode,
  options : RenderOptions,
) -> String {
  (
    $|<div class="\{stage_class(options, "mindmap-stage--vertical")}">
    $|  <div class="vertical-root">\{render_vertical_tree(root, -1, true, -1, options, 0)}</div>
    $|</div>
  )
}

///|
fn render_vertical_tree(
  node : @outline.OutlineNode,
  parent_index : Int,
  center : Bool,
  tone_index : Int,
  options : RenderOptions,
  depth : Int,
) -> String {
  let children = if should_render_children(depth, options.layer) {
    render_vertical_children(node, tone_index, options, depth)
  } else {
    ""
  }
  (
    $|<div class="vertical-tree" data-node-index="\{node.flat_index}" data-parent-index="\{parent_index}">
    $|  \{render_node_card(node, parent_index~, center~, tone_index~, options~, depth~)}
    $|  \{children}
    $|</div>
  )
}

///|
fn render_vertical_children(
  node : @outline.OutlineNode,
  tone_index : Int,
  options : RenderOptions,
  depth : Int,
) -> String {
  if node.children.length() == 0 {
    return ""
  }
  let rendered = []
  for index in 0..<node.children.length() {
    let next_tone = if depth == 0 { fill_tone_index(index) } else { tone_index }
    rendered.push(
      "<div class=\"vertical-tree__child\">\{render_vertical_tree(node.children[index], node.flat_index, false, next_tone, options, depth + 1)}</div>",
    )
  }
  "<div class=\"vertical-tree__children\">\{rendered.join("")}</div>"
}

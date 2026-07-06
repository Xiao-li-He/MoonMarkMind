///|
priv struct StaticNodeBox {
  index : Int
  parent_index : Int
  depth : Int
  x : Double
  y : Double
  width : Double
  height : Double
  branch_line : Bool
  center : Bool
}

///|
fn static_node_width(center : Bool) -> Double {
  if center {
    190.0
  } else {
    150.0
  }
}

///|
fn static_node_height(
  node : @outline.OutlineNode,
  center : Bool,
  options : RenderOptions,
) -> Double {
  let title_lines = max_int(1, (node.title.length() + 17) / 18)
  let body_height = if is_full_layer(options.layer) && node.body.length() > 0 {
    min_int(120, 26 + node.body.length() * 26).to_double()
  } else {
    0.0
  }
  (if center { 70.0 } else { 56.0 }) +
  title_lines.to_double() * 8.0 +
  body_height
}

///|
fn static_subtree_span(
  node : @outline.OutlineNode,
  depth : Int,
  options : RenderOptions,
) -> Double {
  let own = static_node_height(node, depth == 0, options) + 28.0
  if !should_render_layer_children(depth, options.layer) ||
    node.children.length() == 0 {
    own
  } else {
    let mut total = 0.0
    for child in node.children {
      total += static_subtree_span(child, depth + 1, options)
    }
    max_double(own, total)
  }
}

///|
fn collect_static_logic_boxes(
  boxes : Array[StaticNodeBox],
  node : @outline.OutlineNode,
  parent_index : Int,
  depth : Int,
  x : Double,
  top : Double,
  options : RenderOptions,
) -> Double {
  let span = static_subtree_span(node, depth, options)
  let center = depth == 0
  let width = static_node_width(center)
  let height = static_node_height(node, center, options)
  let y = top + span / 2.0 - height / 2.0
  boxes.push(StaticNodeBox::{
    index: node.flat_index,
    parent_index,
    depth,
    x,
    y,
    width,
    height,
    branch_line: options.style is Line,
    center,
  })
  if should_render_layer_children(depth, options.layer) {
    let mut cursor = top
    for child in node.children {
      let child_span = collect_static_logic_boxes(
        boxes,
        child,
        node.flat_index,
        depth + 1,
        x + width + 120.0,
        cursor,
        options,
      )
      cursor += child_span
    }
  }
  span
}

///|
fn collect_static_tree_boxes(
  boxes : Array[StaticNodeBox],
  node : @outline.OutlineNode,
  parent_index : Int,
  depth : Int,
  left : Double,
  y : Double,
  options : RenderOptions,
) -> Double {
  let center = depth == 0
  let width = static_node_width(center)
  let height = static_node_height(node, center, options)
  if !should_render_layer_children(depth, options.layer) ||
    node.children.length() == 0 {
    boxes.push(StaticNodeBox::{
      index: node.flat_index,
      parent_index,
      depth,
      x: left,
      y,
      width,
      height,
      branch_line: options.style is Line,
      center,
    })
    width + 48.0
  } else {
    let mut children_width = 0.0
    for child in node.children {
      children_width += static_subtree_leaf_width(child, depth + 1, options)
    }
    let own_x = left + max_double(0.0, children_width - width) / 2.0
    boxes.push(StaticNodeBox::{
      index: node.flat_index,
      parent_index,
      depth,
      x: own_x,
      y,
      width,
      height,
      branch_line: options.style is Line,
      center,
    })
    let mut cursor = left
    for child in node.children {
      let consumed = collect_static_tree_boxes(
        boxes,
        child,
        node.flat_index,
        depth + 1,
        cursor,
        y + height + 120.0,
        options,
      )
      cursor += consumed
    }
    max_double(width + 48.0, children_width)
  }
}

///|
fn static_subtree_leaf_width(
  node : @outline.OutlineNode,
  depth : Int,
  options : RenderOptions,
) -> Double {
  if !should_render_layer_children(depth, options.layer) ||
    node.children.length() == 0 {
    static_node_width(false) + 48.0
  } else {
    let mut total = 0.0
    for child in node.children {
      total += static_subtree_leaf_width(child, depth + 1, options)
    }
    total
  }
}

///|
fn collect_static_mindmap_boxes(
  boxes : Array[StaticNodeBox],
  root : @outline.OutlineNode,
  options : RenderOptions,
) -> Unit {
  let center_width = static_node_width(true)
  let center_height = static_node_height(root, true, options)
  let left_children = (root.children.length() + 1) / 2
  let left_span = static_children_span(root.children, 0, left_children, options)
  let right_span = static_children_span(
    root.children,
    left_children,
    root.children.length(),
    options,
  )
  let center_y = 80.0 +
    max_double(left_span, right_span) / 2.0 -
    center_height / 2.0
  boxes.push(StaticNodeBox::{
    index: root.flat_index,
    parent_index: -1,
    depth: 0,
    x: 520.0,
    y: center_y,
    width: center_width,
    height: center_height,
    branch_line: options.style is Line,
    center: true,
  })
  collect_static_mindmap_side(
    boxes, root, 0, left_children, "left", 80.0, options,
  )
  collect_static_mindmap_side(
    boxes,
    root,
    left_children,
    root.children.length(),
    "right",
    80.0,
    options,
  )
}

///|
fn static_children_span(
  children : Array[@outline.OutlineNode],
  start : Int,
  end_ : Int,
  options : RenderOptions,
) -> Double {
  let mut total = 0.0
  for index in start..<end_ {
    total += static_subtree_span(children[index], 1, options)
  }
  max_double(total, 180.0)
}

///|
fn collect_static_mindmap_side(
  boxes : Array[StaticNodeBox],
  root : @outline.OutlineNode,
  start : Int,
  end_ : Int,
  direction : String,
  top : Double,
  options : RenderOptions,
) -> Unit {
  let mut cursor = top
  for index in start..<end_ {
    let child = root.children[index]
    let span = static_subtree_span(child, 1, options)
    let x = if direction == "left" { 260.0 } else { 830.0 }
    ignore(
      collect_static_mindmap_branch(
        boxes,
        child,
        root.flat_index,
        1,
        x,
        cursor,
        direction,
        options,
      ),
    )
    cursor += span
  }
}

///|
fn collect_static_mindmap_branch(
  boxes : Array[StaticNodeBox],
  node : @outline.OutlineNode,
  parent_index : Int,
  depth : Int,
  x : Double,
  top : Double,
  direction : String,
  options : RenderOptions,
) -> Double {
  let span = static_subtree_span(node, depth, options)
  let width = static_node_width(false)
  let height = static_node_height(node, false, options)
  let y = top + span / 2.0 - height / 2.0
  boxes.push(StaticNodeBox::{
    index: node.flat_index,
    parent_index,
    depth,
    x,
    y,
    width,
    height,
    branch_line: options.style is Line,
    center: false,
  })
  if should_render_layer_children(depth, options.layer) {
    let mut cursor = top
    let next_x = if direction == "left" { x - 230.0 } else { x + 230.0 }
    for child in node.children {
      let child_span = collect_static_mindmap_branch(
        boxes,
        child,
        node.flat_index,
        depth + 1,
        next_x,
        cursor,
        direction,
        options,
      )
      cursor += child_span
    }
  }
  span
}

///|
fn static_boxes(
  root : @outline.OutlineNode,
  options : RenderOptions,
) -> Array[StaticNodeBox] {
  let boxes = []
  match options.layout {
    Logic =>
      ignore(
        collect_static_logic_boxes(boxes, root, -1, 0, 80.0, 80.0, options),
      )
    Tree =>
      ignore(collect_static_tree_boxes(boxes, root, -1, 0, 80.0, 80.0, options))
    Mindmap => collect_static_mindmap_boxes(boxes, root, options)
  }
  boxes
}

///|
fn find_static_box(boxes : Array[StaticNodeBox], index : Int) -> StaticNodeBox? {
  for box in boxes {
    if box.index == index {
      return Some(box)
    }
  }
  None
}

///|
fn static_canvas_size(boxes : Array[StaticNodeBox]) -> (Int, Int) {
  let mut right = 1.0
  let mut bottom = 1.0
  for box in boxes {
    right = max_double(right, box.x + box.width + 96.0)
    bottom = max_double(bottom, box.y + box.height + 96.0)
  }
  (right.ceil().to_int(), bottom.ceil().to_int())
}

///|
fn static_connector_path(
  parent : StaticNodeBox,
  node : StaticNodeBox,
  layout : MindmapLayout,
) -> String {
  let parent_center_x = parent.x + parent.width / 2.0
  let parent_center_y = parent.y + parent.height / 2.0
  let node_center_x = node.x + node.width / 2.0
  let node_center_y = node.y + node.height / 2.0
  let parent_anchor_y = if parent.branch_line {
    parent.y + parent.height - 0.8
  } else {
    parent_center_y
  }
  let node_anchor_y = if node.branch_line {
    node.y + node.height - 0.8
  } else {
    node_center_y
  }
  let data = match layout {
    Tree => {
      let start_y = parent.y + parent.height
      let end_y = node.y
      let span_y = abs_double(end_y - start_y)
      let bend = min_double(44.0, max_double(16.0, span_y * 0.4))
      (
        parent_center_x,
        start_y,
        parent_center_x,
        start_y + bend,
        node_center_x,
        end_y - bend,
        node_center_x,
        end_y,
      )
    }
    Logic => {
      let start_x = parent.x + parent.width
      let end_x = node.x
      let span_x = abs_double(end_x - start_x)
      let bend = min_double(36.0, max_double(14.0, span_x * 0.28))
      (
        start_x,
        parent_anchor_y,
        start_x + bend,
        parent_anchor_y,
        end_x - bend,
        node_anchor_y,
        end_x,
        node_anchor_y,
      )
    }
    Mindmap => {
      let direction = if node_center_x >= parent_center_x { 1.0 } else { -1.0 }
      let start_x = if direction > 0.0 {
        parent.x + parent.width
      } else {
        parent.x
      }
      let end_x = if direction > 0.0 { node.x } else { node.x + node.width }
      let span = abs_double(end_x - start_x)
      if parent.branch_line || node.branch_line {
        let vertical_delta = abs_double(node_anchor_y - parent_anchor_y)
        let handle_limit = max_double(14.0, span * 0.46)
        let handle_target = min_double(
          68.0,
          max_double(22.0, span * 0.34 + vertical_delta * 0.2),
        )
        let handle = min_double(handle_limit, handle_target)
        (
          start_x,
          parent_anchor_y,
          start_x + direction * handle,
          parent_anchor_y,
          end_x - direction * handle,
          node_anchor_y,
          end_x,
          node_anchor_y,
        )
      } else {
        let pull = min_double(30.0, max_double(12.0, span * 0.26))
        let settle = min_double(40.0, max_double(14.0, span * 0.38))
        let mid_y = parent_center_y + (node_center_y - parent_center_y) * 0.2
        (
          start_x,
          parent_anchor_y,
          start_x + direction * pull,
          mid_y,
          end_x - direction * settle,
          node_anchor_y,
          end_x,
          node_anchor_y,
        )
      }
    }
  }
  "M \{double_to_svg_number(data.0)} \{double_to_svg_number(data.1)} C \{double_to_svg_number(data.2)} \{double_to_svg_number(data.3)}, \{double_to_svg_number(data.4)} \{double_to_svg_number(data.5)}, \{double_to_svg_number(data.6)} \{double_to_svg_number(data.7)}"
}

///|
fn static_connector_stroke_width(
  node : StaticNodeBox,
  parent : StaticNodeBox,
) -> Double {
  if node.branch_line {
    let width = if node.center {
      1.8
    } else if node.depth == 1 {
      1.5
    } else {
      1.25
    }
    if parent.branch_line {
      max_double(
        width,
        if parent.center {
          1.8
        } else if parent.depth == 1 {
          1.5
        } else {
          1.25
        },
      )
    } else {
      width
    }
  } else if node.depth == 1 {
    2.8
  } else {
    2.0
  }
}

///|
fn write_static_connector_layer(
  out : StringBuilder,
  root : @outline.OutlineNode,
  options : RenderOptions,
  width : Int,
  height : Int,
) -> Unit {
  let boxes = static_boxes(root, options)
  let color = if options.style is Full { "#7ca5d4" } else { "#94b6db" }
  write_str(out, "<svg")
  write_class_attr(out, "mindmap-connector-layer")
  write_attr(out, "xmlns", "http://www.w3.org/2000/svg")
  write_int_attr(out, "width", width)
  write_int_attr(out, "height", height)
  write_attr(out, "viewBox", "0 0 \{width} \{height}")
  write_str(out, ">")
  for box in boxes {
    if box.parent_index >= 0 {
      match find_static_box(boxes, box.parent_index) {
        Some(parent) => {
          write_str(out, "<path")
          write_attr(
            out,
            "d",
            static_connector_path(parent, box, options.layout),
          )
          write_attr(out, "fill", "none")
          write_attr(out, "stroke", color)
          write_attr(out, "stroke-opacity", "0.9")
          write_attr(
            out,
            "stroke-width",
            double_to_svg_number(static_connector_stroke_width(box, parent)),
          )
          write_attr(out, "stroke-linecap", "round")
          write_attr(out, "stroke-linejoin", "round")
          write_attr(out, "vector-effect", "non-scaling-stroke")
          write_str(out, "/>")
        }
        None => ()
      }
    }
  }
  write_str(out, "</svg>")
}

///|
fn max_int(left : Int, right : Int) -> Int {
  if left > right {
    left
  } else {
    right
  }
}

///|
fn min_int(left : Int, right : Int) -> Int {
  if left < right {
    left
  } else {
    right
  }
}

///|
fn abs_double(value : Double) -> Double {
  if value < 0.0 {
    -value
  } else {
    value
  }
}

///|
fn min_double(left : Double, right : Double) -> Double {
  if left < right {
    left
  } else {
    right
  }
}

///|
fn max_double(left : Double, right : Double) -> Double {
  if left > right {
    left
  } else {
    right
  }
}

///|
fn double_to_svg_number(value : Double) -> String {
  value.to_string()
}

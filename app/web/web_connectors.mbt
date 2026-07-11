///|
/// Live SVG connector rendering for the interactive mind map.
///
/// This file converts measured DOM node boxes into connector paths and
/// keeps the connector layer aligned with the current browser layout.

///|
/// Rebuild the live SVG connector layer from the currently measured node DOM.
///
/// The function reads browser layout after rendering, so it intentionally stays
/// in the web package rather than in the pure mindmap renderer.
fn render_mindmap_connectors() -> Unit {
  match get_element("#mindmap") {
    Some(mindmap) =>
      match mindmap.querySelector(".mindmap-content") {
        Some(content) =>
          match content.querySelector(".mindmap-stage") {
            Some(stage) => {
              let stage_element = stage
              let nodes : Array[@dom.Element] = content.querySelectorAll(
                ".node[data-node-index]",
              )
              if nodes.length() <= 1 {
                return
              }
              let zoom = parse_float(
                mindmap.getAttribute("data-zoom").unwrap_or("1"),
              )
              let safe_zoom = if zoom.is_nan() || zoom <= 0.0 {
                1.0
              } else {
                zoom
              }
              let content_rect = element_rect(content)
              let stage_rect = element_rect(stage_element)
              let stage_left = stage_rect.left
              let stage_top = stage_rect.top
              let width = if stage_rect.width / safe_zoom < 1.0 {
                1
              } else {
                (stage_rect.width / safe_zoom).round().to_int()
              }
              let height = if stage_rect.height / safe_zoom < 1.0 {
                1
              } else {
                (stage_rect.height / safe_zoom).round().to_int()
              }
              let left = ((stage_rect.left - content_rect.left) / safe_zoom)
                .round()
                .to_int()
              let top = ((stage_rect.top - content_rect.top) / safe_zoom)
                .round()
                .to_int()
              let svg_paths : Array[@dom.Element] = []
              let layout = stage_layout_kind(stage_element)
              for node in nodes {
                match
                  build_branch_line_node_baseline(
                    layout,
                    node,
                    element_rect(node),
                    stage_left,
                    stage_top,
                    safe_zoom,
                    "var(--mindmap-connector-color, #94b6db)",
                  ) {
                  Some(path) => svg_paths.push(path)
                  None => ()
                }
              }
              for node in nodes {
                let parent_index = parse_int_or_default(
                  node.getAttribute("data-parent-index").unwrap_or("-1"),
                  -1,
                )
                if parent_index < 0 {
                  continue
                }
                match find_node_by_index(nodes, parent_index) {
                  Some(parent) =>
                    match
                      connector_geometry(
                        layout,
                        element_rect(parent),
                        element_rect(node),
                        parent,
                        node,
                        stage_left,
                        stage_top,
                        safe_zoom,
                      ) {
                      Some(path_data) =>
                        svg_paths.push(
                          build_connector_path(parent, node, path_data),
                        )
                      None => ()
                    }
                  None => ()
                }
              }
              let svg = ensure_mindmap_connector_svg(stage_element)
              clear_element(svg)
              svg.setAttribute("width", width.to_string())
              svg.setAttribute("height", height.to_string())
              svg.setAttribute("viewBox", "0 0 \{width} \{height}")
              let style = @dom.css_style_from_val(
                svg.as_any()._get("style").cast(),
              )
              style.set_property("left", "0px")
              style.set_property("top", "0px")
              style.set_property("width", "\{width}px")
              style.set_property("height", "\{height}px")
              style.set_property("z-index", connector_layer_z_index(layout))
              style.set_property("pointer-events", "none")
              style.set_property("position", "absolute")
              style.set_property("overflow", "visible")
              for path in svg_paths {
                append_child(svg, path)
              }
              ignore(
                render_mindmap_connector_controls(
                  content, stage_element, nodes, stage_left, stage_top, safe_zoom,
                  left, top, width, height,
                ),
              )
            }
            None => ()
          }
        None => ()
      }
    None => ()
  }
}

///|
fn render_mindmap_connector_controls(
  content : @dom.Element,
  stage : @dom.Element,
  nodes : Array[@dom.Element],
  stage_left : Double,
  stage_top : Double,
  safe_zoom : Double,
  left : Int,
  top : Int,
  width : Int,
  height : Int,
) -> Bool {
  match content.querySelector(".mindmap-connector-controls") {
    Some(existing) => existing.remove()
    None => ()
  }
  let _ = nodes
  let _ = stage
  let _ = stage_left
  let _ = stage_top
  let _ = safe_zoom
  let _ = left
  let _ = top
  let _ = width
  let _ = height
  false
}

///|
fn ensure_mindmap_connector_svg(stage : @dom.Element) -> @dom.Element {
  match stage.querySelector(".mindmap-connector-layer") {
    Some(svg) => svg
    None => {
      let svg = create_svg_element("svg", "mindmap-connector-layer")
      append_child(stage, svg)
      svg
    }
  }
}

///|
priv enum StageLayoutKind {
  Mindmap
  Logic
  Tree
}

///|
priv struct ConnectorPathData {
  start_x : Double
  start_y : Double
  control1_x : Double
  control1_y : Double
  control2_x : Double
  control2_y : Double
  end_x : Double
  end_y : Double
}

///|
fn stage_layout_kind(stage : @dom.Element) -> StageLayoutKind {
  if has_class_name(stage, "mindmap-stage--vertical") {
    StageLayoutKind::Tree
  } else if has_class_name(stage, "mindmap-stage--single-right") {
    StageLayoutKind::Logic
  } else {
    StageLayoutKind::Mindmap
  }
}

///|
/// Compute the cubic connector path in stage-local coordinates.
///
/// The result is `None` when the layout cannot produce a meaningful connector,
/// such as zero-width side direction or unsupported tree geometry.
fn connector_geometry(
  layout : StageLayoutKind,
  parent_rect : @dom.DOMRect,
  node_rect : @dom.DOMRect,
  parent_node : @dom.Element,
  node : @dom.Element,
  stage_left : Double,
  stage_top : Double,
  safe_zoom : Double,
) -> ConnectorPathData? {
  let parent_center_x = stage_local_x(
    rect_center_x(parent_rect),
    stage_left,
    safe_zoom,
  )
  let parent_center_y = stage_local_y(
    rect_center_y(parent_rect),
    stage_top,
    safe_zoom,
  )
  let node_center_x = stage_local_x(
    rect_center_x(node_rect),
    stage_left,
    safe_zoom,
  )
  let node_center_y = stage_local_y(
    rect_center_y(node_rect),
    stage_top,
    safe_zoom,
  )
  let parent_anchor_y = stage_local_y(
    connector_node_anchor_y(parent_rect, parent_node),
    stage_top,
    safe_zoom,
  )
  let node_anchor_y = stage_local_y(
    connector_node_anchor_y(node_rect, node),
    stage_top,
    safe_zoom,
  )
  match layout {
    StageLayoutKind::Tree => {
      let start_x = parent_center_x
      let start_y = stage_local_y(
        connector_node_bottom_y(parent_rect, parent_node, safe_zoom),
        stage_top,
        safe_zoom,
      )
      let end_x = node_center_x
      let end_y = stage_local_y(node_rect.top, stage_top, safe_zoom)
      let span_y = abs_double(end_y - start_y)
      let bend = min_double(44.0, max_double(16.0, span_y * 0.4))
      Some(ConnectorPathData::{
        start_x,
        start_y,
        control1_x: start_x,
        control1_y: start_y + bend,
        control2_x: end_x,
        control2_y: end_y - bend,
        end_x,
        end_y,
      })
    }
    StageLayoutKind::Logic => {
      let start_x = stage_local_x(
        connector_node_side_x(parent_rect, parent_node, 1.0, safe_zoom),
        stage_left,
        safe_zoom,
      )
      let start_y = parent_anchor_y
      let end_x = stage_local_x(node_rect.left, stage_left, safe_zoom)
      let end_y = node_anchor_y
      let span_x = abs_double(end_x - start_x)
      let bend = min_double(36.0, max_double(14.0, span_x * 0.28))
      Some(ConnectorPathData::{
        start_x,
        start_y,
        control1_x: start_x + bend,
        control1_y: start_y,
        control2_x: end_x - bend,
        control2_y: end_y,
        end_x,
        end_y,
      })
    }
    StageLayoutKind::Mindmap => {
      let direction = if node_center_x >= parent_center_x { 1.0 } else { -1.0 }
      let start_x = stage_local_x(
        connector_node_side_x(parent_rect, parent_node, direction, safe_zoom),
        stage_left,
        safe_zoom,
      )
      let end_x = stage_local_x(
        if direction > 0.0 {
          node_rect.left
        } else {
          node_rect.right
        },
        stage_left,
        safe_zoom,
      )
      let span = abs_double(end_x - start_x)
      let is_branch_line = has_class_name(parent_node, "node--branch-line") ||
        has_class_name(node, "node--branch-line")
      if is_branch_line {
        return Some(
          branch_line_connector_path_data(
            start_x, parent_anchor_y, end_x, node_anchor_y, direction, span,
          ),
        )
      }
      let pull = min_double(30.0, max_double(12.0, span * 0.26))
      let settle = min_double(40.0, max_double(14.0, span * 0.38))
      let mid_y = parent_center_y + (node_center_y - parent_center_y) * 0.2
      Some(ConnectorPathData::{
        start_x,
        start_y: parent_anchor_y,
        control1_x: start_x + direction * pull,
        control1_y: mid_y,
        control2_x: end_x - direction * settle,
        control2_y: node_anchor_y,
        end_x,
        end_y: node_anchor_y,
      })
    }
  }
}

///|
fn branch_line_connector_path_data(
  start_x : Double,
  start_y : Double,
  end_x : Double,
  end_y : Double,
  direction : Double,
  span : Double,
) -> ConnectorPathData {
  let vertical_delta = abs_double(end_y - start_y)
  let handle_limit = max_double(14.0, span * 0.46)
  let handle_target = min_double(
    68.0,
    max_double(22.0, span * 0.34 + vertical_delta * 0.2),
  )
  let handle = min_double(handle_limit, handle_target)
  ConnectorPathData::{
    start_x,
    start_y,
    control1_x: start_x + direction * handle,
    control1_y: start_y,
    control2_x: end_x - direction * handle,
    control2_y: end_y,
    end_x,
    end_y,
  }
}

///|
fn connector_node_anchor_y(rect : @dom.DOMRect, node : @dom.Element) -> Double {
  if has_class_name(node, "node--branch-line") {
    rect.bottom - branch_line_baseline_offset(node)
  } else {
    rect_center_y(rect)
  }
}

///|
fn branch_line_baseline_offset(node : @dom.Element) -> Double {
  if has_class_name(node, "node--center") {
    0.9
  } else {
    0.7
  }
}

///|
fn branch_line_connector_extension(node : @dom.Element) -> Double {
  branch_line_connector_extension_by_kind(
    center=has_class_name(node, "node--center"),
  )
}

///|
fn branch_line_connector_extension_by_kind(center~ : Bool) -> Double {
  if center {
    30.0
  } else {
    22.0
  }
}

///|
fn connector_node_side_x(
  rect : @dom.DOMRect,
  node : @dom.Element,
  direction : Double,
  safe_zoom : Double,
) -> Double {
  let edge = if direction > 0.0 { rect.right } else { rect.left }
  let _ = node
  let _ = safe_zoom
  edge
}

///|
fn connector_node_bottom_y(
  rect : @dom.DOMRect,
  node : @dom.Element,
  safe_zoom : Double,
) -> Double {
  let _ = node
  let _ = safe_zoom
  rect.bottom
}

///|
fn export_tree_connector_parent_anchor_y(
  rect : @dom.DOMRect,
  node : @dom.Element,
) -> Double {
  match export_tree_connector_toggle_center_y(node) {
    Some(y) => y
    None => rect.bottom + export_tree_connector_bottom_offset(node)
  }
}

///|
fn export_tree_connector_child_anchor_y(
  rect : @dom.DOMRect,
  node : @dom.Element,
) -> Double {
  let _ = node
  rect.top
}

///|
fn export_tree_connector_toggle_center_y(node : @dom.Element) -> Double? {
  match
    node.querySelector(".node-actions--bottom-center .node-action--toggle") {
    Some(toggle) => Some(rect_center_y(element_rect(toggle)))
    None =>
      match node.querySelector(".node-actions--bottom-center") {
        Some(actions) => Some(rect_center_y(element_rect(actions)))
        None => None
      }
  }
}

///|
fn export_tree_connector_bottom_offset(node : @dom.Element) -> Double {
  if has_class_name(node, "node--branch-line") {
    export_tree_branch_line_bottom_connector_offset()
  } else {
    0.0
  }
}

///|
fn export_tree_branch_line_bottom_connector_offset() -> Double {
  15.0
}

///|
fn build_connector_path(
  parent_node : @dom.Element,
  node : @dom.Element,
  path_data : ConnectorPathData,
) -> @dom.Element {
  let stroke_width = if has_class_name(node, "node--branch-line") {
    let node_stroke_width = branch_line_stroke_width(node)
    if has_class_name(parent_node, "node--branch-line") {
      max_double(node_stroke_width, branch_line_stroke_width(parent_node))
    } else {
      node_stroke_width
    }
  } else if parse_int_or_default(
      node.getAttribute("data-depth").unwrap_or("0"),
      0,
    ) ==
    1 {
    2.8
  } else {
    2.0
  }
  let path = create_svg_element("path", "")
  let branch_extension = branch_line_connector_path_extension(
    parent_node, path_data,
  )
  path.setAttribute(
    "d",
    "\{branch_extension}M \{double_to_svg_number(path_data.start_x)} \{double_to_svg_number(path_data.start_y)} C \{double_to_svg_number(path_data.control1_x)} \{double_to_svg_number(path_data.control1_y)}, \{double_to_svg_number(path_data.control2_x)} \{double_to_svg_number(path_data.control2_y)}, \{double_to_svg_number(path_data.end_x)} \{double_to_svg_number(path_data.end_y)}",
  )
  path.setAttribute("fill", "none")
  path.setAttribute("stroke", "var(--mindmap-connector-color, #94b6db)")
  path.setAttribute("stroke-opacity", "0.9")
  path.setAttribute("stroke-width", double_to_svg_number(stroke_width))
  path.setAttribute("stroke-linecap", "round")
  path.setAttribute("stroke-linejoin", "round")
  path.setAttribute("vector-effect", "non-scaling-stroke")
  path
}

///|
fn build_branch_line_node_baseline(
  layout : StageLayoutKind,
  node : @dom.Element,
  rect : @dom.DOMRect,
  origin_left : Double,
  origin_top : Double,
  safe_zoom : Double,
  color : String,
) -> @dom.Element? {
  if is_tree_layout(layout) ||
    !has_class_name(node, "node--branch-line") ||
    has_class_name(node, "node--line-tree") {
    return None
  }
  let start_x = stage_local_x(rect.left, origin_left, safe_zoom)
  let end_x = stage_local_x(rect.right, origin_left, safe_zoom)
  let y = stage_local_y(
    connector_node_anchor_y(rect, node),
    origin_top,
    safe_zoom,
  )
  let path = create_svg_element("path", "")
  path.setAttribute(
    "d",
    "M \{double_to_svg_number(start_x)} \{double_to_svg_number(y)} L \{double_to_svg_number(end_x)} \{double_to_svg_number(y)}",
  )
  path.setAttribute("fill", "none")
  path.setAttribute("stroke", color)
  path.setAttribute("stroke-opacity", "0.9")
  path.setAttribute(
    "stroke-width",
    double_to_svg_number(branch_line_stroke_width(node)),
  )
  path.setAttribute("stroke-linecap", "round")
  path.setAttribute("stroke-linejoin", "round")
  path.setAttribute("vector-effect", "non-scaling-stroke")
  Some(path)
}

///|
fn branch_line_stroke_width(node : @dom.Element) -> Double {
  branch_line_stroke_width_by_kind(
    center=has_class_name(node, "node--center"),
    depth=parse_int_or_default(
      node.getAttribute("data-depth").unwrap_or("0"),
      0,
    ),
  )
}

///|
fn branch_line_stroke_width_by_kind(center~ : Bool, depth~ : Int) -> Double {
  if center {
    1.8
  } else if depth == 1 {
    1.5
  } else {
    1.25
  }
}

///|
/// Add the short horizontal branch-line stub before the cubic connector.
///
/// Branch-line nodes visually start on a drawn baseline, so the SVG path needs
/// this extra segment to preserve the apparent anchor point.
fn branch_line_connector_path_extension(
  parent_node : @dom.Element,
  path_data : ConnectorPathData,
) -> String {
  if !has_class_name(parent_node, "node--branch-line") {
    return ""
  }
  let direction = path_direction(path_data.control1_x - path_data.start_x)
  if direction == 0.0 {
    return ""
  }
  let extension_x = path_data.start_x -
    direction * branch_line_connector_extension(parent_node)
  "M \{double_to_svg_number(path_data.start_x)} \{double_to_svg_number(path_data.start_y)} L \{double_to_svg_number(extension_x)} \{double_to_svg_number(path_data.start_y)} "
}

///|
fn path_direction(delta : Double) -> Double {
  if delta > 0.0 {
    1.0
  } else if delta < 0.0 {
    -1.0
  } else {
    0.0
  }
}

///|
fn connector_layer_z_index(layout : StageLayoutKind) -> String {
  match layout {
    StageLayoutKind::Tree => "0"
    _ => "1"
  }
}

///|
fn is_tree_layout(layout : StageLayoutKind) -> Bool {
  match layout {
    StageLayoutKind::Tree => true
    _ => false
  }
}

///|
fn find_node_by_index(
  nodes : Array[@dom.Element],
  target_index : Int,
) -> @dom.Element? {
  for node in nodes {
    let node_index = parse_int_or_default(
      node.getAttribute("data-node-index").unwrap_or("-1"),
      -1,
    )
    if node_index == target_index {
      return Some(node)
    }
  }
  None
}

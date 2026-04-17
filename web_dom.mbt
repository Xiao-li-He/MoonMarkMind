///|
fn get_element(selector : String) -> @dom.Element? {
  @dom.document().querySelector(selector)
}

///|
fn get_element_by_id(id : String) -> @dom.Element? {
  @dom.document().getElementById(id)
}

///|
fn to_text_area(element : @dom.Element) -> @dom.HTMLTextAreaElement {
  @dom.HTMLTextAreaElement::cast_from_element(element)
}

///|
let tooltip_visible : @ref.Ref[Bool] = @ref.Ref(false)

///|
let tooltip_text : @ref.Ref[String] = @ref.Ref("")

///|
fn bind_tooltip_ui() -> Unit {
  match get_element("#tooltip-layer") {
    Some(layer) =>
      match layer.querySelector("#tooltip") {
        Some(tooltip) =>
          match tooltip.querySelector(".tooltip__text") {
            Some(text) => {
              let window = @dom.window()
              let sync_tooltip = fn(event : @dom.MouseEvent) {
                let target = event.target()
                match target.closest("[data-tip]") {
                  Some(control) => {
                    if !is_tooltip_allowed(control) {
                      hide_tooltip(layer, tooltip)
                      return
                    }
                    let tip = control.getAttribute("data-tip").unwrap_or("")
                    if tip.length() == 0 {
                      hide_tooltip(layer, tooltip)
                      return
                    }
                    show_tooltip(layer, tooltip, text, control, tip)
                  }
                  None => hide_tooltip(layer, tooltip)
                }
              }
              @dom.document()
              .as_event_target()
              .on("mouseover", fn(raw) { sync_tooltip(raw.cast()) })
              @dom.document()
              .as_event_target()
              .on("mousemove", fn(raw) { sync_tooltip(raw.cast()) })
              @dom.document()
              .as_event_target()
              .on("mouseleave", fn(_) { hide_tooltip(layer, tooltip) })
              window
              .as_event_target()
              .on("blur", fn(_) { hide_tooltip(layer, tooltip) })
              window
              .as_event_target()
              .on("scroll", fn(_) { hide_tooltip(layer, tooltip) })
            }
            None => ()
          }
        None => ()
      }
    None => ()
  }
}

///|
fn show_tooltip(
  layer : @dom.Element,
  tooltip : @dom.Element,
  text : @dom.Element,
  control : @dom.Element,
  tip : String,
) -> Unit {
  if tooltip_visible.val && tooltip_text.val == tip {
    position_tooltip(tooltip, control)
    return
  }
  tooltip_visible.val = true
  tooltip_text.val = tip
  text.setTextContent(tip)
  layer.setAttribute("aria-hidden", "false")
  let style = @dom.css_style_from_val(tooltip.as_any()._get("style").cast())
  style.set_property("opacity", "1")
  style.set_property("visibility", "visible")
  style.set_property("transform", "translateX(-50%)")
  position_tooltip(tooltip, control)
}

///|
fn is_tooltip_allowed(control : @dom.Element) -> Bool {
  control.closest(".editor-chrome, .mindmap-toolbar") is Some(_)
}

///|
fn hide_tooltip(layer : @dom.Element, tooltip : @dom.Element) -> Unit {
  if !tooltip_visible.val {
    return
  }
  tooltip_visible.val = false
  tooltip_text.val = ""
  layer.setAttribute("aria-hidden", "true")
  let style = @dom.css_style_from_val(tooltip.as_any()._get("style").cast())
  style.set_property("opacity", "0")
  style.set_property("visibility", "hidden")
  style.set_property("transform", "translate(-9999px, -9999px)")
}

///|
fn position_tooltip(tooltip : @dom.Element, control : @dom.Element) -> Unit {
  let rect = element_rect(control)
  let viewport_width = @dom.window().innerWidth().to_double()
  let viewport_height = @dom.window().innerHeight().to_double()
  let center_x = rect.left + rect.width / 2.0
  let next_left = clamp_double(center_x - 12.0, 12.0, viewport_width - 40.0)
  let next_top = clamp_double(rect.bottom - 2.0, 12.0, viewport_height - 20.0)
  let style = @dom.css_style_from_val(tooltip.as_any()._get("style").cast())
  style.set_property("left", "\{next_left}px")
  style.set_property("top", "\{next_top}px")
}

///|
fn clamp_double(
  value : Double,
  min_value : Double,
  max_value : Double,
) -> Double {
  if value < min_value {
    min_value
  } else if value > max_value {
    max_value
  } else {
    value
  }
}

///|
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

///|
fn element_rect(element : @dom.Element) -> @dom.DOMRect {
  element.as_any()._call("getBoundingClientRect", []).cast()
}

///|
fn rect_center_x(rect : @dom.DOMRect) -> Double {
  (rect.left + rect.right) / 2.0
}

///|
fn rect_center_y(rect : @dom.DOMRect) -> Double {
  (rect.top + rect.bottom) / 2.0
}

///|
fn stage_local_x(
  absolute_x : Double,
  stage_left : Double,
  zoom : Double,
) -> Double {
  (absolute_x - stage_left) / zoom
}

///|
fn stage_local_y(
  absolute_y : Double,
  stage_top : Double,
  zoom : Double,
) -> Double {
  (absolute_y - stage_top) / zoom
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

///|
fn parse_float(raw : String) -> Double {
  parse_double_or_default(raw, 0.0 / 0.0)
}

///|
let input_linked_line_indexes : @ref.Ref[Array[Int]] = @ref.Ref([])

///|
let input_hover_line_index : @ref.Ref[Int] = @ref.Ref(-1)

///|
let input_selection_frame : @ref.Ref[Int] = @ref.Ref(0)

///|
let input_selected_headings_frame : @ref.Ref[Int] = @ref.Ref(0)

///|
let input_last_selected_headings_key : @ref.Ref[String] = @ref.Ref("__init__")

///|
fn sync_editor_chrome() -> Unit {
  match get_element("#input") {
    Some(input_element) => {
      let input = @dom.HTMLTextAreaElement::cast_from_element(input_element)
      let metrics = input_line_metrics(input)
      let scroll_top = input.scrollTop()
      sync_input_line_numbers(input, metrics)
      sync_input_linked_lines(input, metrics, scroll_top)
      sync_input_hover_line(input, metrics, scroll_top)
      sync_input_active_line(input, metrics, scroll_top)
    }
    None => ()
  }
}

///|
fn schedule_render_mindmap_connectors() -> Unit {
  let window = @dom.window()
  let expected_cycle = current_mindmap_render_cycle()
  ignore(
    window.requestAnimationFrame(fn(_) {
      ignore(
        window.requestAnimationFrame(fn(_) {
          if !mindmap_render_cycle_matches(expected_cycle) {
            return
          }
          render_mindmap_connectors()
        }),
      )
    }),
  )
}

///|
let contour_layout_frame : @ref.Ref[Int] = @ref.Ref(0)

///|
let mindmap_render_cycle : @ref.Ref[Int] = @ref.Ref(0)

///|
fn current_mindmap_render_cycle() -> Int {
  mindmap_render_cycle.val
}

///|
fn mindmap_render_cycle_matches(expected_cycle : Int) -> Bool {
  expected_cycle == mindmap_render_cycle.val
}

///|
fn schedule_contour_layout() -> Unit {
  let window = @dom.window()
  mindmap_render_cycle.val += 1
  let expected_cycle = mindmap_render_cycle.val
  if contour_layout_frame.val != 0 {
    window.cancelAnimationFrame(contour_layout_frame.val)
  }
  contour_layout_frame.val = window.requestAnimationFrame(fn(_) {
    contour_layout_frame.val = 0
    if expected_cycle != mindmap_render_cycle.val {
      return
    }
    apply_contour_layout()
    ignore(
      window.requestAnimationFrame(fn(_) {
        if expected_cycle != mindmap_render_cycle.val {
          return
        }
        apply_contour_layout()
        schedule_render_mindmap_connectors()
      }),
    )
  })
}

///|
fn apply_contour_layout() -> Unit {
  match get_element("#mindmap") {
    Some(mindmap) =>
      match mindmap.querySelector(".mindmap-stage") {
        Some(stage) => {
          if has_class_name(stage, "mindmap-stage--radial") {
            apply_contour_min_heights(stage)
          }
          if has_class_name(stage, "mindmap-stage--radial") {
            apply_mindmap_root_packing(stage)
            apply_mindmap_single_child_alignment(stage)
          }
        }
        None => ()
      }
    None => ()
  }
}

///|
fn apply_contour_min_heights(stage : @dom.Element) -> Unit {
  let nodes = stage.querySelectorAll("[data-node-index]")
  for element in nodes {
    if has_class_name(element, "node") {
      continue
    }
    if !has_class_name(element, "branch-item--root") {
      let style = @dom.css_style_from_val(element.as_any()._get("style").cast())
      style.set_property("min-height", "0")
      continue
    }
    let node_index = parse_int_or_default(
      element.getAttribute("data-node-index").unwrap_or("-1"),
      -1,
    )
    if node_index < 0 {
      continue
    }
    match find_node(app_state.root, node_index) {
      Some(node) => {
        let span = contour_subtree_span(node)
        let style = @dom.css_style_from_val(
          element.as_any()._get("style").cast(),
        )
        style.set_property("min-height", "\{span}px")
      }
      None => ()
    }
  }
}

///|
fn apply_mindmap_root_packing(stage : @dom.Element) -> Unit {
  let zoom = match get_element("#mindmap") {
    Some(mindmap) =>
      parse_float(mindmap.getAttribute("data-zoom").unwrap_or("1"))
    None => 1.0
  }
  let safe_zoom = if zoom.is_nan() || zoom <= 0.0 { 1.0 } else { zoom }
  apply_root_column_packing(
    stage.querySelector(".branch-column--left"),
    16,
    safe_zoom,
  )
  apply_root_column_packing(
    stage.querySelector(".branch-column--right"),
    16,
    safe_zoom,
  )
}

///|
fn apply_mindmap_single_child_alignment(stage : @dom.Element) -> Unit {
  align_single_child_chain(stage, app_state.root)
}

///|
fn align_single_child_chain(stage : @dom.Element, node : OutlineNode) -> Unit {
  if !should_render_children(node) {
    return
  }
  let chain_length = single_child_chain_length(node)
  if chain_length > 1 {
    let child = node.children[0]
    match find_stage_card(stage, node.flat_index) {
      Some(parent_card) =>
        match find_stage_branch(stage, child.flat_index) {
          Some(child_branch) =>
            match find_stage_card(stage, child.flat_index) {
              Some(child_card) => {
                let parent_center_y = rect_center_y(element_rect(parent_card))
                let child_center_y = rect_center_y(element_rect(child_card))
                let delta = parent_center_y - child_center_y
                if abs_double(delta) >= 0.5 {
                  let style = @dom.css_style_from_val(
                    child_branch.as_any()._get("style").cast(),
                  )
                  style.set_property("transform", "translateY(\{delta}px)")
                }
              }
              None => ()
            }
          None => ()
        }
      None => ()
    }
  }
  for child in node.children {
    align_single_child_chain(stage, child)
  }
}

///|
fn find_stage_card(stage : @dom.Element, node_index : Int) -> @dom.Element? {
  stage.querySelector(".node[data-node-index=\"\{node_index}\"]")
}

///|
fn find_stage_branch(stage : @dom.Element, node_index : Int) -> @dom.Element? {
  stage.querySelector(".branch-item[data-node-index=\"\{node_index}\"]")
}

///|
fn apply_root_column_packing(
  column : @dom.Element?,
  gap : Int,
  safe_zoom : Double,
) -> Unit {
  match column {
    Some(root_column) => {
      let branches = root_column.querySelectorAll(".branch-item--root")
      if branches.length() == 0 {
        return
      }
      let card_heights = []
      let branch_top_radii = []
      let branch_bottom_radii = []
      for branch in branches {
        let (card_height, fallback_top_radius, fallback_bottom_radius, card) = match
          root_branch_head_card(branch) {
          Some(card) => {
            let card_rect = element_rect(card)
            let card_height = unscaled_length_to_int(
              card_rect.height,
              safe_zoom,
            )
            (
              card_height,
              if card_height > 1 {
                card_height / 2
              } else {
                1
              },
              if card_height > 1 {
                card_height / 2
              } else {
                1
              },
              card,
            )
          }
          None => {
            let branch_rect = element_rect(branch)
            let branch_height = unscaled_length_to_int(
              branch_rect.height,
              safe_zoom,
            )
            (branch_height, branch_height / 2, branch_height / 2, branch)
          }
        }
        let safe_card_height = if card_height > 1 { card_height } else { 1 }
        card_heights.push(safe_card_height)
        let (top_radius, bottom_radius) = root_branch_dom_radii(
          branch, card, fallback_top_radius, fallback_bottom_radius, safe_zoom,
        )
        branch_top_radii.push(top_radius)
        branch_bottom_radii.push(bottom_radius)
      }
      let available = root_column.clientHeight()
      let starts = contour_anchor_pack_positions(
        card_heights,
        available / 2,
        available,
        gap,
      )
      let positions = root_branch_centers_from_starts(starts, card_heights)
      let adjusted = root_branch_collision_adjusted_centers(
        positions,
        branch_top_radii,
        branch_bottom_radii,
        available / 2,
        gap,
      )
      for index in 0..<branches.length() {
        let branch = branches[index]
        let style = @dom.css_style_from_val(
          branch.as_any()._get("style").cast(),
        )
        let top = root_branch_top_for_card_center(
          branch,
          adjusted[index],
          safe_zoom,
        )
        style.set_property("top", "\{top}px")
      }
    }
    None => ()
  }
}

///|
fn unscaled_length_to_int(value : Double, safe_zoom : Double) -> Int {
  let unscaled = value / safe_zoom
  if unscaled < 1.0 {
    1
  } else {
    unscaled.round().to_int()
  }
}

///|
fn root_branch_head_card(branch : @dom.Element) -> @dom.Element? {
  for child in branch.children() {
    if has_class_name(child, "single-right-tree__head") {
      match child.querySelector(".node[data-node-index]") {
        Some(card) => return Some(card)
        None => ()
      }
    }
  }
  branch.querySelector(".node[data-node-index]")
}

///|
fn root_branch_dom_radii(
  branch : @dom.Element,
  card : @dom.Element,
  fallback_top_radius : Int,
  fallback_bottom_radius : Int,
  safe_zoom : Double,
) -> (Int, Int) {
  let card_center = rect_center_y(element_rect(card))
  let mut top_radius = fallback_top_radius
  let mut bottom_radius = fallback_bottom_radius
  for node_card in branch.querySelectorAll(".node[data-node-index]") {
    let rect = element_rect(node_card)
    let top = unscaled_length_to_int(card_center - rect.top, safe_zoom)
    let bottom = unscaled_length_to_int(rect.bottom - card_center, safe_zoom)
    if top > top_radius {
      top_radius = top
    }
    if bottom > bottom_radius {
      bottom_radius = bottom
    }
  }
  (top_radius, bottom_radius)
}

///|
fn root_branch_top_for_card_center(
  branch : @dom.Element,
  target_center : Int,
  safe_zoom : Double,
) -> Int {
  match root_branch_head_card(branch) {
    Some(card) => {
      let branch_rect = element_rect(branch)
      let card_rect = element_rect(card)
      let card_center_offset = (rect_center_y(card_rect) - branch_rect.top) /
        safe_zoom
      (target_center.to_double() - card_center_offset).round().to_int()
    }
    None => target_center
  }
}

///|
fn root_branch_centers_from_starts(
  starts : Array[Int],
  heights : Array[Int],
) -> Array[Int] {
  let centers = []
  for index in 0..<starts.length() {
    centers.push(starts[index] + heights[index] / 2)
  }
  centers
}

///|
fn root_branch_collision_adjusted_centers(
  centers : Array[Int],
  top_radii : Array[Int],
  bottom_radii : Array[Int],
  anchor_center : Int,
  gap : Int,
) -> Array[Int] {
  let adjusted = []
  if centers.length() == 0 {
    return adjusted
  }
  adjusted.push(centers[0])
  for index in 1..<centers.length() {
    let previous = adjusted[index - 1]
    let min_center = previous + bottom_radii[index - 1] + top_radii[index] + gap
    adjusted.push(
      if centers[index] < min_center {
        min_center
      } else {
        centers[index]
      },
    )
  }
  let first_top = adjusted[0] - top_radii[0]
  let last_index = adjusted.length() - 1
  let last_bottom = adjusted[last_index] + bottom_radii[last_index]
  let shift = anchor_center - (first_top + last_bottom) / 2
  if shift == 0 {
    adjusted
  } else {
    let shifted = []
    for center in adjusted {
      shifted.push(center + shift)
    }
    shifted
  }
}

///|
fn reveal_input_line_after_paint(target_top : Int) -> Unit {
  let window = @dom.window()
  let input = match get_element("#input") {
    Some(input_element) =>
      @dom.HTMLTextAreaElement::cast_from_element(input_element)
    None => return
  }
  ignore(
    window.requestAnimationFrame(fn(_) {
      ignore(
        window.requestAnimationFrame(fn(_) {
          input.setScrollTop(target_top)
          sync_editor_chrome()
        }),
      )
    }),
  )
}

///|
priv struct InputLineMetrics {
  heights : Array[Int]
  tops : Array[Int]
  line_height : Int
  padding_top : Int
}

///|
priv struct GutterVisualRow {
  line_number : Int
  height : Int
  show_number : Bool
}

///|
priv struct LineLayerBounds {
  top : Int
  height : Int
}

///|
fn parse_double_or_default(raw : String, fallback : Double) -> Double {
  if raw.length() == 0 {
    fallback
  } else {
    @strconv.parse_double(raw.view()) catch {
      _ => fallback
    }
  }
}

///|
fn parse_int_or_default(raw : String, fallback : Int) -> Int {
  parse_double_or_default(raw, fallback.to_double()).round().to_int()
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
fn text_area_scroll_height(input : @dom.HTMLTextAreaElement) -> Int {
  parse_int_or_default(input.as_any()._get("scrollHeight").to_string(), 0)
}

///|
fn resolve_input_line_height(style : @dom.CSSStyleDeclaration) -> Int {
  let font_size = parse_css_pixels(style, "font-size", 16.0)
  let line_height = parse_css_pixels(style, "line-height", font_size * 1.75)
  if line_height <= 0.0 {
    (font_size * 1.75).round().to_int()
  } else {
    line_height.round().to_int()
  }
}

///|
fn resolved_metric_line_height(metrics : InputLineMetrics) -> Int {
  if metrics.line_height > 0 {
    metrics.line_height
  } else {
    1
  }
}

///|
fn metric_line_top(metrics : InputLineMetrics, line_index : Int) -> Int {
  metrics.tops.get(line_index).unwrap_or(metrics.padding_top)
}

///|
fn metric_line_height(metrics : InputLineMetrics, line_index : Int) -> Int {
  let default_height = resolved_metric_line_height(metrics)
  let height = metrics.heights.get(line_index).unwrap_or(default_height)
  if height > 1 {
    height
  } else {
    default_height
  }
}

///|
fn measure_mirror_line_heights(
  block_height : Int,
  line_height : Int,
) -> Array[Int] {
  let resolved_line_height = if line_height > 0 { line_height } else { 1 }
  let resolved_block_height = if block_height > 1 {
    block_height
  } else {
    resolved_line_height
  }
  let visual_line_count = max_int(
    1,
    (resolved_block_height + resolved_line_height - 1) / resolved_line_height,
  )
  let heights : Array[Int] = []
  for visual_index in 0..<visual_line_count {
    let visual_height = if visual_index == visual_line_count - 1 {
      let remainder = resolved_block_height -
        resolved_line_height * (visual_line_count - 1)
      if remainder > 0 {
        remainder
      } else {
        resolved_line_height
      }
    } else {
      resolved_line_height
    }
    heights.push(visual_height)
  }
  heights
}

///|
fn gutter_visual_rows(metrics : InputLineMetrics) -> Array[GutterVisualRow] {
  let rows : Array[GutterVisualRow] = []
  let heights = if metrics.heights.length() > 0 {
    metrics.heights
  } else {
    [resolved_metric_line_height(metrics)]
  }
  let mut line_number = 1
  for height in heights {
    for
      visual_index, visual_height in measure_mirror_line_heights(
        height,
        metrics.line_height,
      ) {
      rows.push(GutterVisualRow::{
        line_number,
        height: visual_height,
        show_number: visual_index == 0,
      })
    }
    line_number += 1
  }
  rows
}

///|
fn line_layer_bounds(
  metrics : InputLineMetrics,
  line_index : Int,
  scroll_top : Int,
) -> LineLayerBounds? {
  if line_index < 0 || line_index >= metrics.heights.length() {
    None
  } else {
    Some(LineLayerBounds::{
      top: metric_line_top(metrics, line_index) - scroll_top,
      height: metric_line_height(metrics, line_index),
    })
  }
}

///|
fn line_span_bounds(
  metrics : InputLineMetrics,
  start_line_index : Int,
  end_line_index : Int,
  scroll_top : Int,
) -> LineLayerBounds? {
  if start_line_index < 0 ||
    end_line_index < start_line_index ||
    end_line_index >= metrics.heights.length() {
    None
  } else {
    let start_top = metric_line_top(metrics, start_line_index) - scroll_top
    let end_bottom = metric_line_top(metrics, end_line_index) +
      metric_line_height(metrics, end_line_index) -
      scroll_top
    let height = end_bottom - start_top
    Some(LineLayerBounds::{
      top: start_top,
      height: if height > 1 {
        height
      } else {
        1
      },
    })
  }
}

///|
fn sync_input_measure_mirror_style(
  mirror_element : @dom.Element,
  input_style : @dom.CSSStyleDeclaration,
  mirror_width : Int,
  padding_top : Int,
  padding_right : Int,
  padding_bottom : Int,
  padding_left : Int,
) -> Unit {
  let mirror_style = style_of(mirror_element)
  mirror_style.set_property(
    "box-sizing",
    input_style.get_property_value("box-sizing"),
  )
  mirror_style.set_property("position", "absolute")
  mirror_style.set_property("top", "0")
  mirror_style.set_property("left", "0")
  mirror_style.set_property("width", "\{max_int(1, mirror_width)}px")
  mirror_style.set_property("height", "0")
  mirror_style.set_property("min-height", "0")
  mirror_style.set_property(
    "padding",
    "\{padding_top}px \{padding_right}px \{padding_bottom}px \{padding_left}px",
  )
  mirror_style.set_property(
    "border-top-width",
    input_style.get_property_value("border-top-width"),
  )
  mirror_style.set_property(
    "border-right-width",
    input_style.get_property_value("border-right-width"),
  )
  mirror_style.set_property(
    "border-bottom-width",
    input_style.get_property_value("border-bottom-width"),
  )
  mirror_style.set_property(
    "border-left-width",
    input_style.get_property_value("border-left-width"),
  )
  mirror_style.set_property("border-style", "solid")
  mirror_style.set_property("border-color", "transparent")
  mirror_style.set_property("margin", "0")
  mirror_style.set_property("font", input_style.get_property_value("font"))
  mirror_style.set_property(
    "line-height",
    input_style.get_property_value("line-height"),
  )
  mirror_style.set_property(
    "letter-spacing",
    input_style.get_property_value("letter-spacing"),
  )
  mirror_style.set_property(
    "tab-size",
    if input_style.get_property_value("tab-size").length() > 0 {
      input_style.get_property_value("tab-size")
    } else {
      "2"
    },
  )
  mirror_style.set_property("white-space", "pre-wrap")
  mirror_style.set_property("word-break", "normal")
  mirror_style.set_property("overflow-wrap", "break-word")
  mirror_style.set_property("word-wrap", "break-word")
  mirror_style.set_property("overflow", "hidden")
  mirror_style.set_property("overflow-x", "hidden")
  mirror_style.set_property("overflow-y", "hidden")
  mirror_style.set_property("resize", "none")
  mirror_style.set_property("color", input_style.get_property_value("color"))
  mirror_style.set_property(
    "text-align",
    input_style.get_property_value("text-align"),
  )
  mirror_style.set_property(
    "direction",
    input_style.get_property_value("direction"),
  )
}

///|
fn input_line_metrics(input : @dom.HTMLTextAreaElement) -> InputLineMetrics {
  let raw = measure_input_line_metrics_raw(input)
  let parts = raw.split("|".view()).to_array()
  if parts.length() != 4 {
    return input_line_metrics_fallback(input)
  }
  let heights = parse_int_list(parts[0])
  let tops = parse_int_list(parts[1])
  let line_height = parse_int_or_default(parts[2].to_string(), 28)
  let padding_top = parse_int_or_default(parts[3].to_string(), 18)
  InputLineMetrics::{
    heights: if heights.length() > 0 {
      heights
    } else {
      [line_height]
    },
    tops: if tops.length() > 0 {
      tops
    } else {
      [padding_top]
    },
    line_height,
    padding_top,
  }
}

///|
fn input_line_metrics_fallback(
  input : @dom.HTMLTextAreaElement,
) -> InputLineMetrics {
  let style = @dom.css_style_from_val(
    @dom.window().getComputedStyle(input.as_element()),
  )
  let line_height = resolve_input_line_height(style)
  let padding_top = parse_css_pixels(style, "padding-top", 0.0).round().to_int()
  InputLineMetrics::{
    heights: [line_height],
    tops: [padding_top],
    line_height,
    padding_top,
  }
}

///|
fn parse_int_list(raw : StringView) -> Array[Int] {
  let values : Array[Int] = []
  if raw.length() == 0 {
    return values
  }
  for item in raw.split(",".view()) {
    let trimmed = item.trim()
    if trimmed.is_empty() {
      continue
    }
    let parsed = @strconv.parse_int(trimmed) catch { _ => -1 }
    if parsed >= 0 {
      values.push(parsed)
    }
  }
  values
}

///|
fn serialize_int_list(values : Array[Int]) -> String {
  let parts : Array[String] = []
  for value in values {
    parts.push(value.to_string())
  }
  parts.join(",")
}

///|
fn measure_input_line_metrics_raw(input : @dom.HTMLTextAreaElement) -> String {
  let style = @dom.css_style_from_val(
    @dom.window().getComputedStyle(input.as_element()),
  )
  let resolved_line_height = resolve_input_line_height(style)
  let padding_top = parse_css_pixels(style, "padding-top", 0.0).round().to_int()
  let mirror_element = match get_element("#input-measure-mirror") {
    Some(mirror) => mirror
    None => return ""
  }
  let mirror = to_text_area(mirror_element)
  let fallback_width = parse_int_or_default(
    input.as_any()._get("clientWidth").to_string(),
    0,
  )
  let padding_left = parse_css_pixels(style, "padding-left", 0.0)
    .round()
    .to_int()
  let padding_right = parse_css_pixels(style, "padding-right", 0.0)
    .round()
    .to_int()
  let padding_bottom = parse_css_pixels(style, "padding-bottom", 0.0)
    .round()
    .to_int()
  let mirror_width = fallback_width
  sync_input_measure_mirror_style(
    mirror_element, style, mirror_width, padding_top, padding_right, padding_bottom,
    padding_left,
  )
  let lines = input.value.split("\n".view())
  let heights : Array[Int] = []
  let tops : Array[Int] = []
  let vertical_padding = padding_top + padding_bottom
  let mut current_top = padding_top
  for line in lines {
    let raw_line = line.to_string()
    mirror.value = if raw_line.length() > 0 { raw_line } else { " " }
    let total_height = text_area_scroll_height(mirror)
    let height = if total_height > vertical_padding {
      total_height - vertical_padding
    } else {
      resolved_line_height
    }
    tops.push(current_top)
    heights.push(height)
    current_top += height
  }
  mirror.value = ""
  "\{serialize_int_list(heights)}|\{serialize_int_list(tops)}|\{resolved_line_height}|\{padding_top}"
}

///|
fn build_linked_line_dom(
  metrics : InputLineMetrics,
  line_index : Int,
  scroll_top : Int,
  class_name : String,
) -> @dom.Element? {
  match line_layer_bounds(metrics, line_index, scroll_top) {
    Some(bounds) => {
      let block = create_element("div", class_name)
      let style = @dom.css_style_from_val(block.as_any()._get("style").cast())
      style.set_property("height", "\{bounds.height}px")
      style.set_property("transform", "translateY(\{bounds.top}px)")
      style.set_property("opacity", "1")
      Some(block)
    }
    None => None
  }
}

///|
fn build_gutter_number_dom(
  line_number : Int,
  height : Int,
  show_number : Bool,
) -> @dom.Element {
  let block = create_element("div", "editor-gutter-number")
  let block_height = if height > 1 { height } else { 1 }
  let style = @dom.css_style_from_val(block.as_any()._get("style").cast())
  style.set_property("height", "\{block_height}px")
  block.setTextContent(if show_number { line_number.to_string() } else { "" })
  block
}

///|
fn input_scroll_top(input : @dom.HTMLTextAreaElement) -> Int {
  input.scrollTop()
}

///|
fn input_selection_start(input : @dom.HTMLTextAreaElement) -> Int {
  parse_int_or_default(input.as_any()._get("selectionStart").to_string(), 0)
}

///|
fn input_selection_end(input : @dom.HTMLTextAreaElement) -> Int {
  parse_int_or_default(
    input.as_any()._get("selectionEnd").to_string(),
    input_selection_start(input),
  )
}

///|
fn input_active_element_is_input(input : @dom.HTMLTextAreaElement) -> Bool {
  @dom.document().activeElement().isSameNode(Some(input.as_element().as_node()))
}

///|
fn set_line_layer(
  element : @dom.Element,
  line_index : Int,
  visible : Bool,
  metrics : InputLineMetrics,
  scroll_top : Int,
) -> Unit {
  let style = @dom.css_style_from_val(element.as_any()._get("style").cast())
  if !visible {
    style.set_property("opacity", "0")
    return
  }
  match line_layer_bounds(metrics, line_index, scroll_top) {
    Some(bounds) => {
      style.set_property("height", "\{bounds.height}px")
      style.set_property("transform", "translateY(\{bounds.top}px)")
      style.set_property("opacity", "1")
    }
    None => style.set_property("opacity", "0")
  }
}

///|
fn set_line_span_layer(
  element : @dom.Element,
  start_line_index : Int,
  end_line_index : Int,
  visible : Bool,
  metrics : InputLineMetrics,
  scroll_top : Int,
) -> Unit {
  let style = @dom.css_style_from_val(element.as_any()._get("style").cast())
  if !visible {
    style.set_property("opacity", "0")
    return
  }
  match
    line_span_bounds(metrics, start_line_index, end_line_index, scroll_top) {
    Some(bounds) => {
      style.set_property("height", "\{bounds.height}px")
      style.set_property("transform", "translateY(\{bounds.top}px)")
      style.set_property("opacity", "1")
    }
    None => style.set_property("opacity", "0")
  }
}

///|
fn set_line_collection(
  container : @dom.Element,
  line_indexes : Array[Int],
  class_name : String,
  metrics : InputLineMetrics,
  scroll_top : Int,
) -> Unit {
  clear_element(container)
  if line_indexes.length() == 0 {
    return
  }
  for line_index in line_indexes {
    match build_linked_line_dom(metrics, line_index, scroll_top, class_name) {
      Some(block) => append_child(container, block)
      None => ()
    }
  }
}

///|
fn sync_input_line_numbers(
  input : @dom.HTMLTextAreaElement,
  metrics : InputLineMetrics,
) -> Unit {
  match get_element("#input-gutter") {
    Some(gutter) => {
      clear_element(gutter)
      for row in gutter_visual_rows(metrics) {
        append_child(
          gutter,
          build_gutter_number_dom(row.line_number, row.height, row.show_number),
        )
      }
      let style = @dom.css_style_from_val(gutter.as_any()._get("style").cast())
      style.set_property(
        "transform",
        "translateY(\{-input_scroll_top(input)}px)",
      )
    }
    None => ()
  }
}

///|
fn sync_input_linked_lines(
  _input : @dom.HTMLTextAreaElement,
  metrics : InputLineMetrics,
  scroll_top : Int,
) -> Unit {
  match get_element("#input-linked-lines") {
    Some(linked_lines) =>
      set_line_collection(
        linked_lines,
        input_linked_line_indexes.val,
        "editor-linked-line",
        metrics,
        scroll_top,
      )
    None => ()
  }
  match get_element("#input-linked-gutter-lines") {
    Some(linked_gutter_lines) =>
      set_line_collection(
        linked_gutter_lines,
        input_linked_line_indexes.val,
        "editor-gutter-line editor-gutter-line--linked",
        metrics,
        scroll_top,
      )
    None => ()
  }
}

///|
fn sync_input_hover_line(
  _input : @dom.HTMLTextAreaElement,
  metrics : InputLineMetrics,
  scroll_top : Int,
) -> Unit {
  let line_index = input_hover_line_index.val
  let visible = should_show_input_hover_line(
    line_index,
    input_active_element_is_input(_input),
  )
  match get_element("#input-hover-line") {
    Some(hover_line) =>
      set_line_layer(hover_line, line_index, visible, metrics, scroll_top)
    None => ()
  }
  match get_element("#input-hover-gutter-line") {
    Some(hover_gutter_line) =>
      set_line_layer(
        hover_gutter_line, line_index, visible, metrics, scroll_top,
      )
    None => ()
  }
}

///|
fn should_show_input_hover_line(line_index : Int, is_active : Bool) -> Bool {
  line_index >= 0 && is_active
}

///|
fn sync_input_active_line(
  input : @dom.HTMLTextAreaElement,
  metrics : InputLineMetrics,
  scroll_top : Int,
) -> Unit {
  let selection_start = input_selection_start(input)
  let selection_end = input_selection_end(input)
  let start_line = line_index_at_offset(
    input.value,
    if selection_start < selection_end {
      selection_start
    } else {
      selection_end
    },
  )
  let end_line = line_index_at_offset(
    input.value,
    if selection_start > selection_end {
      selection_start
    } else {
      selection_end
    },
  )
  let visible = input_active_element_is_input(input)
  match get_element("#input-active-line") {
    Some(active_line) =>
      set_line_span_layer(
        active_line, start_line, end_line, visible, metrics, scroll_top,
      )
    None => ()
  }
  match get_element("#input-active-gutter-line") {
    Some(active_gutter_line) =>
      set_line_span_layer(
        active_gutter_line, start_line, end_line, visible, metrics, scroll_top,
      )
    None => ()
  }
}

///|
fn line_index_at_offset(value : String, offset : Int) -> Int {
  let limit = if offset < 0 {
    0
  } else if offset > value.length() {
    value.length()
  } else {
    offset
  }
  let mut line = 0
  for index in 0..<limit {
    if value[index] == '\n' {
      line += 1
    }
  }
  line
}

///|
fn parse_selection_indices(serialized : String) -> Array[Int] {
  if serialized.length() == 0 {
    return []
  }
  let values : Array[Int] = []
  for item in serialized.split(",".view()) {
    let trimmed = item.trim()
    if trimmed.is_empty() {
      continue
    }
    let parsed = @strconv.parse_int(trimmed) catch { _ => -1 }
    if parsed >= 0 && !values.contains(parsed) {
      values.push(parsed)
    }
  }
  values
}

///|
fn current_heading_selection(input : @dom.HTMLTextAreaElement) -> Array[Int] {
  let selection_start = input_selection_start(input)
  let selection_end = input_selection_end(input)
  let range_start = if selection_start < selection_end {
    selection_start
  } else {
    selection_end
  }
  let range_end = if selection_start > selection_end {
    selection_start
  } else {
    selection_end
  }
  let start_line = line_index_at_offset(input.value, range_start)
  let end_line = line_index_at_offset(input.value, range_end)
  let lines = input.value.split("\n".view()).to_array()
  let structural_line_indexes : Array[(Int, Int)] = []
  let mut node_index = 0
  for line_index in 0..<lines.length() {
    let line = lines[line_index]
    if line.has_prefix("#".view()) ||
      line.has_prefix("-".view()) ||
      line.has_prefix("+".view()) ||
      line.has_prefix("*".view()) {
      if line.contains(" ".view()) {
        structural_line_indexes.push((line_index, node_index))
        node_index += 1
      }
    }
  }
  if range_start == range_end {
    for pair in structural_line_indexes {
      if pair.0 == start_line {
        return [pair.1]
      }
    }
    return []
  }
  for line_index in start_line..<=end_line {
    let mut structural = false
    for pair in structural_line_indexes {
      if pair.0 == line_index {
        structural = true
        break
      }
    }
    if !structural {
      return []
    }
  }
  let result : Array[Int] = []
  for pair in structural_line_indexes {
    if pair.0 >= start_line && pair.0 <= end_line {
      result.push(pair.1)
    }
  }
  result
}

///|
fn set_input_linked_lines(line_indexes : String) -> Unit {
  match get_element("#input") {
    Some(_) => {
      input_linked_line_indexes.val = parse_selection_indices(line_indexes)
      sync_editor_chrome()
    }
    None => ()
  }
}

///|
fn reveal_input_line(line_index : Int) -> Unit {
  if line_index < 0 {
    return
  }
  match get_element("#input") {
    Some(input_element) => {
      let input = @dom.HTMLTextAreaElement::cast_from_element(input_element)
      let metrics = input_line_metrics(input)
      if line_index >= metrics.heights.length() {
        return
      }
      let line_top = metric_line_top(metrics, line_index)
      let line_height = metric_line_height(metrics, line_index)
      let viewport_top = input.scrollTop()
      let viewport_bottom = viewport_top + input.clientHeight()
      let top_margin = line_height * 2
      let bottom_margin = line_height * 3
      let visible_top = viewport_top + top_margin
      let visible_bottom = viewport_bottom - bottom_margin
      let target_top = if line_top < visible_top {
        line_top - top_margin
      } else if line_top + line_height > visible_bottom {
        line_top + line_height - input.clientHeight() + bottom_margin
      } else {
        viewport_top
      }
      let next_top = if target_top > 0 { target_top } else { 0 }
      reveal_input_line_after_paint(next_top)
    }
    None => ()
  }
}

///|
fn toggle_class(
  element : @dom.Element,
  class_name : String,
  enabled : Bool,
) -> Unit {
  let tokens : Array[String] = element
    .className()
    .split(" ")
    .map(token => token.to_string())
    .filter(token => token.length() > 0 && token != class_name)
    .to_array()
  let next = if enabled {
    if tokens.length() == 0 {
      class_name
    } else {
      tokens.push(class_name)
      tokens.iter().join(" ")
    }
  } else {
    tokens.iter().join(" ")
  }
  element.setClassName(next)
  apply_theme_to_element(element)
}

///|
fn has_class_name(element : @dom.Element, class_name : String) -> Bool {
  let tokens : Array[String] = element
    .className()
    .split(" ")
    .map(token => token.to_string())
    .filter(token => token.length() > 0)
    .to_array()
  tokens.contains(class_name)
}

///|
fn set_body_drag_style(cursor : String, user_select : String) -> Unit {
  match @dom.window().document().body() {
    Some(body) => {
      let style = @dom.css_style_from_val(body.as_any()._get("style").cast())
      style.set_property("cursor", cursor)
      style.set_property("user-select", user_select)
    }
    None => ()
  }
}

///|
fn clear_body_drag_style() -> Unit {
  match @dom.window().document().body() {
    Some(body) => {
      let style = @dom.css_style_from_val(body.as_any()._get("style").cast())
      ignore(style.remove_property("cursor"))
      ignore(style.remove_property("user-select"))
    }
    None => ()
  }
}

///|
fn close_custom_selects(except : @dom.Element?) -> Unit {
  for custom in @dom.document().querySelectorAll(".tool-select-custom") {
    match except {
      Some(except_element) =>
        if custom.isSameNode(Some(except_element.as_node())) {
          continue
        }
      None => ()
    }
    toggle_class(custom, "is-open", false)
    match custom.querySelector(".tool-select-trigger") {
      Some(trigger) => trigger.setAttribute("aria-expanded", "false")
      None => ()
    }
  }
}

///|
fn is_select_disabled(select : @dom.HTMLSelectElement) -> Bool {
  has_class_name(select.as_element(), "tool-select--disabled") ||
  select.getAttribute("data-disabled").unwrap_or("") == "true"
}

///|
fn sync_custom_select(select : @dom.HTMLSelectElement) -> Unit {
  match select.parentElement() {
    Some(parent) =>
      match parent.querySelector(".tool-select-custom") {
        Some(custom) => {
          let mut fallback_text = ""
          let mut selected_text = ""
          let current_value = select.value
          for child in select.children() {
            let option = @dom.HTMLOptionElement::cast_from_element(child)
            if option.hasAttribute("hidden") {
              continue
            }
            let option_text = option.textContent()
            if fallback_text == "" {
              fallback_text = option_text
            }
            if option.value == current_value {
              selected_text = option_text
              break
            }
          }
          let next_text = if selected_text == "" {
            fallback_text
          } else {
            selected_text
          }
          sync_custom_select_trigger(custom, select, next_text)
          for option_button in custom.querySelectorAll(".tool-select-option") {
            let option_value = option_button
              .getAttribute("data-value")
              .unwrap_or("")
            toggle_class(
              option_button,
              "tool-select-option--selected",
              option_value == current_value,
            )
          }
          apply_tool_select_custom_theme(
            custom,
            has_class_name(select.as_element(), "tool-select--muted"),
          )
        }
        None => ()
      }
    None => ()
  }
}

///|
fn sync_custom_select_trigger(
  custom : @dom.Element,
  select : @dom.HTMLSelectElement,
  next_text : String,
) -> Unit {
  match custom.querySelector(".tool-select-trigger") {
    Some(trigger) => {
      let is_insert = has_class_name(select.as_element(), "tool-select--insert")
      match trigger.querySelector(".tool-select-trigger__label") {
        Some(label) =>
          if is_insert {
            label.setTextContent("")
          } else {
            label.setTextContent(next_text)
          }
        None => if !is_insert { trigger.setTextContent(next_text) }
      }
      toggle_class(
        trigger,
        "tool-select--muted",
        has_class_name(select.as_element(), "tool-select--muted"),
      )
      let prefix = if is_insert {
        "插入"
      } else {
        match select.parentElement() {
          Some(parent) =>
            match parent.querySelector(".tool-select-label") {
              Some(label) => label.textContent()
              None => ""
            }
          None => ""
        }
      }
      let disabled = is_select_disabled(select)
      toggle_class(trigger, "tool-select--disabled", disabled)
      toggle_class(custom, "tool-select-custom--disabled", disabled)
      trigger.setAttribute("data-disabled", disabled.to_string())
      trigger.setAttribute("aria-disabled", disabled.to_string())
      trigger.setAttribute("tabindex", if disabled { "-1" } else { "0" })
      custom.setAttribute("data-disabled", disabled.to_string())
      custom.setAttribute("aria-disabled", disabled.to_string())
      if disabled {
        toggle_class(custom, "is-open", false)
        trigger.setAttribute("aria-expanded", "false")
      }
      let insert_prefix = if is_insert { "插入" } else { prefix }
      let tip = if is_insert {
        insert_prefix
      } else if prefix.length() == 0 {
        next_text
      } else if next_text.length() == 0 {
        prefix
      } else {
        "\{prefix}：\{next_text}"
      }
      trigger.setAttribute("data-tip", tip)
      trigger.setAttribute("aria-label", tip)
    }
    None => ()
  }
}

///|
fn auto_close_custom_select_on_leave(id : String) -> Bool {
  id == "layout-select" ||
  id == "style-select" ||
  id == "detail-select" ||
  id == "export-select" ||
  id == "insert-select" ||
  id == "sample-select"
}

///|
fn init_custom_select(id : String) -> Unit {
  match get_element_by_id(id) {
    Some(control) => {
      let select = @dom.HTMLSelectElement::cast_from_element(control)
      if select.getAttribute("data-custom-select-ready").unwrap_or("") == "true" {
        return
      }
      select.setAttribute("data-custom-select-ready", "true")
      toggle_class(select.as_element(), "tool-select--native", true)
      let custom = create_element("div", "tool-select-custom")
      if id == "insert-select" {
        toggle_class(custom, "tool-select-custom--insert", true)
      }
      let trigger = create_element("button", "tool-select-trigger")
      trigger.setAttribute("type", "button")
      trigger.setAttribute("aria-haspopup", "listbox")
      trigger.setAttribute("aria-expanded", "false")
      if id == "insert-select" {
        trigger.setAttribute("aria-label", "插入")
      }
      if id == "insert-select" {
        append_child(trigger, build_tool_icon("insert", true))
      }
      let trigger_label = create_element("span", "tool-select-trigger__label")
      let trigger_arrow = create_element("span", "tool-select-trigger__arrow")
      trigger_arrow.setTextContent("▾")
      trigger.as_node().appendChild(trigger_label.as_node()) |> ignore
      trigger.as_node().appendChild(trigger_arrow.as_node()) |> ignore
      let menu = create_element("div", "tool-select-menu")
      menu.setAttribute("role", "listbox")
      for child in select.children() {
        let option = @dom.HTMLOptionElement::cast_from_element(child)
        if option.hasAttribute("hidden") {
          continue
        }
        let option_value = option.value
        let option_text = option.textContent()
        let option_button = create_element("button", "tool-select-option")
        option_button.setAttribute("type", "button")
        option_button.setAttribute("data-value", option_value)
        option_button.setTextContent(option_text)
        option_button
        .as_event_target()
        .addEventListener("click", fn(raw) {
          let event : @dom.MouseEvent = raw.cast()
          event.preventDefault()
          if is_select_disabled(select) {
            return
          }
          select.value = option_value
          sync_custom_select(select)
          toggle_class(custom, "is-open", false)
          trigger.setAttribute("aria-expanded", "false")
          let change_event = @event.Event::new("change", bubbles=true)
          ignore(select.as_event_target().dispatchEvent(change_event))
        })
        menu.as_node().appendChild(option_button.as_node()) |> ignore
      }
      trigger
      .as_event_target()
      .addEventListener("click", fn(raw) {
        let event : @dom.MouseEvent = raw.cast()
        event.preventDefault()
        if is_select_disabled(select) {
          return
        }
        let next_open = !has_class_name(custom, "is-open")
        close_custom_selects(Some(custom))
        toggle_class(custom, "is-open", next_open)
        if has_class_name(select.as_element(), "tool-select--insert") {
          trigger.setAttribute(
            "data-tip",
            if next_open {
              ""
            } else {
              "插入"
            },
          )
        }
        trigger.setAttribute(
          "aria-expanded",
          if next_open {
            "true"
          } else {
            "false"
          },
        )
        apply_tool_select_custom_theme(
          custom,
          has_class_name(select.as_element(), "tool-select--muted"),
        )
      })
      if auto_close_custom_select_on_leave(id) {
        custom
        .as_event_target()
        .addEventListener("mouseleave", fn(_) {
          if !has_class_name(custom, "is-open") {
            return
          }
          toggle_class(custom, "is-open", false)
          trigger.setAttribute("aria-expanded", "false")
          apply_tool_select_custom_theme(
            custom,
            has_class_name(select.as_element(), "tool-select--muted"),
          )
        })
      }
      custom.as_node().appendChild(trigger.as_node()) |> ignore
      custom.as_node().appendChild(menu.as_node()) |> ignore
      select.insertAdjacentElement("afterend", custom) |> ignore
      select
      .as_event_target()
      .addEventListener("change", fn(_) { sync_custom_select(select) })
      sync_custom_select(select)
    }
    None => ()
  }
}

///|
fn sync_custom_select_by_id(id : String) -> Unit {
  match get_element_by_id(id) {
    Some(control) =>
      sync_custom_select(@dom.HTMLSelectElement::cast_from_element(control))
    None => ()
  }
}

///|
fn bind_static_ui(
  new_callback : () -> Unit,
  sample_select_callback : (String) -> Unit,
  upload_callback : () -> Unit,
  download_markdown_callback : () -> Unit,
  layout_callback : (String) -> Unit,
  style_callback : (String) -> Unit,
  detail_callback : (String) -> Unit,
  export_callback : (String) -> Unit,
  toolbar_callback : (String) -> Unit,
) -> Unit {
  match get_element("#new-document") {
    Some(button) =>
      button
      .as_event_target()
      .addEventListener("click", fn(_) { new_callback() })
    None => ()
  }
  init_custom_select("sample-select")
  match get_element_by_id("sample-select") {
    Some(select) => {
      let sample_select = @dom.HTMLSelectElement::cast_from_element(select)
      sample_select
      .as_event_target()
      .addEventListener("change", fn(_) {
        sample_select_callback(sample_select.value)
      })
    }
    None => ()
  }
  match get_element("#upload-markdown") {
    Some(button) =>
      button
      .as_event_target()
      .addEventListener("click", fn(_) { upload_callback() })
    None => ()
  }
  match get_element("#download-markdown") {
    Some(button) =>
      button
      .as_event_target()
      .addEventListener("click", fn(_) { download_markdown_callback() })
    None => ()
  }
  init_custom_select("layout-select")
  init_custom_select("style-select")
  init_custom_select("detail-select")
  init_custom_select("export-select")
  init_custom_select("insert-select")
  match get_element_by_id("layout-select") {
    Some(select) => {
      let select = @dom.HTMLSelectElement::cast_from_element(select)
      select
      .as_event_target()
      .addEventListener("change", fn(_) { layout_callback(select.value) })
    }
    None => ()
  }
  match get_element_by_id("style-select") {
    Some(select) => {
      let select = @dom.HTMLSelectElement::cast_from_element(select)
      select
      .as_event_target()
      .addEventListener("change", fn(_) { style_callback(select.value) })
    }
    None => ()
  }
  match get_element_by_id("detail-select") {
    Some(select) => {
      let select = @dom.HTMLSelectElement::cast_from_element(select)
      select
      .as_event_target()
      .addEventListener("change", fn(_) { detail_callback(select.value) })
    }
    None => ()
  }
  match get_element_by_id("export-select") {
    Some(select) => {
      let select = @dom.HTMLSelectElement::cast_from_element(select)
      select
      .as_event_target()
      .addEventListener("change", fn(_) { export_callback(select.value) })
    }
    None => ()
  }
  match get_element_by_id("insert-select") {
    Some(select) => {
      let select = @dom.HTMLSelectElement::cast_from_element(select)
      select
      .as_event_target()
      .addEventListener("change", fn(_) {
        if is_select_disabled(select) {
          select.value = ""
          sync_custom_select(select)
          return
        }
        let action = select.value
        if action == "" {
          return
        }
        select.value = ""
        sync_custom_select(select)
        toolbar_callback(action)
      })
    }
    None => ()
  }
  match get_element("#undo-action") {
    Some(button) =>
      button
      .as_event_target()
      .addEventListener("click", fn(_) {
        if button.getAttribute("data-disabled").unwrap_or("") == "true" {
          return
        }
        toolbar_callback("undo")
      })
    None => ()
  }
  match get_element("#redo-action") {
    Some(button) =>
      button
      .as_event_target()
      .addEventListener("click", fn(_) {
        if button.getAttribute("data-disabled").unwrap_or("") == "true" {
          return
        }
        toolbar_callback("redo")
      })
    None => ()
  }
  for button in @dom.document().querySelectorAll("[data-toolbar-action]") {
    let action = button.getAttribute("data-toolbar-action").unwrap_or("")
    button
    .as_event_target()
    .addEventListener("click", fn(_) {
      if button.getAttribute("data-disabled").unwrap_or("") == "true" {
        return
      }
      toolbar_callback(action)
    })
  }
  @dom.window()
  .as_event_target()
  .addEventListener("keydown", fn(raw) {
    let event : @dom.KeyboardEvent = raw.cast()
    let target = event.target()
    match target.closest("input, textarea, select") {
      Some(_) => return
      None => ()
    }
    let mut action = ""
    if event.key == "Enter" {
      action = "new-branch"
    } else if event.key == "Tab" {
      action = if event.shiftKey { "promote-node" } else { "new-child" }
    } else if event.key == "Delete" || event.key == "Backspace" {
      action = "delete-node"
    } else if event.key == " " || event.code == "Space" {
      action = "toggle-node"
    } else if event.ctrlKey && event.key == "ArrowUp" {
      action = "move-up"
    } else if event.ctrlKey && event.key == "ArrowDown" {
      action = "move-down"
    } else if event.ctrlKey &&
      !event.shiftKey &&
      (event.key == "z" || event.key == "Z") {
      action = "undo"
    } else if event.ctrlKey && (event.key == "y" || event.key == "Y") {
      action = "redo"
    }
    if action == "" {
      return
    }
    event.preventDefault()
    toolbar_callback(action)
  })
}

///|
fn parse_css_pixels(
  style : @dom.CSSStyleDeclaration,
  name : String,
  fallback : Double,
) -> Double {
  let raw = style.get_property_value(name).trim().to_string()
  let value = parse_float(raw.replace(old="px", new=""))
  if value != value {
    fallback
  } else {
    value
  }
}

///|
fn bind_splitter_ui(callback : (Int) -> Unit) -> Unit {
  match get_element("#workspace-divider") {
    Some(divider) =>
      match get_element(".workspace") {
        Some(workspace) => {
          let dragging = @ref.Ref(false)
          let last_percent = @ref.Ref(-1)
          divider
          .as_event_target()
          .addEventListener("mousedown", fn(raw) {
            let event : @dom.MouseEvent = raw.cast()
            dragging.val = true
            toggle_class(divider, "workspace-divider--dragging", true)
            toggle_class(workspace, "workspace--dragging-divider", true)
            set_body_drag_style("col-resize", "none")
            event.preventDefault()
          })
          @dom.window()
          .as_event_target()
          .addEventListener("mousemove", fn(raw) {
            let event : @dom.MouseEvent = raw.cast()
            if !dragging.val {
              return
            }
            let rect : @dom.DOMRect = workspace
              .as_any()
              ._call("getBoundingClientRect", [])
              .cast()
            if rect.width <= 0.0 {
              return
            }
            let min_left = 300.0
            let divider_width = 14.0
            let min_right = parse_css_pixels(
              @dom.css_style_from_val(@dom.window().getComputedStyle(workspace)),
              "--mindmap-toolbar-min-width",
              390.0,
            )
            let max_left = if rect.width - min_right - divider_width > min_left {
              rect.width - min_right - divider_width
            } else {
              min_left
            }
            let raw_left = event.clientX - rect.left
            let clamped_left = if raw_left < min_left {
              min_left
            } else if raw_left > max_left {
              max_left
            } else {
              raw_left
            }
            let percent = clamped_left / rect.width * 100.0
            let next_percent = percent.round().to_int()
            last_percent.val = next_percent
            callback(next_percent)
          })
          @dom.window()
          .as_event_target()
          .addEventListener("mouseup", fn(_) {
            if dragging.val && last_percent.val >= 0 {
              callback(last_percent.val)
            }
            dragging.val = false
            last_percent.val = -1
            toggle_class(divider, "workspace-divider--dragging", false)
            toggle_class(workspace, "workspace--dragging-divider", false)
            clear_body_drag_style()
          })
        }
        None => ()
      }
    None => ()
  }
}

///|
fn bind_input_listener(
  input_callback : () -> Unit,
  selected_headings_callback : (String) -> Unit,
) -> Unit {
  match get_element("#input") {
    Some(input_element) => {
      let input = @dom.HTMLTextAreaElement::cast_from_element(input_element)
      if input.getAttribute("data-input-listener-ready").unwrap_or("") == "true" {
        return
      }
      input.setAttribute("data-input-listener-ready", "true")
      let window = @dom.window()

      let schedule_sync_selected_headings = fn() {
        if input_selected_headings_frame.val != 0 {
          window.cancelAnimationFrame(input_selected_headings_frame.val)
        }
        input_selected_headings_frame.val = window.requestAnimationFrame(fn(_) {
          input_selected_headings_frame.val = 0
          let next_key = current_heading_selection(input)
            .map(fn(value) { value.to_string() })
            .iter()
            .join(",")
          if next_key != input_last_selected_headings_key.val {
            input_last_selected_headings_key.val = next_key
            selected_headings_callback(next_key)
          }
        })
      }

      let schedule_sync_editor_chrome = fn() {
        if input_selection_frame.val != 0 {
          window.cancelAnimationFrame(input_selection_frame.val)
        }
        input_selection_frame.val = window.requestAnimationFrame(fn(_) {
          input_selection_frame.val = 0
          sync_editor_chrome()
        })
      }

      let sync_selection_state = fn() {
        schedule_sync_editor_chrome()
        schedule_sync_selected_headings()
      }

      input
      .as_event_target()
      .on("input", fn(_) {
        sync_editor_chrome()
        sync_selection_state()
        input_callback()
      })
      input.as_event_target().on("scroll", fn(_) { sync_editor_chrome() })
      input
      .as_event_target()
      .on("mousemove", fn(raw) {
        let event : @dom.MouseEvent = raw.cast()
        let metrics = input_line_metrics(input)
        let pointer_y = event.offsetY.to_int() + input.scrollTop()
        let heights = if metrics.heights.length() > 0 {
          metrics.heights
        } else {
          [metrics.line_height]
        }
        let mut next_index = heights.length() - 1
        for line_index in 0..<heights.length() {
          let top = metrics.tops.get(line_index).unwrap_or(metrics.padding_top)
          let bottom = top +
            heights.get(line_index).unwrap_or(metrics.line_height)
          if pointer_y < bottom {
            next_index = line_index
            break
          }
        }
        input_hover_line_index.val = next_index
        sync_editor_chrome()
      })
      input
      .as_event_target()
      .on("mouseleave", fn(_) {
        input_hover_line_index.val = -1
        sync_editor_chrome()
      })
      input.as_event_target().on("click", fn(_) { sync_selection_state() })
      input.as_event_target().on("mouseup", fn(_) { sync_selection_state() })
      input.as_event_target().on("keyup", fn(_) { sync_selection_state() })
      input.as_event_target().on("select", fn(_) { sync_selection_state() })
      input.as_event_target().on("focus", fn(_) { sync_selection_state() })
      input
      .as_event_target()
      .on("blur", fn(_) {
        input_hover_line_index.val = -1
        sync_editor_chrome()
      })
      @dom.document()
      .as_event_target()
      .on("selectionchange", fn(_) {
        if !input_active_element_is_input(input) {
          return
        }
        sync_selection_state()
      })
      window.as_event_target().on("resize", fn(_) { sync_editor_chrome() })
      sync_editor_chrome()
      schedule_sync_selected_headings()
    }
    None => ()
  }
}

///|
fn get_input_value() -> String {
  match get_element("#input") {
    Some(input) => to_text_area(input).value
    None => ""
  }
}

///|
fn set_input_value(value : String) -> Unit {
  match get_element("#input") {
    Some(input) => to_text_area(input).value = value
    None => ()
  }
  sync_editor_chrome()
}

///|
fn set_mindmap_dom(value : @dom.Element) -> Unit {
  match get_element("#mindmap") {
    Some(mindmap) => {
      let pan_x = mindmap.getAttribute("data-pan-x").unwrap_or("0")
      let pan_y = mindmap.getAttribute("data-pan-y").unwrap_or("0")
      let zoom = mindmap.getAttribute("data-zoom").unwrap_or("1")
      mindmap.setAttribute("data-pan-x", pan_x)
      mindmap.setAttribute("data-pan-y", pan_y)
      mindmap.setAttribute("data-zoom", zoom)
      clear_element(mindmap)
      append_child(mindmap, value)
      let style = @dom.css_style_from_val(mindmap.as_any()._get("style").cast())
      style.set_property("--pan-x", "\{pan_x}px")
      style.set_property("--pan-y", "\{pan_y}px")
      style.set_property("--zoom", zoom)
      let zoom_percent = (parse_double_or_default(zoom, 1.0) * 100.0)
        .round()
        .to_int()
      match get_element("#zoom-value") {
        Some(zoom_value) => zoom_value.setTextContent("\{zoom_percent}%")
        None => ()
      }
      match get_element("#zoom-edit") {
        Some(zoom_edit) =>
          @dom.HTMLInputElement::cast_from_element(zoom_edit).value = "\{zoom_percent}%"
        None => ()
      }
    }
    None => ()
  }
  schedule_contour_layout()
}

///|
fn focus_editor(node_index : Int) -> Unit {
  let window = @dom.window()
  ignore(
    window.requestAnimationFrame(fn(_) {
      ignore(
        window.requestAnimationFrame(fn(_) {
          match get_element("[data-editor-for=\"\{node_index}\"]") {
            Some(editor) =>
              if editor.tagName() == "TEXTAREA" {
                let textarea = to_text_area(editor)
                textarea.focus()
                textarea.as_any()._call("select", []) |> ignore
              } else if editor.tagName() == "INPUT" {
                let input = @dom.HTMLInputElement::cast_from_element(editor)
                input.focus()
                input.as_any()._call("select", []) |> ignore
              }
            None => ()
          }
        }),
      )
    }),
  )
}

///|
fn focus_note_editor(node_index : Int) -> Unit {
  let window = @dom.window()
  ignore(
    window.requestAnimationFrame(fn(_) {
      ignore(
        window.requestAnimationFrame(fn(_) {
          match get_element("[data-note-editor-for=\"\{node_index}\"]") {
            Some(editor) =>
              if editor.tagName() == "TEXTAREA" {
                let textarea = to_text_area(editor)
                textarea.focus()
                textarea.as_any()._call("select", []) |> ignore
              }
            None => ()
          }
        }),
      )
    }),
  )
}

///|
fn pick_markdown_file(callback : (String, String) -> Unit) -> Unit {
  let input = create_element("input", "")
  let file_input = @dom.HTMLInputElement::cast_from_element(input)
  file_input.setType("file")
  file_input.setAttribute("accept", ".md,.markdown,text/markdown,text/plain")
  file_input.setAttribute("style", "display:none")
  match @dom.document().body() {
    Some(body) => append_child(body.as_element(), input)
    None => append_child(@dom.document().documentElement(), input)
  }
  file_input
  .as_event_target()
  .addEventListener("change", fn(_) {
    let files = @core.array_from(file_input.as_any()._get("files")).map(fn(
      value,
    ) {
      value
    })
    if files.length() == 0 {
      input.remove()
      return
    }
    let file : @file.File = @core.identity(files[0])
    ignore(
      @core.Promise::new(async fn(resolve, _reject) {
        let markdown = file.text()
        callback(file.name, markdown)
        input.remove()
        resolve(())
      }),
    )
  })
  file_input.click()
}

///|
fn download_link_from_data_url(filename : String, data_url : String) -> Unit {
  let link = create_element("a", "")
  let anchor = @dom.HTMLAnchorElement::cast_from_element(link)
  anchor.setAttribute("href", data_url)
  anchor.setAttribute("download", filename)
  match @dom.document().body() {
    Some(body) => append_child(body.as_element(), link)
    None => append_child(@dom.document().documentElement(), link)
  }
  anchor.click()
  link.remove()
}

///|
fn download_text(filename : String, content : String) -> Unit {
  download_link_from_data_url(
    filename,
    "data:text/plain;charset=utf-8,\{@global.encodeURIComponent(content)}",
  )
}

///|
fn download_current_page_html(filename : String) -> Unit {
  ignore(
    @core.Promise::new(async fn(resolve, _reject) {
      let bundle = fetch_current_bundle_text() catch { _ => "" }
      let html = build_mindmap_export_html(bundle)
      if html.length() > 0 {
        download_link_from_data_url(
          filename,
          "data:text/html;charset=utf-8,\{@global.encodeURIComponent(html)}",
        )
      }
      resolve(())
    }),
  )
}

///|
async fn fetch_current_bundle_text() -> String {
  let response = @dom.window().fetch(current_bundle_src())
  let text_promise : @core.Promise[String] = response
    .as_any()
    ._call("text", [])
    .cast()
  text_promise.wait()
}

///|
fn build_mindmap_export_html(bundle : String) -> String {
  let export_dom = build_mindmap_interactive_export_dom()
  let script_tag = build_export_runtime_script(bundle)
  (
    $|<!doctype html>
    $|<html>
    $|<head>
    $|  <meta charset="utf-8">
    $|  <meta name="viewport" content="width=device-width, initial-scale=1">
    $|  <title>MoonMarkMind Export</title>
    $|</head>
    $|<body>
    $|\{export_dom.outerHTML()}
    $|\{script_tag}
    $|</body>
    $|</html>
  )
}

///|
fn build_export_runtime_script(bundle : String) -> String {
  if bundle.length() == 0 {
    (
      $|<script type="module" src="\{current_bundle_src()}"></script>
    )
  } else {
    (
      $|<script type="module">\{escape_inline_script(bundle)}</script>
    )
  }
}

///|
fn escape_inline_script(script : String) -> String {
  script
  .replace_all(old="</script", new="<\\/script")
  .replace_all(old="<!--", new="<\\!--")
}

///|
fn build_mindmap_interactive_export_dom() -> @dom.Element {
  let saved_collapsed = app_state.collapsed
  let saved_collapsed_note_nodes = app_state.collapsed_note_nodes
  let saved_hidden_nodes = app_state.hidden_nodes
  let saved_selected_node = app_state.selected_node
  let saved_selected_nodes = app_state.selected_nodes
  let saved_editing_node = app_state.editing_node
  let saved_editing_note_node = app_state.editing_note_node
  app_state.collapsed = []
  app_state.collapsed_note_nodes = []
  app_state.hidden_nodes = []
  app_state.selected_node = -2
  app_state.selected_nodes = []
  app_state.editing_node = -2
  app_state.editing_note_node = -2
  let root = create_element("main", "mindmap-export")
  root.setAttribute("id", "mindmap-export")
  root.setAttribute("data-export-collapsed", ints_to_csv(saved_collapsed))
  root.setAttribute(
    "data-export-note-collapsed",
    ints_to_csv(saved_collapsed_note_nodes),
  )
  style_of(root).set_property("display", "inline-block")
  style_of(root).set_property("padding", "48px")
  style_of(root).set_property("background", "transparent")
  let mindmap = create_element("div", "mindmap")
  mindmap.setAttribute("id", "mindmap")
  mindmap.setAttribute("data-pan-x", "0")
  mindmap.setAttribute("data-pan-y", "0")
  mindmap.setAttribute("data-zoom", "1")
  style_of(mindmap).set_property("height", "auto")
  style_of(mindmap).set_property("overflow", "visible")
  append_child(mindmap, build_mindmap_dom())
  apply_mindmap_export_layout(mindmap)
  append_child(root, mindmap)
  app_state.collapsed = saved_collapsed
  app_state.collapsed_note_nodes = saved_collapsed_note_nodes
  app_state.hidden_nodes = saved_hidden_nodes
  app_state.selected_node = saved_selected_node
  app_state.selected_nodes = saved_selected_nodes
  app_state.editing_node = saved_editing_node
  app_state.editing_note_node = saved_editing_note_node
  root
}

///|
fn apply_mindmap_export_layout(mindmap : @dom.Element) -> Unit {
  match mindmap.querySelector(".mindmap-content") {
    Some(content) => {
      let content_style = style_of(content)
      content_style.set_property("position", "relative")
      content_style.set_property("left", "auto")
      content_style.set_property("top", "auto")
      content_style.set_property("transform", "none")
      content_style.set_property("display", "inline-block")
    }
    None => ()
  }
}

///|
fn current_bundle_src() -> String {
  let location = @dom.window().location()
  let origin = location._get("origin").to_string()
  if origin == "null" || origin.length() == 0 {
    "main.bundle.js"
  } else {
    "\{origin}/main.bundle.js"
  }
}

///|
let export_collapsed_nodes : @ref.Ref[Array[Int]] = @ref.Ref([])

///|
let export_collapsed_note_nodes : @ref.Ref[Array[Int]] = @ref.Ref([])

///|
fn bind_export_mindmap_ui(export_root : @dom.Element) -> Unit {
  apply_export_page_theme()
  export_collapsed_nodes.val = parse_selection_indices(
    export_root.getAttribute("data-export-collapsed").unwrap_or(""),
  )
  export_collapsed_note_nodes.val = parse_selection_indices(
    export_root.getAttribute("data-export-note-collapsed").unwrap_or(""),
  )
  export_root
  .as_event_target()
  .on("click", fn(raw) {
    let event : @dom.MouseEvent = raw.cast()
    match event.target().closest(".markdown-image") {
      Some(image) => {
        event.preventDefault()
        event.stopPropagation()
        show_markdown_image_preview(image)
      }
      None =>
        match event.target().closest("[data-action=\"toggle-note\"]") {
          Some(button) =>
            handle_export_note_toggle_click(export_root, event, button)
          None =>
            match event.target().closest("[data-action=\"toggle\"]") {
              Some(button) =>
                handle_export_node_toggle_click(export_root, event, button)
              None => ()
            }
        }
    }
  })
  @dom.window()
  .as_event_target()
  .on("resize", fn(_) { render_export_mindmap_connectors(export_root) })
  apply_export_collapsed_state(export_root)
  apply_export_note_collapsed_state(export_root)
  schedule_export_mindmap_connectors(export_root)
}

///|
fn handle_export_node_toggle_click(
  export_root : @dom.Element,
  event : @dom.MouseEvent,
  button : @dom.Element,
) -> Unit {
  match button.closest(".node[data-node-index]") {
    Some(card) => {
      let node_index = parse_int_or_default(
        card.getAttribute("data-node-index").unwrap_or("-1"),
        -1,
      )
      if node_index >= 0 {
        event.preventDefault()
        event.stopPropagation()
        if contains_int(export_collapsed_nodes.val, node_index) {
          export_collapsed_nodes.val = remove_int(
            export_collapsed_nodes.val,
            node_index,
          )
        } else {
          export_collapsed_nodes.val.push(node_index)
        }
        apply_export_collapsed_state(export_root)
      }
    }
    None => ()
  }
}

///|
fn handle_export_note_toggle_click(
  export_root : @dom.Element,
  event : @dom.MouseEvent,
  button : @dom.Element,
) -> Unit {
  match button.closest(".node[data-node-index]") {
    Some(card) => {
      let node_index = parse_int_or_default(
        card.getAttribute("data-node-index").unwrap_or("-1"),
        -1,
      )
      if node_index >= 0 {
        event.preventDefault()
        event.stopPropagation()
        if contains_int(export_collapsed_note_nodes.val, node_index) {
          export_collapsed_note_nodes.val = remove_int(
            export_collapsed_note_nodes.val,
            node_index,
          )
        } else {
          export_collapsed_note_nodes.val.push(node_index)
        }
        apply_export_note_collapsed_state(export_root)
      }
    }
    None => ()
  }
}

///|
fn apply_export_page_theme() -> Unit {
  let html_style = style_of(@dom.document().documentElement())
  html_style.set_property("min-height", "100%")
  html_style.set_property("background", "transparent")
  match @dom.document().body() {
    Some(body) => {
      let body_style = style_of(body.as_element())
      body_style.set_property("margin", "0")
      body_style.set_property("min-height", "100%")
      body_style.set_property("overflow", "auto")
      body_style.set_property("background", "transparent")
      body_style.set_property(
        "font-family", "\"Segoe UI\", \"PingFang SC\", \"Microsoft YaHei\", sans-serif",
      )
    }
    None => ()
  }
}

///|
fn show_markdown_image_preview(image : @dom.Element) -> Unit {
  let src = image.getAttribute("src").unwrap_or("")
  if src.length() == 0 {
    return
  }
  close_markdown_image_preview()
  let overlay = create_element("div", "image-preview-overlay")
  overlay.setAttribute("role", "dialog")
  overlay.setAttribute("aria-modal", "true")
  overlay.setAttribute("tabindex", "-1")
  let close = create_element("button", "image-preview-close")
  close.setAttribute("type", "button")
  close.setAttribute("aria-label", "Close")
  close.setTextContent("x")
  let preview = create_element("img", "image-preview")
  preview.setAttribute("src", src)
  preview.setAttribute("alt", image.getAttribute("alt").unwrap_or(""))
  append_child(overlay, close)
  append_child(overlay, preview)
  overlay
  .as_event_target()
  .on("click", fn(raw) {
    let event : @dom.MouseEvent = raw.cast()
    match event.target().closest(".image-preview") {
      Some(_) => ()
      None => close_markdown_image_preview()
    }
  })
  overlay
  .as_event_target()
  .on("keydown", fn(raw) {
    let event : @dom.KeyboardEvent = raw.cast()
    if event_key(event) == "Escape" {
      event.preventDefault()
      close_markdown_image_preview()
    }
  })
  match @dom.document().body() {
    Some(body) => append_child(body.as_element(), overlay)
    None => append_child(@dom.document().documentElement(), overlay)
  }
  @dom.HTMLElement::cast_from_element(overlay).focus()
}

///|
fn close_markdown_image_preview() -> Unit {
  match get_element(".image-preview-overlay") {
    Some(overlay) => overlay.remove()
    None => ()
  }
}

///|
fn apply_export_collapsed_state(export_root : @dom.Element) -> Unit {
  let cards : Array[@dom.Element] = export_root.querySelectorAll(
    ".node[data-node-index]",
  )
  for card in cards {
    let node_index = parse_int_or_default(
      card.getAttribute("data-node-index").unwrap_or("-1"),
      -1,
    )
    let parent_index = export_parent_index(card)
    let container = export_node_container(card)
    if parent_index >= 0 {
      apply_export_hidden_state(
        container,
        export_hidden_by_collapsed(cards, node_index),
      )
    }
    match card.querySelector("[data-action=\"toggle\"]") {
      Some(button) => {
        let collapsed = contains_int(export_collapsed_nodes.val, node_index)
        let hidden_count = card.getAttribute("data-hidden-count").unwrap_or("")
        card.setAttribute("data-collapsed", collapsed.to_string())
        button.setAttribute("aria-expanded", (!collapsed).to_string())
        toggle_class(button, "node-action--collapsed", collapsed)
        button.setTextContent(if collapsed { hidden_count } else { "" })
      }
      None => ()
    }
  }
  schedule_export_mindmap_connectors(export_root)
}

///|
fn apply_export_note_collapsed_state(export_root : @dom.Element) -> Unit {
  let cards : Array[@dom.Element] = export_root.querySelectorAll(
    ".node[data-node-index]",
  )
  for card in cards {
    let node_index = parse_int_or_default(
      card.getAttribute("data-node-index").unwrap_or("-1"),
      -1,
    )
    let collapsed = contains_int(export_collapsed_note_nodes.val, node_index)
    match card.querySelector("[data-action=\"toggle-note\"]") {
      Some(button) =>
        button.setAttribute("aria-expanded", (!collapsed).to_string())
      None => ()
    }
    match card.querySelector("[data-note-preview-for]") {
      Some(body) => apply_export_hidden_state(body, collapsed)
      None => ()
    }
  }
  schedule_export_mindmap_connectors(export_root)
}

///|
fn apply_export_hidden_state(container : @dom.Element, hidden : Bool) -> Unit {
  let style = style_of(container)
  if hidden {
    container.setAttribute("hidden", "")
    style.set_property_priority("display", "none", "important")
  } else {
    container.removeAttribute("hidden")
    ignore(style.remove_property("display"))
    apply_theme_to_element(container)
  }
}

///|
fn schedule_export_mindmap_connectors(export_root : @dom.Element) -> Unit {
  let window = @dom.window()
  ignore(
    window.requestAnimationFrame(fn(_) {
      ignore(
        window.requestAnimationFrame(fn(_) {
          render_export_mindmap_connectors(export_root)
        }),
      )
    }),
  )
}

///|
fn export_parent_index(card : @dom.Element) -> Int {
  parse_int_or_default(
    card.getAttribute("data-parent-index").unwrap_or("-1"),
    -1,
  )
}

///|
fn export_node_container(card : @dom.Element) -> @dom.Element {
  match card.closest(".branch-item, .vertical-tree, .single-right-tree__node") {
    Some(container) => container
    None => card
  }
}

///|
fn export_hidden_by_collapsed(
  cards : Array[@dom.Element],
  node_index : Int,
) -> Bool {
  for cursor = export_parent_of(cards, node_index); cursor >= 0; {
    if contains_int(export_collapsed_nodes.val, cursor) {
      return true
    }
    continue export_parent_of(cards, cursor)
  } nobreak {
    false
  }
}

///|
fn export_parent_of(cards : Array[@dom.Element], node_index : Int) -> Int {
  for card in cards {
    let current = parse_int_or_default(
      card.getAttribute("data-node-index").unwrap_or("-1"),
      -1,
    )
    if current == node_index {
      return export_parent_index(card)
    }
  }
  -1
}

///|
fn render_export_mindmap_connectors(export_root : @dom.Element) -> Unit {
  match export_root.querySelector(".mindmap-stage") {
    Some(stage) => {
      match stage.querySelector(".mindmap-connector-layer") {
        Some(layer) => layer.remove()
        None => ()
      }
      let nodes = export_visible_node_cards(export_root)
      if nodes.length() <= 1 {
        return
      }
      let stage_rect = element_rect(stage)
      let width = max_double(1.0, stage_rect.width).ceil().to_int()
      let height = max_double(1.0, stage_rect.height).ceil().to_int()
      let svg = create_svg_element("svg", "mindmap-connector-layer")
      svg.setAttribute("width", width.to_string())
      svg.setAttribute("height", height.to_string())
      svg.setAttribute("viewBox", "0 0 \{width} \{height}")
      let svg_style = style_of(svg)
      svg_style.set_property("position", "absolute")
      svg_style.set_property("left", "0px")
      svg_style.set_property("top", "0px")
      svg_style.set_property("overflow", "visible")
      svg_style.set_property("pointer-events", "none")
      let layout = stage_layout_kind(stage)
      svg_style.set_property("z-index", connector_layer_z_index(layout))
      let color = export_connector_color(stage)
      for node in nodes {
        match
          build_branch_line_node_baseline(
            layout,
            node,
            element_rect(node),
            stage_rect.left,
            stage_rect.top,
            1.0,
            color,
          ) {
          Some(path) => append_child(svg, path)
          None => ()
        }
      }
      for node in nodes {
        let parent_index = export_parent_index(node)
        if parent_index < 0 {
          continue
        }
        match find_node_by_index(nodes, parent_index) {
          Some(parent) => {
            let path_data = export_connector_geometry(
              layout,
              element_rect(parent),
              element_rect(node),
              parent,
              node,
              stage_rect.left,
              stage_rect.top,
            )
            append_child(
              svg,
              build_export_connector_path(parent, node, path_data, color),
            )
          }
          None => ()
        }
      }
      stage.as_any()._call("prepend", [svg.as_any()]) |> ignore
    }
    None => ()
  }
}

///|
fn export_visible_node_cards(export_root : @dom.Element) -> Array[@dom.Element] {
  let nodes : Array[@dom.Element] = export_root.querySelectorAll(
    ".node[data-node-index]",
  )
  let visible : Array[@dom.Element] = []
  for node in nodes {
    if !export_node_container(node).hasAttribute("hidden") {
      visible.push(node)
    }
  }
  visible
}

///|
fn build_mindmap_export_svg() -> String {
  match build_mindmap_export_svg_element() {
    Some(svg) => serialize_svg_export_element(svg)
    None => ""
  }
}

///|
priv struct MindmapExportViewState {
  pan_x : String
  pan_y : String
  zoom : String
  style_pan_x : String
  style_pan_y : String
  style_zoom : String
}

///|
fn capture_mindmap_export_view_state(
  mindmap : @dom.Element,
) -> MindmapExportViewState {
  let style = style_of(mindmap)
  MindmapExportViewState::{
    pan_x: mindmap.getAttribute("data-pan-x").unwrap_or("0"),
    pan_y: mindmap.getAttribute("data-pan-y").unwrap_or("0"),
    zoom: mindmap.getAttribute("data-zoom").unwrap_or("1"),
    style_pan_x: style.get_property_value("--pan-x"),
    style_pan_y: style.get_property_value("--pan-y"),
    style_zoom: style.get_property_value("--zoom"),
  }
}

///|
fn apply_neutral_mindmap_export_view(mindmap : @dom.Element) -> Unit {
  mindmap.setAttribute("data-pan-x", "0")
  mindmap.setAttribute("data-pan-y", "0")
  mindmap.setAttribute("data-zoom", "1")
  let style = style_of(mindmap)
  style.set_property("--pan-x", "0px")
  style.set_property("--pan-y", "0px")
  style.set_property("--zoom", "1")
}

///|
fn restore_mindmap_export_view(
  mindmap : @dom.Element,
  state : MindmapExportViewState,
) -> Unit {
  mindmap.setAttribute("data-pan-x", state.pan_x)
  mindmap.setAttribute("data-pan-y", state.pan_y)
  mindmap.setAttribute("data-zoom", state.zoom)
  let style = style_of(mindmap)
  restore_export_style_property(style, "--pan-x", state.style_pan_x)
  restore_export_style_property(style, "--pan-y", state.style_pan_y)
  restore_export_style_property(style, "--zoom", state.style_zoom)
}

///|
fn restore_export_style_property(
  style : @dom.CSSStyleDeclaration,
  name : String,
  value : String,
) -> Unit {
  if value.length() == 0 {
    ignore(style.remove_property(name))
  } else {
    style.set_property(name, value)
  }
}

///|
fn build_mindmap_export_svg_element() -> @dom.Element? {
  match get_element("#mindmap") {
    Some(mindmap) => {
      let view_state = capture_mindmap_export_view_state(mindmap)
      apply_neutral_mindmap_export_view(mindmap)
      normalize_static_export_note_buttons(mindmap)
      render_mindmap_connectors()
      let clone = @dom.Element::cast_from_node(mindmap.cloneNode(true))
      normalize_export_connector_styles(clone)
      let bounds = mindmap_export_bounds(mindmap)
      let svg = create_svg_element("svg", "")
      svg.setAttribute("xmlns", "http://www.w3.org/2000/svg")
      svg.setAttribute("width", bounds.width.to_string())
      svg.setAttribute("height", bounds.height.to_string())
      svg.setAttribute("viewBox", "0 0 \{bounds.width} \{bounds.height}")
      let foreign_object = create_svg_element("foreignObject", "")
      foreign_object.setAttribute("width", "100%")
      foreign_object.setAttribute("height", "100%")
      let wrapper = create_element("div", "")
      wrapper.setAttribute("xmlns", "http://www.w3.org/1999/xhtml")
      let wrapper_style = style_of(wrapper)
      wrapper_style.set_property("width", "\{bounds.mindmap_width}px")
      wrapper_style.set_property("height", "\{bounds.mindmap_height}px")
      wrapper_style.set_property("background", "transparent")
      wrapper_style.set_property(
        "transform",
        "translate(\{bounds.mindmap_x}px, \{bounds.mindmap_y}px)",
      )
      wrapper_style.set_property("overflow", "visible")
      let mindmap_style = style_of(clone)
      mindmap_style.set_property("width", "\{bounds.mindmap_width}px")
      mindmap_style.set_property("height", "\{bounds.mindmap_height}px")
      mindmap_style.set_property("min-height", "\{bounds.mindmap_height}px")
      mindmap_style.set_property("overflow", "visible")
      mindmap_style.set_property("background", "transparent")
      mindmap_style.set_property("--pan-x", "0px")
      mindmap_style.set_property("--pan-y", "0px")
      mindmap_style.set_property("--zoom", "1")
      match
        build_mindmap_export_connector_group(mindmap, bounds.left, bounds.top) {
        Some(connectors) =>
          svg.as_node().appendChild(connectors.as_node()) |> ignore
        None => ()
      }
      wrapper.as_node().appendChild(clone.as_node()) |> ignore
      foreign_object.as_node().appendChild(wrapper.as_node()) |> ignore
      svg.as_node().appendChild(foreign_object.as_node()) |> ignore
      restore_mindmap_export_view(mindmap, view_state)
      render_ui()
      Some(svg)
    }
    None => None
  }
}

///|
priv struct MindmapExportBounds {
  left : Double
  top : Double
  width : Int
  height : Int
  mindmap_x : Double
  mindmap_y : Double
  mindmap_width : Int
  mindmap_height : Int
}

///|
fn mindmap_export_bounds(mindmap : @dom.Element) -> MindmapExportBounds {
  let margin = 48.0
  let mindmap_rect = element_rect(mindmap)
  let (content_left, content_top, content_right, content_bottom) = match
    mindmap.querySelector(".mindmap-stage") {
    Some(stage) =>
      match mindmap_node_bounds(stage) {
        Some(bounds) => bounds
        None =>
          (
            mindmap_rect.left,
            mindmap_rect.top,
            mindmap_rect.right,
            mindmap_rect.bottom,
          )
      }
    None =>
      (
        mindmap_rect.left,
        mindmap_rect.top,
        mindmap_rect.right,
        mindmap_rect.bottom,
      )
  }
  let left = content_left - margin
  let top = content_top - margin
  let width = max_double(1.0, content_right - content_left + margin * 2.0)
    .ceil()
    .to_int()
  let height = max_double(1.0, content_bottom - content_top + margin * 2.0)
    .ceil()
    .to_int()
  MindmapExportBounds::{
    left,
    top,
    width,
    height,
    mindmap_x: mindmap_rect.left - left,
    mindmap_y: mindmap_rect.top - top,
    mindmap_width: max_double(1.0, mindmap_rect.width).ceil().to_int(),
    mindmap_height: max_double(1.0, mindmap_rect.height).ceil().to_int(),
  }
}

///|
fn normalize_export_connector_styles(mindmap : @dom.Element) -> Unit {
  match mindmap.querySelector(".mindmap-stage") {
    Some(stage) =>
      match stage.querySelector(".mindmap-connector-layer") {
        Some(layer) => layer.remove()
        None => ()
      }
    None => ()
  }
}

///|
fn normalize_static_export_note_buttons(mindmap : @dom.Element) -> Unit {
  let buttons : Array[@dom.Element] = mindmap.querySelectorAll(
    ".node-action--note",
  )
  for button in buttons {
    button.setTextContent("")
    button.removeAttribute("data-action")
    button.removeAttribute("data-tip")
    button.removeAttribute("aria-label")
    button.removeAttribute("aria-expanded")
    let button_style = style_of(button)
    button_style.set_property("display", "none")
    button_style.set_property("pointer-events", "none")
    match button.closest(".node") {
      Some(node) => {
        match node.querySelector("[data-note-preview-for]") {
          Some(body) => {
            let body_style = style_of(body)
            body_style.set_property(
              "margin-top",
              static_export_note_body_margin_top(node),
            )
          }
          None => ()
        }
        match node.querySelector(".node-title") {
          Some(title) => {
            let title_style = style_of(title)
            title_style.set_property(
              "margin-top",
              static_export_note_title_shift(),
            )
          }
          None => ()
        }
      }
      None => ()
    }
  }
}

///|
fn static_export_note_body_margin_top(node : @dom.Element) -> String {
  static_export_note_body_margin_top_for_branch_line(
    has_class_name(node, "node--branch-line"),
  )
}

///|
fn static_export_note_body_margin_top_for_branch_line(
  is_branch_line : Bool,
) -> String {
  let _ = is_branch_line
  "4px"
}

///|
fn static_export_note_title_shift() -> String {
  "4px"
}

///|
fn build_mindmap_export_connector_group(
  mindmap : @dom.Element,
  export_left : Double,
  export_top : Double,
) -> @dom.Element? {
  match mindmap.querySelector(".mindmap-stage") {
    Some(stage) => {
      let nodes : Array[@dom.Element] = stage.querySelectorAll(
        ".node[data-node-index]",
      )
      if nodes.length() <= 1 {
        return None
      }
      let layout = stage_layout_kind(stage)
      let color = export_connector_color(stage)
      let group = create_svg_element("g", "mindmap-export-connectors")
      group.setAttribute("fill", "none")
      group.setAttribute("opacity", "0.92")
      for node in nodes {
        match
          build_branch_line_node_baseline(
            layout,
            node,
            element_rect(node),
            export_left,
            export_top,
            1.0,
            color,
          ) {
          Some(path) => append_child(group, path)
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
          Some(parent) => {
            let path_data = export_connector_geometry(
              layout,
              element_rect(parent),
              element_rect(node),
              parent,
              node,
              export_left,
              export_top,
            )
            append_child(
              group,
              build_export_connector_path(parent, node, path_data, color),
            )
          }
          None => ()
        }
      }
      Some(group)
    }
    None => None
  }
}

///|
fn export_connector_geometry(
  layout : StageLayoutKind,
  parent_rect : @dom.DOMRect,
  node_rect : @dom.DOMRect,
  parent_node : @dom.Element,
  node : @dom.Element,
  export_left : Double,
  export_top : Double,
) -> ConnectorPathData {
  let parent_center_x = rect_center_x(parent_rect) - export_left
  let parent_center_y = rect_center_y(parent_rect) - export_top
  let node_center_x = rect_center_x(node_rect) - export_left
  let node_center_y = rect_center_y(node_rect) - export_top
  let parent_anchor_y = connector_node_anchor_y(parent_rect, parent_node) -
    export_top
  let node_anchor_y = connector_node_anchor_y(node_rect, node) - export_top
  match layout {
    StageLayoutKind::Tree => {
      let start_x = parent_center_x
      let start_y = connector_node_bottom_y(parent_rect, parent_node, 1.0) -
        export_top
      let end_x = node_center_x
      let end_y = node_rect.top - export_top
      let span_y = abs_double(end_y - start_y)
      let bend = min_double(44.0, max_double(16.0, span_y * 0.4))
      ConnectorPathData::{
        start_x,
        start_y,
        control1_x: start_x,
        control1_y: start_y + bend,
        control2_x: end_x,
        control2_y: end_y - bend,
        end_x,
        end_y,
      }
    }
    StageLayoutKind::Logic => {
      let start_x = connector_node_side_x(parent_rect, parent_node, 1.0, 1.0) -
        export_left
      let start_y = parent_anchor_y
      let end_x = node_rect.left - export_left
      let end_y = node_anchor_y
      let span_x = abs_double(end_x - start_x)
      let bend = min_double(36.0, max_double(14.0, span_x * 0.28))
      ConnectorPathData::{
        start_x,
        start_y,
        control1_x: start_x + bend,
        control1_y: start_y,
        control2_x: end_x - bend,
        control2_y: end_y,
        end_x,
        end_y,
      }
    }
    StageLayoutKind::Mindmap => {
      let direction = if node_center_x >= parent_center_x { 1.0 } else { -1.0 }
      let start_x = connector_node_side_x(
          parent_rect, parent_node, direction, 1.0,
        ) -
        export_left
      let end_x = if direction > 0.0 {
        node_rect.left - export_left
      } else {
        node_rect.right - export_left
      }
      let span = abs_double(end_x - start_x)
      let is_branch_line = has_class_name(parent_node, "node--branch-line") ||
        has_class_name(node, "node--branch-line")
      if is_branch_line {
        return branch_line_connector_path_data(
          start_x, parent_anchor_y, end_x, node_anchor_y, direction, span,
        )
      }
      let pull = min_double(30.0, max_double(12.0, span * 0.26))
      let settle = min_double(40.0, max_double(14.0, span * 0.38))
      let mid_y = parent_center_y + (node_center_y - parent_center_y) * 0.2
      ConnectorPathData::{
        start_x,
        start_y: parent_anchor_y,
        control1_x: start_x + direction * pull,
        control1_y: mid_y,
        control2_x: end_x - direction * settle,
        control2_y: node_anchor_y,
        end_x,
        end_y: node_anchor_y,
      }
    }
  }
}

///|
fn build_export_connector_path(
  parent_node : @dom.Element,
  node : @dom.Element,
  path_data : ConnectorPathData,
  color : String,
) -> @dom.Element {
  let path = build_connector_path(parent_node, node, path_data)
  path.setAttribute("stroke", color)
  path.setAttribute("stroke-opacity", "0.92")
  path
}

///|
fn export_connector_color(stage : @dom.Element) -> String {
  if has_class_name(stage, "mindmap-stage--fill") {
    "#7ca5d4"
  } else {
    "#94b6db"
  }
}

///|
fn download_mindmap_svg(filename : String) -> Unit {
  let svg = build_mindmap_export_svg()
  if svg.length() == 0 {
    return
  }
  download_link_from_data_url(
    filename,
    "data:image/svg+xml;charset=utf-8,\{@global.encodeURIComponent(svg)}",
  )
}

///|
fn download_mindmap_png(filename : String) -> Unit {
  let svg_element = match build_mindmap_export_svg_element() {
    Some(svg) => svg
    None => return
  }
  let width = parse_int_or_default(
    svg_element.getAttribute("width").unwrap_or("0"),
    0,
  )
  let height = parse_int_or_default(
    svg_element.getAttribute("height").unwrap_or("0"),
    0,
  )
  if width <= 0 || height <= 0 {
    return
  }
  let scale = png_export_scale(width, height)
  let output_width = (width.to_double() * scale).round().to_int()
  let output_height = (height.to_double() * scale).round().to_int()
  svg_element.setAttribute("width", output_width.to_string())
  svg_element.setAttribute("height", output_height.to_string())
  let svg = serialize_svg_export_element(svg_element)
  let image = create_element("img", "")
  let image_element = @dom.HTMLImageElement::cast_from_element(image)
  let export_url = "data:image/svg+xml;charset=utf-8,\{@global.encodeURIComponent(svg)}"
  image_element
  .as_event_target()
  .addEventListener("load", fn(_) {
    let canvas = create_element("canvas", "")
    let canvas_element = @dom.HTMLCanvasElement::cast_from_element(canvas)
    canvas_element.width = output_width
    canvas_element.height = output_height
    let ctx : @canvas.CanvasRenderingContext2D = @core.identity(
      canvas_element.getContext("2d"),
    )
    ctx.clearRect(0.0, 0.0, output_width.to_double(), output_height.to_double())
    ctx.drawImageScaled(
      image_element.as_any(),
      0.0,
      0.0,
      output_width.to_double(),
      output_height.to_double(),
    )
    download_link_from_data_url(
      filename,
      canvas_element.toDataURL(image_type="image/png"),
    )
  })
  image_element.as_event_target().addEventListener("error", fn(_) { () })
  image_element.src = export_url
}

///|
fn png_export_scale(width : Int, height : Int) -> Double {
  let raw_dpr = @dom.window().devicePixelRatio()
  let preferred = if raw_dpr.is_nan() || raw_dpr < 2.0 {
    2.0
  } else if raw_dpr > 3.0 {
    3.0
  } else {
    raw_dpr
  }
  let max_side = 8192.0
  let max_side_scale = min_double(
    max_side / width.to_double(),
    max_side / height.to_double(),
  )
  let capped = min_double(preferred, max_side_scale)
  if capped < 1.0 {
    1.0
  } else {
    capped
  }
}

///|
fn serialize_svg_export_element(element : @dom.Element) -> String {
  close_svg_void_elements(element.outerHTML())
}

///|
fn close_svg_void_elements(source : String) -> String {
  let parts : Array[String] = []
  let mut cursor = 0
  while cursor < source.length() {
    match find_svg_void_tag_start(source, cursor) {
      Some(start) => {
        if start > cursor {
          parts.push(source[cursor:start].to_string())
        }
        let end_ = find_tag_end(source, start)
        if end_ < 0 {
          parts.push(source[start:].to_string())
          return parts.join("")
        }
        if end_ > start && source[end_ - 1] == '/' {
          parts.push(source[start:end_ + 1].to_string())
        } else {
          parts.push(source[start:end_].to_string() + " />")
        }
        cursor = end_ + 1
      }
      None => {
        parts.push(source[cursor:].to_string())
        cursor = source.length()
      }
    }
  }
  parts.join("")
}

///|
fn find_svg_void_tag_start(source : String, start : Int) -> Int? {
  let mut cursor = start
  while cursor < source.length() {
    if match_svg_void_tag(source, cursor) is Some(_) {
      return Some(cursor)
    }
    cursor += 1
  }
  None
}

///|
fn match_svg_void_tag(source : String, start : Int) -> String? {
  if start < 0 ||
    start + 1 >= source.length() ||
    source[start] != '<' ||
    source[start + 1] == '/' {
    return None
  }
  let tags = [
    "area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "param",
    "source", "track", "wbr",
  ]
  for tag in tags {
    let tag_start = start + 1
    let tag_end = tag_start + tag.length()
    if tag_end <= source.length() &&
      source[tag_start:tag_end].to_string() == tag &&
      (tag_end == source.length() || is_tag_name_boundary(source[tag_end])) {
      return Some(tag)
    }
  }
  None
}

///|
fn is_tag_name_boundary(ch : UInt16) -> Bool {
  ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r' || ch == '/' || ch == '>'
}

///|
fn find_tag_end(source : String, start : Int) -> Int {
  let mut cursor = start
  let mut quote : UInt16 = 0
  while cursor < source.length() {
    let ch = source[cursor]
    if quote != 0 {
      if ch == quote {
        quote = 0
      }
    } else if ch == '"' || ch == '\'' {
      quote = ch
    } else if ch == '>' {
      return cursor
    }
    cursor += 1
  }
  -1
}

///|
fn event_action_from_point(event : @dom.MouseEvent) -> String {
  let target = event_interaction_target(event)
  match target.closest("[data-action]") {
    Some(action) => action.getAttribute("data-action").unwrap_or("")
    None => ""
  }
}

///|
fn event_interaction_target(event : @dom.MouseEvent) -> @dom.Element {
  let target = event.target()
  match
    target.closest(
      ".node, [data-action], [data-editor-for], [data-note-editor-for], [data-body-editor-for]",
    ) {
    Some(interactive) => interactive
    None =>
      if event_target_is_blank_stage_area(target) {
        target
      } else {
        event_target_from_point(event)
      }
  }
}

///|
fn event_target_from_point(event : @dom.MouseEvent) -> @dom.Element {
  for element in @dom.document().elementsFromPoint(event.clientX, event.clientY) {
    match
      element.closest(
        ".node, [data-action], [data-editor-for], [data-note-editor-for], [data-body-editor-for]",
      ) {
      Some(target) => return target
      None => ()
    }
  }
  match @dom.document().elementFromPoint(event.clientX, event.clientY) {
    Some(element) => element
    None => event.target()
  }
}

///|
fn event_target_is_blank_stage_area(target : @dom.Element) -> Bool {
  match target.closest(".mindmap-stage, .mindmap-content, #mindmap") {
    Some(_) =>
      target.closest(
        "[data-node-index], [data-action], [data-editor-for], [data-note-editor-for], [data-body-editor-for], [data-drop-target], [data-drop-parent]",
      )
      is None
    None => false
  }
}

///|
fn event_node_index_from_target(target : @dom.Element) -> Int {
  match target.closest(".node") {
    Some(node) =>
      @strconv.parse_int(node.getAttribute("data-node-index").unwrap_or("-1")) catch {
        _ => -1
      }
    None => -1
  }
}

///|
fn event_node_index_from_point(event : @dom.MouseEvent) -> Int {
  event_node_index_from_target(event_interaction_target(event))
}

///|
fn event_keyboard_node_index(event : @dom.KeyboardEvent) -> Int {
  event_node_index_from_target(event.target())
}

///|
fn event_drop_target_index_from_target(target : @dom.Element) -> Int {
  match target.closest("[data-drop-target]") {
    Some(node) =>
      @strconv.parse_int(node.getAttribute("data-drop-target").unwrap_or("-1")) catch {
        _ => -1
      }
    None => -1
  }
}

///|
fn event_drop_target_index(event : @dom.DragEvent) -> Int {
  event_drop_target_index_from_target(event.target())
}

///|
fn event_drop_parent_index_from_target(target : @dom.Element) -> Int {
  match target.closest("[data-drop-parent]") {
    Some(node) =>
      @strconv.parse_int(node.getAttribute("data-drop-parent").unwrap_or("-1")) catch {
        _ => -1
      }
    None => -1
  }
}

///|
fn event_drop_parent_index(event : @dom.DragEvent) -> Int {
  event_drop_parent_index_from_target(event.target())
}

///|
fn event_drop_place_after_from_target(target : @dom.Element) -> Bool {
  match target.closest("[data-drop-position]") {
    Some(node) =>
      node.getAttribute("data-drop-position").unwrap_or("before") == "after"
    None => false
  }
}

///|
fn event_drop_place_after(event : @dom.DragEvent) -> Bool {
  event_drop_place_after_from_target(event.target())
}

///|
fn event_editor_index_from_target(target : @dom.Element) -> Int {
  match target.closest("[data-editor-for]") {
    Some(node) =>
      @strconv.parse_int(node.getAttribute("data-editor-for").unwrap_or("-1")) catch {
        _ => -1
      }
    None => -1
  }
}

///|
fn event_note_editor_index_from_target(target : @dom.Element) -> Int {
  match target.closest("[data-note-editor-for]") {
    Some(node) =>
      @strconv.parse_int(
        node.getAttribute("data-note-editor-for").unwrap_or("-1"),
      ) catch {
        _ => -1
      }
    None => -1
  }
}

///|
fn event_body_editor_index_from_target(target : @dom.Element) -> Int {
  match target.closest("[data-body-editor-for]") {
    Some(node) =>
      @strconv.parse_int(
        node.getAttribute("data-body-editor-for").unwrap_or("-1"),
      ) catch {
        _ => -1
      }
    None => -1
  }
}

///|
fn event_body_block_index_from_target(target : @dom.Element) -> Int {
  match target.closest("[data-body-block-index], [data-body-editor-block]") {
    Some(block) => {
      let value = block
        .getAttribute("data-body-block-index")
        .unwrap_or(block.getAttribute("data-body-editor-block").unwrap_or("-1"))
      @strconv.parse_int(value) catch {
        _ => -1
      }
    }
    None => -1
  }
}

///|
fn event_note_preview_from_target(target : @dom.Element) -> Bool {
  target.closest("[data-note-preview-for]") is Some(_)
}

///|
fn event_editor_value_from_target(target : @dom.Element) -> String {
  if target.tagName() == "TEXTAREA" {
    to_text_area(target).value
  } else if target.tagName() == "INPUT" {
    @dom.HTMLInputElement::cast_from_element(target).value
  } else {
    target.textContent()
  }
}

///|
fn event_note_editor_value_from_target(target : @dom.Element) -> String {
  event_editor_value_from_target(target)
}

///|
fn event_key(event : @dom.KeyboardEvent) -> String {
  event.key
}

///|
fn event_multi_select_key(event : @dom.MouseEvent) -> Bool {
  event.ctrlKey || event.metaKey
}

///|
fn event_shift_key(event : @dom.MouseEvent) -> Bool {
  event.shiftKey
}

///|
fn event_click_count(event : @dom.MouseEvent) -> Int {
  @strconv.parse_int(event.as_any()._get("detail").to_string()) catch {
    _ => 1
  }
}

///|
fn event_drag_source_index_from_target(target : @dom.Element) -> Int {
  match target.closest("[data-drag-index]") {
    Some(node) =>
      @strconv.parse_int(node.getAttribute("data-drag-index").unwrap_or("-1")) catch {
        _ => -1
      }
    None => -1
  }
}

///|
fn event_drag_source_index(event : @dom.DragEvent) -> Int {
  event_drag_source_index_from_target(event.target())
}

///|
fn event_drag_parent_from_target(target : @dom.Element) -> Int {
  match target.closest("[data-drag-parent]") {
    Some(node) =>
      @strconv.parse_int(node.getAttribute("data-drag-parent").unwrap_or("-1")) catch {
        _ => -1
      }
    None => -1
  }
}

///|
fn event_drag_parent(event : @dom.DragEvent) -> Int {
  event_drag_parent_from_target(event.target())
}

///|
fn set_drag_text(event : @dom.DragEvent, value : String) -> Unit {
  match event.dataTransfer.to_option() {
    Some(data_transfer) => {
      data_transfer.effectAllowed = "move"
      data_transfer.setData("text/plain", value)
    }
    None => ()
  }
}

///|
fn clear_drop_highlights() -> Unit {
  for element in @dom.document().querySelectorAll(".drop-before, .drop-after") {
    toggle_class(element, "drop-before", false)
    toggle_class(element, "drop-after", false)
  }
}

///|
fn highlight_drop_target(node_index : Int, place_after : Bool) -> Unit {
  clear_drop_highlights()
  match get_element("[data-node-index=\"\{node_index}\"]") {
    Some(card) =>
      toggle_class(
        card,
        if place_after {
          "drop-after"
        } else {
          "drop-before"
        },
        true,
      )
    None => ()
  }
}

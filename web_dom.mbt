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
              let _ = if stage_has_vertical_layout(stage_element) {
                false
              } else {
                let svg_paths : Array[@dom.Element] = []
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
                      let parent_rect = element_rect(parent)
                      let node_rect = element_rect(node)
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
                      let direction = if node_center_x >= parent_center_x {
                        1
                      } else {
                        -1
                      }
                      let start_x = stage_local_x(
                        if direction > 0 {
                          parent_rect.right
                        } else {
                          parent_rect.left
                        },
                        stage_left,
                        safe_zoom,
                      )
                      let end_x = stage_local_x(
                        if direction > 0 {
                          node_rect.left
                        } else {
                          node_rect.right
                        },
                        stage_left,
                        safe_zoom,
                      )
                      let span = abs_double(end_x - start_x)
                      let pull = min_double(30.0, max_double(12.0, span * 0.26))
                      let settle = min_double(
                        40.0,
                        max_double(14.0, span * 0.38),
                      )
                      let mid_y = parent_center_y +
                        (node_center_y - parent_center_y) * 0.2
                      let stroke_width = if parse_int_or_default(
                          node.getAttribute("data-depth").unwrap_or("0"),
                          0,
                        ) ==
                        1 {
                        2.8
                      } else {
                        2.0
                      }
                      let path = create_svg_element("path", "")
                      path.setAttribute(
                        "d",
                        "M \{double_to_svg_number(start_x)} \{double_to_svg_number(parent_center_y)} C \{double_to_svg_number(start_x + direction.to_double() * pull)} \{double_to_svg_number(mid_y)}, \{double_to_svg_number(end_x - direction.to_double() * settle)} \{double_to_svg_number(node_center_y)}, \{double_to_svg_number(end_x)} \{double_to_svg_number(node_center_y)}",
                      )
                      path.setAttribute("fill", "none")
                      path.setAttribute("stroke", "#94b6db")
                      path.setAttribute("stroke-opacity", "0.9")
                      path.setAttribute(
                        "stroke-width",
                        double_to_svg_number(stroke_width),
                      )
                      path.setAttribute("stroke-linecap", "round")
                      path.setAttribute("stroke-linejoin", "round")
                      path.setAttribute("vector-effect", "non-scaling-stroke")
                      svg_paths.push(path)
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
                style.set_property("z-index", "0")
                style.set_property("pointer-events", "none")
                style.set_property("position", "absolute")
                style.set_property("overflow", "visible")
                for path in svg_paths {
                  append_child(svg, path)
                }
                svg_paths.length() > 0
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
fn stage_has_vertical_layout(stage : @dom.Element) -> Bool {
  has_class_name(stage, "mindmap-stage--vertical") ||
  has_class_name(stage, "mindmap-stage--single-right")
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
  ignore(
    window.requestAnimationFrame(fn(_) {
      ignore(
        window.requestAnimationFrame(fn(_) { render_mindmap_connectors() }),
      )
    }),
  )
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
  let font_size = parse_double_or_default(
    style.get_property_value("font-size"),
    16.0,
  )
  let line_height_raw = style.get_property_value("line-height")
  let line_height = if line_height_raw.length() > 0 {
    let next_line_height = parse_double_or_default(
      line_height_raw,
      font_size * 1.75,
    )
    if next_line_height.is_nan() || next_line_height <= 0.0 {
      (font_size * 1.75).round().to_int()
    } else {
      next_line_height.round().to_int()
    }
  } else {
    (font_size * 1.75).round().to_int()
  }
  let padding_top = parse_int_or_default(
    style.get_property_value("padding-top"),
    0,
  )
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
  let font_size = parse_double_or_default(
    style.get_property_value("font-size"),
    16.0,
  )
  let line_height_raw = style.get_property_value("line-height")
  let resolved_line_height = if line_height_raw.length() > 0 {
    let next_line_height = parse_double_or_default(
      line_height_raw,
      font_size * 1.75,
    )
    if next_line_height.is_nan() || next_line_height <= 0.0 {
      (font_size * 1.75).round().to_int()
    } else {
      next_line_height.round().to_int()
    }
  } else {
    (font_size * 1.75).round().to_int()
  }
  let padding_top = parse_int_or_default(
    style.get_property_value("padding-top"),
    0,
  )
  let padding_bottom = parse_int_or_default(
    style.get_property_value("padding-bottom"),
    0,
  )
  let padding_right = parse_double_or_default(
    style.get_property_value("padding-right"),
    0.0,
  )
  let padding_left = parse_double_or_default(
    style.get_property_value("padding-left"),
    0.0,
  )
  let mirror = create_element("div", "")
  let mirror_style = @dom.css_style_from_val(
    mirror.as_any()._get("style").cast(),
  )
  mirror_style.set_property("position", "absolute")
  mirror_style.set_property("visibility", "hidden")
  mirror_style.set_property("pointer-events", "none")
  mirror_style.set_property("inset", "0")
  mirror_style.set_property("width", "100%")
  mirror_style.set_property("height", "auto")
  mirror_style.set_property("box-sizing", "border-box")
  mirror_style.set_property("border", "0")
  mirror_style.set_property(
    "padding",
    "\{padding_top}px \{padding_right}px \{padding_bottom}px \{padding_left}px",
  )
  mirror_style.set_property("font", style.get_property_value("font"))
  mirror_style.set_property(
    "line-height",
    style.get_property_value("line-height"),
  )
  mirror_style.set_property(
    "letter-spacing",
    style.get_property_value("letter-spacing"),
  )
  mirror_style.set_property(
    "tab-size",
    if style.get_property_value("tab-size").length() > 0 {
      style.get_property_value("tab-size")
    } else {
      "2"
    },
  )
  mirror_style.set_property("white-space", "normal")
  mirror_style.set_property("word-break", "break-word")
  mirror_style.set_property("overflow-wrap", "anywhere")
  mirror_style.set_property("color", style.get_property_value("color"))
  mirror_style.set_property(
    "text-align",
    style.get_property_value("text-align"),
  )
  mirror_style.set_property("direction", style.get_property_value("direction"))
  mirror_style.set_property(
    "width",
    "\{max_double(1.0, input.clientWidth().to_double()).round().to_int()}px",
  )
  let lines = input.value.split("\n".view())
  let heights : Array[Int] = []
  let tops : Array[Int] = []
  let mut current_top = padding_top
  let parent = match input.parentElement() {
    Some(parent) => parent
    None => @dom.document().documentElement()
  }
  append_child(parent, mirror)
  for line in lines {
    let block = create_element("div", "")
    let block_style = @dom.css_style_from_val(
      block.as_any()._get("style").cast(),
    )
    block_style.set_property("display", "block")
    block_style.set_property("white-space", "pre-wrap")
    block_style.set_property("word-break", "break-word")
    block_style.set_property("overflow-wrap", "anywhere")
    block_style.set_property("margin", "0")
    block_style.set_property("padding", "0")
    block.setTextContent(if line.length() > 0 { line.to_string() } else { " " })
    append_child(mirror, block)
    let content_height = block.clientHeight()
    let next_height = if content_height > resolved_line_height {
      content_height
    } else {
      resolved_line_height
    }
    heights.push(next_height)
    tops.push(current_top)
    current_top += next_height
  }
  mirror.remove()
  "\{serialize_int_list(heights)}|\{serialize_int_list(tops)}|\{resolved_line_height}|\{padding_top}"
}

///|
fn build_linked_line_dom(
  metrics : InputLineMetrics,
  line_index : Int,
  scroll_top : Int,
  class_name : String,
) -> @dom.Element? {
  if line_index < 0 || line_index >= metrics.heights.length() {
    None
  } else {
    let top = metrics.tops.get(line_index).unwrap_or(metrics.padding_top) -
      scroll_top
    let height = metrics.heights.get(line_index).unwrap_or(metrics.line_height)
    let block_height = if height > 1 { height } else { 1 }
    let block = create_element("div", class_name)
    let style = @dom.css_style_from_val(block.as_any()._get("style").cast())
    style.set_property("height", "\{block_height}px")
    style.set_property("transform", "translateY(\{top}px)")
    style.set_property("opacity", "1")
    Some(block)
  }
}

///|
fn build_gutter_number_dom(line_number : Int, height : Int) -> @dom.Element {
  let block = create_element("div", "editor-gutter-number")
  let block_height = if height > 1 { height } else { 1 }
  let style = @dom.css_style_from_val(block.as_any()._get("style").cast())
  style.set_property("height", "\{block_height}px")
  block.setTextContent(line_number.to_string())
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
  if !visible || line_index < 0 {
    style.set_property("opacity", "0")
    return
  }
  let top = metrics.tops.get(line_index).unwrap_or(metrics.padding_top) -
    scroll_top
  let height = metrics.heights.get(line_index).unwrap_or(metrics.line_height)
  let block_height = if height > 1 { height } else { 1 }
  style.set_property("height", "\{block_height}px")
  style.set_property("transform", "translateY(\{top}px)")
  style.set_property("opacity", "1")
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
  if !visible || start_line_index < 0 || end_line_index < start_line_index {
    style.set_property("opacity", "0")
    return
  }
  let start_top = metrics.tops
    .get(start_line_index)
    .unwrap_or(metrics.padding_top) -
    scroll_top
  let end_bottom = metrics.tops
    .get(end_line_index)
    .unwrap_or(metrics.padding_top) +
    metrics.heights.get(end_line_index).unwrap_or(metrics.line_height) -
    scroll_top
  let height = end_bottom - start_top
  let block_height = if height > 1 { height } else { 1 }
  style.set_property("height", "\{block_height}px")
  style.set_property("transform", "translateY(\{start_top}px)")
  style.set_property("opacity", "1")
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
      let heights = if metrics.heights.length() > 0 {
        metrics.heights
      } else {
        [metrics.line_height]
      }
      let mut line_number = 1
      for height in heights {
        append_child(gutter, build_gutter_number_dom(line_number, height))
        line_number += 1
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
  match get_element("#input-hover-line") {
    Some(hover_line) =>
      set_line_layer(
        hover_line,
        line_index,
        line_index >= 0,
        metrics,
        scroll_top,
      )
    None => ()
  }
  match get_element("#input-hover-gutter-line") {
    Some(hover_gutter_line) =>
      set_line_layer(
        hover_gutter_line,
        line_index,
        line_index >= 0,
        metrics,
        scroll_top,
      )
    None => ()
  }
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
      let line_top = metrics.tops.get(line_index).unwrap_or(metrics.padding_top)
      let line_height = metrics.heights
        .get(line_index)
        .unwrap_or(metrics.line_height)
      let target_top = {
        let offset = line_height * 2
        let minimum_view = (input.clientHeight().to_double() * 0.35)
          .round()
          .to_int()
        let view_offset = if offset > minimum_view {
          offset
        } else {
          minimum_view
        }
        let candidate = line_top - view_offset
        if candidate > 0 {
          candidate
        } else {
          0
        }
      }
      reveal_input_line_after_paint(target_top)
      select_input_line(input, line_index)
    }
    None => ()
  }
}

///|
fn select_input_line(
  input : @dom.HTMLTextAreaElement,
  line_index : Int,
) -> Unit {
  set_input_selection_range_by_line(input, line_index)
  sync_editor_chrome()
}

///|
fn set_input_selection_range_by_line(
  input : @dom.HTMLTextAreaElement,
  line_index : Int,
) -> Unit {
  let lines = input.value.split("\n".view()).to_array()
  if line_index < 0 || line_index >= lines.length() {
    return
  }
  let mut start = 0
  for index in 0..<line_index {
    start += lines[index].length() + 1
  }
  let end = start + lines[line_index].length()
  input.focus()
  let box = input.as_any()
  box._set("__selection_start", @core.any(start))
  box._set("__selection_end", @core.any(end))
  let start_any = box._get("__selection_start")
  let end_any = box._get("__selection_end")
  input.as_any()._call("setSelectionRange", [start_any, end_any]) |> ignore
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
          match custom.querySelector(".tool-select-trigger") {
            Some(trigger) => {
              match trigger.querySelector(".tool-select-trigger__label") {
                Some(label) => label.setTextContent(next_text)
                None => trigger.setTextContent(next_text)
              }
              toggle_class(
                trigger,
                "tool-select--muted",
                has_class_name(select.as_element(), "tool-select--muted"),
              )
            }
            None => ()
          }
          for option_button in custom.querySelectorAll(".tool-select-option") {
            let option_value = option_button
              .getAttribute("data-value")
              .unwrap_or("")
            toggle_class(
              option_button,
              "is-selected",
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
      let trigger = create_element("button", "tool-select-trigger")
      trigger.setAttribute("type", "button")
      trigger.setAttribute("aria-haspopup", "listbox")
      trigger.setAttribute("aria-expanded", "false")
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
        let next_open = !has_class_name(custom, "is-open")
        close_custom_selects(Some(custom))
        toggle_class(custom, "is-open", next_open)
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
  @dom.document()
  .as_event_target()
  .addEventListener("click", fn(raw) {
    let event : @dom.MouseEvent = raw.cast()
    match event.target().closest(".tool-select-custom") {
      Some(_) => return
      None => ()
    }
    close_custom_selects(None)
  })
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
      action = "new-child"
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
            callback(percent.round().to_int())
          })
          @dom.window()
          .as_event_target()
          .addEventListener("mouseup", fn(_) {
            dragging.val = false
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
      input.as_event_target().on("blur", fn(_) { sync_editor_chrome() })
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
  schedule_render_mindmap_connectors()
}

///|
fn focus_editor(node_index : Int) -> Unit {
  match get_element("[data-editor-for=\"\{node_index}\"]") {
    Some(editor) => {
      let textarea = to_text_area(editor)
      textarea.focus()
    }
    None => ()
  }
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
  let html = @dom.document().documentElement().outerHTML()
  download_link_from_data_url(
    filename,
    "data:text/html;charset=utf-8,\{@global.encodeURIComponent(html)}",
  )
}

///|
fn collect_inline_style_text() -> String {
  let styles : Array[String] = []
  for style_element in @dom.document().querySelectorAll("style") {
    styles.push(style_element.textContent())
  }
  styles.join("\n")
}

///|
fn export_dimension(
  content_size : Double,
  mindmap_size : Double,
  minimum : Int,
) -> Int {
  if content_size > mindmap_size && content_size > minimum.to_double() {
    content_size.ceil().to_int()
  } else if mindmap_size > minimum.to_double() {
    mindmap_size.ceil().to_int()
  } else {
    minimum
  }
}

///|
fn build_mindmap_export_svg() -> String {
  match get_element("#mindmap") {
    Some(mindmap) =>
      match mindmap.querySelector(".mindmap-content") {
        Some(content) => {
          let content_rect = element_rect(content)
          let mindmap_rect = element_rect(mindmap)
          let width = export_dimension(
            content_rect.width,
            mindmap_rect.width,
            640,
          )
          let height = export_dimension(
            content_rect.height,
            mindmap_rect.height,
            360,
          )
          let pan_x = mindmap.getAttribute("data-pan-x").unwrap_or("0")
          let pan_y = mindmap.getAttribute("data-pan-y").unwrap_or("0")
          let zoom = mindmap.getAttribute("data-zoom").unwrap_or("1")
          let css = collect_inline_style_text()
          let body = content.innerHTML()
          let svg =
            $|<?xml version="1.0" encoding="UTF-8"?>
            $|<svg xmlns="http://www.w3.org/2000/svg" width="\{width}" height="\{height}" viewBox="0 0 \{width} \{height}">
            $|  <foreignObject width="100%" height="100%">
            $|    <div xmlns="http://www.w3.org/1999/xhtml" style="width:\{width}px;height:\{height}px;background:#ffffff;">
            $|      <style>\{css}</style>
            $|      <div class="mindmap" style="width:\{width}px;height:\{height}px;min-height:\{height}px;overflow:hidden;padding:20px;--pan-x:\{pan_x}px;--pan-y:\{pan_y}px;--zoom:\{zoom};"><div class="mindmap-content">\{body}</div></div>
            $|    </div>
            $|  </foreignObject>
            $|</svg>
          svg
        }
        None => ""
      }
    None => ""
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
  let svg = build_mindmap_export_svg()
  if svg.length() == 0 {
    return
  }
  let image = create_element("img", "")
  let image_element = @dom.HTMLImageElement::cast_from_element(image)
  let export_url = "data:image/svg+xml;charset=utf-8,\{@global.encodeURIComponent(svg)}"
  image_element
  .as_event_target()
  .addEventListener("load", fn(_) {
    match get_element("#mindmap") {
      Some(mindmap) =>
        match mindmap.querySelector(".mindmap-content") {
          Some(content) => {
            let canvas = create_element("canvas", "")
            let canvas_element = @dom.HTMLCanvasElement::cast_from_element(
              canvas,
            )
            let content_rect = element_rect(content)
            let mindmap_rect = element_rect(mindmap)
            let width = export_dimension(
              content_rect.width,
              mindmap_rect.width,
              640,
            )
            let height = export_dimension(
              content_rect.height,
              mindmap_rect.height,
              360,
            )
            canvas_element.width = width
            canvas_element.height = height
            let ctx : @canvas.CanvasRenderingContext2D = @core.identity(
              canvas_element.getContext("2d"),
            )
            ctx.fillStyle = "#ffffff"
            ctx.fillRect(0.0, 0.0, width.to_double(), height.to_double())
            ctx.drawImage(image_element.as_any(), 0.0, 0.0)
            download_link_from_data_url(
              filename,
              canvas_element.toDataURL(image_type="image/png"),
            )
          }
          None => ()
        }
      None => ()
    }
  })
  image_element.as_event_target().addEventListener("error", fn(_) { () })
  image_element.src = export_url
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
  match
    event
    .target()
    .closest("[data-node-index], [data-action], [data-editor-for]") {
    Some(target) => target
    None => event_target_from_point(event)
  }
}

///|
fn event_target_from_point(event : @dom.MouseEvent) -> @dom.Element {
  for element in @dom.document().elementsFromPoint(event.clientX, event.clientY) {
    match
      element.closest("[data-node-index], [data-action], [data-editor-for]") {
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
fn event_node_index_from_target(target : @dom.Element) -> Int {
  match target.closest("[data-node-index]") {
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

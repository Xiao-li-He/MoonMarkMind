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
              toggle_class(stage_element, "mindmap-stage--svg-connectors", true)
              remove_mindmap_connector_layers(content)
              if stage_has_vertical_layout(stage_element) {
                return
              }
              let nodes = content.querySelectorAll(".node[data-node-index]")
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
              let svg_paths : Array[String] = []
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
                    let pull = min_double(24.0, max_double(10.0, span * 0.22))
                    let settle = min_double(32.0, max_double(12.0, span * 0.34))
                    let mid_y = parent_center_y +
                      (node_center_y - parent_center_y) * 0.18
                    let stroke_width = if parse_int_or_default(
                        node.getAttribute("data-depth").unwrap_or("0"),
                        0,
                      ) ==
                      1 {
                      3.2
                    } else {
                      2.4
                    }
                    svg_paths.push(
                      "<path d=\"M \{double_to_svg_number(start_x)} \{double_to_svg_number(parent_center_y)} C \{double_to_svg_number(start_x + direction.to_double() * pull)} \{double_to_svg_number(mid_y)}, \{double_to_svg_number(end_x - direction.to_double() * settle)} \{double_to_svg_number(node_center_y)}, \{double_to_svg_number(end_x)} \{double_to_svg_number(node_center_y)}\" fill=\"none\" stroke=\"#7ea7d1\" stroke-width=\"\{double_to_svg_number(stroke_width)}\" stroke-linecap=\"round\" stroke-linejoin=\"round\" vector-effect=\"non-scaling-stroke\" />",
                    )
                  }
                  None => ()
                }
              }
              if svg_paths.length() == 0 {
                return
              }
              let svg_paths_html = svg_paths.iter().join("")
              let svg_html = "<svg class=\"mindmap-connector-layer\" width=\"\{width}\" height=\"\{height}\" viewBox=\"0 0 \{width} \{height}\" style=\"left:\{left}px;top:\{top}px;width:\{width}px;height:\{height}px;pointer-events:none;position:absolute;overflow:visible\">\{svg_paths_html}</svg>"
              content.insertAdjacentHTML("afterbegin", svg_html)
            }
            None => ()
          }
        None => ()
      }
    None => ()
  }
}

///|
fn remove_mindmap_connector_layers(content : @dom.Element) -> Unit {
  for
    element in content.querySelectorAll(
      ".mindmap-connector-layer, .mindmap-connector-controls, .mindmap-node-anchor",
    ) {
    element.remove()
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
extern "js" fn parse_float(raw : String) -> Double =
  #|(raw) => Number.parseFloat(raw)

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
extern "js" fn measure_input_line_metrics_raw(
  input : @dom.HTMLTextAreaElement,
) -> String =
  #|(input) => {
  #|  const style = getComputedStyle(input)
  #|  const fontSize = Number.parseFloat(style.fontSize || "16")
  #|  const lineHeightRaw = style.lineHeight || ""
  #|  const lineHeight = lineHeightRaw.length > 0 ? Number.parseFloat(lineHeightRaw) : fontSize * 1.75
  #|  const resolvedLineHeight = Number.isFinite(lineHeight) && lineHeight > 0 ? Math.round(lineHeight) : Math.round(fontSize * 1.75)
  #|  const paddingTop = Math.round(Number.parseFloat(style.paddingTop || "0"))
  #|  const paddingBottom = Math.round(Number.parseFloat(style.paddingBottom || "0"))
  #|  const paddingRight = Number.parseFloat(style.paddingRight || "0")
  #|  const paddingLeft = Number.parseFloat(style.paddingLeft || "0")
  #|  const mirror = document.createElement("div")
  #|  mirror.style.position = "absolute"
  #|  mirror.style.visibility = "hidden"
  #|  mirror.style.pointerEvents = "none"
  #|  mirror.style.inset = "0"
  #|  mirror.style.width = "100%"
  #|  mirror.style.height = "auto"
  #|  mirror.style.boxSizing = "border-box"
  #|  mirror.style.border = "0"
  #|  mirror.style.padding = `${paddingTop}px ${paddingRight}px ${paddingBottom}px ${paddingLeft}px`
  #|  mirror.style.font = style.font
  #|  mirror.style.lineHeight = style.lineHeight
  #|  mirror.style.letterSpacing = style.letterSpacing
  #|  mirror.style.tabSize = style.tabSize || "2"
  #|  mirror.style.whiteSpace = "normal"
  #|  mirror.style.wordBreak = "break-word"
  #|  mirror.style.overflowWrap = "anywhere"
  #|  mirror.style.color = style.color
  #|  mirror.style.textAlign = style.textAlign
  #|  mirror.style.direction = style.direction
  #|  const lines = input.value.split("\n")
  #|  const heights = []
  #|  const tops = []
  #|  let currentTop = paddingTop
  #|  const parent = input.parentElement || document.body || document.documentElement
  #|  const contentWidth = Math.max(1, Math.round(input.clientWidth || 1))
  #|  parent.appendChild(mirror)
  #|  mirror.style.width = `${contentWidth}px`
  #|  for (const line of lines) {
  #|    const block = document.createElement("div")
  #|    block.style.display = "block"
  #|    block.style.whiteSpace = "pre-wrap"
  #|    block.style.wordBreak = "break-word"
  #|    block.style.overflowWrap = "anywhere"
  #|    block.style.margin = "0"
  #|    block.style.padding = "0"
  #|    block.textContent = line.length > 0 ? line : " "
  #|    mirror.appendChild(block)
  #|    const contentHeight = block.getBoundingClientRect().height
  #|    const nextHeight = Math.max(Math.round(contentHeight), resolvedLineHeight)
  #|    heights.push(nextHeight)
  #|    tops.push(currentTop)
  #|    currentTop += nextHeight
  #|  }
  #|  mirror.remove()
  #|  return `${heights.join(",")}|${tops.join(",")}|${resolvedLineHeight}|${paddingTop}`
  #|}

///|
fn linked_line_html(
  metrics : InputLineMetrics,
  line_index : Int,
  scroll_top : Int,
  class_name : String,
) -> String? {
  if line_index < 0 || line_index >= metrics.heights.length() {
    None
  } else {
    let top = metrics.tops.get(line_index).unwrap_or(metrics.padding_top) -
      scroll_top
    let height = metrics.heights.get(line_index).unwrap_or(metrics.line_height)
    let block_height = if height > 1 { height } else { 1 }
    Some(
      "<div class=\"\{class_name}\" style=\"height:\{block_height}px;transform:translateY(\{top}px);opacity:1\"></div>",
    )
  }
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
  if line_indexes.length() == 0 {
    container.setInnerHTML("")
    return
  }
  let blocks = line_indexes.filter_map(fn(line_index) {
    linked_line_html(metrics, line_index, scroll_top, class_name)
  })
  container.setInnerHTML(blocks.iter().join(""))
}

///|
fn sync_input_line_numbers(
  input : @dom.HTMLTextAreaElement,
  metrics : InputLineMetrics,
) -> Unit {
  match get_element("#input-gutter") {
    Some(gutter) => {
      let heights = if metrics.heights.length() > 0 {
        metrics.heights
      } else {
        [metrics.line_height]
      }
      let blocks : Array[String] = []
      let mut line_number = 1
      for height in heights {
        let block_height = if height > 1 { height } else { 1 }
        blocks.push(
          "<div class=\"editor-gutter-number\" style=\"height:\{block_height}px\">\{line_number}</div>",
        )
        line_number += 1
      }
      gutter.setInnerHTML(blocks.iter().join(""))
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
  _line_index_at_offset_js(value, offset)
}

///|
extern "js" fn _line_index_at_offset_js(value : String, offset : Int) -> Int =
  #|(value, offset) => value.slice(0, offset).split("\n").length - 1

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
extern "js" fn set_input_selection_range_by_line(
  input : @dom.HTMLTextAreaElement,
  line_index : Int,
) =
  #|(input, lineIndex) => {
  #|  const lines = input.value.split("\n")
  #|  if (lineIndex == null || lineIndex < 0 || lineIndex >= lines.length) return
  #|  const start = lines.slice(0, lineIndex).join("\n").length + (lineIndex === 0 ? 0 : lineIndex)
  #|  const end = start + lines[lineIndex].length
  #|  input.focus()
  #|  input.setSelectionRange(start, end)
  #|}

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
              trigger.setTextContent(next_text)
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
      let doc = @dom.document()
      let custom = doc.createElement("div")
      custom.setClassName("tool-select-custom")
      let trigger = doc.createElement("button")
      trigger.setAttribute("type", "button")
      trigger.setClassName("tool-select-trigger")
      trigger.setAttribute("aria-haspopup", "listbox")
      trigger.setAttribute("aria-expanded", "false")
      let menu = doc.createElement("div")
      menu.setClassName("tool-select-menu")
      menu.setAttribute("role", "listbox")
      for child in select.children() {
        let option = @dom.HTMLOptionElement::cast_from_element(child)
        if option.hasAttribute("hidden") {
          continue
        }
        let option_value = option.value
        let option_text = option.textContent()
        let option_button = doc.createElement("button")
        option_button.setAttribute("type", "button")
        option_button.setClassName("tool-select-option")
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
  sample_callback : () -> Unit,
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
  match get_element("#load-sample") {
    Some(button) =>
      button
      .as_event_target()
      .addEventListener("click", fn(_) { sample_callback() })
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
fn set_mindmap_html(value : String) -> Unit {
  match get_element("#mindmap") {
    Some(mindmap) => {
      let pan_x = mindmap.getAttribute("data-pan-x").unwrap_or("0")
      let pan_y = mindmap.getAttribute("data-pan-y").unwrap_or("0")
      let zoom = mindmap.getAttribute("data-zoom").unwrap_or("1")
      mindmap.setAttribute("data-pan-x", pan_x)
      mindmap.setAttribute("data-pan-y", pan_y)
      mindmap.setAttribute("data-zoom", zoom)
      mindmap.setInnerHTML("<div class=\"mindmap-content\">\{value}</div>")
      let style = @dom.css_style_from_val(mindmap.as_any()._get("style").cast())
      style.set_property("--pan-x", "\{pan_x}px")
      style.set_property("--pan-y", "\{pan_y}px")
      style.set_property("--zoom", zoom)
      let zoom_percent = (parse_float(zoom) * 100.0).round().to_int()
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
extern "js" fn pick_markdown_file(callback : (String, String) -> Unit) =
  #|(callback) => {
  #|  const input = document.createElement("input")
  #|  input.type = "file"
  #|  input.accept = ".md,.markdown,text/markdown,text/plain"
  #|  input.addEventListener("change", async () => {
  #|    const file = input.files?.[0]
  #|    if (!file) return
  #|    callback(file.name || "notes.md", await file.text())
  #|  })
  #|  input.click()
  #|}

///|
extern "js" fn download_text(filename : String, content : String) =
  #|(filename, content) => {
  #|  const blob = new Blob([content], { type: "text/plain;charset=utf-8" })
  #|  const url = URL.createObjectURL(blob)
  #|  const link = document.createElement("a")
  #|  link.href = url
  #|  link.download = filename
  #|  document.body.appendChild(link)
  #|  link.click()
  #|  link.remove()
  #|  URL.revokeObjectURL(url)
  #|}

///|
extern "js" fn download_current_page_html(filename : String) =
  #|(filename) => {
  #|  const html = document.documentElement.outerHTML
  #|  const blob = new Blob([html], { type: "text/html;charset=utf-8" })
  #|  const url = URL.createObjectURL(blob)
  #|  const link = document.createElement("a")
  #|  link.href = url
  #|  link.download = filename
  #|  document.body.appendChild(link)
  #|  link.click()
  #|  link.remove()
  #|  URL.revokeObjectURL(url)
  #|}

///|
extern "js" fn download_mindmap_svg(filename : String) =
  #|(filename) => {
  #|  const svg = (() => {
  #|    const mindmap = document.querySelector("#mindmap")
  #|    if (!mindmap) return null
  #|    const content = mindmap.querySelector(".mindmap-content")
  #|    const contentRect = content?.getBoundingClientRect()
  #|    const width = Math.max(Math.ceil(contentRect?.width ?? 0), Math.ceil(mindmap.getBoundingClientRect().width), 640)
  #|    const height = Math.max(Math.ceil(contentRect?.height ?? 0), Math.ceil(mindmap.getBoundingClientRect().height), 360)
  #|    const styles = [...document.querySelectorAll("style")]
  #|      .map((node) => node.textContent ?? "")
  #|      .join("\n")
  #|    const panX = Number(mindmap.dataset.panX ?? "0")
  #|    const panY = Number(mindmap.dataset.panY ?? "0")
  #|    const zoom = Number(mindmap.dataset.zoom ?? "1")
  #|    const body = content?.innerHTML ?? ""
  #|    return `<?xml version="1.0" encoding="UTF-8"?>
  #|<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}">
  #|  <foreignObject width="100%" height="100%">
  #|    <div xmlns="http://www.w3.org/1999/xhtml" style="width:${width}px;height:${height}px;background:#ffffff;">
  #|      <style>${styles}</style>
  #|      <div class="mindmap" style="width:${width}px;height:${height}px;min-height:${height}px;overflow:hidden;padding:20px;--pan-x:${panX}px;--pan-y:${panY}px;--zoom:${zoom};"><div class="mindmap-content">${body}</div></div>
  #|    </div>
  #|  </foreignObject>
  #|</svg>`
  #|  })()
  #|  if (!svg) return
  #|  const blob = new Blob([svg], { type: "image/svg+xml;charset=utf-8" })
  #|  const url = URL.createObjectURL(blob)
  #|  const link = document.createElement("a")
  #|  link.href = url
  #|  link.download = filename
  #|  document.body.appendChild(link)
  #|  link.click()
  #|  link.remove()
  #|  URL.revokeObjectURL(url)
  #|}

///|
extern "js" fn download_mindmap_png(filename : String) =
  #|(filename) => {
  #|  const mindmap = document.querySelector("#mindmap")
  #|  if (!mindmap) return
  #|  const content = mindmap.querySelector(".mindmap-content")
  #|  const contentRect = content?.getBoundingClientRect()
  #|  const width = Math.max(Math.ceil(contentRect?.width ?? 0), Math.ceil(mindmap.getBoundingClientRect().width), 640)
  #|  const height = Math.max(Math.ceil(contentRect?.height ?? 0), Math.ceil(mindmap.getBoundingClientRect().height), 360)
  #|  const styles = [...document.querySelectorAll("style")]
  #|    .map((node) => node.textContent ?? "")
  #|    .join("\n")
  #|  const panX = Number(mindmap.dataset.panX ?? "0")
  #|  const panY = Number(mindmap.dataset.panY ?? "0")
  #|  const zoom = Number(mindmap.dataset.zoom ?? "1")
  #|  const body = content?.innerHTML ?? ""
  #|  const svg = `<?xml version="1.0" encoding="UTF-8"?>
  #|<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}">
  #|  <foreignObject width="100%" height="100%">
  #|    <div xmlns="http://www.w3.org/1999/xhtml" style="width:${width}px;height:${height}px;background:#ffffff;">
  #|      <style>${styles}</style>
  #|      <div class="mindmap" style="width:${width}px;height:${height}px;min-height:${height}px;overflow:hidden;padding:20px;--pan-x:${panX}px;--pan-y:${panY}px;--zoom:${zoom};"><div class="mindmap-content">${body}</div></div>
  #|    </div>
  #|  </foreignObject>
  #|</svg>`
  #|  const blob = new Blob([svg], { type: "image/svg+xml;charset=utf-8" })
  #|  const url = URL.createObjectURL(blob)
  #|  const image = new Image()
  #|  image.onload = () => {
  #|    const canvas = document.createElement("canvas")
  #|    canvas.width = width
  #|    canvas.height = height
  #|    const ctx = canvas.getContext("2d")
  #|    if (!ctx) {
  #|      URL.revokeObjectURL(url)
  #|      return
  #|    }
  #|    ctx.fillStyle = "#ffffff"
  #|    ctx.fillRect(0, 0, width, height)
  #|    ctx.drawImage(image, 0, 0)
  #|    canvas.toBlob((pngBlob) => {
  #|      URL.revokeObjectURL(url)
  #|      if (!pngBlob) return
  #|      const pngUrl = URL.createObjectURL(pngBlob)
  #|      const link = document.createElement("a")
  #|      link.href = pngUrl
  #|      link.download = filename
  #|      document.body.appendChild(link)
  #|      link.click()
  #|      link.remove()
  #|      URL.revokeObjectURL(pngUrl)
  #|    }, "image/png")
  #|  }
  #|  image.onerror = () => URL.revokeObjectURL(url)
  #|  image.src = url
  #|}

///|
fn event_action_from_point(event : @dom.MouseEvent) -> String {
  let target = event_target_from_point(event)
  match target.closest("[data-action]") {
    Some(action) => action.getAttribute("data-action").unwrap_or("")
    None => ""
  }
}

///|
extern "js" fn event_target_from_point(event : @dom.MouseEvent) -> @dom.Element =
  #|(event) => {
  #|  const stack = document.elementsFromPoint(event.clientX, event.clientY)
  #|  for (const element of stack) {
  #|    const target = element.closest?.("[data-node-index], [data-action], [data-editor-for]")
  #|    if (target) return target
  #|  }
  #|  return document.elementFromPoint(event.clientX, event.clientY) ?? event.target
  #|}

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
  event_node_index_from_target(event_target_from_point(event))
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
extern "js" fn set_drag_text(event : @dom.DragEvent, value : String) =
  #|(event, value) => {
  #|  if (!event.dataTransfer) return
  #|  event.dataTransfer.effectAllowed = "move"
  #|  event.dataTransfer.setData("text/plain", value)
  #|}

///|
extern "js" fn clear_drop_highlights() =
  #|() => {
  #|  for (const element of document.querySelectorAll(".drop-before, .drop-after")) {
  #|    element.classList.remove("drop-before", "drop-after")
  #|  }
  #|}

///|
extern "js" fn highlight_drop_target(node_index : Int, place_after : Bool) =
  #|(nodeIndex, placeAfter) => {
  #|  for (const element of document.querySelectorAll(".drop-before, .drop-after")) {
  #|    element.classList.remove("drop-before", "drop-after")
  #|  }
  #|  const card = document.querySelector(`[data-node-index="${nodeIndex}"]`)
  #|  if (!card) return
  #|  card.classList.add(placeAfter ? "drop-after" : "drop-before")
  #|}

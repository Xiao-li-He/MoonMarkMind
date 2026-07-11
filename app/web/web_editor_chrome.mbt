///|
/// Textarea chrome that mirrors browser line layout.
///
/// The editor gutter, active line, hover line, and heading selection all use
/// measured DOM line heights so wrapped markdown stays visually aligned.
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
/// Synchronize all textarea overlay layers with the measured input layout.
///
/// This keeps line numbers, active highlights, hover rows, and linked heading
/// rows aligned when markdown wraps or the textarea scroll position changes.
fn sync_editor_chrome() -> Unit {
  // Keep textarea overlays aligned with the real browser layout. This depends
  // on measured font metrics, so it lives outside the pure outline model.
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
  source_line : Int
  height : Int
  show_number : Bool
  show_fold_button : Bool
  folded : Bool
  placeholder : Bool
}

///|
priv struct LineLayerBounds {
  top : Int
  height : Int
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
/// Collapse measured logical lines into visual gutter rows.
///
/// Wrapped continuation rows intentionally omit repeated numbers while keeping
/// fold controls attached to the source line that owns them.
fn gutter_visual_rows(metrics : InputLineMetrics) -> Array[GutterVisualRow] {
  let rows : Array[GutterVisualRow] = []
  let heights = if metrics.heights.length() > 0 {
    metrics.heights
  } else {
    [resolved_metric_line_height(metrics)]
  }
  let projection = current_editor_projection.val
  for visible_line, height in heights {
    let source_line = projection.visible_line_to_source_line
      .get(visible_line)
      .unwrap_or(-1)
    let placeholder = visible_line_is_fold_placeholder(visible_line)
    let line_number = if source_line >= 0 && !placeholder {
      source_line + 1
    } else {
      0
    }
    let heading = source_line >= 0 &&
      !placeholder &&
      is_heading_source_line(app_state.markdown, source_line)
    let folded = contains_int(app_state.folded_heading_lines, source_line)
    for
      visual_index, visual_height in measure_mirror_line_heights(
        height,
        metrics.line_height,
      ) {
      rows.push(GutterVisualRow::{
        line_number,
        source_line,
        height: visual_height,
        show_number: visual_index == 0,
        show_fold_button: heading && visual_index == 0 && !placeholder,
        folded,
        placeholder,
      })
    }
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
/// Measure the textarea line layout using the hidden mirror element.
///
/// Browser text wrapping is layout-dependent, so the editor chrome uses these
/// DOM measurements instead of trying to predict line heights from markdown.
fn input_line_metrics(input : @dom.HTMLTextAreaElement) -> InputLineMetrics {
  let raw = measure_input_line_metrics_raw(input)
  let parts = raw.split("|".view()).to_array()
  if parts.length() != 4 {
    return input_line_metrics_fallback(input)
  }
  let heights = parse_int_list(parts[0])
  let tops = parse_int_list(parts[1])
  let line_height = parse_int_or_default(parts[2].to_owned(), 28)
  let padding_top = parse_int_or_default(parts[3].to_owned(), 18)
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
    let parsed = @string.parse_int(trimmed) catch { _ => -1 }
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
    let raw_line = line.to_owned()
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
fn build_gutter_number_dom(row : GutterVisualRow, height : Int) -> @dom.Element {
  let block = create_element("div", "editor-gutter-number")
  let block_height = if height > 1 { height } else { 1 }
  let style = @dom.css_style_from_val(block.as_any()._get("style").cast())
  style.set_property("height", "\{block_height}px")
  let number = create_element("span", "editor-gutter-number__text")
  if row.show_number && row.line_number > 0 && !row.placeholder {
    number.setTextContent(row.line_number.to_string())
  } else {
    number.setTextContent("")
  }
  append_child(block, number)
  if row.show_number && row.show_fold_button {
    let button = create_element("button", "editor-fold-button")
    button.setAttribute("type", "button")
    button.setAttribute("data-action", "toggle-heading-fold")
    button.setAttribute("data-source-line", row.source_line.to_string())
    button.setAttribute(
      "aria-label",
      if row.folded {
        "Expand heading"
      } else {
        "Collapse heading"
      },
    )
    button.setAttribute(
      "data-tip",
      if row.folded {
        "Expand"
      } else {
        "Collapse"
      },
    )
    button.setAttribute("aria-expanded", (!row.folded).to_string())
    append_child(button, build_editor_fold_icon_dom(row.folded))
    button
    .as_event_target()
    .on("click", fn(raw) {
      let event : @dom.MouseEvent = raw.cast()
      event.preventDefault()
      event.stopPropagation()
      toggle_heading_fold(row.source_line)
    })
    append_child(block, button)
  } else {
    append_child(block, create_element("span", "editor-fold-spacer"))
  }
  block
}

///|
fn build_editor_fold_icon_dom(folded : Bool) -> @dom.Element {
  let svg = create_svg_element("svg", "")
  svg.setAttribute("viewBox", "0 0 16 16")
  svg.setAttribute("width", "14")
  svg.setAttribute("height", "14")
  svg.setAttribute("aria-hidden", "true")
  svg.setAttribute("focusable", "false")
  svg.setAttribute("fill", "none")
  svg.setAttribute("stroke", "currentColor")
  svg.setAttribute("stroke-width", "2")
  svg.setAttribute("stroke-linecap", "round")
  svg.setAttribute("stroke-linejoin", "round")
  if folded {
    append_child(svg, build_svg_path("M6 4L10 8L6 12"))
  } else {
    append_child(svg, build_svg_path("M4 6L8 10L12 6"))
  }
  svg
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
        append_child(gutter, build_gutter_number_dom(row, row.height))
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
    let parsed = @string.parse_int(trimmed) catch { _ => -1 }
    if parsed >= 0 && !values.contains(parsed) {
      values.push(parsed)
    }
  }
  values
}

///|
/// Return the heading nodes covered by the current textarea selection.
///
/// Body lines map back to their owning heading so editor selection can drive
/// mindmap selection without requiring the cursor to sit on a heading line.
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
  if range_start == range_end {
    let node_index = markdown_node_index_at_line(
      app_state.markdown,
      visible_line_to_source_line(start_line),
    )
    if node_index >= 0 {
      return [node_index]
    }
  }
  let lines = app_state.markdown.split("\n".view()).to_array()
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
      if pair.0 == visible_line_to_source_line(start_line) {
        return [pair.1]
      }
    }
    return []
  }
  for line_index in start_line..<=end_line {
    let source_line = visible_line_to_source_line(line_index)
    let mut structural = false
    for pair in structural_line_indexes {
      if pair.0 == source_line {
        structural = true
        break
      }
    }
    if !structural {
      return []
    }
  }
  let result : Array[Int] = []
  let source_start = visible_line_to_source_line(start_line)
  let source_end = visible_line_to_source_line(end_line)
  for pair in structural_line_indexes {
    if pair.0 >= source_start && pair.0 <= source_end {
      result.push(pair.1)
    }
  }
  result
}

///|
fn markdown_node_index_at_line(markdown : String, line_index : Int) -> Int {
  if line_index < 0 {
    return -1
  }
  let nodes = @outline_parser.parse_markdown_nodes(markdown)
  for index in 0..<nodes.length() {
    let node = nodes[index]
    if node.source_line == line_index {
      return index
    }
    for block_index in 0..<node.body.length() {
      match markdown_node_body_block_line_range(node, block_index) {
        Some((start_line, end_line)) =>
          if line_index >= start_line && line_index <= end_line {
            return index
          }
        None => ()
      }
    }
  }
  -1
}

///|
fn should_notify_selected_headings(
  next_key : String,
  last_key : String,
  force_reveal : Bool,
) -> Bool {
  next_key != last_key || (force_reveal && next_key.length() > 0)
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
  if source_line_to_visible_line(line_index) < 0 &&
    unfold_hidden_source_line(line_index) {
    reveal_input_line(line_index)
    return
  }
  let visible_line = source_line_to_visible_line(line_index)
  let target_line = if visible_line >= 0 { visible_line } else { line_index }
  match get_element("#input") {
    Some(input_element) => {
      let input = @dom.HTMLTextAreaElement::cast_from_element(input_element)
      let metrics = input_line_metrics(input)
      if target_line >= metrics.heights.length() {
        return
      }
      let line_top = metric_line_top(metrics, target_line)
      let line_height = metric_line_height(metrics, target_line)
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
fn input_offset_for_line(value : String, line_index : Int) -> Int {
  if line_index <= 0 {
    return 0
  }
  let mut line = 0
  for index in 0..<value.length() {
    if line == line_index {
      return index
    }
    if value[index] == '\n' {
      line += 1
    }
  }
  value.length()
}

///|
fn input_offset_after_line(value : String, line_index : Int) -> Int {
  if line_index < 0 {
    return 0
  }
  let mut line = 0
  for index in 0..<value.length() {
    if line == line_index && value[index] == '\n' {
      return index
    }
    if value[index] == '\n' {
      line += 1
    }
  }
  value.length()
}

///|
fn focus_input_line_range(start_line : Int, end_line : Int) -> Unit {
  if source_line_to_visible_line(start_line) < 0 &&
    unfold_hidden_source_line(start_line) {
    focus_input_line_range(start_line, end_line)
    return
  }
  let visible_start = source_line_to_visible_line(start_line)
  let visible_end = source_line_to_visible_line(end_line)
  let start = if visible_start >= 0 {
    visible_start
  } else if start_line < 0 {
    0
  } else {
    start_line
  }
  let stop = if visible_end >= 0 {
    visible_end
  } else if end_line < start {
    start
  } else {
    end_line
  }
  match get_element("#input") {
    Some(input_element) => {
      let input = @dom.HTMLTextAreaElement::cast_from_element(input_element)
      let start_offset = input_offset_for_line(input.value, start)
      let end_offset = input_offset_after_line(input.value, stop)
      input.as_any()._call("focus", []) |> ignore
      input
      .as_any()
      ._call("setSelectionRange", [
        @core.any(start_offset),
        @core.any(end_offset),
      ])
      |> ignore
      reveal_input_line(start)
      sync_editor_chrome()
    }
    None => ()
  }
}

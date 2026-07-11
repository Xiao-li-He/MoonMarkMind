///|
/// Shared browser DOM helpers used by the MoonBit frontend.
///
/// Larger DOM features live in adjacent files; this file keeps the small
/// element lookup, tooltip, geometry, parsing, and class helpers together.
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

///|
fn parse_double_or_default(raw : String, fallback : Double) -> Double {
  if raw.length() == 0 {
    fallback
  } else {
    @string.parse_double(raw.view()) catch {
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
fn toggle_class(
  element : @dom.Element,
  class_name : String,
  enabled : Bool,
) -> Unit {
  let tokens : Array[String] = element
    .className()
    .split(" ")
    .map(token => token.to_owned())
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
    .getAttribute("class")
    .unwrap_or("")
    .split(" ")
    .map(token => token.to_owned())
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

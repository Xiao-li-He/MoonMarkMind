///|
fn mindmap_set_body_user_select(user_select : String) -> Unit {
  match @dom.document().body() {
    Some(body) => {
      let style = @dom.css_style_from_val(body.as_any()._get("style").cast())
      style.set_property("user-select", user_select)
    }
    None => ()
  }
}

///|
fn mindmap_clear_body_user_select() -> Unit {
  match @dom.document().body() {
    Some(body) => {
      let style = @dom.css_style_from_val(body.as_any()._get("style").cast())
      ignore(style.remove_property("user-select"))
    }
    None => ()
  }
}

///|
fn mindmap_clamp_zoom(value : Double) -> Double {
  if value < 0.4 {
    0.4
  } else if value > 2.0 {
    2.0
  } else {
    value
  }
}

///|
fn mindmap_current_zoom(mindmap : @dom.Element) -> Double {
  let raw = mindmap.getAttribute("data-zoom").unwrap_or("1")
  let value = parse_float(raw)
  if value != value {
    1.0
  } else {
    value
  }
}

///|
fn mindmap_sync_zoom_display(
  zoom_value : @dom.Element?,
  zoom_edit : @dom.Element?,
  zoom : Double,
) -> Unit {
  let percent = (zoom * 100.0).round().to_int()
  match zoom_value {
    Some(value) => value.setTextContent("\{percent}%")
    None => ()
  }
  match zoom_edit {
    Some(edit) =>
      @dom.HTMLInputElement::cast_from_element(edit).value = "\{percent}%"
    None => ()
  }
}

///|
fn mindmap_set_zoom_editing(editing : Bool) -> Unit {
  match get_element(".zoom-strip") {
    Some(strip) => {
      toggle_class(strip, "is-editing", editing)
      match strip.querySelector(".zoom-value") {
        Some(value) => {
          let style = @dom.css_style_from_val(
            value.as_any()._get("style").cast(),
          )
          style.set_property("display", if editing { "none" } else { "block" })
        }
        None => ()
      }
      match strip.querySelector(".zoom-edit") {
        Some(edit) => {
          let style = @dom.css_style_from_val(
            edit.as_any()._get("style").cast(),
          )
          style.set_property("display", if editing { "block" } else { "none" })
        }
        None => ()
      }
    }
    None => ()
  }
}

///|
fn mindmap_sync_view(
  mindmap : @dom.Element,
  zoom_value : @dom.Element?,
  zoom_edit : @dom.Element?,
) -> Unit {
  let pan_x = mindmap.getAttribute("data-pan-x").unwrap_or("0")
  let pan_y = mindmap.getAttribute("data-pan-y").unwrap_or("0")
  let zoom = mindmap_current_zoom(mindmap)
  let style = @dom.css_style_from_val(mindmap.as_any()._get("style").cast())
  style.set_property("--pan-x", "\{pan_x}px")
  style.set_property("--pan-y", "\{pan_y}px")
  style.set_property("--zoom", zoom.to_string())
  mindmap_sync_zoom_display(zoom_value, zoom_edit, zoom)
}

///|
fn mindmap_schedule_connectors(
  frame : @ref.Ref[Int],
  window : @dom.Window,
) -> Unit {
  if frame.val != 0 {
    window.cancelAnimationFrame(frame.val)
  }
  let expected_cycle = current_mindmap_render_cycle()
  frame.val = window.requestAnimationFrame(fn(_) {
    frame.val = 0
    if !mindmap_render_cycle_matches(expected_cycle) {
      return
    }
    render_mindmap_connectors()
  })
}

///|
fn mouse_delta_exceeds_pan_threshold(
  start_x : Int,
  start_y : Int,
  next_x : Int,
  next_y : Int,
) -> Bool {
  let delta_x = if next_x >= start_x {
    next_x - start_x
  } else {
    start_x - next_x
  }
  let delta_y = if next_y >= start_y {
    next_y - start_y
  } else {
    start_y - next_y
  }
  delta_x >= 4 || delta_y >= 4
}

///|
fn mindmap_can_pan(target : @dom.Element) -> Bool {
  match
    target.closest(
      ".node, .node-action, .node-note-rail, .node-editor, .node-note-editor, [data-action], [data-editor-for], [data-note-editor-for], button, input, textarea",
    ) {
    Some(_) => false
    None => true
  }
}

///|
fn mindmap_parse_zoom_input(raw : String) -> Double? {
  let trimmed = raw.trim()
  if trimmed.length() == 0 {
    return None
  }
  let numeric = parse_float(trimmed.to_string().replace(old="%", new=""))
  if numeric != numeric {
    None
  } else if trimmed.contains("%") || numeric > 10.0 {
    Some(numeric / 100.0)
  } else {
    Some(numeric)
  }
}

///|
fn mindmap_apply_zoom(
  mindmap : @dom.Element,
  zoom_value : @dom.Element?,
  zoom_edit : @dom.Element?,
  frame : @ref.Ref[Int],
  window : @dom.Window,
  next_zoom : Double,
) -> Unit {
  let clamped = mindmap_clamp_zoom(next_zoom)
  mindmap.setAttribute("data-zoom", clamped.to_string())
  mindmap_sync_view(mindmap, zoom_value, zoom_edit)
  mindmap_schedule_connectors(frame, window)
}

///|
fn mindmap_fit_to_view(
  mindmap : @dom.Element,
  zoom_value : @dom.Element?,
  zoom_edit : @dom.Element?,
  frame : @ref.Ref[Int],
  window : @dom.Window,
) -> Unit {
  match mindmap.querySelector(".mindmap-stage") {
    Some(stage) => {
      let viewport_width = mindmap.clientWidth().to_double() - 24.0
      let viewport_height = mindmap.clientHeight().to_double() - 24.0
      let stage_width = stage.clientWidth().to_double()
      let stage_height = stage.clientHeight().to_double()
      if viewport_width <= 0.0 ||
        viewport_height <= 0.0 ||
        stage_width <= 0.0 ||
        stage_height <= 0.0 {
        return
      }
      let next_zoom = if viewport_width / stage_width <
        viewport_height / stage_height {
        viewport_width / stage_width
      } else {
        viewport_height / stage_height
      }
      mindmap.setAttribute("data-pan-x", "0")
      mindmap.setAttribute("data-pan-y", "0")
      mindmap_apply_zoom(
        mindmap, zoom_value, zoom_edit, frame, window, next_zoom,
      )
    }
    None => {
      mindmap.setAttribute("data-pan-x", "0")
      mindmap.setAttribute("data-pan-y", "0")
      mindmap_apply_zoom(mindmap, zoom_value, zoom_edit, frame, window, 1.0)
    }
  }
}

///|
fn mindmap_root_anchor_fraction(stage : @dom.Element) -> (Double, Double) {
  if has_class_name(stage, "mindmap-stage--vertical") {
    (0.5, 0.125)
  } else if has_class_name(stage, "mindmap-stage--single-right") {
    (0.125, 0.5)
  } else {
    (0.5, 0.5)
  }
}

///|
fn schedule_mindmap_recenter_current_view() -> Unit {
  match get_element("#mindmap") {
    Some(mindmap) => {
      let window = @dom.window()
      ignore(
        window.requestAnimationFrame(fn(_) {
          ignore(
            window.requestAnimationFrame(fn(_) {
              let frame = @ref.Ref(0)
              mindmap_recenter_pan(
                mindmap,
                get_element("#zoom-value"),
                get_element("#zoom-edit"),
                frame,
                window,
              )
            }),
          )
        }),
      )
    }
    None => ()
  }
}

///|
fn mindmap_recenter_pan(
  mindmap : @dom.Element,
  zoom_value : @dom.Element?,
  zoom_edit : @dom.Element?,
  frame : @ref.Ref[Int],
  window : @dom.Window,
) -> Unit {
  match mindmap.querySelector(".mindmap-stage") {
    Some(stage) => {
      match stage.querySelector(".node[data-parent-index=\"-1\"]") {
        Some(root) => {
          let mindmap_rect = element_rect(mindmap)
          let root_rect = element_rect(root)
          let (anchor_x, anchor_y) = mindmap_root_anchor_fraction(stage)
          let target_x = mindmap_rect.left + mindmap_rect.width * anchor_x
          let target_y = mindmap_rect.top + mindmap_rect.height * anchor_y
          let current_pan_x = parse_int_or_default(
            mindmap.getAttribute("data-pan-x").unwrap_or("0"),
            0,
          )
          let current_pan_y = parse_int_or_default(
            mindmap.getAttribute("data-pan-y").unwrap_or("0"),
            0,
          )
          let next_pan_x = current_pan_x.to_double() +
            target_x -
            rect_center_x(root_rect)
          let next_pan_y = current_pan_y.to_double() +
            target_y -
            rect_center_y(root_rect)
          mindmap.setAttribute(
            "data-pan-x",
            next_pan_x.round().to_int().to_string(),
          )
          mindmap.setAttribute(
            "data-pan-y",
            next_pan_y.round().to_int().to_string(),
          )
        }
        None => {
          mindmap.setAttribute("data-pan-x", "0")
          mindmap.setAttribute("data-pan-y", "0")
        }
      }
      mindmap_sync_view(mindmap, zoom_value, zoom_edit)
      mindmap_schedule_connectors(frame, window)
    }
    None => {
      mindmap.setAttribute("data-pan-x", "0")
      mindmap.setAttribute("data-pan-y", "0")
      mindmap_sync_view(mindmap, zoom_value, zoom_edit)
      mindmap_schedule_connectors(frame, window)
    }
  }
}

///|
fn focus_mindmap() -> Unit {
  match get_element("#mindmap") {
    Some(mindmap) => @dom.HTMLElement::cast_from_element(mindmap).focus()
    None => ()
  }
}

///|
fn bind_mindmap_ui(
  click_callback : (@dom.MouseEvent) -> Unit,
  dblclick_callback : (@dom.MouseEvent) -> Unit,
  keydown_callback : (@dom.KeyboardEvent) -> Unit,
  focusout_callback : (@dom.FocusEvent) -> Unit,
  input_callback : (@dom.Event) -> Unit,
  dragstart_callback : (@dom.DragEvent) -> Unit,
  dragend_callback : (@dom.DragEvent) -> Unit,
  dragover_callback : (@dom.DragEvent) -> Unit,
  drop_callback : (@dom.DragEvent) -> Unit,
) -> Unit {
  match get_element("#mindmap") {
    Some(mindmap) => {
      mindmap.setAttribute("tabindex", "0")
      let window = @dom.window()
      let zoom_in = get_element("#zoom-in")
      let zoom_out = get_element("#zoom-out")
      let zoom_value = get_element("#zoom-value")
      let zoom_edit = get_element("#zoom-edit")
      let fit_view = get_element("#fit-view")
      let recenter_view = get_element("#recenter-view")
      let connector_frame = @ref.Ref(0)
      let panning = @ref.Ref(false)
      let pan_moved = @ref.Ref(false)
      let suppress_click = @ref.Ref(false)
      let start_x = @ref.Ref(0)
      let start_y = @ref.Ref(0)
      let start_pan_x = @ref.Ref(0)
      let start_pan_y = @ref.Ref(0)

      mindmap
      .as_event_target()
      .on("click", fn(raw) {
        let event : @dom.MouseEvent = raw.cast()
        focus_mindmap_container(mindmap, event.target())
        if suppress_click.val {
          suppress_click.val = false
          event.preventDefault()
          event.stopPropagation()
          return
        }
        click_callback(event)
      })
      mindmap
      .as_event_target()
      .on("dblclick", fn(raw) {
        let event : @dom.MouseEvent = raw.cast()
        if mindmap_can_pan(event.target()) {
          event.preventDefault()
          event.stopPropagation()
          suppress_click.val = false
          mindmap_recenter_pan(
            mindmap, zoom_value, zoom_edit, connector_frame, window,
          )
          return
        }
        suppress_click.val = false
        dblclick_callback(event)
      })
      mindmap
      .as_event_target()
      .on("keydown", fn(raw) { keydown_callback(raw.cast()) })
      mindmap
      .as_event_target()
      .on("focusout", fn(raw) { focusout_callback(raw.cast()) })
      mindmap
      .as_event_target()
      .on("input", fn(raw) { input_callback(raw.cast()) })
      mindmap
      .as_event_target()
      .on(
        "wheel",
        fn(raw) {
          let event : @dom.WheelEvent = raw.cast()
          if event.deltaY == 0.0 {
            return
          }
          event.preventDefault()
          mindmap_apply_zoom(
            mindmap,
            zoom_value,
            zoom_edit,
            connector_frame,
            window,
            mindmap_current_zoom(mindmap) * @math.exp(-event.deltaY * 0.0018),
          )
        },
        passive=false,
      )
      mindmap
      .as_event_target()
      .on("dragstart", fn(raw) { dragstart_callback(raw.cast()) })
      mindmap
      .as_event_target()
      .on("dragend", fn(raw) { dragend_callback(raw.cast()) })
      mindmap
      .as_event_target()
      .on("dragover", fn(raw) { dragover_callback(raw.cast()) })
      mindmap
      .as_event_target()
      .on("drop", fn(raw) { drop_callback(raw.cast()) })
      mindmap
      .as_event_target()
      .on("mousedown", fn(raw) {
        let event : @dom.MouseEvent = raw.cast()
        focus_mindmap_container(mindmap, event.target())
        if !mindmap_can_pan(event.target()) {
          return
        }
        panning.val = true
        pan_moved.val = false
        suppress_click.val = false
        start_x.val = event.clientX.to_int()
        start_y.val = event.clientY.to_int()
        start_pan_x.val = @strconv.parse_int(
          mindmap.getAttribute("data-pan-x").unwrap_or("0"),
        ) catch {
          _ => 0
        }
        start_pan_y.val = @strconv.parse_int(
          mindmap.getAttribute("data-pan-y").unwrap_or("0"),
        ) catch {
          _ => 0
        }
        toggle_class(mindmap, "is-panning", true)
        mindmap_set_body_user_select("none")
        event.preventDefault()
      })

      window
      .as_event_target()
      .on("mousemove", fn(raw) {
        if !panning.val {
          return
        }
        let event : @dom.MouseEvent = raw.cast()
        if mouse_delta_exceeds_pan_threshold(
            start_x.val,
            start_y.val,
            event.clientX.to_int(),
            event.clientY.to_int(),
          ) {
          pan_moved.val = true
        }
        let next_pan_x = start_pan_x.val + event.clientX.to_int() - start_x.val
        let next_pan_y = start_pan_y.val + event.clientY.to_int() - start_y.val
        mindmap.setAttribute("data-pan-x", next_pan_x.to_string())
        mindmap.setAttribute("data-pan-y", next_pan_y.to_string())
        mindmap_sync_view(mindmap, zoom_value, zoom_edit)
      })
      window
      .as_event_target()
      .on("mouseup", fn(_) {
        if !panning.val {
          return
        }
        panning.val = false
        if pan_moved.val {
          suppress_click.val = true
        }
        toggle_class(mindmap, "is-panning", false)
        mindmap_clear_body_user_select()
        mindmap_schedule_connectors(connector_frame, window)
      })
      window
      .as_event_target()
      .on("resize", fn(_) {
        mindmap_schedule_connectors(connector_frame, window)
      })

      match zoom_out {
        Some(control) =>
          control
          .as_event_target()
          .on("click", fn(_) {
            mindmap_apply_zoom(
              mindmap,
              zoom_value,
              zoom_edit,
              connector_frame,
              window,
              mindmap_current_zoom(mindmap) - 0.1,
            )
          })
        None => ()
      }
      match zoom_in {
        Some(control) =>
          control
          .as_event_target()
          .on("click", fn(_) {
            mindmap_apply_zoom(
              mindmap,
              zoom_value,
              zoom_edit,
              connector_frame,
              window,
              mindmap_current_zoom(mindmap) + 0.1,
            )
          })
        None => ()
      }
      match zoom_value {
        Some(control) =>
          control
          .as_event_target()
          .on("dblclick", fn(raw) {
            let event : @dom.MouseEvent = raw.cast()
            event.preventDefault()
            match zoom_edit {
              Some(edit) => {
                let input = @dom.HTMLInputElement::cast_from_element(edit)
                input.value = (mindmap_current_zoom(mindmap) * 100.0)
                  .round()
                  .to_int()
                  .to_string()
                mindmap_set_zoom_editing(true)
                input.focus()
              }
              None => ()
            }
          })
        None => ()
      }
      match zoom_edit {
        Some(edit) => {
          edit
          .as_event_target()
          .on("keydown", fn(raw) {
            let event : @dom.KeyboardEvent = raw.cast()
            let input = @dom.HTMLInputElement::cast_from_element(edit)
            match event.key {
              "Enter" => {
                event.preventDefault()
                match mindmap_parse_zoom_input(input.value) {
                  Some(next_zoom) =>
                    mindmap_apply_zoom(
                      mindmap, zoom_value, zoom_edit, connector_frame, window, next_zoom,
                    )
                  None => mindmap_sync_view(mindmap, zoom_value, zoom_edit)
                }
                mindmap_set_zoom_editing(false)
              }
              "Escape" => {
                event.preventDefault()
                mindmap_set_zoom_editing(false)
                mindmap_sync_view(mindmap, zoom_value, zoom_edit)
              }
              _ => ()
            }
          })
          edit
          .as_event_target()
          .on("blur", fn(_) {
            let input = @dom.HTMLInputElement::cast_from_element(edit)
            match mindmap_parse_zoom_input(input.value) {
              Some(next_zoom) =>
                mindmap_apply_zoom(
                  mindmap, zoom_value, zoom_edit, connector_frame, window, next_zoom,
                )
              None => mindmap_sync_view(mindmap, zoom_value, zoom_edit)
            }
            mindmap_set_zoom_editing(false)
          })
        }
        None => ()
      }
      match fit_view {
        Some(control) =>
          control
          .as_event_target()
          .on("click", fn(_) {
            mindmap_fit_to_view(
              mindmap, zoom_value, zoom_edit, connector_frame, window,
            )
          })
        None => ()
      }
      match recenter_view {
        Some(control) =>
          control
          .as_event_target()
          .on("click", fn(_) {
            mindmap_recenter_pan(
              mindmap, zoom_value, zoom_edit, connector_frame, window,
            )
          })
        None => ()
      }

      mindmap_sync_view(mindmap, zoom_value, zoom_edit)
      mindmap_schedule_connectors(connector_frame, window)
      ignore(
        window.requestAnimationFrame(fn(_) {
          ignore(
            window.requestAnimationFrame(fn(_) {
              mindmap_fit_to_view(
                mindmap, zoom_value, zoom_edit, connector_frame, window,
              )
            }),
          )
        }),
      )
    }
    None => ()
  }
}

///|
fn focus_mindmap_container(
  mindmap : @dom.Element,
  target : @dom.Element,
) -> Unit {
  match target.closest("input, textarea, select, button") {
    Some(_) => ()
    None => mindmap.as_any()._call("focus", []) |> ignore
  }
}

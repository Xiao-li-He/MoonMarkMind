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
      @dom.HTMLInputElement::cast_from_element(edit).value = percent.to_string()
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
  frame.val = window.requestAnimationFrame(fn(_) {
    frame.val = 0
    render_mindmap_connectors()
  })
}

///|
fn mindmap_can_pan(target : @dom.Element) -> Bool {
  match
    target.closest(
      ".node, .node-action, .node-editor, [data-action], [data-editor-for], button, input",
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
fn mindmap_recenter_pan(
  mindmap : @dom.Element,
  zoom_value : @dom.Element?,
  zoom_edit : @dom.Element?,
  frame : @ref.Ref[Int],
  window : @dom.Window,
) -> Unit {
  match mindmap.querySelector(".mindmap-stage") {
    Some(stage) => {
      let viewport_width = mindmap.clientWidth().to_double()
      let viewport_height = mindmap.clientHeight().to_double()
      let stage_width = stage.clientWidth().to_double()
      let stage_height = stage.clientHeight().to_double()
      let mut next_pan_x = 0
      let mut next_pan_y = 0
      if has_class_name(stage, "mindmap-stage--vertical") {
        next_pan_y = ((stage_height - viewport_height) / 2.0 + 48.0)
          .round()
          .to_int()
      } else if has_class_name(stage, "mindmap-stage--single-right") {
        next_pan_x = ((stage_width - viewport_width) / 2.0 + 56.0)
          .round()
          .to_int()
      }
      mindmap.setAttribute("data-pan-x", next_pan_x.to_string())
      mindmap.setAttribute("data-pan-y", next_pan_y.to_string())
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
fn bind_mindmap_ui(
  click_callback : (@dom.MouseEvent) -> Unit,
  dblclick_callback : (@dom.MouseEvent) -> Unit,
  keydown_callback : (@dom.KeyboardEvent) -> Unit,
  focusout_callback : (@dom.FocusEvent) -> Unit,
  dragstart_callback : (@dom.DragEvent) -> Unit,
  dragend_callback : (@dom.DragEvent) -> Unit,
  dragover_callback : (@dom.DragEvent) -> Unit,
  drop_callback : (@dom.DragEvent) -> Unit,
) -> Unit {
  match get_element("#mindmap") {
    Some(mindmap) => {
      let window = @dom.window()
      let zoom_in = get_element("#zoom-in")
      let zoom_out = get_element("#zoom-out")
      let zoom_value = get_element("#zoom-value")
      let zoom_edit = get_element("#zoom-edit")
      let fit_view = get_element("#fit-view")
      let recenter_view = get_element("#recenter-view")
      let connector_frame = @ref.Ref(0)
      let panning = @ref.Ref(false)
      let start_x = @ref.Ref(0)
      let start_y = @ref.Ref(0)
      let start_pan_x = @ref.Ref(0)
      let start_pan_y = @ref.Ref(0)

      mindmap
      .as_event_target()
      .on("click", fn(raw) { click_callback(raw.cast()) })
      mindmap
      .as_event_target()
      .on("dblclick", fn(raw) {
        let event : @dom.MouseEvent = raw.cast()
        if mindmap_can_pan(event.target()) {
          event.preventDefault()
          mindmap_recenter_pan(
            mindmap, zoom_value, zoom_edit, connector_frame, window,
          )
          return
        }
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
        if !mindmap_can_pan(event.target()) {
          return
        }
        panning.val = true
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
              }
              "Escape" => {
                event.preventDefault()
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

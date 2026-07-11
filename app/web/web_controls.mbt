///|
/// Static controls and input bindings for the browser app shell.
///
/// This file wires toolbar controls, custom selects, split panes, markdown
/// input changes, and direct editor focus helpers to app callbacks.
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
/// Replace a native select with the themed custom-select facade.
///
/// The native select remains the source of truth; the custom DOM mirrors its
/// value and dispatches the same change flow used by app callbacks.
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
/// Bind static toolbar and panel controls to frontend callbacks.
///
/// This is called once during app startup, so it only wires DOM events and
/// leaves app-state decisions to the supplied callbacks.
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
  let raw = style.get_property_value(name).trim().to_owned()
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
/// Bind markdown textarea input, scroll, selection, and drag/drop events.
///
/// The listener keeps editor chrome and mindmap projection in sync while
/// preserving browser-native textarea behavior.
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

      let schedule_sync_selected_headings = fn(force_reveal) {
        if input_selected_headings_frame.val != 0 {
          window.cancelAnimationFrame(input_selected_headings_frame.val)
        }
        input_selected_headings_frame.val = window.requestAnimationFrame(fn(_) {
          input_selected_headings_frame.val = 0
          let next_key = current_heading_selection(input)
            .map(fn(value) { value.to_string() })
            .iter()
            .join(",")
          if should_notify_selected_headings(
              next_key,
              input_last_selected_headings_key.val,
              force_reveal,
            ) {
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

      let sync_selection_state = fn(force_reveal) {
        schedule_sync_editor_chrome()
        schedule_sync_selected_headings(force_reveal)
      }

      let unfold_placeholder_at_selection = fn() {
        let line_index = line_index_at_offset(
          input.value,
          input_selection_start(input),
        )
        unfold_placeholder_at_visible_line(line_index) |> ignore
      }

      input
      .as_event_target()
      .on("input", fn(_) {
        sync_editor_chrome()
        sync_selection_state(false)
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
      input
      .as_event_target()
      .on("click", fn(_) {
        unfold_placeholder_at_selection()
        sync_selection_state(true)
      })
      input
      .as_event_target()
      .on("mouseup", fn(_) {
        unfold_placeholder_at_selection()
        sync_selection_state(true)
      })
      input
      .as_event_target()
      .on("keyup", fn(_) {
        unfold_placeholder_at_selection()
        sync_selection_state(true)
      })
      input.as_event_target().on("select", fn(_) { sync_selection_state(true) })
      input.as_event_target().on("focus", fn(_) { sync_selection_state(true) })
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
        sync_selection_state(true)
      })
      window.as_event_target().on("resize", fn(_) { sync_editor_chrome() })
      sync_editor_chrome()
      schedule_sync_selected_headings(false)
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
fn set_input_value_without_projection_sync(value : String) -> Unit {
  set_input_value(value)
}

///|
fn set_mindmap_dom(
  value : @dom.Element,
  ensure_visible? : Bool = false,
) -> Unit {
  match get_element("#mindmap") {
    Some(mindmap) => {
      let original_pan_x = mindmap.getAttribute("data-pan-x").unwrap_or("0")
      let original_pan_y = mindmap.getAttribute("data-pan-y").unwrap_or("0")
      let original_zoom = mindmap.getAttribute("data-zoom").unwrap_or("1")
      clear_element(mindmap)
      append_child(mindmap, value)
      let content = match mindmap.querySelector(".mindmap-stage") {
        Some(stage) => stage
        None => mindmap
      }
      let node_count = mindmap
        .querySelectorAll(".node[data-node-index]")
        .length()
      let pan_x_int = parse_int_or_default(original_pan_x, 0)
      let pan_y_int = parse_int_or_default(original_pan_y, 0)
      let zoom_double = parse_double_or_default(original_zoom, 1.0)
      let reset_view = ensure_visible &&
        should_reset_mindmap_view(
          node_count,
          mindmap.clientWidth().to_double(),
          mindmap.clientHeight().to_double(),
          content.clientWidth().to_double(),
          content.clientHeight().to_double(),
          pan_x_int,
          pan_y_int,
          zoom_double,
        )
      let pan_x = if reset_view { "0" } else { original_pan_x }
      let pan_y = if reset_view { "0" } else { original_pan_y }
      let zoom = if reset_view { "1" } else { original_zoom }
      mindmap.setAttribute("data-pan-x", pan_x)
      mindmap.setAttribute("data-pan-y", pan_y)
      mindmap.setAttribute("data-zoom", zoom)
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
      apply_contour_layout()
    }
    None => ()
  }
  schedule_contour_layout(ensure_visible~)
}

///|
fn should_reset_mindmap_view(
  node_count : Int,
  viewport_width : Double,
  viewport_height : Double,
  content_width : Double,
  content_height : Double,
  pan_x : Int,
  pan_y : Int,
  zoom : Double,
) -> Bool {
  if node_count <= 0 ||
    viewport_width <= 0.0 ||
    viewport_height <= 0.0 ||
    content_width <= 0.0 ||
    content_height <= 0.0 ||
    zoom.is_nan() ||
    zoom <= 0.0 {
    return true
  }
  let pan_limit_x = max_double(viewport_width, content_width) * 2.0 + 120.0
  let pan_limit_y = max_double(viewport_height, content_height) * 2.0 + 120.0
  abs_double(pan_x.to_double()) > pan_limit_x ||
  abs_double(pan_y.to_double()) > pan_limit_y
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
  // File input is created on demand to avoid keeping browser-only state in the
  // core model. The callback receives both filename and text contents.
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

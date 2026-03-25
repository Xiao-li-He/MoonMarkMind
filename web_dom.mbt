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
extern "js" fn sync_editor_chrome() =
  #|() => {
  #|  window.__moonmarkmindSyncEditorChrome?.()
  #|}

///|
extern "js" fn render_mindmap_connectors() =
  #|() => {
  #|  window.__moonmarkmindRenderConnectors?.()
  #|}

///|
extern "js" fn parse_float(raw : String) -> Double =
  #|(raw) => Number.parseFloat(raw)

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
extern "js" fn bind_mindmap_ui(
  click_callback : (@dom.MouseEvent) -> Unit,
  dblclick_callback : (@dom.MouseEvent) -> Unit,
  keydown_callback : (@dom.KeyboardEvent) -> Unit,
  focusout_callback : (@dom.FocusEvent) -> Unit,
  dragstart_callback : (@dom.DragEvent) -> Unit,
  dragend_callback : (@dom.DragEvent) -> Unit,
  dragover_callback : (@dom.DragEvent) -> Unit,
  drop_callback : (@dom.DragEvent) -> Unit,
) =
  #|(
  #|  clickCallback,
  #|  dblclickCallback,
  #|  keydownCallback,
  #|  focusoutCallback,
  #|  dragstartCallback,
  #|  dragendCallback,
  #|  dragoverCallback,
  #|  dropCallback,
  #|) => {
  #|  const mindmap = document.querySelector("#mindmap")
  #|  if (!mindmap) return
  #|  const zoomIn = document.querySelector("#zoom-in")
  #|  const zoomOut = document.querySelector("#zoom-out")
  #|  const zoomStrip = document.querySelector(".zoom-strip")
  #|  const zoomValue = document.querySelector("#zoom-value")
  #|  const zoomEdit = document.querySelector("#zoom-edit")
  #|  const fitView = document.querySelector("#fit-view")
  #|  const recenterView = document.querySelector("#recenter-view")
  #|  const syncView = () => {
  #|    const panX = Number(mindmap.dataset.panX ?? "0")
  #|    const panY = Number(mindmap.dataset.panY ?? "0")
  #|    const zoom = Number(mindmap.dataset.zoom ?? "1")
  #|    mindmap.style.setProperty("--pan-x", `${panX}px`)
  #|    mindmap.style.setProperty("--pan-y", `${panY}px`)
  #|    mindmap.style.setProperty("--zoom", `${zoom}`)
  #|    const percentText = `${Math.round(zoom * 100)}%`
  #|    if (zoomValue) zoomValue.textContent = percentText
  #|    if (zoomEdit) zoomEdit.value = `${Math.round(zoom * 100)}`
  #|  }
  #|  const renderConnectors = () => {
  #|    const content = mindmap.querySelector(".mindmap-content")
  #|    const stage = content?.querySelector(".mindmap-stage")
  #|    if (!content || !stage) return
  #|    stage.classList.remove("mindmap-stage--svg-connectors")
  #|    content.querySelector(".mindmap-connector-layer")?.remove()
  #|    content.querySelector(".mindmap-connector-controls")?.remove()
  #|    content.querySelectorAll(".mindmap-node-anchor").forEach((element) => element.remove())
  #|    if (
  #|      stage.classList.contains("mindmap-stage--vertical") ||
  #|      stage.classList.contains("mindmap-stage--single-right")
  #|    ) {
  #|      return
  #|    }
  #|    const nodes = [...content.querySelectorAll(".node[data-node-index]")]
  #|    if (nodes.length <= 1) return
  #|    const zoom = Number(mindmap.dataset.zoom ?? "1") || 1
  #|    const contentRect = content.getBoundingClientRect()
  #|    const stageRect = stage.getBoundingClientRect()
  #|    const width = Math.max(1, Math.round(stageRect.width / zoom))
  #|    const height = Math.max(1, Math.round(stageRect.height / zoom))
  #|    const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg")
  #|    svg.setAttribute("class", "mindmap-connector-layer")
  #|    svg.setAttribute("width", `${width}`)
  #|    svg.setAttribute("height", `${height}`)
  #|    svg.setAttribute("viewBox", `0 0 ${width} ${height}`)
  #|    svg.style.left = `${Math.round((stageRect.left - contentRect.left) / zoom)}px`
  #|    svg.style.top = `${Math.round((stageRect.top - contentRect.top) / zoom)}px`
  #|    const controls = document.createElement("div")
  #|    controls.className = "mindmap-connector-controls"
  #|    controls.style.left = svg.style.left
  #|    controls.style.top = svg.style.top
  #|    controls.style.width = `${width}px`
  #|    controls.style.height = `${height}px`
  #|    const nodeMap = new Map(nodes.map((node) => [node.dataset.nodeIndex, node]))
  #|    const stageOffsetX = (stageRect.left - contentRect.left) / zoom
  #|    const stageOffsetY = (stageRect.top - contentRect.top) / zoom
  #|    const localRect = (element) => {
  #|      const rect = element.getBoundingClientRect()
  #|      return {
  #|        left: (rect.left - contentRect.left) / zoom - stageOffsetX,
  #|        right: (rect.right - contentRect.left) / zoom - stageOffsetX,
  #|        top: (rect.top - contentRect.top) / zoom - stageOffsetY,
  #|        bottom: (rect.bottom - contentRect.top) / zoom - stageOffsetY,
  #|        width: rect.width / zoom,
  #|        height: rect.height / zoom,
  #|      }
  #|    }
  #|    const appendCircle = (x, y, radius) => {
  #|      const circle = document.createElementNS("http://www.w3.org/2000/svg", "circle")
  #|      circle.setAttribute("cx", `${x}`)
  #|      circle.setAttribute("cy", `${y}`)
  #|      circle.setAttribute("r", `${radius}`)
  #|      circle.setAttribute("fill", "rgba(255,255,255,0.98)")
  #|      circle.setAttribute("stroke", "#6f9ccd")
  #|      circle.setAttribute("stroke-width", "1.8")
  #|      svg.appendChild(circle)
  #|    }
  #|    const appendPath = (d, strokeWidth) => {
  #|      const path = document.createElementNS("http://www.w3.org/2000/svg", "path")
  #|      path.setAttribute("d", d)
  #|      path.setAttribute("fill", "none")
  #|      path.setAttribute("stroke", "#7ea7d3")
  #|      path.setAttribute("stroke-width", `${strokeWidth}`)
  #|      path.setAttribute("stroke-linecap", "round")
  #|      path.setAttribute("stroke-linejoin", "round")
  #|      svg.appendChild(path)
  #|    }
  #|    const appendJoint = (x, y, node, count) => {
  #|      if (!node || node.dataset.hiddenNode === "true") return
  #|      if (node.dataset.hasChildren !== "true") return
  #|      const joint = document.createElement("button")
  #|      joint.type = "button"
  #|      joint.className = "mindmap-connector-joint"
  #|      joint.dataset.action = "toggle"
  #|      joint.dataset.nodeIndex = node.dataset.nodeIndex ?? ""
  #|      const collapsed = node.dataset.collapsed === "true"
  #|      const subtreeCount = Number(count ?? node.dataset.hiddenCount ?? "0")
  #|      const hiddenCount = Math.max(0, subtreeCount - 1)
  #|      joint.dataset.collapsed = collapsed ? "true" : "false"
  #|      joint.setAttribute(
  #|        "aria-label",
  #|        collapsed ? `Expand node (${hiddenCount} hidden)` : "Collapse node",
  #|      )
  #|      joint.setAttribute("aria-expanded", collapsed ? "false" : "true")
  #|      joint.textContent = collapsed && hiddenCount > 0 ? `${hiddenCount}` : ""
  #|      joint.style.left = `${x}px`
  #|      joint.style.top = `${y}px`
  #|      controls.appendChild(joint)
  #|    }
  #|    const edgeGroups = new Map()
  #|    const rootEdges = { L: [], R: [] }
  #|    for (const node of nodes) {
  #|      const parentIndex = node.dataset.parentIndex ?? ""
  #|      if (!parentIndex || parentIndex === "-1") continue
  #|      const parent = nodeMap.get(parentIndex)
  #|      if (!parent) continue
  #|      const parentRect = localRect(parent)
  #|      const childRect = localRect(node)
  #|      const parentCenterX = parentRect.left + parentRect.width / 2
  #|      const childCenterX = childRect.left + childRect.width / 2
  #|      const childOnLeft = childCenterX < parentCenterX
  #|      if (node.dataset.hasChildren === "true" && node.dataset.hiddenNode !== "true") {
  #|        const jointX = childOnLeft ? childRect.left - 3 : childRect.right + 3
  #|        const jointY = childRect.top + childRect.height / 2
  #|        appendJoint(jointX, jointY, node, Number(node.dataset.hiddenCount ?? "0"))
  #|      }
  #|      if (parent.dataset.depth === "0") {
  #|        const side = childOnLeft ? "L" : "R"
  #|        rootEdges[side].push({ node, parentRect, childRect, childOnLeft, parentIndex })
  #|        continue
  #|      }
  #|      const key = `${parentIndex}:${childOnLeft ? "L" : "R"}`
  #|      const group = edgeGroups.get(key) ?? []
  #|      group.push({ node, parentRect, childRect, childOnLeft, parentIndex })
  #|      edgeGroups.set(key, group)
  #|    }
  #|    for (const side of ["L", "R"]) {
  #|      const rootSide = rootEdges[side]
  #|      if (!rootSide.length) continue
  #|      rootSide.sort(
  #|        (a, b) =>
  #|          a.childRect.top + a.childRect.height / 2 - (b.childRect.top + b.childRect.height / 2),
  #|      )
  #|      const count = rootSide.length
  #|      for (const [index, edge] of rootSide.entries()) {
  #|        const { node, parentRect, childRect, childOnLeft } = edge
  #|        const dir = childOnLeft ? -1 : 1
  #|        const startX = childOnLeft ? parentRect.left : parentRect.right
  #|        const startY =
  #|          count === 1
  #|            ? parentRect.top + parentRect.height / 2
  #|            : parentRect.top + parentRect.height * ((index + 1) / (count + 1))
  #|        const endX = childOnLeft ? childRect.right : childRect.left
  #|        const endY = childRect.top + childRect.height / 2
  #|        const span = Math.max(32, Math.abs(endX - startX))
  #|        const lead = Math.min(74, Math.max(24, span * 0.34))
  #|        const settle = Math.min(66, Math.max(20, span * 0.28))
  #|        const bend = Math.min(44, Math.max(16, span * 0.16))
  #|        const curveStartY = startY - bend
  #|        const curveEndY = endY + bend
  #|        appendPath(
  #|          `M ${startX} ${startY} C ${startX + dir * lead} ${curveStartY}, ${endX - dir * settle} ${curveEndY}, ${endX} ${endY}`,
  #|          node.dataset.depth === "1" ? 3.4 : 2.7,
  #|        )
  #|      }
  #|    }
  #|    for (const edges of edgeGroups.values()) {
  #|      if (!edges.length) continue
  #|      edges.sort(
  #|        (a, b) =>
  #|          a.childRect.top + a.childRect.height / 2 - (b.childRect.top + b.childRect.height / 2),
  #|      )
  #|      const sample = edges[0]
  #|      const { parentRect, childOnLeft, parentIndex } = sample
  #|      const parentNode = nodeMap.get(parentIndex)
  #|      const dir = childOnLeft ? -1 : 1
  #|      const startX = childOnLeft ? parentRect.left : parentRect.right
  #|      const startY = parentRect.top + parentRect.height / 2
  #|      const endpoints = edges.map((edge) => ({
  #|        edge,
  #|        endX: childOnLeft ? edge.childRect.right : edge.childRect.left,
  #|        endY: edge.childRect.top + edge.childRect.height / 2,
  #|      }))
  #|      const groupStrokeWidth = edges.some((edge) => edge.node.dataset.depth === "1") ? 3.2 : 2.5
  #|      if (endpoints.length === 1) {
  #|        const target = endpoints[0]
  #|        const span = Math.max(20, Math.abs(target.endX - startX))
  #|        const lead = Math.min(26, Math.max(12, span * 0.24))
  #|        const settle = Math.min(28, Math.max(16, span * 0.3))
  #|        appendPath(
  #|          `M ${startX} ${startY} C ${startX + dir * lead} ${startY}, ${target.endX - dir * settle} ${target.endY}, ${target.endX} ${target.endY}`,
  #|          groupStrokeWidth,
  #|        )
  #|        continue
  #|      }
  #|      const nearestSpan = Math.max(
  #|        20,
  #|        Math.min(...endpoints.map((target) => Math.abs(target.endX - startX))),
  #|      )
  #|      const branchX = startX + dir * Math.min(30, Math.max(16, nearestSpan * 0.22))
  #|      const branchLead = Math.min(18, Math.max(8, Math.abs(branchX - startX) * 0.7))
  #|      appendPath(
  #|        `M ${startX} ${startY} C ${startX + dir * branchLead} ${startY}, ${branchX - dir * 6} ${startY}, ${branchX} ${startY}`,
  #|        groupStrokeWidth,
  #|      )
  #|      for (const target of endpoints) {
  #|        const span = Math.max(18, Math.abs(target.endX - branchX))
  #|        const pull = Math.min(18, Math.max(10, span * 0.2))
  #|        const settle = Math.min(24, Math.max(12, span * 0.34))
  #|        const easeY = startY + (target.endY - startY) * 0.18
  #|        appendPath(
  #|          `M ${branchX} ${startY} C ${branchX + dir * pull} ${easeY}, ${target.endX - dir * settle} ${target.endY}, ${target.endX} ${target.endY}`,
  #|          target.edge.node.dataset.depth === "1" ? 3.2 : 2.4,
  #|        )
  #|      }
  #|    }
  #|    content.insertAdjacentElement("afterbegin", controls)
  #|    content.insertAdjacentElement("afterbegin", svg)
  #|    stage.classList.add("mindmap-stage--svg-connectors")
  #|  }
  #|  let connectorFrame = 0
  #|  const scheduleConnectorRender = () => {
  #|    if (connectorFrame) cancelAnimationFrame(connectorFrame)
  #|    connectorFrame = requestAnimationFrame(() => {
  #|      connectorFrame = 0
  #|      renderConnectors()
  #|    })
  #|  }
  #|  window.__moonmarkmindRenderConnectors = scheduleConnectorRender
  #|  const clampZoom = (value) => Math.max(0.4, Math.min(2, value))
  #|  const setZoom = (value) => {
  #|    mindmap.dataset.zoom = `${clampZoom(value)}`
  #|    syncView()
  #|    scheduleConnectorRender()
  #|  }
  #|  const applyWheelZoom = (event) => {
  #|    const delta = event.deltaY ?? 0
  #|    if (!Number.isFinite(delta) || delta === 0) return
  #|    event.preventDefault()
  #|    const currentZoom = Number(mindmap.dataset.zoom ?? "1") || 1
  #|    const speed = event.ctrlKey ? 0.0032 : 0.0018
  #|    const nextZoom = clampZoom(currentZoom * Math.exp(-delta * speed))
  #|    setZoom(nextZoom)
  #|  }
  #|  const parseZoomInput = (raw) => {
  #|    const trimmed = (raw ?? "").trim()
  #|    if (!trimmed) return null
  #|    const numeric = Number.parseFloat(trimmed.replace("%", ""))
  #|    if (!Number.isFinite(numeric)) return null
  #|    return trimmed.includes("%") || numeric > 10 ? numeric / 100 : numeric
  #|  }
  #|  const stopZoomEditing = (commit) => {
  #|    if (!zoomStrip || !zoomEdit) return
  #|    if (commit) {
  #|      const nextZoom = parseZoomInput(zoomEdit.value)
  #|      if (nextZoom != null) setZoom(nextZoom)
  #|      else syncView()
  #|    } else {
  #|      syncView()
  #|    }
  #|    zoomStrip.classList.remove("is-editing")
  #|  }
  #|  const startZoomEditing = () => {
  #|    if (!zoomStrip || !zoomEdit) return
  #|    zoomStrip.classList.add("is-editing")
  #|    zoomEdit.value = `${Math.round(Number(mindmap.dataset.zoom ?? "1") * 100)}`
  #|    zoomEdit.focus()
  #|    zoomEdit.select()
  #|  }
  #|  const fitToView = () => {
  #|    const stage = mindmap.querySelector(".mindmap-stage")
  #|    if (!stage) {
  #|      mindmap.dataset.panX = "0"
  #|      mindmap.dataset.panY = "0"
  #|      setZoom(1)
  #|      return
  #|    }
  #|    const viewportWidth = Math.max(0, mindmap.clientWidth - 24)
  #|    const viewportHeight = Math.max(0, mindmap.clientHeight - 24)
  #|    const stageWidth = stage.offsetWidth
  #|    const stageHeight = stage.offsetHeight
  #|    if (viewportWidth <= 0 || viewportHeight <= 0 || stageWidth <= 0 || stageHeight <= 0) {
  #|      return
  #|    }
  #|    const nextZoom = clampZoom(Math.min(1, viewportWidth / stageWidth, viewportHeight / stageHeight))
  #|    mindmap.dataset.panX = "0"
  #|    mindmap.dataset.panY = "0"
  #|    setZoom(nextZoom)
  #|  }
  #|  const recenterPan = () => {
  #|    const stage = mindmap.querySelector(".mindmap-stage")
  #|    if (!stage) {
  #|      mindmap.dataset.panX = "0"
  #|      mindmap.dataset.panY = "0"
  #|      syncView()
  #|      return
  #|    }
  #|    const viewportWidth = Math.ceil(mindmap.getBoundingClientRect().width)
  #|    const viewportHeight = Math.ceil(mindmap.getBoundingClientRect().height)
  #|    const stageWidth = Math.ceil(stage.getBoundingClientRect().width)
  #|    const stageHeight = Math.ceil(stage.getBoundingClientRect().height)
  #|    let nextPanX = 0
  #|    let nextPanY = 0
  #|    if (stage.classList.contains("mindmap-stage--vertical")) {
  #|      const topMargin = 48
  #|      nextPanY = Math.round((stageHeight - viewportHeight) / 2 + topMargin)
  #|    } else if (stage.classList.contains("mindmap-stage--single-right")) {
  #|      const leftMargin = 56
  #|      nextPanX = Math.round((stageWidth - viewportWidth) / 2 + leftMargin)
  #|    }
  #|    mindmap.dataset.panX = `${nextPanX}`
  #|    mindmap.dataset.panY = `${nextPanY}`
  #|    syncView()
  #|  }
  #|  let panning = false
  #|  let startX = 0
  #|  let startY = 0
  #|  let startPanX = 0
  #|  let startPanY = 0
  #|  const canPan = (target) => {
  #|    if (!target) return false
  #|    return !target.closest?.("[data-node-index], [data-action], [data-editor-for], button, input")
  #|  }
  #|  const stopPan = () => {
  #|    panning = false
  #|    mindmap.classList.remove("is-panning")
  #|    document.body.style.userSelect = ""
  #|  }
  #|  mindmap.addEventListener("click", clickCallback)
  #|  mindmap.addEventListener("dblclick", (event) => {
  #|    if (canPan(event.target)) {
  #|      event.preventDefault()
  #|      recenterPan()
  #|      return
  #|    }
  #|    dblclickCallback(event)
  #|  })
  #|  mindmap.addEventListener("keydown", keydownCallback)
  #|  mindmap.addEventListener("focusout", focusoutCallback)
  #|  mindmap.addEventListener("wheel", applyWheelZoom, { passive: false })
  #|  mindmap.addEventListener("dragstart", dragstartCallback)
  #|  mindmap.addEventListener("dragend", dragendCallback)
  #|  mindmap.addEventListener("dragover", dragoverCallback)
  #|  mindmap.addEventListener("drop", dropCallback)
  #|  zoomOut?.addEventListener("click", () => {
  #|    setZoom(Number(mindmap.dataset.zoom ?? "1") - 0.1)
  #|  })
  #|  zoomIn?.addEventListener("click", () => {
  #|    setZoom(Number(mindmap.dataset.zoom ?? "1") + 0.1)
  #|  })
  #|  zoomValue?.addEventListener("dblclick", (event) => {
  #|    event.preventDefault()
  #|    startZoomEditing()
  #|  })
  #|  zoomEdit?.addEventListener("keydown", (event) => {
  #|    if (event.key === "Enter") {
  #|      event.preventDefault()
  #|      stopZoomEditing(true)
  #|    } else if (event.key === "Escape") {
  #|      event.preventDefault()
  #|      stopZoomEditing(false)
  #|    }
  #|  })
  #|  zoomEdit?.addEventListener("blur", () => stopZoomEditing(true))
  #|  fitView?.addEventListener("click", () => fitToView())
  #|  recenterView?.addEventListener("click", () => recenterPan())
  #|  mindmap.addEventListener("mousedown", (event) => {
  #|    if (!canPan(event.target)) return
  #|    panning = true
  #|    startX = event.clientX
  #|    startY = event.clientY
  #|    startPanX = Number(mindmap.dataset.panX ?? "0")
  #|    startPanY = Number(mindmap.dataset.panY ?? "0")
  #|    mindmap.classList.add("is-panning")
  #|    document.body.style.userSelect = "none"
  #|    event.preventDefault()
  #|  })
  #|  window.addEventListener("mousemove", (event) => {
  #|    if (!panning) return
  #|    mindmap.dataset.panX = (startPanX + event.clientX - startX).toString()
  #|    mindmap.dataset.panY = (startPanY + event.clientY - startY).toString()
  #|    syncView()
  #|  })
  #|  window.addEventListener("mouseup", stopPan)
  #|  window.addEventListener("resize", scheduleConnectorRender)
  #|  syncView()
  #|  scheduleConnectorRender()
  #|}

///|
extern "js" fn bind_input_listener(
  input_callback : () -> Unit,
  selected_headings_callback : (String) -> Unit,
) =
  #|(inputCallback, selectedHeadingsCallback) => {
  #|  const input = document.querySelector("#input")
  #|  const gutter = document.querySelector("#input-gutter")
  #|  const linkedGutterLines = document.querySelector("#input-linked-gutter-lines")
  #|  const hoverGutterLine = document.querySelector("#input-hover-gutter-line")
  #|  const activeGutterLine = document.querySelector("#input-active-gutter-line")
  #|  const linkedLines = document.querySelector("#input-linked-lines")
  #|  const hoverLine = document.querySelector("#input-hover-line")
  #|  const activeLine = document.querySelector("#input-active-line")
  #|  let lineMetrics = {
  #|    heights: [28],
  #|    tops: [18],
  #|    lineHeight: 28,
  #|    paddingTop: 18,
  #|    paddingBottom: 22,
  #|  }
  #|  const measureLineMetrics = () => {
  #|    if (!input) return lineMetrics
  #|    const style = getComputedStyle(input)
  #|    const fontSize = Number.parseFloat(style.fontSize || "16")
  #|    const lineHeight = Number.parseFloat(style.lineHeight || "") || fontSize * 1.75
  #|    const paddingTop = Number.parseFloat(style.paddingTop || "0")
  #|    const paddingBottom = Number.parseFloat(style.paddingBottom || "0")
  #|    const mirror = document.createElement("div")
  #|    mirror.style.position = "absolute"
  #|    mirror.style.visibility = "hidden"
  #|    mirror.style.pointerEvents = "none"
  #|    mirror.style.inset = "0"
  #|    mirror.style.width = "100%"
  #|    mirror.style.height = "auto"
  #|    mirror.style.boxSizing = "border-box"
  #|    mirror.style.border = "0"
  #|    mirror.style.padding = `${paddingTop}px ${Number.parseFloat(style.paddingRight || "0")}px ${paddingBottom}px ${Number.parseFloat(style.paddingLeft || "0")}px`
  #|    mirror.style.font = style.font
  #|    mirror.style.lineHeight = style.lineHeight
  #|    mirror.style.letterSpacing = style.letterSpacing
  #|    mirror.style.tabSize = style.tabSize || "2"
  #|    mirror.style.whiteSpace = "normal"
  #|    mirror.style.wordBreak = "break-word"
  #|    mirror.style.overflowWrap = "anywhere"
  #|    mirror.style.color = style.color
  #|    mirror.style.textAlign = style.textAlign
  #|    mirror.style.direction = style.direction
  #|    const lines = input.value.split("\n")
  #|    const heights = []
  #|    const tops = []
  #|    let currentTop = paddingTop
  #|    const mirrorParent = input.parentElement ?? document.body
  #|    const contentWidth = Math.max(1, input.clientWidth || input.getBoundingClientRect().width)
  #|    mirrorParent.appendChild(mirror)
  #|    mirror.style.width = `${contentWidth}px`
  #|    for (const line of lines) {
  #|      const block = document.createElement("div")
  #|      block.style.display = "block"
  #|      block.style.whiteSpace = "pre-wrap"
  #|      block.style.wordBreak = "break-word"
  #|      block.style.overflowWrap = "anywhere"
  #|      block.style.margin = "0"
  #|      block.style.padding = "0"
  #|      block.textContent = line.length > 0 ? line : " "
  #|      mirror.appendChild(block)
  #|      const contentHeight = block.getBoundingClientRect().height
  #|      const height = Math.max(lineHeight, contentHeight)
  #|      heights.push(height)
  #|      tops.push(currentTop)
  #|      currentTop += height
  #|    }
  #|    const totalHeight = currentTop + paddingBottom
  #|    mirror.remove()
  #|    return { heights, tops, lineHeight, paddingTop, paddingBottom, totalHeight }
  #|  }
  #|  const syncLineMetrics = () => {
  #|    lineMetrics = measureLineMetrics()
  #|  }
  #|  const syncLineNumbers = () => {
  #|    if (!input || !gutter) return
  #|    const heights = lineMetrics.heights.length > 0 ? lineMetrics.heights : [lineMetrics.lineHeight]
  #|    gutter.innerHTML = heights
  #|      .map((height, index) => {
  #|        const blockHeight = Math.max(1, height)
  #|        return `<div class="editor-gutter-number" style="height:${blockHeight}px">${index + 1}</div>`
  #|      })
  #|      .join("")
  #|    gutter.style.transform = `translateY(${-Math.round(input.scrollTop)}px)`
  #|  }
  #|  const setLineLayer = (element, lineIndex, visible) => {
  #|    if (!input || !element) return
  #|    if (!visible || lineIndex < 0) {
  #|      element.style.opacity = "0"
  #|      return
  #|    }
  #|    const top = (lineMetrics.tops[lineIndex] ?? lineMetrics.paddingTop) - input.scrollTop
  #|    const height = lineMetrics.heights[lineIndex] ?? lineMetrics.lineHeight
  #|    element.style.height = `${Math.max(1, height)}px`
  #|    element.style.transform = `translateY(${top}px)`
  #|    element.style.opacity = "1"
  #|  }
  #|  const setLineSpanLayer = (element, startLineIndex, endLineIndex, visible) => {
  #|    if (!input || !element) return
  #|    if (!visible || startLineIndex < 0 || endLineIndex < startLineIndex) {
  #|      element.style.opacity = "0"
  #|      return
  #|    }
  #|    const startTop = (lineMetrics.tops[startLineIndex] ?? lineMetrics.paddingTop) - input.scrollTop
  #|    const endBottom =
  #|      (lineMetrics.tops[endLineIndex] ?? lineMetrics.paddingTop) +
  #|      (lineMetrics.heights[endLineIndex] ?? lineMetrics.lineHeight) -
  #|      input.scrollTop
  #|    const height = endBottom - startTop
  #|    element.style.height = `${Math.max(1, height)}px`
  #|    element.style.transform = `translateY(${startTop}px)`
  #|    element.style.opacity = "1"
  #|  }
  #|  const setLineCollection = (container, lineIndexes, className) => {
  #|    if (!input || !container) return
  #|    if (!lineIndexes || lineIndexes.length === 0) {
  #|      container.innerHTML = ""
  #|      return
  #|    }
  #|    const heights = lineMetrics.heights.length > 0 ? lineMetrics.heights : [lineMetrics.lineHeight]
  #|    container.innerHTML = lineIndexes
  #|      .map((lineIndex) => {
  #|        const top = (lineMetrics.tops[lineIndex] ?? lineMetrics.paddingTop) - input.scrollTop
  #|        const height = Math.max(1, heights[lineIndex] ?? lineMetrics.lineHeight)
  #|        return `<div class="${className}" style="height:${height}px;transform:translateY(${top}px);opacity:1"></div>`
  #|      })
  #|      .join("")
  #|  }
  #|  const syncActiveLine = () => {
  #|    const selectionStart = input.selectionStart ?? 0
  #|    const selectionEnd = input.selectionEnd ?? selectionStart
  #|    const startLine = lineIndexAtOffset(Math.min(selectionStart, selectionEnd))
  #|    const endLine = lineIndexAtOffset(Math.max(selectionStart, selectionEnd))
  #|    const visible = document.activeElement === input
  #|    setLineSpanLayer(activeLine, startLine, endLine, visible)
  #|    setLineSpanLayer(activeGutterLine, startLine, endLine, visible)
  #|  }
  #|  let linkedLineIndexes = []
  #|  const syncLinkedLine = () => {
  #|    setLineCollection(linkedLines, linkedLineIndexes, "editor-linked-line")
  #|    setLineCollection(linkedGutterLines, linkedLineIndexes, "editor-gutter-line editor-gutter-line--linked")
  #|  }
  #|  window.__moonmarkmindSetLinkedLines = (nextLineIndexes) => {
  #|    linkedLineIndexes = Array.isArray(nextLineIndexes) ? nextLineIndexes : []
  #|    syncLinkedLine()
  #|  }
  #|  let hoverLineIndex = -1
  #|  const syncHoverLine = () => {
  #|    setLineLayer(hoverLine, hoverLineIndex, hoverLineIndex >= 0)
  #|    setLineLayer(hoverGutterLine, hoverLineIndex, hoverLineIndex >= 0)
  #|  }
  #|  let activeLineFrame = 0
  #|  const scheduleSyncActiveLine = () => {
  #|    if (activeLineFrame) cancelAnimationFrame(activeLineFrame)
  #|    activeLineFrame = requestAnimationFrame(() => {
  #|      activeLineFrame = 0
  #|      syncActiveLine()
  #|    })
  #|  }
  #|  let lastSelectedHeadingKey = "__init__"
  #|  const headingPattern = /^#+\s/
  #|  const listPattern = /^(?:\s*)(?:[-+*]|\d+\.)\s+/
  #|  const lineIndexAtOffset = (offset) => input.value.slice(0, offset).split("\n").length - 1
  #|  const currentHeadingSelection = () => {
  #|    if (!input) return []
  #|    const selectionStart = input.selectionStart ?? 0
  #|    const selectionEnd = input.selectionEnd ?? selectionStart
  #|    const rangeStart = Math.min(selectionStart, selectionEnd)
  #|    const rangeEnd = Math.max(selectionStart, selectionEnd)
  #|    const startLine = lineIndexAtOffset(rangeStart)
  #|    const endLine = lineIndexAtOffset(rangeEnd)
  #|    const lines = input.value.split("\n")
  #|    const structuralLineIndexes = []
  #|    let nodeIndex = 0
  #|    for (let lineIndex = 0; lineIndex < lines.length; lineIndex += 1) {
  #|      if (headingPattern.test(lines[lineIndex]) || listPattern.test(lines[lineIndex])) {
  #|        structuralLineIndexes.push([lineIndex, nodeIndex])
  #|        nodeIndex += 1
  #|      }
  #|    }
  #|    const isStructuralLine = (lineIndex) => {
  #|      for (const [structuralLineIndex] of structuralLineIndexes) {
  #|        if (structuralLineIndex === lineIndex) return true
  #|      }
  #|      return false
  #|    }
  #|    if (rangeStart === rangeEnd) {
  #|      for (const [structuralLineIndex, structuralNodeIndex] of structuralLineIndexes) {
  #|        if (structuralLineIndex === startLine) return [structuralNodeIndex]
  #|      }
  #|      return []
  #|    }
  #|    for (let lineIndex = startLine; lineIndex <= endLine; lineIndex += 1) {
  #|      if (!isStructuralLine(lineIndex)) return []
  #|    }
  #|    return structuralLineIndexes
  #|      .filter(([structuralLineIndex]) =>
  #|        structuralLineIndex >= startLine && structuralLineIndex <= endLine,
  #|      )
  #|      .map(([, structuralNodeIndex]) => structuralNodeIndex)
  #|  }
  #|  const syncSelectedHeadings = () => {
  #|    const nextHeadings = currentHeadingSelection()
  #|    const nextKey = nextHeadings.join(",")
  #|    if (nextKey === lastSelectedHeadingKey) return
  #|    lastSelectedHeadingKey = nextKey
  #|    selectedHeadingsCallback(nextKey)
  #|  }
  #|  let selectedHeadingsFrame = 0
  #|  const scheduleSyncSelectedHeadings = () => {
  #|    if (selectedHeadingsFrame) cancelAnimationFrame(selectedHeadingsFrame)
  #|    selectedHeadingsFrame = requestAnimationFrame(() => {
  #|      selectedHeadingsFrame = 0
  #|      syncSelectedHeadings()
  #|    })
  #|  }
  #|  const syncSelectionState = () => {
  #|    scheduleSyncActiveLine()
  #|    scheduleSyncSelectedHeadings()
  #|  }
  #|  const syncEditorChrome = () => {
  #|    syncLineMetrics()
  #|    syncLineNumbers()
  #|    if (gutter) gutter.style.transform = `translateY(${-Math.round(input?.scrollTop ?? 0)}px)`
  #|    syncLinkedLine()
  #|    syncHoverLine()
  #|    syncActiveLine()
  #|  }
  #|  window.__moonmarkmindSyncLineNumbers = syncLineNumbers
  #|  window.__moonmarkmindGetLineMetrics = () => lineMetrics
  #|  window.__moonmarkmindSyncEditorChrome = syncEditorChrome
  #|  input?.addEventListener("input", () => {
  #|    syncEditorChrome()
  #|    syncSelectionState()
  #|    inputCallback()
  #|  })
  #|  input?.addEventListener("scroll", () => {
  #|    if (gutter) gutter.style.transform = `translateY(${-Math.round(input.scrollTop)}px)`
  #|    syncLinkedLine()
  #|    syncHoverLine()
  #|    syncActiveLine()
  #|  })
  #|  input?.addEventListener("mousemove", (event) => {
  #|    const pointerY = event.offsetY + input.scrollTop
  #|    const heights = lineMetrics.heights.length > 0 ? lineMetrics.heights : [lineMetrics.lineHeight]
  #|    let nextIndex = heights.length - 1
  #|    for (let lineIndex = 0; lineIndex < heights.length; lineIndex += 1) {
  #|      const top = lineMetrics.tops[lineIndex] ?? lineMetrics.paddingTop
  #|      const bottom = top + (heights[lineIndex] ?? lineMetrics.lineHeight)
  #|      if (pointerY < bottom) {
  #|        nextIndex = lineIndex
  #|        break
  #|      }
  #|    }
  #|    hoverLineIndex = Math.max(0, nextIndex)
  #|    syncHoverLine()
  #|  })
  #|  input?.addEventListener("mouseleave", () => {
  #|    hoverLineIndex = -1
  #|    syncHoverLine()
  #|  })
  #|  input?.addEventListener("click", () => {
  #|    syncSelectionState()
  #|  })
  #|  input?.addEventListener("mouseup", () => {
  #|    syncSelectionState()
  #|  })
  #|  input?.addEventListener("keyup", () => {
  #|    syncSelectionState()
  #|  })
  #|  input?.addEventListener("select", () => {
  #|    syncSelectionState()
  #|  })
  #|  input?.addEventListener("focus", () => {
  #|    syncSelectionState()
  #|  })
  #|  input?.addEventListener("blur", syncActiveLine)
  #|  document.addEventListener("selectionchange", () => {
  #|    if (document.activeElement !== input) return
  #|    syncSelectionState()
  #|  })
  #|  window.addEventListener("resize", () => {
  #|    syncEditorChrome()
  #|  })
  #|  syncEditorChrome()
  #|  syncSelectedHeadings()
  #|}

///|
fn set_app_html(value : String) -> Unit {
  match get_element("#app") {
    Some(app) => app.setInnerHTML(value)
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
extern "js" fn set_input_linked_lines(line_indexes : String) =
  #|(lineIndexes) => {
  #|  const nextLineIndexes = (lineIndexes ?? "")
  #|    .split(",")
  #|    .map((value) => Number.parseInt(value, 10))
  #|    .filter((value) => Number.isFinite(value) && value >= 0)
  #|  window.__moonmarkmindSetLinkedLines(nextLineIndexes)
  #|}

///|
extern "js" fn reveal_input_line(line_index : Int) =
  #|(lineIndex) => {
  #|  const input = document.querySelector("#input")
  #|  if (!input || lineIndex == null || lineIndex < 0) return
  #|  const metrics = window.__moonmarkmindGetLineMetrics?.() ?? null
  #|  const style = getComputedStyle(input)
  #|  const fontSize = Number.parseFloat(style.fontSize || "16")
  #|  const fallbackLineHeight = Number.parseFloat(style.lineHeight || "") || fontSize * 1.75
  #|  const paddingTop = Number.parseFloat(style.paddingTop || "0")
  #|  const lineHeight = metrics?.lineHeight ?? fallbackLineHeight
  #|  const lineTop = (metrics?.tops?.[lineIndex] ?? paddingTop)
  #|  const lineBottom = lineTop + (metrics?.heights?.[lineIndex] ?? lineHeight)
  #|  const viewportTop = input.scrollTop
  #|  const viewportBottom = viewportTop + input.clientHeight
  #|  const topMargin = lineHeight * 2
  #|  const bottomMargin = lineHeight * 3
  #|  const visibleTop = viewportTop + topMargin
  #|  const visibleBottom = viewportBottom - bottomMargin
  #|  if (lineTop >= visibleTop && lineBottom <= visibleBottom) return
  #|  const targetTop = Math.max(0, lineTop - Math.max(lineHeight * 2, input.clientHeight * 0.35))
  #|  if (typeof input.scrollTo === "function") {
  #|    input.scrollTo({ top: targetTop, behavior: "smooth" })
  #|  } else {
  #|    input.scrollTop = targetTop
  #|  }
  #|  window.__moonmarkmindSyncEditorChrome?.()
  #|}

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
  render_mindmap_connectors()
}

///|
fn set_workspace_split(percent : Int) -> Unit {
  match get_element(".workspace") {
    Some(workspace) => {
      let style = @dom.css_style_from_val(
        workspace.as_any()._get("style").cast(),
      )
      style.set_property("--left-pane-percent", "\{percent}%")
    }
    None => ()
  }
}

///|
fn set_select_value(id : String, value : String) -> Unit {
  match get_element_by_id(id) {
    Some(control) => {
      @dom.HTMLSelectElement::cast_from_element(control).value = value
      sync_custom_select_by_id(id)
    }
    None => ()
  }
}

///|
fn set_select_muted(id : String, muted : Bool) -> Unit {
  match get_element_by_id(id) {
    Some(control) => {
      toggle_class(control, "tool-select--muted", muted)
      sync_custom_select_by_id(id)
    }
    None => ()
  }
}

///|
fn set_toolbar_selection_enabled(enabled : Bool) -> Unit {
  for button in @dom.document().querySelectorAll("[data-toolbar-action]") {
    let disabled = (!enabled).to_string()
    button.setAttribute("data-disabled", disabled)
    button.setAttribute("aria-disabled", disabled)
    toggle_class(button, "mindmap-tool--disabled", !enabled)
  }
}

///|
fn set_toolbar_action_enabled(action : String, enabled : Bool) -> Unit {
  match get_element("[data-toolbar-action=\"\{action}\"]") {
    Some(button) => {
      let disabled = (!enabled).to_string()
      button.setAttribute("data-disabled", disabled)
      button.setAttribute("aria-disabled", disabled)
      toggle_class(button, "mindmap-tool--disabled", !enabled)
    }
    None => ()
  }
}

///|
fn set_aux_action_enabled(id : String, enabled : Bool) -> Unit {
  match get_element_by_id(id) {
    Some(button) => {
      let disabled = (!enabled).to_string()
      button.setAttribute("data-disabled", disabled)
      button.setAttribute("aria-disabled", disabled)
      toggle_class(button, "mindmap-aux-button--disabled", !enabled)
    }
    None => ()
  }
}

///|
fn focus_editor(node_index : Int) -> Unit {
  match get_element("[data-editor-for=\"\{node_index}\"]") {
    Some(editor) => {
      let textarea = to_text_area(editor)
      textarea.focus()
      textarea.as_any()._call("select", []) |> ignore
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
fn stop_event(event : @dom.MouseEvent) -> Unit {
  event.stopPropagation()
}

///|
fn prevent_event_default(event : @dom.MouseEvent) -> Unit {
  event.preventDefault()
}

///|
fn event_action(event : @dom.MouseEvent) -> String {
  match event.target().closest("[data-action]") {
    Some(action) => action.getAttribute("data-action").unwrap_or("")
    None => ""
  }
}

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
fn event_node_index(event : @dom.MouseEvent) -> Int {
  event_node_index_from_target(event.target())
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
fn event_editor_index(event : @dom.FocusEvent) -> Int {
  event_editor_index_from_target(event.target())
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
fn event_editor_value(event : @dom.FocusEvent) -> String {
  event_editor_value_from_target(event.target())
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

///|
fn set_editor_document_name(value : String) -> Unit {
  match get_element(".editor-chrome__badge") {
    Some(badge) => {
      badge.setTextContent(value)
      badge.setAttribute("title", value)
    }
    None => ()
  }
}

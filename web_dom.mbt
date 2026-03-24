///|
#external
priv type BrowserEvent

///|
extern "js" fn bind_static_ui(
  new_callback : () -> Unit,
  sample_callback : () -> Unit,
  upload_callback : () -> Unit,
  download_markdown_callback : () -> Unit,
  layout_callback : (String) -> Unit,
  style_callback : (String) -> Unit,
  detail_callback : (String) -> Unit,
  export_callback : (String) -> Unit,
  toolbar_callback : (String) -> Unit,
) =
  #|(
  #|  newCallback,
  #|  sampleCallback,
  #|  uploadCallback,
  #|  downloadMarkdownCallback,
  #|  layoutCallback,
  #|  styleCallback,
  #|  detailCallback,
  #|  exportCallback,
  #|  toolbarCallback,
  #|) => {
  #|  const syncCustomSelect = (select) => {
  #|    if (!select) return
  #|    const custom = select.parentElement?.querySelector?.(".tool-select-custom")
  #|    if (!custom) return
  #|    const trigger = custom.querySelector(".tool-select-trigger")
  #|    const selectedOption = [...select.options].find((option) => option.value === select.value) ?? select.options[0]
  #|    if (trigger) trigger.textContent = selectedOption?.textContent ?? ""
  #|    trigger?.classList.toggle("tool-select--muted", select.classList.contains("tool-select--muted"))
  #|    for (const optionButton of custom.querySelectorAll(".tool-select-option")) {
  #|      optionButton.classList.toggle("is-selected", optionButton.dataset.value === select.value)
  #|    }
  #|  }
  #|  const closeCustomSelects = (except) => {
  #|    for (const custom of document.querySelectorAll(".tool-select-custom")) {
  #|      if (custom === except) continue
  #|      custom.classList.remove("is-open")
  #|      custom.querySelector(".tool-select-trigger")?.setAttribute("aria-expanded", "false")
  #|    }
  #|  }
  #|  const initCustomSelect = (id) => {
  #|    const select = document.querySelector(`#${id}`)
  #|    if (!select || select.dataset.customSelectReady === "true") return
  #|    select.dataset.customSelectReady = "true"
  #|    select.classList.add("tool-select--native")
  #|    const custom = document.createElement("div")
  #|    custom.className = "tool-select-custom"
  #|    const trigger = document.createElement("button")
  #|    trigger.type = "button"
  #|    trigger.className = "tool-select-trigger"
  #|    trigger.setAttribute("aria-haspopup", "listbox")
  #|    trigger.setAttribute("aria-expanded", "false")
  #|    const menu = document.createElement("div")
  #|    menu.className = "tool-select-menu"
  #|    menu.setAttribute("role", "listbox")
  #|    for (const option of select.options) {
  #|      if (option.hidden) continue
  #|      const optionButton = document.createElement("button")
  #|      optionButton.type = "button"
  #|      optionButton.className = "tool-select-option"
  #|      optionButton.dataset.value = option.value
  #|      optionButton.textContent = option.textContent ?? ""
  #|      optionButton.addEventListener("click", () => {
  #|        select.value = option.value
  #|        syncCustomSelect(select)
  #|        custom.classList.remove("is-open")
  #|        trigger.setAttribute("aria-expanded", "false")
  #|        select.dispatchEvent(new Event("change", { bubbles: true }))
  #|      })
  #|      menu.appendChild(optionButton)
  #|    }
  #|    trigger.addEventListener("click", (event) => {
  #|      event.preventDefault()
  #|      const nextOpen = !custom.classList.contains("is-open")
  #|      closeCustomSelects(nextOpen ? custom : null)
  #|      custom.classList.toggle("is-open", nextOpen)
  #|      trigger.setAttribute("aria-expanded", nextOpen ? "true" : "false")
  #|    })
  #|    custom.appendChild(trigger)
  #|    custom.appendChild(menu)
  #|    select.insertAdjacentElement("afterend", custom)
  #|    select.addEventListener("change", () => syncCustomSelect(select))
  #|    syncCustomSelect(select)
  #|  }
  #|  window.__moonmarkmindSyncCustomSelect = syncCustomSelect
  #|  document.querySelector("#new-document")?.addEventListener("click", () => newCallback())
  #|  document.querySelector("#load-sample")?.addEventListener("click", () => sampleCallback())
  #|  document.querySelector("#upload-markdown")?.addEventListener("click", () => uploadCallback())
  #|  document.querySelector("#download-markdown")?.addEventListener("click", () => downloadMarkdownCallback())
  #|  initCustomSelect("layout-select")
  #|  initCustomSelect("style-select")
  #|  initCustomSelect("detail-select")
  #|  initCustomSelect("export-select")
  #|  document.querySelector("#layout-select")?.addEventListener("change", (event) => {
  #|    layoutCallback(event.target?.value ?? "horizontal")
  #|  })
  #|  document.querySelector("#style-select")?.addEventListener("change", (event) => {
  #|    styleCallback(event.target?.value ?? "line")
  #|  })
  #|  document.querySelector("#detail-select")?.addEventListener("change", (event) => {
  #|    detailCallback(event.target?.value ?? "medium")
  #|  })
  #|  document.querySelector("#export-select")?.addEventListener("change", (event) => {
  #|    exportCallback(event.target?.value ?? "")
  #|  })
  #|  document.addEventListener("click", (event) => {
  #|    if (event.target?.closest?.(".tool-select-custom")) return
  #|    closeCustomSelects(null)
  #|  })
  #|  document.querySelector("#undo-action")?.addEventListener("click", (event) => {
  #|    if (event.currentTarget?.dataset?.disabled === "true") return
  #|    toolbarCallback("undo")
  #|  })
  #|  document.querySelector("#redo-action")?.addEventListener("click", (event) => {
  #|    if (event.currentTarget?.dataset?.disabled === "true") return
  #|    toolbarCallback("redo")
  #|  })
  #|  for (const button of document.querySelectorAll("[data-toolbar-action]")) {
  #|    button.addEventListener("click", () => {
  #|      if (button.dataset.disabled === "true") return
  #|      toolbarCallback(button.dataset.toolbarAction ?? "")
  #|    })
  #|  }
  #|  window.addEventListener("keydown", (event) => {
  #|    const target = event.target
  #|    if (target?.closest?.("input, textarea, select")) return
  #|    let action = ""
  #|    if (event.key === "Enter") action = "new-branch"
  #|    else if (event.key === "Tab") action = "new-child"
  #|    else if (event.key === "Delete" || event.key === "Backspace") action = "delete-node"
  #|    else if (event.key === " " || event.code === "Space") action = "toggle-node"
  #|    else if (event.ctrlKey && event.key === "ArrowUp") action = "move-up"
  #|    else if (event.ctrlKey && event.key === "ArrowDown") action = "move-down"
  #|    else if (event.ctrlKey && !event.shiftKey && (event.key === "z" || event.key === "Z")) action = "undo"
  #|    else if (event.ctrlKey && (event.key === "y" || event.key === "Y")) action = "redo"
  #|    if (!action) return
  #|    event.preventDefault()
  #|    toolbarCallback(action)
  #|  })
  #|}

///|
extern "js" fn bind_splitter_ui(callback : (Int) -> Unit) =
  #|(callback) => {
  #|  const divider = document.querySelector("#workspace-divider")
  #|  const workspace = document.querySelector(".workspace")
  #|  if (!divider || !workspace) return
  #|  let dragging = false
  #|  const parseCssPixels = (name, fallback) => {
  #|    const raw = getComputedStyle(workspace).getPropertyValue(name).trim()
  #|    const value = Number.parseFloat(raw.replace("px", ""))
  #|    return Number.isFinite(value) ? value : fallback
  #|  }
  #|  const onMove = (event) => {
  #|    if (!dragging) return
  #|    const rect = workspace.getBoundingClientRect()
  #|    if (rect.width <= 0) return
  #|    const minLeft = 300
  #|    const dividerWidth = 14
  #|    const minRight = parseCssPixels("--mindmap-toolbar-min-width", 390)
  #|    const maxLeft = Math.max(minLeft, rect.width - minRight - dividerWidth)
  #|    const clampedLeft = Math.max(minLeft, Math.min(event.clientX - rect.left, maxLeft))
  #|    const percent = (clampedLeft / rect.width) * 100
  #|    callback(Math.round(percent))
  #|  }
  #|  const stop = () => {
  #|    dragging = false
  #|    document.body.style.cursor = ""
  #|    document.body.style.userSelect = ""
  #|  }
  #|  divider.addEventListener("mousedown", (event) => {
  #|    dragging = true
  #|    document.body.style.cursor = "col-resize"
  #|    document.body.style.userSelect = "none"
  #|    event.preventDefault()
  #|  })
  #|  window.addEventListener("mousemove", onMove)
  #|  window.addEventListener("mouseup", stop)
  #|}

///|
extern "js" fn bind_mindmap_ui(
  click_callback : (BrowserEvent) -> Unit,
  dblclick_callback : (BrowserEvent) -> Unit,
  keydown_callback : (BrowserEvent) -> Unit,
  focusout_callback : (BrowserEvent) -> Unit,
  dragstart_callback : (BrowserEvent) -> Unit,
  dragend_callback : (BrowserEvent) -> Unit,
  dragover_callback : (BrowserEvent) -> Unit,
  drop_callback : (BrowserEvent) -> Unit,
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
  #|  const measureEditor = () => {
  #|    if (!input) return { lineHeight: 28, paddingTop: 18 }
  #|    const style = getComputedStyle(input)
  #|    const fontSize = Number.parseFloat(style.fontSize || "16")
  #|    const lineHeight = Number.parseFloat(style.lineHeight || "") || fontSize * 1.75
  #|    const paddingTop = Number.parseFloat(style.paddingTop || "0")
  #|    return { lineHeight, paddingTop }
  #|  }
  #|  const syncLineNumbers = () => {
  #|    if (!input || !gutter) return
  #|    const totalLines = Math.max(1, (input.value.match(/\n/g)?.length ?? 0) + 1)
  #|    gutter.textContent = Array.from({ length: totalLines }, (_, index) => `${index + 1}`).join("\n")
  #|    gutter.style.transform = `translateY(${-Math.round(input.scrollTop)}px)`
  #|  }
  #|  const setLineLayer = (element, lineIndex, visible) => {
  #|    if (!input || !element) return
  #|    if (!visible || lineIndex < 0) {
  #|      element.style.opacity = "0"
  #|      return
  #|    }
  #|    const { lineHeight, paddingTop } = measureEditor()
  #|    const top = paddingTop + lineIndex * lineHeight - input.scrollTop
  #|    element.style.height = `${Math.round(lineHeight)}px`
  #|    element.style.transform = `translateY(${Math.round(top)}px)`
  #|    element.style.opacity = "1"
  #|  }
  #|  const setLineSpanLayer = (element, startLineIndex, endLineIndex, visible) => {
  #|    if (!input || !element) return
  #|    if (!visible || startLineIndex < 0 || endLineIndex < startLineIndex) {
  #|      element.style.opacity = "0"
  #|      return
  #|    }
  #|    const { lineHeight, paddingTop } = measureEditor()
  #|    const top = paddingTop + startLineIndex * lineHeight - input.scrollTop
  #|    const height = (endLineIndex - startLineIndex + 1) * lineHeight
  #|    element.style.height = `${Math.round(height)}px`
  #|    element.style.transform = `translateY(${Math.round(top)}px)`
  #|    element.style.opacity = "1"
  #|  }
  #|  const setLineCollection = (container, lineIndexes, className) => {
  #|    if (!input || !container) return
  #|    if (!lineIndexes || lineIndexes.length === 0) {
  #|      container.innerHTML = ""
  #|      return
  #|    }
  #|    const { lineHeight, paddingTop } = measureEditor()
  #|    container.innerHTML = lineIndexes
  #|      .map((lineIndex) => {
  #|        const top = Math.round(paddingTop + lineIndex * lineHeight - input.scrollTop)
  #|        const height = Math.round(lineHeight)
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
  #|    let headingIndex = 0
  #|    let nearestHeading = -2
  #|    const selectedHeadings = []
  #|    for (let lineIndex = 0; lineIndex < lines.length; lineIndex += 1) {
  #|      if (headingPattern.test(lines[lineIndex])) {
  #|        nearestHeading = headingIndex
  #|        if (lineIndex >= startLine && lineIndex <= endLine) {
  #|          selectedHeadings.push(headingIndex)
  #|        }
  #|        headingIndex += 1
  #|      }
  #|      if (lineIndex >= endLine) break
  #|    }
  #|    if (selectedHeadings.length > 0) return selectedHeadings
  #|    return nearestHeading >= 0 ? [nearestHeading] : []
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
  #|  const syncEditorChrome = () => {
  #|    syncLineNumbers()
  #|    if (gutter) gutter.style.transform = `translateY(${-Math.round(input?.scrollTop ?? 0)}px)`
  #|    syncLinkedLine()
  #|    syncHoverLine()
  #|    syncActiveLine()
  #|  }
  #|  window.__moonmarkmindSyncLineNumbers = syncLineNumbers
  #|  window.__moonmarkmindSyncEditorChrome = syncEditorChrome
  #|  input?.addEventListener("input", () => {
  #|    syncEditorChrome()
  #|    scheduleSyncSelectedHeadings()
  #|    inputCallback()
  #|  })
  #|  input?.addEventListener("scroll", () => {
  #|    if (gutter) gutter.style.transform = `translateY(${-Math.round(input.scrollTop)}px)`
  #|    syncLinkedLine()
  #|    syncHoverLine()
  #|    syncActiveLine()
  #|  })
  #|  input?.addEventListener("mousemove", (event) => {
  #|    const { lineHeight, paddingTop } = measureEditor()
  #|    const totalLines = Math.max(1, (input.value.match(/\n/g)?.length ?? 0) + 1)
  #|    const rawLine = Math.floor((event.offsetY + input.scrollTop - paddingTop) / lineHeight)
  #|    hoverLineIndex = Math.max(0, Math.min(totalLines - 1, rawLine))
  #|    syncHoverLine()
  #|  })
  #|  input?.addEventListener("mouseleave", () => {
  #|    hoverLineIndex = -1
  #|    syncHoverLine()
  #|  })
  #|  input?.addEventListener("click", () => {
  #|    scheduleSyncActiveLine()
  #|    scheduleSyncSelectedHeadings()
  #|  })
  #|  input?.addEventListener("keyup", () => {
  #|    syncActiveLine()
  #|    scheduleSyncSelectedHeadings()
  #|  })
  #|  input?.addEventListener("select", () => {
  #|    scheduleSyncActiveLine()
  #|    scheduleSyncSelectedHeadings()
  #|  })
  #|  input?.addEventListener("focus", () => {
  #|    scheduleSyncActiveLine()
  #|    scheduleSyncSelectedHeadings()
  #|  })
  #|  input?.addEventListener("blur", syncActiveLine)
  #|  syncEditorChrome()
  #|  syncSelectedHeadings()
  #|}

///|
extern "js" fn set_app_html(value : String) =
  #|(value) => {
  #|  const app = document.querySelector("#app")
  #|  if (app) app.innerHTML = value
  #|}

///|
extern "js" fn get_input_value() -> String =
  #|() => document.querySelector("#input")?.value ?? ""

///|
extern "js" fn set_input_value(value : String) =
  #|(value) => {
  #|  const input = document.querySelector("#input")
  #|  if (input) input.value = value
  #|  window.__moonmarkmindSyncEditorChrome?.()
  #|}

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
  #|  const style = getComputedStyle(input)
  #|  const fontSize = Number.parseFloat(style.fontSize || "16")
  #|  const lineHeight = Number.parseFloat(style.lineHeight || "") || fontSize * 1.75
  #|  const paddingTop = Number.parseFloat(style.paddingTop || "0")
  #|  const lineTop = paddingTop + lineIndex * lineHeight
  #|  const viewportTop = input.scrollTop
  #|  const viewportBottom = viewportTop + input.clientHeight
  #|  const topMargin = lineHeight * 2
  #|  const bottomMargin = lineHeight * 3
  #|  const visibleTop = viewportTop + topMargin
  #|  const visibleBottom = viewportBottom - bottomMargin
  #|  if (lineTop >= visibleTop && lineTop + lineHeight <= visibleBottom) return
  #|  const targetTop = Math.max(0, lineTop - Math.max(lineHeight * 2, input.clientHeight * 0.35))
  #|  if (typeof input.scrollTo === "function") {
  #|    input.scrollTo({ top: targetTop, behavior: "smooth" })
  #|  } else {
  #|    input.scrollTop = targetTop
  #|  }
  #|  window.__moonmarkmindSyncEditorChrome?.()
  #|}

///|
extern "js" fn set_mindmap_html(value : String) =
  #|(value) => {
  #|  const mindmap = document.querySelector("#mindmap")
  #|  if (!mindmap) return
  #|  if (mindmap.dataset.panX == null) mindmap.dataset.panX = "0"
  #|  if (mindmap.dataset.panY == null) mindmap.dataset.panY = "0"
  #|  if (mindmap.dataset.zoom == null) mindmap.dataset.zoom = "1"
  #|  mindmap.innerHTML = `<div class="mindmap-content">${value}</div>`
  #|  mindmap.style.setProperty("--pan-x", `${Number(mindmap.dataset.panX ?? "0")}px`)
  #|  mindmap.style.setProperty("--pan-y", `${Number(mindmap.dataset.panY ?? "0")}px`)
  #|  mindmap.style.setProperty("--zoom", `${Number(mindmap.dataset.zoom ?? "1")}`)
  #|  const zoomValue = document.querySelector("#zoom-value")
  #|  const zoomEdit = document.querySelector("#zoom-edit")
  #|  if (zoomValue) zoomValue.textContent = `${Math.round(Number(mindmap.dataset.zoom ?? "1") * 100)}%`
  #|  if (zoomEdit) zoomEdit.value = `${Math.round(Number(mindmap.dataset.zoom ?? "1") * 100)}`
  #|  window.__moonmarkmindRenderConnectors?.()
  #|}

///|
extern "js" fn set_workspace_split(percent : Int) =
  #|(percent) => {
  #|  const workspace = document.querySelector(".workspace")
  #|  if (workspace) {
  #|    workspace.style.setProperty("--left-pane-percent", `${percent}%`)
  #|  }
  #|}

///|
extern "js" fn set_select_value(id : String, value : String) =
  #|(id, value) => {
  #|  const control = document.querySelector(`#${id}`)
  #|  if (!control) return
  #|  control.value = value
  #|  window.__moonmarkmindSyncCustomSelect?.(control)
  #|}

///|
extern "js" fn set_select_muted(id : String, muted : Bool) =
  #|(id, muted) => {
  #|  const control = document.querySelector(`#${id}`)
  #|  if (!control) return
  #|  control.classList.toggle("tool-select--muted", muted)
  #|  window.__moonmarkmindSyncCustomSelect?.(control)
  #|}

///|
extern "js" fn set_toolbar_selection_enabled(enabled : Bool) =
  #|(enabled) => {
  #|  for (const button of document.querySelectorAll("[data-toolbar-action]")) {
  #|    button.dataset.disabled = (!enabled).toString()
  #|    button.setAttribute("aria-disabled", (!enabled).toString())
  #|    button.classList.toggle("mindmap-tool--disabled", !enabled)
  #|  }
  #|}

///|
extern "js" fn set_toolbar_action_enabled(action : String, enabled : Bool) =
  #|(action, enabled) => {
  #|  const button = document.querySelector(`[data-toolbar-action="${action}"]`)
  #|  if (!button) return
  #|  button.dataset.disabled = (!enabled).toString()
  #|  button.setAttribute("aria-disabled", (!enabled).toString())
  #|  button.classList.toggle("mindmap-tool--disabled", !enabled)
  #|}

///|
extern "js" fn set_aux_action_enabled(id : String, enabled : Bool) =
  #|(id, enabled) => {
  #|  const button = document.querySelector(`#${id}`)
  #|  if (!button) return
  #|  button.dataset.disabled = (!enabled).toString()
  #|  button.setAttribute("aria-disabled", (!enabled).toString())
  #|  button.classList.toggle("mindmap-aux-button--disabled", !enabled)
  #|}

///|
extern "js" fn focus_editor(node_index : Int) =
  #|(nodeIndex) => {
  #|  queueMicrotask(() => {
  #|    const editor = document.querySelector(`[data-editor-for="${nodeIndex}"]`)
  #|    if (editor) {
  #|      editor.focus()
  #|      editor.select?.()
  #|    }
  #|  })
  #|}

///|
extern "js" fn pick_markdown_file(callback : (String) -> Unit) =
  #|(callback) => {
  #|  const input = document.createElement("input")
  #|  input.type = "file"
  #|  input.accept = ".md,.markdown,text/markdown,text/plain"
  #|  input.addEventListener("change", async () => {
  #|    const file = input.files?.[0]
  #|    if (!file) return
  #|    callback(await file.text())
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
extern "js" fn stop_event(event : BrowserEvent) =
  #|(event) => event.stopPropagation()

///|
extern "js" fn prevent_event_default(event : BrowserEvent) =
  #|(event) => event.preventDefault()

///|
extern "js" fn event_action(event : BrowserEvent) -> String =
  #|(event) => event.target?.closest?.("[data-action]")?.dataset?.action ?? ""

///|
extern "js" fn event_node_index(event : BrowserEvent) -> Int =
  #|(event) => Number(event.target?.closest?.("[data-node-index]")?.dataset?.nodeIndex ?? -1)

///|
extern "js" fn event_drop_target_index(event : BrowserEvent) -> Int =
  #|(event) => Number(event.target?.closest?.("[data-drop-target]")?.dataset?.dropTarget ?? -1)

///|
extern "js" fn event_drop_parent_index(event : BrowserEvent) -> Int =
  #|(event) => Number(event.target?.closest?.("[data-drop-parent]")?.dataset?.dropParent ?? -1)

///|
extern "js" fn event_drop_place_after(event : BrowserEvent) -> Bool =
  #|(event) => (event.target?.closest?.("[data-drop-position]")?.dataset?.dropPosition ?? "before") === "after"

///|
extern "js" fn event_editor_index(event : BrowserEvent) -> Int =
  #|(event) => Number(event.target?.closest?.("[data-editor-for]")?.dataset?.editorFor ?? -1)

///|
extern "js" fn event_editor_value(event : BrowserEvent) -> String =
  #|(event) => event.target?.value ?? ""

///|
extern "js" fn event_key(event : BrowserEvent) -> String =
  #|(event) => event.key ?? ""

///|
extern "js" fn event_multi_select_key(event : BrowserEvent) -> Bool =
  #|(event) => Boolean(event.ctrlKey || event.metaKey)

///|
extern "js" fn event_shift_key(event : BrowserEvent) -> Bool =
  #|(event) => Boolean(event.shiftKey)

///|
extern "js" fn event_drag_source_index(event : BrowserEvent) -> Int =
  #|(event) => Number(event.target?.closest?.("[data-drag-index]")?.dataset?.dragIndex ?? -1)

///|
extern "js" fn event_drag_parent(event : BrowserEvent) -> Int =
  #|(event) => Number(event.target?.closest?.("[data-drag-parent]")?.dataset?.dragParent ?? -1)

///|
extern "js" fn set_drag_text(event : BrowserEvent, value : String) =
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

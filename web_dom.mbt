///|
#external
priv type BrowserEvent

///|
extern "js" fn bind_static_ui(
  render_callback : () -> Unit,
  sample_callback : () -> Unit,
  layout_callback : (String) -> Unit,
) =
  #|(
  #|  renderCallback,
  #|  sampleCallback,
  #|  layoutCallback,
  #|) => {
  #|  document.querySelector("#render")?.addEventListener("click", () => renderCallback())
  #|  document.querySelector("#load-sample")?.addEventListener("click", () => sampleCallback())
  #|  for (const button of document.querySelectorAll("[data-layout-mode]")) {
  #|    button.addEventListener("click", () => {
  #|      layoutCallback(button.dataset.layoutMode ?? "horizontal")
  #|    })
  #|  }
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
  #|  mindmap.addEventListener("click", clickCallback)
  #|  mindmap.addEventListener("dblclick", dblclickCallback)
  #|  mindmap.addEventListener("keydown", keydownCallback)
  #|  mindmap.addEventListener("focusout", focusoutCallback)
  #|  mindmap.addEventListener("dragstart", dragstartCallback)
  #|  mindmap.addEventListener("dragend", dragendCallback)
  #|  mindmap.addEventListener("dragover", dragoverCallback)
  #|  mindmap.addEventListener("drop", dropCallback)
  #|}

///|
extern "js" fn bind_input_listener(callback : () -> Unit) =
  #|(callback) => {
  #|  document.querySelector("#input")?.addEventListener("input", () => callback())
  #|}

///|
extern "js" fn get_input_value() -> String =
  #|() => document.querySelector("#input")?.value ?? ""

///|
extern "js" fn set_input_value(value : String) =
  #|(value) => {
  #|  const input = document.querySelector("#input")
  #|  if (input) input.value = value
  #|}

///|
extern "js" fn set_output_text(value : String) =
  #|(value) => {
  #|  const output = document.querySelector("#output")
  #|  if (output) output.textContent = value
  #|}

///|
extern "js" fn set_mindmap_html(value : String) =
  #|(value) => {
  #|  const mindmap = document.querySelector("#mindmap")
  #|  if (mindmap) mindmap.innerHTML = value
  #|}

///|
extern "js" fn set_layout_button_state(mode : String) =
  #|(mode) => {
  #|  for (const button of document.querySelectorAll("[data-layout-mode]")) {
  #|    const active = (button.dataset.layoutMode ?? "horizontal") === mode
  #|    button.classList.toggle("is-active", active)
  #|    button.setAttribute("aria-pressed", String(active))
  #|  }
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
extern "js" fn prompt_text(message : String, default_value : String) -> String =
  #|(message, defaultValue) => window.prompt(message, defaultValue) ?? ""

///|
extern "js" fn confirm_text(message : String) -> Bool =
  #|(message) => window.confirm(message)

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

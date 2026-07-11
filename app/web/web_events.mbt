///|
/// Event target helpers for mouse and keyboard interactions.
///
/// Pointer events can land on nested text, overlays, or blank stage space;
/// these helpers normalize that browser target back to app-level actions.
fn event_action_from_point(event : @dom.MouseEvent) -> String {
  let target = event_interaction_target(event)
  match target.closest("[data-action]") {
    Some(action) => action.getAttribute("data-action").unwrap_or("")
    None => ""
  }
}

///|
fn event_interaction_target(event : @dom.MouseEvent) -> @dom.Element {
  let target = event.target()
  match
    target.closest(
      ".node, [data-action], [data-editor-for], [data-note-editor-for], [data-body-editor-for]",
    ) {
    Some(interactive) => interactive
    None =>
      if event_target_is_blank_stage_area(target) {
        target
      } else {
        event_target_from_point(event)
      }
  }
}

///|
fn event_target_from_point(event : @dom.MouseEvent) -> @dom.Element {
  for element in @dom.document().elementsFromPoint(event.clientX, event.clientY) {
    match
      element.closest(
        ".node, [data-action], [data-editor-for], [data-note-editor-for], [data-body-editor-for]",
      ) {
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
fn event_target_is_blank_stage_area(target : @dom.Element) -> Bool {
  match target.closest(".mindmap-stage, .mindmap-content, #mindmap") {
    Some(_) =>
      target.closest(
        "[data-node-index], [data-action], [data-editor-for], [data-note-editor-for], [data-body-editor-for]",
      )
      is None
    None => false
  }
}

///|
fn event_node_index_from_target(target : @dom.Element) -> Int {
  match target.closest(".node") {
    Some(node) =>
      @string.parse_int(node.getAttribute("data-node-index").unwrap_or("-1")) catch {
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
fn event_editor_index_from_target(target : @dom.Element) -> Int {
  match target.closest("[data-editor-for]") {
    Some(node) =>
      @string.parse_int(node.getAttribute("data-editor-for").unwrap_or("-1")) catch {
        _ => -1
      }
    None => -1
  }
}

///|
fn event_note_editor_index_from_target(target : @dom.Element) -> Int {
  match target.closest("[data-note-editor-for]") {
    Some(node) =>
      @string.parse_int(
        node.getAttribute("data-note-editor-for").unwrap_or("-1"),
      ) catch {
        _ => -1
      }
    None => -1
  }
}

///|
fn event_body_editor_index_from_target(target : @dom.Element) -> Int {
  match target.closest("[data-body-editor-for]") {
    Some(node) =>
      @string.parse_int(
        node.getAttribute("data-body-editor-for").unwrap_or("-1"),
      ) catch {
        _ => -1
      }
    None => -1
  }
}

///|
fn event_body_block_index_from_target(target : @dom.Element) -> Int {
  match target.closest("[data-body-block-index], [data-body-editor-block]") {
    Some(block) => {
      let value = block
        .getAttribute("data-body-block-index")
        .unwrap_or(block.getAttribute("data-body-editor-block").unwrap_or("-1"))
      @string.parse_int(value) catch {
        _ => -1
      }
    }
    None => -1
  }
}

///|
fn event_note_preview_from_target(target : @dom.Element) -> Bool {
  target.closest("[data-note-preview-for]") is Some(_)
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
fn event_note_editor_value_from_target(target : @dom.Element) -> String {
  event_editor_value_from_target(target)
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
fn event_click_count(event : @dom.MouseEvent) -> Int {
  @string.parse_int(event.as_any()._get("detail").to_string()) catch {
    _ => 1
  }
}

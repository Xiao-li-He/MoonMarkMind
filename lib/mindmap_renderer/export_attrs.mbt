///|
fn visible_child_count(
  depth : Int,
  node : @outline.OutlineNode,
  layer : MindmapLayer,
) -> Int {
  if should_render_layer_children(depth, layer) {
    node.children.length()
  } else {
    0
  }
}

///|
fn hidden_descendant_count(node : @outline.OutlineNode) -> Int {
  let mut count = 0
  for child in node.children {
    count += 1 + hidden_descendant_count(child)
  }
  count
}

///|
fn write_node_export_attrs(
  out : StringBuilder,
  node : @outline.OutlineNode,
  depth : Int,
  layer : MindmapLayer,
) -> Unit {
  write_bool_attr(out, "data-has-children", node.children.length() > 0)
  write_bool_attr(out, "data-collapsed", false)
  write_int_attr(out, "data-hidden-count", hidden_descendant_count(node))
  write_bool_attr(out, "data-hidden-node", false)
  write_int_attr(
    out,
    "data-visible-child-count",
    visible_child_count(depth, node, layer),
  )
}

///|
fn node_toggle_action_class(style : MindmapStyle) -> String {
  match style {
    Line => "node-action node-action--toggle node-action--branch-line"
    Full => "node-action node-action--toggle"
  }
}

///|
fn node_actions_class(style : MindmapStyle) -> String {
  match style {
    Line => "node-actions node-actions--right-mid node-actions--branch-line"
    Full => "node-actions node-actions--right-mid"
  }
}

///|
fn write_node_toggle_action(
  out : StringBuilder,
  node : @outline.OutlineNode,
  center : Bool,
  style : MindmapStyle,
) -> Unit {
  if center || node.children.length() == 0 {
    return
  }
  let hidden_count = hidden_descendant_count(node)
  write_str(out, "<div")
  write_class_attr(out, node_actions_class(style))
  write_str(out, "><button")
  write_class_attr(out, node_toggle_action_class(style))
  write_attr(out, "type", "button")
  write_attr(out, "data-action", "toggle")
  write_attr(out, "data-tip", "Collapse")
  write_attr(out, "aria-label", "Collapse")
  write_bool_attr(out, "aria-expanded", true)
  write_int_attr(out, "data-hidden-count", hidden_count)
  write_str(out, "></button></div>")
}

///|
fn write_note_toggle_action(
  out : StringBuilder,
  node : @outline.OutlineNode,
) -> Unit {
  write_str(out, "<button")
  write_class_attr(out, "node-action node-action--note")
  write_attr(out, "type", "button")
  write_attr(out, "data-action", "toggle-note")
  write_attr(out, "data-tip", "Note")
  write_attr(out, "aria-label", "Note")
  write_bool_attr(out, "aria-expanded", true)
  write_int_attr(out, "data-note-node-index", node.flat_index)
  write_str(out, ">...</button>")
}

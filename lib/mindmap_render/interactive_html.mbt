///|
pub fn render_interactive_content_html(
  root : @outline.OutlineNode,
  options : RenderOptions,
  hooks : InteractiveRenderHooks,
) -> String {
  let out = StringBuilder()
  write_str(out, "<div class=\"mindmap-content\">")
  write_interactive_stage(out, root, options, hooks)
  write_str(out, "</div>")
  finish_builder(out)
}

///|
fn write_interactive_stage(
  out : StringBuilder,
  root : @outline.OutlineNode,
  options : RenderOptions,
  hooks : InteractiveRenderHooks,
) -> Unit {
  match options.layout {
    Logic => write_interactive_single_right_mindmap(out, root, options, hooks)
    Mindmap => write_interactive_horizontal_mindmap(out, root, options, hooks)
    Tree => write_interactive_vertical_mindmap(out, root, options, hooks)
  }
}

///|
fn interactive_stage_class(options : RenderOptions, extra : String) -> String {
  let style_classes = match options.style {
    Line => "mindmap-stage--fill mindmap-stage--branch-line"
    Full => "mindmap-stage--line"
  }
  "mindmap-stage \{style_classes} \{extra}"
}

///|
fn write_interactive_horizontal_mindmap(
  out : StringBuilder,
  root : @outline.OutlineNode,
  options : RenderOptions,
  hooks : InteractiveRenderHooks,
) -> Unit {
  write_str(out, "<div")
  write_class_attr(
    out,
    interactive_stage_class(options, "mindmap-stage--radial"),
  )
  write_str(out, ">")
  write_connector_layer_placeholder(out)
  write_str(
    out, "<div class=\"branch-column branch-column--left branch-column--root\">",
  )
  if (hooks.should_render_children)(root) {
    let left_count = (hooks.root_left_count)(root)
    let left_total_weight = interactive_root_branch_total_span(
      root, 0, left_count, hooks,
    )
    for index in 0..<root.children.length() {
      if index < left_count {
        let child = root.children[index]
        write_interactive_root_branch_node(
          out,
          child,
          root.flat_index,
          "left",
          fill_tone_index(index),
          interactive_root_branch_offset(root, 0, index, hooks),
          (hooks.root_branch_span)(child),
          left_total_weight,
          hooks,
        )
      }
    }
  }
  write_str(out, "</div><div class=\"center-wrap\">")
  write_str(
    out,
    (hooks.render_node_card)(root, -1, true, -1, 0, "node-actions--corner"),
  )
  write_str(
    out, "</div><div class=\"branch-column branch-column--right branch-column--root\">",
  )
  if (hooks.should_render_children)(root) {
    let left_count = (hooks.root_left_count)(root)
    let right_total_weight = interactive_root_branch_total_span(
      root,
      left_count,
      root.children.length(),
      hooks,
    )
    for index in 0..<root.children.length() {
      if index >= left_count {
        let child = root.children[index]
        write_interactive_root_branch_node(
          out,
          child,
          root.flat_index,
          "right",
          fill_tone_index(index),
          interactive_root_branch_offset(root, left_count, index, hooks),
          (hooks.root_branch_span)(child),
          right_total_weight,
          hooks,
        )
      }
    }
  }
  write_str(out, "</div></div>")
}

///|
fn interactive_root_branch_total_span(
  root : @outline.OutlineNode,
  start : Int,
  stop : Int,
  hooks : InteractiveRenderHooks,
) -> Int {
  let mut total = 0
  for index in start..<stop {
    total += (hooks.root_branch_span)(root.children[index])
  }
  if total <= 0 {
    1
  } else {
    total
  }
}

///|
fn interactive_root_branch_offset(
  root : @outline.OutlineNode,
  start : Int,
  stop : Int,
  hooks : InteractiveRenderHooks,
) -> Int {
  let mut total = 0
  for index in start..<stop {
    total += (hooks.root_branch_span)(root.children[index])
  }
  total
}

///|
fn write_interactive_root_branch_node(
  out : StringBuilder,
  node : @outline.OutlineNode,
  parent_index : Int,
  direction : String,
  tone_index : Int,
  offset : Int,
  weight : Int,
  total_weight : Int,
  hooks : InteractiveRenderHooks,
) -> Unit {
  write_str(out, "<div")
  write_class_attr(
    out,
    "branch-item branch-item--\{direction} branch-item--root single-right-tree__node single-right-tree__node--\{direction}",
  )
  write_int_attr(out, "data-node-index", node.flat_index)
  write_int_attr(out, "data-parent-index", parent_index)
  write_interactive_root_weight_style(out, offset, weight, total_weight)
  write_str(out, ">")
  write_interactive_node_spacing_slot(out, Logic)
  write_interactive_branch_logic_parts(
    out, node, parent_index, direction, tone_index, hooks,
  )
  write_interactive_node_spacing_slot(out, Logic)
  write_str(out, "</div>")
}

///|
fn write_interactive_root_weight_style(
  out : StringBuilder,
  offset : Int,
  weight : Int,
  total_weight : Int,
) -> Unit {
  let safe_total = if total_weight > 0 { total_weight } else { 1 }
  let safe_weight = if weight > 0 { weight } else { 1 }
  let basis_points = (offset * 10000 + safe_weight * 5000) / safe_total
  write_attr(
    out,
    "style",
    "top: \{interactive_format_percentage(basis_points)};",
  )
}

///|
fn interactive_format_percentage(value : Int) -> String {
  let whole = value / 100
  let frac = value % 100
  let frac_text = if frac < 10 { "0\{frac}" } else { frac.to_string() }
  "\{whole}.\{frac_text}%"
}

///|
fn write_interactive_branch_logic_parts(
  out : StringBuilder,
  node : @outline.OutlineNode,
  parent_index : Int,
  direction : String,
  tone_index : Int,
  hooks : InteractiveRenderHooks,
) -> Unit {
  let anchor = if direction == "left" {
    "node-actions--left-mid"
  } else {
    "node-actions--right-mid"
  }
  let head = "<div class=\"single-right-tree__head single-right-tree__head--\{direction}\">\{(hooks.render_node_card)(node, parent_index, false, tone_index, node.level, anchor)}</div>"
  if direction == "left" {
    write_interactive_branch_children(out, node, direction, tone_index, hooks)
    write_str(out, head)
  } else {
    write_str(out, head)
    write_interactive_branch_children(out, node, direction, tone_index, hooks)
  }
}

///|
fn write_interactive_branch_children(
  out : StringBuilder,
  node : @outline.OutlineNode,
  direction : String,
  tone_index : Int,
  hooks : InteractiveRenderHooks,
) -> Unit {
  write_str(
    out,
    "<div class=\"single-right-tree__children single-right-tree__children--\{direction}\">",
  )
  if (hooks.should_render_children)(node) {
    for child in node.children {
      if (hooks.is_hidden_node)(child.flat_index) {
        write_interactive_hidden_branch_node(
          out, child, direction, tone_index, hooks,
        )
      } else {
        write_interactive_branch_node(
          out,
          child,
          node.flat_index,
          direction,
          tone_index,
          hooks,
        )
      }
    }
  }
  write_str(out, "</div>")
}

///|
fn write_interactive_branch_node(
  out : StringBuilder,
  node : @outline.OutlineNode,
  parent_index : Int,
  direction : String,
  tone_index : Int,
  hooks : InteractiveRenderHooks,
) -> Unit {
  write_str(out, "<div")
  write_class_attr(
    out,
    "branch-item branch-item--\{direction} single-right-tree__node single-right-tree__node--\{direction}",
  )
  write_int_attr(out, "data-node-index", node.flat_index)
  write_int_attr(out, "data-parent-index", parent_index)
  write_str(out, ">")
  write_interactive_node_spacing_slot(out, Logic)
  write_interactive_branch_logic_parts(
    out, node, parent_index, direction, tone_index, hooks,
  )
  write_interactive_node_spacing_slot(out, Logic)
  write_str(out, "</div>")
}

///|
fn write_interactive_hidden_branch_node(
  out : StringBuilder,
  node : @outline.OutlineNode,
  direction : String,
  tone_index : Int,
  hooks : InteractiveRenderHooks,
) -> Unit {
  write_str(out, "<div")
  write_class_attr(
    out,
    "branch-item branch-item--\{direction} branch-item--hidden",
  )
  write_int_attr(out, "data-node-index", node.flat_index)
  write_int_attr(out, "data-parent-index", -1)
  write_str(
    out, "><div class=\"branch-item__row\"><div class=\"branch-item__head\">",
  )
  write_str(out, (hooks.render_hidden_marker)(node, direction, tone_index))
  write_str(out, "</div></div></div>")
}

///|
fn write_interactive_vertical_mindmap(
  out : StringBuilder,
  root : @outline.OutlineNode,
  options : RenderOptions,
  hooks : InteractiveRenderHooks,
) -> Unit {
  write_str(out, "<div")
  write_class_attr(
    out,
    interactive_stage_class(options, "mindmap-stage--vertical"),
  )
  write_str(out, ">")
  write_connector_layer_placeholder(out)
  write_str(out, "<div class=\"vertical-root\">")
  write_interactive_vertical_tree(out, root, -1, true, -1, 0, options, hooks)
  write_str(out, "</div></div>")
}

///|
fn write_interactive_vertical_tree(
  out : StringBuilder,
  node : @outline.OutlineNode,
  parent_index : Int,
  center : Bool,
  tone_index : Int,
  depth : Int,
  options : RenderOptions,
  hooks : InteractiveRenderHooks,
) -> Unit {
  let class_name = if is_tree_line_style(options) && node.body.length() > 0 {
    "vertical-tree vertical-tree--line-note"
  } else {
    "vertical-tree"
  }
  write_str(out, "<div")
  write_class_attr(out, class_name)
  write_int_attr(out, "data-node-index", node.flat_index)
  write_int_attr(out, "data-parent-index", parent_index)
  write_str(out, ">")
  write_interactive_node_spacing_slot(out, options.layout)
  write_str(
    out,
    (hooks.render_node_card)(
      node, parent_index, center, tone_index, depth, "node-actions--bottom-center",
    ),
  )
  write_interactive_node_spacing_slot(out, options.layout)
  write_interactive_vertical_children(
    out, node, tone_index, depth, options, hooks,
  )
  write_str(out, "</div>")
}

///|
fn write_interactive_vertical_children(
  out : StringBuilder,
  node : @outline.OutlineNode,
  tone_index : Int,
  depth : Int,
  options : RenderOptions,
  hooks : InteractiveRenderHooks,
) -> Unit {
  let class_name = if is_tree_line_style(options) {
    "vertical-tree__children vertical-tree__children--line-tree"
  } else {
    "vertical-tree__children"
  }
  write_str(out, "<div")
  write_class_attr(out, class_name)
  write_str(out, ">")
  if (hooks.should_render_children)(node) {
    for index in 0..<node.children.length() {
      let child = node.children[index]
      let next_tone = if depth == 0 {
        fill_tone_index(index)
      } else {
        tone_index
      }
      let child_class = if is_tree_line_style(options) &&
        child.body.length() > 0 {
        "vertical-tree__child vertical-tree__child--line-note"
      } else {
        "vertical-tree__child"
      }
      write_str(out, "<div")
      write_class_attr(out, child_class)
      write_str(out, ">")
      write_interactive_vertical_tree(
        out,
        child,
        node.flat_index,
        false,
        next_tone,
        depth + 1,
        options,
        hooks,
      )
      write_str(out, "</div>")
    }
  }
  write_str(out, "</div>")
}

///|
fn write_interactive_single_right_mindmap(
  out : StringBuilder,
  root : @outline.OutlineNode,
  options : RenderOptions,
  hooks : InteractiveRenderHooks,
) -> Unit {
  write_str(out, "<div")
  write_class_attr(
    out,
    interactive_stage_class(options, "mindmap-stage--single-right"),
  )
  write_str(out, ">")
  write_connector_layer_placeholder(out)
  write_str(out, "<div class=\"single-right-tree\">")
  write_interactive_single_right_tree(
    out, root, -1, true, -1, 0, options, hooks,
  )
  write_str(out, "</div></div>")
}

///|
fn write_interactive_single_right_tree(
  out : StringBuilder,
  node : @outline.OutlineNode,
  parent_index : Int,
  center : Bool,
  tone_index : Int,
  depth : Int,
  options : RenderOptions,
  hooks : InteractiveRenderHooks,
) -> Unit {
  write_str(out, "<div class=\"single-right-tree__node\"")
  write_int_attr(out, "data-node-index", node.flat_index)
  write_int_attr(out, "data-parent-index", parent_index)
  write_str(out, ">")
  write_interactive_node_spacing_slot(out, options.layout)
  write_str(out, "<div class=\"single-right-tree__head\">")
  write_str(
    out,
    (hooks.render_node_card)(
      node, parent_index, center, tone_index, depth, "node-actions--right-mid",
    ),
  )
  write_str(out, "</div>")
  write_interactive_node_spacing_slot(out, options.layout)
  write_interactive_single_right_children(
    out, node, tone_index, depth, options, hooks,
  )
  write_str(out, "</div>")
}

///|
fn write_interactive_single_right_children(
  out : StringBuilder,
  node : @outline.OutlineNode,
  tone_index : Int,
  depth : Int,
  options : RenderOptions,
  hooks : InteractiveRenderHooks,
) -> Unit {
  write_str(out, "<div class=\"single-right-tree__children\">")
  if (hooks.should_render_children)(node) {
    for index in 0..<node.children.length() {
      let child = node.children[index]
      let next_tone = if depth == 0 {
        fill_tone_index(index)
      } else {
        tone_index
      }
      write_interactive_single_right_tree(
        out,
        child,
        node.flat_index,
        false,
        next_tone,
        depth + 1,
        options,
        hooks,
      )
    }
  }
  write_str(out, "</div>")
}

///|
fn write_interactive_node_spacing_slot(
  out : StringBuilder,
  layout : MindmapLayout,
) -> Unit {
  let class_name = match layout {
    Logic => "node-spacing-slot node-spacing-slot--single-right"
    _ => "node-spacing-slot"
  }
  write_str(out, "<div")
  write_class_attr(out, class_name)
  write_str(out, "></div>")
}

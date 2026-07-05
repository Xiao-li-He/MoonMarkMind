///|
fn render_node_card(
  node : @outline.OutlineNode,
  parent_index~ : Int,
  center~ : Bool,
  tone_index~ : Int,
  options~ : RenderOptions,
  depth~ : Int,
) -> String {
  let classes = ["node"]
  if center {
    classes.push("node--center")
  }
  classes.push(render_node_style_class(options.style))
  let body = render_node_body(node, options)
  (
    $|<article class="\{classes.join(" ")}" data-level="\{node.level}" data-depth="\{depth}" data-tone="\{tone_index}" data-node-index="\{node.flat_index}" data-parent-index="\{parent_index}" data-child-count="\{node.children.length()}" data-synthetic="\{node.synthetic}">
    $|  <strong class="\{node_title_class(options.style)}" data-title-depth="\{depth}" data-title-center="\{center}">\{@markdown_render.render_markdown_title_html(node.title)}</strong>
    $|  \{body}
    $|</article>
  )
}

///|
fn render_node_body(
  node : @outline.OutlineNode,
  options : RenderOptions,
) -> String {
  if node.body.length() == 0 || !is_full_layer(options.layer) {
    return ""
  }
  "<div class=\"node-note-rail\"><div class=\"node-body node-body-preview\"><div class=\"markdown-blocks\">\{@markdown_render.render_markdown_blocks_html(node.body)}</div></div></div>"
}

///|
fn stage_class(options : RenderOptions, extra : String) -> String {
  let classes = ["mindmap-stage", extra]
  match options.style {
    Line => classes.push("mindmap-stage--branch-line")
    Full => classes.push("mindmap-stage--fill")
  }
  classes.join(" ")
}

///|
fn is_full_layer(layer : MindmapLayer) -> Bool {
  match layer {
    Full => true
    _ => false
  }
}

///|
fn render_node_style_class(style : MindmapStyle) -> String {
  match style {
    Line => "node--fill node--branch-line"
    Full => "node--line"
  }
}

///|
fn node_title_class(style : MindmapStyle) -> String {
  match style {
    Line => "node-title node-title--scaled node-title--line"
    Full => "node-title node-title--scaled node-title--fill"
  }
}

///|
fn should_render_children(depth : Int, layer : MindmapLayer) -> Bool {
  match layer {
    Root => false
    Layer2 => depth < 1
    Full => true
  }
}

///|
fn fill_tone_index(index : Int) -> Int {
  index % 5
}

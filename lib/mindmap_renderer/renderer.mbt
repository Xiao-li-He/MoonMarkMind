///|
pub(all) enum MindmapLayout {
  Logic
  Mindmap
  Tree
}

///|
pub(all) enum MindmapStyle {
  Full
  Line
}

///|
pub(all) enum MindmapLayer {
  Root
  Layer2
  Full
}

///|
pub(all) struct RenderOptions {
  layout : MindmapLayout
  style : MindmapStyle
  layer : MindmapLayer
}

///|
pub fn default_render_options() -> RenderOptions {
  { layout: Logic, style: Full, layer: Full }
}

///|
pub fn normalize_layout(value : String) -> MindmapLayout {
  match value {
    "mindmap" => Mindmap
    "tree" => Tree
    _ => Logic
  }
}

///|
pub fn normalize_style(value : String) -> MindmapStyle {
  match value {
    "line" => Line
    _ => Full
  }
}

///|
pub fn normalize_layer(value : String) -> MindmapLayer {
  match value {
    "root" => Root
    "layer2" => Layer2
    _ => Full
  }
}

///|
pub fn layer_to_detail_select(layer : MindmapLayer) -> String {
  match layer {
    Root => "small"
    Layer2 => "medium"
    Full => "all"
  }
}

///|
pub fn render_markdown_html(
  markdown : String,
  options? : RenderOptions = default_render_options(),
) -> String {
  render_outline_html(@outline.build_outline(markdown), options~)
}

///|
pub fn render_markdown_svg(
  markdown : String,
  options? : RenderOptions = default_render_options(),
) -> String {
  render_outline_svg(@outline.build_outline(markdown), options~)
}

///|
pub fn render_outline_html(
  root : @outline.OutlineNode,
  options? : RenderOptions = default_render_options(),
) -> String {
  let classes = [
    "moonmarkmind-export",
    "moonmarkmind-export--\{layout_class(options.layout)}",
    "moonmarkmind-export--\{style_class(options.style)}",
    "moonmarkmind-export--\{layer_to_detail_select(options.layer)}",
  ]
  let class_name = classes.join(" ")
  "<section class=\"\{class_name}\">\{render_node_html(root, options, 0)}</section>"
}

///|
pub fn render_outline_svg(
  root : @outline.OutlineNode,
  options? : RenderOptions = default_render_options(),
) -> String {
  let html = render_outline_html(root, options~)
  (
    $|<svg xmlns="http://www.w3.org/2000/svg" width="960" height="640" viewBox="0 0 960 640">
    $|<foreignObject x="0" y="0" width="960" height="640">
    $|<div xmlns="http://www.w3.org/1999/xhtml">
    $|\{html}
    $|</div>
    $|</foreignObject>
    $|</svg>
  )
}

///|
fn render_node_html(
  node : @outline.OutlineNode,
  options : RenderOptions,
  depth : Int,
) -> String {
  let child_html = if should_render_children(depth, options.layer) {
    let children = []
    for child in node.children {
      children.push(render_node_html(child, options, depth + 1))
    }
    if children.length() == 0 {
      ""
    } else {
      "<div class=\"moonmarkmind-children\">\{children.join("")}</div>"
    }
  } else {
    ""
  }
  let body_html = if node.body.length() == 0 {
    ""
  } else {
    let body = node.body.join("\n\n")
    "<div class=\"moonmarkmind-node-body\">\{escape_html(body)}</div>"
  }
  "<article class=\"moonmarkmind-node\" data-level=\"\{node.level}\" data-node-index=\"\{node.flat_index}\"><strong class=\"moonmarkmind-node-title\">\{escape_html(node.title)}</strong>\{body_html}\{child_html}</article>"
}

///|
fn should_render_children(depth : Int, layer : MindmapLayer) -> Bool {
  match layer {
    Root => depth < 1
    Layer2 => depth < 2
    Full => true
  }
}

///|
fn layout_class(layout : MindmapLayout) -> String {
  match layout {
    Logic => "logic"
    Mindmap => "mindmap"
    Tree => "tree"
  }
}

///|
fn style_class(style : MindmapStyle) -> String {
  match style {
    Full => "full"
    Line => "line"
  }
}

///|
fn escape_html(source : String) -> String {
  source
  .replace(old="&", new="&amp;")
  .replace(old="<", new="&lt;")
  .replace(old=">", new="&gt;")
  .replace(old="\"", new="&quot;")
}

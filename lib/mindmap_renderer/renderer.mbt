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
  "\{export_stylesheet()}<section class=\"\{class_name}\">\{render_node_html(root, options, 0)}</section>"
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
fn export_stylesheet() -> String {
  (
    $|<style>
    $|.moonmarkmind-export {
    $|  box-sizing: border-box;
    $|  min-width: 100%;
    $|  min-height: 100%;
    $|  padding: 40px;
    $|  color: #172033;
    $|  background: #f7f9fc;
    $|  font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    $|  line-height: 1.45;
    $|}
    $|.moonmarkmind-export, .moonmarkmind-export * {
    $|  box-sizing: border-box;
    $|}
    $|.moonmarkmind-node {
    $|  position: relative;
    $|  margin: 0;
    $|  padding: 0;
    $|}
    $|.moonmarkmind-node-title {
    $|  display: inline-flex;
    $|  align-items: center;
    $|  justify-content: center;
    $|  max-width: 260px;
    $|  min-height: 36px;
    $|  padding: 8px 14px;
    $|  color: #142033;
    $|  background: #ffffff;
    $|  border: 1px solid #cfd8e6;
    $|  border-radius: 8px;
    $|  box-shadow: 0 8px 20px rgba(20, 32, 51, 0.08);
    $|  font-size: 14px;
    $|  font-weight: 700;
    $|  text-align: center;
    $|  white-space: normal;
    $|}
    $|.moonmarkmind-node-body {
    $|  max-width: 280px;
    $|  margin-top: 8px;
    $|  padding: 8px 10px;
    $|  color: #44546a;
    $|  background: rgba(255, 255, 255, 0.8);
    $|  border: 1px solid #e1e7f0;
    $|  border-radius: 6px;
    $|  font-size: 12px;
    $|  white-space: pre-wrap;
    $|}
    $|.moonmarkmind-children {
    $|  position: relative;
    $|}
    $|.moonmarkmind-export--line .moonmarkmind-node-title {
    $|  background: transparent;
    $|  border-color: #8aa0bd;
    $|  box-shadow: none;
    $|}
    $|.moonmarkmind-export--logic > .moonmarkmind-node,
    $|.moonmarkmind-export--mindmap > .moonmarkmind-node {
    $|  display: flex;
    $|  align-items: center;
    $|  justify-content: center;
    $|  gap: 36px;
    $|}
    $|.moonmarkmind-export--logic .moonmarkmind-node,
    $|.moonmarkmind-export--mindmap .moonmarkmind-node {
    $|  display: flex;
    $|  align-items: center;
    $|  gap: 28px;
    $|}
    $|.moonmarkmind-export--logic .moonmarkmind-children,
    $|.moonmarkmind-export--mindmap .moonmarkmind-children {
    $|  display: flex;
    $|  flex-direction: column;
    $|  gap: 18px;
    $|  padding-left: 28px;
    $|  border-left: 2px solid #b8c6d9;
    $|}
    $|.moonmarkmind-export--logic .moonmarkmind-children > .moonmarkmind-node::before,
    $|.moonmarkmind-export--mindmap .moonmarkmind-children > .moonmarkmind-node::before {
    $|  content: "";
    $|  position: absolute;
    $|  left: -28px;
    $|  top: 50%;
    $|  width: 28px;
    $|  border-top: 2px solid #b8c6d9;
    $|}
    $|.moonmarkmind-export--tree > .moonmarkmind-node,
    $|.moonmarkmind-export--tree .moonmarkmind-node {
    $|  display: flex;
    $|  flex-direction: column;
    $|  align-items: center;
    $|}
    $|.moonmarkmind-export--tree .moonmarkmind-children {
    $|  display: flex;
    $|  justify-content: center;
    $|  align-items: flex-start;
    $|  gap: 26px;
    $|  margin-top: 34px;
    $|  padding-top: 24px;
    $|  border-top: 2px solid #b8c6d9;
    $|}
    $|.moonmarkmind-export--tree .moonmarkmind-children::before {
    $|  content: "";
    $|  position: absolute;
    $|  top: -34px;
    $|  left: 50%;
    $|  height: 34px;
    $|  border-left: 2px solid #b8c6d9;
    $|}
    $|.moonmarkmind-export--tree .moonmarkmind-children > .moonmarkmind-node::before {
    $|  content: "";
    $|  position: absolute;
    $|  top: -24px;
    $|  left: 50%;
    $|  height: 24px;
    $|  border-left: 2px solid #b8c6d9;
    $|}
    $|.moonmarkmind-export--small .moonmarkmind-node-body,
    $|.moonmarkmind-export--medium .moonmarkmind-node-body {
    $|  display: none;
    $|}
    $|</style>
  )
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

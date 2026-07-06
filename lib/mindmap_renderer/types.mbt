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
fn stage_style_class(style : MindmapStyle) -> String {
  match style {
    Line => "mindmap-stage--branch-line"
    Full => "mindmap-stage--fill"
  }
}

///|
fn stage_class(options : RenderOptions, extra : String) -> String {
  "mindmap-stage \{extra} \{stage_style_class(options.style)}"
}

///|
fn node_style_class(style : MindmapStyle) -> String {
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
fn is_full_layer(layer : MindmapLayer) -> Bool {
  match layer {
    Full => true
    _ => false
  }
}

///|
fn should_render_layer_children(depth : Int, layer : MindmapLayer) -> Bool {
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

///|
/// Build a structured static mind-map document without raw HTML fragments.
pub fn build_markdown_document(
  markdown : String,
  options? : RenderOptions = default_render_options(),
) -> MarkupNode {
  build_outline_document(@outline.build_outline(markdown), options~)
}

///|
/// Build a structured static mind-map document without raw HTML fragments.
pub fn build_outline_document(
  root : @outline.OutlineNode,
  options? : RenderOptions = default_render_options(),
) -> MarkupNode {
  let classes = "moonmarkmind-export moonmarkmind-export--\{layout_class(options.layout)} moonmarkmind-export--\{style_class(options.style)} moonmarkmind-export--\{layer_to_detail_select(options.layer)}"
  html_element("main", attributes=[markup_attribute("class", classes)], children=[
    html_element("div", attributes=[markup_attribute("class", "mindmap")], children=[
      html_element(
        "div",
        attributes=[markup_attribute("class", "mindmap-content")],
        children=[build_structured_stage(root, options)],
      ),
    ]),
  ])
}

///|
/// Build the static SVG document tree. It deliberately contains no script node.
pub fn build_markdown_svg_document(
  markdown : String,
  options? : RenderOptions = default_render_options(),
) -> MarkupNode {
  build_outline_svg_document(@outline.build_outline(markdown), options~)
}

///|
pub fn build_outline_svg_document(
  root : @outline.OutlineNode,
  options? : RenderOptions = default_render_options(),
) -> MarkupNode {
  let boxes = static_boxes(root, options)
  let (width, height) = static_canvas_size(boxes)
  svg_element(
    "svg",
    attributes=[
      markup_attribute("xmlns", "http://www.w3.org/2000/svg"),
      markup_attribute("width", width.to_string()),
      markup_attribute("height", height.to_string()),
      markup_attribute("viewBox", "0 0 \{width} \{height}"),
    ],
    children=[
      svg_element(
        "foreignObject",
        attributes=[
          markup_attribute("x", "0"),
          markup_attribute("y", "0"),
          markup_attribute("width", width.to_string()),
          markup_attribute("height", height.to_string()),
        ],
        children=[
          html_element(
            "div",
            attributes=[
              markup_attribute("xmlns", "http://www.w3.org/1999/xhtml"),
            ],
            children=[build_outline_document(root, options~)],
          ),
        ],
      ),
    ],
  )
}

///|
fn build_structured_stage(
  root : @outline.OutlineNode,
  options : RenderOptions,
) -> MarkupNode {
  html_element(
    "div",
    attributes=[markup_attribute("class", stage_class(options, ""))],
    children=[build_structured_node(root, -1, 0, options)],
  )
}

///|
fn build_structured_node(
  node : @outline.OutlineNode,
  parent_index : Int,
  depth : Int,
  options : RenderOptions,
) -> MarkupNode {
  let children = [build_structured_card(node, parent_index, depth, options)]
  if should_render_layer_children(depth, options.layer) {
    for child in node.children {
      children.push(
        build_structured_node(child, node.flat_index, depth + 1, options),
      )
    }
  }
  html_element(
    "section",
    attributes=[
      markup_attribute("class", "single-right-tree__node"),
      markup_attribute("data-node-index", node.flat_index.to_string()),
      markup_attribute("data-parent-index", parent_index.to_string()),
      markup_attribute("data-depth", depth.to_string()),
    ],
    children~,
  )
}

///|
fn build_structured_card(
  node : @outline.OutlineNode,
  parent_index : Int,
  depth : Int,
  options : RenderOptions,
) -> MarkupNode {
  let content = [
    html_element(
      "strong",
      attributes=[markup_attribute("class", node_title_class(options.style))],
      children=[markup_text(node.title)],
    ),
  ]
  if node.body.length() > 0 && is_full_layer(options.layer) {
    let body_children = []
    for block in node.body {
      body_children.push(
        html_element(
          "p",
          attributes=[markup_attribute("class", "markdown-paragraph")],
          children=[markup_text(block)],
        ),
      )
    }
    content.push(
      html_element(
        "div",
        attributes=[markup_attribute("class", "node-body")],
        children=body_children,
      ),
    )
  }
  html_element(
    "article",
    attributes=[
      markup_attribute("class", "node \{node_style_class_for_options(options)}"),
      markup_attribute("data-node-index", node.flat_index.to_string()),
      markup_attribute("data-parent-index", parent_index.to_string()),
      markup_attribute("data-level", node.level.to_string()),
      markup_attribute("data-depth", depth.to_string()),
    ],
    children=content,
  )
}

///|
/// Tree node used by the browser-facing outline JSON.
///
/// `flat_index` keeps every rendered node tied back to the parser stream so UI
/// actions can rewrite the original Markdown through `outline_model.mbt`.
priv struct OutlineNode {
  flat_index : Int
  source_line : Int
  level : Int
  title : String
  marker : String
  body : Array[String]
  kind : MarkdownNodeKind
  synthetic : Bool
  children : Array[OutlineNode]
}

///|
fn build_outline(markdown : String) -> OutlineNode {
  // The parser may return zero roots, one real root, or multiple top-level
  // siblings. A synthetic root gives downstream renderers one stable entry.
  let nodes = parse_markdown_nodes(markdown)
  build_outline_from_nodes(nodes)
}

///|
fn build_outline_from_nodes(nodes : Array[MarkdownNode]) -> OutlineNode {
  if nodes.length() == 0 {
    return empty_outline()
  }
  if top_level_count(nodes) == 1 {
    let (root, _) = build_node(nodes, 0)
    return root
  }
  OutlineNode::{
    flat_index: -1,
    source_line: -1,
    level: 1,
    title: "Document",
    marker: "",
    body: [],
    kind: MarkdownNodeKind::Heading,
    synthetic: true,
    children: build_root_nodes(nodes),
  }
}

///|
fn empty_outline() -> OutlineNode {
  OutlineNode::{
    flat_index: -1,
    source_line: -1,
    level: 1,
    title: "Empty Document",
    marker: "",
    body: [],
    kind: MarkdownNodeKind::Heading,
    synthetic: true,
    children: [],
  }
}

///|
fn build_root_nodes(nodes : Array[MarkdownNode]) -> Array[OutlineNode] {
  let next = []
  let mut index = 0
  while index < nodes.length() {
    let (node, next_index) = build_node(nodes, index)
    next.push(node)
    index = next_index
  }
  next
}

///|
fn build_node(nodes : Array[MarkdownNode], index : Int) -> (OutlineNode, Int) {
  let node = nodes[index]
  let children = build_children(nodes, index)
  (
    OutlineNode::{
      flat_index: index,
      source_line: node.source_line,
      level: node.level,
      title: node.title,
      marker: node.marker,
      body: node.body,
      kind: node.kind,
      synthetic: false,
      children,
    },
    subtree_end(nodes, index),
  )
}

///|
fn build_children(
  nodes : Array[MarkdownNode],
  index : Int,
) -> Array[OutlineNode] {
  let (level, _) = (nodes[index].level, nodes[index].title)
  let children = []
  let mut cursor = index + 1
  while cursor < nodes.length() && nodes[cursor].level > level {
    let (child, next_cursor) = build_node(nodes, cursor)
    children.push(child)
    cursor = next_cursor
  }
  children
}

///|
fn top_level_count(nodes : Array[MarkdownNode]) -> Int {
  let mut count = 0
  for node in nodes {
    if node.level == 1 {
      count += 1
    }
  }
  count
}

///|
fn subtree_end(nodes : Array[MarkdownNode], index : Int) -> Int {
  let level = nodes[index].level
  let mut cursor = index + 1
  while cursor < nodes.length() && nodes[cursor].level > level {
    cursor += 1
  }
  cursor
}

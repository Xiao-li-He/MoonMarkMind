///|
priv struct OutlineNode {
  flat_index : Int
  level : Int
  title : String
  synthetic : Bool
  children : Array[OutlineNode]
}

///|
fn build_outline(markdown : String) -> OutlineNode {
  let headings = parse_headings(markdown)
  build_outline_from_headings(headings)
}

///|
fn build_outline_from_headings(headings : Array[(Int, String)]) -> OutlineNode {
  if headings.length() == 0 {
    return empty_outline()
  }
  if top_level_count(headings) == 1 {
    let (root, _) = build_node(headings, 0)
    return root
  }
  OutlineNode::{
    flat_index: -1,
    level: 1,
    title: "Document",
    synthetic: true,
    children: build_root_nodes(headings),
  }
}

///|
fn empty_outline() -> OutlineNode {
  OutlineNode::{
    flat_index: -1,
    level: 1,
    title: "Empty Document",
    synthetic: true,
    children: [],
  }
}

///|
fn build_root_nodes(headings : Array[(Int, String)]) -> Array[OutlineNode] {
  let nodes = []
  let mut index = 0
  while index < headings.length() {
    let (node, next_index) = build_node(headings, index)
    nodes.push(node)
    index = next_index
  }
  nodes
}

///|
fn build_node(
  headings : Array[(Int, String)],
  index : Int,
) -> (OutlineNode, Int) {
  let (level, title) = headings[index]
  let children = build_children(headings, index)
  (
    OutlineNode::{ flat_index: index, level, title, synthetic: false, children },
    subtree_end(headings, index),
  )
}

///|
fn build_children(
  headings : Array[(Int, String)],
  index : Int,
) -> Array[OutlineNode] {
  let (level, _) = headings[index]
  let children = []
  let mut cursor = index + 1
  while cursor < headings.length() && headings[cursor].0 > level {
    let (child, next_cursor) = build_node(headings, cursor)
    children.push(child)
    cursor = next_cursor
  }
  children
}

///|
pub fn outline_json(markdown : String) -> String {
  let root = build_outline(markdown)
  if root.children.length() == 0 && root.synthetic {
    return document_json("Empty Document", children_json="[]")
  }
  if root.synthetic {
    return document_json(
      root.title,
      children_json=render_outline_children_json(root.children),
    )
  }
  render_node_json_from_outline(root)
}

///|
pub fn rename_heading(
  markdown : String,
  flat_index : Int,
  title : String,
) -> String {
  let nodes = parse_markdown_nodes(markdown)
  if flat_index < 0 || flat_index >= nodes.length() {
    return markdown
  }
  let next_title = title.to_string()
  if next_title.length() == 0 {
    return markdown
  }
  let updated = []
  for i in 0..<nodes.length() {
    let node = nodes[i]
    if i == flat_index {
      updated.push(MarkdownNode::{
        kind: node.kind,
        level: node.level,
        title: next_title,
        marker: node.marker,
        body: node.body,
      })
    } else {
      updated.push(node)
    }
  }
  render_markdown_nodes(updated)
}

///|
pub fn move_heading(
  markdown : String,
  from_flat_index : Int,
  to_flat_index : Int,
  place_after : Bool,
) -> String {
  let nodes = parse_markdown_nodes(markdown)
  if !can_move_heading(nodes, from_flat_index, to_flat_index) {
    return markdown
  }
  let from_end = subtree_end(nodes, from_flat_index)
  let to_end = subtree_end(nodes, to_flat_index)
  let moved = slice_nodes(nodes, from_flat_index, from_end)
  let remaining = concat_nodes(
    slice_nodes(nodes, 0, from_flat_index),
    slice_nodes(nodes, from_end, nodes.length()),
  )
  let raw_insert_at = if place_after { to_end } else { to_flat_index }
  let insert_at = if from_flat_index < raw_insert_at {
    raw_insert_at - (from_end - from_flat_index)
  } else {
    raw_insert_at
  }
  let rebuilt = concat_nodes(
    concat_nodes(slice_nodes(remaining, 0, insert_at), moved),
    slice_nodes(remaining, insert_at, remaining.length()),
  )
  render_markdown_nodes(rebuilt)
}

///|
pub fn add_child_heading(
  markdown : String,
  parent_flat_index : Int,
  title : String,
) -> String {
  let nodes = parse_markdown_nodes(markdown)
  let next_title = title.to_string()
  if next_title.length() == 0 {
    return markdown
  }
  if parent_flat_index == -1 {
    let rebuilt = concat_nodes(nodes, [
      MarkdownNode::{
        kind: MarkdownNodeKind::Heading,
        level: 1,
        title: next_title,
        marker: "",
        body: [],
      },
    ])
    return render_markdown_nodes(rebuilt)
  }
  if parent_flat_index < 0 || parent_flat_index >= nodes.length() {
    return markdown
  }
  let parent = nodes[parent_flat_index]
  let child_level = parent.level + 1
  let child_kind = match parent.kind {
    MarkdownNodeKind::Heading =>
      if child_level <= 6 {
        MarkdownNodeKind::Heading
      } else {
        MarkdownNodeKind::ListItem
      }
    MarkdownNodeKind::ListItem => MarkdownNodeKind::ListItem
  }
  let insert_at = subtree_end(nodes, parent_flat_index)
  let rebuilt = concat_nodes(
    concat_nodes(slice_nodes(nodes, 0, insert_at), [
      MarkdownNode::{
        kind: child_kind,
        level: child_level,
        title: next_title,
        marker: if child_kind is MarkdownNodeKind::ListItem {
          "-"
        } else {
          ""
        },
        body: [],
      },
    ]),
    slice_nodes(nodes, insert_at, nodes.length()),
  )
  render_markdown_nodes(rebuilt)
}

///|
pub fn add_sibling_heading(
  markdown : String,
  flat_index : Int,
  title : String,
  place_after : Bool,
) -> String {
  let nodes = parse_markdown_nodes(markdown)
  let next_title = title.to_string()
  if next_title.length() == 0 {
    return markdown
  }
  if flat_index < 0 || flat_index >= nodes.length() {
    return markdown
  }
  let node = nodes[flat_index]
  let insert_at = if place_after {
    subtree_end(nodes, flat_index)
  } else {
    flat_index
  }
  let rebuilt = concat_nodes(
    concat_nodes(slice_nodes(nodes, 0, insert_at), [
      MarkdownNode::{
        kind: node.kind,
        level: node.level,
        title: next_title,
        marker: node.marker,
        body: [],
      },
    ]),
    slice_nodes(nodes, insert_at, nodes.length()),
  )
  render_markdown_nodes(rebuilt)
}

///|
pub fn delete_heading(markdown : String, flat_index : Int) -> String {
  let nodes = parse_markdown_nodes(markdown)
  if flat_index < 0 || flat_index >= nodes.length() {
    return markdown
  }
  let end_index = subtree_end(nodes, flat_index)
  let rebuilt = concat_nodes(
    slice_nodes(nodes, 0, flat_index),
    slice_nodes(nodes, end_index, nodes.length()),
  )
  render_markdown_nodes(rebuilt)
}

///|
pub fn move_heading_among_siblings(
  markdown : String,
  flat_index : Int,
  move_down : Bool,
) -> String {
  let nodes = parse_markdown_nodes(markdown)
  if flat_index < 0 || flat_index >= nodes.length() {
    return markdown
  }
  let siblings = sibling_indices(nodes, flat_index)
  let mut current = -1
  for index in 0..<siblings.length() {
    if siblings[index] == flat_index {
      current = index
    }
  }
  if current < 0 {
    return markdown
  }
  let target_index = if move_down {
    if current + 1 >= siblings.length() {
      return markdown
    }
    siblings[current + 1]
  } else {
    if current == 0 {
      return markdown
    }
    siblings[current - 1]
  }
  move_heading(markdown, flat_index, target_index, move_down)
}

///|
fn render_outline_markdown(root : OutlineNode) -> String {
  if root.synthetic {
    return render_outline_children_markdown(root.children, 0)
  }
  render_outline_node_markdown(root, 0)
}

///|
fn render_outline_children_markdown(
  children : Array[OutlineNode],
  list_indent : Int,
) -> String {
  let rendered = []
  for child in children {
    rendered.push(render_outline_node_markdown(child, list_indent))
  }
  rendered.join("\n")
}

///|
fn render_outline_node_markdown(
  node : OutlineNode,
  list_indent : Int,
) -> String {
  let current = match node.kind {
    MarkdownNodeKind::Heading => "\{repeat_hashes(node.level)} \{node.title}"
    MarkdownNodeKind::ListItem =>
      "\{repeat_spaces(list_indent * 2)}\{node.marker} \{node.title}"
  }
  let body = render_markdown_body(node.body)
  let child_indent = match node.kind {
    MarkdownNodeKind::Heading => 0
    MarkdownNodeKind::ListItem => list_indent + 1
  }
  let children = render_outline_children_markdown(node.children, child_indent)
  let with_body = if body.length() == 0 {
    current
  } else {
    "\{current}\n\{body}"
  }
  if children.length() == 0 {
    with_body
  } else {
    "\{with_body}\n\{children}"
  }
}

///|
fn render_markdown_nodes(nodes : Array[MarkdownNode]) -> String {
  render_outline_markdown(build_outline_from_nodes(nodes))
}

///|
fn render_markdown_body(body : Array[String]) -> String {
  body.join("\n")
}

///|
fn render_node_json_from_outline(node : OutlineNode) -> String {
  let flat_index_field = json_field(
    "flat_index",
    value=node.flat_index.to_string(),
  )
  let level_field = json_field("level", value=node.level.to_string())
  let title_field = json_field("title", value=json_string(node.title))
  let synthetic_field = json_field(
    "synthetic",
    value=node.synthetic.to_string(),
  )
  let children_field = render_outline_children_json(node.children)
  "{\{flat_index_field},\{level_field},\{title_field},\{synthetic_field},\"children\":\{children_field}}"
}

///|
fn render_outline_children_json(children : Array[OutlineNode]) -> String {
  let rendered = []
  for child in children {
    rendered.push(render_node_json_from_outline(child))
  }
  let joined = rendered.join(",")
  "[\{joined}]"
}

///|
fn document_json(title : String, children_json~ : String) -> String {
  let flat_index_field = json_field("flat_index", value="-1")
  let level_field = json_field("level", value="1")
  let title_field = json_field("title", value=json_string(title))
  let synthetic_field = json_field("synthetic", value="true")
  "{\{flat_index_field},\{level_field},\{title_field},\{synthetic_field},\"children\":\{children_json}}"
}

///|
fn can_move_heading(
  nodes : Array[MarkdownNode],
  from_flat_index : Int,
  to_flat_index : Int,
) -> Bool {
  if from_flat_index < 0 || to_flat_index < 0 {
    return false
  }
  if from_flat_index >= nodes.length() || to_flat_index >= nodes.length() {
    return false
  }
  if from_flat_index == to_flat_index {
    return false
  }
  parent_index(nodes, from_flat_index) == parent_index(nodes, to_flat_index)
}

///|
fn sibling_indices(nodes : Array[MarkdownNode], flat_index : Int) -> Array[Int] {
  let node = nodes[flat_index]
  let parent = parent_index(nodes, flat_index)
  let siblings = []
  for index in 0..<nodes.length() {
    if index == flat_index {
      siblings.push(index)
    } else if nodes[index].level == node.level &&
      parent_index(nodes, index) == parent {
      siblings.push(index)
    }
  }
  siblings
}

///|
fn parent_index(nodes : Array[MarkdownNode], index : Int) -> Int {
  let level = nodes[index].level
  let mut cursor = index - 1
  while cursor >= 0 {
    if nodes[cursor].level < level {
      return cursor
    }
    cursor -= 1
  }
  -1
}

///|
fn slice_nodes(
  nodes : Array[MarkdownNode],
  start : Int,
  end_ : Int,
) -> Array[MarkdownNode] {
  let sliced = []
  for i in start..<end_ {
    sliced.push(nodes[i])
  }
  sliced
}

///|
fn concat_nodes(
  left : Array[MarkdownNode],
  right : Array[MarkdownNode],
) -> Array[MarkdownNode] {
  let merged = []
  for item in left {
    merged.push(item)
  }
  for item in right {
    merged.push(item)
  }
  merged
}

///|
fn repeat_hashes(level : Int) -> String {
  let hashes = []
  for _ in 0..<level {
    hashes.push("#")
  }
  hashes.join("")
}

///|
fn repeat_spaces(count : Int) -> String {
  let spaces = []
  for _ in 0..<count {
    spaces.push(" ")
  }
  spaces.join("")
}

///|
fn json_field(name : String, value~ : String) -> String {
  "\"\{name}\":\{value}"
}

///|
fn json_string(source : String) -> String {
  let escaped_backslash = source.replace(old="\\", new="\\\\")
  let escaped_quote = escaped_backslash.replace(old="\"", new="\\\"")
  let escaped_newline = escaped_quote.replace(old="\n", new="\\n")
  "\"\{escaped_newline}\""
}

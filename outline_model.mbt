///|
pub fn outline_json(markdown : String) -> String {
  let headings = parse_headings(markdown)
  if headings.length() == 0 {
    return document_json("Empty Document", children_json="[]")
  }
  if top_level_count(headings) == 1 {
    let (root_json, _) = render_node_json(headings, 0)
    return root_json
  }
  document_json("Document", children_json=render_roots_json(headings))
}

///|
fn top_level_count(headings : Array[(Int, String)]) -> Int {
  let mut count = 0
  for heading in headings {
    if heading.0 == 1 {
      count += 1
    }
  }
  count
}

///|
pub fn rename_heading(
  markdown : String,
  flat_index : Int,
  title : String,
) -> String {
  let headings = parse_headings(markdown)
  if flat_index < 0 || flat_index >= headings.length() {
    return markdown
  }
  let next_title = title.to_string()
  if next_title.length() == 0 {
    return markdown
  }
  let updated = []
  for i in 0..<headings.length() {
    let (level, old_title) = headings[i]
    if i == flat_index {
      updated.push((level, next_title))
    } else {
      updated.push((level, old_title))
    }
  }
  render_markdown(updated)
}

///|
pub fn move_heading(
  markdown : String,
  from_flat_index : Int,
  to_flat_index : Int,
  place_after : Bool,
) -> String {
  let headings = parse_headings(markdown)
  if !can_move_heading(headings, from_flat_index, to_flat_index) {
    return markdown
  }
  let from_end = subtree_end(headings, from_flat_index)
  let to_end = subtree_end(headings, to_flat_index)
  let moved = slice_headings(headings, from_flat_index, from_end)
  let remaining = concat_headings(
    slice_headings(headings, 0, from_flat_index),
    slice_headings(headings, from_end, headings.length()),
  )
  let raw_insert_at = if place_after { to_end } else { to_flat_index }
  let insert_at = if from_flat_index < raw_insert_at {
    raw_insert_at - (from_end - from_flat_index)
  } else {
    raw_insert_at
  }
  let rebuilt = concat_headings(
    concat_headings(slice_headings(remaining, 0, insert_at), moved),
    slice_headings(remaining, insert_at, remaining.length()),
  )
  render_markdown(rebuilt)
}

///|
pub fn add_child_heading(
  markdown : String,
  parent_flat_index : Int,
  title : String,
) -> String {
  let headings = parse_headings(markdown)
  let next_title = title.to_string()
  if next_title.length() == 0 {
    return markdown
  }
  if parent_flat_index == -1 {
    let rebuilt = concat_headings(headings, [(1, next_title)])
    return render_markdown(rebuilt)
  }
  if parent_flat_index < 0 || parent_flat_index >= headings.length() {
    return markdown
  }
  let (level, _) = headings[parent_flat_index]
  let insert_at = subtree_end(headings, parent_flat_index)
  let rebuilt = concat_headings(
    concat_headings(slice_headings(headings, 0, insert_at), [
      (level + 1, next_title),
    ]),
    slice_headings(headings, insert_at, headings.length()),
  )
  render_markdown(rebuilt)
}

///|
pub fn delete_heading(markdown : String, flat_index : Int) -> String {
  let headings = parse_headings(markdown)
  if flat_index < 0 || flat_index >= headings.length() {
    return markdown
  }
  let end_index = subtree_end(headings, flat_index)
  let rebuilt = concat_headings(
    slice_headings(headings, 0, flat_index),
    slice_headings(headings, end_index, headings.length()),
  )
  render_markdown(rebuilt)
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
fn render_roots_json(headings : Array[(Int, String)]) -> String {
  let nodes = []
  let mut index = 0
  while index < headings.length() {
    let (node, next_index) = render_node_json(headings, index)
    nodes.push(node)
    index = next_index
  }
  let joined = nodes.join(",")
  "[\{joined}]"
}

///|
fn render_node_json(
  headings : Array[(Int, String)],
  index : Int,
) -> (String, Int) {
  let (level, title) = headings[index]
  let flat_index_field = json_field("flat_index", value=index.to_string())
  let level_field = json_field("level", value=level.to_string())
  let title_field = json_field("title", value=json_string(title))
  let synthetic_field = json_field("synthetic", value="false")
  let children_field = children_json(headings, index)
  (
    "{\{flat_index_field},\{level_field},\{title_field},\{synthetic_field},\"children\":\{children_field}}",
    subtree_end(headings, index),
  )
}

///|
fn children_json(headings : Array[(Int, String)], index : Int) -> String {
  let (level, _) = headings[index]
  let children = []
  let mut cursor = index + 1
  while cursor < headings.length() && headings[cursor].0 > level {
    let (child_json, next_cursor) = render_node_json(headings, cursor)
    children.push(child_json)
    cursor = next_cursor
  }
  let joined = children.join(",")
  "[\{joined}]"
}

///|
fn subtree_end(headings : Array[(Int, String)], index : Int) -> Int {
  let (level, _) = headings[index]
  let mut cursor = index + 1
  while cursor < headings.length() && headings[cursor].0 > level {
    cursor += 1
  }
  cursor
}

///|
fn can_move_heading(
  headings : Array[(Int, String)],
  from_flat_index : Int,
  to_flat_index : Int,
) -> Bool {
  if from_flat_index < 0 || to_flat_index < 0 {
    return false
  }
  if from_flat_index >= headings.length() || to_flat_index >= headings.length() {
    return false
  }
  if from_flat_index == to_flat_index {
    return false
  }
  parent_index(headings, from_flat_index) ==
  parent_index(headings, to_flat_index)
}

///|
fn parent_index(headings : Array[(Int, String)], index : Int) -> Int {
  let (level, _) = headings[index]
  let mut cursor = index - 1
  while cursor >= 0 {
    if headings[cursor].0 < level {
      return cursor
    }
    cursor -= 1
  }
  -1
}

///|
fn slice_headings(
  headings : Array[(Int, String)],
  start : Int,
  end_ : Int,
) -> Array[(Int, String)] {
  let sliced = []
  for i in start..<end_ {
    sliced.push(headings[i])
  }
  sliced
}

///|
fn concat_headings(
  left : Array[(Int, String)],
  right : Array[(Int, String)],
) -> Array[(Int, String)] {
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
fn render_markdown(headings : Array[(Int, String)]) -> String {
  let lines = []
  for heading in headings {
    let (level, title) = heading
    lines.push("\{repeat_hashes(level)} \{title}")
  }
  lines.join("\n")
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

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
        marker: normalized_marker(node.marker, node.level),
        body: node.body,
        body_blank_lines: node.body_blank_lines,
        leading_blank_lines: node.leading_blank_lines,
        source_line: node.source_line,
      })
    } else {
      updated.push(node)
    }
  }
  render_markdown_nodes(updated)
}

///|
fn update_node_body(
  markdown : String,
  flat_index : Int,
  body_text : String,
) -> String {
  let nodes = parse_markdown_nodes(markdown)
  if flat_index < 0 || flat_index >= nodes.length() {
    return markdown
  }
  let body_lines = normalize_note_editor_body_lines(
    body_text.split("\n").map(fn(line) { line.to_string() }).to_array(),
  )
  let updated = []
  for i in 0..<nodes.length() {
    let node = nodes[i]
    if i == flat_index {
      updated.push(MarkdownNode::{
        kind: node.kind,
        level: node.level,
        title: node.title,
        marker: node.marker,
        body: body_lines,
        body_blank_lines: default_body_blank_lines(body_lines),
        leading_blank_lines: node.leading_blank_lines,
        source_line: node.source_line,
      })
    } else {
      updated.push(node)
    }
  }
  render_markdown_nodes(updated)
}

///|
fn update_node_body_block(
  markdown : String,
  flat_index : Int,
  block_index : Int,
  block_text : String,
) -> String {
  let nodes = parse_markdown_nodes(markdown)
  if flat_index < 0 || flat_index >= nodes.length() {
    return markdown
  }
  let node = nodes[flat_index]
  if block_index < 0 || block_index >= node.body.length() {
    return markdown
  }
  let next_block = block_text.trim().to_string()
  if next_block.length() == 0 {
    return delete_node_body_block(markdown, flat_index, block_index)
  }
  let next_body = []
  for index in 0..<node.body.length() {
    if index == block_index {
      next_body.push(next_block)
    } else {
      next_body.push(node.body[index])
    }
  }
  replace_node_body_blocks(markdown, flat_index, next_body)
}

///|
fn delete_node_body_block(
  markdown : String,
  flat_index : Int,
  block_index : Int,
) -> String {
  let nodes = parse_markdown_nodes(markdown)
  if flat_index < 0 || flat_index >= nodes.length() {
    return markdown
  }
  let node = nodes[flat_index]
  if block_index < 0 || block_index >= node.body.length() {
    return markdown
  }
  let next_body = []
  for index in 0..<node.body.length() {
    if index != block_index {
      next_body.push(node.body[index])
    }
  }
  replace_node_body_blocks(markdown, flat_index, next_body)
}

///|
fn replace_node_body_blocks(
  markdown : String,
  flat_index : Int,
  next_body : Array[String],
) -> String {
  let nodes = parse_markdown_nodes(markdown)
  if flat_index < 0 || flat_index >= nodes.length() {
    return markdown
  }
  let updated = []
  for i in 0..<nodes.length() {
    let node = nodes[i]
    if i == flat_index {
      updated.push(MarkdownNode::{
        kind: node.kind,
        level: node.level,
        title: node.title,
        marker: node.marker,
        body: next_body,
        body_blank_lines: default_body_blank_lines(next_body),
        leading_blank_lines: node.leading_blank_lines,
        source_line: node.source_line,
      })
    } else {
      updated.push(node)
    }
  }
  render_markdown_nodes(updated)
}

///|
fn normalize_note_editor_body_lines(lines : Array[String]) -> Array[String] {
  let normalized = []
  let mut index = 0
  while index < lines.length() {
    let line = lines[index]
    if is_blank_markdown_line(line) {
      index += 1
    } else if is_markdown_code_fence_line(line) {
      let block = []
      block.push(line)
      index += 1
      while index < lines.length() {
        let next_line = lines[index]
        block.push(next_line)
        index += 1
        if is_markdown_code_fence_line(next_line) {
          break
        }
      }
      normalized.push(block.join("\n"))
    } else if starts_markdown_table_block(lines, index) {
      let block = []
      while index < lines.length() && is_markdown_table_row(lines[index]) {
        block.push(lines[index])
        index += 1
      }
      normalized.push(block.join("\n"))
    } else if is_note_list_body_line(line) {
      let block = []
      while index < lines.length() && is_note_list_body_line(lines[index]) {
        block.push(lines[index])
        index += 1
      }
      normalized.push(block.join("\n"))
    } else {
      normalized.push(line)
      index += 1
    }
  }
  normalized
}

///|
fn is_markdown_code_fence_line(line : String) -> Bool {
  line.trim().to_string().has_prefix("```")
}

///|
fn starts_markdown_table_block(lines : Array[String], index : Int) -> Bool {
  index + 1 < lines.length() &&
  is_markdown_table_row(lines[index]) &&
  is_markdown_table_separator(lines[index + 1])
}

///|
fn is_note_list_body_line(line : String) -> Bool {
  let trimmed = line.trim_start().to_string()
  parse_list_line(trimmed[:]) is Some(_)
}

///|
priv enum DropPlacement {
  DropBefore(Int)
  DropAfter(Int)
  DropInside(Int)
}

///|
priv struct MoveNodeResult {
  markdown : String
  selected_node : Int
  changed : Bool
  index_map : Array[Int]
}

///|
fn unchanged_move_node_result(
  markdown : String,
  nodes : Array[MarkdownNode],
  selected_node : Int,
) -> MoveNodeResult {
  MoveNodeResult::{
    markdown,
    selected_node,
    changed: false,
    index_map: identity_index_map(nodes.length()),
  }
}

///|
fn move_node_to_drop_placement(
  markdown : String,
  from_flat_index : Int,
  placement : DropPlacement,
) -> MoveNodeResult {
  let nodes = parse_markdown_nodes(markdown)
  if from_flat_index < 0 || from_flat_index >= nodes.length() {
    return unchanged_move_node_result(markdown, nodes, from_flat_index)
  }
  let from_end = subtree_end(nodes, from_flat_index)
  let moved_length = from_end - from_flat_index
  let (raw_insert_at, target_kind, target_marker, target_level) = match
    placement {
    DropBefore(target_index) => {
      if !can_drop_relative_to_node(nodes, from_flat_index, target_index) {
        return unchanged_move_node_result(markdown, nodes, from_flat_index)
      }
      let target = nodes[target_index]
      (target_index, target.kind, target.marker, target.level)
    }
    DropAfter(target_index) => {
      if !can_drop_relative_to_node(nodes, from_flat_index, target_index) {
        return unchanged_move_node_result(markdown, nodes, from_flat_index)
      }
      let target = nodes[target_index]
      (
        subtree_end(nodes, target_index),
        target.kind,
        target.marker,
        target.level,
      )
    }
    DropInside(parent_index) => {
      if !can_drop_inside_node(nodes, from_flat_index, parent_index) {
        return unchanged_move_node_result(markdown, nodes, from_flat_index)
      }
      if parent_index < 0 {
        (nodes.length(), MarkdownNodeKind::Heading, "", 1)
      } else {
        let parent = nodes[parent_index]
        let child_level = parent.level + 1
        (
          subtree_end(nodes, parent_index),
          normalized_node_kind(parent.kind, child_level),
          normalized_marker(parent.marker, child_level),
          child_level,
        )
      }
    }
  }
  let insert_at = adjusted_insert_index_after_removal(
    from_flat_index, from_end, raw_insert_at,
  )
  if insert_at == from_flat_index &&
    move_node_target_matches_source(
      nodes[from_flat_index],
      target_kind,
      target_marker,
      target_level,
    ) {
    return unchanged_move_node_result(markdown, nodes, from_flat_index)
  }
  let moved = relevel_subtree(
    slice_nodes(nodes, from_flat_index, from_end),
    target_level - nodes[from_flat_index].level,
  )
  let normalized_moved = normalize_moved_root_kind(
    moved, target_kind, target_marker, target_level,
  )
  let remaining = concat_nodes(
    slice_nodes(nodes, 0, from_flat_index),
    slice_nodes(nodes, from_end, nodes.length()),
  )
  let rebuilt = insert_nodes_at(remaining, insert_at, normalized_moved)
  let next_markdown = render_markdown_nodes(rebuilt)
  if next_markdown == markdown {
    return unchanged_move_node_result(markdown, nodes, from_flat_index)
  }
  MoveNodeResult::{
    markdown: next_markdown,
    selected_node: insert_at,
    changed: true,
    index_map: move_node_index_map(
      nodes.length(),
      from_flat_index,
      moved_length,
      insert_at,
    ),
  }
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
  let source_level = nodes[from_flat_index].level
  let target_level = nodes[to_flat_index].level
  let moved = relevel_subtree(
    slice_nodes(nodes, from_flat_index, from_end),
    target_level - source_level,
  )
  let target_node = nodes[to_flat_index]
  let source_kind_name = node_kind_name(nodes[from_flat_index].kind)
  let target_kind_name = node_kind_name(target_node.kind)
  let normalized_moved = if source_level == target_level &&
    source_kind_name == target_kind_name {
    moved
  } else {
    normalize_moved_root_kind(
      moved,
      target_node.kind,
      target_node.marker,
      target_level,
    )
  }
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
    concat_nodes(slice_nodes(remaining, 0, insert_at), normalized_moved),
    slice_nodes(remaining, insert_at, remaining.length()),
  )
  render_markdown_nodes(rebuilt)
}

///|
pub fn move_heading_prev(markdown : String, flat_index : Int) -> String {
  move_heading_in_direction(markdown, flat_index, false)
}

///|
pub fn move_heading_next(markdown : String, flat_index : Int) -> String {
  move_heading_in_direction(markdown, flat_index, true)
}

///|
pub fn move_heading_prev_with_selection(
  markdown : String,
  flat_index : Int,
) -> (String, Int) {
  move_heading_in_direction_with_selection(markdown, flat_index, false)
}

///|
pub fn move_heading_next_with_selection(
  markdown : String,
  flat_index : Int,
) -> (String, Int) {
  move_heading_in_direction_with_selection(markdown, flat_index, true)
}

///|
pub fn move_heading_among_siblings(
  markdown : String,
  flat_index : Int,
  move_down : Bool,
) -> String {
  move_heading_in_direction(markdown, flat_index, move_down)
}

///|
fn move_heading_in_direction(
  markdown : String,
  flat_index : Int,
  move_down : Bool,
) -> String {
  let nodes = parse_markdown_nodes(markdown)
  if flat_index < 0 || flat_index >= nodes.length() {
    return markdown
  }
  let node = nodes[flat_index]
  match node.kind {
    MarkdownNodeKind::Heading => {
      let (target_index, place_after) = resolve_heading_move_target(
        nodes, flat_index, move_down,
      )
      if target_index >= 0 {
        return move_heading(markdown, flat_index, target_index, place_after)
      }
      if move_down {
        return markdown
      }
      let parent = parent_index(nodes, flat_index)
      if parent < 0 || nodes[parent].level <= 1 {
        return markdown
      }
      promote_heading(markdown, flat_index)
    }
    MarkdownNodeKind::ListItem => {
      let (target_index, place_after) = resolve_list_move_target(
        nodes, flat_index, move_down,
      )
      if target_index < 0 {
        return markdown
      }
      move_heading(markdown, flat_index, target_index, place_after)
    }
  }
}

///|
fn move_heading_in_direction_with_selection(
  markdown : String,
  flat_index : Int,
  move_down : Bool,
) -> (String, Int) {
  let nodes = parse_markdown_nodes(markdown)
  if flat_index < 0 || flat_index >= nodes.length() {
    return (markdown, flat_index)
  }
  let node = nodes[flat_index]
  match node.kind {
    MarkdownNodeKind::Heading => {
      let (target_index, place_after) = resolve_heading_move_target(
        nodes, flat_index, move_down,
      )
      if target_index >= 0 {
        let moved_length = subtree_end(nodes, flat_index) - flat_index
        let target_end = subtree_end(nodes, target_index)
        let next_markdown = move_heading(
          markdown, flat_index, target_index, place_after,
        )
        let next_selected_node = if place_after {
          target_end - moved_length
        } else {
          target_index
        }
        return (next_markdown, next_selected_node)
      }
      if move_down {
        return (markdown, flat_index)
      }
      let parent = parent_index(nodes, flat_index)
      if parent < 0 || nodes[parent].level <= 1 {
        return (markdown, flat_index)
      }
      (promote_heading(markdown, flat_index), flat_index)
    }
    MarkdownNodeKind::ListItem => {
      let (target_index, place_after) = resolve_list_move_target(
        nodes, flat_index, move_down,
      )
      if target_index < 0 {
        return (markdown, flat_index)
      }
      let moved_length = subtree_end(nodes, flat_index) - flat_index
      let target_end = subtree_end(nodes, target_index)
      let next_markdown = move_heading(
        markdown, flat_index, target_index, place_after,
      )
      let next_selected_node = if place_after {
        target_end - moved_length
      } else {
        target_index
      }
      (next_markdown, next_selected_node)
    }
  }
}

///|
pub fn indent_heading(markdown : String, flat_index : Int) -> String {
  let nodes = parse_markdown_nodes(markdown)
  if flat_index <= 0 || flat_index >= nodes.length() {
    return markdown
  }
  let previous_sibling = previous_sibling_index(nodes, flat_index)
  if previous_sibling < 0 {
    return markdown
  }
  let current_level = nodes[flat_index].level
  let next_level = nodes[previous_sibling].level + 1
  render_markdown_nodes(
    apply_level_delta_to_subtree(nodes, flat_index, next_level - current_level),
  )
}

///|
pub fn promote_heading(markdown : String, flat_index : Int) -> String {
  let nodes = parse_markdown_nodes(markdown)
  if flat_index < 0 || flat_index >= nodes.length() {
    return markdown
  }
  if parent_index(nodes, flat_index) < 0 {
    return markdown
  }
  render_markdown_nodes(apply_level_delta_to_subtree(nodes, flat_index, -1))
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
    let rebuilt = insert_nodes_at(nodes, nodes.length(), [
      MarkdownNode::{
        kind: MarkdownNodeKind::Heading,
        level: 1,
        title: next_title,
        marker: "",
        body: [],
        body_blank_lines: [],
        leading_blank_lines: default_insert_leading_blank_lines(nodes),
        source_line: -1,
      },
    ])
    return render_markdown_nodes(rebuilt)
  }
  if parent_flat_index < 0 || parent_flat_index >= nodes.length() {
    return markdown
  }
  let parent = nodes[parent_flat_index]
  let child_level = parent.level + 1
  let insert_at = subtree_end(nodes, parent_flat_index)
  let rebuilt = insert_nodes_at(nodes, insert_at, [
    MarkdownNode::{
      kind: normalized_node_kind(parent.kind, child_level),
      level: child_level,
      title: next_title,
      marker: normalized_marker(parent.marker, child_level),
      body: [],
      body_blank_lines: [],
      leading_blank_lines: 0,
      source_line: -1,
    },
  ])
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
  let rebuilt = insert_nodes_at(nodes, insert_at, [
    MarkdownNode::{
      kind: node.kind,
      level: node.level,
      title: next_title,
      marker: normalized_marker(node.marker, node.level),
      body: [],
      body_blank_lines: [],
      leading_blank_lines: 0,
      source_line: -1,
    },
  ])
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
fn render_markdown_nodes(nodes : Array[MarkdownNode]) -> String {
  render_flat_markdown_nodes(nodes)
}

///|
fn render_flat_markdown_nodes(nodes : Array[MarkdownNode]) -> String {
  let lines = []
  for index in 0..<nodes.length() {
    let node = nodes[index]
    for _ in 0..<node.leading_blank_lines {
      lines.push("")
    }
    lines.push(render_flat_markdown_node_line(nodes, index))
    let body_prefix = match node.kind {
      MarkdownNodeKind::Heading => ""
      MarkdownNodeKind::ListItem =>
        repeat_spaces((flat_list_indent(nodes, index) + 1) * 2)
    }
    append_rendered_body_lines(lines, node, body_prefix)
  }
  lines.join("\n")
}

///|
fn render_flat_markdown_node_line(
  nodes : Array[MarkdownNode],
  index : Int,
) -> String {
  let node = nodes[index]
  match node.kind {
    MarkdownNodeKind::Heading => "\{repeat_hashes(node.level)} \{node.title}"
    MarkdownNodeKind::ListItem =>
      "\{repeat_spaces(flat_list_indent(nodes, index) * 2)}\{node.marker} \{node.title}"
  }
}

///|
fn flat_list_indent(nodes : Array[MarkdownNode], index : Int) -> Int {
  let mut indent = 0
  let mut cursor = parent_index(nodes, index)
  while cursor >= 0 {
    match nodes[cursor].kind {
      MarkdownNodeKind::ListItem => indent += 1
      MarkdownNodeKind::Heading => ()
    }
    cursor = parent_index(nodes, cursor)
  }
  indent
}

///|
fn append_rendered_body_lines(
  lines : Array[String],
  node : MarkdownNode,
  prefix : String,
) -> Unit {
  for index in 0..<node.body.length() {
    let blank_count = node.body_blank_lines
      .get(index)
      .unwrap_or(default_body_blank_line_count(index))
    for _ in 0..<blank_count {
      lines.push("")
    }
    for
      line in indent_markdown_block(node.body[index], prefix)
      .split("\n")
      .to_array() {
      lines.push(line.to_string())
    }
  }
}

///|
fn default_body_blank_lines(body : Array[String]) -> Array[Int] {
  let blanks = []
  for index in 0..<body.length() {
    blanks.push(default_body_blank_line_count(index))
  }
  blanks
}

///|
fn default_body_blank_line_count(index : Int) -> Int {
  if index == 0 {
    0
  } else {
    1
  }
}

///|
fn default_insert_leading_blank_lines(nodes : Array[MarkdownNode]) -> Int {
  if nodes.length() == 0 {
    0
  } else {
    1
  }
}

///|
fn insert_nodes_at(
  nodes : Array[MarkdownNode],
  insert_at : Int,
  inserted : Array[MarkdownNode],
) -> Array[MarkdownNode] {
  if inserted.length() == 0 {
    return nodes
  }
  if insert_at < 0 || insert_at > nodes.length() {
    return nodes
  }
  let prefix = slice_nodes(nodes, 0, insert_at)
  let suffix = slice_nodes(nodes, insert_at, nodes.length())
  if suffix.length() == 0 {
    return concat_nodes(prefix, inserted_nodes_with_context(prefix, inserted))
  }
  let adjusted_inserted = []
  for index in 0..<inserted.length() {
    let next_leading = if index == 0 {
      suffix[0].leading_blank_lines
    } else {
      inserted[index].leading_blank_lines
    }
    adjusted_inserted.push(
      with_leading_blank_lines(
        inserted[index],
        inserted_leading_blank_lines(
          prefix,
          adjusted_inserted,
          inserted[index],
          next_leading,
        ),
      ),
    )
  }
  let adjusted_suffix = [
    with_leading_blank_lines(
      suffix[0],
      suffix_leading_blank_lines(adjusted_inserted, suffix[0]),
    ),
  ]
  for index in 1..<suffix.length() {
    adjusted_suffix.push(suffix[index])
  }
  concat_nodes(concat_nodes(prefix, adjusted_inserted), adjusted_suffix)
}

///|
fn suffix_leading_blank_lines(
  inserted_before : Array[MarkdownNode],
  suffix_node : MarkdownNode,
) -> Int {
  if inserted_before.length() == 0 {
    return 0
  }
  let previous = inserted_before[inserted_before.length() - 1]
  match (previous.kind, suffix_node.kind) {
    (MarkdownNodeKind::ListItem, MarkdownNodeKind::Heading) => 1
    _ => 0
  }
}

///|
fn inserted_nodes_with_context(
  prefix : Array[MarkdownNode],
  inserted : Array[MarkdownNode],
) -> Array[MarkdownNode] {
  let adjusted = []
  for node in inserted {
    adjusted.push(
      with_leading_blank_lines(
        node,
        inserted_leading_blank_lines(
          prefix,
          adjusted,
          node,
          node.leading_blank_lines,
        ),
      ),
    )
  }
  adjusted
}

///|
fn inserted_leading_blank_lines(
  prefix : Array[MarkdownNode],
  inserted_before : Array[MarkdownNode],
  node : MarkdownNode,
  inherited : Int,
) -> Int {
  let previous = if inserted_before.length() > 0 {
    Some(inserted_before[inserted_before.length() - 1])
  } else if prefix.length() > 0 {
    Some(prefix[prefix.length() - 1])
  } else {
    None
  }
  match previous {
    Some(prev) =>
      match (prev.kind, node.kind) {
        (MarkdownNodeKind::ListItem, MarkdownNodeKind::Heading) =>
          if inherited < 1 {
            1
          } else {
            inherited
          }
        (MarkdownNodeKind::ListItem, MarkdownNodeKind::ListItem) => 0
        _ => inherited
      }
    None => inherited
  }
}

///|
fn with_leading_blank_lines(
  node : MarkdownNode,
  leading_blank_lines : Int,
) -> MarkdownNode {
  MarkdownNode::{
    kind: node.kind,
    level: node.level,
    title: node.title,
    marker: node.marker,
    body: node.body,
    body_blank_lines: node.body_blank_lines,
    leading_blank_lines,
    source_line: node.source_line,
  }
}

///|
fn indent_markdown_block(block : String, prefix : String) -> String {
  if prefix.length() == 0 {
    return block
  }
  let lines = block.split("\n").to_array()
  let indented = []
  for line in lines {
    indented.push("\{prefix}\{line}")
  }
  indented.join("\n")
}

///|
fn render_node_json_from_outline(node : OutlineNode) -> String {
  let _ = node.marker
  let flat_index_field = json_field(
    "flat_index",
    value=node.flat_index.to_string(),
  )
  let source_line_field = json_field(
    "source_line",
    value=node.source_line.to_string(),
  )
  let level_field = json_field("level", value=node.level.to_string())
  let type_field = json_field(
    "type",
    value=json_string(node_kind_name(node.kind)),
  )
  let title_field = json_field("title", value=json_string(node.title))
  let synthetic_field = json_field(
    "synthetic",
    value=node.synthetic.to_string(),
  )
  let children_field = render_outline_children_json(node.children)
  "{\{flat_index_field},\{source_line_field},\{level_field},\{type_field},\{title_field},\{synthetic_field},\"children\":\{children_field}}"
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
  let source_line_field = json_field("source_line", value="-1")
  let level_field = json_field("level", value="1")
  let type_field = json_field("type", value=json_string("document"))
  let title_field = json_field("title", value=json_string(title))
  let synthetic_field = json_field("synthetic", value="true")
  "{\{flat_index_field},\{source_line_field},\{level_field},\{type_field},\{title_field},\{synthetic_field},\"children\":\{children_json}}"
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
  let from_end = subtree_end(nodes, from_flat_index)
  to_flat_index < from_flat_index || to_flat_index >= from_end
}

///|
fn can_drop_relative_to_node(
  nodes : Array[MarkdownNode],
  from_flat_index : Int,
  target_index : Int,
) -> Bool {
  if from_flat_index < 0 ||
    target_index < 0 ||
    from_flat_index >= nodes.length() ||
    target_index >= nodes.length() {
    return false
  }
  if from_flat_index == target_index {
    return false
  }
  let from_end = subtree_end(nodes, from_flat_index)
  target_index < from_flat_index || target_index >= from_end
}

///|
fn can_drop_inside_node(
  nodes : Array[MarkdownNode],
  from_flat_index : Int,
  parent_index : Int,
) -> Bool {
  if from_flat_index < 0 || from_flat_index >= nodes.length() {
    return false
  }
  if parent_index < 0 {
    return true
  }
  if parent_index >= nodes.length() || parent_index == from_flat_index {
    return false
  }
  let from_end = subtree_end(nodes, from_flat_index)
  parent_index < from_flat_index || parent_index >= from_end
}

///|
fn adjusted_insert_index_after_removal(
  from_flat_index : Int,
  from_end : Int,
  raw_insert_at : Int,
) -> Int {
  if from_flat_index < raw_insert_at {
    raw_insert_at - (from_end - from_flat_index)
  } else {
    raw_insert_at
  }
}

///|
fn move_node_target_matches_source(
  source : MarkdownNode,
  target_kind : MarkdownNodeKind,
  target_marker : String,
  target_level : Int,
) -> Bool {
  source.level == target_level &&
  node_kind_name(source.kind) == node_kind_name(target_kind) &&
  normalized_marker(source.marker, target_level) ==
  normalized_marker(target_marker, target_level)
}

///|
fn identity_index_map(length : Int) -> Array[Int] {
  let map = []
  for index in 0..<length {
    map.push(index)
  }
  map
}

///|
fn move_node_index_map(
  length : Int,
  from_flat_index : Int,
  moved_length : Int,
  insert_at : Int,
) -> Array[Int] {
  let map = []
  let from_end = from_flat_index + moved_length
  for index in 0..<length {
    if index >= from_flat_index && index < from_end {
      map.push(insert_at + index - from_flat_index)
    } else {
      let remaining_index = if index >= from_end {
        index - moved_length
      } else {
        index
      }
      if remaining_index >= insert_at {
        map.push(remaining_index + moved_length)
      } else {
        map.push(remaining_index)
      }
    }
  }
  map
}

///|
fn resolve_heading_move_target(
  nodes : Array[MarkdownNode],
  flat_index : Int,
  move_down : Bool,
) -> (Int, Bool) {
  if flat_index < 0 || flat_index >= nodes.length() {
    return (-1, false)
  }
  let previous = previous_same_kind_sibling_index(nodes, flat_index)
  let next = next_same_kind_sibling_index(nodes, flat_index)
  if move_down {
    if next >= 0 {
      return (next, true)
    }
    return (-1, false)
  }
  if previous >= 0 {
    return (previous, false)
  }
  let parent = parent_index(nodes, flat_index)
  if parent < 0 || nodes[parent].level <= 1 {
    return (-1, false)
  }
  (parent, true)
}

///|
fn resolve_list_move_target(
  nodes : Array[MarkdownNode],
  flat_index : Int,
  move_down : Bool,
) -> (Int, Bool) {
  if flat_index < 0 || flat_index >= nodes.length() {
    return (-1, false)
  }
  let previous = previous_same_kind_sibling_index(nodes, flat_index)
  let next = next_same_kind_sibling_index(nodes, flat_index)
  if move_down {
    if next >= 0 {
      return (next, true)
    }
    return (-1, false)
  }
  if previous >= 0 {
    return (previous, false)
  }
  (-1, false)
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
fn previous_sibling_index(nodes : Array[MarkdownNode], index : Int) -> Int {
  let level = nodes[index].level
  let parent = parent_index(nodes, index)
  let mut cursor = index - 1
  while cursor >= 0 {
    if nodes[cursor].level < level {
      return -1
    }
    if nodes[cursor].level == level && parent_index(nodes, cursor) == parent {
      return cursor
    }
    cursor -= 1
  }
  -1
}

///|
fn same_kind_sibling_indices(
  nodes : Array[MarkdownNode],
  flat_index : Int,
) -> Array[Int] {
  let node = nodes[flat_index]
  let parent = parent_index(nodes, flat_index)
  let siblings = []
  for index in 0..<nodes.length() {
    if index == flat_index {
      siblings.push(index)
    } else if nodes[index].level == node.level &&
      node_kind_name(nodes[index].kind) == node_kind_name(node.kind) &&
      parent_index(nodes, index) == parent {
      siblings.push(index)
    }
  }
  siblings
}

///|
fn previous_same_kind_sibling_index(
  nodes : Array[MarkdownNode],
  index : Int,
) -> Int {
  let siblings = same_kind_sibling_indices(nodes, index)
  let mut previous = -1
  for sibling in siblings {
    if sibling == index {
      return previous
    }
    previous = sibling
  }
  -1
}

///|
fn next_same_kind_sibling_index(
  nodes : Array[MarkdownNode],
  index : Int,
) -> Int {
  let siblings = same_kind_sibling_indices(nodes, index)
  let mut seen_self = false
  for sibling in siblings {
    if seen_self {
      return sibling
    }
    if sibling == index {
      seen_self = true
    }
  }
  -1
}

///|
fn apply_level_delta_to_subtree(
  nodes : Array[MarkdownNode],
  flat_index : Int,
  delta : Int,
) -> Array[MarkdownNode] {
  let end_index = subtree_end(nodes, flat_index)
  let rebuilt = []
  for index in 0..<nodes.length() {
    if index >= flat_index && index < end_index {
      rebuilt.push(relevel_node(nodes[index], delta))
    } else {
      rebuilt.push(nodes[index])
    }
  }
  rebuilt
}

///|
fn relevel_subtree(
  nodes : Array[MarkdownNode],
  delta : Int,
) -> Array[MarkdownNode] {
  let rebuilt = []
  for node in nodes {
    rebuilt.push(relevel_node(node, delta))
  }
  rebuilt
}

///|
fn relevel_node(node : MarkdownNode, delta : Int) -> MarkdownNode {
  let next_level = node.level + delta
  let kind = normalized_node_kind(node.kind, next_level)
  MarkdownNode::{
    kind,
    level: next_level,
    title: node.title,
    marker: normalized_marker(node.marker, next_level),
    body: node.body,
    body_blank_lines: node.body_blank_lines,
    leading_blank_lines: node.leading_blank_lines,
    source_line: node.source_line,
  }
}

///|
fn normalize_moved_root_kind(
  moved : Array[MarkdownNode],
  target_kind : MarkdownNodeKind,
  target_marker : String,
  target_level : Int,
) -> Array[MarkdownNode] {
  if moved.length() == 0 {
    return moved
  }
  let root = moved[0]
  let next_root = MarkdownNode::{
    kind: target_kind,
    level: target_level,
    title: root.title,
    marker: match target_kind {
      MarkdownNodeKind::Heading => ""
      MarkdownNodeKind::ListItem => target_marker
    },
    body: root.body,
    body_blank_lines: root.body_blank_lines,
    leading_blank_lines: root.leading_blank_lines,
    source_line: root.source_line,
  }
  let rebuilt = [next_root]
  for index in 1..<moved.length() {
    rebuilt.push(moved[index])
  }
  rebuilt
}

///|
fn normalized_node_kind(
  kind : MarkdownNodeKind,
  level : Int,
) -> MarkdownNodeKind {
  if level > 6 {
    MarkdownNodeKind::ListItem
  } else {
    kind
  }
}

///|
fn normalized_marker(marker : String, level : Int) -> String {
  if level > 6 {
    if marker.length() == 0 {
      "-"
    } else {
      marker
    }
  } else if marker.length() == 0 {
    "-"
  } else {
    marker
  }
}

///|
fn node_kind_name(kind : MarkdownNodeKind) -> String {
  match kind {
    MarkdownNodeKind::Heading => "heading"
    MarkdownNodeKind::ListItem => "list_item"
  }
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

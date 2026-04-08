///|
priv enum MarkdownNodeKind {
  Heading
  ListItem
}

///|
priv struct MarkdownNode {
  kind : MarkdownNodeKind
  level : Int
  title : String
  marker : String
  body : Array[String]
  source_line : Int
}

///|
priv struct ParseContext {
  kind : MarkdownNodeKind
  level : Int
  indent : Int
}

///|
pub fn parse_headings(markdown : String) -> Array[(Int, String)] {
  let headings = []
  for node in parse_markdown_nodes(markdown) {
    match node.kind {
      MarkdownNodeKind::Heading => headings.push((node.level, node.title))
      _ => ()
    }
  }
  headings
}

///|
fn parse_markdown_nodes(markdown : String) -> Array[MarkdownNode] {
  let nodes = []
  let mut stack : Array[ParseContext] = []
  let lines = markdown.split("\n").to_array()
  for line_index in 0..<lines.length() {
    let line = lines[line_index]
    match parse_heading_line(line) {
      Some(heading) => {
        let (level, title) = heading
        stack = pop_contexts_while_level_at_least(stack, level)
        nodes.push(MarkdownNode::{
          kind: MarkdownNodeKind::Heading,
          level,
          title,
          marker: "",
          body: [],
          source_line: line_index,
        })
        stack.push(ParseContext::{
          kind: MarkdownNodeKind::Heading,
          level,
          indent: -1,
        })
      }
      None =>
        match parse_list_line(line) {
          Some(list_item) => {
            let (indent, marker, title) = list_item
            stack = pop_list_contexts_while_indent_at_least(stack, indent)
            let parent_level = if stack.length() == 0 {
              0
            } else {
              stack[stack.length() - 1].level
            }
            let level = parent_level + 1
            nodes.push(MarkdownNode::{
              kind: MarkdownNodeKind::ListItem,
              level,
              title,
              marker,
              body: [],
              source_line: line_index,
            })
            stack.push(ParseContext::{
              kind: MarkdownNodeKind::ListItem,
              level,
              indent,
            })
          }
          None =>
            if nodes.length() > 0 {
              nodes[nodes.length() - 1].body.push(line.to_string())
            }
        }
    }
  }
  nodes
}

///|
fn parse_heading_line(line : StringView) -> (Int, String)? {
  if line.length() == 0 || line[0] != '#' {
    return None
  }
  let mut hash_count = 0
  while hash_count < line.length() && line[hash_count] == '#' {
    hash_count += 1
  }
  if hash_count == 0 || hash_count > 6 {
    return None
  }
  if hash_count >= line.length() || line[hash_count] != ' ' {
    return None
  }
  Some((hash_count, view_tail_to_string(line, hash_count + 1)))
}

///|
fn parse_list_line(line : StringView) -> (Int, String, String)? {
  let indent = count_leading_spaces(line)
  if indent >= line.length() {
    return None
  }
  let start = indent
  let marker = line[start]
  if marker == '-' || marker == '*' || marker == '+' {
    if start + 1 >= line.length() || line[start + 1] != ' ' {
      return None
    }
    let marker_str = match marker {
      '-' => "-"
      '*' => "*"
      '+' => "+"
      _ => "-"
    }
    return Some((indent, marker_str, view_tail_to_string(line, start + 2)))
  }
  if marker < '0' || marker > '9' {
    return None
  }
  let mut cursor = start
  while cursor < line.length() {
    let ch = line[cursor]
    if ch < '0' || ch > '9' {
      break
    }
    cursor += 1
  }
  if cursor >= line.length() || line[cursor] != '.' {
    return None
  }
  cursor += 1
  if cursor >= line.length() || line[cursor] != ' ' {
    return None
  }
  Some(
    (
      indent,
      view_slice_to_string(line, start, cursor),
      view_tail_to_string(line, cursor + 1),
    ),
  )
}

///|
fn count_leading_spaces(line : StringView) -> Int {
  let mut count = 0
  while count < line.length() {
    let ch = line[count]
    if ch == ' ' {
      count += 1
    } else if ch == '\t' {
      count += 2
    } else {
      break
    }
  }
  count
}

///|
fn view_tail_to_string(line : StringView, start : Int) -> String {
  line[start:].to_string()
}

///|
fn view_slice_to_string(line : StringView, start : Int, end_ : Int) -> String {
  line[start:end_].to_string()
}

///|
fn pop_contexts_while_level_at_least(
  stack : Array[ParseContext],
  level : Int,
) -> Array[ParseContext] {
  let mut next = stack
  while next.length() > 0 && next[next.length() - 1].level >= level {
    next = slice_contexts(next, 0, next.length() - 1)
  }
  next
}

///|
fn pop_list_contexts_while_indent_at_least(
  stack : Array[ParseContext],
  indent : Int,
) -> Array[ParseContext] {
  let mut next = stack
  while next.length() > 0 {
    let top = next[next.length() - 1]
    match top.kind {
      MarkdownNodeKind::ListItem => {
        if top.indent < indent {
          break
        }
        next = slice_contexts(next, 0, next.length() - 1)
      }
      _ => break
    }
  }
  next
}

///|
fn slice_contexts(
  contexts : Array[ParseContext],
  start : Int,
  end_ : Int,
) -> Array[ParseContext] {
  let sliced = []
  for i in start..<end_ {
    sliced.push(contexts[i])
  }
  sliced
}

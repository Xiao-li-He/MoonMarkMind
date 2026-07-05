///|
/// Render a Markdown body fragment to a safe HTML fragment.
pub fn render(markdown : String) -> String {
  let parts = []
  for block in split_markdown_blocks(markdown) {
    match render_heading_block(block) {
      Some(heading) => parts.push(heading)
      None => parts.push(@markdown.render_markdown_blocks_html([block]))
    }
  }
  parts.join("")
}

///|
/// Render inline Markdown to a safe HTML fragment.
pub fn render_inline(source : String) -> String {
  @markdown.render_markdown_inline_html(source)
}

///|
/// Render a mind-map node title to a safe HTML fragment.
pub fn render_title(source : String) -> String {
  @markdown.render_markdown_title_html(source)
}

///|
/// Render Markdown body blocks that have already been split by blank lines.
pub fn render_blocks(blocks : Array[String]) -> String {
  @markdown.render_markdown_blocks_html(blocks)
}

///|
fn render_heading_block(block : String) -> String? {
  let trimmed = block.trim().to_owned()
  let mut level = 0
  while level < trimmed.length() &&
        level < 6 &&
        trimmed[level].to_int().unsafe_to_char() == '#' {
    level += 1
  }
  if level == 0 ||
    level >= trimmed.length() ||
    trimmed[level].to_int().unsafe_to_char() != ' ' {
    return None
  }
  let title = trimmed[level + 1:].to_owned().trim().to_owned()
  if title.length() == 0 {
    None
  } else {
    Some(
      "<h\{level} class=\"markdown-heading markdown-heading--h\{level}\">\{render_title(title)}</h\{level}>",
    )
  }
}

///|
fn split_markdown_blocks(markdown : String) -> Array[String] {
  let blocks = []
  let current = []
  let mut in_code = false
  let mut in_math = false
  for line in markdown.split("\n") {
    let owned = line.to_owned()
    let trimmed = owned.trim().to_owned()
    if trimmed.has_prefix("```") {
      current.push(owned)
      in_code = !in_code
    } else if trimmed.has_prefix("$$") &&
      trimmed.has_suffix("$$") &&
      trimmed.length() > 2 {
      current.push(owned)
    } else if trimmed.has_prefix("$$") {
      current.push(owned)
      in_math = !in_math
    } else if trimmed.length() == 0 && !in_code && !in_math {
      if current.length() > 0 {
        blocks.push(current.join("\n"))
        current.clear()
      }
    } else {
      current.push(owned)
    }
  }
  if current.length() > 0 {
    blocks.push(current.join("\n"))
  }
  blocks
}

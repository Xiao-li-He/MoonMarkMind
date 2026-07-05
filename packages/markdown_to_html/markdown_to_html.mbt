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
/// Render the CSS needed by math fragments emitted from this package.
pub fn render_math_style_css() -> String {
  @math.math_style_css()
}

///|
/// Render CSS for the Markdown structural classes emitted from this package.
pub fn render_markdown_style_css() -> String {
  (
    $|.markdown-heading { margin: 0 0 0.45em; line-height: 1.25; }
    $|.markdown-heading--h1 { font-size: 1.55em; }
    $|.markdown-heading--h2 { font-size: 1.35em; }
    $|.markdown-heading--h3 { font-size: 1.2em; }
    $|.markdown-heading--h4,
    $|.markdown-heading--h5,
    $|.markdown-heading--h6 { font-size: 1.05em; }
    $|.markdown-paragraph { margin: 0 0 0.75em; white-space: normal; }
    $|.markdown-strong { font-weight: 800; }
    $|.markdown-emphasis { font-style: italic; }
    $|.markdown-inline-code { display: inline-block; padding: 1px 4px; border-radius: 5px; background: rgba(32, 57, 82, 0.1); color: #28415d; font-family: "Cascadia Mono", Consolas, monospace; font-size: 0.92em; }
    $|.markdown-strike { text-decoration: line-through; opacity: 0.74; }
    $|.markdown-link { color: #2c70ce; text-decoration: underline; text-underline-offset: 2px; }
    $|.markdown-image { display: block; max-width: 100%; max-height: 96px; height: auto; width: auto; margin: 0; border-radius: 6px; object-fit: contain; }
    $|.markdown-list { margin: 0 0 0.75em; padding-left: 1.35em; }
    $|.markdown-list .markdown-list { margin: 0.18em 0 0; }
    $|.markdown-list__item { margin: 0.12em 0; }
    $|.markdown-task { display: flex; align-items: flex-start; gap: 6px; margin: 0 0 0.75em; }
    $|.markdown-task--title { display: inline-flex; align-items: center; margin: 0; }
    $|.markdown-task__check { width: 13px; height: 13px; margin: 2px 0 0 0; flex: 0 0 auto; }
    $|.markdown-code-block { margin: 0 0 0.85em; padding: 9px 10px; border-radius: 6px; background: rgba(32, 57, 82, 0.08); overflow-x: auto; }
    $|.markdown-code-block__code { font-family: "Cascadia Mono", Consolas, monospace; font-size: 0.92em; white-space: pre; }
    $|.markdown-table { width: 100%; border-collapse: collapse; font-size: 11px; line-height: 1.35; overflow: hidden; margin: 0 0 0.85em; }
    $|.markdown-table th,
    $|.markdown-table td { padding: 3px 5px; border: 1px solid rgba(167, 190, 214, 0.5); vertical-align: top; word-break: break-word; }
    $|.markdown-table th { font-weight: 800; background: rgba(214, 230, 245, 0.5); }
  )
}

///|
/// Render a style element for standalone HTML documents.
pub fn render_style_element() -> String {
  "<style>\{render_markdown_style_css()}\n\{render_math_style_css()}</style>"
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
    } else if is_markdown_heading_line(trimmed) && !in_code && !in_math {
      if current.length() > 0 {
        blocks.push(current.join("\n"))
        current.clear()
      }
      blocks.push(owned)
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

///|
fn is_markdown_heading_line(line : String) -> Bool {
  let mut level = 0
  while level < line.length() &&
        level < 6 &&
        line[level].to_int().unsafe_to_char() == '#' {
    level += 1
  }
  level > 0 &&
  level < line.length() &&
  line[level].to_int().unsafe_to_char() == ' '
}

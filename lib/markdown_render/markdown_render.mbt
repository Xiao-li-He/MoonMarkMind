///|
/// Minimal Markdown renderer for node titles and bodies.
///
/// It supports the subset needed inside mind-map nodes and emits either DOM
/// nodes or escaped `SafeHtml` for export paths.
pub(all) enum MarkdownInline {
  InlineText(String)
  InlineStrong(String)
  InlineEmphasis(String)
  InlineCode(String)
  InlineStrike(String)
  InlineLink(String, String)
  InlineImage(String, String)
  InlineMath(String)
}

///|
pub(all) enum MarkdownBlock {
  BlockParagraph(String)
  BlockCode(String, String)
  BlockTask(Bool, String)
  BlockTable(Array[String], Array[Array[String]])
  BlockMath(String)
}

///|
/// Wrapper used to make unsafe string/HTML boundaries explicit.
pub(all) struct SafeHtml {
  value : String
}

///|

///|
pub fn render_markdown_html(markdown : String) -> String {
  render_markdown_blocks_html(split_markdown_blocks(markdown))
}

///|
pub fn parse_markdown_blocks(markdown : String) -> Array[MarkdownBlock] {
  parse_markdown_block_list(split_markdown_blocks(markdown))
}

///|
pub fn render_markdown_inline_html(source : String) -> String {
  render_markdown_inline_safe_html(source).value
}

///|
pub fn render_markdown_title_html(source : String) -> String {
  match parse_markdown_task_line(source) {
    Some(BlockTask(checked, text)) => {
      let check_attrs = if checked {
        " type=\"checkbox\" disabled=\"true\" checked=\"true\""
      } else {
        " type=\"checkbox\" disabled=\"true\""
      }
      safe_html_element(
        "span",
        class_name="markdown-task markdown-task--title",
        attrs="",
        children=[
          safe_html_element(
            "input",
            class_name="markdown-task__check",
            attrs=check_attrs,
            children=[],
          ),
          safe_html_element(
            "span",
            class_name="markdown-task__label",
            attrs="",
            children=[render_markdown_inline_safe_html(text)],
          ),
        ],
      ).value
    }
    _ => render_markdown_inline_html(source)
  }
}

///|
fn render_markdown_inline_safe_html(source : String) -> SafeHtml {
  // Exported HTML cannot rely on DOM text setters, so every inline renderer
  // returns escaped fragments wrapped in SafeHtml.
  let parts = []
  for inline in parse_markdown_inline(source) {
    parts.push(render_markdown_inline_piece_safe_html(inline))
  }
  safe_html_join(parts)
}

///|
fn render_markdown_inline_piece_safe_html(inline : MarkdownInline) -> SafeHtml {
  match inline {
    InlineText(text) => safe_html_text(text)
    InlineStrong(text) =>
      safe_html_element("span", class_name="markdown-strong", attrs="", children=[
        safe_html_text(text),
      ])
    InlineEmphasis(text) =>
      safe_html_element("em", class_name="markdown-emphasis", attrs="", children=[
        safe_html_text(text),
      ])
    InlineCode(text) =>
      safe_html_element("code", class_name="markdown-inline-code", attrs="", children=[
        safe_html_text(text),
      ])
    InlineStrike(text) =>
      safe_html_element("del", class_name="markdown-strike", attrs="", children=[
        safe_html_text(text),
      ])
    InlineLink(text, href) =>
      if is_safe_markdown_href(href) {
        let safe_href = href.trim().to_owned()
        safe_html_element(
          "a",
          class_name="markdown-link",
          attrs=" href=\"\{escape_html_attribute(safe_href)}\" target=\"_blank\" rel=\"noreferrer\"",
          children=[safe_html_text(text)],
        )
      } else {
        safe_html_text(text)
      }
    InlineImage(alt, src) =>
      if is_safe_markdown_image_src(src) {
        safe_html_element(
          "img",
          class_name="markdown-image",
          attrs=" src=\"\{escape_html_attribute(src.trim().to_owned())}\" alt=\"\{escape_html_attribute(alt)}\" loading=\"lazy\"",
          children=[],
        )
      } else {
        safe_html_text(alt)
      }
    InlineMath(source) =>
      safe_html_element(
        "span",
        class_name="markdown-math markdown-math--inline",
        attrs="",
        children=[
          SafeHtml::{
            value: @latex_math_render.render_latex_math_inline_html(source),
          },
        ],
      )
  }
}

///|
pub fn render_markdown_blocks_html(blocks : Array[String]) -> String {
  let parts = []
  for block in parse_markdown_block_list(blocks) {
    parts.push(render_markdown_block_safe_html(block))
  }
  safe_html_join(parts).value
}

///|
fn render_markdown_block_safe_html(block : MarkdownBlock) -> SafeHtml {
  match block {
    BlockParagraph(text) =>
      safe_html_element("p", class_name="markdown-paragraph", attrs="", children=[
        render_markdown_inline_safe_html(text),
      ])
    BlockCode(lang, code_text) => {
      let lang_attr = if lang.length() > 0 {
        " data-lang=\"\{escape_html_attribute(lang)}\""
      } else {
        ""
      }
      safe_html_element(
        "pre",
        class_name="markdown-code-block",
        attrs=lang_attr,
        children=[
          safe_html_element(
            "code",
            class_name="markdown-code-block__code",
            attrs="",
            children=[safe_html_text(code_text)],
          ),
        ],
      )
    }
    BlockTask(checked, text) => {
      let check_attrs = if checked {
        " type=\"checkbox\" disabled=\"true\" checked=\"true\""
      } else {
        " type=\"checkbox\" disabled=\"true\""
      }
      safe_html_element("div", class_name="markdown-task", attrs="", children=[
        safe_html_element(
          "input",
          class_name="markdown-task__check",
          attrs=check_attrs,
          children=[],
        ),
        safe_html_element("span", class_name="markdown-task__label", attrs="", children=[
          render_markdown_inline_safe_html(text),
        ]),
      ])
    }
    BlockTable(header, rows) => render_markdown_table_safe_html(header, rows)
    BlockMath(source) =>
      safe_html_element(
        "div",
        class_name="markdown-math markdown-math--block",
        attrs="",
        children=[
          SafeHtml::{
            value: @latex_math_render.render_latex_math_block_html(source),
          },
        ],
      )
  }
}

///|
fn render_markdown_table_safe_html(
  header : Array[String],
  rows : Array[Array[String]],
) -> SafeHtml {
  let head_cells = []
  for cell in header {
    head_cells.push(
      safe_html_element("th", class_name="", attrs="", children=[
        render_markdown_inline_safe_html(cell),
      ]),
    )
  }
  let row_parts = []
  for row in rows {
    let cells = []
    for cell in row {
      cells.push(
        safe_html_element("td", class_name="", attrs="", children=[
          render_markdown_inline_safe_html(cell),
        ]),
      )
    }
    row_parts.push(
      safe_html_element("tr", class_name="", attrs="", children=cells),
    )
  }
  safe_html_element("table", class_name="markdown-table", attrs="", children=[
    safe_html_element("thead", class_name="", attrs="", children=[
      safe_html_element("tr", class_name="", attrs="", children=head_cells),
    ]),
    safe_html_element("tbody", class_name="", attrs="", children=row_parts),
  ])
}

///|
fn safe_html_text(source : String) -> SafeHtml {
  SafeHtml::{ value: escape_html(source) }
}

///|
fn safe_html_join(parts : Array[SafeHtml]) -> SafeHtml {
  let values = []
  for part in parts {
    values.push(part.value)
  }
  SafeHtml::{ value: values.join("") }
}

///|
fn safe_html_element(
  tag : String,
  class_name~ : String,
  attrs~ : String,
  children~ : Array[SafeHtml],
) -> SafeHtml {
  let class_attr = if class_name.length() > 0 {
    " class=\"\{escape_html_attribute(class_name)}\""
  } else {
    ""
  }
  let child_html = safe_html_join(children).value
  if tag == "input" {
    SafeHtml::{ value: "<input\{class_attr}\{attrs} />" }
  } else {
    SafeHtml::{ value: "<\{tag}\{class_attr}\{attrs}>\{child_html}</\{tag}>" }
  }
}

///|
pub fn parse_markdown_block_list(
  blocks : Array[String],
) -> Array[MarkdownBlock] {
  // Body blocks arrive from the outline parser already separated by blank-line
  // runs. Classify each block once so DOM and HTML renderers share behavior.
  let parsed = []
  for block in blocks {
    let trimmed = block.trim().to_owned()
    if trimmed.length() == 0 {
      ()
    } else {
      match parse_markdown_math_block(trimmed) {
        Some(math_block) => parsed.push(math_block)
        None =>
          match parse_markdown_code_block(trimmed) {
            Some(code_block) => parsed.push(code_block)
            None =>
              match parse_markdown_table(trimmed) {
                Some(table) => parsed.push(table)
                None => {
                  let lines = trimmed
                    .split("\n")
                    .map(line => line.to_owned())
                    .to_array()
                  if lines.length() > 1 && all_markdown_task_lines(lines) {
                    for line in lines {
                      match parse_markdown_task_line(line) {
                        Some(task) => parsed.push(task)
                        None => ()
                      }
                    }
                  } else {
                    match parse_markdown_task_line(trimmed) {
                      Some(task) => parsed.push(task)
                      None =>
                        parsed.push(
                          BlockParagraph(
                            normalize_markdown_paragraph_display_text(trimmed),
                          ),
                        )
                    }
                  }
                }
              }
          }
      }
    }
  }
  parsed
}

///|
fn normalize_markdown_paragraph_display_text(text : String) -> String {
  let lines = text.split("\n").map(line => line.to_owned()).to_array()
  let normalized = []
  for line in lines {
    if !is_blank_markdown_line(line) {
      normalized.push(line)
    }
  }
  normalized.join("\n")
}

///|
fn parse_markdown_math_block(block : String) -> MarkdownBlock? {
  if !block.has_prefix("$$") || !block.has_suffix("$$") {
    return None
  }
  let content = if block.length() >= 4 {
    block[2:block.length() - 2].to_owned().trim().to_owned()
  } else {
    ""
  }
  if content.length() == 0 {
    None
  } else {
    Some(BlockMath(content))
  }
}

///|
fn parse_markdown_code_block(block : String) -> MarkdownBlock? {
  if !block.has_prefix("```") {
    return None
  }
  let lines = block.split("\n").map(line => line.to_owned()).to_array()
  if lines.length() < 2 ||
    !lines[lines.length() - 1].trim().to_owned().has_prefix("```") {
    return None
  }
  let lang = lines[0][3:].to_owned().trim().to_owned()
  let code_lines = []
  for index in 1..<(lines.length() - 1) {
    code_lines.push(lines[index])
  }
  Some(BlockCode(lang, code_lines.join("\n")))
}

///|
pub fn parse_markdown_table(block : String) -> MarkdownBlock? {
  let lines = block.split("\n").map(line => line.to_owned()).to_array()
  if lines.length() < 2 ||
    !is_markdown_table_row(lines[0]) ||
    !is_markdown_table_separator(lines[1]) {
    return None
  }
  let header = split_markdown_table_row(lines[0])
  if header.length() == 0 {
    return None
  }
  let rows = []
  for index in 2..<lines.length() {
    if is_markdown_table_row(lines[index]) {
      rows.push(
        normalize_markdown_table_cells(
          split_markdown_table_row(lines[index]),
          header.length(),
        ),
      )
    }
  }
  Some(BlockTable(header, rows))
}

///|
fn is_markdown_table_row(line : String) -> Bool {
  let trimmed = line.trim().to_owned()
  trimmed.has_prefix("|") && trimmed.has_suffix("|")
}

///|
fn is_markdown_table_separator(line : String) -> Bool {
  let cells = split_markdown_table_row(line)
  if cells.length() == 0 {
    return false
  }
  for cell in cells {
    let text = cell.trim().to_owned()
    if text.length() == 0 {
      return false
    }
    for ch in text {
      if ch != '-' && ch != ':' {
        return false
      }
    }
  }
  true
}

///|
fn split_markdown_table_row(line : String) -> Array[String] {
  let trimmed = line.trim().to_owned()
  let inner = if trimmed.length() >= 2 &&
    trimmed.has_prefix("|") &&
    trimmed.has_suffix("|") {
    trimmed[1:trimmed.length() - 1].to_owned()
  } else {
    trimmed
  }
  inner.split("|").map(cell => cell.to_owned().trim().to_owned()).to_array()
}

///|
fn normalize_markdown_table_cells(
  cells : Array[String],
  width : Int,
) -> Array[String] {
  let normalized = []
  for index in 0..<width {
    normalized.push(cells.get(index).unwrap_or(""))
  }
  normalized
}

///|
fn all_markdown_task_lines(lines : Array[String]) -> Bool {
  for line in lines {
    if parse_markdown_task_line(line) is None {
      return false
    }
  }
  true
}

///|
pub fn parse_markdown_task_line(line : String) -> MarkdownBlock? {
  let trimmed = line.trim().to_owned()
  if trimmed.has_prefix("- [ ] ") {
    Some(BlockTask(false, trimmed[6:].to_owned()))
  } else if trimmed.has_prefix("- [x] ") || trimmed.has_prefix("- [X] ") {
    Some(BlockTask(true, trimmed[6:].to_owned()))
  } else if trimmed.has_prefix("[ ] ") {
    Some(BlockTask(false, trimmed[4:].to_owned()))
  } else if trimmed.has_prefix("[x] ") || trimmed.has_prefix("[X] ") {
    Some(BlockTask(true, trimmed[4:].to_owned()))
  } else {
    None
  }
}

///|
pub fn parse_markdown_inline(source : String) -> Array[MarkdownInline] {
  // Prefer preserving literal text over guessing when delimiters are incomplete.
  // That keeps pasted Markdown readable even when it is not fully well-formed.
  let pieces = []
  let mut cursor = 0
  while cursor < source.length() {
    match next_markdown_inline(source, cursor) {
      Some((start, stop, inline)) => {
        if start > cursor {
          pieces.push(InlineText(source[cursor:start].to_owned()))
        }
        pieces.push(inline)
        cursor = stop
      }
      None => {
        pieces.push(InlineText(source[cursor:].to_owned()))
        cursor = source.length()
      }
    }
  }
  pieces
}

///|
fn next_markdown_inline(
  source : String,
  start : Int,
) -> (Int, Int, MarkdownInline)? {
  let mut cursor = start
  while cursor < source.length() {
    match parse_markdown_inline_at(source, cursor) {
      Some((stop, inline)) => return Some((cursor, stop, inline))
      None => cursor += 1
    }
  }
  None
}

///|
fn parse_markdown_inline_at(
  source : String,
  cursor : Int,
) -> (Int, MarkdownInline)? {
  match parse_markdown_escape_at(source, cursor) {
    Some(escaped) => return Some(escaped)
    None => ()
  }
  if has_markdown_at(source, cursor, "$") &&
    !has_markdown_at(source, cursor, "$$") {
    match find_unescaped_markdown_from(source, "$", cursor + 1) {
      Some(end_) =>
        if end_ > cursor + 1 {
          let math_source = source[cursor + 1:end_].to_owned()
          if math_source.trim().to_owned().length() > 0 {
            return Some((end_ + 1, InlineMath(math_source)))
          }
        }
      None => ()
    }
  }
  if has_markdown_at(source, cursor, "`") {
    match find_unescaped_markdown_from(source, "`", cursor + 1) {
      Some(end_) =>
        if end_ > cursor + 1 {
          return Some(
            (end_ + 1, InlineCode(source[cursor + 1:end_].to_owned())),
          )
        }
      None => ()
    }
  }
  if has_markdown_at(source, cursor, "**") {
    match find_unescaped_markdown_from(source, "**", cursor + 2) {
      Some(end_) =>
        if end_ > cursor + 2 {
          return Some(
            (end_ + 2, InlineStrong(source[cursor + 2:end_].to_owned())),
          )
        }
      None => ()
    }
  }
  if has_markdown_at(source, cursor, "~~") {
    match find_unescaped_markdown_from(source, "~~", cursor + 2) {
      Some(end_) =>
        if end_ > cursor + 2 {
          return Some(
            (end_ + 2, InlineStrike(source[cursor + 2:end_].to_owned())),
          )
        }
      None => ()
    }
  }
  if has_markdown_at(source, cursor, "*") {
    match find_unescaped_markdown_from(source, "*", cursor + 1) {
      Some(end_) =>
        if end_ > cursor + 1 {
          return Some(
            (end_ + 1, InlineEmphasis(source[cursor + 1:end_].to_owned())),
          )
        }
      None => ()
    }
  }
  if has_markdown_at(source, cursor, "_") {
    match find_unescaped_markdown_from(source, "_", cursor + 1) {
      Some(end_) =>
        if end_ > cursor + 1 {
          return Some(
            (end_ + 1, InlineEmphasis(source[cursor + 1:end_].to_owned())),
          )
        }
      None => ()
    }
  }
  if has_markdown_at(source, cursor, "![") {
    match parse_markdown_image_at(source, cursor) {
      Some(image) => return Some(image)
      None => ()
    }
  }
  if has_markdown_at(source, cursor, "[") {
    match parse_markdown_link_at(source, cursor) {
      Some(link) => return Some(link)
      None => ()
    }
  }
  None
}

///|
fn parse_markdown_escape_at(
  source : String,
  cursor : Int,
) -> (Int, MarkdownInline)? {
  if !has_markdown_at(source, cursor, "\\") || cursor + 1 >= source.length() {
    return None
  }
  if has_markdown_at(source, cursor + 1, "**") {
    return Some((cursor + 3, InlineText("**")))
  }
  if has_markdown_at(source, cursor + 1, "~~") {
    return Some((cursor + 3, InlineText("~~")))
  }
  let escaped = source[cursor + 1].to_int().unsafe_to_char()
  if is_markdown_escapable_char(escaped) {
    Some((cursor + 2, InlineText(escaped.to_string())))
  } else {
    None
  }
}

///|
fn is_markdown_escapable_char(ch : Char) -> Bool {
  ch == '\\' ||
  ch == '`' ||
  ch == '*' ||
  ch == '_' ||
  ch == '~' ||
  ch == '$' ||
  ch == '[' ||
  ch == ']' ||
  ch == '(' ||
  ch == ')' ||
  ch == '!' ||
  ch == '#' ||
  ch == '|'
}

///|
fn parse_markdown_image_at(
  source : String,
  cursor : Int,
) -> (Int, MarkdownInline)? {
  match find_markdown_from(source, "](", cursor + 2) {
    Some(close_alt) => {
      let src_start = close_alt + 2
      match find_markdown_from(source, ")", src_start) {
        Some(close_src) =>
          if close_alt >= cursor + 2 && close_src > src_start {
            let alt = source[cursor + 2:close_alt].to_owned()
            let src = source[src_start:close_src].to_owned()
            Some((close_src + 1, InlineImage(alt, src)))
          } else {
            None
          }
        None => None
      }
    }
    None => None
  }
}

///|
fn parse_markdown_link_at(
  source : String,
  cursor : Int,
) -> (Int, MarkdownInline)? {
  match find_markdown_from(source, "](", cursor + 1) {
    Some(close_label) => {
      let href_start = close_label + 2
      match find_markdown_from(source, ")", href_start) {
        Some(close_href) =>
          if close_label > cursor + 1 && close_href > href_start {
            let label = source[cursor + 1:close_label].to_owned()
            let href = source[href_start:close_href].to_owned()
            Some((close_href + 1, InlineLink(label, href)))
          } else {
            None
          }
        None => None
      }
    }
    None => None
  }
}

///|
fn has_markdown_at(source : String, start : Int, needle : String) -> Bool {
  start >= 0 &&
  start + needle.length() <= source.length() &&
  source[start:start + needle.length()].to_owned() == needle
}

///|
pub fn find_markdown_from(
  source : String,
  needle : String,
  start : Int,
) -> Int? {
  if start >= source.length() {
    return None
  }
  match source[start:].to_owned().find(needle) {
    Some(offset) => Some(start + offset)
    None => None
  }
}

///|
fn find_unescaped_markdown_from(
  source : String,
  needle : String,
  start : Int,
) -> Int? {
  let mut cursor = start
  while cursor < source.length() {
    match find_markdown_from(source, needle, cursor) {
      Some(found) =>
        if is_escaped_markdown_position(source, found) {
          cursor = found + needle.length()
        } else {
          return Some(found)
        }
      None => return None
    }
  }
  None
}

///|
fn is_escaped_markdown_position(source : String, cursor : Int) -> Bool {
  if cursor <= 0 {
    return false
  }
  let mut slash_count = 0
  let mut index = cursor - 1
  while index >= 0 && source[index].to_int().unsafe_to_char() == '\\' {
    slash_count += 1
    index -= 1
  }
  slash_count % 2 == 1
}

///|
pub fn is_safe_markdown_href(href : String) -> Bool {
  let trimmed = href.trim().to_owned().to_lower()
  trimmed.has_prefix("https://") ||
  trimmed.has_prefix("http://") ||
  trimmed.has_prefix("mailto:") ||
  trimmed.has_prefix("#")
}

///|
pub fn is_safe_markdown_image_src(src : String) -> Bool {
  let trimmed = src.trim().to_owned()
  if trimmed.length() == 0 {
    return false
  }
  let lower = trimmed.to_lower()
  if lower.has_prefix("https://") ||
    lower.has_prefix("http://") ||
    lower.has_prefix("./") ||
    lower.has_prefix("../") ||
    lower.has_prefix("/") {
    return true
  }
  !trimmed.contains(":")
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
    } else if is_blank_markdown_line(owned) && !in_code && !in_math {
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
fn is_blank_markdown_line(line : String) -> Bool {
  line.trim().length() == 0
}

///|
fn escape_html(source : String) -> String {
  source
  .replace_all(old="&", new="&amp;")
  .replace_all(old="<", new="&lt;")
  .replace_all(old=">", new="&gt;")
  .replace_all(old="\"", new="&quot;")
}

///|
fn escape_html_attribute(source : String) -> String {
  escape_html(source).replace_all(old="'", new="&#39;")
}

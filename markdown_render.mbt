///|
priv enum MarkdownInline {
  InlineText(String)
  InlineStrong(String)
  InlineEmphasis(String)
  InlineCode(String)
  InlineStrike(String)
  InlineLink(String, String)
  InlineMath(String)
}

///|
priv enum MarkdownBlock {
  BlockParagraph(String)
  BlockCode(String, String)
  BlockTask(Bool, String)
  BlockTable(Array[String], Array[Array[String]])
  BlockMath(String)
}

///|
priv struct SafeHtml {
  value : String
}

///|
fn build_markdown_inline_dom(source : String) -> @dom.Element {
  let wrap = create_element("span", "markdown-inline")
  append_markdown_inline_dom(wrap, source)
  wrap
}

///|
fn build_markdown_title_dom(source : String) -> @dom.Element {
  match parse_markdown_task_line(source) {
    Some(BlockTask(checked, text)) =>
      build_markdown_task_title_dom(checked, text)
    _ => build_markdown_inline_dom(source)
  }
}

///|
fn build_markdown_task_title_dom(checked : Bool, text : String) -> @dom.Element {
  let title = create_element("span", "markdown-task markdown-task--title")
  let checkbox = create_element("input", "markdown-task__check")
  checkbox.setAttribute("type", "checkbox")
  checkbox.setAttribute("disabled", "true")
  if checked {
    checkbox.setAttribute("checked", "true")
  }
  let label = create_element("span", "markdown-task__label")
  append_markdown_inline_dom(label, text)
  append_child(title, checkbox)
  append_child(title, label)
  title
}

///|
fn append_markdown_inline_dom(parent : @dom.Element, source : String) -> Unit {
  for inline in parse_markdown_inline(source) {
    append_child(parent, build_markdown_inline_piece_dom(inline))
  }
}

///|
fn build_markdown_inline_piece_dom(inline : MarkdownInline) -> @dom.Element {
  match inline {
    InlineText(text) => {
      let span = create_element("span", "markdown-text")
      span.setTextContent(text)
      span
    }
    InlineStrong(text) => {
      let strong = create_element("span", "markdown-strong")
      strong.setTextContent(text)
      strong
    }
    InlineEmphasis(text) => {
      let em = create_element("em", "markdown-emphasis")
      em.setTextContent(text)
      em
    }
    InlineCode(text) => {
      let code = create_element("code", "markdown-inline-code")
      code.setTextContent(text)
      code
    }
    InlineStrike(text) => {
      let del = create_element("del", "markdown-strike")
      del.setTextContent(text)
      del
    }
    InlineLink(text, href) =>
      if is_safe_markdown_href(href) {
        let safe_href = href.trim().to_string()
        let link = create_element("a", "markdown-link")
        link.setAttribute("href", safe_href)
        link.setAttribute("target", "_blank")
        link.setAttribute("rel", "noreferrer")
        link.setTextContent(text)
        link
      } else {
        let span = create_element("span", "markdown-text")
        span.setTextContent(text)
        span
      }
    InlineMath(source) => {
      let math = create_element("span", "markdown-math markdown-math--inline")
      math.setInnerHTML(render_latex_math_html(source).value)
      math
    }
  }
}

///|
fn render_markdown_inline_html(source : String) -> String {
  render_markdown_inline_safe_html(source).value
}

///|
fn render_markdown_title_html(source : String) -> String {
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
        let safe_href = href.trim().to_string()
        safe_html_element(
          "a",
          class_name="markdown-link",
          attrs=" href=\"\{escape_html_attribute(safe_href)}\" target=\"_blank\" rel=\"noreferrer\"",
          children=[safe_html_text(text)],
        )
      } else {
        safe_html_text(text)
      }
    InlineMath(source) =>
      safe_html_element(
        "span",
        class_name="markdown-math markdown-math--inline",
        attrs="",
        children=[render_latex_math_html(source)],
      )
  }
}

///|
fn build_markdown_blocks_dom(blocks : Array[String]) -> @dom.Element {
  let wrap = create_element("div", "markdown-blocks")
  for block in parse_markdown_blocks(blocks) {
    append_child(wrap, build_markdown_block_dom(block))
  }
  wrap
}

///|
fn build_markdown_block_dom(block : MarkdownBlock) -> @dom.Element {
  match block {
    BlockParagraph(text) => {
      let paragraph = create_element("p", "markdown-paragraph")
      append_markdown_inline_dom(paragraph, text)
      paragraph
    }
    BlockCode(lang, code_text) => {
      let pre = create_element("pre", "markdown-code-block")
      if lang.length() > 0 {
        pre.setAttribute("data-lang", lang)
      }
      let code = create_element("code", "markdown-code-block__code")
      code.setTextContent(code_text)
      append_child(pre, code)
      pre
    }
    BlockTask(checked, text) => {
      let item = create_element("div", "markdown-task")
      let checkbox = create_element("input", "markdown-task__check")
      checkbox.setAttribute("type", "checkbox")
      checkbox.setAttribute("disabled", "true")
      if checked {
        checkbox.setAttribute("checked", "true")
      }
      let label = create_element("span", "markdown-task__label")
      append_markdown_inline_dom(label, text)
      append_child(item, checkbox)
      append_child(item, label)
      item
    }
    BlockTable(header, rows) => build_markdown_table_dom(header, rows)
    BlockMath(source) => {
      let math = create_element("div", "markdown-math markdown-math--block")
      math.setInnerHTML(render_latex_math_html(source).value)
      math
    }
  }
}

///|
fn build_markdown_table_dom(
  header : Array[String],
  rows : Array[Array[String]],
) -> @dom.Element {
  let table = create_element("table", "markdown-table")
  let thead = create_element("thead", "")
  let head_row = create_element("tr", "")
  for cell in header {
    let th = create_element("th", "")
    append_markdown_inline_dom(th, cell)
    append_child(head_row, th)
  }
  append_child(thead, head_row)
  append_child(table, thead)
  let tbody = create_element("tbody", "")
  for row in rows {
    let tr = create_element("tr", "")
    for cell in row {
      let td = create_element("td", "")
      append_markdown_inline_dom(td, cell)
      append_child(tr, td)
    }
    append_child(tbody, tr)
  }
  append_child(table, tbody)
  table
}

///|
fn render_markdown_blocks_html(blocks : Array[String]) -> String {
  let parts = []
  for block in parse_markdown_blocks(blocks) {
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
        children=[render_latex_math_html(source)],
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
fn render_latex_math_html(source : String) -> SafeHtml {
  SafeHtml::{ value: render_latex_math_fragment(source.trim().to_string()) }
}

///|
fn render_latex_math_fragment(source : String) -> String {
  let parts = []
  let mut cursor = 0
  while cursor < source.length() {
    if has_markdown_at(source, cursor, "\\frac") {
      match read_latex_group(source, cursor + 5) {
        Some((numerator, after_numerator)) =>
          match read_latex_group(source, after_numerator) {
            Some((denominator, after_denominator)) => {
              parts.push(
                "<span class=\"markdown-math-frac\"><span class=\"markdown-math-frac__num\">\{render_latex_math_fragment(numerator)}</span><span class=\"markdown-math-frac__den\">\{render_latex_math_fragment(denominator)}</span></span>",
              )
              cursor = after_denominator
              continue
            }
            None => ()
          }
        None => ()
      }
    }
    if has_markdown_at(source, cursor, "\\sqrt") {
      match read_latex_group(source, cursor + 5) {
        Some((radicand, after_radicand)) => {
          parts.push(
            "<span class=\"markdown-math-sqrt\"><span class=\"markdown-math-sqrt__symbol\">√</span><span class=\"markdown-math-sqrt__radicand\">\{render_latex_math_fragment(radicand)}</span></span>",
          )
          cursor = after_radicand
          continue
        }
        None => ()
      }
    }
    if source[cursor] == '^' || source[cursor] == '_' {
      let is_sup = source[cursor] == '^'
      match read_latex_atom(source, cursor + 1) {
        Some((atom, after_atom)) => {
          parts.push(
            if is_sup {
              "<sup>\{atom}</sup>"
            } else {
              "<sub>\{atom}</sub>"
            },
          )
          cursor = after_atom
          continue
        }
        None => ()
      }
    }
    if source[cursor] == '\\' {
      let (command, after_command) = read_latex_command(source, cursor + 1)
      if command.length() > 0 {
        parts.push(safe_html_text(latex_command_symbol(command)).value)
        cursor = after_command
        continue
      }
    }
    if source[cursor] == '{' {
      match read_latex_group(source, cursor) {
        Some((group, after_group)) => {
          parts.push(render_latex_math_fragment(group))
          cursor = after_group
          continue
        }
        None => ()
      }
    }
    if source[cursor] == '}' {
      cursor += 1
    } else {
      parts.push(safe_html_text(source[cursor:cursor + 1].to_string()).value)
      cursor += 1
    }
  }
  parts.join("")
}

///|
fn read_latex_atom(source : String, start : Int) -> (String, Int)? {
  let cursor = skip_latex_spaces(source, start)
  if cursor >= source.length() {
    return None
  }
  if source[cursor] == '{' {
    match read_latex_group(source, cursor) {
      Some((group, after_group)) =>
        Some((render_latex_math_fragment(group), after_group))
      None => None
    }
  } else if source[cursor] == '\\' {
    let (command, after_command) = read_latex_command(source, cursor + 1)
    if command.length() == 0 {
      Some((safe_html_text("\\").value, cursor + 1))
    } else {
      Some((safe_html_text(latex_command_symbol(command)).value, after_command))
    }
  } else {
    Some(
      (safe_html_text(source[cursor:cursor + 1].to_string()).value, cursor + 1),
    )
  }
}

///|
fn read_latex_group(source : String, start : Int) -> (String, Int)? {
  let cursor = skip_latex_spaces(source, start)
  if cursor >= source.length() || source[cursor] != '{' {
    return None
  }
  let mut depth = 1
  let mut index = cursor + 1
  while index < source.length() {
    if source[index] == '{' {
      depth += 1
    } else if source[index] == '}' {
      depth -= 1
      if depth == 0 {
        return Some((source[cursor + 1:index].to_string(), index + 1))
      }
    }
    index += 1
  }
  None
}

///|
fn skip_latex_spaces(source : String, start : Int) -> Int {
  let mut cursor = start
  while cursor < source.length() && source[cursor] == ' ' {
    cursor += 1
  }
  cursor
}

///|
fn read_latex_command(source : String, start : Int) -> (String, Int) {
  let mut cursor = start
  while cursor < source.length() && is_ascii_letter(source[cursor]) {
    cursor += 1
  }
  (source[start:cursor].to_string(), cursor)
}

///|
fn is_ascii_letter(ch : UInt16) -> Bool {
  (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z')
}

///|
fn latex_command_symbol(command : String) -> String {
  match command {
    "alpha" => "α"
    "beta" => "β"
    "gamma" => "γ"
    "delta" => "δ"
    "epsilon" => "ε"
    "theta" => "θ"
    "lambda" => "λ"
    "mu" => "μ"
    "pi" => "π"
    "rho" => "ρ"
    "sigma" => "σ"
    "tau" => "τ"
    "phi" => "φ"
    "omega" => "ω"
    "Gamma" => "Γ"
    "Delta" => "Δ"
    "Theta" => "Θ"
    "Lambda" => "Λ"
    "Pi" => "Π"
    "Sigma" => "Σ"
    "Phi" => "Φ"
    "Omega" => "Ω"
    "times" => "×"
    "cdot" => "·"
    "pm" => "±"
    "le" => "≤"
    "ge" => "≥"
    "neq" => "≠"
    "approx" => "≈"
    "infty" => "∞"
    "sum" => "∑"
    "prod" => "∏"
    "int" => "∫"
    "rightarrow" => "→"
    "leftarrow" => "←"
    "to" => "→"
    _ => command
  }
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
fn parse_markdown_blocks(blocks : Array[String]) -> Array[MarkdownBlock] {
  let parsed = []
  for block in blocks {
    let trimmed = block.trim().to_string()
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
                    .map(line => line.to_string())
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
                      None => parsed.push(BlockParagraph(trimmed))
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
fn parse_markdown_math_block(block : String) -> MarkdownBlock? {
  if !block.has_prefix("$$") || !block.has_suffix("$$") {
    return None
  }
  let content = if block.length() >= 4 {
    block[2:block.length() - 2].to_string().trim().to_string()
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
  let lines = block.split("\n").map(line => line.to_string()).to_array()
  if lines.length() < 2 ||
    !lines[lines.length() - 1].trim().to_string().has_prefix("```") {
    return None
  }
  let lang = lines[0][3:].to_string().trim().to_string()
  let code_lines = []
  for index in 1..<(lines.length() - 1) {
    code_lines.push(lines[index])
  }
  Some(BlockCode(lang, code_lines.join("\n")))
}

///|
fn parse_markdown_table(block : String) -> MarkdownBlock? {
  let lines = block.split("\n").map(line => line.to_string()).to_array()
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
  let trimmed = line.trim().to_string()
  trimmed.has_prefix("|") && trimmed.has_suffix("|")
}

///|
fn is_markdown_table_separator(line : String) -> Bool {
  let cells = split_markdown_table_row(line)
  if cells.length() == 0 {
    return false
  }
  for cell in cells {
    let text = cell.trim().to_string()
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
  let trimmed = line.trim().to_string()
  let inner = if trimmed.length() >= 2 &&
    trimmed.has_prefix("|") &&
    trimmed.has_suffix("|") {
    trimmed[1:trimmed.length() - 1].to_string()
  } else {
    trimmed
  }
  inner.split("|").map(cell => cell.to_string().trim().to_string()).to_array()
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
fn parse_markdown_task_line(line : String) -> MarkdownBlock? {
  let trimmed = line.trim().to_string()
  if trimmed.has_prefix("- [ ] ") {
    Some(BlockTask(false, trimmed[6:].to_string()))
  } else if trimmed.has_prefix("- [x] ") || trimmed.has_prefix("- [X] ") {
    Some(BlockTask(true, trimmed[6:].to_string()))
  } else if trimmed.has_prefix("[ ] ") {
    Some(BlockTask(false, trimmed[4:].to_string()))
  } else if trimmed.has_prefix("[x] ") || trimmed.has_prefix("[X] ") {
    Some(BlockTask(true, trimmed[4:].to_string()))
  } else {
    None
  }
}

///|
fn parse_markdown_inline(source : String) -> Array[MarkdownInline] {
  let pieces = []
  let mut cursor = 0
  while cursor < source.length() {
    match next_markdown_inline(source, cursor) {
      Some((start, stop, inline)) => {
        if start > cursor {
          pieces.push(InlineText(source[cursor:start].to_string()))
        }
        pieces.push(inline)
        cursor = stop
      }
      None => {
        pieces.push(InlineText(source[cursor:].to_string()))
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
  if has_markdown_at(source, cursor, "$") &&
    !has_markdown_at(source, cursor, "$$") {
    match find_markdown_from(source, "$", cursor + 1) {
      Some(end_) =>
        if end_ > cursor + 1 {
          return Some(
            (end_ + 1, InlineMath(source[cursor + 1:end_].to_string())),
          )
        }
      None => ()
    }
  }
  if has_markdown_at(source, cursor, "`") {
    match find_markdown_from(source, "`", cursor + 1) {
      Some(end_) =>
        if end_ > cursor + 1 {
          return Some(
            (end_ + 1, InlineCode(source[cursor + 1:end_].to_string())),
          )
        }
      None => ()
    }
  }
  if has_markdown_at(source, cursor, "**") {
    match find_markdown_from(source, "**", cursor + 2) {
      Some(end_) =>
        if end_ > cursor + 2 {
          return Some(
            (end_ + 2, InlineStrong(source[cursor + 2:end_].to_string())),
          )
        }
      None => ()
    }
  }
  if has_markdown_at(source, cursor, "~~") {
    match find_markdown_from(source, "~~", cursor + 2) {
      Some(end_) =>
        if end_ > cursor + 2 {
          return Some(
            (end_ + 2, InlineStrike(source[cursor + 2:end_].to_string())),
          )
        }
      None => ()
    }
  }
  if has_markdown_at(source, cursor, "_") {
    match find_markdown_from(source, "_", cursor + 1) {
      Some(end_) =>
        if end_ > cursor + 1 {
          return Some(
            (end_ + 1, InlineEmphasis(source[cursor + 1:end_].to_string())),
          )
        }
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
            let label = source[cursor + 1:close_label].to_string()
            let href = source[href_start:close_href].to_string()
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
  source[start:start + needle.length()].to_string() == needle
}

///|
fn find_markdown_from(source : String, needle : String, start : Int) -> Int? {
  if start >= source.length() {
    return None
  }
  match source[start:].to_string().find(needle) {
    Some(offset) => Some(start + offset)
    None => None
  }
}

///|
fn is_safe_markdown_href(href : String) -> Bool {
  let trimmed = href.trim().to_string().to_lower()
  trimmed.has_prefix("https://") ||
  trimmed.has_prefix("http://") ||
  trimmed.has_prefix("mailto:") ||
  trimmed.has_prefix("#")
}

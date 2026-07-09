///|
/// Browser DOM adapters for Markdown rendered inside mind-map nodes.
/// Pure parsing and HTML string rendering live in lib/markdown_render.
type MarkdownInline = @markdown_render.MarkdownInline

///|
type MarkdownBlock = @markdown_render.MarkdownBlock

///|
fn build_markdown_inline_dom(source : String) -> @dom.Element {
  let wrap = create_element("span", "markdown-inline")
  append_markdown_inline_dom(wrap, source)
  wrap
}

///|
fn build_markdown_title_dom(source : String) -> @dom.Element {
  match @markdown_render.parse_markdown_task_line(source) {
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
  for inline in @markdown_render.parse_markdown_inline(source) {
    append_child(parent, build_markdown_inline_piece_dom(inline))
  }
}

///|
fn build_markdown_inline_piece_dom(inline : MarkdownInline) -> @dom.Element {
  // Links and images fall back to plain text when their URLs are unsafe for
  // direct browser rendering, preserving readable text without script URLs.
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
    InlineHighlight(text) => {
      let mark = create_element("mark", "markdown-highlight")
      mark.setTextContent(text)
      mark
    }
    InlineLink(text, href) =>
      if @markdown_render.is_safe_markdown_href(href) {
        let safe_href = href.trim().to_owned()
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
    InlineImage(alt, src) =>
      if @markdown_render.is_safe_markdown_image_src(src) {
        let image = create_element("img", "markdown-image")
        image.setAttribute("src", src.trim().to_owned())
        image.setAttribute("alt", alt)
        image.setAttribute("loading", "lazy")
        image
      } else {
        let span = create_element("span", "markdown-text")
        span.setTextContent(alt)
        span
      }
    InlineMath(source) => {
      let math = create_element("span", "markdown-math markdown-math--inline")
      math.setInnerHTML(
        @latex_math_render.render_latex_math_inline_html(source),
      )
      apply_theme_to_subtree(math)
      math
    }
    InlineLineBreak => create_element("br", "markdown-line-break")
  }
}

///|

///|
pub fn render_markdown_html(markdown : String) -> String {
  @markdown_render.render_markdown_html(markdown)
}

///|
pub fn render_markdown_inline_html(source : String) -> String {
  @markdown_render.render_markdown_inline_html(source)
}

///|
pub fn render_markdown_title_html(source : String) -> String {
  @markdown_render.render_markdown_title_html(source)
}

///|
fn build_markdown_blocks_dom(blocks : Array[String]) -> @dom.Element {
  let wrap = create_element("div", "markdown-blocks")
  for block in @markdown_render.parse_markdown_block_list(blocks) {
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
      let pre = create_element("pre", markdown_code_block_class())
      if lang.length() > 0 {
        pre.setAttribute("data-lang", lang)
      }
      let code = create_element("code", markdown_code_block_code_class())
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
    BlockList(list) => build_markdown_list_dom(list)
    BlockTable(header, rows) => build_markdown_table_dom(header, rows)
    BlockMath(source) => {
      let math = create_element("div", "markdown-math markdown-math--block")
      math.setInnerHTML(@latex_math_render.render_latex_math_block_html(source))
      apply_theme_to_subtree(math)
      math
    }
  }
}

///|
fn build_markdown_list_dom(
  list_block : @markdown_render.MarkdownListBlock,
) -> @dom.Element {
  let tag = if list_block.ordered { "ol" } else { "ul" }
  let class_name = if list_block.ordered {
    "markdown-list markdown-list--ordered"
  } else {
    "markdown-list markdown-list--unordered"
  }
  let list = create_element(tag, class_name)
  for item in list_block.items {
    let li = create_element("li", "markdown-list__item")
    append_markdown_inline_dom(li, item.text)
    for child in item.children {
      append_child(li, build_markdown_list_dom(child))
    }
    append_child(list, li)
  }
  list
}

///|
fn apply_theme_to_subtree(root : @dom.Element) -> Unit {
  apply_theme_to_element(root)
  for element in root.querySelectorAll("*") {
    apply_theme_to_element(element)
  }
}

///|
fn markdown_code_block_class() -> String {
  if is_branch_line_tree_mode() {
    "markdown-code-block markdown-code-block--line-tree"
  } else {
    "markdown-code-block"
  }
}

///|
fn markdown_code_block_code_class() -> String {
  if is_branch_line_tree_mode() {
    "markdown-code-block__code markdown-code-block__code--line-tree"
  } else {
    "markdown-code-block__code"
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
  apply_theme_to_subtree(table)
  table
}

///|

///|
pub fn render_markdown_blocks_html(blocks : Array[String]) -> String {
  @markdown_render.render_markdown_blocks_html(blocks)
}

///|
fn parse_markdown_table(block : String) -> MarkdownBlock? {
  @markdown_render.parse_markdown_table(block)
}

///|
fn find_markdown_from(source : String, needle : String, start : Int) -> Int? {
  @markdown_render.find_markdown_from(source, needle, start)
}

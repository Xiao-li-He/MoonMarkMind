# markdown_render

MoonMarkMind 的轻量 Markdown fragment/body 到安全 HTML 渲染包。

它覆盖脑图节点标题和正文需要的 Markdown 子集：行内强调、代码、链接、图片、任务项、表格、代码块，以及通过 `latex_math_render` 处理的行内/块级公式。它不依赖 DOM、Canvas 或浏览器 API。

## Install / Import

在 `moon.pkg` 中导入：

```text
import {
  "Xiao-li-He/MoonMarkMind/lib/markdown_render" @markdown
}
```

## Quick Start

```mbt check
///|
test {
  let html = render_markdown_html("Hello **MoonBit**\n\n$$x^2$$")
  assert_true(html.contains("markdown-strong"))
  assert_true(html.contains("markdown-math--block"))
}
```

如果只渲染一行标题或行内片段：

```mbt check
///|
test {
  let title = render_markdown_title_html("[x] Done **today**")
  let inline = render_markdown_inline_html("Value $x^2$ and `code`")
  assert_true(title.contains("markdown-task--title"))
  assert_true(inline.contains("markdown-math--inline"))
}
```

## Core APIs

- `render_markdown_html(markdown : String) -> String`：把一段 Markdown 文本渲染为 HTML fragment。
- `render_markdown_inline_html(source : String) -> String`：渲染行内 Markdown。
- `render_markdown_title_html(source : String) -> String`：渲染节点标题，支持任务标题标记。
- `render_markdown_blocks_html(blocks : Array[String]) -> String`：渲染已经按空行分好的正文块。
- `parse_markdown_blocks(markdown : String) -> Array[MarkdownBlock]`：解析一段 Markdown 文本。
- `parse_markdown_block_list(blocks : Array[String]) -> Array[MarkdownBlock]`：解析已分块正文。
- `parse_markdown_inline(source : String) -> Array[MarkdownInline]`：解析行内节点。

## Notes

- 这是 MoonMarkMind 面向脑图节点正文的 Markdown 子集渲染器，不是完整 CommonMark 引擎。
- HTML 输出会转义普通文本，并过滤不安全的链接和图片地址。
- LaTeX 公式渲染委托给 `lib/latex_math_render`。
- Web 应用中的 DOM 构建、主题应用和交互仍保留在 `app/web`。

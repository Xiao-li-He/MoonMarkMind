# MoonMarkMind

MoonMarkMind 是一个用 MoonBit 编写的 Markdown 脑图工具包与浏览器应用。它把 Markdown 大纲解析为结构树，并提供浏览器编辑、脑图渲染、布局切换、节点编辑和 PNG/SVG/HTML 导出能力。

[在线使用 MoonMarkMind](https://xiao-li-he.github.io/MoonMarkMind/)

![MoonMarkMind 界面预览](product.png)

## Packages

| 包 | 定位 | 适用场景 |
| --- | --- | --- |
| `lib/outline_parser` | Markdown 大纲解析、`OutlineNode` 构建、结构编辑、Markdown 回写 | 需要把 Markdown 当作可编辑大纲模型处理 |
| `lib/latex_math_render` | LaTeX 行内/块级公式到 HTML/SVG fragment | 需要在 Markdown 节点中渲染轻量公式 |
| `lib/markdown_render` | Markdown fragment/body 到安全 HTML | 需要在无 DOM 环境渲染脑图节点标题和正文 Markdown |
| `packages/markdown_to_html` | Markdown 文本到安全 HTML fragment | 推荐给用户直接调用的 Markdown to HTML 包 |
| `packages/markdown_to_mindmap` | Markdown 文本到静态 SVG 脑图 | 推荐给用户直接调用的 Markdown to mindmap 包 |
| `lib/mindmap_render` | `OutlineNode` 或 Markdown 到静态 HTML/SVG 脑图字符串 | 需要服务端、CLI 或测试环境生成脑图片段 |
| `app/web` | 浏览器端 MoonMarkMind 应用 | DOM 交互、编辑器、工具栏、Canvas PNG 导出 |
| `cmd/cli` | 命令行导出入口 | 本地终端将单个 Markdown 文件导出为 PNG/SVG/HTML |

## Install / Import

在 `moon.mod` 中依赖本模块后，可以在 `moon.pkg` 中按需导入子包：

```text
import {
  "Xiao-li-He/MoonMarkMind/lib/outline_parser" @outline
  "Xiao-li-He/MoonMarkMind/lib/mindmap_render" @mindmap
  "Xiao-li-He/MoonMarkMind/lib/latex_math_render" @math
  "Xiao-li-He/MoonMarkMind/lib/markdown_render" @markdown
  "Xiao-li-He/MoonMarkMind/packages/markdown_to_html" @markdown_to_html
  "Xiao-li-He/MoonMarkMind/packages/markdown_to_mindmap" @markdown_to_mindmap
}
```

浏览器应用入口由 `cmd/main` 构建，Web 集成包路径为：

```text
Xiao-li-He/MoonMarkMind/app/web
```

## Quick Start

### 在线使用

打开：

```text
https://xiao-li-he.github.io/MoonMarkMind/
```

### 本地构建与预览

在项目根目录运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\build-web.ps1
```

只构建、不启动服务：

```powershell
powershell -ExecutionPolicy Bypass -File .\build-web.ps1 -NoServe
```

默认预览地址：

```text
http://127.0.0.1:8000/index.html
```

### 库包调用

```mbt nocheck
///|
test {
  let markdown = "# Root\n## Child"
  let outline = @outline.build_outline(markdown)
  let html = @mindmap.render_outline_html(outline)
  let formula = @math.render_latex_math_inline_html("\\frac{x}{y}")
  let body = @markdown.render_markdown_html("Hello **MoonBit**")
  let user_html = @markdown_to_html.render("Hello **MoonBit**")
  let svg = @markdown_to_mindmap.render_svg(markdown)
  ignore(html)
  ignore(formula)
  ignore(body)
  ignore(user_html)
  ignore(svg)
}
```

### CLI 单文件导出

`cmd/cli` 是命令行导出入口，参数设计与 Web 端布局、样式和详情级别保持一致：

```powershell
moon run cmd/cli samples/example1.md --format svg --layout mindmap --style line --layer layer2
moon run cmd/cli samples/example1.md --format html -o output/example1.html
moon run cmd/cli samples/example1.md -o output/example1.png
```

默认导出 PNG，输出到 `output/<input-stem>.<format>`。`--format` 支持 `png`、`svg`、`html`，`-o`/`--output` 可指定输出文件路径；当输出路径以 `.png`、`.svg` 或 `.html` 结尾时，CLI 会自动推断导出格式。CLI 每次接受一个 Markdown 文件和一种格式；目录输入、多文件输入和逗号分隔的多格式会被拒绝。所有格式都走 Web 端动态渲染导出，PNG 需要本机可用的 Chrome 或 Edge，也可通过 `--browser <path>` 指定。

## Core APIs

- `outline_parser`：`parse_headings`、`parse_markdown_nodes`、`build_outline`、`outline_json`、`rename_heading`、`render_markdown_nodes`。
- `markdown_to_html`：`render`、`render_inline`、`render_title`、`render_blocks`。
- `markdown_to_mindmap`：`render_svg`、`build_svg_document`、`default_render_options`、`normalize_layout`、`normalize_style`、`normalize_layer`。
- `markdown_render`：`render_markdown_html`、`render_markdown_inline_html`、`render_markdown_title_html`、`render_markdown_blocks_html`。
- `mindmap_render`：`default_render_options`、`render_markdown_html`、`render_markdown_svg`、`render_outline_html`、`render_outline_svg`。
- `latex_math_render`：`render_latex_math_inline_html`、`render_latex_math_block_html`、`render_latex_math_inline_svg`、`render_latex_math_block_svg`。

## Web App Features

- Markdown 实时转换为结构化脑图。
- 支持脑图、树状图、逻辑图三种布局。
- 支持填充卡片和线框/分支线两种样式。
- 支持完整、中等、精简详情级别。
- 支持节点选择、折叠、隐藏、拖拽调整层级、新增、删除、移动、缩进和提升。
- 支持常见 Markdown 富文本、图片和 LaTeX 公式。
- 支持导出 PNG、SVG 和 HTML。

## Project Layout

- `lib/outline_parser`：可复用大纲解析和编辑模型。
- `lib/latex_math_render`：可复用公式 fragment 渲染。
- `lib/markdown_render`：可复用 Markdown fragment/body HTML 渲染。
- `packages/markdown_to_html`：面向用户的 Markdown 文本到 HTML fragment 包。
- `packages/markdown_to_mindmap`：面向用户的 Markdown 文本到静态 SVG 脑图包。
- `lib/mindmap_render`：可复用静态脑图字符串渲染。
- `app/web`：浏览器端应用。
- `cmd/main`：Web bundle 导出入口。
- `cmd/cli`：命令行入口。
- `web/index.html`：静态 Web 页面入口。
- `build-web.ps1`：构建并预览 Web 版本。

更完整的结构规则见 [docs/SPEC.md](docs/SPEC.md)，验收说明见 [docs/ACCEPTANCE.md](docs/ACCEPTANCE.md)。

## Development

常用验证命令：

```powershell
moon check
moon test --no-render
moon info
```

如果修改 Web 入口、样式、导出逻辑或前端交互，请重新构建 Web bundle：

```powershell
powershell -ExecutionPolicy Bypass -File .\build-web.ps1 -NoServe
```

## Notes

- MoonMarkMind 采用单仓多包结构，顶层模块名为 `Xiao-li-He/MoonMarkMind`。
- `lib/*` 包保持纯模型或纯字符串能力，避免依赖 DOM、Canvas 或浏览器 API。
- `app/web` 负责浏览器交互、真实布局测量和 Canvas PNG 导出。
- 当前 LaTeX 渲染是轻量公式子集渲染，不是完整 LaTeX 引擎。

## License

Apache-2.0。详见 [LICENSE](LICENSE)。

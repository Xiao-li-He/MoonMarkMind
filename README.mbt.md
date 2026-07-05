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
| `lib/mindmap_renderer` | `OutlineNode` 或 Markdown 到静态 HTML/SVG 脑图字符串 | 需要服务端、CLI 或测试环境生成脑图片段 |
| `app/web` | 浏览器端 MoonMarkMind 应用 | DOM 交互、编辑器、工具栏、Canvas PNG 导出 |
| `cmd/cli` | 命令行导出入口 | 本地终端批量生成 SVG/HTML 脑图文件 |

## Install / Import

在 `moon.mod` 中依赖本模块后，可以在 `moon.pkg` 中按需导入子包：

```text
import {
  "Xiao-li-He/MoonMarkMind/lib/outline_parser" @outline
  "Xiao-li-He/MoonMarkMind/lib/mindmap_renderer" @mindmap
  "Xiao-li-He/MoonMarkMind/lib/latex_math_render" @math
  "Xiao-li-He/MoonMarkMind/lib/markdown_render" @markdown
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
  ignore(html)
  ignore(formula)
  ignore(body)
}
```

### CLI 批量导出

`cmd/cli` 是命令行导出入口，参数设计与 Web 端布局、样式和详情级别保持一致：

```powershell
moon run cmd/cli -- ./samples/example1.md --output svg --layout logic --style full --layer full
moon run cmd/cli -- ./samples/example1.md --output html --layout tree --style line --layer layer2 -o output
```

默认输出目录为 `output/`；PNG/XMind 不作为本阶段文档承诺。

## Core APIs

- `outline_parser`：`parse_headings`、`parse_markdown_nodes`、`build_outline`、`outline_json`、`rename_heading`、`render_markdown_nodes`。
- `markdown_render`：`render_markdown_html`、`render_markdown_inline_html`、`render_markdown_title_html`、`render_markdown_blocks_html`。
- `mindmap_renderer`：`default_render_options`、`render_markdown_html`、`render_markdown_svg`、`render_outline_html`、`render_outline_svg`。
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
- `lib/mindmap_renderer`：可复用静态脑图字符串渲染。
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

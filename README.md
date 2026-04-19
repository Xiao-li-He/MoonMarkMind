# MoonMarkMind

[在线使用 MoonMarkMind](https://xiao-li-he.github.io/MoonMarkMind/)

MoonMarkMind 是一个用 MoonBit 编写的 Markdown 脑图编辑器。它把 Markdown 解析成结构树，并在浏览器中提供编辑、预览、布局切换、样式切换和导出能力。

![MoonMarkMind 界面预览](product.png)

## 核心能力

- **Markdown 即脑图**：左侧直接编辑 Markdown，右侧实时生成结构化脑图。
- **双向定位**：编辑器行号和脑图节点联动，便于在文档和图形之间快速定位。
- **多种布局**：支持脑图、树状图和逻辑图布局。
- **多种样式**：支持填充卡片样式和线框/分支线样式。
- **详情级别**：支持全部、中等、精简等展示级别，适合从总览到细节的不同阅读场景。
- **节点交互**：支持节点选择、折叠、隐藏、拖拽调整层级，以及新增、删除、移动节点。
- **富文本节点**：支持常见 Markdown 内容，包括加粗、斜体、删除线、行内代码、链接、任务项、表格、代码块、图片和 LaTeX 公式。
- **导出能力**：支持导出 `.PNG`、`.SVG` 和 `.HTML`。
- **本地示例**：内置示例文档，便于快速查看不同 Markdown 结构的渲染效果。

## 使用方式

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

脚本会完成以下工作：

- 使用 MoonBit 构建 JS 产物。
- 将产物写入 `web/main.bundle.js`。
- 将 `samples/*.md` 复制到 `web/samples/`。
- 将根目录 `logo.png` 复制到 `web/logo.png`，作为网页图标资源。
- 启动本地预览服务。

默认预览地址：

```text
http://127.0.0.1:8000/index.html
```

如果只想构建、不启动服务：

```powershell
powershell -ExecutionPolicy Bypass -File .\build-web.ps1 -NoServe
```

如果只想构建并启动服务、但不自动打开浏览器：

```powershell
powershell -ExecutionPolicy Bypass -File .\build-web.ps1 -NoOpenBrowser
```

## 常用命令

```powershell
moon check
moon test
moon info
moon fmt
```

建议在提交前运行：

```powershell
moon check
moon test
moon info
moon fmt
```

## 项目结构

- `heading_parser.mbt`：解析 Markdown 标题和文档结构。
- `outline_tree.mbt`：构建层级树。
- `outline_model.mbt`：处理节点增删改移、隐藏、折叠和 Markdown 回写。
- `markdown_render.mbt`：渲染节点中的 Markdown 内容。
- `latex_math_render.mbt`：渲染 LaTeX 公式。
- `sample_data.mbt`：提供内置示例文档。
- `web_api.mbt`：提供 Web 侧调用的 API。
- `web_layout.mbt`：构建页面布局和工具栏。
- `web_dom.mbt`：处理 DOM 操作、编辑器联动、导出和下载。
- `web_frontend.mbt`：管理前端状态、交互事件和脑图渲染。
- `web_mindmap_bindings.mbt`：处理脑图视图、缩放、拖拽和节点定位。
- `web_theme.mbt`：定义 Web 界面和脑图样式。
- `web/index.html`：Web 入口页面。
- `build-web.ps1`：构建并预览 Web 版本。

## 导出说明

MoonMarkMind 支持三种导出格式：

- `.PNG`：适合用于图片分享、文档插图和演示材料。
- `.SVG`：保留矢量图形，适合继续编辑或高清展示。
- `.HTML`：导出可独立打开可交互的网页版本。

PNG/SVG 导出会使用静态导出路径，尽量保留当前脑图的视觉布局、节点样式和树状图连接线锚点。HTML 导出会保留运行时能力，并在页面加载后重新计算连接线。

## 开发说明

本项目是 MoonBit 项目，源码按 MoonBit package 组织。修改代码后请优先运行：

```powershell
moon check
moon test
```

涉及公开接口或格式化时，继续运行：

```powershell
moon info
moon fmt
```

如果修改 Web 入口、样式、导出逻辑或前端交互，请重新构建 Web bundle：

```powershell
powershell -ExecutionPolicy Bypass -File .\build-web.ps1 -NoOpenBrowser
```

## 许可证

本项目使用 Apache-2.0 License。详见 [LICENSE](LICENSE)。

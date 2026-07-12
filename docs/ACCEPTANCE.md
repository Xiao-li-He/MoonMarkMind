# MoonMarkMind 验收说明

本文档面向项目验收，按完成度、工程质量、可解释性、用户体验四个维度说明可验证材料和操作路径。

## 1. 完成度评估

MoonMarkMind 的声明范围是 Markdown 脑图编辑器与可复用 Markdown 渲染工具包：项目解析 Markdown、生成结构化脑图、提供 Web 交互编辑、支持 Markdown 富文本预览、布局与样式切换，并脑图导出 PNG、SVG 和 HTML；同时提供 `markdown_to_html` 和 `markdown_to_mindmap` 包，以及 `cmd/cli` 命令行入口，供第三方复用和自动化导出。

### 可构建

在项目根目录执行：

```powershell
moon check
moon test
powershell -ExecutionPolicy Bypass -File .\build-web.ps1 -NoOpenBrowser
```

`moon check` 用于类型检查，`moon test` 用于验证核心模型、可复用包、CLI 和前端辅助逻辑，`build-web.ps1` 用于生成 `web/main.bundle.js` 并启动本地预览服务。

### 可运行

本地预览地址：

```text
http://127.0.0.1:8000/index.html
```

在线版本：

```text
https://xiao-li-he.github.io/MoonMarkMind/
```

### 关键功能路径

1. 打开在线或本地页面。
2. 在 Markdown 编辑区输入标题、列表、任务项、代码块、表格或公式。
3. 确认脑图区域实时更新，并能定位当前节点。
4. 在 Markdown 编辑区按标题层级折叠/展开。
5. 打开 Markdown HTML 富文本预览，确认预览显示正常。
6. 切换脑图、树状图、逻辑图布局。
7. 切换填充卡片和线框/分支线样式。
8. 对节点执行新增、删除、上移、下移、缩进、提升、折叠、隐藏。
9. 加载 `samples/` 中的示例文档。
10. 导出 PNG、SVG、HTML，并检查导出文件可打开。
11. 运行 `packages/examples/markdown_to_html` 和 `packages/examples/markdown_to_mindmap`，确认可复用包示例能生成 HTML/SVG 输出。
12. 运行 `cmd/cli`，确认单个 Markdown 文件可导出为 PNG、SVG、HTML，并可通过输出扩展名推断格式。

### 可复现

核心解析和模型操作是确定性的。对同一 Markdown 输入，多次运行 `outline_json`、节点编辑和 Markdown 回写逻辑会得到一致结果。Web 端布局涉及视口尺寸和浏览器字体渲染，视觉位置可能因环境有细微差异，但结构、节点文本和导出内容应保持一致。

## 2. 工程质量评估

### 模块职责

- `lib/outline_parser`：Markdown 大纲解析、`OutlineNode` 构建、结构编辑和 Markdown 回写。
- `lib/markdown_render`：Markdown fragment/body 到安全 HTML，覆盖标题、列表、表格、图片、任务项、代码和可折叠标题区块。
- `lib/latex_math_render`：LaTeX 行内/块级公式到 HTML/SVG fragment。
- `lib/mindmap_render`：`OutlineNode` 或 Markdown 到静态 HTML/SVG 脑图字符串。
- `packages/markdown_to_html`：面向用户的 Markdown 文本到 HTML fragment 包，提供富文本与可折叠预览渲染。
- `packages/markdown_to_mindmap`：面向用户的 Markdown 文本到静态 SVG 脑图包。
- `app/web`：浏览器端应用，负责编辑器、工具栏、脑图交互、Markdown 富文本预览、DOM 集成和 Canvas PNG 导出。
- `cmd/cli`：命令行导出入口，支持单个 Markdown 文件导出 PNG/SVG/HTML。
- `cmd/main`：Web bundle 导出入口。

这些模块形成了可替换边界：解析/模型逻辑可脱离浏览器验证，可复用包可被第三方调用，Web 视图层可围绕同一模型接口演进，CLI 可复用 Web 渲染导出链路。

### 风格与错误处理

代码遵循 MoonBit block style，以 `///|` 分隔顶层块。解析和模型层尽量把边界条件收敛在局部函数中，面向 Web 的操作通过状态刷新和防御性 DOM 访问降低用户交互中的中断风险。公开接口由 `pkg.generated.mbti` 描述，便于评审确认 API 变化。

### 测试覆盖

当前测试覆盖核心路径：

- Markdown 到 outline 的解析与回写。
- 节点移动、缩进、提升、删除等模型操作。
- `markdown_to_html` 与 `markdown_to_mindmap` 包级 API。
- 可运行示例包，包括 Markdown to HTML 示例和 Markdown to mindmap SVG 示例。
- CLI 参数解析、格式推断、错误输入拒绝和输出路径解析。
- Web DOM 辅助逻辑、Markdown 编辑区标题折叠、富文本预览、前端状态和渲染辅助函数。
- 脑图导出结构、SVG/XML 转义、HTML 导出运行时和示例导出完整性。

CI 通过 `.github/workflows/check.yml` 在 Ubuntu、macOS 和 Windows 上执行：

```powershell
moon check
moon test
moon info
moon fmt
git diff --exit-code
```

推荐验收命令：

```powershell
moon check
moon test
moon info
moon fmt
```

## 3. 可解释性评估

可解释性材料包括：

- [README.md](README.md)：项目目标、功能范围、运行方式、包结构、CLI 示例和模块说明。
- [SPEC.md](SPEC.md)：Markdown 与脑图结构的规则说明。
- `pkg.generated.mbti`：公开 API 摘要。
- `packages/examples/`：用可运行示例说明可复用包输出。
- `samples/` 和 `web/samples/`：提供 Web 应用和导出回归用例。

评审可从这些材料追踪项目为什么这样拆分、核心数据如何流动，以及哪些能力属于声明范围。

## 4. 用户体验评估

目标用户包括普通写作者和 AI 代理。

### 面向写作者

- 首屏直接进入编辑体验，不需要先理解复杂配置。
- Markdown 文本和脑图同步更新，适合从大纲写作切换到结构化思考。
- Markdown 编辑区支持按标题折叠，预览区提供可折叠 HTML 富文本视图。
- 内置示例降低初次使用成本。
- 导出 PNG、SVG、HTML，覆盖分享、文档插图、继续编辑和离线展示。

### 面向 AI 代理

- README 提供明确命令入口、包调用示例、CLI 示例和关键功能路径。
- 核心模型、可复用包、CLI 和 Web 交互都有测试覆盖，便于自动化验证。
- 模块边界明确，适合局部修改和回归测试。
- `moon check`、`moon test`、`moon info`、`moon fmt` 形成稳定验收闭环。

## 当前验收状态

本次验收检查已执行：

```text
moon test app/web: 192 passed, 0 failed
moon test cmd/cli: 8 passed, 0 failed
moon test packages/markdown_to_html packages/markdown_to_mindmap packages/examples/markdown_to_html packages/examples/markdown_to_mindmap: 29 passed, 0 failed
cmd/cli PNG/SVG/HTML 本地导出: passed
```

后续若修改核心逻辑，应再次运行完整验收命令，并检查 `pkg.generated.mbti` 的 diff 是否符合预期。

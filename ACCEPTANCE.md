# MoonMarkMind 验收说明

本文档面向项目验收，按完成度、工程质量、可解释性、用户体验四个维度说明可验证材料和操作路径。

## 1. 完成度评估

MoonMarkMind 的声明范围是 Markdown 脑图编辑器：解析 Markdown、生成结构化脑图、提供 Web 交互编辑、支持布局与样式切换，并导出图片或独立 HTML。

### 可构建

在项目根目录执行：

```powershell
moon check
moon test
powershell -ExecutionPolicy Bypass -File .\build-web.ps1 -NoOpenBrowser
```

`moon check` 用于类型检查，`moon test` 用于验证核心模型和前端辅助逻辑，`build-web.ps1` 用于生成 `web/main.bundle.js` 并启动本地预览服务。

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
4. 切换脑图、树状图、逻辑图布局。
5. 切换填充卡片和线框/分支线样式。
6. 对节点执行新增、删除、上移、下移、缩进、提升、折叠、隐藏。
7. 加载 `samples/` 中的示例文档。
8. 导出 PNG、SVG、HTML，并检查导出文件可打开。

### 可复现

核心解析和模型操作是确定性的。对同一 Markdown 输入，多次运行 `outline_json`、节点编辑和 Markdown 回写逻辑会得到一致结果。Web 端布局涉及视口尺寸和浏览器字体渲染，视觉位置可能因环境有细微差异，但结构、节点文本和导出内容应保持一致。

## 2. 工程质量评估

### 模块职责

- `heading_parser.mbt`：Markdown 标题、列表和结构线索解析。
- `outline_tree.mbt`：把扁平解析结果组织为层级树。
- `outline_model.mbt`：维护脑图模型，提供节点增删改移、折叠、隐藏、缩进、提升和 Markdown 回写。
- `markdown_render.mbt`：处理节点正文中的 Markdown 富文本渲染。
- `latex_math_render.mbt`：处理 LaTeX 公式渲染。
- `sample_data.mbt`：集中维护内置示例。
- `web_layout.mbt`：生成页面结构和工具栏。
- `web_dom.mbt`：封装 DOM 读取、写入、下载、导出、编辑器联动等操作。
- `web_frontend.mbt`：组织前端状态、事件绑定和视图刷新。
- `web_mindmap_bindings.mbt`：处理脑图视图、缩放、拖拽和节点定位。
- `web_theme.mbt`：集中管理界面与脑图主题样式。

这些模块形成了可替换边界：解析/模型逻辑可脱离浏览器验证，Web 视图层可围绕同一模型接口演进，主题与布局逻辑可独立调整。

### 风格与错误处理

代码遵循 MoonBit block style，以 `///|` 分隔顶层块。解析和模型层尽量把边界条件收敛在局部函数中，面向 Web 的操作通过状态刷新和防御性 DOM 访问降低用户交互中的中断风险。公开接口由 `pkg.generated.mbti` 描述，便于评审确认 API 变化。

### 测试覆盖

当前测试覆盖核心路径：

- Markdown 到 outline 的解析与回写。
- 节点移动、缩进、提升、删除等模型操作。
- 示例数据有效性。
- Web DOM 辅助逻辑。
- 前端状态和渲染辅助函数。

推荐验收命令：

```powershell
moon check
moon test
moon info
moon fmt
```

## 3. 可解释性评估

可解释性材料包括：

- [README.md](README.md)：项目目标、功能范围、运行方式、模块说明。
- [SPEC.md](SPEC.md)：Markdown 与脑图结构的规则说明。
- `pkg.generated.mbti`：公开 API 摘要。
- 测试文件samples：用可执行示例说明核心行为。

评审可从这些材料追踪项目为什么这样拆分、核心数据如何流动，以及哪些能力属于声明范围。

## 4. 用户体验评估

目标用户包括普通写作者和 AI 代理。

### 面向写作者

- 首屏直接进入编辑体验，不需要先理解复杂配置。
- Markdown 文本和脑图同步更新，适合从大纲写作切换到结构化思考。
- 内置示例降低初次使用成本。
- 导出 PNG、SVG、HTML，覆盖分享、文档插图、继续编辑和离线展示。

### 面向 AI 代理

- README 提供明确命令入口和关键功能路径。
- 核心模型有命令行入口和测试覆盖，便于自动化验证。
- 模块边界明确，适合局部修改和回归测试。
- `moon check`、`moon test`、`moon info`、`moon fmt` 形成稳定验收闭环。

## 当前验收状态

本次补充前已执行：

```text
moon check: passed
moon test: 168 passed, 0 failed
```

后续若修改核心逻辑，应再次运行完整验收命令，并检查 `pkg.generated.mbti` 的 diff 是否符合预期。

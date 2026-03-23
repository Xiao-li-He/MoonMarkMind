# MoonMarkMind

MoonMarkMind 是一个以 MoonBit 为核心的 Markdown 脑图编辑 Demo。它会把基于标题层级的 Markdown 解析成树结构，并在浏览器里以可交互脑图的形式展示。

当前 Web Demo 采用左右分栏布局：

- 左侧是 `.md文档` 编辑区，带编辑器头部、行号和更接近文本编辑器的视觉样式
- 右侧是 `脑图` 画布，支持多种布局、样式和层级视图
- 顶部和画布工具栏支持下载、示例载入、撤销重做、缩放、适配画布、回中等操作

![MoonMarkMind Demo](demo1.png)

## 核心能力

- Markdown 标题解析
- 脑图树结构渲染
- ASCII 脑图生成
- Markdown 回写
- 节点重命名
- 新增子节点
- 删除节点
- 同级节点拖拽重排

项目重点不是只做一个前端可视化页面，而是尽量把核心文档逻辑保留在 MoonBit 中，浏览器端主要负责布局渲染和交互转发。

## 当前界面特性

- 左侧 `.md文档` 编辑区支持直接编辑 Markdown
- 编辑区带行号和更明显的书写横线背景
- 编辑器头部内置 `新建`、`上传` 图标按钮
- 右侧 `脑图` 区支持自定义下拉菜单，不再依赖浏览器原生下拉样式
- 支持 `思维图 / 逻辑图 / 树状图`
- 支持 `线条 / 填充`
- 支持 `最小 / 中等 / 全部` 层级视图
- 支持导出 `.PNG / .SVG / .HTML`
- 支持工具栏操作和缩放比例显示

## 项目结构

- `heading_parser.mbt`：解析 Markdown 标题层级
- `mindmap_renderer.mbt`：生成 ASCII 脑图
- `outline_model.mbt`：树结构导出与节点编辑逻辑
- `outline_tree.mbt`：树结构遍历与组装
- `web_api.mbt`：浏览器调用入口
- `web_layout.mbt`：Web 页面骨架和按钮/工具栏 HTML
- `web_dom.mbt`：浏览器 DOM 绑定、文件导入导出、前端交互桥接
- `web_frontend.mbt`：Web 端状态协调、视图更新和交互流程
- `web/index.html`：Web Demo 页面与样式
- `build-web.ps1`：生成浏览器可用 bundle

## 本地运行

先检查和测试：

```powershell
moon check
moon test
```

运行命令行 Demo：

```powershell
moon run cmd/main
```

生成 Web bundle：

```powershell
powershell -ExecutionPolicy Bypass -File .\build-web.ps1
```

启动静态服务：

```powershell
python -m http.server 8080 -d web
```

然后访问：

```text
http://localhost:8080
```

## 当前支持的交互

- 编辑 Markdown 后同步刷新脑图
- 双击节点标题直接改名
- 点击 `+` 新增子节点
- 点击 `x` 删除当前节点及其子树
- 点击节点或折叠按钮展开、收起子树
- 拖拽同级节点调整顺序
- 工具栏撤销 / 重做
- 缩放、适配画布、回中视图
- 导出 PNG、SVG、HTML

## 当前限制

- 目前只支持基于标题层级的 Markdown
- 还没有完整保真处理段落、列表、引用、代码块等正文内容
- 当前拖拽只支持同一父节点下的兄弟节点重排
- `web/main.bundle.js` 为构建产物，需要通过脚本生成

## 校验命令

```powershell
moon info
moon fmt
moon test
```

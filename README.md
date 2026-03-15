# MoonMarkMind

MoonMarkMind 是一个以 MoonBit 为核心的 Markdown 脑图编辑 Demo。它把基于标题层级的 Markdown 解析成树结构，并在浏览器里以左右展开的脑图形式展示，支持直接编辑、折叠、同级拖拽重排、新增子节点和删除节点。

![MoonMarkMind Demo](demo1.png)

项目的重点不是单纯做一个前端可视化页面，而是尽量把核心文档逻辑放回 MoonBit：

- Markdown 标题解析
- ASCII 脑图生成
- 树结构 JSON 导出
- 节点重命名
- 同级节点重排
- 新增子节点
- 删除节点
- Markdown 回写

浏览器端只负责布局渲染和交互事件转发。

## 项目结构

- `heading_parser.mbt`：解析 Markdown 标题层级
- `mindmap_renderer.mbt`：生成 ASCII 脑图
- `outline_model.mbt`：树结构导出和节点编辑逻辑
- `web_api.mbt`：浏览器调用入口
- `web/index.html`：Web Demo 页面
- `web/app.js`：浏览器交互层
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

- 双击节点标题直接改名
- 点击 `+` 新增子节点
- 点击 `x` 删除当前节点及其子树
- 点击节点或折叠按钮展开、收起子树
- 拖拽同级节点调整顺序
- 编辑后同步更新 Markdown 和 ASCII 视图

## 当前限制

- 目前只支持基于标题层级的 Markdown
- 还没有完整保真处理段落、列表、引用、代码块等正文内容
- 当前拖拽只支持同一父节点下的兄弟节点重排
- `web/main.bundle.js` 为构建产物，不纳入版本控制，需通过脚本生成

## 校验命令

```powershell
moon info
moon fmt
moon test
```

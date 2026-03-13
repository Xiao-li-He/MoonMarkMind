# MindDown

MindDown 是一个以 MoonBit 为核心的 Markdown 脑图演示项目。

它目前支持把基于标题层级的 Markdown 文档转换成脑图视图，并在浏览器中完成一组基础编辑操作。项目的重点不是“做一个前端小玩具”，而是把文档核心操作尽量放回 MoonBit 实现，让浏览器层只负责渲染和交互。

## 项目特性

- Markdown 标题结构解析
- MoonBit 生成 ASCII 脑图
- 中心节点向左右展开的脑图布局
- 节点折叠与展开
- 节点标题双击直接编辑
- 同级节点拖拽重排
- 新增子节点
- 删除节点子树
- 编辑后同步回写 Markdown 与 ASCII 视图

## 架构说明

项目目前分成两层：

- MoonBit 核心层
  负责解析标题、导出树结构 JSON、重命名节点、重排同级节点、新增节点、删除节点，并把结果重新序列化回 Markdown。
- Web 交互层
  负责脑图布局、按钮事件、拖拽事件和编辑输入框，并调用 MoonBit 编译出的 JS API。

主要 MoonBit 文件：

- `heading_parser.mbt`
- `mindmap_renderer.mbt`
- `outline_model.mbt`
- `web_api.mbt`

主要前端文件：

- `web/index.html`
- `web/app.js`
- `build-web.ps1`

## MoonBit 核心 API

浏览器当前会调用这些 MoonBit API：

- `outline_json(markdown)`
- `render_ascii_mindmap(markdown)`
- `rename_heading(markdown, flat_index, title)`
- `move_heading(markdown, from_flat_index, to_flat_index, place_after)`
- `add_child_heading(markdown, parent_flat_index, title)`
- `delete_heading(markdown, flat_index)`

其中“重命名、重排、新增、删除、Markdown 回写”都已经由 MoonBit 驱动，不再由前端自己维护文档模型。

## 本地开发

先安装 MoonBit，然后执行：

```powershell
moon check
moon test
```

运行命令行 demo：

```powershell
moon run cmd/main
```

构建浏览器 bundle：

```powershell
powershell -ExecutionPolicy Bypass -File .\build-web.ps1
```

本地启动静态服务：

```powershell
python -m http.server 8080 -d web
```

浏览器访问：

```text
http://localhost:8080
```

## 当前交互方式

在浏览器 demo 中：

- 双击节点标题可直接修改名称
- 点击 `+` 可新增子节点
- 点击 `×` 可删除当前节点及其子树
- 拖拽节点到同级节点上方或下方可重排顺序
- 点击节点或折叠按钮可展开/收起子树

每次操作后，左侧 Markdown 输入区和 ASCII 输出区都会同步更新。

## 校验方式

核心检查命令：

```powershell
moon check
moon test
moon info
```

Web bundle 生成方式：

- 底层由 `moon build --target js --release` 生成
- 再通过 `build-web.ps1` 桥接成浏览器可调用的接口

## 当前限制

- 目前只支持基于标题层级的 Markdown 模型
- 普通段落、列表、引用、代码块等正文内容还不会保真回写
- 当前只支持同一父节点下的拖拽重排
- 跨父节点拖拽改变层级还没有实现

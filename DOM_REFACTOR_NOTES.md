# DOM 重构整理

这份文档记录当前这块 MoonBit 前端重构里，哪些函数应当留在浏览器边界，哪些应当下沉到 MoonBit 核心逻辑。

## 1. 必须保留在 DOM / 浏览器边界层

- `bind_mindmap_ui_js`
- `bind_input_listener`
- `pick_markdown_file`
- `download_text`
- `download_current_page_html`
- `download_mindmap_svg`
- `download_mindmap_png`
- `event_target_from_point`
- `set_drag_text`
- `clear_drop_highlights`
- `highlight_drop_target`
- `parse_float`

这类函数要么直接依赖浏览器 API，要么做文件下载、拖拽、坐标命中、SVG/DOM 渲染，适合作为薄边界保留。

## 2. 适合下沉到 MoonBit 核心逻辑

- `set_input_linked_lines`
- `reveal_input_line`

这两个更像视图同步结果，不应继续和大块 JS 逻辑混在一起。

## 3. 适合做成很薄的桥接函数

- `sync_editor_chrome`
- `render_mindmap_connectors`

它们应只负责“MoonBit 触发浏览器重绘”，不要承载业务逻辑。

## 4. 不建议继续保留成大段 JS 绑定

- `bind_mindmap_ui_js`
- `bind_input_listener`

后续应当继续拆分为：

- MoonBit 侧负责状态、选择、编辑、折叠、布局规则、导出决策
- DOM helper 负责事件转发、DOM 查询、尺寸读取、下载、拖拽
- JS 只保留 MoonBit 库暂时还没覆盖到的少数浏览器细节

## 5. 当前建议的目标结构

1. MoonBit：核心逻辑
2. DOM helper：薄边界
3. JS 兜底：尽量少


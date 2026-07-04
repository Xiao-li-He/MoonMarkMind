# mindmap_renderer

`mindmap_renderer` 是 MoonMarkMind 的纯字符串脑图渲染包，负责把 Markdown 或 `OutlineNode` 渲染为静态 HTML/SVG 片段。

它依赖 `outline_parser`，但不依赖 DOM 测量、Canvas 或浏览器下载逻辑。浏览器端精细交互仍由 `app/web` 负责。

## Install / Import

在使用方 `moon.pkg` 中导入：

```text
import {
  "Xiao-li-He/MoonMarkMind/lib/mindmap_renderer" @mindmap
}
```

## Quick Start

```mbt check
///|
test {
  let html = render_markdown_html(
    "# Root\n## Child",
    options=default_render_options(),
  )
  assert_true(html.contains("moonmarkmind-node"))
  assert_true(html.contains("Root"))
}
```

## Core APIs

### 渲染 HTML

```mbt check
///|
test {
  let html = render_markdown_html("# Root\n## Child")
  assert_true(html.contains("moonmarkmind-export"))
  assert_true(html.contains("data-level=\"2\""))
}
```

### 渲染 SVG

```mbt check
///|
test {
  let svg = render_markdown_svg("# Root\n## Child")
  assert_true(svg.contains("<svg"))
  assert_true(svg.contains("Root"))
}
```

### 使用 OutlineNode

```mbt check
///|
test {
  let outline = @outline.build_outline("# Root\n## Child")
  let html = render_outline_html(outline)
  let svg = render_outline_svg(outline)
  assert_true(html.contains("Child"))
  assert_true(svg.contains("Child"))
}
```

## Options

`RenderOptions` 包含三类配置：

- `layout`：`Logic`、`Mindmap`、`Tree`
- `style`：`Full`、`Line`
- `layer`：`Root`、`Layer2`、`Full`

`layer` 与 Web 端 `detail-select` 的映射为：

| `MindmapLayer` | Web detail-select |
| --- | --- |
| `Root` | `small` |
| `Layer2` | `medium` |
| `Full` | `all` |

```mbt check
///|
test {
  assert_eq(layer_to_detail_select(Root), "small")
  assert_eq(layer_to_detail_select(Layer2), "medium")
  assert_eq(layer_to_detail_select(Full), "all")
}
```

## Notes

- 本包提供基础静态 HTML/SVG 输出，适合 CLI、测试和简单嵌入。
- Web 应用中的节点拖拽、缩放、DOM 测量、Canvas PNG 导出仍保留在 `app/web`。
- 字符串输入会先通过 `outline_parser` 构建结构树。

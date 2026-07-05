# outline_parser

`outline_parser` 是 MoonMarkMind 的 Markdown 大纲结构包，负责从 Markdown 中提取结构节点、构建 `OutlineNode` 树、执行节点级编辑，并把编辑结果回写为 Markdown。

它不依赖 DOM、Canvas 或浏览器 API，适合在 Web、CLI、测试和后续服务端场景中复用。

## Install / Import

在使用方 `moon.pkg` 中导入：

```text
import {
  "Xiao-li-He/MoonMarkMind/lib/outline_parser" @outline
}
```

## Quick Start

```mbt check
///|
test {
  let markdown = "# Project\n## Goal\n## Plan"
  let headings = parse_headings(markdown)
  guard headings.length() == 3 else { fail("expected three headings") }
  guard headings[0] == (1, "Project") else { fail("unexpected root heading") }

  let outline = build_outline(markdown)
  guard outline.title == "Project" else { fail("unexpected title") }
  guard outline.children.length() == 2 else {
    fail("expected two child headings")
  }
}
```

## Core APIs

### 解析 Markdown

```mbt check
///|
test {
  let markdown = "# Root\n\nbody\n\n## Child"
  let nodes = parse_markdown_nodes(markdown)
  guard nodes.length() == 2 else { fail("expected two nodes") }
  guard nodes[0].title == "Root" else { fail("unexpected root title") }
  guard nodes[1].level == 2 else { fail("unexpected child level") }
}
```

### 构建树和 JSON

```mbt check
///|
test {
  let markdown = "# Root\n## Child"
  let outline = build_outline(markdown)
  guard outline.children[0].title == "Child" else {
    fail("expected child node")
  }

  let json = outline_json(markdown)
  assert_true(json.contains("\"title\":\"Root\""))
  assert_true(json.contains("\"title\":\"Child\""))
}
```

### 编辑并回写 Markdown

```mbt check
///|
test {
  let markdown = "# Root\n## Old"
  let renamed = rename_heading(markdown, 1, "New")
  assert_true(renamed.contains("## New"))

  let nodes = parse_markdown_nodes(renamed)
  let rendered = render_markdown_nodes(nodes)
  assert_true(rendered.contains("# Root"))
  assert_true(rendered.contains("## New"))
}
```

## Notes

- `flat_index` 以解析出的可见结构节点为准，常用于 Web 端选择和编辑节点。
- `MarkdownNode` 表示扁平 Markdown 结构，`OutlineNode` 表示树形结构。
- 结构编辑 API 会返回新的 Markdown 字符串，不直接修改浏览器状态。
- 本包定位不同于完整 CommonMark 解析器：它聚焦“大纲结构”和“脑图编辑回写”。

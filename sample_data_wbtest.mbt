///|
test "rules markdown keeps body blocks visible" {
  let rendered = render_markdown_nodes(
    parse_markdown_nodes(rules_test_markdown()),
  )
  guard rendered.contains("# 示例1 基本使用") else {
    fail("missing example 1 heading")
  }
  guard rendered.contains("###### 标题5级分支") else {
    fail("missing deepest heading")
  }
  guard rendered.contains("- 6级分支及之后用列表") else {
    fail("missing list branch")
  }
  guard rendered.contains("1. 有序列表也可以 子分支1.3") else {
    fail("missing ordered list marker")
  }
  guard rendered.contains(
    "  3. 层级仅由其父节点和缩进结构决定 子分支1.4.1",
  ) else {
    fail("missing nested ordered list content")
  }
  guard rendered.contains("  * 符号- * + 都可以 子分支1.1.1") else {
    fail("missing mixed bullet content")
  }
  guard rendered.contains("```ts\nconst title = \"code block\";") else {
    fail("missing code block content")
  }
  guard rendered.contains("| md编辑区 | ✅ | 已完成 |") else {
    fail("missing table content")
  }
  guard rendered.contains("### 直接跳到三级标题") else {
    fail("missing bug test heading")
  }
}

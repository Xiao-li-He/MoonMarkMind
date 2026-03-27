///|
test "rules markdown keeps body blocks visible" {
  let rendered = render_markdown_nodes(
    parse_markdown_nodes(rules_test_markdown()),
  )
  guard rendered.contains("这是根节点的说明文本") else {
    fail("missing intro paragraph")
  }
  guard rendered.contains("```ts") else { fail("missing code block") }
  guard rendered.contains("> 这是引用块文本") else {
    fail("missing blockquote")
  }
  guard rendered.contains("1. 有序列表 B1") else {
    fail("missing ordered list marker")
  }
  guard rendered.contains("标题下面直接接列表") else {
    fail("missing bullet list content")
  }
  guard rendered.contains("![图片测试](https://example.com/image.png)") else {
    fail("missing image markdown")
  }
}

///|
test "parse headings from markdown" {
  inspect(
    parse_headings(sample_markdown()),
    content="[(1, \"MoonMarkMind Demo\"), (2, \"Parser\"), (3, \"Heading extraction\"), (3, \"Level mapping\"), (2, \"Renderer\"), (3, \"Tree preview\"), (3, \"Round-trip preview\")]",
  )
}

///|
test "export outline json" {
  inspect(
    outline_json(sample_markdown()),
    content="{\"flat_index\":0,\"source_line\":0,\"level\":1,\"type\":\"heading\",\"title\":\"MoonMarkMind Demo\",\"synthetic\":false,\"children\":[{\"flat_index\":1,\"source_line\":1,\"level\":2,\"type\":\"heading\",\"title\":\"Parser\",\"synthetic\":false,\"children\":[{\"flat_index\":2,\"source_line\":2,\"level\":3,\"type\":\"heading\",\"title\":\"Heading extraction\",\"synthetic\":false,\"children\":[]},{\"flat_index\":3,\"source_line\":3,\"level\":3,\"type\":\"heading\",\"title\":\"Level mapping\",\"synthetic\":false,\"children\":[]}]},{\"flat_index\":4,\"source_line\":4,\"level\":2,\"type\":\"heading\",\"title\":\"Renderer\",\"synthetic\":false,\"children\":[{\"flat_index\":5,\"source_line\":5,\"level\":3,\"type\":\"heading\",\"title\":\"Tree preview\",\"synthetic\":false,\"children\":[]},{\"flat_index\":6,\"source_line\":6,\"level\":3,\"type\":\"heading\",\"title\":\"Round-trip preview\",\"synthetic\":false,\"children\":[]}]}]}",
  )
}

///|
test "rename heading in markdown" {
  inspect(
    rename_heading(sample_markdown(), 5, "Canvas preview"),
    content="# MoonMarkMind Demo\n## Parser\n### Heading extraction\n### Level mapping\n## Renderer\n### Canvas preview\n### Round-trip preview",
  )
}

///|
test "move sibling heading subtree" {
  inspect(
    move_heading(sample_markdown(), 4, 1, false),
    content="# MoonMarkMind Demo\n## Renderer\n### Tree preview\n### Round-trip preview\n## Parser\n### Heading extraction\n### Level mapping",
  )
}

///|
test "add child heading" {
  inspect(
    add_child_heading(sample_markdown(), 4, "Export"),
    content="# MoonMarkMind Demo\n## Parser\n### Heading extraction\n### Level mapping\n## Renderer\n### Tree preview\n### Round-trip preview\n### Export",
  )
}

///|
test "delete heading subtree" {
  inspect(
    delete_heading(sample_markdown(), 1),
    content="# MoonMarkMind Demo\n## Renderer\n### Tree preview\n### Round-trip preview",
  )
}

///|
test "delete keeps fixed root heading" {
  inspect(delete_heading(sample_markdown(), 0), content=sample_markdown())
}

///|
test "add sibling heading after subtree" {
  inspect(
    add_sibling_heading(sample_markdown(), 1, "Tokenizer", true),
    content="# MoonMarkMind Demo\n## Parser\n### Heading extraction\n### Level mapping\n## Tokenizer\n## Renderer\n### Tree preview\n### Round-trip preview",
  )
}

///|
test "move sibling heading up" {
  let markdown = "# Root\n## A\n## B\n## C"
  inspect(
    move_heading_among_siblings(markdown, 2, false),
    content="# Root\n## B\n## A\n## C",
  )
}

///|
test "move sibling heading down" {
  let markdown = "# Root\n## A\n## B\n## C"
  inspect(
    move_heading_among_siblings(markdown, 2, true),
    content="# Root\n## A\n## C\n## B",
  )
}

///|
test "seventh level falls back to list" {
  let markdown = "# Root\n## A\n### B\n#### C\n##### D\n###### E\n- F\n  - G"
  let outline = outline_json(markdown)
  guard outline.contains("\"title\":\"F\"") && outline.contains("\"level\":7") else {
    fail("missing seventh level list node")
  }
  guard outline.contains("\"title\":\"G\"") && outline.contains("\"level\":8") else {
    fail("missing eighth level list node")
  }
}

///|
test "export structural outline json" {
  let markdown = "# Root\n- A\n  - B\n## C\n1. D\n   1. E"
  inspect(
    outline_json(markdown),
    content="{\"flat_index\":0,\"source_line\":0,\"level\":1,\"type\":\"heading\",\"title\":\"Root\",\"synthetic\":false,\"children\":[{\"flat_index\":1,\"source_line\":1,\"level\":2,\"type\":\"list_item\",\"title\":\"A\",\"synthetic\":false,\"children\":[{\"flat_index\":2,\"source_line\":2,\"level\":3,\"type\":\"list_item\",\"title\":\"B\",\"synthetic\":false,\"children\":[]}]},{\"flat_index\":3,\"source_line\":3,\"level\":2,\"type\":\"heading\",\"title\":\"C\",\"synthetic\":false,\"children\":[{\"flat_index\":4,\"source_line\":4,\"level\":3,\"type\":\"list_item\",\"title\":\"D\",\"synthetic\":false,\"children\":[{\"flat_index\":5,\"source_line\":5,\"level\":4,\"type\":\"list_item\",\"title\":\"E\",\"synthetic\":false,\"children\":[]}]}]}]}",
  )
}

///|
test "indent heading nests subtree under previous sibling" {
  let markdown = "# Root\n## Alpha\n## Beta\n### Beta child\n## Gamma"
  inspect(
    indent_heading(markdown, 2),
    content="# Root\n## Alpha\n### Beta\n#### Beta child\n## Gamma",
  )
}

///|
test "promote heading lifts subtree one level" {
  let markdown = "# Root\n## Alpha\n### Beta\n#### Beta child\n## Gamma"
  inspect(
    promote_heading(markdown, 2),
    content="# Root\n## Alpha\n## Beta\n### Beta child\n## Gamma",
  )
}

///|
test "move heading can reparent across branches" {
  let markdown = "# Root\n## Alpha\n### Alpha child\n## Beta\n### Beta child"
  inspect(
    move_heading(markdown, 1, 4, false),
    content="# Root\n## Beta\n### Alpha\n#### Alpha child\n### Beta child",
  )
}

///|
test "indent and promote keep structure round trippable" {
  let markdown = "# Root\n## Alpha\n## Beta\n## Gamma"
  let indented = indent_heading(markdown, 2)
  inspect(
    outline_json(indented),
    content="{\"flat_index\":0,\"source_line\":0,\"level\":1,\"type\":\"heading\",\"title\":\"Root\",\"synthetic\":false,\"children\":[{\"flat_index\":1,\"source_line\":1,\"level\":2,\"type\":\"heading\",\"title\":\"Alpha\",\"synthetic\":false,\"children\":[{\"flat_index\":2,\"source_line\":2,\"level\":3,\"type\":\"heading\",\"title\":\"Beta\",\"synthetic\":false,\"children\":[]}]},{\"flat_index\":3,\"source_line\":3,\"level\":2,\"type\":\"heading\",\"title\":\"Gamma\",\"synthetic\":false,\"children\":[]}]}",
  )
  inspect(
    promote_heading(indented, 2),
    content="# Root\n## Alpha\n## Beta\n## Gamma",
  )
}

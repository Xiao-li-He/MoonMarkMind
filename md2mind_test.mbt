///|
test "parse headings from markdown" {
  inspect(
    parse_headings(sample_markdown()),
    content="[(1, \"MoonMarkMind Demo\"), (2, \"Parser\"), (3, \"Heading extraction\"), (3, \"Level mapping\"), (2, \"Renderer\"), (3, \"ASCII mindmap\"), (3, \"Round-trip preview\")]",
  )
}

///|
test "render ascii mindmap" {
  inspect(
    render_ascii_mindmap(sample_markdown()),
    content="- MoonMarkMind Demo\n  - Parser\n    - Heading extraction\n    - Level mapping\n  - Renderer\n    - ASCII mindmap\n    - Round-trip preview",
  )
}

///|
test "export outline json" {
  inspect(
    outline_json(sample_markdown()),
    content="{\"flat_index\":0,\"level\":1,\"title\":\"MoonMarkMind Demo\",\"synthetic\":false,\"children\":[{\"flat_index\":1,\"level\":2,\"title\":\"Parser\",\"synthetic\":false,\"children\":[{\"flat_index\":2,\"level\":3,\"title\":\"Heading extraction\",\"synthetic\":false,\"children\":[]},{\"flat_index\":3,\"level\":3,\"title\":\"Level mapping\",\"synthetic\":false,\"children\":[]}]},{\"flat_index\":4,\"level\":2,\"title\":\"Renderer\",\"synthetic\":false,\"children\":[{\"flat_index\":5,\"level\":3,\"title\":\"ASCII mindmap\",\"synthetic\":false,\"children\":[]},{\"flat_index\":6,\"level\":3,\"title\":\"Round-trip preview\",\"synthetic\":false,\"children\":[]}]}]}",
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
    content="# MoonMarkMind Demo\n## Renderer\n### ASCII mindmap\n### Round-trip preview\n## Parser\n### Heading extraction\n### Level mapping",
  )
}

///|
test "add child heading" {
  inspect(
    add_child_heading(sample_markdown(), 4, "Export"),
    content="# MoonMarkMind Demo\n## Parser\n### Heading extraction\n### Level mapping\n## Renderer\n### ASCII mindmap\n### Round-trip preview\n### Export",
  )
}

///|
test "delete heading subtree" {
  inspect(
    delete_heading(sample_markdown(), 1),
    content="# MoonMarkMind Demo\n## Renderer\n### ASCII mindmap\n### Round-trip preview",
  )
}

///|
test "render structural headings and lists" {
  let markdown = "# Root\n- A\n  - B\n## C\n1. D\n   1. E"
  inspect(
    render_ascii_mindmap(markdown),
    content="- Root\n  - A\n    - B\n  - C\n    - D\n      - E",
  )
}

///|
test "export structural outline json" {
  let markdown = "# Root\n- A\n  - B\n## C\n1. D\n   1. E"
  inspect(
    outline_json(markdown),
    content="{\"flat_index\":0,\"level\":1,\"title\":\"Root\",\"synthetic\":false,\"children\":[{\"flat_index\":1,\"level\":2,\"title\":\"A\",\"synthetic\":false,\"children\":[{\"flat_index\":2,\"level\":3,\"title\":\"B\",\"synthetic\":false,\"children\":[]}]},{\"flat_index\":3,\"level\":2,\"title\":\"C\",\"synthetic\":false,\"children\":[{\"flat_index\":4,\"level\":3,\"title\":\"D\",\"synthetic\":false,\"children\":[{\"flat_index\":5,\"level\":4,\"title\":\"E\",\"synthetic\":false,\"children\":[]}]}]}]}",
  )
}

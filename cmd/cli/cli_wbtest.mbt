///|
test "parse request uses stable defaults" {
  let request = parse_request(["cmd/cli", "--", "samples/example1.md"])
  assert_eq(request.input_path, "samples/example1.md")
  assert_eq(request.output_format, "png")
  assert_eq(request.output_path, "output/example1.png")
  assert_eq(request.layout, "logic")
  assert_eq(request.style, "full")
  assert_eq(request.layer, "full")
}

///|
test "parse request accepts one explicit format and all rendering options" {
  let request = parse_request([
    "cmd/cli", "samples/example1.md", "--format", "svg", "--layout", "mindmap", "--style",
    "line", "--layer", "layer2", "--browser", "chrome", "-o", "dist/map.svg",
  ])
  assert_eq(request.input_path, "samples/example1.md")
  assert_eq(request.output_format, "svg")
  assert_eq(request.output_path, "dist/map.svg")
  assert_eq(request.layout, "mindmap")
  assert_eq(request.style, "line")
  assert_eq(request.layer, "layer2")
  assert_eq(request.browser_path, "chrome")
}

///|
test "output extension infers format" {
  for
    pair in [
      ("dist/map.png", "png"),
      ("dist/map.svg", "svg"),
      ("dist/map.html", "html"),
    ] {
    let (path, expected) = pair
    let request = parse_request(["cmd/cli", "input.md", "-o", path])
    assert_eq(request.output_format, expected)
  }
}

///|
test "format and output extension conflict fails" {
  try
    parse_request(["cmd/cli", "input.md", "--format", "png", "-o", "map.svg"])
  catch {
    _ => ()
  } noraise {
    _ => fail("expected conflicting format and extension to fail")
  }
}

///|
test "comma separated and unknown formats fail" {
  for format in ["png,svg", "pdf"] {
    try parse_request(["cmd/cli", "input.md", "--format", format]) catch {
      _ => ()
    } noraise {
      _ => fail("expected invalid format to fail")
    }
  }
}

///|
test "multiple inputs fail" {
  try parse_request(["cmd/cli", "one.md", "two.md"]) catch {
    _ => ()
  } noraise {
    _ => fail("expected multiple inputs to fail")
  }
}

///|
test "all layout style and layer values are accepted" {
  for layout in ["logic", "mindmap", "tree"] {
    assert_eq(validate_layout(layout), layout)
  }
  for style in ["full", "line"] {
    assert_eq(validate_style(style), style)
  }
  for layer in ["root", "layer2", "full"] {
    assert_eq(validate_layer(layer), layer)
  }
}

///|
test "input and output path helpers" {
  assert_true(is_markdown_path("notes.MD"))
  assert_false(is_markdown_path("notes.txt"))
  assert_eq(
    resolve_output_path("samples/example1.md", "html", None),
    "output/example1.html",
  )
}

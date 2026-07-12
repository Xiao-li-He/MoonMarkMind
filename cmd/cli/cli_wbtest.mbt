///|
test "parse batch request accepts multiple inputs and formats" {
  let request = parse_request([
    "cmd/cli",
    "--",
    "samples",
    "README.md",
    "--output",
    "png,svg,html",
    "--layout",
    "mindmap",
    "--style",
    "line",
    "--layer",
    "layer2",
    "--browser",
    "chrome",
    "-o",
    "dist",
  ])
  assert_true(request.input_paths == ["samples", "README.md"])
  assert_true(request.output_formats == ["png", "svg", "html"])
  assert_eq(request.layout, "mindmap")
  assert_eq(request.style, "line")
  assert_eq(request.layer, "layer2")
  assert_eq(request.browser_path, "chrome")
  assert_eq(request.output_dir, "dist")
}

///|
test "parse batch request defaults to all dynamic formats" {
  let request = parse_request(["cmd/cli", "--", "samples/example1.md"])
  assert_true(request.input_paths == ["samples/example1.md"])
  assert_true(request.output_formats == ["png", "svg", "html"])
  assert_eq(request.layout, "logic")
  assert_eq(request.style, "full")
  assert_eq(request.layer, "full")
  assert_eq(request.output_dir, "output")
}

///|
test "parse output formats removes duplicates" {
  assert_true(validate_output_formats("svg,png,svg,html") == [
    "svg",
    "png",
    "html",
  ])
}

///|
test "invalid output format fails" {
  try validate_output_formats("png,pdf") catch {
    _ => ()
  } noraise {
    _ => fail("expected invalid format to fail")
  }
}

///|
test "duplicate stems fail before export" {
  try
    ensure_unique_output_stems([
      ExportInput::{ path: "a/notes.md", stem: "notes" },
      ExportInput::{ path: "b/notes.md", stem: "notes" },
    ])
  catch {
    _ => ()
  } noraise {
    _ => fail("expected duplicate stems to fail")
  }
}

///|
test "output path uses input stem and format" {
  let input = ExportInput::{ path: "samples/example1.md", stem: "example1" }
  assert_eq(output_path("output", input, "png"), "output/example1.png")
}

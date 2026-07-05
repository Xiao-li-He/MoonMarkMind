///|
fn example_input_path() -> String {
  "packages/examples/markdown_to_html/example1.md"
}

///|
fn example_output_path() -> String {
  "packages/examples/markdown_to_html/example1.html"
}

///|
fn render_html_document(body : String) -> String {
  (
    $|<!doctype html>
    $|<html lang="en">
    $|<head>
    $|  <meta charset="utf-8">
    $|  <meta name="viewport" content="width=device-width, initial-scale=1">
    $|  <title>MoonMarkMind Markdown to HTML Example</title>
    $|</head>
    $|<body>
    $|\{body}
    $|</body>
    $|</html>
  )
}

///|
async fn render_example_file() -> String {
  let markdown = @fs.read_file(example_input_path()).text()
  let html = render_html_document(@to_html.render(markdown))
  @fs.write_file(example_output_path(), html)
  html
}

///|
async fn main {
  try render_example_file() catch {
    e => fail("Failed to render markdown_to_html example: \{e}")
  } noraise {
    _ => println("Generated \{example_output_path()}")
  }
}

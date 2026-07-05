///|
fn example_input_path() -> String {
  "packages/examples/markdown_to_html/example1.md"
}

///|
fn example_output_path() -> String {
  "packages/examples/markdown_to_html/example1.html"
}

///|
pub fn rich_markdown() -> String {
  "# Markdown to HTML\n\nHello **MoonBit**, `code`, and inline math $x^2$.\n\n$$\\frac{a}{\\sqrt{b}}$$"
}

///|
pub fn render_rich_markdown_html() -> String {
  @to_html.render(rich_markdown())
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
    $|  \{@to_html.render_style_element()}
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

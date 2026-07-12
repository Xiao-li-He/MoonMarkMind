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
pub fn render_rich_markdown_collapsible_html() -> String {
  @to_html.render_collapsible(rich_markdown())
}

///|
fn render_html_document(body : String) -> String {
  [
    "<!doctype html>",
    html_element("html", attrs=" lang=\"en\"", children=[
      render_html_head(),
      html_element("body", attrs="", children=[body]),
    ]),
  ].join("\n")
}

///|
fn render_html_head() -> String {
  html_element("head", attrs="", children=[
    void_html_element("meta", attrs=" charset=\"utf-8\""),
    void_html_element(
      "meta",
      attrs=" name=\"viewport\" content=\"width=device-width, initial-scale=1\"",
    ),
    html_element("title", attrs="", children=[
      "MoonMarkMind Markdown to HTML Example",
    ]),
    @to_html.render_style_element(),
  ])
}

///|
fn html_element(
  tag : String,
  attrs~ : String,
  children~ : Array[String],
) -> String {
  "<\{tag}\{attrs}>\{children.join("")}</\{tag}>"
}

///|
fn void_html_element(tag : String, attrs~ : String) -> String {
  "<\{tag}\{attrs}>"
}

///|
async fn render_example_file() -> String {
  let markdown = @fs.read_file(example_input_path()).text()
  let html = render_html_document(@to_html.render_collapsible(markdown))
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

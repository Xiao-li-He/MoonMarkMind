///|
fn sample_names() -> Array[String] {
  ["example1", "example2", "example3", "example4"]
}

///|
fn sample_input_path(name : String) -> String {
  "samples/\{name}.md"
}

///|
fn example_output_dir() -> String {
  "packages/examples/markdown_to_mindmap/output"
}

///|
fn html_output_path(name : String) -> String {
  "\{example_output_dir()}/\{name}.html"
}

///|
fn svg_output_path(name : String) -> String {
  "\{example_output_dir()}/\{name}.svg"
}

///|
fn render_options() -> @to_mindmap.RenderOptions {
  {
    layout: @to_mindmap.normalize_layout("logic"),
    style: @to_mindmap.normalize_style("full"),
    layer: @to_mindmap.normalize_layer("full"),
  }
}

///|
pub fn render_sample_html(markdown : String) -> String {
  @to_mindmap.render_html_document(markdown, options=render_options())
}

///|
pub fn render_sample_svg(markdown : String) -> String {
  @to_mindmap.render_svg(markdown, options=render_options())
}

///|
async fn render_sample_file(name : String) -> Unit {
  let markdown = @fs.read_file(sample_input_path(name)).text()
  @fs.write_file(html_output_path(name), render_sample_html(markdown))
  @fs.write_file(svg_output_path(name), render_sample_svg(markdown))
}

///|
pub async fn render_all_samples() -> Array[String] {
  @fs.mkdir(example_output_dir(), recursive=true) catch {
    _ => ()
  }
  let generated = []
  for name in sample_names() {
    render_sample_file(name)
    generated.push(html_output_path(name))
    generated.push(svg_output_path(name))
  }
  generated
}

///|
async fn main {
  try render_all_samples() catch {
    e => fail("Failed to render markdown_to_mindmap examples: \{e}")
  } noraise {
    paths =>
      for path in paths {
        println("Generated \{path}")
      }
  }
}

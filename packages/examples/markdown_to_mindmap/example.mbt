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
struct ExampleVariant {
  layout : String
  style : String
}

///|
fn example_variants() -> Array[ExampleVariant] {
  let variants = []
  for layout in ["logic", "mindmap", "tree"] {
    for style in ["full", "line"] {
      variants.push(ExampleVariant::{ layout, style })
    }
  }
  variants
}

///|
fn html_output_path(name : String, variant : ExampleVariant) -> String {
  "\{example_output_dir()}/\{name}.\{variant.layout}.\{variant.style}.html"
}

///|
fn svg_output_path(name : String, variant : ExampleVariant) -> String {
  "\{example_output_dir()}/\{name}.\{variant.layout}.\{variant.style}.svg"
}

///|
fn render_options(layout : String, style : String) -> @to_mindmap.RenderOptions {
  {
    layout: @to_mindmap.normalize_layout(layout),
    style: @to_mindmap.normalize_style(style),
    layer: @to_mindmap.normalize_layer("full"),
  }
}

///|
pub fn render_sample_html(
  markdown : String,
  layout? : String = "logic",
  style? : String = "full",
) -> String {
  @to_mindmap.render_html_document(
    markdown,
    options=render_options(layout, style),
  )
}

///|
pub fn render_sample_svg(
  markdown : String,
  layout? : String = "logic",
  style? : String = "full",
) -> String {
  @to_mindmap.render_svg(markdown, options=render_options(layout, style))
}

///|
async fn render_sample_variant_file(
  name : String,
  markdown : String,
  variant : ExampleVariant,
) -> Unit {
  @fs.write_file(
    html_output_path(name, variant),
    render_sample_html(markdown, layout=variant.layout, style=variant.style),
  )
  @fs.write_file(
    svg_output_path(name, variant),
    render_sample_svg(markdown, layout=variant.layout, style=variant.style),
  )
}

///|
async fn clean_example_output_dir() -> Unit {
  @fs.mkdir(example_output_dir(), recursive=true) catch {
    _ => ()
  }
  let entries = @fs.readdir(example_output_dir()) catch { _ => [] }
  for entry in entries {
    if entry.has_suffix(".html") || entry.has_suffix(".svg") {
      @fs.remove("\{example_output_dir()}/\{entry}") catch {
        _ => ()
      }
    }
  }
}

///|
async fn render_sample_file(name : String) -> Array[String] {
  let markdown = @fs.read_file(sample_input_path(name)).text()
  let generated = []
  for variant in example_variants() {
    render_sample_variant_file(name, markdown, variant)
    generated.push(html_output_path(name, variant))
    generated.push(svg_output_path(name, variant))
  }
  generated
}

///|
pub async fn render_all_samples() -> Array[String] {
  clean_example_output_dir()
  let generated = []
  for name in sample_names() {
    for path in render_sample_file(name) {
      generated.push(path)
    }
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

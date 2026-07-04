///|
priv struct CliRequest {
  input_path : String
  output_format : String
  layout : String
  style : String
  layer : String
}

///|
fn command() -> @argparse.Command {
  @argparse.Command(
    "moonmarkmind",
    about="Export Markdown outlines as MoonMarkMind mind-map artifacts",
    arg_required_else_help=true,
    options=[
      @argparse.OptionArg(
        "output",
        long="output",
        about="Output format: svg, html, or png",
      ),
      @argparse.OptionArg(
        "layout",
        long="layout",
        about="Layout: logic, mindmap, or tree",
      ),
      @argparse.OptionArg("style", long="style", about="Style: full or line"),
      @argparse.OptionArg(
        "layer",
        long="layer",
        about="Layer preset: root, layer2, or full",
      ),
    ],
    positionals=[
      @argparse.PositionArg(
        "input",
        about="Markdown file path",
        num_args=@argparse.ValueRange::single(),
      ),
    ],
  )
}

///|
fn parse_request(argv : Array[String]) -> CliRequest raise {
  let matches = @argparse.parse(command(), argv=argv[1:])
  {
    input_path: required_arg(matches, "input"),
    output_format: optional_arg(matches, "output", "svg"),
    layout: optional_arg(matches, "layout", "logic"),
    style: optional_arg(matches, "style", "full"),
    layer: optional_arg(matches, "layer", "full"),
  }
}

///|
fn required_arg(matches : @argparse.Matches, key : String) -> String raise {
  match matches.values.get(key) {
    Some([value, ..]) => value
    _ => fail("Missing required argument: \{key}")
  }
}

///|
fn optional_arg(
  matches : @argparse.Matches,
  key : String,
  fallback : String,
) -> String {
  match matches.values.get(key) {
    Some([value, ..]) => value
    _ => fallback
  }
}

///|
fn render_options(request : CliRequest) -> @renderer.RenderOptions {
  {
    layout: @renderer.normalize_layout(request.layout),
    style: @renderer.normalize_style(request.style),
    layer: @renderer.normalize_layer(request.layer),
  }
}

///|
fn output_path(input_path : String, output_format : String) -> String {
  "\{file_stem(input_path)}.\{output_format}"
}

///|
fn file_stem(path : String) -> String {
  let mut name_start = 0
  for i in 0..<path.length() {
    let ch = path[i].to_int().unsafe_to_char()
    if ch == '/' || ch == '\\' {
      name_start = i + 1
    }
  }
  let mut dot_index = -1
  for i in name_start..<path.length() {
    if path[i].to_int().unsafe_to_char() == '.' {
      dot_index = i
    }
  }
  if dot_index > name_start {
    path[name_start:dot_index].to_owned()
  } else {
    path[name_start:path.length()].to_owned()
  }
}

///|
fn run_export(request : CliRequest) -> Unit raise {
  let options = render_options(request)
  let _ = options
  let _ = request.input_path
  let _ = output_path(request.input_path, request.output_format)
  match request.output_format {
    "svg" | "html" =>
      fail(
        "File-system export requires moonbitlang/x; renderer library APIs are available now",
      )
    "png" =>
      fail(
        "PNG export requires the browser Canvas pipeline and is not available in the native CLI yet",
      )
    format => fail("Unsupported output format: \{format}")
  }
}

///|
pub fn run() -> Unit {
  let request = parse_request(@env.args()) catch {
    e => {
      println("Error parsing arguments: \{e}")
      return
    }
  }
  run_export(request) catch {
    e => println("Failed to export mind map: \{e}")
  }
}

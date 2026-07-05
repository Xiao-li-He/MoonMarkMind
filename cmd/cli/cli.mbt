///|
priv struct CliRequest {
  input_path : String
  output_format : String
  layout : String
  style : String
  layer : String
  output_dir : String
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
        about="Output format: svg or html",
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
      @argparse.OptionArg(
        "output-dir",
        short='o',
        long="output-dir",
        about="Output directory",
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
  let matches = @argparse.parse(command(), argv=normalize_argv(argv))
  {
    input_path: required_arg(matches, "input"),
    output_format: validate_output_format(
      optional_arg(matches, "output", "svg"),
    ),
    layout: validate_layout(optional_arg(matches, "layout", "logic")),
    style: validate_style(optional_arg(matches, "style", "full")),
    layer: validate_layer(optional_arg(matches, "layer", "full")),
    output_dir: optional_arg(matches, "output-dir", "output"),
  }
}

///|
fn normalize_argv(argv : Array[String]) -> Array[String] {
  let args = []
  let mut in_runtime_prefix = true
  for arg in argv {
    if in_runtime_prefix && looks_like_executable_arg(arg) {
      continue
    }
    in_runtime_prefix = false
    if arg == "--" {
      continue
    }
    args.push(arg)
  }
  args
}

///|
fn looks_like_executable_arg(arg : String) -> Bool {
  arg.has_suffix(".js") ||
  arg.has_suffix(".mjs") ||
  arg.has_suffix(".exe") ||
  arg.has_suffix(".wasm") ||
  arg.has_suffix("cmd/cli") ||
  arg.has_suffix("cmd\\cli")
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
fn validate_output_format(value : String) -> String raise {
  match value {
    "svg" | "html" => value
    _ => fail("Unsupported output format: \{value}")
  }
}

///|
fn validate_layout(value : String) -> String raise {
  match value {
    "logic" | "mindmap" | "tree" => value
    _ => fail("Unsupported layout: \{value}")
  }
}

///|
fn validate_style(value : String) -> String raise {
  match value {
    "full" | "line" => value
    _ => fail("Unsupported style: \{value}")
  }
}

///|
fn validate_layer(value : String) -> String raise {
  match value {
    "root" | "layer2" | "full" => value
    _ => fail("Unsupported layer: \{value}")
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
fn output_path(request : CliRequest) -> String {
  join_path(
    request.output_dir,
    "\{file_stem(request.input_path)}.\{request.output_format}",
  )
}

///|
fn join_path(dir : String, name : String) -> String {
  let trimmed = dir.trim().to_owned()
  if trimmed.length() == 0 {
    name
  } else if ends_with_separator(trimmed) {
    "\{trimmed}\{name}"
  } else {
    "\{trimmed}/\{name}"
  }
}

///|
fn ends_with_separator(path : String) -> Bool {
  if path.length() == 0 {
    false
  } else {
    let ch = path[path.length() - 1].to_int().unsafe_to_char()
    ch == '/' || ch == '\\'
  }
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
async fn run_export(request : CliRequest) -> Unit {
  let options = render_options(request)
  let markdown = @fs.read_file(request.input_path).text()
  let rendered = match request.output_format {
    "svg" => @renderer.render_markdown_svg(markdown, options~)
    "html" =>
      render_html_document(@renderer.render_markdown_html(markdown, options~))
    format => fail("Unsupported output format: \{format}")
  }
  @fs.mkdir(request.output_dir, recursive=true) catch {
    _ => ()
  }
  let path = output_path(request)
  @fs.write_file(path, rendered)
  println("Exported \{request.output_format}: \{path}")
}

///|
fn render_html_document(body : String) -> String {
  let out = StringBuilder()
  out.write_string("<!doctype html><html lang=\"en\"><head>")
  out.write_string("<meta charset=\"utf-8\">")
  out.write_string(
    "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">",
  )
  out.write_string("<title>MoonMarkMind Export</title>")
  out.write_string("</head><body>")
  out.write_string(body)
  out.write_string("</body></html>")
  out.to_string()
}

///|
pub async fn run() -> Unit {
  let request = parse_request(@env.args()) catch {
    e => {
      println("Error parsing arguments: \{e}")
      @sys.exit(1)
      return
    }
  }
  run_export(request) catch {
    e => {
      println("Failed to export mind map: \{e}")
      @sys.exit(1)
    }
  }
}

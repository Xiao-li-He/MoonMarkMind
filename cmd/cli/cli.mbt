///|
priv struct CliRequest {
  input_path : String
  output_format : String
  layout : String
  style : String
  layer : String
  output_path : String
  browser_path : String
}

///|
fn command() -> @argparse.Command {
  @argparse.Command(
    "moonmarkmind",
    about="Export one Markdown outline through the MoonMarkMind browser renderer",
    arg_required_else_help=true,
    options=[
      @argparse.OptionArg(
        "format",
        short='f',
        long="format",
        about="Output format: png, svg, or html (default: png)",
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
        "output",
        short='o',
        long="output",
        about="Output file path (default: output/<input>.<format>)",
      ),
      @argparse.OptionArg(
        "browser",
        long="browser",
        about="Chrome or Edge executable path",
      ),
    ],
    positionals=[@argparse.PositionArg("input", about="Markdown file path")],
  )
}

///|
fn parse_request(argv : Array[String]) -> CliRequest raise {
  let matches = @argparse.parse(command(), argv=normalize_argv(argv))
  let input_path = required_arg(matches, "input")
  let requested_format = optional_arg_value(matches, "format")
  let requested_output = optional_arg_value(matches, "output")
  let output_format = resolve_output_format(requested_format, requested_output)
  {
    input_path,
    output_format,
    layout: validate_layout(optional_arg(matches, "layout", "logic")),
    style: validate_style(optional_arg(matches, "style", "full")),
    layer: validate_layer(optional_arg(matches, "layer", "full")),
    output_path: resolve_output_path(
      input_path, output_format, requested_output,
    ),
    browser_path: optional_arg(matches, "browser", ""),
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
    Some([value]) => value
    _ => fail("Missing required argument: \{key}")
  }
}

///|
fn optional_arg_value(matches : @argparse.Matches, key : String) -> String? {
  match matches.values.get(key) {
    Some([value]) => Some(value)
    _ => None
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
  let format = value.trim().to_lower().to_owned()
  match format {
    "png" | "svg" | "html" => format
    _ => fail("Unsupported output format: \{value}; expected png, svg, or html")
  }
}

///|
fn resolve_output_format(format : String?, output : String?) -> String raise {
  let explicit = format.map(validate_output_format)
  let inferred = match output {
    Some(path) => output_format_from_path(path)
    None => None
  }
  match (explicit, inferred) {
    (Some(a), Some(b)) if a != b =>
      fail("Output format '\{a}' conflicts with output file extension '.\{b}'")
    (Some(value), _) | (_, Some(value)) => value
    _ => "png"
  }
}

///|
fn output_format_from_path(path : String) -> String? {
  let lower = path.trim().to_lower()
  if lower.has_suffix(".png") {
    Some("png")
  } else if lower.has_suffix(".svg") {
    Some("svg")
  } else if lower.has_suffix(".html") {
    Some("html")
  } else {
    None
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
fn validate_input(input : String) -> Unit raise {
  let stat = @node_fs.statSync(input) catch {
    _ => fail("Input is not a Markdown file: \{input}")
  }
  if stat.isDirectory() {
    fail("Directory input is not supported: \{input}")
  }
  if !stat.isFile() {
    fail("Input is not a Markdown file: \{input}")
  }
  if !is_markdown_path(input) {
    fail("Input file is not Markdown: \{input}")
  }
}

///|
fn is_markdown_path(path : String) -> Bool {
  path.to_lower().has_suffix(".md")
}

///|
fn resolve_output_path(
  input : String,
  format : String,
  output : String?,
) -> String {
  output.unwrap_or_else(fn() {
    join_path("output", "\{file_stem(input)}.\{format}")
  })
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
  validate_input(request.input_path)
  @node.init_esm_require().wait()
  ensure_output_parent(request.output_path)
  ensure_web_bundle(".")
  let browser = find_browser_executable(request.browser_path)
  let markdown = @node_fs.read_file_as_string(request.input_path)
  export_with_browser(
    "web",
    browser,
    markdown,
    request.layout,
    request.style,
    request.layer,
    request.output_format,
    request.output_path,
  )
  println("Exported \{request.output_format}: \{request.output_path}")
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

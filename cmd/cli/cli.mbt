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
async fn validate_input(input : String) -> Unit {
  match @fs.kind(input) {
    @fs.FileKind::Regular =>
      if !is_markdown_path(input) {
        fail("Input file is not Markdown: \{input}")
      }
    @fs.FileKind::Directory =>
      fail("Directory input is not supported: \{input}")
    _ => fail("Input is not a Markdown file: \{input}")
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
  ensure_output_parent(request.output_path)
  ensure_web_bundle(".")
  let browser = find_browser_executable(request.browser_path)
  let markdown = @fs.read_file(request.input_path).text()
  let export_error = export_with_browser(
    "web",
    browser,
    markdown,
    request.layout,
    request.style,
    request.layer,
    request.output_format,
    request.output_path,
  ).wait()
  if export_error.length() > 0 {
    fail(export_error)
  }
  println("Exported \{request.output_format}: \{request.output_path}")
}

///|
extern "js" fn ensure_output_parent(output_path : String) -> Unit =
  #| (outputPath) => {
  #|   const fs = require("node:fs");
  #|   const path = require("node:path");
  #|   const parent = path.dirname(path.resolve(outputPath));
  #|   fs.mkdirSync(parent, { recursive: true });
  #| }

///|
extern "js" fn ensure_web_bundle(root : String) -> Unit =
  #| (root) => {
  #|   const fs = require("node:fs");
  #|   const path = require("node:path");
  #|   const childProcess = require("node:child_process");
  #|   const bundle = path.join(root, "web", "main.bundle.js");
  #|   const script = path.join(root, "build-web.ps1");
  #|   if (fs.existsSync(bundle)) return;
  #|   const candidates = process.platform === "win32" ? ["powershell", "pwsh"] : ["pwsh"];
  #|   let last = "";
  #|   for (const shell of candidates) {
  #|     const result = childProcess.spawnSync(
  #|       shell,
  #|       ["-ExecutionPolicy", "Bypass", "-File", script, "-NoServe", "-NoOpenBrowser"],
  #|       { cwd: root, encoding: "utf8" },
  #|     );
  #|     if (result.status === 0) return;
  #|     last = `${shell}: ${result.stderr || result.stdout || result.error || ""}`;
  #|   }
  #|   throw new Error(`Failed to build web bundle. ${last}`);
  #| }

///|
extern "js" fn find_browser_executable(preferred : String) -> String =
  #| (preferred) => {
  #|   const fs = require("node:fs");
  #|   const childProcess = require("node:child_process");
  #|   if (preferred && fs.existsSync(preferred)) return preferred;
  #|   const names = process.platform === "win32"
  #|     ? [
  #|         process.env.LOCALAPPDATA && `${process.env.LOCALAPPDATA}\\Google\\Chrome\\Application\\chrome.exe`,
  #|         process.env.PROGRAMFILES && `${process.env.PROGRAMFILES}\\Google\\Chrome\\Application\\chrome.exe`,
  #|         process.env["PROGRAMFILES(X86)"] && `${process.env["PROGRAMFILES(X86)"]}\\Google\\Chrome\\Application\\chrome.exe`,
  #|         process.env.PROGRAMFILES && `${process.env.PROGRAMFILES}\\Microsoft\\Edge\\Application\\msedge.exe`,
  #|         process.env["PROGRAMFILES(X86)"] && `${process.env["PROGRAMFILES(X86)"]}\\Microsoft\\Edge\\Application\\msedge.exe`,
  #|         "chrome.exe",
  #|         "msedge.exe",
  #|       ]
  #|     : ["google-chrome", "chrome", "chromium", "chromium-browser", "microsoft-edge", "msedge"];
  #|   for (const name of names.filter(Boolean)) {
  #|     if (fs.existsSync(name)) return name;
  #|     const probe = childProcess.spawnSync(name, ["--version"], { encoding: "utf8" });
  #|     if (probe.status === 0) return name;
  #|   }
  #|   if (preferred) {
  #|     throw new Error(`Browser executable not found: ${preferred}`);
  #|   }
  #|   throw new Error("Chrome or Edge executable not found. Pass --browser <path>.");
  #| }

///|
extern "js" fn export_with_browser(
  web_dir : String,
  browser_path : String,
  markdown : String,
  layout : String,
  style : String,
  layer : String,
  format : String,
  output_path : String,
) -> @core.Promise[String] =
  #| async (webDir, browserPath, markdown, layout, style, layer, format, outputPath) => {
  #|   const fs = require("node:fs");
  #|   const path = require("node:path");
  #|   const os = require("node:os");
  #|   const http = require("node:http");
  #|   const childProcess = require("node:child_process");
  #|   try {
  #|   if (typeof WebSocket === "undefined") {
  #|     throw new Error("Node.js WebSocket support is required for browser export.");
  #|   }
  #|   const absoluteWebDir = path.resolve(webDir);
  #|   const contentTypes = new Map([
  #|     [".html", "text/html; charset=utf-8"],
  #|     [".js", "text/javascript; charset=utf-8"],
  #|     [".css", "text/css; charset=utf-8"],
  #|     [".png", "image/png"],
  #|     [".md", "text/markdown; charset=utf-8"],
  #|   ]);
  #|   const server = http.createServer((req, res) => {
  #|     const url = new URL(req.url || "/", "http://127.0.0.1");
  #|     const requested = decodeURIComponent(url.pathname === "/" ? "/index.html" : url.pathname);
  #|     const file = path.resolve(absoluteWebDir, `.${requested}`);
  #|     if (!file.startsWith(absoluteWebDir)) {
  #|       res.writeHead(403);
  #|       res.end("Forbidden");
  #|       return;
  #|     }
  #|     fs.readFile(file, (err, data) => {
  #|       if (err) {
  #|         res.writeHead(404);
  #|         res.end("Not found");
  #|         return;
  #|       }
  #|       res.writeHead(200, { "Content-Type": contentTypes.get(path.extname(file)) || "application/octet-stream" });
  #|       res.end(data);
  #|     });
  #|   });
  #|   await new Promise((resolve, reject) => {
  #|     server.once("error", reject);
  #|     server.listen(0, "127.0.0.1", resolve);
  #|   });
  #|   const serverPort = server.address().port;
  #|   const debugPort = 40000 + Math.floor(Math.random() * 20000);
  #|   const userDataDir = fs.mkdtempSync(path.join(os.tmpdir(), "moonmarkmind-cli-"));
  #|   const browser = childProcess.spawn(browserPath, [
  #|     "--headless=new",
  #|     "--disable-gpu",
  #|     "--no-first-run",
  #|     "--no-default-browser-check",
  #|     `--user-data-dir=${userDataDir}`,
  #|     `--remote-debugging-port=${debugPort}`,
  #|     "about:blank",
  #|   ], { stdio: "ignore" });
  #|   const closeAll = async () => {
  #|     try { browser.kill(); } catch (_) {}
  #|     try { server.close(); } catch (_) {}
  #|     try { fs.rmSync(userDataDir, { recursive: true, force: true }); } catch (_) {}
  #|   };
  #|   try {
  #|     await waitForJson(`http://127.0.0.1:${debugPort}/json/version`, 8000);
  #|     const targets = await waitForJson(`http://127.0.0.1:${debugPort}/json/list`, 8000);
  #|     const pageTarget = targets.find((target) => target.type === "page" && target.webSocketDebuggerUrl);
  #|     if (!pageTarget) throw new Error("Browser did not expose a debuggable page target");
  #|     const ws = await openWebSocket(pageTarget.webSocketDebuggerUrl);
  #|     let nextId = 1;
  #|     const pending = new Map();
  #|     const listeners = [];
  #|     ws.addEventListener("message", async (event) => {
  #|       const raw = typeof event.data === "string"
  #|         ? event.data
  #|         : event.data && typeof event.data.text === "function"
  #|           ? await event.data.text()
  #|           : Buffer.from(event.data).toString("utf8");
  #|       const msg = JSON.parse(raw);
  #|       if (msg.id && pending.has(msg.id)) {
  #|         const { resolve, reject, timer } = pending.get(msg.id);
  #|         clearTimeout(timer);
  #|         pending.delete(msg.id);
  #|         msg.error ? reject(new Error(JSON.stringify(msg.error))) : resolve(msg.result || {});
  #|       }
  #|       for (const listener of listeners) listener(msg);
  #|     });
  #|     const send = (method, params = {}, sessionId = undefined) => new Promise((resolve, reject) => {
  #|       const id = nextId++;
  #|       const timer = setTimeout(() => {
  #|         pending.delete(id);
  #|         reject(new Error(`Timed out waiting for CDP method ${method}`));
  #|       }, 15000);
  #|       pending.set(id, { resolve, reject, timer });
  #|       ws.send(JSON.stringify(sessionId ? { id, method, params, sessionId } : { id, method, params }));
  #|     });
  #|     const sessionId = undefined;
  #|     await send("Page.navigate", { url: `http://127.0.0.1:${serverPort}/index.html` }, sessionId);
  #|     await waitForExportApi(send, sessionId, 10000);
  #|     const args = [markdown, layout, style, layer].map(JSON.stringify).join(",");
  #|     const method = format === "png"
  #|       ? "exportMindmapPngDataUrl"
  #|       : format === "svg"
  #|         ? "exportMindmapSvg"
  #|         : "exportMindmapHtml";
  #|     const value = await evaluate(send, sessionId, `globalThis.MoonMarkMind.${method}(${args})`);
  #|     if (format === "png") {
  #|       const marker = "base64,";
  #|       const index = value.indexOf(marker);
  #|       if (!value.startsWith("data:image/png") || index < 0) {
  #|         throw new Error("Browser did not return a PNG data URL");
  #|       }
  #|       fs.writeFileSync(outputPath, Buffer.from(value.slice(index + marker.length), "base64"));
  #|     } else {
  #|       fs.writeFileSync(outputPath, value, "utf8");
  #|     }
  #|     try { await send("Browser.close"); } catch (_) {}
  #|     try { ws.close(); } catch (_) {}
  #|   } finally {
  #|     await closeAll();
  #|   }
  #|   async function waitForJson(url, timeoutMs) {
  #|     const started = Date.now();
  #|     while (Date.now() - started < timeoutMs) {
  #|       try {
  #|         const response = await fetch(url);
  #|         if (response.ok) return await response.json();
  #|       } catch (_) {}
  #|       await new Promise((resolve) => setTimeout(resolve, 100));
  #|     }
  #|     throw new Error("Timed out waiting for browser debugging endpoint");
  #|   }
  #|   function openWebSocket(url) {
  #|     return new Promise((resolve, reject) => {
  #|       const ws = new WebSocket(url);
  #|       ws.addEventListener("open", () => resolve(ws), { once: true });
  #|       ws.addEventListener("error", reject, { once: true });
  #|     });
  #|   }
  #|   async function waitForExportApi(send, sessionId, timeoutMs) {
  #|     const started = Date.now();
  #|     while (Date.now() - started < timeoutMs) {
  #|       const result = await send("Runtime.evaluate", {
  #|         expression: "Boolean(document.readyState !== 'loading' && globalThis.MoonMarkMind && globalThis.MoonMarkMind.exportMindmapHtml)",
  #|         returnByValue: true,
  #|       }, sessionId);
  #|       if (result.result && result.result.value === true) return;
  #|       await new Promise((resolve) => setTimeout(resolve, 100));
  #|     }
  #|     throw new Error("MoonMarkMind export API did not become ready");
  #|   }
  #|   async function evaluate(send, sessionId, expression) {
  #|     const result = await send("Runtime.evaluate", {
  #|       expression,
  #|       awaitPromise: true,
  #|       returnByValue: true,
  #|     }, sessionId);
  #|     if (result.exceptionDetails) {
  #|       const details = result.exceptionDetails;
  #|       const description = details.exception && details.exception.description;
  #|       const frames = details.stackTrace && details.stackTrace.callFrames;
  #|       const stack = Array.isArray(frames)
  #|         ? frames.map((frame) => `    at ${frame.functionName || "<anonymous>"} (${frame.url}:${frame.lineNumber + 1}:${frame.columnNumber + 1})`).join("\n")
  #|         : "";
  #|       throw new Error([description || details.text || "Browser evaluation failed", stack].filter(Boolean).join("\n"));
  #|     }
  #|     return result.result ? result.result.value || "" : "";
  #|   }
  #|   return "";
  #|   } catch (error) {
  #|     return error && error.stack ? String(error.stack) : String(error);
  #|   }
  #| }

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

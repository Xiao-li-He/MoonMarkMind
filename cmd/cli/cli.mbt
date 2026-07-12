///|
priv struct CliRequest {
  input_paths : Array[String]
  output_formats : Array[String]
  layout : String
  style : String
  layer : String
  output_dir : String
  browser_path : String
}

///|
priv struct ExportInput {
  path : String
  stem : String
}

///|
fn command() -> @argparse.Command {
  @argparse.Command(
    "moonmarkmind",
    about="Batch export Markdown outlines through the MoonMarkMind browser renderer",
    arg_required_else_help=true,
    options=[
      @argparse.OptionArg(
        "output",
        long="output",
        about="Output formats: png, svg, html, or comma-separated values",
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
      @argparse.OptionArg(
        "browser",
        long="browser",
        about="Chrome or Edge executable path",
      ),
    ],
    positionals=[
      @argparse.PositionArg(
        "input",
        about="Markdown file path or directory",
        num_args=@argparse.ValueRange(lower=1),
      ),
    ],
  )
}

///|
fn parse_request(argv : Array[String]) -> CliRequest raise {
  let matches = @argparse.parse(command(), argv=normalize_argv(argv))
  {
    input_paths: required_args(matches, "input"),
    output_formats: validate_output_formats(
      optional_arg(matches, "output", "png,svg,html"),
    ),
    layout: validate_layout(optional_arg(matches, "layout", "logic")),
    style: validate_style(optional_arg(matches, "style", "full")),
    layer: validate_layer(optional_arg(matches, "layer", "full")),
    output_dir: optional_arg(matches, "output-dir", "output"),
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
fn required_args(matches : @argparse.Matches, key : String) -> Array[String] raise {
  match matches.values.get(key) {
    Some(values) if values.length() > 0 => values
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
fn validate_output_formats(value : String) -> Array[String] raise {
  let formats = []
  for raw in value.split(",".view()) {
    let format = raw.trim().to_owned()
    if format.length() > 0 {
      match format {
        "png" | "svg" | "html" => ()
        _ => fail("Unsupported output format: \{format}")
      }
      if !formats.contains(format) {
        formats.push(format)
      }
    }
  }
  if formats.length() == 0 {
    fail("At least one output format is required")
  }
  formats
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
async fn expand_inputs(input_paths : Array[String]) -> Array[ExportInput] raise {
  let inputs = []
  for input in input_paths {
    match @fs.kind(input) {
      @fs.FileKind::Regular => {
        if is_markdown_path(input) {
          inputs.push(ExportInput::{ path: input, stem: file_stem(input) })
        } else {
          fail("Input file is not Markdown: \{input}")
        }
      }
      @fs.FileKind::Directory => {
        let entries = @fs.readdir(input, sort=true)
        for entry in entries {
          if is_markdown_path(entry) {
            let path = join_path(input, entry)
            match @fs.kind(path) {
              @fs.FileKind::Regular =>
                inputs.push(ExportInput::{ path, stem: file_stem(entry) })
              _ => ()
            }
          }
        }
      }
      _ => fail("Input is not a Markdown file or directory: \{input}")
    }
  }
  if inputs.length() == 0 {
    fail("No Markdown files found")
  }
  ensure_unique_output_stems(inputs)
  inputs
}

///|
fn ensure_unique_output_stems(inputs : Array[ExportInput]) -> Unit raise {
  let seen : Map[String, String] = {}
  for input in inputs {
    match seen.get(input.stem) {
      Some(previous) =>
        fail(
          "Duplicate output stem '\{input.stem}' for \{previous} and \{input.path}",
        )
      None => seen[input.stem] = input.path
    }
  }
}

///|
fn is_markdown_path(path : String) -> Bool {
  path.to_lower().has_suffix(".md")
}

///|
fn output_path(output_dir : String, input : ExportInput, format : String) -> String {
  join_path(output_dir, "\{input.stem}.\{format}")
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
  let inputs = expand_inputs(request.input_paths)
  @fs.mkdir(request.output_dir, recursive=true) catch {
    _ => ()
  }
  ensure_web_bundle(".")
  let browser = find_browser_executable(request.browser_path)
  for input in inputs {
    let markdown = @fs.read_file(input.path).text()
    for format in request.output_formats {
      let path = output_path(request.output_dir, input, format)
      export_with_browser(
        "web",
        browser,
        markdown,
        request.layout,
        request.style,
        request.layer,
        format,
        path,
      ).wait()
      println("Exported \{format}: \{path}")
    }
  }
}

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
) -> @core.Promise[Unit] =
  #| async (webDir, browserPath, markdown, layout, style, layer, format, outputPath) => {
  #|   const fs = require("node:fs");
  #|   const path = require("node:path");
  #|   const os = require("node:os");
  #|   const http = require("node:http");
  #|   const childProcess = require("node:child_process");
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
  #|     const version = await waitForJson(`http://127.0.0.1:${debugPort}/json/version`, 8000);
  #|     const ws = await openWebSocket(version.webSocketDebuggerUrl);
  #|     let nextId = 1;
  #|     const pending = new Map();
  #|     const listeners = [];
  #|     ws.addEventListener("message", (event) => {
  #|       const msg = JSON.parse(String(event.data));
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
  #|       }, 10000);
  #|       pending.set(id, { resolve, reject, timer });
  #|       ws.send(JSON.stringify(sessionId ? { id, method, params, sessionId } : { id, method, params }));
  #|     });
  #|     const created = await send("Target.createTarget", { url: "about:blank" });
  #|     const attached = await send("Target.attachToTarget", { targetId: created.targetId, flatten: true });
  #|     const sessionId = attached.sessionId;
  #|     await send("Page.enable", {}, sessionId);
  #|     await send("Runtime.enable", {}, sessionId);
  #|     await send("Page.navigate", { url: `http://127.0.0.1:${serverPort}/index.html` }, sessionId);
  #|     await evaluate(send, sessionId, `
  #|       (async () => {
  #|         for (let i = 0; i < 200; i++) {
  #|           if (document.readyState !== "loading" &&
  #|               globalThis.MoonMarkMind &&
  #|               globalThis.MoonMarkMind.exportMindmapHtml) return true;
  #|           await new Promise((resolve) => setTimeout(resolve, 50));
  #|         }
  #|         throw new Error("MoonMarkMind export API did not become ready");
  #|       })()
  #|     `);
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
  #|   async function evaluate(send, sessionId, expression) {
  #|     const result = await send("Runtime.evaluate", {
  #|       expression,
  #|       awaitPromise: true,
  #|       returnByValue: true,
  #|     }, sessionId);
  #|     if (result.exceptionDetails) {
  #|       throw new Error(result.exceptionDetails.text || "Browser evaluation failed");
  #|     }
  #|     return result.result ? result.result.value || "" : "";
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

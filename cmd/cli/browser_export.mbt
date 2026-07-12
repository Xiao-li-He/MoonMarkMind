///|
priv struct StaticServer {
  server : @http.Server
  port : Int
}

///|
priv struct BrowserRuntime {
  process : @child_process.ChildProcess
  user_data_dir : String
  debug_port : Int
}

///|
priv struct CdpClient {
  socket : @websocket.WebSocket
  responses : Map[Int, @core.Any]
  mut next_id : Int
}

///|
async fn export_with_browser(
  web_dir : String,
  browser_path : String,
  markdown : String,
  layout : String,
  style : String,
  layer : String,
  format : String,
  output_path : String,
) -> Unit {
  perform_browser_export(
    web_dir, browser_path, markdown, layout, style, layer, format, output_path,
  )
}

///|
async fn perform_browser_export(
  web_dir : String,
  browser_path : String,
  markdown : String,
  layout : String,
  style : String,
  layer : String,
  format : String,
  output_path : String,
) -> Unit {
  let server = start_static_server(web_dir)
  let browser = start_browser(browser_path)
  try {
    let websocket_url = wait_for_page_websocket(browser.debug_port)
    let client = open_cdp_client(websocket_url)
    try {
      ignore(client.send(
        "Page.navigate",
        @core.from_entries([
          (
            "url",
            @core.any("http://127.0.0.1:\{server.port}/index.html"),
          ),
        ]),
      ))
      wait_for_export_api(client)
      let export_method = match format {
        "png" => "exportMindmapPngDataUrl"
        "svg" => "exportMindmapSvg"
        _ => "exportMindmapHtml"
      }
      let args = [markdown, layout, style, layer]
        .map(fn(value) { @core.json_stringify(@core.any(value)) })
        .join(",")
      let value = client.evaluate(
        "globalThis.MoonMarkMind.\{export_method}(\{args})",
        await_promise=true,
      )
      write_export_output(format, output_path, value)
      client.close()
    } catch {
      error => {
        client.close()
        fail("Browser export failed: \{error}")
      }
    }
    cleanup_runtime(browser, server)
  } catch {
    error => {
      cleanup_runtime(browser, server)
      fail("Browser runtime failed: \{error}")
    }
  }
}

///|
async fn start_static_server(web_dir : String) -> StaticServer {
  let root = node_path_resolve([web_dir])
  let server = @http.createServer(requestListener=fn(request, response) {
    let raw_url = request.url.unwrap_or("/")
    let pathname = match raw_url.find("?") {
      Some(index) => raw_url[:index].to_owned()
      None => raw_url
    }
    let relative = if pathname == "/" {
      "index.html"
    } else {
      pathname.trim_start(chars=['/']).to_owned()
    }
    let file = node_path_resolve([root, relative])
    let rel = @path.relative(root, file)
    if rel.has_prefix("..") || @path.isAbsolute(rel) {
      response.writeHead(403) |> ignore
      response.end(data="Forbidden")
      return
    }
    try @node_fs.read_file_sync(file) catch {
      _ => {
        response.writeHead(404) |> ignore
        response.end(data="Not found")
      }
    } noraise {
      data => {
        response.setHeader("Content-Type", content_type(file))
        response.as_writable().end(chunk=data.as_any()) |> ignore
      }
    }
  })
  server.listen(0, host="127.0.0.1") |> ignore
  for _ in 0..<100 {
    if server.listening() {
      break
    }
    @core.sleep(10)
  }
  let address = server.address().unwrap_or_else(() => {
    fail("Static server did not expose an address")
  })
  { server, port: address.port() }
}

///|
fn content_type(path : String) -> String {
  match @path.extname(path).to_lower() {
    ".html" => "text/html; charset=utf-8"
    ".js" => "text/javascript; charset=utf-8"
    ".css" => "text/css; charset=utf-8"
    ".png" => "image/png"
    ".md" => "text/markdown; charset=utf-8"
    _ => "application/octet-stream"
  }
}

///|
fn unique_temp_dir() -> String raise {
  let timestamp = @core
    .global_this()
    ._get("Date")
    ._call("now", [])
    .to_string()
  let dir = node_path_join([@os.tmpdir(), "moonmarkmind-cli-\{timestamp}"])
  @node_fs.mkdirSync(dir, recursive=true)
  dir
}

///|
async fn start_browser(browser_path : String) -> BrowserRuntime {
  let user_data_dir = unique_temp_dir()
  let process = @child_process.spawn(
    browser_path,
    args=[
      "--headless=new",
      "--disable-gpu",
      "--no-first-run",
      "--no-default-browser-check",
      "--remote-debugging-port=0",
      "--user-data-dir=\{user_data_dir}",
      "about:blank",
    ],
  )
  let active_port_file = node_path_join([user_data_dir, "DevToolsActivePort"])
  let debug_port = wait_for_debug_port(active_port_file)
  { process, user_data_dir, debug_port }
}

///|
async fn wait_for_debug_port(path : String) -> Int {
  for _ in 0..<100 {
    if @node_fs.existsSync(path) {
      let lines = @node_fs.read_file_as_string(path).split("\n".view()).to_array()
      match lines.get(0) {
        Some(line) => return parse_decimal_int(line.to_owned())
        None => ()
      }
    }
    @core.sleep(100)
  }
  fail("Timed out waiting for browser debugging endpoint")
}

///|
async fn wait_for_page_websocket(debug_port : Int) -> String {
  let url = "http://127.0.0.1:\{debug_port}/json/list"
  for _ in 0..<100 {
    try @web_http.fetch(url, method_="GET") catch {
      _ => ()
    } noraise {
      response =>
        if response.ok {
          let targets = response.json()
          for target in @core.array_from(targets) {
            if any_string_field(target, "type") == "page" {
              let websocket_url = any_string_field(
                target, "webSocketDebuggerUrl",
              )
              if websocket_url.length() > 0 {
                return websocket_url
              }
            }
          }
        }
    }
    @core.sleep(100)
  }
  fail("Timed out waiting for a debuggable browser page")
}

///|
async fn open_cdp_client(url : String) -> CdpClient {
  let socket = @websocket.WebSocket::new(url)
  let responses : Map[Int, @core.Any] = {}
  socket.set_onmessage(fn(event) {
    let message = @core.json_parse(@websocket.get_message_data(event))
    let id_value = message._get("id")
    if !@core.is_undefined(id_value) {
      let id : Int = id_value.cast()
      responses[id] = message
    }
  })
  for _ in 0..<100 {
    if socket.readyState == 1 {
      return { socket, responses, next_id: 1 }
    }
    if socket.readyState == 3 {
      fail("Browser debugging WebSocket closed before opening")
    }
    @core.sleep(100)
  }
  socket.close()
  fail("Timed out opening browser debugging WebSocket")
}

///|
async fn CdpClient::send(self : CdpClient, method_name : String, params : @core.Any) -> @core.Any {
  let id = self.next_id
  self.next_id += 1
  self.socket.send_string(
    @core.json_stringify(
      @core.from_entries([
        ("id", @core.any(id)),
        ("method", @core.any(method_name)),
        ("params", params),
      ]),
    ),
  )
  for _ in 0..<600 {
    match self.responses.get(id) {
      Some(message) => {
        self.responses.remove(id)
        let error = message._get("error")
        if !@core.is_undefined(error) {
          fail("CDP \{method_name} failed: \{@core.json_stringify(error)}")
        }
        return message._get("result")
      }
      None => @core.sleep(25)
    }
  }
  fail("Timed out waiting for CDP method \{method_name}")
}

///|
async fn CdpClient::evaluate(
  self : CdpClient,
  expression : String,
  await_promise~ : Bool,
) -> String {
  let result = self.send(
    "Runtime.evaluate",
    @core.from_entries([
      ("expression", @core.any(expression)),
      ("awaitPromise", @core.any(await_promise)),
      ("returnByValue", @core.any(true)),
    ]),
  )
  let exception = result._get("exceptionDetails")
  if !@core.is_undefined(exception) {
    let description = exception._get("exception")._get("description")
    if !@core.is_undefined(description) {
      fail(description.to_string())
    }
    fail("Browser evaluation failed: \{@core.json_stringify(exception)}")
  }
  let value = result._get("result")._get("value")
  if @core.is_undefined(value) {
    ""
  } else {
    value.to_string()
  }
}

///|
async fn wait_for_export_api(client : CdpClient) -> Unit {
  for _ in 0..<100 {
    let ready = client.evaluate(
      "Boolean(document.readyState !== 'loading' && globalThis.MoonMarkMind && globalThis.MoonMarkMind.exportMindmapHtml)",
      await_promise=false,
    )
    if ready == "true" {
      return
    }
    @core.sleep(100)
  }
  fail("MoonMarkMind export API did not become ready")
}

///|
fn any_string_field(value : @core.Any, field : String) -> String {
  let item = value._get(field)
  if @core.is_undefined(item) || @core.is_null(item) {
    ""
  } else {
    item.to_string()
  }
}

///|
fn write_export_output(format : String, output_path : String, value : String) -> Unit raise {
  if format == "png" {
    let encoded = png_base64_payload(value)
    let buffer = @buffer.Buffer::from_string(encoded, encoding="base64")
    @node_fs.writeFileSync(output_path, buffer.as_any())
  } else {
    let buffer = @buffer.Buffer::from_string(value, encoding="utf8")
    @node_fs.writeFileSync(output_path, buffer.as_any())
  }
}

///|
fn png_base64_payload(value : String) -> String raise {
  let marker = "base64,"
  match value.find(marker) {
    Some(index) if value.has_prefix("data:image/png") =>
      value[index + marker.length():].to_owned()
    _ => fail("Browser did not return a PNG data URL")
  }
}

///|
fn CdpClient::close(self : CdpClient) -> Unit {
  self.socket.close()
}

///|
fn cleanup_runtime(browser : BrowserRuntime, server : StaticServer) -> Unit {
  ignore(browser.process.kill())
  server.server.close() |> ignore
  try @node_fs.rmSync(
    browser.user_data_dir, recursive=true, force=true,
  ) catch {
    _ => ()
  } noraise {
    _ => ()
  }
}

///|
fn parse_decimal_int(text : String) -> Int raise {
  let trimmed = text.trim()
  if trimmed.length() == 0 {
    fail("Expected a decimal integer")
  }
  let mut value = 0
  for ch in trimmed {
    if ch < '0' || ch > '9' {
      fail("Invalid decimal integer: \{text}")
    }
    value = value * 10 + ch.to_int() - '0'.to_int()
  }
  value
}

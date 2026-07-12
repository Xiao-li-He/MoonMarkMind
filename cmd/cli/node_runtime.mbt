///|
fn ensure_output_parent(output_path : String) -> Unit raise {
  try {
    let parent = @path.dirname(node_path_resolve([output_path]))
    @node_fs.mkdirSync(parent, recursive=true)
  } catch {
    @core.ThrowError(error) =>
      fail("Failed to create output directory: \{error}")
  }
}

///|
fn ensure_web_bundle(root : String) -> Unit raise {
  let bundle = node_path_join([root, "web", "main.bundle.js"])
  if @node_fs.existsSync(bundle) {
    return
  }
  let script = node_path_join([root, "build-web.ps1"])
  let shells = if @os.platform() == "win32" {
    ["powershell", "pwsh"]
  } else {
    ["pwsh"]
  }
  let mut last_error = ""
  for shell in shells {
    try
      @child_process.spawnSync(
        shell,
        args=[
          "-ExecutionPolicy", "Bypass", "-File", script, "-NoServe", "-NoOpenBrowser",
        ],
        cwd=root,
        stdio="pipe",
      )
    catch {
      error => last_error = "Unable to start \{shell}: \{error}"
    } noraise {
      process =>
        if process.status() == Some(0) {
          return
        } else {
          last_error = "\{shell} exited with status \{to_repr(process.status())}"
        }
    }
  }
  fail("Failed to build web bundle: \{last_error}")
}

///|
fn find_browser_executable(preferred : String) -> String raise {
  if preferred.length() > 0 {
    if @node_fs.existsSync(preferred) {
      return preferred
    }
    fail("Browser executable not found: \{preferred}")
  }
  let env = @node.esm_require("node:process")._get("env")
  let candidates = if @os.platform() == "win32" {
    [
      env_value(env, "LOCALAPPDATA").map(fn(p) {
        node_path_join([p, "Google", "Chrome", "Application", "chrome.exe"])
      }),
      env_value(env, "PROGRAMFILES").map(fn(p) {
        node_path_join([p, "Google", "Chrome", "Application", "chrome.exe"])
      }),
      env_value(env, "PROGRAMFILES(X86)").map(fn(p) {
        node_path_join([p, "Google", "Chrome", "Application", "chrome.exe"])
      }),
      env_value(env, "PROGRAMFILES").map(fn(p) {
        node_path_join([p, "Microsoft", "Edge", "Application", "msedge.exe"])
      }),
      env_value(env, "PROGRAMFILES(X86)").map(fn(p) {
        node_path_join([p, "Microsoft", "Edge", "Application", "msedge.exe"])
      }),
      Some("chrome.exe"),
      Some("msedge.exe"),
    ]
  } else {
    [
      Some("google-chrome"),
      Some("chrome"),
      Some("chromium"),
      Some("chromium-browser"),
      Some("microsoft-edge"),
      Some("msedge"),
    ]
  }
  for candidate in candidates {
    match candidate {
      Some(name) if @node_fs.existsSync(name) => return name
      Some(name) =>
        try
          @child_process.spawnSync(name, args=["--version"], stdio="pipe")
        catch {
          _ => ()
        } noraise {
          result => if result.status() == Some(0) { return name }
        }
      None => ()
    }
  }
  fail("Chrome or Edge executable not found. Pass --browser <path>.")
}

///|
fn node_path_join(parts : Array[String]) -> String {
  @node.esm_require("node:path")
  ._call("join", parts.map(fn(part) { @core.any(part) }))
  .cast()
}

///|
fn node_path_resolve(parts : Array[String]) -> String {
  @node.esm_require("node:path")
  ._call("resolve", parts.map(fn(part) { @core.any(part) }))
  .cast()
}

///|
fn env_value(env : @core.Any, key : String) -> String? {
  let value = env._get(key)
  if @core.is_nullish(value) {
    None
  } else {
    Some(value.cast())
  }
}

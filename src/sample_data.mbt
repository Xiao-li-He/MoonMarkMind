///|
pub fn sample_markdown() -> String {
  (
    #|# MoonMarkMind Demo
    #|## Parser
    #|### Heading extraction
    #|### Level mapping
    #|## Renderer
    #|### Tree preview
    #|### Round-trip preview
    #|
  )
}

///|
fn rules_sample_markdown_path(sample_id : String) -> String {
  match sample_id {
    "part2" => "samples/example2.md"
    "part3" => "samples/example3.md"
    "part4" => "samples/example4.md"
    _ => "samples/example1.md"
  }
}

///|
fn rules_sample_fallback_markdown(sample_id : String) -> String {
  "# Sample failed to load\n\nMissing markdown asset: \{rules_sample_markdown_path(sample_id)}"
}

///|
fn cache_busted_markdown_path(path : String) -> String {
  let date = @global.global_this()._get("Date")
  let stamp = date._call("now", []).to_string()
  let separator = if path.contains("?".view()) { "&" } else { "?" }
  "\{path}\{separator}v=\{stamp}"
}

///|
fn fetch_markdown_asset(
  path : String,
  on_success : (String) -> Unit,
  on_error : () -> Unit,
) -> Unit {
  ignore(
    @core.Promise::new(async fn(resolve, _reject) {
      let response = @dom.window().fetch(cache_busted_markdown_path(path)) catch {
        _ => {
          on_error()
          resolve(())
          return
        }
      }
      if !response.ok {
        on_error()
        resolve(())
        return
      }
      let markdown = response.text() catch {
        _ => {
          on_error()
          resolve(())
          return
        }
      }
      on_success(markdown)
      resolve(())
    }),
  )
}

///|
fn load_rules_sample_markdown(
  sample_id : String,
  callback : (String) -> Unit,
) -> Unit {
  fetch_markdown_asset(rules_sample_markdown_path(sample_id), callback, fn() {
    callback(rules_sample_fallback_markdown(sample_id))
  })
}

///|
fn rules_sample_default_id() -> String {
  "part1"
}

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
extern "js" fn fetch_markdown_asset(
  path : String,
  on_success : (String) -> Unit,
  on_error : () -> Unit,
) -> Unit =
  #| (path, onSuccess, onError) => {
  #|   fetch(path)
  #|     .then((response) => {
  #|       if (!response.ok) {
  #|         throw new Error(`Failed to load ${path}`);
  #|       }
  #|       return response.text();
  #|     })
  #|     .then(onSuccess)
  #|     .catch(onError);
  #| }

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

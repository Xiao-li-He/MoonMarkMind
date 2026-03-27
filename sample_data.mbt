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
fn rules_test_markdown() -> String {
  let part1 = rules_test_markdown_part1()
  let part2 = rules_test_markdown_part2()
  let part3 = rules_test_markdown_part3()
  let part4 = rules_test_markdown_part4()
  "\{part1}\{part2}\{part3}\{part4}"
}

///|
fn rules_sample_markdown(sample_id : String) -> String {
  match sample_id {
    "part2" => rules_test_markdown_part2()
    "part3" => rules_test_markdown_part3()
    "part4" => rules_test_markdown_part4()
    "full" => rules_test_markdown()
    _ => rules_test_markdown_part1()
  }
}

///|
fn rules_sample_default_id() -> String {
  "part1"
}

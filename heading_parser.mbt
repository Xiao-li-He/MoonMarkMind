///|
pub fn parse_headings(markdown : String) -> Array[(Int, String)] {
  let headings = []
  let lines = markdown.split("\n").to_array()
  for line in lines {
    match parse_heading_line(line) {
      Some(heading) => headings.push(heading)
      None => ()
    }
  }
  headings
}

///|
fn parse_heading_line(line : StringView) -> (Int, String)? {
  if line.length() == 0 || line[0] != '#' {
    return None
  }
  lexmatch line {
    (("#+" as hashes) " " (".*" as title)) =>
      Some((hashes.length(), title.to_string()))
    _ => None
  }
}

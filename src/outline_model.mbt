///|
pub type DropPlacement = @outline_parser.DropPlacement

///|
pub type MoveNodeResult = @outline_parser.MoveNodeResult

///|
pub fn outline_json(markdown : String) -> String {
  @outline_parser.outline_json(markdown)
}

///|
pub fn rename_heading(
  markdown : String,
  flat_index : Int,
  title : String,
) -> String {
  @outline_parser.rename_heading(markdown, flat_index, title)
}

///|
fn update_node_body(
  markdown : String,
  flat_index : Int,
  body_text : String,
) -> String {
  @outline_parser.update_node_body(markdown, flat_index, body_text)
}

///|
fn update_node_body_block(
  markdown : String,
  flat_index : Int,
  block_index : Int,
  block_text : String,
) -> String {
  @outline_parser.update_node_body_block(
    markdown, flat_index, block_index, block_text,
  )
}

///|
fn delete_node_body_block(
  markdown : String,
  flat_index : Int,
  block_index : Int,
) -> String {
  @outline_parser.delete_node_body_block(markdown, flat_index, block_index)
}

///|
pub fn move_heading(
  markdown : String,
  from_flat_index : Int,
  to_flat_index : Int,
  place_after : Bool,
) -> String {
  @outline_parser.move_heading(
    markdown, from_flat_index, to_flat_index, place_after,
  )
}

///|
pub fn move_heading_prev(markdown : String, flat_index : Int) -> String {
  @outline_parser.move_heading_prev(markdown, flat_index)
}

///|
pub fn move_heading_next(markdown : String, flat_index : Int) -> String {
  @outline_parser.move_heading_next(markdown, flat_index)
}

///|
pub fn move_heading_prev_with_selection(
  markdown : String,
  flat_index : Int,
) -> (String, Int) {
  @outline_parser.move_heading_prev_with_selection(markdown, flat_index)
}

///|
pub fn move_heading_next_with_selection(
  markdown : String,
  flat_index : Int,
) -> (String, Int) {
  @outline_parser.move_heading_next_with_selection(markdown, flat_index)
}

///|
pub fn move_heading_among_siblings(
  markdown : String,
  flat_index : Int,
  move_down : Bool,
) -> String {
  @outline_parser.move_heading_among_siblings(markdown, flat_index, move_down)
}

///|
pub fn move_node_to_drop_placement(
  markdown : String,
  from_flat_index : Int,
  placement : DropPlacement,
) -> MoveNodeResult {
  @outline_parser.move_node_to_drop_placement(
    markdown, from_flat_index, placement,
  )
}

///|
pub fn indent_heading(markdown : String, flat_index : Int) -> String {
  @outline_parser.indent_heading(markdown, flat_index)
}

///|
pub fn promote_heading(markdown : String, flat_index : Int) -> String {
  @outline_parser.promote_heading(markdown, flat_index)
}

///|
pub fn add_child_heading(
  markdown : String,
  parent_flat_index : Int,
  title : String,
) -> String {
  @outline_parser.add_child_heading(markdown, parent_flat_index, title)
}

///|
pub fn add_sibling_heading(
  markdown : String,
  flat_index : Int,
  title : String,
  place_after : Bool,
) -> String {
  @outline_parser.add_sibling_heading(markdown, flat_index, title, place_after)
}

///|
pub fn delete_heading(markdown : String, flat_index : Int) -> String {
  @outline_parser.delete_heading(markdown, flat_index)
}

///|
fn render_markdown_nodes(nodes : Array[MarkdownNode]) -> String {
  @outline_parser.render_markdown_nodes(nodes)
}

///|
fn default_body_blank_lines(body : Array[String]) -> Array[Int] {
  @outline_parser.default_body_blank_lines(body)
}

///|
fn default_body_blank_line_count(index : Int) -> Int {
  if index == 0 {
    0
  } else {
    1
  }
}

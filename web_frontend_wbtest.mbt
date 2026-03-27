///|
test "outline selection lines track source lines exactly" {
  let markdown = "# Root\n\n- First\n  body\n## Second\n\n+ Third"
  let root = build_outline(markdown)
  inspect(source_line_for_flat_index(root, 0), content="0")
  inspect(source_line_for_flat_index(root, 1), content="2")
  inspect(source_line_for_flat_index(root, 2), content="4")
  inspect(source_line_for_flat_index(root, 3), content="6")
}

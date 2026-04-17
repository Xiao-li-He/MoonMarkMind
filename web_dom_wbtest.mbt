///|
test "wrapped logical line keeps second gutter row blank" {
  let metrics = InputLineMetrics::{
    heights: [56],
    tops: [18],
    line_height: 28,
    padding_top: 18,
  }
  let rows = gutter_visual_rows(metrics)
  assert_eq(rows.length(), 2)
  assert_eq(rows[0].line_number, 1)
  assert_eq(rows[0].height, 28)
  assert_eq(rows[0].show_number, true)
  assert_eq(rows[1].line_number, 1)
  assert_eq(rows[1].height, 28)
  assert_eq(rows[1].show_number, false)
}

///|
test "double-height logical line does not advance gutter to next line" {
  let metrics = InputLineMetrics::{
    heights: [56, 28],
    tops: [18, 74],
    line_height: 28,
    padding_top: 18,
  }
  let rows = gutter_visual_rows(metrics)
  assert_eq(rows.length(), 3)
  assert_eq(rows[0].line_number, 1)
  assert_eq(rows[0].show_number, true)
  assert_eq(rows[1].line_number, 1)
  assert_eq(rows[1].show_number, false)
  assert_eq(rows[2].line_number, 2)
  assert_eq(rows[2].show_number, true)
}

///|
test "triple wrapped logical line keeps continuation gutter rows blank" {
  let metrics = InputLineMetrics::{
    heights: [84],
    tops: [18],
    line_height: 28,
    padding_top: 18,
  }
  let rows = gutter_visual_rows(metrics)
  assert_eq(rows.length(), 3)
  assert_eq(rows[0].show_number, true)
  assert_eq(rows[1].show_number, false)
  assert_eq(rows[2].show_number, false)
  assert_eq(rows[0].height, 28)
  assert_eq(rows[1].height, 28)
  assert_eq(rows[2].height, 28)
}

///|
test "active span bounds cover full wrapped line range" {
  let metrics = InputLineMetrics::{
    heights: [56, 28, 84],
    tops: [18, 74, 102],
    line_height: 28,
    padding_top: 18,
  }
  match line_span_bounds(metrics, 0, 2, 12) {
    Some(bounds) => {
      assert_eq(bounds.top, 6)
      assert_eq(bounds.height, 168)
    }
    None => fail("expected active span bounds")
  }
}

///|
test "current mindmap render cycle helper reflects the stored cycle" {
  let previous = mindmap_render_cycle.val
  mindmap_render_cycle.val = 9
  assert_eq(current_mindmap_render_cycle(), 9)
  assert_eq(mindmap_render_cycle_matches(9), true)
  assert_eq(mindmap_render_cycle_matches(8), false)
  mindmap_render_cycle.val = previous
}

///|
test "hover line stays hidden when editor is inactive" {
  assert_eq(should_show_input_hover_line(3, true), true)
  assert_eq(should_show_input_hover_line(3, false), false)
  assert_eq(should_show_input_hover_line(-1, true), false)
}

///|
test "export runtime script is inline safe" {
  let script = build_export_runtime_script("console.log('</script><!--')")
  assert_eq(script.contains("src="), false)
  assert_eq(script.contains("<\\/script>"), true)
  assert_eq(script.contains("<\\!--"), true)
}

///|
test "selection index csv roundtrips collapsed note export state" {
  let serialized = ints_to_csv([1, 3, 8])
  assert_eq(serialized, "1,3,8")
  assert_eq(parse_selection_indices(serialized), [1, 3, 8])
}

///|
test "static export note title transform appends export shift once" {
  assert_eq(static_export_note_title_transform(""), "translateY(6px)")
  assert_eq(static_export_note_title_transform("none"), "translateY(6px)")
  assert_eq(
    static_export_note_title_transform("scale(1.1)"),
    "scale(1.1) translateY(6px)",
  )
  assert_eq(
    static_export_note_title_transform("translateY(4px)"),
    "translateY(4px)",
  )
}

///|
test "branch line connector extension preserves anchors" {
  assert_eq(branch_line_connector_extension_by_kind(center=false), 22.0)
  assert_eq(branch_line_connector_extension_by_kind(center=true), 30.0)
  assert_eq(path_direction(10.0), 1.0)
  assert_eq(path_direction(-10.0), -1.0)
  assert_eq(path_direction(0.0), 0.0)
  assert_eq(connector_layer_z_index(StageLayoutKind::Tree), "0")
  assert_eq(connector_layer_z_index(StageLayoutKind::Mindmap), "1")
  assert_eq(branch_line_stroke_width_by_kind(center=true, depth=0), 1.8)
  assert_eq(branch_line_stroke_width_by_kind(center=false, depth=1), 1.5)
  assert_eq(branch_line_stroke_width_by_kind(center=false, depth=2), 1.25)
}

///|
test "svg export void elements are xml self closing" {
  let source = "<svg><foreignObject><div><input class=\"markdown-task__check\" type=\"checkbox\"><span>Done</span><br></div></foreignObject></svg>"
  let fixed = close_svg_void_elements(source)

  assert_eq(
    fixed, "<svg><foreignObject><div><input class=\"markdown-task__check\" type=\"checkbox\" /><span>Done</span><br /></div></foreignObject></svg>",
  )
}

///|
test "svg export void element scanner preserves quoted greater-than signs" {
  let source = "<svg><foreignObject><img alt=\"a > b\"><span>x</span></foreignObject></svg>"

  assert_eq(
    close_svg_void_elements(source),
    "<svg><foreignObject><img alt=\"a > b\" /><span>x</span></foreignObject></svg>",
  )
}

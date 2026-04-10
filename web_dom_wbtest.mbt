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
  mindmap_render_cycle.val = previous
}

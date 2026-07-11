///|
/// Browser-side layout reflow for the rendered mind map.
///
/// These helpers schedule layout passes, apply tree/radial positioning, and
/// recover the viewport when reflow temporarily moves content offscreen.
fn schedule_render_mindmap_connectors() -> Unit {
  let window = @dom.window()
  let expected_cycle = current_mindmap_render_cycle()
  ignore(
    window.requestAnimationFrame(fn(_) {
      ignore(
        window.requestAnimationFrame(fn(_) {
          if !mindmap_render_cycle_matches(expected_cycle) {
            return
          }
          render_mindmap_connectors()
        }),
      )
    }),
  )
}

///|
let contour_layout_frame : @ref.Ref[Int] = @ref.Ref(0)

///|
let mindmap_render_cycle : @ref.Ref[Int] = @ref.Ref(0)

///|
fn current_mindmap_render_cycle() -> Int {
  mindmap_render_cycle.val
}

///|
fn mindmap_render_cycle_matches(expected_cycle : Int) -> Bool {
  expected_cycle == mindmap_render_cycle.val
}

///|
/// Schedule a browser-frame layout pass after the current render cycle.
///
/// The optional visibility recovery runs after layout so measurements reflect
/// the final DOM positions instead of a partially painted tree.
fn schedule_contour_layout(ensure_visible? : Bool = false) -> Unit {
  let window = @dom.window()
  mindmap_render_cycle.val += 1
  let expected_cycle = mindmap_render_cycle.val
  if contour_layout_frame.val != 0 {
    window.cancelAnimationFrame(contour_layout_frame.val)
  }
  contour_layout_frame.val = window.requestAnimationFrame(fn(_) {
    contour_layout_frame.val = 0
    if expected_cycle != mindmap_render_cycle.val {
      return
    }
    apply_contour_layout()
    ignore(
      window.requestAnimationFrame(fn(_) {
        if expected_cycle != mindmap_render_cycle.val {
          return
        }
        apply_contour_layout()
        if ensure_visible {
          ensure_mindmap_visible_after_layout(expected_cycle)
        }
        schedule_render_mindmap_connectors()
      }),
    )
  })
}

///|
fn ensure_mindmap_visible_after_layout(expected_cycle : Int) -> Unit {
  if !mindmap_render_cycle_matches(expected_cycle) {
    return
  }
  match get_element("#mindmap") {
    Some(mindmap) => {
      let frame = @ref.Ref(0)
      let window = @dom.window()
      mindmap_center_at_actual_size(
        mindmap,
        get_element("#zoom-value"),
        get_element("#zoom-edit"),
        frame,
        window,
      )
      mindmap_schedule_visibility_recovery(
        mindmap,
        get_element("#zoom-value"),
        get_element("#zoom-edit"),
        frame,
        window,
        expected_cycle,
      )
    }
    None => ()
  }
}

///|
/// Apply the active layout strategy to the current mindmap stage.
///
/// This is the runtime bridge between rendered static DOM and browser-measured
/// placement for contour, radial branch, and root-column layouts.
fn apply_contour_layout() -> Unit {
  match get_element("#mindmap") {
    Some(mindmap) =>
      match mindmap.querySelector(".mindmap-stage") {
        Some(stage) =>
          if has_class_name(stage, "mindmap-stage--radial") {
            apply_contour_min_heights(stage)
            apply_radial_branch_layout(stage)
          }
        None => ()
      }
    None => ()
  }
}

///|
fn apply_contour_min_heights(stage : @dom.Element) -> Unit {
  let nodes = stage.querySelectorAll("[data-node-index]")
  for element in nodes {
    if has_class_name(element, "node") {
      continue
    }
    if !has_class_name(element, "branch-item--root") {
      let style = @dom.css_style_from_val(element.as_any()._get("style").cast())
      style.set_property("min-height", "0")
      continue
    }
    let node_index = parse_int_or_default(
      element.getAttribute("data-node-index").unwrap_or("-1"),
      -1,
    )
    if node_index < 0 {
      continue
    }
    match find_node(app_state.root, node_index) {
      Some(node) => {
        let span = root_branch_span(node)
        let style = @dom.css_style_from_val(
          element.as_any()._get("style").cast(),
        )
        style.set_property("min-height", "\{span}px")
      }
      None => ()
    }
  }
}

///|
fn apply_radial_branch_layout(stage : @dom.Element) -> Unit {
  let zoom = match get_element("#mindmap") {
    Some(mindmap) =>
      parse_float(mindmap.getAttribute("data-zoom").unwrap_or("1"))
    None => 1.0
  }
  let safe_zoom = if zoom.is_nan() || zoom <= 0.0 { 1.0 } else { zoom }
  apply_radial_branch_layout_with_zoom(stage, safe_zoom)
}

///|
fn apply_radial_branch_layout_with_zoom(
  stage : @dom.Element,
  safe_zoom : Double,
) -> Unit {
  clear_radial_branch_transforms(stage)
  apply_root_column_packing(
    stage,
    stage.querySelector(".branch-column--left"),
    16,
    safe_zoom,
  )
  apply_root_column_packing(
    stage,
    stage.querySelector(".branch-column--right"),
    16,
    safe_zoom,
  )
  align_right_radial_single_child_chains(stage, safe_zoom)
}

///|
fn clear_radial_branch_transforms(stage : @dom.Element) -> Unit {
  for branch in stage.querySelectorAll(".branch-item") {
    let style = @dom.css_style_from_val(branch.as_any()._get("style").cast())
    style.set_property("transform", "none")
  }
}

///|
fn align_right_radial_single_child_chains(
  stage : @dom.Element,
  safe_zoom : Double,
) -> Unit {
  match stage.querySelector(".branch-column--right") {
    Some(right_column) =>
      for branch in right_column.querySelectorAll(".branch-item--root") {
        let node_index = parse_int_or_default(
          branch.getAttribute("data-node-index").unwrap_or("-1"),
          -1,
        )
        if node_index >= 0 {
          match find_node(app_state.root, node_index) {
            Some(node) => align_single_child_chain(stage, node, safe_zoom)
            None => ()
          }
        }
      }
    None => ()
  }
}

///|
fn align_single_child_chain(
  stage : @dom.Element,
  node : @outline_parser.OutlineNode,
  safe_zoom : Double,
) -> Unit {
  if !should_render_children(node) {
    return
  }
  let chain_length = single_child_chain_length(node)
  if chain_length > 1 {
    let child = node.children[0]
    match find_stage_card(stage, node.flat_index) {
      Some(parent_card) =>
        match find_stage_branch(stage, child.flat_index) {
          Some(child_branch) =>
            match find_stage_card(stage, child.flat_index) {
              Some(child_card) => {
                let parent_center_y = rect_center_y(element_rect(parent_card))
                let child_center_y = rect_center_y(element_rect(child_card))
                let local_delta = root_branch_local_translate_delta(
                  child_center_y, parent_center_y, safe_zoom,
                )
                if abs_double(local_delta) >= 0.5 {
                  let style = @dom.css_style_from_val(
                    child_branch.as_any()._get("style").cast(),
                  )
                  style.set_property(
                    "transform",
                    "translateY(\{local_delta}px)",
                  )
                }
              }
              None => ()
            }
          None => ()
        }
      None => ()
    }
  }
  for child in node.children {
    align_single_child_chain(stage, child, safe_zoom)
  }
}

///|
fn find_stage_card(stage : @dom.Element, node_index : Int) -> @dom.Element? {
  stage.querySelector(".node[data-node-index=\"\{node_index}\"]")
}

///|
fn find_stage_branch(stage : @dom.Element, node_index : Int) -> @dom.Element? {
  stage.querySelector(".branch-item[data-node-index=\"\{node_index}\"]")
}

///|
/// Pack root branches into columns while avoiding visible subtree collisions.
///
/// The calculation works in unscaled stage coordinates so zoom does not leak
/// into persisted node sizes or connector geometry.
fn apply_root_column_packing(
  stage : @dom.Element,
  column : @dom.Element?,
  gap : Int,
  safe_zoom : Double,
) -> Unit {
  match column {
    Some(root_column) => {
      let branches = root_column.querySelectorAll(".branch-item--root")
      if branches.length() == 0 {
        return
      }
      let card_top_radii = []
      let card_bottom_radii = []
      let branch_top_radii = []
      let branch_bottom_radii = []
      for branch in branches {
        let (_, card_top_radius, card_bottom_radius, card) = match
          root_branch_head_card(branch) {
          Some(card) => {
            let card_rect = element_rect(card)
            let card_height = unscaled_length_to_int(
              card_rect.height,
              safe_zoom,
            )
            (
              card_height,
              if card_height > 1 {
                card_height / 2
              } else {
                1
              },
              if card_height > 1 {
                card_height / 2
              } else {
                1
              },
              card,
            )
          }
          None => {
            let branch_rect = element_rect(branch)
            let branch_height = unscaled_length_to_int(
              branch_rect.height,
              safe_zoom,
            )
            (branch_height, branch_height / 2, branch_height / 2, branch)
          }
        }
        let fallback_top_radius = card_top_radius
        let fallback_bottom_radius = card_bottom_radius
        let (top_radius, bottom_radius) = root_branch_dom_radii(
          branch, card, fallback_top_radius, fallback_bottom_radius, safe_zoom,
        )
        card_top_radii.push(card_top_radius)
        card_bottom_radii.push(card_bottom_radius)
        branch_top_radii.push(top_radius)
        branch_bottom_radii.push(bottom_radius)
      }
      let adjusted = root_branch_sibling_group_centers(
        card_top_radii, card_bottom_radii, branch_top_radii, branch_bottom_radii,
        gap,
      )
      let root_center = match
        find_stage_card(stage, app_state.root.flat_index) {
        Some(root_card) => rect_center_y(element_rect(root_card))
        None => rect_center_y(element_rect(root_column))
      }
      for index in 0..<branches.length() {
        let branch = branches[index]
        let style = @dom.css_style_from_val(
          branch.as_any()._get("style").cast(),
        )
        match root_branch_head_card(branch) {
          Some(card) => {
            let current_center = rect_center_y(element_rect(card))
            let target_center = root_center +
              adjusted[index].to_double() * safe_zoom
            let local_delta = root_branch_local_translate_delta(
              current_center, target_center, safe_zoom,
            )
            style.set_property("transform", "translateY(\{local_delta}px)")
          }
          None => ()
        }
      }
    }
    None => ()
  }
}

///|
fn unscaled_length_to_int(value : Double, safe_zoom : Double) -> Int {
  let unscaled = value / safe_zoom
  if unscaled < 1.0 {
    1
  } else {
    unscaled.round().to_int()
  }
}

///|
fn root_branch_local_translate_delta(
  current_center : Double,
  target_center : Double,
  safe_zoom : Double,
) -> Double {
  let zoom = if safe_zoom.is_nan() || safe_zoom <= 0.0 {
    1.0
  } else {
    safe_zoom
  }
  (target_center - current_center) / zoom
}

///|
fn root_branch_head_card(branch : @dom.Element) -> @dom.Element? {
  for child in branch.children() {
    if has_class_name(child, "single-right-tree__head") {
      match child.querySelector(".node[data-node-index]") {
        Some(card) => return Some(card)
        None => ()
      }
    }
  }
  branch.querySelector(".node[data-node-index]")
}

///|
fn root_branch_dom_radii(
  branch : @dom.Element,
  card : @dom.Element,
  fallback_top_radius : Int,
  fallback_bottom_radius : Int,
  safe_zoom : Double,
) -> (Int, Int) {
  let card_center = rect_center_y(element_rect(card))
  let mut top_radius = fallback_top_radius
  let mut bottom_radius = fallback_bottom_radius
  for node_card in branch.querySelectorAll(".node[data-node-index]") {
    let rect = element_rect(node_card)
    let top = unscaled_length_to_int(card_center - rect.top, safe_zoom)
    let bottom = unscaled_length_to_int(rect.bottom - card_center, safe_zoom)
    if top > top_radius {
      top_radius = top
    }
    if bottom > bottom_radius {
      bottom_radius = bottom
    }
  }
  (top_radius, bottom_radius)
}

///|
fn root_branch_sibling_group_span(
  top_radii : Array[Int],
  bottom_radii : Array[Int],
  gap : Int,
) -> Int {
  if top_radii.length() == 0 || bottom_radii.length() == 0 {
    return 0
  }
  let safe_count = if top_radii.length() < bottom_radii.length() {
    top_radii.length()
  } else {
    bottom_radii.length()
  }
  let mut total = top_radii[0] + bottom_radii[safe_count - 1]
  for index in 1..<safe_count {
    total += bottom_radii[index - 1] + top_radii[index] + gap
  }
  total
}

///|
fn root_branch_sibling_group_centers(
  card_top_radii : Array[Int],
  card_bottom_radii : Array[Int],
  top_radii : Array[Int],
  bottom_radii : Array[Int],
  gap : Int,
) -> Array[Int] {
  let centers = root_branch_card_group_centers(
    card_top_radii, card_bottom_radii, gap,
  )
  root_branch_avoid_visible_subtree_collisions(
    centers, top_radii, bottom_radii, gap,
  )
}

///|
fn root_branch_card_group_centers(
  card_top_radii : Array[Int],
  card_bottom_radii : Array[Int],
  gap : Int,
) -> Array[Int] {
  let centers = []
  if card_top_radii.length() == 0 || card_bottom_radii.length() == 0 {
    return centers
  }
  let safe_count = if card_top_radii.length() < card_bottom_radii.length() {
    card_top_radii.length()
  } else {
    card_bottom_radii.length()
  }
  if safe_count == 1 {
    return [0]
  }
  let group_span = root_branch_sibling_group_span(
    card_top_radii, card_bottom_radii, gap,
  )
  let group_top = -group_span / 2
  centers.push(group_top + card_top_radii[0])
  for index in 1..<safe_count {
    let previous = centers[index - 1]
    centers.push(
      previous + card_bottom_radii[index - 1] + card_top_radii[index] + gap,
    )
  }
  centers
}

///|
fn root_branch_avoid_visible_subtree_collisions(
  centers : Array[Int],
  top_radii : Array[Int],
  bottom_radii : Array[Int],
  gap : Int,
) -> Array[Int] {
  if centers.length() == 0 {
    return []
  }
  let safe_count = if centers.length() < top_radii.length() {
    if centers.length() < bottom_radii.length() {
      centers.length()
    } else {
      bottom_radii.length()
    }
  } else if top_radii.length() < bottom_radii.length() {
    top_radii.length()
  } else {
    bottom_radii.length()
  }
  if safe_count == 0 {
    return []
  }
  let adjusted = []
  adjusted.push(centers[0])
  for index in 1..<safe_count {
    let previous = adjusted[index - 1]
    let minimum_center = previous +
      bottom_radii[index - 1] +
      top_radii[index] +
      gap
    if centers[index] < minimum_center {
      adjusted.push(minimum_center)
    } else {
      adjusted.push(centers[index])
    }
  }
  adjusted
}

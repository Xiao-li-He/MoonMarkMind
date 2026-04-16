///|
fn apply_page_theme() -> Unit {
  let html = @dom.document().documentElement()
  let html_style = style_of(html)
  html_style.set_property("min-height", "100%")
  html_style.set_property("background", "#edf6ff")
  match @dom.document().body() {
    Some(body) => {
      let style = style_of(body.as_element())
      style.set_property("margin", "0")
      style.set_property("min-height", "100%")
      style.set_property("overflow", "auto")
      style.set_property("color", "#23384d")
      style.set_property(
        "font-family", "\"Segoe UI\", \"PingFang SC\", \"Microsoft YaHei\", sans-serif",
      )
      style.set_property(
        "background", "radial-gradient(circle at 12% 16%, rgba(116, 226, 255, 0.58) 0%, rgba(116, 226, 255, 0.34) 16%, rgba(116, 226, 255, 0.08) 30%, transparent 42%), radial-gradient(circle at 86% 14%, rgba(140, 255, 206, 0.46) 0%, rgba(140, 255, 206, 0.24) 14%, rgba(140, 255, 206, 0.06) 28%, transparent 40%), linear-gradient(180deg, #f6fcff 0%, #edf6ff 52%, #eef6ff 100%)",
      )
    }
    None => ()
  }
  match get_element_by_id("app") {
    Some(app) => {
      let style = style_of(app)
      style.set_property("width", "100%")
      style.set_property("height", "100vh")
      style.set_property("box-sizing", "border-box")
      style.set_property("min-width", "812px")
      style.set_property("min-height", "540px")
      style.set_property("padding", "14px")
      style.set_property("overflow", "visible")
    }
    None => ()
  }
}

///|
fn apply_theme_to_element(element : @dom.Element) -> Unit {
  let tag = element.tagName()
  if tag == "TEXTAREA" {
    style_editor_textarea(element)
  } else if tag == "INPUT" && has_class_name(element, "zoom-edit") {
    style_zoom_edit(element)
  }

  if has_class_name(element, "app-shell") {
    style_app_shell(element)
  }
  if has_class_name(element, "topbar") {
    style_topbar(element)
  }
  if has_class_name(element, "workspace") {
    style_workspace(element)
  }
  if has_class_name(element, "workspace--dragging-divider") {
    style_workspace_dragging(element)
  }
  if has_class_name(element, "topbar-group") {
    style_topbar_group(element)
  }
  if has_class_name(element, "brand-title") {
    style_brand_title(element)
  }
  if has_class_name(element, "section-title") {
    style_section_title(element)
  }
  if has_class_name(element, "tool-button") ||
    has_class_name(element, "mindmap-tool") ||
    has_class_name(element, "mindmap-aux-button") ||
    has_class_name(element, "editor-chrome-action") ||
    has_class_name(element, "zoom-chip") {
    style_button_shell(element)
  }
  if has_class_name(element, "tool-button") {
    set_style(element, "min-width", "80px")
  }
  if has_class_name(element, "mindmap-tool") {
    style_mindmap_tool(element)
  }
  if has_class_name(element, "mindmap-aux-button") {
    style_mindmap_aux_button(element)
  }
  if has_class_name(element, "editor-chrome-action") {
    style_icon_button(element, "32px")
  }
  if has_class_name(element, "zoom-chip") {
    style_zoom_chip(element)
  }
  if has_class_name(element, "tool-icon") {
    style_tool_icon(element)
  }
  if has_class_name(element, "tool-icon--compact") {
    style_tool_icon_compact(element)
  }
  if has_class_name(element, "tool-select-wrap") {
    style_tool_select_wrap(element)
  }
  if has_class_name(element, "tool-select-label") {
    style_tool_select_label(element)
  }
  if has_class_name(element, "tool-select") {
    style_tool_select(element)
  }
  if has_class_name(element, "tool-select--native") {
    style_tool_select_native(element)
  }
  if has_class_name(element, "tool-select-custom") {
    style_tool_select_custom(element)
  }
  if has_class_name(element, "tool-select-trigger") {
    style_tool_select_trigger(element)
  }
  if has_class_name(element, "tool-select-menu") {
    style_tool_select_menu(element)
  }
  if has_class_name(element, "tool-select-option") {
    style_tool_select_option(element)
  }
  if has_class_name(element, "tool-select-option--selected") {
    style_tool_select_option_selected(element)
  }
  if has_class_name(element, "tool-select-trigger__label") {
    style_tool_select_trigger_label(element)
  }
  if has_class_name(element, "tool-select-trigger__arrow") {
    style_tool_select_trigger_arrow(element)
  }
  if has_class_name(element, "editor-panel") {
    style_editor_panel(element)
  }
  if has_class_name(element, "editor-surface") {
    style_editor_surface(element)
  }
  if has_class_name(element, "editor-chrome") {
    style_editor_chrome(element)
  }
  if has_class_name(element, "editor-chrome__lights") {
    style_row_center(element)
  }
  if has_class_name(element, "editor-chrome__light") {
    style_dot(element)
  }
  if has_class_name(element, "editor-chrome__light--red") {
    style_dot_red(element)
  }
  if has_class_name(element, "editor-chrome__light--yellow") {
    style_dot_yellow(element)
  }
  if has_class_name(element, "editor-chrome__light--green") {
    style_dot_green(element)
  }
  if has_class_name(element, "editor-chrome__title") {
    style_editor_title(element)
  }
  if has_class_name(element, "editor-chrome__actions") {
    style_row_center(element)
  }
  if has_class_name(element, "editor-chrome__badge") {
    style_badge(element)
  }
  if has_class_name(element, "editor-body") {
    style_editor_body(element)
  }
  if has_class_name(element, "editor-gutter-wrap") {
    style_editor_gutter_wrap(element)
  }
  if has_class_name(element, "editor-input-wrap") {
    style_editor_input_wrap(element)
  }
  if has_class_name(element, "editor-input-mirror") {
    style_editor_input_mirror(element)
  }
  if has_class_name(element, "editor-gutter-lines") ||
    has_class_name(element, "editor-linked-lines") {
    style_overlay_layer(element)
  }
  if has_class_name(element, "editor-gutter-line") ||
    has_class_name(element, "editor-linked-line") ||
    has_class_name(element, "editor-hover-line") ||
    has_class_name(element, "editor-active-line") {
    style_line_layer(element)
  }
  if has_class_name(element, "editor-linked-line") {
    style_editor_linked_line(element)
  }
  if has_class_name(element, "editor-hover-line") {
    style_editor_hover_line(element)
  }
  if has_class_name(element, "editor-active-line") {
    style_editor_active_line(element)
  }
  if has_class_name(element, "editor-gutter-line--linked") {
    style_editor_gutter_line_linked(element)
  }
  if has_class_name(element, "editor-gutter-line--hover") {
    style_editor_gutter_line_hover(element)
  }
  if has_class_name(element, "editor-gutter-line--active") {
    style_editor_gutter_line_active(element)
  }
  if has_class_name(element, "editor-gutter") {
    style_editor_gutter(element)
  }
  if has_class_name(element, "editor-gutter-number") {
    style_editor_gutter_number(element)
  }
  if has_class_name(element, "workspace-divider") {
    style_workspace_divider(element)
  }
  if has_class_name(element, "workspace-divider__track") {
    style_workspace_divider_track(element)
  }
  if has_class_name(element, "workspace-divider__handle") {
    style_workspace_divider_handle(element)
  }
  if has_class_name(element, "mindmap-panel") {
    style_mindmap_panel(element)
  }
  if has_class_name(element, "mindmap-toolbar") {
    style_mindmap_toolbar(element)
  }
  if has_class_name(element, "mindmap-toolbar__cluster") {
    style_mindmap_toolbar_cluster(element)
  }
  if has_class_name(element, "mindmap-toolbar__actions") {
    style_mindmap_toolbar_actions(element)
  }
  if has_class_name(element, "mindmap-toolbar__side") {
    style_mindmap_toolbar_side(element)
  }
  if has_class_name(element, "mindmap-side-tools") {
    style_mindmap_side_tools(element)
  }
  if has_class_name(element, "mindmap-zoom") {
    style_mindmap_zoom(element)
  }
  if has_class_name(element, "mindmap-canvas-shell") {
    style_mindmap_canvas_shell(element)
  }
  if has_class_name(element, "mindmap-surface") {
    style_mindmap_surface(element)
  }
  if has_class_name(element, "mindmap-connector-layer") {
    style_mindmap_connector_layer(element)
  }
  if has_class_name(element, "mindmap") {
    style_mindmap(element)
  }
  if has_class_name(element, "mindmap-content") {
    style_mindmap_content(element)
  }
  if has_class_name(element, "mindmap-stage") {
    style_mindmap_stage(element)
  }
  if has_class_name(element, "mindmap-stage--radial") {
    style_mindmap_stage_radial(element)
  }
  if has_class_name(element, "mindmap-stage--fill") {
    style_mindmap_stage_fill(element)
  }
  if has_class_name(element, "mindmap-stage--line") {
    style_mindmap_stage_line(element)
  }
  if has_class_name(element, "mindmap-stage--branch-line") {
    style_mindmap_stage_branch_line(element)
  }
  if has_class_name(element, "mindmap-stage--vertical") {
    style_mindmap_stage_vertical(element)
  }
  if has_class_name(element, "mindmap-stage--single-right") {
    style_mindmap_stage_single_right(element)
  }
  if has_class_name(element, "mindmap-stage--svg-connectors") {
    style_mindmap_stage_svg_connectors(element)
  }
  if has_class_name(element, "branch-column") ||
    has_class_name(element, "center-wrap") ||
    has_class_name(element, "branch-item") ||
    has_class_name(element, "branch-children") ||
    has_class_name(element, "vertical-root") ||
    has_class_name(element, "vertical-tree") ||
    has_class_name(element, "vertical-tree__children") ||
    has_class_name(element, "vertical-tree__child") ||
    has_class_name(element, "single-right-tree") ||
    has_class_name(element, "single-right-tree__node") ||
    has_class_name(element, "single-right-tree__head") ||
    has_class_name(element, "single-right-tree__children") {
    style_layout_block(element)
  }
  if has_class_name(element, "branch-column") {
    style_branch_column(element)
  }
  if has_class_name(element, "branch-column--root") {
    style_branch_column_root(element)
  }
  if has_class_name(element, "branch-column--left") {
    style_branch_column_left(element)
  }
  if has_class_name(element, "branch-column--right") {
    style_branch_column_right(element)
  }
  if has_class_name(element, "center-wrap") {
    style_center_wrap(element)
  }
  if has_class_name(element, "branch-item") {
    style_branch_item(element)
  }
  if has_class_name(element, "branch-item--root") {
    style_branch_item_root(element)
  }
  if has_class_name(element, "branch-item--left") {
    style_branch_item_left(element)
  }
  if has_class_name(element, "branch-item--right") {
    style_branch_item_right(element)
  }
  if has_class_name(element, "branch-item__row") {
    style_branch_item_row(element)
  }
  if has_class_name(element, "branch-item__head") {
    style_branch_item_head(element)
  }
  if has_class_name(element, "branch-children") {
    style_branch_children(element)
  }
  if has_class_name(element, "branch-children--left") {
    style_branch_children_left(element)
  }
  if has_class_name(element, "branch-children--right") {
    style_branch_children_right(element)
  }
  if has_class_name(element, "vertical-root") {
    style_vertical_root(element)
  }
  if has_class_name(element, "vertical-tree") {
    style_vertical_tree(element)
  }
  if has_class_name(element, "vertical-tree__children") {
    style_vertical_tree_children(element)
  }
  if has_class_name(element, "vertical-tree__child") {
    style_vertical_tree_child(element)
  }
  if has_class_name(element, "single-right-tree") {
    style_single_right_tree(element)
  }
  if has_class_name(element, "single-right-tree__node") {
    style_single_right_tree_node(element)
  }
  if has_class_name(element, "single-right-tree__node--left") {
    style_single_right_tree_node_left(element)
  }
  if has_class_name(element, "single-right-tree__node--right") {
    style_single_right_tree_node_right(element)
  }
  if has_class_name(element, "single-right-tree__head") {
    style_single_right_tree_head(element)
  }
  if has_class_name(element, "single-right-tree__children") {
    style_single_right_tree_children(element)
  }
  if has_class_name(element, "single-right-tree__children--left") {
    style_single_right_tree_children_left(element)
  }
  if has_class_name(element, "single-right-tree__children--right") {
    style_single_right_tree_children_right(element)
  }
  if has_class_name(element, "node") {
    style_node(element)
  }
  if has_class_name(element, "node--line") {
    style_node_line(element)
  }
  if has_class_name(element, "node--fill") {
    style_node_fill(element)
  }
  if has_class_name(element, "node--center") {
    style_node_center(element)
  }
  if has_class_name(element, "node--branch-line") {
    style_node_branch_line(element)
  }
  if has_class_name(element, "is-selected") {
    style_node_selected(element)
  }
  if tag == "SMALL" {
    style_node_kicker(element)
  }
  if tag == "STRONG" {
    style_node_title(element)
  }
  if has_class_name(element, "node-body") {
    style_node_body(element)
  }
  if has_class_name(element, "node-body-preview") {
    style_node_body_preview(element)
  }
  if has_class_name(element, "markdown-blocks") {
    style_markdown_blocks(element)
  }
  if has_class_name(element, "markdown-paragraph") {
    style_markdown_paragraph(element)
  }
  if has_class_name(element, "markdown-strong") {
    style_markdown_strong(element)
  }
  if has_class_name(element, "markdown-emphasis") {
    style_markdown_emphasis(element)
  }
  if has_class_name(element, "markdown-inline-code") {
    style_markdown_inline_code(element)
  }
  if has_class_name(element, "markdown-strike") {
    style_markdown_strike(element)
  }
  if has_class_name(element, "markdown-link") {
    style_markdown_link(element)
  }
  if has_class_name(element, "markdown-code-block") {
    style_markdown_code_block(element)
  }
  if has_class_name(element, "markdown-code-block__code") {
    style_markdown_code_block_code(element)
  }
  if has_class_name(element, "markdown-math") {
    style_markdown_math(element)
  }
  if has_class_name(element, "markdown-math--inline") {
    style_markdown_math_inline(element)
  }
  if has_class_name(element, "markdown-math--block") {
    style_markdown_math_block(element)
  }
  if has_class_name(element, "markdown-math-frac") {
    style_markdown_math_frac(element)
  }
  if has_class_name(element, "markdown-math-frac__num") {
    style_markdown_math_frac_num(element)
  }
  if has_class_name(element, "markdown-math-frac__den") {
    style_markdown_math_frac_den(element)
  }
  if has_class_name(element, "markdown-math-sqrt") {
    style_markdown_math_sqrt(element)
  }
  if has_class_name(element, "markdown-math-sqrt__symbol") {
    style_markdown_math_sqrt_symbol(element)
  }
  if has_class_name(element, "markdown-math-sqrt__radicand") {
    style_markdown_math_sqrt_radicand(element)
  }
  if has_class_name(element, "markdown-task") {
    style_markdown_task(element)
  }
  if has_class_name(element, "markdown-task--title") {
    style_markdown_task_title(element)
  }
  if has_class_name(element, "markdown-task__check") {
    style_markdown_task_check(element)
  }
  if has_class_name(element, "markdown-table") {
    style_markdown_table(element)
  }
  if tag == "TH" || tag == "TD" {
    style_markdown_table_cell(element, tag == "TH")
  }
  if has_class_name(element, "node-note-rail") {
    style_node_note_rail(element)
  }
  if has_class_name(element, "node-note-editor") {
    style_node_note_editor(element)
  }
  if has_class_name(element, "node-editor") {
    style_node_editor(element)
  }
  if has_class_name(element, "node-actions") {
    style_node_actions(element)
  }
  if has_class_name(element, "node-actions--left-mid") {
    style_node_actions_left_mid(element)
  }
  if has_class_name(element, "node-actions--right-mid") {
    style_node_actions_right_mid(element)
  }
  if has_class_name(element, "node-actions--top-center") {
    style_node_actions_top_center(element)
  }
  if has_class_name(element, "node-actions--bottom-center") {
    style_node_actions_bottom_center(element)
  }
  if has_class_name(element, "node-actions--corner") {
    style_node_actions_corner(element)
  }
  if has_class_name(element, "node-actions--branch-line") {
    style_node_actions_branch_line(element)
  }
  if has_class_name(element, "node-action") {
    style_node_action(element)
  }
  if has_class_name(element, "node-action--toggle") {
    style_node_action_toggle(element)
  }
  if has_class_name(element, "node-action--branch-line") {
    style_node_action_branch_line(element)
  }
  if has_class_name(element, "node-action--collapsed") {
    style_node_action_collapsed(element)
  }
  if has_class_name(element, "node-action--branch-line") {
    style_node_action_branch_line(element)
  }
  if has_class_name(element, "node-action--danger") {
    style_node_action_danger(element)
  }
  if has_class_name(element, "collapsed-node") {
    style_collapsed_node(element)
  }
  if has_class_name(element, "is-dragging") {
    style_node_dragging(element)
  }
  if has_class_name(element, "drop-slot") {
    style_drop_slot(element)
    style_single_right_drop_slot(element)
  }
  if has_class_name(element, "drop-before") {
    style_drop_before(element)
  }
  if has_class_name(element, "drop-after") {
    style_drop_after(element)
  }
  if has_class_name(element, "workspace-divider--dragging") {
    style_workspace_divider_dragging(element)
  }
  if has_class_name(element, "zoom-strip") {
    style_zoom_strip(element)
  }
  if has_class_name(element, "zoom-strip") &&
    has_class_name(element, "is-editing") {
    style_zoom_strip_editing(element)
  }
  if has_class_name(element, "zoom-value") {
    style_zoom_value(element)
  }
  if has_class_name(element, "zoom-edit") {
    style_zoom_edit(element)
  }
  if has_class_name(element, "tooltip-layer") {
    style_tooltip_layer(element)
  }
  if has_class_name(element, "tooltip") {
    style_tooltip(element)
  }
  if has_class_name(element, "tooltip__text") {
    style_tooltip_text(element)
  }
}

///|
fn apply_tool_select_custom_theme(custom : @dom.Element, muted : Bool) -> Unit {
  style_tool_select_custom(custom)
  let disabled = is_control_disabled(custom)
  let open = has_class_name(custom, "is-open") && !disabled
  let is_insert = has_class_name(custom, "tool-select-custom--insert")
  match custom.querySelector(".tool-select-trigger") {
    Some(trigger) => {
      style_tool_select_trigger(trigger)
      let trigger_style = style_of(trigger)
      if is_insert {
        style_insert_tool_select_trigger(trigger)
      }
      trigger_style.set_property(
        "color",
        if muted || disabled {
          "#92a4b8"
        } else {
          "#5c88a8"
        },
      )
      if disabled {
        trigger_style.set_property("cursor", "not-allowed")
        trigger_style.set_property("opacity", "0.56")
        trigger_style.set_property(
          "background", "linear-gradient(180deg, rgba(250, 252, 255, 0.9), rgba(236, 243, 250, 0.84))",
        )
        trigger_style.set_property("border-color", "rgba(194, 207, 221, 0.9)")
        trigger_style.set_property(
          "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.76), 0 4px 10px rgba(141, 159, 180, 0.05)",
        )
        trigger_style.set_property("color", "rgba(140, 160, 182, 0.96)")
        trigger_style.set_property("filter", "grayscale(0.3) saturate(0.82)")
        trigger_style.set_property("pointer-events", "auto")
      } else {
        trigger_style.set_property("cursor", "pointer")
        trigger_style.set_property("opacity", "1")
        trigger_style.set_property("pointer-events", "auto")
      }
      if open {
        trigger_style.set_property("border-color", "rgba(192, 208, 226, 0.96)")
        trigger_style.set_property(
          "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.84), rgba(244, 249, 253, 0.6))",
        )
        trigger_style.set_property(
          "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.92), 0 12px 28px rgba(120, 139, 164, 0.12)",
        )
      }
      match trigger.querySelector(".tool-select-trigger__arrow") {
        Some(arrow) => {
          let arrow_style = style_of(arrow)
          if is_insert {
            arrow_style.set_property("position", "static")
            arrow_style.set_property("right", "auto")
            arrow_style.set_property("top", "auto")
            arrow_style.set_property(
              "transform",
              if open {
                "rotate(180deg)"
              } else {
                "rotate(0deg)"
              },
            )
          } else {
            arrow_style.set_property(
              "transform",
              if open {
                "translateY(-48%) rotate(180deg)"
              } else {
                "translateY(-52%) rotate(0deg)"
              },
            )
          }
          arrow_style.set_property(
            "color",
            if muted || disabled {
              "rgba(146, 164, 184, 1)"
            } else {
              "#5c88a8"
            },
          )
          arrow_style.set_property("pointer-events", "none")
        }
        None => ()
      }
      if is_insert {
        match trigger.querySelector(".tool-select-trigger__label") {
          Some(label) => {
            let label_style = style_of(label)
            label_style.set_property("flex", "0 0 auto")
            label_style.set_property("min-width", "0")
            label_style.set_property("text-align", "left")
            label_style.set_property("display", "none")
          }
          None => ()
        }
        match trigger.querySelector(".tool-icon") {
          Some(icon) => {
            let icon_style = style_of(icon)
            icon_style.set_property("pointer-events", "none")
            icon_style.set_property("flex", "0 0 auto")
          }
          None => ()
        }
      }
    }
    None => ()
  }
  match custom.querySelector(".tool-select-menu") {
    Some(menu) => {
      style_tool_select_menu(menu)
      let menu_style = style_of(menu)
      if open {
        menu_style.set_property("opacity", "1")
        menu_style.set_property("visibility", "visible")
        menu_style.set_property("transform", "translateY(0)")
      } else {
        menu_style.set_property("opacity", "0")
        menu_style.set_property("visibility", "hidden")
        menu_style.set_property("transform", "translateY(-6px)")
      }
    }
    None => ()
  }
}

///|
fn style_of(element : @dom.Element) -> @dom.CSSStyleDeclaration {
  @dom.css_style_from_val(element.as_any()._get("style").cast())
}

///|
fn set_style(element : @dom.Element, name : String, value : String) -> Unit {
  style_of(element).set_property(name, value)
}

///|
fn style_app_shell(element : @dom.Element) -> Unit {
  set_style(element, "width", "100%")
  set_style(element, "margin", "0 auto")
  set_style(element, "display", "grid")
  set_style(element, "grid-template-rows", "auto 1fr")
  set_style(element, "gap", "14px")
  set_style(element, "padding", "18px")
  set_style(element, "height", "100%")
  set_style(element, "border", "1px solid rgba(221, 231, 241, 0.8)")
  set_style(element, "border-radius", "36px")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.5), rgba(247, 251, 255, 0.3))",
  )
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.82), 0 24px 60px rgba(120, 139, 164, 0.1)",
  )
  set_style(element, "backdrop-filter", "blur(26px) saturate(125%)")
  set_style(element, "overflow", "hidden")
}

///|
fn style_topbar(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "justify-content", "space-between")
  set_style(element, "align-items", "center")
  set_style(element, "gap", "12px 20px")
  set_style(element, "flex-wrap", "wrap")
}

///|
fn style_topbar_group(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "align-items", "center")
  set_style(element, "flex-wrap", "wrap")
  set_style(element, "gap", "10px 14px")
}

///|
fn style_workspace(element : @dom.Element) -> Unit {
  match read_workspace_split() {
    Some(percent) => set_style(element, "--left-pane-percent", "\{percent}%")
    None => set_style(element, "--left-pane-percent", "33%")
  }
  set_style(element, "--mindmap-toolbar-actions-width", "390px")
  set_style(element, "--mindmap-toolbar-min-width", "430px")
  set_style(element, "display", "grid")
  set_style(
    element, "grid-template-columns", "minmax(330px, var(--left-pane-percent)) 14px minmax(var(--mindmap-toolbar-min-width), 1fr)",
  )
  set_style(element, "height", "100%")
  set_style(element, "min-height", "0")
  set_style(element, "min-width", "0")
  set_style(element, "gap", "8px")
  set_style(element, "align-items", "stretch")
}

///|
fn style_workspace_dragging(element : @dom.Element) -> Unit {
  set_style(element, "user-select", "none")
  set_style(element, "cursor", "col-resize")
}

///|
fn style_brand_title(element : @dom.Element) -> Unit {
  set_style(element, "display", "inline-flex")
  set_style(element, "align-items", "center")
  set_style(element, "font-size", "28px")
  set_style(element, "font-weight", "700")
  set_style(element, "letter-spacing", "-0.03em")
  set_style(element, "color", "#1f3a56")
}

///|
fn style_section_title(element : @dom.Element) -> Unit {
  set_style(element, "font-size", "14px")
  set_style(element, "font-weight", "600")
  set_style(element, "letter-spacing", "0.01em")
  set_style(element, "color", "#5c88a8")
}

///|
fn style_button_shell(element : @dom.Element) -> Unit {
  set_style(element, "appearance", "none")
  set_style(element, "height", "40px")
  set_style(element, "padding", "0 12px")
  set_style(element, "border", "1px solid rgba(214, 225, 237, 0.76)")
  set_style(element, "border-radius", "15px")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.7), rgba(245, 249, 253, 0.42))",
  )
  set_style(element, "color", "#5c88a8")
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.88), 0 10px 24px rgba(120, 139, 164, 0.08)",
  )
  set_style(element, "cursor", "pointer")
}

///|
fn style_icon_button(element : @dom.Element, size : String) -> Unit {
  set_style(element, "width", size)
  set_style(element, "height", size)
  set_style(element, "padding", "0")
  set_style(element, "line-height", "1")
  set_style(element, "border-radius", "999px")
  set_style(element, "box-sizing", "border-box")
  set_style(element, "display", "inline-flex")
  set_style(element, "align-items", "center")
  set_style(element, "justify-content", "center")
}

///|
fn is_control_disabled(element : @dom.Element) -> Bool {
  has_class_name(element, "mindmap-tool--disabled") ||
  has_class_name(element, "mindmap-aux-button--disabled") ||
  has_class_name(element, "tool-select--disabled") ||
  has_class_name(element, "tool-select-custom--disabled") ||
  element.getAttribute("data-disabled").unwrap_or("") == "true"
}

///|
fn style_mindmap_tool(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
  set_style(element, "display", "inline-flex")
  set_style(element, "align-items", "center")
  set_style(element, "justify-content", "center")
  set_style(element, "width", "40px")
  set_style(element, "height", "40px")
  set_style(element, "padding", "0")
  set_style(element, "appearance", "none")
  set_style(element, "border", "1px solid rgba(214, 225, 237, 0.76)")
  set_style(element, "border-radius", "14px")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.7), rgba(245, 249, 253, 0.42))",
  )
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.82), 0 10px 24px rgba(120, 139, 164, 0.08)",
  )
  set_style(element, "color", "#5c88a8")
  set_style(element, "font-size", "14px")
  set_style(element, "line-height", "1")
  set_style(element, "white-space", "nowrap")
  if is_control_disabled(element) {
    set_style(element, "cursor", "not-allowed")
    set_style(element, "opacity", "0.56")
    set_style(
      element, "background", "linear-gradient(180deg, rgba(250, 252, 255, 0.9), rgba(236, 243, 250, 0.84))",
    )
    set_style(element, "border-color", "rgba(194, 207, 221, 0.9)")
    set_style(
      element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.76), 0 4px 10px rgba(141, 159, 180, 0.05)",
    )
    set_style(element, "color", "rgba(140, 160, 182, 0.96)")
    set_style(element, "filter", "grayscale(0.3) saturate(0.82)")
  } else {
    set_style(element, "cursor", "pointer")
    set_style(element, "opacity", "1")
    set_style(element, "filter", "none")
    set_style(element, "border-color", "rgba(214, 225, 237, 0.76)")
    set_style(
      element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.7), rgba(245, 249, 253, 0.42))",
    )
    set_style(
      element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.82), 0 10px 24px rgba(120, 139, 164, 0.08)",
    )
    set_style(element, "color", "#5c88a8")
  }
}

///|
fn style_mindmap_aux_button(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
  set_style(element, "display", "inline-flex")
  set_style(element, "align-items", "center")
  set_style(element, "justify-content", "center")
  set_style(element, "width", "40px")
  set_style(element, "height", "40px")
  set_style(element, "padding", "0")
  set_style(element, "appearance", "none")
  set_style(element, "border", "1px solid rgba(214, 225, 237, 0.76)")
  set_style(element, "border-radius", "14px")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.7), rgba(245, 249, 253, 0.42))",
  )
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.82), 0 10px 24px rgba(120, 139, 164, 0.08)",
  )
  set_style(element, "color", "#5c88a8")
  set_style(element, "font-size", "14px")
  set_style(element, "line-height", "1")
  set_style(element, "white-space", "nowrap")
  if is_control_disabled(element) {
    set_style(element, "cursor", "not-allowed")
    set_style(element, "opacity", "0.56")
    set_style(
      element, "background", "linear-gradient(180deg, rgba(250, 252, 255, 0.9), rgba(236, 243, 250, 0.84))",
    )
    set_style(element, "border-color", "rgba(194, 207, 221, 0.9)")
    set_style(
      element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.76), 0 4px 10px rgba(141, 159, 180, 0.05)",
    )
    set_style(element, "color", "rgba(140, 160, 182, 0.96)")
    set_style(element, "filter", "grayscale(0.3) saturate(0.82)")
  } else {
    set_style(element, "cursor", "default")
    set_style(element, "opacity", "1")
    set_style(element, "filter", "none")
    set_style(element, "border-color", "rgba(214, 225, 237, 0.76)")
    set_style(
      element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.7), rgba(245, 249, 253, 0.42))",
    )
    set_style(
      element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.82), 0 10px 24px rgba(120, 139, 164, 0.08)",
    )
    set_style(element, "color", "#5c88a8")
  }
}

///|
fn style_zoom_chip(element : @dom.Element) -> Unit {
  set_style(element, "display", "inline-flex")
  set_style(element, "align-items", "center")
  set_style(element, "justify-content", "center")
  set_style(element, "width", "32px")
  set_style(element, "height", "32px")
  set_style(element, "padding", "0")
  set_style(element, "border", "0")
  set_style(element, "border-radius", "10px")
  set_style(element, "background", "rgba(220, 230, 239, 0.62)")
  set_style(element, "color", "#5c88a8")
  set_style(element, "cursor", "pointer")
}

///|
fn style_tool_icon(element : @dom.Element) -> Unit {
  set_style(element, "display", "inline-flex")
  set_style(element, "align-items", "center")
  set_style(element, "justify-content", "center")
  set_style(element, "width", "22px")
  set_style(element, "height", "22px")
  set_style(element, "color", "currentColor")
}

///|
fn style_tool_icon_compact(element : @dom.Element) -> Unit {
  set_style(element, "width", "16px")
  set_style(element, "height", "16px")
}

///|
fn style_tool_select_wrap(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "align-items", "center")
  set_style(element, "gap", "8px")
  set_style(element, "position", "relative")
}

///|
fn style_tool_select_label(element : @dom.Element) -> Unit {
  set_style(element, "font-size", "14px")
  set_style(element, "color", "#5c88a8")
}

///|
fn style_tool_select(element : @dom.Element) -> Unit {
  set_style(element, "appearance", "none")
  set_style(element, "-webkit-appearance", "none")
  set_style(element, "-moz-appearance", "none")
  set_style(element, "min-width", "108px")
  set_style(element, "height", "44px")
  set_style(element, "padding", "0 40px 0 14px")
  set_style(element, "border-radius", "16px")
  set_style(element, "border", "1px solid rgba(214, 225, 237, 0.76)")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.7), rgba(245, 249, 253, 0.42))",
  )
  set_style(element, "color", "#5c88a8")
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.88), 0 10px 24px rgba(120, 139, 164, 0.08)",
  )
  set_style(element, "cursor", "pointer")
  if has_class_name(element, "tool-select--muted") {
    set_style(element, "border-color", "rgba(214, 225, 237, 0.76)")
    set_style(element, "color", "rgba(146, 164, 184, 1)")
  }
  if has_class_name(element, "tool-select--disabled") {
    set_style(element, "cursor", "not-allowed")
    set_style(element, "opacity", "0.72")
    set_style(element, "color", "rgba(146, 164, 184, 1)")
  } else {
    set_style(element, "opacity", "1")
  }
}

///|
fn style_tool_select_native(element : @dom.Element) -> Unit {
  set_style(element, "display", "none")
}

///|
fn is_insert_tool_select_part(element : @dom.Element) -> Bool {
  element.closest(".tool-select-custom--insert") is Some(_)
}

///|
fn style_insert_tool_select_custom(element : @dom.Element) -> Unit {
  set_style(element, "width", "47px")
  set_style(element, "min-width", "47px")
  set_style(element, "max-width", "47px")
  set_style(element, "flex", "0 0 47px")
}

///|
fn style_insert_tool_select_trigger(element : @dom.Element) -> Unit {
  set_style(element, "width", "47px")
  set_style(element, "min-width", "47px")
  set_style(element, "max-width", "47px")
  set_style(element, "flex", "0 0 47px")
  set_style(element, "box-sizing", "border-box")
  set_style(element, "height", "40px")
  set_style(element, "padding", "0 6px")
  set_style(element, "justify-content", "space-between")
  set_style(element, "gap", "0")
}

///|
fn style_insert_tool_select_trigger_label(element : @dom.Element) -> Unit {
  set_style(element, "flex", "0 0 auto")
  set_style(element, "min-width", "0")
  set_style(element, "text-align", "left")
  set_style(element, "display", "none")
}

///|
fn style_insert_tool_select_trigger_arrow(
  element : @dom.Element,
  open : Bool,
) -> Unit {
  set_style(element, "position", "static")
  set_style(element, "right", "auto")
  set_style(element, "top", "auto")
  set_style(
    element,
    "transform",
    if open {
      "rotate(180deg)"
    } else {
      "rotate(0deg)"
    },
  )
}

///|
fn style_tool_select_trigger_disabled(element : @dom.Element) -> Unit {
  set_style(element, "cursor", "not-allowed")
  set_style(element, "opacity", "0.56")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(250, 252, 255, 0.9), rgba(236, 243, 250, 0.84))",
  )
  set_style(element, "border-color", "rgba(194, 207, 221, 0.9)")
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.76), 0 4px 10px rgba(141, 159, 180, 0.05)",
  )
  set_style(element, "color", "rgba(140, 160, 182, 0.96)")
  set_style(element, "filter", "grayscale(0.3) saturate(0.82)")
  set_style(element, "pointer-events", "auto")
}

///|
fn style_tool_select_custom(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
  set_style(element, "display", "inline-flex")
  let open = has_class_name(element, "is-open")
  let is_insert = has_class_name(element, "tool-select-custom--insert")
  let disabled = is_control_disabled(element)
  if is_insert {
    style_insert_tool_select_custom(element)
  }
  match element.querySelector(".tool-select-trigger") {
    Some(trigger) => {
      set_style(trigger, "position", "relative")
      set_style(trigger, "display", "inline-flex")
      set_style(trigger, "align-items", "center")
      set_style(trigger, "justify-content", "flex-start")
      set_style(trigger, "gap", "8px")
      set_style(trigger, "min-width", "96px")
      set_style(trigger, "height", "40px")
      set_style(trigger, "padding", "0 32px 0 12px")
      set_style(trigger, "border", "1px solid rgba(214, 225, 237, 0.76)")
      set_style(trigger, "border-radius", "15px")
      set_style(
        trigger, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.7), rgba(245, 249, 253, 0.42))",
      )
      set_style(trigger, "color", "#5c88a8")
      set_style(
        trigger, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.88), 0 10px 24px rgba(120, 139, 164, 0.08)",
      )
      set_style(trigger, "cursor", "pointer")
      if is_insert {
        style_insert_tool_select_trigger(trigger)
      }
      if has_class_name(trigger, "tool-select--muted") {
        set_style(trigger, "color", "rgba(146, 164, 184, 1)")
      }
      if disabled {
        style_tool_select_trigger_disabled(trigger)
      }
      match trigger.querySelector(".tool-select-trigger__label") {
        Some(label) => {
          set_style(label, "flex", "1")
          set_style(label, "min-width", "0")
          set_style(label, "overflow", "hidden")
          set_style(label, "text-overflow", "ellipsis")
          set_style(label, "white-space", "nowrap")
          if is_insert {
            style_insert_tool_select_trigger_label(label)
          }
        }
        None => ()
      }
      match trigger.querySelector(".tool-select-trigger__arrow") {
        Some(arrow) => {
          set_style(arrow, "position", "absolute")
          set_style(arrow, "right", "12px")
          set_style(arrow, "top", "50%")
          set_style(
            arrow,
            "transform",
            if open {
              "translateY(-48%) rotate(180deg)"
            } else {
              "translateY(-52%) rotate(0deg)"
            },
          )
          set_style(arrow, "color", "#5c88a8")
          set_style(arrow, "font-size", "11px")
          set_style(arrow, "line-height", "1")
          set_style(arrow, "pointer-events", "none")
          if is_insert {
            style_insert_tool_select_trigger_arrow(arrow, open)
          }
        }
        None => ()
      }
      if open {
        set_style(trigger, "border-color", "rgba(192, 208, 226, 0.96)")
        set_style(
          trigger, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.84), rgba(244, 249, 253, 0.6))",
        )
        set_style(
          trigger, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.92), 0 12px 28px rgba(120, 139, 164, 0.12)",
        )
      }
      if !has_class_name(trigger, "tool-select--muted") && !disabled {
        set_style(trigger, "color", "#5c88a8")
      }
    }
    None => ()
  }
  match element.querySelector(".tool-select-menu") {
    Some(menu) => {
      if has_class_name(element, "tool-select-custom--insert") {
        set_style(menu, "min-width", "112px")
      }
      if open {
        set_style(menu, "opacity", "1")
        set_style(menu, "visibility", "visible")
        set_style(menu, "transform", "translateY(0)")
      } else {
        set_style(menu, "opacity", "0")
        set_style(menu, "visibility", "hidden")
        set_style(menu, "transform", "translateY(-6px)")
      }
    }
    None => ()
  }
}

///|
fn style_tool_select_trigger(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
  set_style(element, "display", "inline-flex")
  set_style(element, "align-items", "center")
  set_style(element, "justify-content", "flex-start")
  set_style(element, "gap", "8px")
  set_style(element, "min-width", "96px")
  set_style(element, "height", "40px")
  set_style(element, "padding", "0 32px 0 12px")
  set_style(element, "border", "1px solid rgba(214, 225, 237, 0.76)")
  set_style(element, "border-radius", "15px")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.7), rgba(245, 249, 253, 0.42))",
  )
  set_style(element, "color", "#5c88a8")
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.88), 0 10px 24px rgba(120, 139, 164, 0.08)",
  )
  set_style(element, "cursor", "pointer")
  if has_class_name(element, "tool-select--muted") {
    set_style(element, "color", "rgba(146, 164, 184, 1)")
  }
  if is_control_disabled(element) {
    style_tool_select_trigger_disabled(element)
  }
  if is_insert_tool_select_part(element) {
    style_insert_tool_select_trigger(element)
  }
}

///|
fn style_tool_select_trigger_label(element : @dom.Element) -> Unit {
  if is_insert_tool_select_part(element) {
    style_insert_tool_select_trigger_label(element)
  } else {
    set_style(element, "flex", "1")
    set_style(element, "min-width", "0")
    set_style(element, "overflow", "hidden")
    set_style(element, "text-overflow", "ellipsis")
    set_style(element, "white-space", "nowrap")
  }
}

///|
fn style_tool_select_trigger_arrow(element : @dom.Element) -> Unit {
  match element.closest(".tool-select-custom--insert") {
    Some(custom) =>
      style_insert_tool_select_trigger_arrow(
        element,
        has_class_name(custom, "is-open"),
      )
    None => {
      set_style(element, "position", "absolute")
      set_style(element, "right", "12px")
      set_style(element, "top", "50%")
    }
  }
  set_style(element, "color", "#5c88a8")
  set_style(element, "font-size", "11px")
  set_style(element, "line-height", "1")
  set_style(element, "pointer-events", "none")
}

///|
fn style_tool_select_menu(element : @dom.Element) -> Unit {
  set_style(element, "position", "absolute")
  set_style(element, "top", "100%")
  set_style(element, "left", "0")
  set_style(element, "min-width", "100%")
  set_style(element, "padding", "6px")
  set_style(element, "border", "1px solid rgba(206, 219, 232, 0.96)")
  set_style(element, "border-radius", "16px")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.92), rgba(245, 249, 253, 0.84))",
  )
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.96), 0 20px 44px rgba(120, 139, 164, 0.16)",
  )
  set_style(element, "backdrop-filter", "blur(20px) saturate(135%)")
  set_style(element, "opacity", "0")
  set_style(element, "visibility", "hidden")
  set_style(element, "transform", "translateY(-6px)")
  set_style(element, "z-index", "12")
}

///|
fn style_tool_select_option(element : @dom.Element) -> Unit {
  set_style(element, "width", "100%")
  set_style(element, "min-height", "36px")
  set_style(element, "padding", "0 12px")
  set_style(element, "border", "0")
  set_style(element, "border-radius", "10px")
  set_style(element, "background", "transparent")
  set_style(element, "color", "#23384d")
  set_style(element, "text-align", "left")
  set_style(element, "white-space", "nowrap")
  set_style(element, "cursor", "pointer")
  set_style(element, "box-shadow", "none")
}

///|
fn style_tool_select_option_selected(element : @dom.Element) -> Unit {
  set_style(
    element, "background", "linear-gradient(180deg, rgba(222, 236, 248, 0.98), rgba(210, 228, 244, 0.94))",
  )
  set_style(element, "color", "#17324f")
  set_style(element, "box-shadow", "inset 0 0 0 1px rgba(137, 173, 206, 0.62)")
}

///|
fn style_editor_panel(element : @dom.Element) -> Unit {
  set_style(element, "display", "grid")
  set_style(element, "grid-template-rows", "minmax(0, 1fr)")
  set_style(element, "min-width", "0")
  set_style(element, "min-height", "0")
  set_style(element, "height", "100%")
  set_style(element, "grid-column", "1")
  set_style(element, "padding", "0")
  set_style(element, "border", "0")
  set_style(element, "border-radius", "0")
  set_style(element, "background", "transparent")
  set_style(element, "box-shadow", "none")
  set_style(element, "backdrop-filter", "none")
  set_style(element, "overflow", "visible")
}

///|
fn style_editor_surface(element : @dom.Element) -> Unit {
  set_style(element, "display", "grid")
  set_style(element, "grid-template-rows", "auto 1fr")
  set_style(element, "height", "100%")
  set_style(element, "min-height", "0")
  set_style(element, "min-width", "0")
  set_style(element, "padding", "0")
  set_style(element, "border", "1px solid rgba(222, 232, 242, 0.84)")
  set_style(element, "border-radius", "32px")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.92), rgba(248, 251, 255, 0.84))",
  )
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.9), 0 18px 46px rgba(120, 139, 164, 0.09)",
  )
  set_style(element, "backdrop-filter", "blur(22px) saturate(122%)")
  set_style(element, "overflow", "hidden")
}

///|
fn style_editor_chrome(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "align-items", "center")
  set_style(element, "gap", "12px")
  set_style(element, "min-height", "52px")
  set_style(element, "padding", "0 16px")
  set_style(element, "border-bottom", "1px solid rgba(220, 231, 241, 0.92)")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(250, 252, 255, 0.9), rgba(242, 247, 252, 0.72))",
  )
}

///|
fn style_row_center(element : @dom.Element) -> Unit {
  set_style(element, "display", "inline-flex")
  set_style(element, "align-items", "center")
  set_style(element, "gap", "6px")
}

///|
fn style_dot(element : @dom.Element) -> Unit {
  set_style(element, "width", "8px")
  set_style(element, "height", "8px")
  set_style(element, "border-radius", "999px")
  set_style(element, "box-shadow", "inset 0 1px 1px rgba(255, 255, 255, 0.42)")
}

///|
fn style_dot_red(element : @dom.Element) -> Unit {
  set_style(element, "background", "#ff5f57")
  set_style(element, "border", "1px solid rgba(214, 69, 58, 0.42)")
}

///|
fn style_dot_yellow(element : @dom.Element) -> Unit {
  set_style(element, "background", "#febc2e")
  set_style(element, "border", "1px solid rgba(199, 149, 28, 0.42)")
}

///|
fn style_dot_green(element : @dom.Element) -> Unit {
  set_style(element, "background", "#28c840")
  set_style(element, "border", "1px solid rgba(26, 147, 44, 0.42)")
}

///|
fn style_editor_title(element : @dom.Element) -> Unit {
  set_style(element, "color", "#59728d")
  set_style(element, "font-size", "13px")
  set_style(element, "font-weight", "600")
  set_style(element, "letter-spacing", "0.02em")
}

///|
fn style_badge(element : @dom.Element) -> Unit {
  set_style(element, "display", "inline-flex")
  set_style(element, "align-items", "center")
  set_style(element, "min-width", "0")
  set_style(element, "max-width", "160px")
  set_style(element, "height", "28px")
  set_style(element, "padding", "0 10px")
  set_style(element, "border", "1px solid rgba(212, 223, 235, 0.94)")
  set_style(element, "border-radius", "999px")
  set_style(element, "background", "rgba(255, 255, 255, 0.72)")
  set_style(element, "color", "#6b84a0")
  set_style(element, "font-size", "12px")
  set_style(element, "margin-left", "auto")
  set_style(element, "overflow", "hidden")
  set_style(element, "text-overflow", "ellipsis")
  set_style(element, "white-space", "nowrap")
}

///|
fn style_editor_body(element : @dom.Element) -> Unit {
  set_style(element, "display", "grid")
  set_style(element, "grid-template-columns", "44px minmax(0, 1fr)")
  set_style(element, "align-self", "stretch")
  set_style(element, "min-height", "0")
  set_style(element, "height", "100%")
  set_style(element, "background", "#f8fbff")
  set_style(element, "overflow", "hidden")
}

///|
fn style_editor_gutter_wrap(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
  set_style(element, "height", "100%")
  set_style(element, "min-height", "0")
  set_style(element, "width", "44px")
  set_style(element, "min-width", "44px")
  set_style(element, "overflow", "hidden")
  set_style(element, "border-right", "1px solid rgba(224, 233, 242, 0.92)")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(245, 249, 253, 0.82), rgba(240, 246, 251, 0.64))",
  )
}

///|
fn style_editor_input_wrap(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
  set_style(element, "height", "100%")
  set_style(element, "min-width", "0")
  set_style(element, "min-height", "0")
  set_style(element, "background", "transparent")
  set_style(element, "overflow", "hidden")
}

///|
fn style_overlay_layer(element : @dom.Element) -> Unit {
  set_style(element, "position", "absolute")
  set_style(element, "inset", "0")
  set_style(element, "pointer-events", "none")
}

///|
fn style_line_layer(element : @dom.Element) -> Unit {
  set_style(element, "position", "absolute")
  set_style(element, "top", "0")
  set_style(element, "height", "28px")
  set_style(element, "opacity", "0")
  set_style(element, "pointer-events", "none")
  set_style(element, "transform", "translateY(0)")
  set_style(element, "transition", "opacity 120ms ease")
  set_style(element, "z-index", "0")
  set_style(element, "left", "0")
  set_style(element, "right", "0")
}

///|
fn style_editor_linked_line(element : @dom.Element) -> Unit {
  set_style(element, "left", "10px")
  set_style(element, "right", "12px")
  set_style(element, "border-radius", "9px")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(111, 214, 183, 0.22), rgba(111, 214, 183, 0.1))",
  )
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.4), inset 3px 0 0 rgba(37, 162, 122, 0.48), 0 0 0 1px rgba(83, 188, 157, 0.18)",
  )
}

///|
fn style_editor_hover_line(element : @dom.Element) -> Unit {
  set_style(element, "left", "10px")
  set_style(element, "right", "12px")
  set_style(element, "border-radius", "9px")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(146, 196, 248, 0.18), rgba(146, 196, 248, 0.08))",
  )
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.44), 0 0 0 1px rgba(146, 196, 248, 0.16)",
  )
  set_style(element, "z-index", "1")
}

///|
fn style_editor_active_line(element : @dom.Element) -> Unit {
  set_style(element, "left", "10px")
  set_style(element, "right", "12px")
  set_style(element, "border-radius", "9px")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(134, 186, 244, 0.34), rgba(134, 186, 244, 0.18))",
  )
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.56), inset 3px 0 0 rgba(72, 137, 210, 0.58), 0 0 0 1px rgba(126, 173, 225, 0.32)",
  )
  set_style(element, "z-index", "2")
}

///|
fn style_editor_gutter_line_linked(element : @dom.Element) -> Unit {
  set_style(
    element, "background", "linear-gradient(180deg, rgba(111, 214, 183, 0.18), rgba(111, 214, 183, 0.08))",
  )
  set_style(
    element, "box-shadow", "inset 2px 0 0 rgba(37, 162, 122, 0.42), 0 0 0 1px rgba(83, 188, 157, 0.14)",
  )
}

///|
fn style_editor_gutter_line_hover(element : @dom.Element) -> Unit {
  set_style(
    element, "background", "linear-gradient(180deg, rgba(146, 196, 248, 0.14), rgba(146, 196, 248, 0.05))",
  )
  set_style(element, "box-shadow", "0 0 0 1px rgba(146, 196, 248, 0.12)")
  set_style(element, "z-index", "1")
}

///|
fn style_editor_gutter_line_active(element : @dom.Element) -> Unit {
  set_style(
    element, "background", "linear-gradient(180deg, rgba(134, 186, 244, 0.26), rgba(134, 186, 244, 0.12))",
  )
  set_style(
    element, "box-shadow", "inset 2px 0 0 rgba(72, 137, 210, 0.46), 0 0 0 1px rgba(126, 173, 225, 0.22)",
  )
  set_style(element, "z-index", "2")
}

///|
fn style_editor_gutter(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
  set_style(element, "z-index", "3")
  set_style(element, "margin", "0")
  set_style(element, "padding", "18px 8px 22px 10px")
  set_style(element, "width", "44px")
  set_style(element, "min-width", "44px")
  set_style(element, "background", "transparent")
  set_style(element, "color", "rgba(109, 129, 151, 0.72)")
  set_style(
    element, "font", "16px/28px \"Cascadia Code\", \"Consolas\", monospace",
  )
  set_style(element, "text-align", "right")
  set_style(element, "overflow", "hidden")
  set_style(element, "user-select", "none")
  set_style(element, "font-variant-numeric", "tabular-nums")
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "align-items", "stretch")
}

///|
fn style_editor_gutter_number(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "align-items", "flex-start")
  set_style(element, "justify-content", "flex-end")
  set_style(element, "width", "100%")
  set_style(element, "min-height", "28px")
  set_style(element, "line-height", "28px")
  set_style(element, "font-size", "12px")
  set_style(element, "font-weight", "600")
}

///|
fn style_editor_textarea(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
  set_style(element, "z-index", "3")
  set_style(element, "box-sizing", "border-box")
  set_style(element, "width", "100%")
  set_style(element, "height", "100%")
  set_style(element, "min-height", "0")
  set_style(element, "resize", "none")
  set_style(element, "border", "0")
  set_style(element, "padding", "18px 18px 22px 16px")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.08), rgba(255, 255, 255, 0)), repeating-linear-gradient(180deg, transparent 0, transparent 27px, rgba(198, 213, 228, 0.86) 27px, rgba(198, 213, 228, 0.86) 28px, transparent 28px)",
  )
  set_style(element, "background-position", "0 0, 0 0")
  set_style(element, "background-origin", "border-box, content-box")
  set_style(element, "background-attachment", "local, local")
  set_style(element, "background-repeat", "no-repeat, repeat")
  set_style(element, "color", "#23384d")
  set_style(
    element, "font", "16px/28px \"Cascadia Code\", \"Consolas\", monospace",
  )
  set_style(element, "white-space", "pre-wrap")
  set_style(element, "word-break", "normal")
  set_style(element, "overflow-wrap", "break-word")
  set_style(element, "word-wrap", "break-word")
  set_style(element, "overflow", "auto")
  set_style(element, "overflow-x", "hidden")
  set_style(element, "caret-color", "#5e86b5")
  set_style(element, "tab-size", "2")
  set_style(element, "outline", "none")
}

///|
fn style_editor_input_mirror(element : @dom.Element) -> Unit {
  set_style(element, "position", "absolute")
  set_style(element, "top", "0")
  set_style(element, "left", "0")
  set_style(element, "right", "auto")
  set_style(element, "bottom", "auto")
  set_style(element, "z-index", "0")
  set_style(element, "visibility", "hidden")
  set_style(element, "pointer-events", "none")
  set_style(element, "user-select", "none")
  set_style(element, "overflow", "hidden")
  set_style(element, "overflow-x", "hidden")
  set_style(element, "overflow-y", "hidden")
  set_style(element, "box-sizing", "border-box")
  set_style(element, "width", "100%")
  set_style(element, "height", "0")
  set_style(element, "min-height", "0")
  set_style(element, "border", "0")
  set_style(element, "resize", "none")
  set_style(element, "padding", "0")
  set_style(element, "margin", "0")
  set_style(element, "white-space", "pre-wrap")
  set_style(element, "word-break", "normal")
  set_style(element, "overflow-wrap", "break-word")
  set_style(element, "word-wrap", "break-word")
}

///|
fn style_workspace_divider(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "align-items", "stretch")
  set_style(element, "justify-content", "center")
  set_style(element, "position", "relative")
  set_style(element, "width", "14px")
  set_style(element, "min-width", "14px")
  set_style(element, "height", "100%")
  set_style(element, "grid-column", "2")
  set_style(element, "cursor", "col-resize")
  set_style(element, "touch-action", "none")
}

///|
fn style_workspace_divider_dragging(element : @dom.Element) -> Unit {
  ignore(element)
}

///|
fn style_workspace_divider_track(element : @dom.Element) -> Unit {
  set_style(element, "width", "5px")
  set_style(element, "height", "100%")
  set_style(element, "border-radius", "999px")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(209, 220, 232, 0.14), rgba(156, 174, 196, 0.34), rgba(209, 220, 232, 0.14))",
  )
}

///|
fn style_workspace_divider_handle(element : @dom.Element) -> Unit {
  set_style(element, "position", "absolute")
  set_style(element, "top", "50%")
  set_style(element, "left", "50%")
  set_style(element, "width", "10px")
  set_style(element, "height", "136px")
  set_style(element, "border", "0")
  set_style(element, "border-radius", "999px")
  set_style(element, "transform", "translate(-50%, -50%)")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.94), rgba(227, 234, 242, 0.88))",
  )
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.84), 0 8px 18px rgba(120, 139, 164, 0.12)",
  )
}

///|
fn style_mindmap_panel(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "min-width", "0")
  set_style(element, "min-height", "0")
  set_style(element, "gap", "8px")
  set_style(element, "grid-column", "3")
  set_style(element, "padding", "18px 20px")
  set_style(element, "border", "1px solid rgba(222, 232, 242, 0.84)")
  set_style(element, "border-radius", "32px")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.92), rgba(248, 251, 255, 0.84))",
  )
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.9), 0 18px 46px rgba(120, 139, 164, 0.09)",
  )
  set_style(element, "backdrop-filter", "blur(22px) saturate(122%)")
  set_style(element, "overflow", "visible")
}

///|
fn style_mindmap_toolbar(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-wrap", "wrap")
  set_style(element, "align-items", "flex-start")
  set_style(element, "justify-content", "space-between")
  set_style(element, "column-gap", "8px")
  set_style(element, "row-gap", "10px")
  set_style(element, "padding", "0 15px 4px")
  set_style(element, "position", "relative")
  set_style(element, "z-index", "3")
  set_style(element, "min-width", "0")
  set_style(element, "max-width", "100%")
}

///|
fn style_mindmap_toolbar_cluster(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "align-items", "center")
  set_style(element, "flex-wrap", "wrap")
  set_style(element, "gap", "10px")
  set_style(element, "min-width", "0")
}

///|
fn style_mindmap_zoom(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "justify-content", "flex-end")
  set_style(element, "align-items", "center")
  set_style(element, "justify-content", "flex-end")
  set_style(element, "margin-left", "auto")
  set_style(element, "min-width", "0")
  set_style(element, "flex", "0 0 auto")
  set_style(element, "padding", "0")
}

///|
fn style_mindmap_toolbar_actions(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-wrap", "nowrap")
  set_style(element, "gap", "9px")
  set_style(element, "flex", "0 0 auto")
  set_style(element, "min-width", "max-content")
}

///|
fn style_mindmap_toolbar_side(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "align-items", "center")
  set_style(element, "justify-content", "flex-end")
  set_style(element, "gap", "10px")
  set_style(element, "flex", "0 0 auto")
  set_style(element, "margin-left", "auto")
  set_style(element, "min-width", "fit-content")
}

///|
fn style_mindmap_side_tools(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "align-items", "center")
  set_style(element, "gap", "10px")
}

///|
fn style_mindmap_canvas_shell(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "min-height", "0")
  set_style(element, "height", "100%")
  set_style(element, "min-width", "0")
}

///|
fn style_mindmap_surface(element : @dom.Element) -> Unit {
  set_style(element, "flex", "1")
  set_style(element, "min-height", "0")
  set_style(element, "min-width", "0")
  set_style(element, "border", "1px solid rgba(223, 233, 243, 0.9)")
  set_style(element, "border-radius", "26px")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.74), rgba(249, 252, 255, 0.62))",
  )
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.88), 0 12px 28px rgba(120, 139, 164, 0.06)",
  )
  set_style(element, "height", "100%")
  set_style(element, "overflow", "visible")
}

///|
fn style_mindmap(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
  set_style(element, "height", "100%")
  set_style(element, "min-height", "0")
  set_style(element, "min-width", "0")
  set_style(element, "padding", "6px 2px 2px")
  set_style(element, "overflow", "hidden")
  set_style(element, "outline", "none")
  set_style(
    element,
    "cursor",
    if has_class_name(element, "is-panning") {
      "grabbing"
    } else {
      "grab"
    },
  )
}

///|
fn style_mindmap_content(element : @dom.Element) -> Unit {
  set_style(element, "position", "absolute")
  set_style(element, "left", "50%")
  set_style(element, "top", "50%")
  set_style(
    element, "transform", "translate(calc(-50% + var(--pan-x)), calc(-50% + var(--pan-y))) scale(var(--zoom))",
  )
  set_style(element, "transform-origin", "center center")
}

///|
fn style_mindmap_stage(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
  set_style(element, "display", "grid")
  set_style(
    element, "grid-template-columns", "minmax(220px, 1fr) auto minmax(220px, 1fr)",
  )
  set_style(element, "gap", "28px")
  set_style(element, "align-items", "start")
  set_style(element, "min-width", "860px")
  set_style(element, "padding", "20px 4px")
  set_style(element, "z-index", "1")
}

///|
fn style_mindmap_stage_radial(element : @dom.Element) -> Unit {
  set_style(
    element, "grid-template-columns", "minmax(280px, 1fr) auto minmax(280px, 1fr)",
  )
  set_style(element, "gap", "60px")
  set_style(element, "align-items", "center")
  set_style(element, "min-width", "1120px")
  set_style(element, "min-height", "1040px")
  set_style(element, "padding", "56px 32px 48px")
}

///|
fn style_mindmap_stage_fill(element : @dom.Element) -> Unit {
  set_style(element, "--fill-branch", "#5c88a8")
  set_style(element, "--fill-outline", "#55c3fb")
  set_style(element, "--fill-soft-outline", "rgba(136, 169, 199, 0.42)")
  set_style(
    element, "--fill-card-bg", "linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(248, 251, 254, 0.92))",
  )
  set_style(element, "--mindmap-connector-color", "#7ca5d4")
  set_style(element, "--mindmap-connector-accent", "#5c88a8")
  set_style(element, "--mindmap-node-muted", "#7287a0")
}

///|
fn style_mindmap_stage_line(element : @dom.Element) -> Unit {
  set_style(element, "--fill-branch", "#5c88a8")
  set_style(element, "--fill-outline", "#55c3fb")
  set_style(element, "--fill-soft-outline", "rgba(136, 169, 199, 0.42)")
  set_style(
    element, "--fill-card-bg", "linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(248, 251, 254, 0.92))",
  )
  set_style(element, "--mindmap-connector-color", "#94b6db")
  set_style(element, "--mindmap-connector-accent", "#5c88a8")
  set_style(element, "--mindmap-node-muted", "#7287a0")
}

///|
fn style_mindmap_stage_branch_line(element : @dom.Element) -> Unit {
  set_style(element, "gap", "52px")
  set_style(element, "padding", "48px 28px")
}

///|
fn style_mindmap_stage_vertical(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "align-items", "center")
  set_style(element, "gap", "18px")
  set_style(element, "min-width", "960px")
  set_style(element, "min-height", "720px")
  set_style(element, "padding", "42px 32px 48px")
}

///|
fn style_mindmap_stage_single_right(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "row")
  set_style(element, "align-items", "center")
  set_style(element, "justify-content", "flex-start")
  set_style(element, "gap", "0")
  set_style(element, "min-width", "820px")
  set_style(element, "min-height", "720px")
  set_style(element, "padding", "48px 32px 48px")
}

///|
fn style_mindmap_connector_layer(element : @dom.Element) -> Unit {
  set_style(element, "z-index", "0")
  set_style(element, "position", "absolute")
  set_style(element, "left", "0")
  set_style(element, "top", "0")
  set_style(element, "width", "100%")
  set_style(element, "height", "100%")
  set_style(element, "overflow", "visible")
  set_style(element, "mix-blend-mode", "multiply")
  set_style(element, "opacity", "0.92")
  set_style(element, "pointer-events", "none")
}

///|
fn style_layout_block(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "min-width", "0")
}

///|
fn style_branch_column(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "gap", "20px")
  set_style(element, "min-height", "540px")
  set_style(element, "padding-top", "20px")
}

///|
fn style_branch_column_root(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
  set_style(element, "align-self", "stretch")
  set_style(element, "height", "100%")
  set_style(element, "min-height", "0")
}

///|
fn style_branch_column_left(element : @dom.Element) -> Unit {
  set_style(element, "align-items", "flex-end")
}

///|
fn style_branch_column_right(element : @dom.Element) -> Unit {
  set_style(element, "align-items", "flex-start")
}

///|
fn style_center_wrap(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "align-items", "center")
  set_style(element, "justify-content", "center")
  set_style(element, "height", "100%")
  set_style(element, "min-width", "260px")
  set_style(element, "padding", "0 16px")
}

///|
fn style_branch_item(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "gap", "8px")
}

///|
fn style_branch_item_root(element : @dom.Element) -> Unit {
  set_style(element, "position", "absolute")
  set_style(element, "top", "0")
  set_style(element, "transform", "none")
}

///|
fn style_branch_item_left(element : @dom.Element) -> Unit {
  set_style(element, "align-items", "flex-end")
}

///|
fn style_branch_item_right(element : @dom.Element) -> Unit {
  set_style(element, "align-items", "flex-start")
}

///|
fn style_branch_item_row(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "align-items", "center")
  set_style(element, "gap", "24px")
}

///|
fn style_branch_item_head(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
  set_style(element, "display", "flex")
  set_style(element, "align-items", "flex-start")
  set_style(element, "flex-direction", "column")
}

///|
fn style_branch_children(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "gap", "16px")
  set_style(element, "position", "relative")
}

///|
fn style_branch_children_left(element : @dom.Element) -> Unit {
  set_style(element, "align-items", "flex-end")
  set_style(element, "margin-right", "16px")
}

///|
fn style_branch_children_right(element : @dom.Element) -> Unit {
  set_style(element, "align-items", "flex-start")
  set_style(element, "margin-left", "16px")
}

///|
fn style_vertical_root(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "align-items", "center")
  set_style(element, "min-width", "0")
}

///|
fn style_vertical_tree(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "align-items", "center")
  set_style(element, "gap", "18px")
}

///|
fn style_vertical_tree_children(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "row")
  set_style(element, "align-items", "flex-start")
  set_style(element, "justify-content", "center")
  set_style(element, "gap", "18px")
  set_style(element, "padding-top", "22px")
  set_style(element, "position", "relative")
}

///|
fn style_vertical_tree_child(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "justify-content", "center")
  set_style(element, "align-items", "flex-start")
  set_style(element, "min-width", "0")
}

///|
fn style_single_right_tree(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "row")
  set_style(element, "align-items", "center")
  set_style(element, "gap", "56px")
  set_style(element, "min-width", "0")
}

///|
fn style_single_right_tree_node(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "row")
  set_style(element, "align-items", "center")
  set_style(element, "gap", "24px")
  set_style(element, "min-width", "0")
}

///|
fn style_single_right_tree_node_left(element : @dom.Element) -> Unit {
  set_style(element, "justify-content", "flex-end")
}

///|
fn style_single_right_tree_node_right(element : @dom.Element) -> Unit {
  set_style(element, "justify-content", "flex-start")
}

///|
fn style_single_right_tree_head(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "justify-content", "flex-start")
  set_style(element, "position", "relative")
  set_style(element, "flex-direction", "column")
  set_style(element, "flex", "0 0 auto")
}

///|
fn style_single_right_tree_children(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "align-items", "flex-start")
  set_style(element, "gap", "16px")
  set_style(element, "padding-left", "0")
  set_style(element, "position", "relative")
  set_style(element, "flex", "0 0 auto")
}

///|
fn style_single_right_tree_children_left(element : @dom.Element) -> Unit {
  set_style(element, "align-items", "flex-end")
}

///|
fn style_single_right_tree_children_right(element : @dom.Element) -> Unit {
  set_style(element, "align-items", "flex-start")
}

///|
fn style_node(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
  set_style(element, "display", "inline-flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "align-items", "center")
  set_style(element, "gap", "0")
  set_style(element, "min-width", "156px")
  set_style(element, "max-width", "228px")
  set_style(element, "padding", "12px 16px")
  set_style(element, "border", "1px solid rgba(214, 225, 237, 0.96)")
  set_style(element, "border-radius", "16px")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.94), rgba(247, 250, 253, 0.82))",
  )
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.88), 0 12px 28px rgba(120, 139, 164, 0.1)",
  )
  set_style(element, "color", "#23384d")
  set_style(element, "text-align", "center")
}

///|
fn style_node_center(element : @dom.Element) -> Unit {
  if has_class_name(element, "node--fill") {
    set_style(element, "min-width", "192px")
    set_style(element, "max-width", "252px")
    set_style(element, "padding", "22px 30px")
    set_style(element, "border", "3px solid #55c3fb")
    set_style(element, "border-radius", "18px")
    set_style(
      element, "background", "linear-gradient(135deg, #243b4f, #182633)",
    )
    set_style(
      element, "box-shadow", "inset 0 1px 0 rgba(235, 244, 252, 0.12), 0 18px 32px rgba(136, 169, 199, 0.2)",
    )
    set_style(element, "color", "#ffffff")
  } else {
    set_style(element, "min-width", "210px")
    set_style(element, "max-width", "260px")
    set_style(element, "padding", "22px 30px")
    set_style(element, "border-radius", "20px")
    set_style(element, "border-color", "rgba(146, 170, 198, 0.22)")
    set_style(
      element, "background", "linear-gradient(180deg, rgba(84, 113, 145, 0.96), rgba(67, 93, 122, 0.94))",
    )
    set_style(element, "color", "#ffffff")
    set_style(
      element, "box-shadow", "inset 0 1px 0 rgba(233, 242, 251, 0.18), 0 16px 34px rgba(110, 131, 156, 0.16)",
    )
  }
}

///|
fn is_single_right_drop_slot(element : @dom.Element) -> Bool {
  has_class_name(element, "drop-slot--single-right") ||
  element.closest(".mindmap-stage--single-right, .single-right-tree__node")
  is Some(_)
}

///|
fn style_node_line(element : @dom.Element) -> Unit {
  set_style(element, "border-color", "rgba(224, 233, 242, 0.96)")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.94), rgba(247, 250, 253, 0.82))",
  )
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.88), 0 12px 28px rgba(120, 139, 164, 0.1)",
  )
}

///|
fn style_node_fill(element : @dom.Element) -> Unit {
  if element.getAttribute("data-depth").unwrap_or("0") == "1" {
    set_style(element, "min-width", "152px")
    set_style(element, "max-width", "228px")
    set_style(element, "padding", "16px 22px")
    set_style(element, "border", "2px solid #55c3fb")
    set_style(element, "border-radius", "13px")
    set_style(element, "color", "#28415d")
    set_style(
      element, "background", "linear-gradient(135deg, #89dfff, #46b9f5)",
    )
    set_style(
      element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.42), 0 12px 24px rgba(136, 169, 199, 0.18)",
    )
  } else {
    set_style(element, "min-width", "136px")
    set_style(element, "max-width", "214px")
    set_style(element, "padding", "12px 18px")
    set_style(element, "border", "2px solid #90d2ff")
    set_style(element, "border-radius", "12px")
    set_style(element, "color", "#28415d")
    set_style(
      element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(248, 251, 254, 0.92))",
    )
    set_style(
      element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.84), 0 10px 22px rgba(136, 169, 199, 0.14)",
    )
  }
}

///|
fn style_node_branch_line(element : @dom.Element) -> Unit {
  set_style(element, "display", "inline-flex")
  set_style(element, "align-items", "center")
  set_style(element, "justify-content", "center")
  set_style(element, "gap", "0")
  set_style(element, "min-width", "48px")
  set_style(element, "max-width", "360px")
  set_style(element, "padding", "0 15px 4px")
  set_style(element, "border", "0")
  set_style(element, "border-radius", "0")
  set_style(
    element, "border-bottom", "1.4px solid var(--mindmap-connector-color, #94b6db)",
  )
  set_style(element, "background", "transparent")
  set_style(element, "box-shadow", "none")
  set_style(element, "color", "#596475")
  set_style(element, "text-align", "center")
  match element.closest(".branch-item--left, .single-right-tree__node--left") {
    Some(_) => {
      set_style(element, "align-items", "center")
      set_style(element, "text-align", "center")
    }
    None => ()
  }
  if has_class_name(element, "node--center") {
    set_style(element, "min-width", "128px")
    set_style(element, "max-width", "220px")
    set_style(element, "padding", "0 15px 5px")
    set_style(element, "border-bottom-width", "1.8px")
    set_style(element, "color", "#4d5969")
  }
}

///|
fn style_node_kicker(element : @dom.Element) -> Unit {
  match element.closest(".mindmap-stage--radial, .node--fill") {
    Some(_) => {
      set_style(element, "display", "none")
      return
    }
    None => ()
  }
  set_style(element, "display", "block")
  set_style(element, "margin-bottom", "4px")
  set_style(element, "font-size", "11px")
  set_style(element, "line-height", "1.35")
  set_style(element, "font-weight", "600")
  set_style(element, "color", "var(--muted)")
}

///|
fn style_node_title(element : @dom.Element) -> Unit {
  if has_class_name(element, "node-title--scaled") {
    set_style(element, "display", "block")
    set_style(element, "font-size", scaled_node_title_font_size(element))
    set_style(
      element,
      "line-height",
      if has_class_name(element, "node-title--line") {
        "1.18"
      } else {
        "1.28"
      },
    )
    set_style(element, "font-weight", "400")
    set_style(element, "color", "inherit")
    set_style(element, "white-space", "normal")
    set_style(element, "word-break", "break-word")
    return
  }
  match element.closest(".node") {
    Some(node) => {
      if has_class_name(node, "node--branch-line") {
        set_style(element, "display", "block")
        set_style(element, "font-size", branch_line_title_font_size(node))
        set_style(element, "line-height", "1.18")
        set_style(element, "font-weight", "400")
        set_style(element, "color", "inherit")
        set_style(element, "white-space", "normal")
        set_style(element, "word-break", "break-word")
        return
      }
      if has_class_name(node, "node--fill") {
        if has_class_name(node, "node--center") {
          set_style(element, "display", "block")
          set_style(element, "font-size", "22px")
          set_style(element, "line-height", "1.35")
          set_style(element, "font-weight", "700")
          set_style(element, "color", "inherit")
          return
        }
        if node.getAttribute("data-depth").unwrap_or("0") == "1" {
          set_style(element, "display", "block")
          set_style(element, "font-size", "18px")
          set_style(element, "line-height", "1.35")
          set_style(element, "font-weight", "700")
          set_style(element, "color", "inherit")
          return
        }
        set_style(element, "display", "block")
        set_style(element, "font-size", "15px")
        set_style(element, "line-height", "1.35")
        set_style(element, "font-weight", "600")
        set_style(element, "color", "inherit")
        return
      }
      if has_class_name(node, "node--center") {
        set_style(element, "display", "block")
        set_style(element, "font-size", "15px")
        set_style(element, "line-height", "1.35")
        set_style(element, "font-weight", "700")
        set_style(element, "color", "inherit")
        return
      }
    }
    None => ()
  }
  set_style(element, "display", "block")
  set_style(element, "font-size", "15px")
  set_style(element, "line-height", "1.3")
  set_style(element, "font-weight", "700")
  set_style(element, "color", "inherit")
}

///|
fn scaled_node_title_font_size(element : @dom.Element) -> String {
  if element.getAttribute("data-title-center").unwrap_or("false") == "true" {
    "22px"
  } else {
    match element.getAttribute("data-title-depth").unwrap_or("0") {
      "1" => "20px"
      "2" => "18px"
      "3" => "16px"
      "4" => "15px"
      _ => "14px"
    }
  }
}

///|
fn branch_line_title_font_size(node : @dom.Element) -> String {
  if has_class_name(node, "node--center") {
    "22px"
  } else {
    match node.getAttribute("data-depth").unwrap_or("0") {
      "1" => "20px"
      "2" => "18px"
      "3" => "16px"
      "4" => "15px"
      _ => "14px"
    }
  }
}

///|
fn style_node_body(element : @dom.Element) -> Unit {
  match element.closest(".node--branch-line") {
    Some(_) => {
      set_style(element, "display", "block")
      set_style(element, "width", "100%")
      set_style(element, "max-width", "100%")
      set_style(element, "min-width", "0")
      set_style(element, "box-sizing", "border-box")
      set_style(element, "margin-top", "6px")
      set_style(element, "padding", "0")
      set_style(element, "border", "0")
      set_style(element, "border-radius", "0")
      set_style(element, "background", "transparent")
      set_style(element, "color", "inherit")
      set_style(element, "font-size", "14px")
      set_style(element, "line-height", "1.35")
      set_style(element, "white-space", "pre-wrap")
      set_style(element, "word-break", "break-word")
      set_style(element, "max-height", "160px")
      set_style(element, "overflow", "auto")
      set_style(element, "font-weight", "400")
      return
    }
    None => ()
  }
  set_style(element, "display", "block")
  set_style(element, "width", "100%")
  set_style(element, "max-width", "100%")
  set_style(element, "min-width", "0")
  set_style(element, "box-sizing", "border-box")
  set_style(element, "margin-top", "0")
  set_style(element, "margin-left", "auto")
  set_style(element, "margin-right", "auto")
  set_style(element, "padding", "8px 10px")
  set_style(element, "border-radius", "8px")
  set_style(element, "background", "rgba(247, 250, 253, 0.84)")
  set_style(element, "border", "1px solid rgba(214, 225, 237, 0.68)")
  set_style(element, "color", "rgba(92, 122, 153, 0.95)")
  set_style(element, "font-size", "12px")
  set_style(element, "line-height", "1.45")
  set_style(element, "white-space", "pre-wrap")
  set_style(element, "word-break", "break-word")
  set_style(element, "max-height", "120px")
  set_style(element, "overflow", "auto")
  set_style(element, "font-weight", "500")
}

///|
fn style_node_body_preview(element : @dom.Element) -> Unit {
  set_style(element, "cursor", "text")
  set_style(element, "text-align", "left")
}

///|
fn style_markdown_blocks(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "gap", "6px")
  set_style(element, "width", "100%")
  set_style(element, "max-width", "100%")
  set_style(element, "min-width", "0")
}

///|
fn style_markdown_paragraph(element : @dom.Element) -> Unit {
  set_style(element, "margin", "0")
  set_style(element, "white-space", "pre-wrap")
}

///|
fn style_markdown_strong(element : @dom.Element) -> Unit {
  set_style(element, "font-weight", "800")
}

///|
fn style_markdown_emphasis(element : @dom.Element) -> Unit {
  set_style(element, "font-style", "italic")
}

///|
fn style_markdown_inline_code(element : @dom.Element) -> Unit {
  set_style(element, "display", "inline-block")
  set_style(element, "padding", "1px 4px")
  set_style(element, "border-radius", "5px")
  set_style(element, "background", "rgba(32, 57, 82, 0.1)")
  set_style(element, "color", "#28415d")
  set_style(element, "font-family", "\"Cascadia Mono\", Consolas, monospace")
  set_style(element, "font-size", "0.92em")
}

///|
fn style_markdown_strike(element : @dom.Element) -> Unit {
  set_style(element, "text-decoration", "line-through")
  set_style(element, "opacity", "0.74")
}

///|
fn style_markdown_link(element : @dom.Element) -> Unit {
  set_style(element, "color", "#2c70ce")
  set_style(element, "text-decoration", "underline")
  set_style(element, "text-underline-offset", "2px")
}

///|
fn style_markdown_code_block(element : @dom.Element) -> Unit {
  set_style(element, "margin", "0")
  set_style(element, "display", "block")
  set_style(element, "width", "100%")
  set_style(element, "max-width", "100%")
  set_style(element, "min-width", "0")
  set_style(element, "box-sizing", "border-box")
  set_style(element, "padding", "8px")
  set_style(element, "border-radius", "8px")
  set_style(element, "background", "rgba(29, 45, 62, 0.92)")
  set_style(element, "color", "#f6fbff")
  set_style(element, "font-family", "\"Cascadia Mono\", Consolas, monospace")
  set_style(element, "font-size", "11px")
  set_style(element, "line-height", "1.45")
  set_style(element, "white-space", "pre")
  set_style(element, "overflow-x", "auto")
  set_style(element, "overflow-y", "hidden")
}

///|
fn style_markdown_code_block_code(element : @dom.Element) -> Unit {
  set_style(element, "display", "block")
  set_style(element, "min-width", "max-content")
}

///|
fn style_markdown_math(element : @dom.Element) -> Unit {
  set_style(
    element, "font-family", "\"Cambria Math\", \"Times New Roman\", serif",
  )
  set_style(element, "color", "#24384f")
  set_style(element, "line-height", "1.35")
  set_style(element, "max-width", "100%")
  set_style(element, "box-sizing", "border-box")
}

///|
fn style_markdown_math_inline(element : @dom.Element) -> Unit {
  set_style(element, "display", "inline-flex")
  set_style(element, "align-items", "center")
  set_style(element, "vertical-align", "middle")
  set_style(element, "padding", "0 2px")
}

///|
fn style_markdown_math_block(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "justify-content", "center")
  set_style(element, "width", "100%")
  set_style(element, "padding", "6px 4px")
  set_style(element, "text-align", "center")
  set_style(element, "overflow-x", "auto")
  set_style(element, "overflow-y", "hidden")
  set_style(element, "font-size", "1.05em")
}

///|
fn style_markdown_math_frac(element : @dom.Element) -> Unit {
  set_style(element, "display", "inline-flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "align-items", "stretch")
  set_style(element, "vertical-align", "middle")
  set_style(element, "margin", "0 2px")
  set_style(element, "line-height", "1.1")
}

///|
fn style_markdown_math_frac_num(element : @dom.Element) -> Unit {
  set_style(element, "border-bottom", "1px solid currentColor")
  set_style(element, "padding", "0 4px 2px")
  set_style(element, "text-align", "center")
}

///|
fn style_markdown_math_frac_den(element : @dom.Element) -> Unit {
  set_style(element, "padding", "2px 4px 0")
  set_style(element, "text-align", "center")
}

///|
fn style_markdown_math_sqrt(element : @dom.Element) -> Unit {
  set_style(element, "display", "inline-flex")
  set_style(element, "align-items", "stretch")
  set_style(element, "vertical-align", "middle")
  set_style(element, "margin", "0 2px")
}

///|
fn style_markdown_math_sqrt_symbol(element : @dom.Element) -> Unit {
  set_style(element, "font-size", "1.2em")
  set_style(element, "line-height", "1")
  set_style(element, "padding-right", "1px")
}

///|
fn style_markdown_math_sqrt_radicand(element : @dom.Element) -> Unit {
  set_style(element, "border-top", "1px solid currentColor")
  set_style(element, "padding", "0 2px")
}

///|
fn style_markdown_task(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "align-items", "flex-start")
  set_style(element, "gap", "6px")
  set_style(element, "margin", "0")
}

///|
fn style_markdown_task_title(element : @dom.Element) -> Unit {
  set_style(element, "display", "inline-flex")
  set_style(element, "align-items", "center")
}

///|
fn style_markdown_task_check(element : @dom.Element) -> Unit {
  set_style(element, "width", "13px")
  set_style(element, "height", "13px")
  set_style(element, "margin", "2px 0 0 0")
  set_style(element, "flex", "0 0 auto")
}

///|
fn style_markdown_table(element : @dom.Element) -> Unit {
  set_style(element, "width", "100%")
  set_style(element, "border-collapse", "collapse")
  set_style(element, "font-size", "11px")
  set_style(element, "line-height", "1.35")
  set_style(element, "overflow", "hidden")
}

///|
fn style_markdown_table_cell(element : @dom.Element, is_header : Bool) -> Unit {
  set_style(element, "padding", "3px 5px")
  set_style(element, "border", "1px solid rgba(167, 190, 214, 0.5)")
  set_style(element, "vertical-align", "top")
  set_style(element, "word-break", "break-word")
  if is_header {
    set_style(element, "font-weight", "800")
    set_style(element, "background", "rgba(214, 230, 245, 0.5)")
  }
}

///|
fn style_node_note_rail(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "align-items", "center")
  set_style(element, "gap", "6px")
  set_style(element, "margin-top", "8px")
  set_style(element, "width", "100%")
  set_style(element, "position", "relative")
  set_style(element, "z-index", "1")
}

///|
fn style_node_note_editor(element : @dom.Element) -> Unit {
  set_style(element, "width", "100%")
  set_style(element, "min-height", "72px")
  set_style(element, "box-sizing", "border-box")
  set_style(element, "padding", "0")
  set_style(element, "margin", "0")
  set_style(element, "border", "0")
  set_style(element, "background", "transparent")
  set_style(element, "resize", "vertical")
  set_style(element, "color", "inherit")
  set_style(element, "font", "inherit")
  set_style(element, "line-height", "1.5")
  set_style(element, "outline", "none")
}

///|
fn style_node_editor(element : @dom.Element) -> Unit {
  set_style(element, "width", "100%")
  set_style(element, "border", "2px solid rgba(26, 122, 114, 0.22)")
  set_style(element, "border-radius", "10px")
  set_style(element, "padding", "8px 10px")
  set_style(element, "font", "inherit")
  set_style(element, "background", "rgba(248, 251, 254, 0.92)")
  set_style(element, "box-sizing", "border-box")
}

///|
fn style_node_selected(element : @dom.Element) -> Unit {
  if has_class_name(element, "node--branch-line") {
    set_style(element, "border-bottom-color", "rgba(44, 112, 206, 0.95)")
    set_style(element, "box-shadow", "0 3px 0 rgba(44, 112, 206, 0.22)")
    return
  }
  set_style(element, "border-color", "rgba(44, 112, 206, 0.95)")
  set_style(
    element, "box-shadow", "inset 0 0 0 1px rgba(255, 255, 255, 0.8), 0 0 0 2px rgba(44, 112, 206, 0.42)",
  )
}

///|
fn style_node_actions(element : @dom.Element) -> Unit {
  set_style(element, "position", "absolute")
  set_style(element, "display", "flex")
  set_style(element, "gap", "6px")
  set_style(element, "z-index", "2")
  style_node_actions_corner(element)
}

///|
fn style_node_actions_left_mid(element : @dom.Element) -> Unit {
  set_style(element, "top", "50%")
  set_style(element, "left", "0")
  set_style(element, "right", "auto")
  set_style(element, "bottom", "auto")
  set_style(element, "transform", "translate(-50%, -50%)")
  match element.closest(".node--branch-line") {
    Some(_) => {
      set_style(element, "top", "100%")
      set_style(element, "left", "15px")
      set_style(element, "transform", "translate(-50%, -50%)")
    }
    None => ()
  }
}

///|
fn style_node_actions_right_mid(element : @dom.Element) -> Unit {
  set_style(element, "top", "50%")
  set_style(element, "right", "0")
  set_style(element, "left", "auto")
  set_style(element, "bottom", "auto")
  set_style(element, "transform", "translate(50%, -50%)")
  match element.closest(".node--branch-line") {
    Some(_) => {
      set_style(element, "top", "100%")
      set_style(element, "right", "15px")
      set_style(element, "transform", "translate(50%, -50%)")
    }
    None => ()
  }
}

///|
fn style_node_actions_branch_line(element : @dom.Element) -> Unit {
  set_style(element, "top", "100%")
  set_style(element, "bottom", "auto")
  if has_class_name(element, "node-actions--left-mid") {
    set_style(element, "left", "0")
    set_style(element, "right", "auto")
    set_style(element, "transform", "translate(-50%, -50%)")
  } else if has_class_name(element, "node-actions--bottom-center") {
    set_style(element, "left", "50%")
    set_style(element, "right", "auto")
    set_style(element, "top", "calc(100% + 15px)")
    set_style(element, "transform", "translate(-50%, -50%)")
  } else {
    set_style(element, "right", "0")
    set_style(element, "left", "auto")
    set_style(element, "transform", "translate(50%, -50%)")
  }
}

///|
fn style_node_actions_top_center(element : @dom.Element) -> Unit {
  set_style(element, "top", "0")
  set_style(element, "left", "50%")
  set_style(element, "right", "auto")
  set_style(element, "bottom", "auto")
  set_style(element, "transform", "translate(-50%, -50%)")
}

///|
fn style_node_actions_bottom_center(element : @dom.Element) -> Unit {
  set_style(element, "bottom", "0")
  set_style(element, "left", "50%")
  set_style(element, "right", "auto")
  set_style(element, "top", "auto")
  set_style(element, "transform", "translate(-50%, 50%)")
}

///|
fn style_node_actions_corner(element : @dom.Element) -> Unit {
  set_style(element, "top", "8px")
  set_style(element, "right", "8px")
  set_style(element, "left", "auto")
  set_style(element, "bottom", "auto")
  set_style(element, "transform", "none")
}

///|
fn style_node_action(element : @dom.Element) -> Unit {
  set_style(element, "width", "24px")
  set_style(element, "height", "24px")
  set_style(element, "padding", "0")
  set_style(element, "border", "0")
  set_style(element, "border-radius", "999px")
  set_style(element, "background", "rgba(26, 122, 114, 0.12)")
  set_style(element, "color", "#5c88a8")
  set_style(element, "font-size", "12px")
  set_style(element, "font-weight", "700")
  set_style(element, "display", "inline-flex")
  set_style(element, "align-items", "center")
  set_style(element, "justify-content", "center")
  set_style(element, "line-height", "1")
  if has_class_name(element, "node-action--toggle") {
    set_style(element, "border", "2px solid rgba(95, 143, 190, 0.92)")
    set_style(element, "background", "rgba(255, 255, 255, 0.98)")
    set_style(element, "color", "rgba(95, 143, 190, 0.92)")
  }
  match element.closest(".node--branch-line") {
    Some(_) =>
      if has_class_name(element, "node-action--toggle") {
        set_style(element, "width", "15px")
        set_style(element, "height", "15px")
        set_style(element, "min-width", "15px")
        set_style(element, "padding", "0")
        set_style(
          element, "border", "1.5px solid var(--mindmap-connector-color, #94b6db)",
        )
        set_style(element, "background", "#ffffff")
        set_style(element, "color", "var(--mindmap-connector-color, #94b6db)")
        set_style(element, "font-size", "8px")
        set_style(element, "line-height", "1")
        set_style(element, "box-shadow", "none")
      }
    None => ()
  }
  match element.closest(".mindmap-stage--fill") {
    Some(_) => {
      set_style(element, "background", "rgba(39, 64, 92, 0.12)")
      set_style(element, "color", "rgba(39, 64, 92, 0.62)")
      set_style(element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.3)")
    }
    None => ()
  }
  match element.closest(".node--branch-line") {
    Some(_) =>
      if has_class_name(element, "node-action--toggle") {
        set_style(element, "width", "20px")
        set_style(element, "height", "20px")
        set_style(element, "min-width", "20px")
        set_style(element, "max-width", "20px")
        set_style(element, "max-height", "20px")
        set_style(element, "flex", "0 0 20px")
        set_style(element, "box-sizing", "border-box")
        set_style(element, "overflow", "hidden")
        set_style(
          element, "border", "1.6px solid var(--mindmap-connector-color, #94b6db)",
        )
        set_style(element, "background", "#ffffff")
        set_style(element, "color", "var(--mindmap-connector-color, #94b6db)")
        set_style(element, "font-size", "0")
        set_style(element, "text-indent", "-999px")
        set_style(element, "box-shadow", "none")
      }
    None => ()
  }
}

///|
fn style_node_action_toggle(element : @dom.Element) -> Unit {
  set_style(element, "border", "2px solid rgba(95, 143, 190, 0.92)")
  set_style(element, "background", "rgba(255, 255, 255, 0.98)")
  set_style(element, "color", "rgba(95, 143, 190, 0.92)")
  match element.closest(".mindmap-stage--fill") {
    Some(_) => {
      set_style(element, "border", "3px solid var(--fill-branch)")
      set_style(element, "background", "rgba(255, 255, 255, 0.98)")
      set_style(element, "color", "var(--fill-branch)")
      set_style(element, "box-shadow", "0 0 0 2px rgba(255, 255, 255, 0.42)")
    }
    None => ()
  }
  match element.closest(".node--branch-line") {
    Some(_) => {
      set_style(element, "width", "20px")
      set_style(element, "height", "20px")
      set_style(element, "min-width", "20px")
      set_style(element, "max-width", "20px")
      set_style(element, "max-height", "20px")
      set_style(element, "flex", "0 0 20px")
      set_style(element, "box-sizing", "border-box")
      set_style(element, "overflow", "hidden")
      set_style(element, "padding", "0")
      set_style(
        element, "border", "1.6px solid var(--mindmap-connector-color, #94b6db)",
      )
      set_style(element, "background", "#ffffff")
      set_style(element, "color", "var(--mindmap-connector-color, #94b6db)")
      set_style(element, "font-size", "0")
      set_style(element, "text-indent", "-999px")
      set_style(element, "box-shadow", "none")
    }
    None => ()
  }
}

///|
fn style_node_action_branch_line(element : @dom.Element) -> Unit {
  set_style(element, "width", "20px")
  set_style(element, "height", "20px")
  set_style(element, "min-width", "20px")
  set_style(element, "max-width", "20px")
  set_style(element, "max-height", "20px")
  set_style(element, "flex", "0 0 20px")
  set_style(element, "box-sizing", "border-box")
  set_style(element, "overflow", "hidden")
  set_style(element, "padding", "0")
  set_style(
    element, "border", "1.6px solid var(--mindmap-connector-color, #94b6db)",
  )
  set_style(element, "border-radius", "999px")
  set_style(element, "background", "#ffffff")
  set_style(element, "color", "var(--mindmap-connector-color, #94b6db)")
  set_style(element, "line-height", "1")
  if has_class_name(element, "node-action--collapsed") {
    set_style(element, "font-size", "9px")
    set_style(element, "font-weight", "700")
    set_style(element, "text-indent", "0")
  } else {
    set_style(element, "font-size", "0")
    set_style(element, "text-indent", "-999px")
  }
  set_style(element, "box-shadow", "none")
}

///|
fn style_node_action_collapsed(element : @dom.Element) -> Unit {
  set_style(element, "min-width", "28px")
  set_style(element, "width", "auto")
  set_style(element, "padding", "0 7px")
  match element.closest(".node--branch-line") {
    Some(_) => {
      set_style(element, "min-width", "20px")
      set_style(element, "width", "20px")
      set_style(element, "height", "20px")
      set_style(element, "max-width", "20px")
      set_style(element, "max-height", "20px")
      set_style(element, "flex", "0 0 20px")
      set_style(element, "box-sizing", "border-box")
      set_style(element, "overflow", "hidden")
      set_style(element, "padding", "0")
      set_style(element, "font-size", "9px")
      set_style(element, "font-weight", "700")
      set_style(element, "text-indent", "0")
    }
    None => ()
  }
}

///|
fn style_node_action_danger(element : @dom.Element) -> Unit {
  set_style(element, "color", "var(--red)")
  set_style(element, "background", "rgba(239, 79, 67, 0.14)")
}

///|
fn style_collapsed_node(element : @dom.Element) -> Unit {
  set_style(element, "min-width", "22px")
  set_style(element, "width", "auto")
  set_style(element, "height", "16px")
  set_style(element, "padding", "0 5px")
  set_style(element, "border-radius", "999px")
  set_style(element, "border", "2px solid #6f9ccd")
  set_style(element, "background", "rgba(255, 255, 255, 0.98)")
  set_style(element, "color", "#5f8fbe")
  set_style(element, "box-shadow", "none")
  set_style(element, "font-size", "9px")
  set_style(element, "font-weight", "700")
  set_style(element, "line-height", "1")
  set_style(element, "display", "inline-flex")
  set_style(element, "align-items", "center")
  set_style(element, "justify-content", "center")
  set_style(element, "cursor", "pointer")
  match element.closest(".mindmap-stage--fill") {
    Some(_) => {
      set_style(element, "border", "2px solid var(--fill-branch)")
      set_style(element, "color", "var(--fill-branch)")
    }
    None => ()
  }
}

///|
fn style_node_dragging(element : @dom.Element) -> Unit {
  set_style(element, "opacity", "0.45")
}

///|
fn style_mindmap_stage_svg_connectors(element : @dom.Element) -> Unit {
  set_style(element, "z-index", "1")
  for node_actions in element.querySelectorAll(".node-actions") {
    set_style(node_actions, "display", "none")
  }
  for node_small in element.querySelectorAll(".node small") {
    set_style(node_small, "display", "none")
  }
}

///|
fn style_drop_slot(element : @dom.Element) -> Unit {
  set_style(element, "width", "100%")
  set_style(element, "min-height", "12px")
}

///|
fn style_single_right_drop_slot(element : @dom.Element) -> Unit {
  match is_single_right_drop_slot(element) {
    true => {
      set_style(element, "width", "0")
      set_style(element, "min-width", "0")
      set_style(element, "min-height", "0")
      set_style(element, "height", "0")
      set_style(element, "overflow", "hidden")
      set_style(element, "flex", "0 0 0")
    }
    false => ()
  }
}

///|
fn style_drop_before(element : @dom.Element) -> Unit {
  set_style(
    element, "box-shadow", "inset 0 4px 0 var(--mindmap-connector-accent, #5c88a8), 0 14px 28px rgba(120, 139, 164, 0.1)",
  )
}

///|
fn style_drop_after(element : @dom.Element) -> Unit {
  set_style(
    element, "box-shadow", "inset 0 -4px 0 var(--mindmap-connector-accent, #5c88a8), 0 14px 28px rgba(120, 139, 164, 0.1)",
  )
}

///|
fn style_zoom_strip(element : @dom.Element) -> Unit {
  set_style(element, "display", "inline-flex")
  set_style(element, "align-items", "center")
  set_style(element, "gap", "6px")
  set_style(element, "width", "140px")
  set_style(element, "height", "40px")
  set_style(element, "padding", "4px")
  set_style(element, "border-radius", "14px")
  set_style(element, "border", "1px solid rgba(214, 225, 237, 0.76)")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.7), rgba(245, 249, 253, 0.42))",
  )
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.9), 0 10px 24px rgba(120, 139, 164, 0.08)",
  )
}

///|
fn style_zoom_value(element : @dom.Element) -> Unit {
  set_style(element, "flex", "1")
  set_style(element, "min-width", "0")
  set_style(element, "text-align", "center")
  set_style(element, "color", "rgba(114, 135, 160, 1)")
  set_style(element, "font-size", "13px")
  set_style(element, "font-weight", "600")
  set_style(element, "letter-spacing", "-0.01em")
  set_style(element, "line-height", "1")
  set_style(element, "font-variant-numeric", "tabular-nums")
  set_style(element, "cursor", "text")
}

///|
fn style_zoom_edit(element : @dom.Element) -> Unit {
  set_style(element, "display", "none")
  set_style(element, "flex", "1")
  set_style(element, "min-width", "0")
  set_style(element, "height", "100%")
  set_style(element, "border", "0")
  set_style(element, "padding", "0 2px")
  set_style(element, "background", "transparent")
  set_style(element, "color", "#23384d")
  set_style(element, "font", "inherit")
  set_style(element, "font-size", "13px")
  set_style(element, "line-height", "1")
  set_style(element, "text-align", "center")
  set_style(element, "font-variant-numeric", "tabular-nums")
  set_style(element, "outline", "none")
  set_style(element, "caret-color", "#5c88a8")
}

///|
fn style_tooltip_layer(element : @dom.Element) -> Unit {
  set_style(element, "position", "fixed")
  set_style(element, "inset", "0")
  set_style(element, "pointer-events", "none")
  set_style(element, "z-index", "9999")
}

///|
fn style_tooltip(element : @dom.Element) -> Unit {
  set_style(element, "position", "fixed")
  set_style(element, "left", "0")
  set_style(element, "top", "0")
  set_style(element, "max-width", "320px")
  set_style(element, "padding", "8px 10px")
  set_style(element, "border-radius", "10px")
  set_style(element, "background", "rgba(27, 39, 53, 0.95)")
  set_style(element, "color", "#f6fbff")
  set_style(element, "box-shadow", "0 12px 28px rgba(26, 39, 56, 0.22)")
  set_style(element, "backdrop-filter", "blur(10px)")
  set_style(element, "opacity", "0")
  set_style(element, "visibility", "hidden")
  set_style(element, "transform", "translate(-9999px, -9999px)")
  set_style(element, "transition", "none")
  set_style(element, "pointer-events", "none")
}

///|
fn style_tooltip_text(element : @dom.Element) -> Unit {
  set_style(element, "display", "block")
  set_style(element, "font-size", "12px")
  set_style(element, "line-height", "1.45")
  set_style(element, "font-weight", "500")
  set_style(element, "white-space", "pre-wrap")
  set_style(element, "word-break", "break-word")
}

///|
fn style_zoom_strip_editing(element : @dom.Element) -> Unit {
  set_style(element, "display", "inline-flex")
  match element.querySelector(".zoom-value") {
    Some(value) => set_style(value, "display", "none")
    None => ()
  }
  match element.querySelector(".zoom-edit") {
    Some(edit) => set_style(edit, "display", "block")
    None => ()
  }
}

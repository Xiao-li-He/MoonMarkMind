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
      style.set_property("height", "100vh")
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
  if has_class_name(element, "editor-panel") {
    style_editor_panel(element)
  }
  if has_class_name(element, "editor-surface") {
    style_card_surface(element)
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
  if has_class_name(element, "single-right-tree__head") {
    style_single_right_tree_head(element)
  }
  if has_class_name(element, "single-right-tree__children") {
    style_single_right_tree_children(element)
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
  if has_class_name(element, "is-selected") {
    style_node_selected(element)
  }
  if tag == "SMALL" {
    style_node_kicker(element)
  }
  if tag == "STRONG" {
    style_node_title(element)
  }
  if has_class_name(element, "node-editor") {
    style_node_editor(element)
  }
  if has_class_name(element, "node-actions") {
    style_node_actions(element)
  }
  if has_class_name(element, "node-action") {
    style_node_action(element)
  }
  if has_class_name(element, "node-action--toggle") {
    style_node_action_toggle(element)
  }
  if has_class_name(element, "node-action--collapsed") {
    style_node_action_collapsed(element)
  }
  if has_class_name(element, "collapsed-node") {
    style_collapsed_node(element)
  }
  if has_class_name(element, "is-dragging") {
    style_node_dragging(element)
  }
  if has_class_name(element, "drop-slot") {
    style_drop_slot(element)
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
}

///|
fn apply_tool_select_custom_theme(custom : @dom.Element, muted : Bool) -> Unit {
  style_tool_select_custom(custom)
  let open = has_class_name(custom, "is-open")
  match custom.querySelector(".tool-select-trigger") {
    Some(trigger) => {
      style_tool_select_trigger(trigger)
      let trigger_style = style_of(trigger)
      trigger_style.set_property(
        "color",
        if muted {
          "#92a4b8"
        } else {
          "#23384d"
        },
      )
      if open {
        trigger_style.set_property("border-color", "rgba(192, 208, 226, 0.96)")
        trigger_style.set_property(
          "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.84), rgba(244, 249, 253, 0.6))",
        )
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
  set_style(element, "--left-pane-percent", "33%")
  set_style(element, "--mindmap-toolbar-actions-width", "390px")
  set_style(element, "--mindmap-toolbar-min-width", "412px")
  set_style(element, "display", "grid")
  set_style(
    element, "grid-template-columns", "minmax(300px, var(--left-pane-percent)) 14px minmax(var(--mindmap-toolbar-min-width), 1fr)",
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
  set_style(element, "color", "var(--teal)")
  set_style(element, "font-size", "14px")
  set_style(element, "line-height", "1")
  set_style(element, "white-space", "nowrap")
  set_style(element, "cursor", "pointer")
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
  set_style(element, "color", "var(--teal)")
  set_style(element, "font-size", "14px")
  set_style(element, "line-height", "1")
  set_style(element, "white-space", "nowrap")
  set_style(element, "cursor", "default")
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
  set_style(element, "color", "var(--teal)")
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
  set_style(element, "color", "#7287a0")
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
  set_style(element, "color", "#23384d")
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.88), 0 10px 24px rgba(120, 139, 164, 0.08)",
  )
  set_style(element, "cursor", "pointer")
}

///|
fn style_tool_select_native(element : @dom.Element) -> Unit {
  set_style(element, "display", "none")
}

///|
fn style_tool_select_custom(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
  set_style(element, "display", "inline-flex")
  let open = has_class_name(element, "is-open")
  match element.querySelector(".tool-select-menu") {
    Some(menu) =>
      if open {
        set_style(menu, "opacity", "1")
        set_style(menu, "visibility", "visible")
        set_style(menu, "transform", "translateY(0)")
      } else {
        set_style(menu, "opacity", "0")
        set_style(menu, "visibility", "hidden")
        set_style(menu, "transform", "translateY(-6px)")
      }
    None => ()
  }
}

///|
fn style_tool_select_trigger(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
  set_style(element, "min-width", "96px")
  set_style(element, "height", "40px")
  set_style(element, "padding", "0 34px 0 12px")
  set_style(element, "border", "1px solid rgba(214, 225, 237, 0.76)")
  set_style(element, "border-radius", "15px")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.7), rgba(245, 249, 253, 0.42))",
  )
  set_style(element, "color", "#23384d")
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.88), 0 10px 24px rgba(120, 139, 164, 0.08)",
  )
  set_style(element, "cursor", "pointer")
}

///|
fn style_tool_select_menu(element : @dom.Element) -> Unit {
  set_style(element, "position", "absolute")
  set_style(element, "top", "calc(100% + 6px)")
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
  set_style(element, "cursor", "pointer")
}

///|
fn style_editor_panel(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "min-width", "0")
  set_style(element, "min-height", "0")
  set_style(element, "height", "100%")
  set_style(element, "grid-column", "1")
}

///|
fn style_card_surface(element : @dom.Element) -> Unit {
  set_style(element, "display", "grid")
  set_style(element, "grid-template-rows", "auto 1fr")
  set_style(element, "height", "100%")
  set_style(element, "min-height", "0")
  set_style(element, "min-width", "0")
  set_style(element, "border-radius", "0")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.5), rgba(248, 251, 255, 0.34))",
  )
  set_style(
    element, "box-shadow", "inset 0 1px 0 rgba(255, 255, 255, 0.82), 0 18px 40px rgba(120, 139, 164, 0.08)",
  )
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
  set_style(element, "gap", "7px")
}

///|
fn style_dot(element : @dom.Element) -> Unit {
  set_style(element, "width", "10px")
  set_style(element, "height", "10px")
  set_style(element, "border-radius", "999px")
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
  set_style(element, "min-height", "0")
  set_style(element, "height", "100%")
}

///|
fn style_editor_gutter_wrap(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
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
  set_style(element, "min-width", "0")
  set_style(element, "min-height", "0")
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
  set_style(element, "width", "100%")
  set_style(element, "height", "100%")
  set_style(element, "min-height", "0")
  set_style(element, "resize", "none")
  set_style(element, "border", "0")
  set_style(element, "padding", "18px 18px 22px 16px")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.08), rgba(255, 255, 255, 0)), repeating-linear-gradient(180deg, transparent 0, transparent 27px, rgba(198, 213, 228, 0.86) 27px, rgba(198, 213, 228, 0.86) 28px, transparent 28px)",
  )
  set_style(element, "background-attachment", "local, local")
  set_style(element, "background-repeat", "no-repeat, repeat")
  set_style(element, "color", "#23384d")
  set_style(
    element, "font", "16px/28px \"Cascadia Code\", \"Consolas\", monospace",
  )
  set_style(element, "overflow", "auto")
  set_style(element, "overflow-x", "hidden")
  set_style(element, "caret-color", "#5e86b5")
  set_style(element, "tab-size", "2")
  set_style(element, "outline", "none")
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
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.28), rgba(240, 246, 251, 0.16))",
  )
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
}

///|
fn style_mindmap_toolbar(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-wrap", "wrap")
  set_style(element, "align-items", "flex-start")
  set_style(element, "justify-content", "space-between")
  set_style(element, "column-gap", "8px")
  set_style(element, "row-gap", "10px")
  set_style(element, "padding", "0 2px 4px")
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
  set_style(element, "gap", "10px")
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
  set_style(element, "border", "2px dashed rgba(187, 203, 221, 0.52)")
  set_style(element, "border-radius", "26px")
  set_style(
    element, "background", "linear-gradient(180deg, rgba(255, 255, 255, 0.28), rgba(248, 251, 254, 0.14))",
  )
  set_style(element, "box-shadow", "none")
  set_style(element, "height", "100%")
}

///|
fn style_mindmap(element : @dom.Element) -> Unit {
  set_style(element, "--pan-x", "0px")
  set_style(element, "--pan-y", "0px")
  set_style(element, "--zoom", "1")
  set_style(element, "position", "relative")
  set_style(element, "height", "100%")
  set_style(element, "min-height", "0")
  set_style(element, "min-width", "0")
  set_style(element, "padding", "6px 2px 2px")
  set_style(element, "overflow", "hidden")
  set_style(element, "cursor", "grab")
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
  set_style(element, "gap", "44px")
  set_style(element, "align-items", "center")
  set_style(element, "min-width", "980px")
  set_style(element, "min-height", "940px")
  set_style(element, "padding", "44px 24px 40px")
}

///|
fn style_mindmap_stage_vertical(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "align-items", "center")
  set_style(element, "gap", "24px")
  set_style(element, "min-width", "720px")
}

///|
fn style_mindmap_stage_single_right(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "align-items", "flex-start")
  set_style(element, "gap", "18px")
  set_style(element, "min-width", "860px")
}

///|
fn style_mindmap_connector_layer(element : @dom.Element) -> Unit {
  set_style(element, "z-index", "0")
  set_style(element, "mix-blend-mode", "multiply")
  set_style(element, "opacity", "0.92")
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
  set_style(element, "gap", "26px")
  set_style(element, "min-height", "460px")
  set_style(element, "padding-top", "26px")
}

///|
fn style_branch_column_root(element : @dom.Element) -> Unit {
  set_style(element, "position", "relative")
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
  set_style(element, "min-width", "220px")
  set_style(element, "padding", "0 20px")
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
  set_style(element, "transform", "translateY(-50%)")
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
  set_style(element, "align-items", "flex-start")
  set_style(element, "gap", "34px")
}

///|
fn style_branch_item_head(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "align-items", "flex-start")
  set_style(element, "flex-direction", "column")
}

///|
fn style_branch_children(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "gap", "18px")
  set_style(element, "position", "relative")
}

///|
fn style_branch_children_left(element : @dom.Element) -> Unit {
  set_style(element, "align-items", "flex-end")
  set_style(element, "margin-right", "18px")
}

///|
fn style_branch_children_right(element : @dom.Element) -> Unit {
  set_style(element, "align-items", "flex-start")
  set_style(element, "margin-left", "18px")
}

///|
fn style_vertical_root(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "align-items", "center")
  set_style(element, "min-width", "720px")
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
  set_style(element, "flex-direction", "column")
  set_style(element, "align-items", "center")
  set_style(element, "gap", "18px")
  set_style(element, "padding-top", "26px")
  set_style(element, "position", "relative")
}

///|
fn style_vertical_tree_child(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "justify-content", "center")
  set_style(element, "min-width", "0")
}

///|
fn style_single_right_tree(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "gap", "18px")
}

///|
fn style_single_right_tree_node(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "align-items", "flex-start")
  set_style(element, "gap", "26px")
}

///|
fn style_single_right_tree_head(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "justify-content", "flex-start")
  set_style(element, "position", "relative")
  set_style(element, "flex-direction", "column")
}

///|
fn style_single_right_tree_children(element : @dom.Element) -> Unit {
  set_style(element, "display", "flex")
  set_style(element, "flex-direction", "column")
  set_style(element, "gap", "18px")
  set_style(element, "padding-left", "32px")
  set_style(element, "position", "relative")
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
  match element.closest(".node") {
    Some(node) => {
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
  set_style(element, "border-color", "rgba(44, 112, 206, 0.95)")
  set_style(
    element, "box-shadow", "inset 0 0 0 1px rgba(255, 255, 255, 0.8), 0 0 0 2px rgba(44, 112, 206, 0.42)",
  )
}

///|
fn style_node_actions(element : @dom.Element) -> Unit {
  set_style(element, "position", "absolute")
  set_style(element, "top", "8px")
  set_style(element, "right", "8px")
  set_style(element, "display", "flex")
  set_style(element, "gap", "6px")
  set_style(element, "z-index", "2")
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
}

///|
fn style_node_action_toggle(element : @dom.Element) -> Unit {
  set_style(element, "border", "2px solid rgba(95, 143, 190, 0.92)")
  set_style(element, "background", "rgba(255, 255, 255, 0.98)")
  set_style(element, "color", "rgba(95, 143, 190, 0.92)")
}

///|
fn style_node_action_collapsed(element : @dom.Element) -> Unit {
  set_style(element, "min-width", "28px")
  set_style(element, "width", "auto")
  set_style(element, "padding", "0 7px")
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
fn style_drop_before(element : @dom.Element) -> Unit {
  set_style(
    element, "box-shadow", "inset 0 4px 0 #5c88a8, 0 14px 28px rgba(120, 139, 164, 0.1)",
  )
}

///|
fn style_drop_after(element : @dom.Element) -> Unit {
  set_style(
    element, "box-shadow", "inset 0 -4px 0 #5c88a8, 0 14px 28px rgba(120, 139, 164, 0.1)",
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

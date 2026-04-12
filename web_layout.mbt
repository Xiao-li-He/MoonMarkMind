///|
priv struct SelectOption {
  value : String
  label : String
  hidden : Bool
  selected : Bool
}

///|
fn mount_app_shell() -> Unit {
  apply_page_theme()
  match get_element_by_id("app") {
    Some(app) => {
      clear_element(app)
      append_child(app, build_app_shell())
      localize_layout_select_labels()
    }
    None => ()
  }
}

///|
fn set_workspace_split(percent : Int) -> Unit {
  match get_element(".workspace") {
    Some(workspace) => {
      let style = @dom.css_style_from_val(
        workspace.as_any()._get("style").cast(),
      )
      style.set_property("--left-pane-percent", "\{percent}%")
    }
    None => ()
  }
}

///|
fn read_workspace_split() -> Int? {
  match get_element(".workspace") {
    Some(workspace) => {
      let style = @dom.css_style_from_val(
        workspace.as_any()._get("style").cast(),
      )
      let raw = style.get_property_value("--left-pane-percent")
      if raw.length() == 0 {
        None
      } else {
        let cleaned = raw.replace(old="%", new="").trim().to_string()
        Some(@strconv.parse_int(cleaned) catch { _ => -1 })
      }
    }
    None => None
  }
}

///|
fn set_select_value(id : String, value : String) -> Unit {
  match get_element_by_id(id) {
    Some(control) => {
      let select = @dom.HTMLSelectElement::cast_from_element(control)
      select.value = value
      sync_custom_select_by_id(id)
    }
    None => ()
  }
}

///|
fn set_select_muted(id : String, muted : Bool) -> Unit {
  match get_element_by_id(id) {
    Some(control) => {
      toggle_class(control, "tool-select--muted", muted)
      sync_custom_select_by_id(id)
      apply_theme_to_element(control)
    }
    None => ()
  }
}

///|
fn set_select_disabled(id : String, disabled : Bool) -> Unit {
  match get_element_by_id(id) {
    Some(control) => {
      let disabled_text = disabled.to_string()
      control.setAttribute("data-disabled", disabled_text)
      control.setAttribute("aria-disabled", disabled_text)
      toggle_class(control, "tool-select--disabled", disabled)
      sync_custom_select_by_id(id)
      apply_theme_to_element(control)
    }
    None => ()
  }
}

///|
fn localize_layout_select_labels() -> Unit {
  set_select_option_text("layout-select", "mindmap", "思维图")
  set_select_option_text("layout-select", "logic", "逻辑图")
  set_select_option_text("layout-select", "tree", "树状图")
  sync_custom_select_by_id("layout-select")
}

///|
fn set_select_option_text(id : String, value : String, text : String) -> Unit {
  match get_element_by_id(id) {
    Some(control) => {
      let select = @dom.HTMLSelectElement::cast_from_element(control)
      for child in select.children() {
        let option = @dom.HTMLOptionElement::cast_from_element(child)
        if option.value == value {
          option.setTextContent(text)
        }
      }
    }
    None => ()
  }
}

///|
fn set_toolbar_selection_enabled(enabled : Bool) -> Unit {
  for button in @dom.document().querySelectorAll("[data-toolbar-action]") {
    let disabled = (!enabled).to_string()
    button.setAttribute("data-disabled", disabled)
    button.setAttribute("aria-disabled", disabled)
    toggle_class(button, "mindmap-tool--disabled", !enabled)
    apply_theme_to_element(button)
  }
}

///|
fn set_toolbar_action_enabled(action : String, enabled : Bool) -> Unit {
  match get_element("[data-toolbar-action=\"\{action}\"]") {
    Some(button) => {
      let disabled = (!enabled).to_string()
      button.setAttribute("data-disabled", disabled)
      button.setAttribute("aria-disabled", disabled)
      toggle_class(button, "mindmap-tool--disabled", !enabled)
      apply_theme_to_element(button)
    }
    None => ()
  }
}

///|
fn set_aux_action_enabled(id : String, enabled : Bool) -> Unit {
  match get_element_by_id(id) {
    Some(button) => {
      let disabled = (!enabled).to_string()
      button.setAttribute("data-disabled", disabled)
      button.setAttribute("aria-disabled", disabled)
      toggle_class(button, "mindmap-aux-button--disabled", !enabled)
      apply_theme_to_element(button)
    }
    None => ()
  }
}

///|
fn set_editor_document_name(value : String) -> Unit {
  match get_element(".editor-chrome__badge") {
    Some(badge) => badge.setTextContent(value)
    None => ()
  }
}

///|
fn build_app_shell() -> @dom.Element {
  let shell = create_element("main", "app-shell")
  append_child(shell, build_topbar())
  let workspace = create_element("section", "workspace")
  append_child(workspace, build_editor_panel())
  append_child(workspace, build_workspace_divider())
  append_child(workspace, build_mindmap_panel())
  append_child(shell, workspace)
  append_child(shell, build_tooltip_layer())
  shell
}

///|
fn build_tooltip_layer() -> @dom.Element {
  let layer = create_element("div", "tooltip-layer")
  layer.setAttribute("id", "tooltip-layer")
  layer.setAttribute("aria-hidden", "true")
  let tip = create_element("div", "tooltip")
  tip.setAttribute("id", "tooltip")
  tip.setAttribute("role", "tooltip")
  append_child(tip, build_text_span("span", "tooltip__text", ""))
  append_child(layer, tip)
  layer
}

///|
fn build_topbar() -> @dom.Element {
  let topbar = create_element("header", "topbar")
  let left_group = create_element("div", "topbar-group")
  append_child(
    left_group,
    build_text_span("span", "brand-title", "MoonMarkMind"),
  )
  append_child(left_group, build_text_span("span", "section-title", "文档"))
  append_child(
    left_group,
    build_button(
      "tool-button tool-button--blue", "download-markdown", "下载 Markdown", "导出",
    ),
  )
  append_child(
    left_group,
    build_select_control(
      id="sample-select",
      label="示例",
      class_name="tool-select",
      options=[
        SelectOption::{
          value: "custom",
          label: "自定义",
          hidden: true,
          selected: false,
        },
        SelectOption::{
          value: "part1",
          label: "片段一",
          hidden: false,
          selected: true,
        },
        SelectOption::{
          value: "part2",
          label: "片段二",
          hidden: false,
          selected: false,
        },
        SelectOption::{
          value: "part3",
          label: "片段三",
          hidden: false,
          selected: false,
        },
        SelectOption::{
          value: "part4",
          label: "片段四",
          hidden: false,
          selected: false,
        },
      ],
    ),
  )

  let right_group = create_element("div", "topbar-group topbar-group--controls")
  append_child(right_group, build_text_span("span", "section-title", "脑图"))
  append_child(
    right_group,
    build_select_control(
      id="layout-select",
      label="布局",
      class_name="tool-select",
      options=[
        SelectOption::{
          value: "logic",
          label: "逻辑图",
          hidden: false,
          selected: true,
        },
        SelectOption::{
          value: "mindmap",
          label: "思维图",
          hidden: false,
          selected: false,
        },
        SelectOption::{
          value: "tree",
          label: "纵向",
          hidden: false,
          selected: false,
        },
      ],
    ),
  )
  append_child(
    right_group,
    build_select_control(
      id="style-select",
      label="样式",
      class_name="tool-select",
      options=[
        SelectOption::{
          value: "line",
          label: "填充",
          hidden: false,
          selected: true,
        },
        SelectOption::{
          value: "fill",
          label: "线条",
          hidden: false,
          selected: false,
        },
      ],
    ),
  )
  append_child(
    right_group,
    build_select_control(
      id="detail-select",
      label="层级",
      class_name="tool-select",
      options=[
        SelectOption::{
          value: "small",
          label: "精简",
          hidden: false,
          selected: false,
        },
        SelectOption::{
          value: "custom-small",
          label: "精简",
          hidden: true,
          selected: false,
        },
        SelectOption::{
          value: "medium",
          label: "中等",
          hidden: false,
          selected: false,
        },
        SelectOption::{
          value: "custom-medium",
          label: "中等",
          hidden: true,
          selected: false,
        },
        SelectOption::{
          value: "all",
          label: "全部",
          hidden: false,
          selected: true,
        },
        SelectOption::{
          value: "custom-all",
          label: "全部",
          hidden: true,
          selected: false,
        },
      ],
    ),
  )
  append_child(
    right_group,
    build_select_control(
      id="export-select",
      label="导出",
      class_name="tool-select tool-select--accent",
      options=[
        SelectOption::{
          value: "",
          label: "选择格式",
          hidden: true,
          selected: true,
        },
        SelectOption::{
          value: "png",
          label: ".PNG",
          hidden: false,
          selected: false,
        },
        SelectOption::{
          value: "svg",
          label: ".SVG",
          hidden: false,
          selected: false,
        },
        SelectOption::{
          value: "html",
          label: ".HTML",
          hidden: false,
          selected: false,
        },
      ],
    ),
  )
  append_child(topbar, left_group)
  append_child(topbar, right_group)
  topbar
}

///|
fn build_select_control(
  id~ : String,
  label~ : String,
  class_name~ : String,
  options~ : Array[SelectOption],
) -> @dom.Element {
  let label_el = create_element("label", "tool-select-wrap")
  if label.length() > 0 {
    append_child(label_el, build_text_span("span", "tool-select-label", label))
  }
  let select = create_element("select", class_name)
  select.setAttribute("id", id)
  for option in options {
    let option_el = create_element("option", "")
    option_el.setAttribute("value", option.value)
    if option.hidden {
      option_el.setAttribute("hidden", "true")
    }
    if option.selected {
      option_el.setAttribute("selected", "true")
    }
    option_el.setTextContent(option.label)
    append_child(select, option_el)
  }
  append_child(label_el, select)
  label_el
}

///|
fn build_editor_panel() -> @dom.Element {
  let panel = create_element("aside", "editor-panel")
  let surface = create_element("div", "editor-surface")
  append_child(surface, build_editor_chrome(filename=current_document_name()))
  let body = create_element("div", "editor-body")
  let gutter_wrap = create_element("div", "editor-gutter-wrap")
  append_child(
    gutter_wrap,
    {
      let linked_gutter_lines = create_element(
        "div", "editor-gutter-lines editor-gutter-lines--linked",
      )
      linked_gutter_lines.setAttribute("id", "input-linked-gutter-lines")
      linked_gutter_lines
    },
  )
  append_child(
    gutter_wrap,
    {
      let hover_gutter_line = create_element(
        "div", "editor-gutter-line editor-gutter-line--hover",
      )
      hover_gutter_line.setAttribute("id", "input-hover-gutter-line")
      hover_gutter_line
    },
  )
  append_child(
    gutter_wrap,
    {
      let active_gutter_line = create_element(
        "div", "editor-gutter-line editor-gutter-line--active",
      )
      active_gutter_line.setAttribute("id", "input-active-gutter-line")
      active_gutter_line
    },
  )
  append_child(
    gutter_wrap,
    {
      let gutter = create_element("div", "editor-gutter")
      gutter.setAttribute("id", "input-gutter")
      gutter
    },
  )

  let input_wrap = create_element("div", "editor-input-wrap")
  append_child(
    input_wrap,
    {
      let linked_lines = create_element("div", "editor-linked-lines")
      linked_lines.setAttribute("id", "input-linked-lines")
      linked_lines
    },
  )
  append_child(
    input_wrap,
    {
      let hover_line = create_element("div", "editor-hover-line")
      hover_line.setAttribute("id", "input-hover-line")
      hover_line
    },
  )
  append_child(
    input_wrap,
    {
      let active_line = create_element("div", "editor-active-line")
      active_line.setAttribute("id", "input-active-line")
      active_line
    },
  )
  append_child(
    input_wrap,
    {
      let measure_mirror = create_element("textarea", "editor-input-mirror")
      measure_mirror.setAttribute("id", "input-measure-mirror")
      measure_mirror.setAttribute("aria-hidden", "true")
      measure_mirror.setAttribute("wrap", "soft")
      measure_mirror.setAttribute("rows", "1")
      measure_mirror.setAttribute("tabindex", "-1")
      measure_mirror
    },
  )
  let input = create_element("textarea", "")
  input.setAttribute("id", "input")
  input.setAttribute("wrap", "soft")
  input.setAttribute("spellcheck", "false")
  input.setAttribute(
    "placeholder", "# MoonMarkMind\n\n## 链接\n- [MoonBit 包](https://mooncakes.io/)\n\n## 功能\n### 列表\n- 条目",
  )
  append_child(input_wrap, input)

  append_child(body, gutter_wrap)
  append_child(body, input_wrap)
  append_child(surface, body)
  append_child(panel, surface)
  panel
}

///|
fn build_editor_chrome(filename~ : String) -> @dom.Element {
  let chrome = create_element("div", "editor-chrome")
  let lights = create_element("div", "editor-chrome__lights")
  lights.setAttribute("aria-hidden", "true")
  append_child(
    lights,
    create_element("span", "editor-chrome__light editor-chrome__light--red"),
  )
  append_child(
    lights,
    create_element("span", "editor-chrome__light editor-chrome__light--yellow"),
  )
  append_child(
    lights,
    create_element("span", "editor-chrome__light editor-chrome__light--green"),
  )

  append_child(chrome, lights)
  append_child(
    chrome,
    build_text_span("span", "editor-chrome__title", "Markdown"),
  )

  let actions = create_element("div", "editor-chrome__actions")
  actions.setAttribute("aria-label", "Markdown 编辑操作")
  append_child(
    actions,
    build_icon_button(
      class_name="editor-chrome-action",
      id="new-document",
      tip="新建",
      label="+",
    ),
  )
  append_child(
    actions,
    build_icon_button(
      class_name="editor-chrome-action",
      id="upload-markdown",
      tip="导入",
      label="⇪",
    ),
  )
  append_child(chrome, actions)

  let badge = build_text_span("span", "editor-chrome__badge", filename)
  append_child(chrome, badge)
  chrome
}

///|
fn build_workspace_divider() -> @dom.Element {
  let divider = create_element("div", "workspace-divider")
  divider.setAttribute("id", "workspace-divider")
  divider.setAttribute("role", "separator")
  divider.setAttribute("aria-orientation", "vertical")
  divider.setAttribute("aria-label", "调整左右面板宽度")
  append_child(divider, create_element("div", "workspace-divider__track"))
  append_child(divider, create_element("div", "workspace-divider__handle"))
  divider
}

///|
fn build_mindmap_panel() -> @dom.Element {
  let panel = create_element("section", "mindmap-panel")
  let toolbar = create_element("div", "mindmap-toolbar")
  let actions = create_element("div", "mindmap-toolbar__actions")
  append_child(actions, build_primary_toolbar())

  let side = create_element("div", "mindmap-toolbar__side")
  append_child(side, build_secondary_toolbar())
  append_child(side, build_zoom_controls())

  append_child(toolbar, actions)
  append_child(toolbar, side)

  let shell = create_element("div", "mindmap-canvas-shell")
  let surface = create_element("div", "mindmap-surface")
  let mindmap = create_element("div", "mindmap")
  mindmap.setAttribute("id", "mindmap")
  mindmap.setAttribute("tabindex", "0")
  mindmap.setAttribute("data-pan-x", "0")
  mindmap.setAttribute("data-pan-y", "0")
  mindmap.setAttribute("data-zoom", "1")
  append_child(surface, mindmap)
  append_child(shell, surface)

  append_child(panel, toolbar)
  append_child(panel, shell)
  panel
}

///|
fn build_zoom_controls() -> @dom.Element {
  let zoom = create_element("div", "mindmap-zoom")
  let strip = create_element("div", "zoom-strip")
  append_child(
    strip,
    build_icon_button(
      class_name="zoom-chip",
      id="zoom-out",
      tip="缩小",
      label="-",
      compact=true,
    ),
  )
  append_child(
    strip,
    {
      let value = build_text_span("span", "zoom-value", "100%")
      value.setAttribute("id", "zoom-value")
      value
    },
  )
  let edit = create_element("input", "zoom-edit")
  edit.setAttribute("id", "zoom-edit")
  edit.setAttribute("type", "text")
  edit.setAttribute("value", "100%")
  edit.setAttribute("aria-label", "编辑缩放比例")
  append_child(strip, edit)
  append_child(
    strip,
    build_icon_button(
      class_name="zoom-chip",
      id="zoom-in",
      tip="放大",
      label="+",
      compact=true,
    ),
  )
  append_child(zoom, strip)
  zoom
}

///|
fn build_primary_toolbar() -> @dom.Element {
  let toolbar = create_element(
    "div", "mindmap-toolbar__actions mindmap-toolbar__cluster mindmap-toolbar__cluster--primary",
  )
  append_child(
    toolbar,
    build_toolbar_button(
      action="new-branch",
      tip="新建兄弟节点 / Enter",
      label="B",
    ),
  )
  append_child(
    toolbar,
    build_toolbar_button(
      action="new-child",
      tip="新建子节点 / Tab",
      label="C",
    ),
  )
  append_child(
    toolbar,
    build_toolbar_button(
      action="delete-node",
      tip="删除当前节点 / Delete",
      label="X",
    ),
  )
  append_child(
    toolbar,
    build_toolbar_button(
      action="edit-node",
      tip="编辑节点 / 双击",
      label="E",
    ),
  )
  append_child(
    toolbar,
    build_toolbar_button(action="move-up", tip="上移 / Ctrl+Up", label="↑"),
  )
  append_child(
    toolbar,
    build_toolbar_button(
      action="move-down",
      tip="下移 / Ctrl+Down",
      label="↓",
    ),
  )
  append_child(
    toolbar,
    build_toolbar_button(
      action="toggle-node",
      tip="折叠或展开 / Space",
      label="⤢",
    ),
  )
  append_child(
    toolbar,
    build_select_control(
      id="insert-select",
      label="",
      class_name="tool-select tool-select--insert",
      options=[
        SelectOption::{
          value: "",
          label: "插入",
          hidden: true,
          selected: true,
        },
        SelectOption::{
          value: "insert-note",
          label: "笔记",
          hidden: false,
          selected: false,
        },
        SelectOption::{
          value: "insert-link",
          label: "链接",
          hidden: false,
          selected: false,
        },
        SelectOption::{
          value: "insert-image",
          label: "图片",
          hidden: false,
          selected: false,
        },
        SelectOption::{
          value: "insert-formula",
          label: "公式",
          hidden: false,
          selected: false,
        },
      ],
    ),
  )
  toolbar
}

///|
fn build_secondary_toolbar() -> @dom.Element {
  let toolbar = create_element(
    "div", "mindmap-side-tools mindmap-toolbar__side mindmap-toolbar__cluster mindmap-toolbar__cluster--secondary",
  )
  append_child(
    toolbar,
    build_aux_button(id="undo-action", tip="撤销 / Ctrl+Z", label="↶"),
  )
  append_child(
    toolbar,
    build_aux_button(id="redo-action", tip="重做 / Ctrl+Y", label="↷"),
  )
  append_child(
    toolbar,
    build_aux_button(id="fit-view", tip="适配视图", label="⤢"),
  )
  append_child(
    toolbar,
    build_aux_button(id="recenter-view", tip="居中视图", label="◎"),
  )
  append_child(toolbar, build_aux_button(tip="帮助", label="?"))
  toolbar
}

///|
fn build_toolbar_button(
  action~ : String,
  tip~ : String,
  label~ : String,
) -> @dom.Element {
  let _ = label
  let button = create_element("button", "mindmap-tool")
  button.setAttribute("type", "button")
  button.setAttribute("data-toolbar-action", action)
  button.setAttribute("data-tip", tip)
  button.setAttribute("aria-label", tip)
  append_child(button, build_tool_icon(toolbar_icon_key(action), false))
  button
}

///|
fn build_aux_button(
  tip~ : String,
  label~ : String,
  id? : String = "",
) -> @dom.Element {
  let button = create_element("button", "mindmap-aux-button")
  button.setAttribute("type", "button")
  button.setAttribute("data-tip", tip)
  button.setAttribute("aria-label", tip)
  append_child(button, build_tool_icon(aux_icon_key(id, label), false))
  if id.length() > 0 {
    button.setAttribute("id", id)
  }
  button
}

///|
fn build_button(
  class_name : String,
  id : String,
  tip : String,
  label : String,
) -> @dom.Element {
  let button = create_element("button", class_name)
  button.setAttribute("type", "button")
  button.setAttribute("id", id)
  button.setAttribute("data-tip", tip)
  button.setAttribute("aria-label", tip)
  button.setTextContent(label)
  button
}

///|
fn build_icon_button(
  class_name~ : String,
  tip~ : String,
  label~ : String,
  icon? : String = "",
  id? : String = "",
  compact? : Bool = false,
) -> @dom.Element {
  let button = create_element("button", class_name)
  button.setAttribute("type", "button")
  button.setAttribute("data-tip", tip)
  button.setAttribute("aria-label", tip)
  let icon_key = if icon.length() == 0 {
    default_icon_key(tip, label)
  } else {
    icon
  }
  append_child(button, build_tool_icon(icon_key, compact))
  if id.length() > 0 {
    button.setAttribute("id", id)
  }
  button
}

///|
fn build_tool_icon(icon_key : String, compact : Bool) -> @dom.Element {
  let icon_class = if compact {
    "tool-icon tool-icon--compact"
  } else {
    "tool-icon"
  }
  let icon = create_element("span", icon_class)
  icon.setAttribute("aria-hidden", "true")
  append_child(icon, build_tool_svg(icon_key, compact))
  icon
}

///|
fn build_tool_svg(icon_key : String, compact : Bool) -> @dom.Element {
  let svg = create_svg_element("svg", "")
  svg.setAttribute("viewBox", "0 0 24 24")
  svg.setAttribute("width", "100%")
  svg.setAttribute("height", "100%")
  svg.setAttribute("fill", "none")
  svg.setAttribute("stroke", "currentColor")
  svg.setAttribute("stroke-width", if compact { "2.2" } else { "1.9" })
  svg.setAttribute("stroke-linecap", "round")
  svg.setAttribute("stroke-linejoin", "round")
  match icon_key {
    "branch" => {
      append_child(svg, build_svg_circle(7.0, 12.0, 1.8, true))
      append_child(svg, build_svg_circle(17.0, 7.0, 1.8, true))
      append_child(svg, build_svg_circle(17.0, 17.0, 1.8, true))
      append_child(svg, build_svg_path("M8.8 12H13M13 12L18 7M13 12L18 17"))
    }
    "child" => {
      append_child(svg, build_svg_circle(12.0, 6.5, 1.8, true))
      append_child(svg, build_svg_circle(12.0, 17.5, 1.8, true))
      append_child(
        svg,
        build_svg_path("M12 8.3V15.2M9.2 12.3L12 15.2L14.8 12.3"),
      )
    }
    "delete" => append_child(svg, build_svg_path("M7 7L17 17M17 7L7 17"))
    "edit" => {
      append_child(
        svg,
        build_svg_path(
          "M5.5 18.5L6.5 14.7L15.8 5.4L18.6 8.2L9.3 17.5L5.5 18.5Z",
        ),
      )
      append_child(svg, build_svg_path("M14.9 6.3L17.7 9.1"))
    }
    "up" =>
      append_child(svg, build_svg_path("M12 18V6M7.5 11.5L12 7L16.5 11.5"))
    "down" =>
      append_child(svg, build_svg_path("M12 6V18M7.5 12.5L12 17L16.5 12.5"))
    "toggle" => {
      append_child(svg, build_svg_path("M6 7H18"))
      append_child(svg, build_svg_path("M8 12H16"))
      append_child(svg, build_svg_path("M10 17H14"))
    }
    "insert" => append_child(svg, build_svg_path("M12 5.5V18.5M5.5 12H18.5"))
    "document" => {
      append_child(svg, build_svg_path("M8 4H14.2L18 7.8V20H8V4Z"))
      append_child(svg, build_svg_path("M14.2 4V8H18"))
      append_child(svg, build_svg_path("M10.5 11H15.5M10.5 14H15.5"))
      append_child(svg, build_svg_path("M10.5 17H13"))
    }
    "upload" => {
      append_child(svg, build_svg_path("M12 16V6M8.5 9.5L12 6L15.5 9.5"))
      append_child(svg, build_svg_path("M6.5 15.5V18.5H17.5V15.5"))
    }
    "undo" => {
      append_child(svg, build_svg_path("M9 8H5V4M5.4 8A8 8 0 1 1 8 17.5"))
      append_child(svg, build_svg_path("M5 4L8.2 7.2"))
    }
    "redo" => {
      append_child(svg, build_svg_path("M15 8H19V4M18.6 8A8 8 0 1 0 16 17.5"))
      append_child(svg, build_svg_path("M19 4L15.8 7.2"))
    }
    "fit" =>
      append_child(
        svg,
        build_svg_path("M8 4H4V8M16 4H20V8M8 20H4V16M16 20H20V16"),
      )
    "center" => {
      append_child(svg, build_svg_path("M12 4V7M12 17V20M4 12H7M17 12H20"))
      append_child(svg, build_svg_circle(12.0, 12.0, 3.2, false))
    }
    "help" => {
      append_child(
        svg,
        build_svg_path("M10.2 9a2 2 0 1 1 3.8 1c0 1.5-2 1.8-2 3.5M12 17.5V18"),
      )
      append_child(svg, build_svg_circle(12.0, 12.0, 8.5, false))
    }
    "zoom-in" => append_child(svg, build_svg_path("M12 5.5V18.5M5.5 12H18.5"))
    "zoom-out" => append_child(svg, build_svg_path("M5.5 12H18.5"))
    _ => append_child(svg, build_svg_path("M6 12H18"))
  }
  svg
}

///|
fn default_icon_key(tip : String, label : String) -> String {
  if tip.contains("新建") {
    "document"
  } else if tip.contains("导入") || tip.contains("上传") {
    "upload"
  } else {
    zoom_icon_key(label)
  }
}

///|
fn build_svg_path(d : String) -> @dom.Element {
  let path = create_svg_element("path", "")
  path.setAttribute("d", d)
  path.setAttribute("fill", "none")
  path
}

///|
fn build_svg_circle(
  cx : Double,
  cy : Double,
  r : Double,
  filled : Bool,
) -> @dom.Element {
  let circle = create_svg_element("circle", "")
  circle.setAttribute("cx", cx.to_string())
  circle.setAttribute("cy", cy.to_string())
  circle.setAttribute("r", r.to_string())
  if filled {
    circle.setAttribute("fill", "currentColor")
    circle.setAttribute("stroke", "none")
  } else {
    circle.setAttribute("fill", "none")
  }
  circle
}

///|
fn toolbar_icon_key(action : String) -> String {
  match action {
    "new-branch" => "branch"
    "new-child" => "child"
    "delete-node" => "delete"
    "edit-node" => "edit"
    "move-up" => "up"
    "move-down" => "down"
    "toggle-node" => "toggle"
    "insert-note" => "insert"
    "insert-link" => "insert"
    "insert-image" => "insert"
    "insert-formula" => "insert"
    _ => "branch"
  }
}

///|
fn aux_icon_key(id : String, label : String) -> String {
  if id == "undo-action" {
    "undo"
  } else if id == "redo-action" {
    "redo"
  } else if id == "fit-view" {
    "fit"
  } else if id == "recenter-view" {
    "center"
  } else if label == "?" {
    "help"
  } else {
    "help"
  }
}

///|
fn zoom_icon_key(label : String) -> String {
  if label == "-" {
    "zoom-out"
  } else if label == "+" {
    "zoom-in"
  } else {
    "help"
  }
}

///|
fn build_text_span(
  tag : String,
  class_name : String,
  value : String,
) -> @dom.Element {
  let el = create_element(tag, class_name)
  el.setTextContent(value)
  el
}

///|
fn create_element(tag : String, class_name : String) -> @dom.Element {
  let element = @dom.document().createElement(tag)
  style_of(element).set_property("box-sizing", "border-box")
  if class_name.length() > 0 {
    element.setClassName(class_name)
  }
  apply_theme_to_element(element)
  element
}

///|
fn create_svg_element(tag : String, class_name : String) -> @dom.Element {
  let element = @dom.document().createElementNs(
    "http://www.w3.org/2000/svg", tag,
  )
  if class_name.length() > 0 {
    element.setAttribute("class", class_name)
  }
  element
}

///|
fn append_child(parent : @dom.Element, child : @dom.Element) -> Unit {
  parent.as_node().appendChild(child.as_node()) |> ignore
}

///|
fn clear_element(element : @dom.Element) -> Unit {
  element.setTextContent("")
}

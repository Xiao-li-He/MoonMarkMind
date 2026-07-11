///|
/// HTML, SVG, and PNG export helpers for the browser app.
///
/// Export code clones the live mind map into a neutral measurement state,
/// serializes browser DOM into portable assets, and downloads the result.
fn download_link_from_data_url(filename : String, data_url : String) -> Unit {
  let link = create_element("a", "")
  let anchor = @dom.HTMLAnchorElement::cast_from_element(link)
  anchor.setAttribute("href", data_url)
  anchor.setAttribute("download", filename)
  match @dom.document().body() {
    Some(body) => append_child(body.as_element(), link)
    None => append_child(@dom.document().documentElement(), link)
  }
  anchor.click()
  link.remove()
}

///|
fn download_text(filename : String, content : String) -> Unit {
  // Text downloads use a generated link so the same path works for Markdown,
  // SVG text, and HTML exports across supported browsers.
  download_link_from_data_url(
    filename,
    "data:text/plain;charset=utf-8,\{@global.encodeURIComponent(content)}",
  )
}

///|
fn download_current_page_html(filename : String) -> Unit {
  ignore(
    @core.Promise::new(async fn(resolve, _reject) {
      let bundle = fetch_current_bundle_text() catch { _ => "" }
      let html = build_mindmap_export_html(bundle)
      if html.length() > 0 {
        download_link_from_data_url(
          filename,
          "data:text/html;charset=utf-8,\{@global.encodeURIComponent(html)}",
        )
      }
      resolve(())
    }),
  )
}

///|
async fn fetch_current_bundle_text() -> String {
  let response = @dom.window().fetch(current_bundle_src())
  let text_promise : @core.Promise[String] = response
    .as_any()
    ._call("text", [])
    .cast()
  text_promise.wait()
}

///|
fn build_mindmap_export_html(bundle : String) -> String {
  // Interactive exports embed the current map shell and either inline or link
  // the app bundle so the resulting file can be opened independently.
  let export_dom = build_mindmap_interactive_export_dom()
  let script_tag = build_export_runtime_script(bundle)
  let out = StringBuilder()
  out.write_string("<!doctype html><html><head>")
  out.write_string("<meta charset=\"utf-8\">")
  out.write_string(
    "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">",
  )
  out.write_string("<title>MoonMarkMind Export</title>")
  out.write_string("</head><body>")
  out.write_string(export_dom.outerHTML())
  out.write_string(script_tag)
  out.write_string("</body></html>")
  out.to_string()
}

///|
fn build_export_runtime_script(bundle : String) -> String {
  let out = StringBuilder()
  if bundle.length() == 0 {
    out.write_string("<script type=\"module\" src=\"")
    out.write_string(current_bundle_src())
    out.write_string("\"></script>")
  } else {
    out.write_string("<script type=\"module\">")
    out.write_string(escape_inline_script(bundle))
    out.write_string("</script>")
  }
  out.to_string()
}

///|
fn escape_inline_script(script : String) -> String {
  script
  .replace_all(old="</script", new="<\\/script")
  .replace_all(old="<!--", new="<\\!--")
}

///|
fn build_mindmap_interactive_export_dom() -> @dom.Element {
  // Clone only the mind-map experience, not editor chrome, so exported HTML is
  // focused on reading and presenting the current map.
  let saved_collapsed = app_state.collapsed
  let saved_collapsed_note_nodes = app_state.collapsed_note_nodes
  let saved_hidden_nodes = app_state.hidden_nodes
  let saved_selected_node = app_state.selected_node
  let saved_selected_nodes = app_state.selected_nodes
  let saved_editing_node = app_state.editing_node
  let saved_editing_note_node = app_state.editing_note_node
  app_state.collapsed = []
  app_state.collapsed_note_nodes = []
  app_state.hidden_nodes = []
  app_state.selected_node = -2
  app_state.selected_nodes = []
  app_state.editing_node = -2
  app_state.editing_note_node = -2
  let root = create_element("main", "mindmap-export")
  root.setAttribute("id", "mindmap-export")
  root.setAttribute("data-export-collapsed", ints_to_csv(saved_collapsed))
  root.setAttribute(
    "data-export-note-collapsed",
    ints_to_csv(saved_collapsed_note_nodes),
  )
  style_of(root).set_property("display", "inline-block")
  style_of(root).set_property("padding", "48px")
  style_of(root).set_property("background", "transparent")
  let mindmap = create_element("div", "mindmap")
  mindmap.setAttribute("id", "mindmap")
  mindmap.setAttribute("data-pan-x", "0")
  mindmap.setAttribute("data-pan-y", "0")
  mindmap.setAttribute("data-zoom", "1")
  style_of(mindmap).set_property("height", "auto")
  style_of(mindmap).set_property("overflow", "visible")
  append_child(mindmap, build_mindmap_dom())
  remove_node_width_resize_handles(mindmap)
  apply_mindmap_export_layout(mindmap)
  append_child(root, mindmap)
  app_state.collapsed = saved_collapsed
  app_state.collapsed_note_nodes = saved_collapsed_note_nodes
  app_state.hidden_nodes = saved_hidden_nodes
  app_state.selected_node = saved_selected_node
  app_state.selected_nodes = saved_selected_nodes
  app_state.editing_node = saved_editing_node
  app_state.editing_note_node = saved_editing_note_node
  root
}

///|
fn apply_mindmap_export_layout(mindmap : @dom.Element) -> Unit {
  match mindmap.querySelector(".mindmap-content") {
    Some(content) => {
      let content_style = style_of(content)
      content_style.set_property("position", "relative")
      content_style.set_property("left", "auto")
      content_style.set_property("top", "auto")
      content_style.set_property("transform", "none")
      content_style.set_property("display", "inline-block")
    }
    None => ()
  }
}

///|
fn current_bundle_src() -> String {
  let location = @dom.window().location()
  let origin = location._get("origin").to_string()
  if origin == "null" || origin.length() == 0 {
    "main.bundle.js"
  } else {
    let pathname = location._get("pathname").to_string()
    "\{origin}\{bundle_directory_path(pathname)}main.bundle.js"
  }
}

///|
fn bundle_directory_path(pathname : String) -> String {
  if pathname.length() == 0 {
    return "/"
  }
  let slash = last_slash_index(pathname)
  if slash < 0 {
    "/"
  } else {
    pathname[0:slash + 1].to_owned()
  }
}

///|
fn last_slash_index(source : String) -> Int {
  let mut index = source.length() - 1
  while index >= 0 {
    if source[index] == '/' {
      return index
    }
    index -= 1
  }
  -1
}

///|
let export_collapsed_nodes : @ref.Ref[Array[Int]] = @ref.Ref([])

///|
let export_collapsed_note_nodes : @ref.Ref[Array[Int]] = @ref.Ref([])

///|
fn bind_export_mindmap_ui(export_root : @dom.Element) -> Unit {
  apply_export_page_theme()
  export_collapsed_nodes.val = parse_selection_indices(
    export_root.getAttribute("data-export-collapsed").unwrap_or(""),
  )
  export_collapsed_note_nodes.val = parse_selection_indices(
    export_root.getAttribute("data-export-note-collapsed").unwrap_or(""),
  )
  export_root
  .as_event_target()
  .on("click", fn(raw) {
    let event : @dom.MouseEvent = raw.cast()
    match event.target().closest(".markdown-image") {
      Some(image) => {
        event.preventDefault()
        event.stopPropagation()
        show_markdown_image_preview(image)
      }
      None =>
        match event.target().closest("[data-action=\"toggle-note\"]") {
          Some(button) =>
            handle_export_note_toggle_click(export_root, event, button)
          None =>
            match event.target().closest("[data-action=\"toggle\"]") {
              Some(button) =>
                handle_export_node_toggle_click(export_root, event, button)
              None => ()
            }
        }
    }
  })
  @dom.window()
  .as_event_target()
  .on("resize", fn(_) { render_export_mindmap_connectors(export_root) })
  bind_export_mindmap_connector_reflows(export_root)
  apply_export_collapsed_state(export_root)
  apply_export_note_collapsed_state(export_root)
  schedule_export_mindmap_connectors(export_root)
}

///|
fn handle_export_node_toggle_click(
  export_root : @dom.Element,
  event : @dom.MouseEvent,
  button : @dom.Element,
) -> Unit {
  match button.closest(".node[data-node-index]") {
    Some(card) => {
      let node_index = parse_int_or_default(
        card.getAttribute("data-node-index").unwrap_or("-1"),
        -1,
      )
      if node_index >= 0 {
        event.preventDefault()
        event.stopPropagation()
        if contains_int(export_collapsed_nodes.val, node_index) {
          export_collapsed_nodes.val = remove_int(
            export_collapsed_nodes.val,
            node_index,
          )
        } else {
          export_collapsed_nodes.val.push(node_index)
        }
        apply_export_collapsed_state(export_root)
      }
    }
    None => ()
  }
}

///|
fn handle_export_note_toggle_click(
  export_root : @dom.Element,
  event : @dom.MouseEvent,
  button : @dom.Element,
) -> Unit {
  match button.closest(".node[data-node-index]") {
    Some(card) => {
      let node_index = parse_int_or_default(
        card.getAttribute("data-node-index").unwrap_or("-1"),
        -1,
      )
      if node_index >= 0 {
        event.preventDefault()
        event.stopPropagation()
        if contains_int(export_collapsed_note_nodes.val, node_index) {
          export_collapsed_note_nodes.val = remove_int(
            export_collapsed_note_nodes.val,
            node_index,
          )
        } else {
          export_collapsed_note_nodes.val.push(node_index)
        }
        apply_export_note_collapsed_state(export_root)
      }
    }
    None => ()
  }
}

///|
fn apply_export_page_theme() -> Unit {
  let html_style = style_of(@dom.document().documentElement())
  html_style.set_property("min-height", "100%")
  html_style.set_property("background", "transparent")
  match @dom.document().body() {
    Some(body) => {
      let body_style = style_of(body.as_element())
      body_style.set_property("margin", "0")
      body_style.set_property("min-height", "100%")
      body_style.set_property("overflow", "auto")
      body_style.set_property("background", "transparent")
      body_style.set_property(
        "font-family", "\"Segoe UI\", \"PingFang SC\", \"Microsoft YaHei\", sans-serif",
      )
    }
    None => ()
  }
}

///|
fn show_markdown_image_preview(image : @dom.Element) -> Unit {
  let src = image.getAttribute("src").unwrap_or("")
  if src.length() == 0 {
    return
  }
  close_markdown_image_preview()
  let overlay = create_element("div", "image-preview-overlay")
  overlay.setAttribute("role", "dialog")
  overlay.setAttribute("aria-modal", "true")
  overlay.setAttribute("tabindex", "-1")
  let close = create_element("button", "image-preview-close")
  close.setAttribute("type", "button")
  close.setAttribute("aria-label", "Close")
  close.setTextContent("x")
  let preview = create_element("img", "image-preview")
  preview.setAttribute("src", src)
  preview.setAttribute("alt", image.getAttribute("alt").unwrap_or(""))
  append_child(overlay, close)
  append_child(overlay, preview)
  overlay
  .as_event_target()
  .on("click", fn(raw) {
    let event : @dom.MouseEvent = raw.cast()
    match event.target().closest(".image-preview") {
      Some(_) => ()
      None => close_markdown_image_preview()
    }
  })
  overlay
  .as_event_target()
  .on("keydown", fn(raw) {
    let event : @dom.KeyboardEvent = raw.cast()
    if event_key(event) == "Escape" {
      event.preventDefault()
      close_markdown_image_preview()
    }
  })
  match @dom.document().body() {
    Some(body) => append_child(body.as_element(), overlay)
    None => append_child(@dom.document().documentElement(), overlay)
  }
  @dom.HTMLElement::cast_from_element(overlay).focus()
}

///|
fn close_markdown_image_preview() -> Unit {
  match get_element(".image-preview-overlay") {
    Some(overlay) => overlay.remove()
    None => ()
  }
}

///|
fn apply_export_collapsed_state(export_root : @dom.Element) -> Unit {
  let cards : Array[@dom.Element] = export_root.querySelectorAll(
    ".node[data-node-index]",
  )
  for card in cards {
    let node_index = parse_int_or_default(
      card.getAttribute("data-node-index").unwrap_or("-1"),
      -1,
    )
    let parent_index = export_parent_index(card)
    let container = export_node_container(card)
    if parent_index >= 0 {
      apply_export_hidden_state(
        container,
        export_hidden_by_collapsed(cards, node_index),
      )
    }
    match card.querySelector("[data-action=\"toggle\"]") {
      Some(button) => {
        let collapsed = contains_int(export_collapsed_nodes.val, node_index)
        let hidden_count = card.getAttribute("data-hidden-count").unwrap_or("")
        card.setAttribute("data-collapsed", collapsed.to_string())
        button.setAttribute("aria-expanded", (!collapsed).to_string())
        toggle_class(button, "node-action--collapsed", collapsed)
        button.setTextContent(if collapsed { hidden_count } else { "" })
      }
      None => ()
    }
  }
  schedule_export_mindmap_connectors(export_root)
}

///|
fn apply_export_note_collapsed_state(export_root : @dom.Element) -> Unit {
  let cards : Array[@dom.Element] = export_root.querySelectorAll(
    ".node[data-node-index]",
  )
  for card in cards {
    let node_index = parse_int_or_default(
      card.getAttribute("data-node-index").unwrap_or("-1"),
      -1,
    )
    let collapsed = contains_int(export_collapsed_note_nodes.val, node_index)
    match card.querySelector("[data-action=\"toggle-note\"]") {
      Some(button) =>
        button.setAttribute("aria-expanded", (!collapsed).to_string())
      None => ()
    }
    match card.querySelector("[data-note-preview-for]") {
      Some(body) => apply_export_hidden_state(body, collapsed)
      None => ()
    }
  }
  schedule_export_mindmap_connectors(export_root)
}

///|
fn apply_export_hidden_state(container : @dom.Element, hidden : Bool) -> Unit {
  let style = style_of(container)
  if hidden {
    container.setAttribute("hidden", "")
    style.set_property_priority("display", "none", "important")
  } else {
    container.removeAttribute("hidden")
    ignore(style.remove_property("display"))
    apply_theme_to_element(container)
  }
}

///|
fn schedule_export_mindmap_connectors(export_root : @dom.Element) -> Unit {
  let window = @dom.window()
  ignore(
    window.requestAnimationFrame(fn(_) {
      ignore(
        window.requestAnimationFrame(fn(_) {
          render_export_mindmap_connectors(export_root)
        }),
      )
    }),
  )
}

///|
fn schedule_export_mindmap_connector_reflow_series(
  export_root : @dom.Element,
) -> Unit {
  schedule_export_mindmap_connectors(export_root)
  let window = @dom.window()
  ignore(
    window.setTimeout(
      fn() { render_export_mindmap_connectors(export_root) },
      80,
    ),
  )
  ignore(
    window.setTimeout(
      fn() { render_export_mindmap_connectors(export_root) },
      240,
    ),
  )
  ignore(
    window.setTimeout(
      fn() { render_export_mindmap_connectors(export_root) },
      640,
    ),
  )
}

///|
fn bind_export_mindmap_connector_reflows(export_root : @dom.Element) -> Unit {
  @dom.window()
  .as_event_target()
  .on("load", fn(_) {
    schedule_export_mindmap_connector_reflow_series(export_root)
  })
  let images : Array[@dom.Element] = export_root.querySelectorAll("img")
  for image in images {
    image
    .as_event_target()
    .on("load", fn(_) {
      schedule_export_mindmap_connector_reflow_series(export_root)
    })
  }
}

///|
fn export_parent_index(card : @dom.Element) -> Int {
  parse_int_or_default(
    card.getAttribute("data-parent-index").unwrap_or("-1"),
    -1,
  )
}

///|
fn export_node_container(card : @dom.Element) -> @dom.Element {
  match card.closest(".branch-item, .vertical-tree, .single-right-tree__node") {
    Some(container) => container
    None => card
  }
}

///|
fn export_hidden_by_collapsed(
  cards : Array[@dom.Element],
  node_index : Int,
) -> Bool {
  for cursor = export_parent_of(cards, node_index); cursor >= 0; {
    if contains_int(export_collapsed_nodes.val, cursor) {
      return true
    }
    continue export_parent_of(cards, cursor)
  } nobreak {
    false
  }
}

///|
fn export_parent_of(cards : Array[@dom.Element], node_index : Int) -> Int {
  for card in cards {
    let current = parse_int_or_default(
      card.getAttribute("data-node-index").unwrap_or("-1"),
      -1,
    )
    if current == node_index {
      return export_parent_index(card)
    }
  }
  -1
}

///|
fn render_export_mindmap_connectors(export_root : @dom.Element) -> Unit {
  match export_root.querySelector(".mindmap-stage") {
    Some(stage) => {
      apply_export_mindmap_layout(stage)
      ensure_export_mindmap_visible_bounds(export_root, stage)
      apply_export_mindmap_layout(stage)
      match stage.querySelector(".mindmap-connector-layer") {
        Some(layer) => layer.remove()
        None => ()
      }
      let nodes = export_visible_node_cards(export_root)
      if nodes.length() <= 1 {
        return
      }
      let stage_rect = element_rect(stage)
      let width = max_double(1.0, stage_rect.width).ceil().to_int()
      let height = max_double(1.0, stage_rect.height).ceil().to_int()
      let svg = create_svg_element("svg", "mindmap-connector-layer")
      svg.setAttribute("width", width.to_string())
      svg.setAttribute("height", height.to_string())
      svg.setAttribute("viewBox", "0 0 \{width} \{height}")
      let svg_style = style_of(svg)
      svg_style.set_property("position", "absolute")
      svg_style.set_property("left", "0px")
      svg_style.set_property("top", "0px")
      svg_style.set_property("overflow", "visible")
      svg_style.set_property("pointer-events", "none")
      let layout = stage_layout_kind(stage)
      svg_style.set_property("z-index", connector_layer_z_index(layout))
      let color = export_connector_color(stage)
      for node in nodes {
        match
          build_branch_line_node_baseline(
            layout,
            node,
            element_rect(node),
            stage_rect.left,
            stage_rect.top,
            1.0,
            color,
          ) {
          Some(path) => append_child(svg, path)
          None => ()
        }
      }
      for node in nodes {
        let parent_index = export_parent_index(node)
        if parent_index < 0 {
          continue
        }
        match find_node_by_index(nodes, parent_index) {
          Some(parent) =>
            match
              export_connector_geometry(
                layout,
                element_rect(parent),
                element_rect(node),
                parent,
                node,
                stage_rect.left,
                stage_rect.top,
              ) {
              Some(path_data) =>
                append_child(
                  svg,
                  build_export_connector_path(parent, node, path_data, color),
                )
              None => ()
            }
          None => ()
        }
      }
      stage.as_any()._call("prepend", [svg.as_any()]) |> ignore
    }
    None => ()
  }
}

///|
fn ensure_export_mindmap_visible_bounds(
  export_root : @dom.Element,
  stage : @dom.Element,
) -> Unit {
  match mindmap_node_bounds(stage) {
    Some((left, top, right, bottom)) => {
      let stage_rect = element_rect(stage)
      let base_padding = 48.0
      let margin = 48.0
      let extra_left = max_double(0.0, stage_rect.left - left + margin)
      let extra_right = max_double(0.0, right - stage_rect.right + margin)
      let root_style = style_of(export_root)
      root_style.set_property(
        "padding-left",
        "\{(base_padding + extra_left).ceil().to_int()}px",
      )
      root_style.set_property(
        "padding-right",
        "\{(base_padding + extra_right).ceil().to_int()}px",
      )
      let trim_top = max_double(0.0, top - stage_rect.top - margin)
      let trim_bottom = max_double(0.0, stage_rect.bottom - bottom - margin)
      let stage_style = style_of(stage)
      stage_style.set_property("margin-top", "-\{trim_top.ceil().to_int()}px")
      stage_style.set_property(
        "margin-bottom",
        "-\{trim_bottom.ceil().to_int()}px",
      )
    }
    None => ()
  }
}

///|
fn apply_export_mindmap_layout(stage : @dom.Element) -> Unit {
  if has_class_name(stage, "mindmap-stage--radial") {
    apply_radial_branch_layout_with_zoom(stage, 1.0)
  }
}

///|
fn export_visible_node_cards(export_root : @dom.Element) -> Array[@dom.Element] {
  let nodes : Array[@dom.Element] = export_root.querySelectorAll(
    ".node[data-node-index]",
  )
  let visible : Array[@dom.Element] = []
  for node in nodes {
    if !export_node_container(node).hasAttribute("hidden") {
      visible.push(node)
    }
  }
  visible
}

///|
/// Serialize the current mindmap into a standalone SVG string.
///
/// The live viewport is temporarily normalized so exported bounds come from the
/// content itself rather than the user's current pan and zoom.
fn build_mindmap_export_svg() -> String {
  // SVG export delegates to a neutralized snapshot element so the live viewport
  // can be restored after serialization.
  match build_mindmap_export_svg_element() {
    Some(svg) => serialize_svg_export_element(svg)
    None => ""
  }
}

///|
priv struct MindmapExportViewState {
  pan_x : String
  pan_y : String
  zoom : String
  style_pan_x : String
  style_pan_y : String
  style_zoom : String
}

///|
fn capture_mindmap_export_view_state(
  mindmap : @dom.Element,
) -> MindmapExportViewState {
  let style = style_of(mindmap)
  MindmapExportViewState::{
    pan_x: mindmap.getAttribute("data-pan-x").unwrap_or("0"),
    pan_y: mindmap.getAttribute("data-pan-y").unwrap_or("0"),
    zoom: mindmap.getAttribute("data-zoom").unwrap_or("1"),
    style_pan_x: style.get_property_value("--pan-x"),
    style_pan_y: style.get_property_value("--pan-y"),
    style_zoom: style.get_property_value("--zoom"),
  }
}

///|
fn apply_neutral_mindmap_export_view(mindmap : @dom.Element) -> Unit {
  mindmap.setAttribute("data-pan-x", "0")
  mindmap.setAttribute("data-pan-y", "0")
  mindmap.setAttribute("data-zoom", "1")
  let style = style_of(mindmap)
  style.set_property("--pan-x", "0px")
  style.set_property("--pan-y", "0px")
  style.set_property("--zoom", "1")
}

///|
fn restore_mindmap_export_view(
  mindmap : @dom.Element,
  state : MindmapExportViewState,
) -> Unit {
  mindmap.setAttribute("data-pan-x", state.pan_x)
  mindmap.setAttribute("data-pan-y", state.pan_y)
  mindmap.setAttribute("data-zoom", state.zoom)
  let style = style_of(mindmap)
  restore_export_style_property(style, "--pan-x", state.style_pan_x)
  restore_export_style_property(style, "--pan-y", state.style_pan_y)
  restore_export_style_property(style, "--zoom", state.style_zoom)
}

///|
fn restore_export_style_property(
  style : @dom.CSSStyleDeclaration,
  name : String,
  value : String,
) -> Unit {
  if value.length() == 0 {
    ignore(style.remove_property(name))
  } else {
    style.set_property(name, value)
  }
}

///|
/// Build the SVG DOM used by both SVG download and PNG rasterization.
///
/// The element contains cloned mindmap markup plus a freshly measured connector
/// layer so static exports match the visible browser layout.
fn build_mindmap_export_svg_element() -> @dom.Element? {
  match get_element("#mindmap") {
    Some(mindmap) => {
      let view_state = capture_mindmap_export_view_state(mindmap)
      apply_neutral_mindmap_export_view(mindmap)
      normalize_static_export_note_buttons(mindmap)
      render_mindmap_connectors()
      let clone = @dom.Element::cast_from_node(mindmap.cloneNode(true))
      remove_node_width_resize_handles(clone)
      normalize_export_connector_styles(clone)
      normalize_static_export_selection_styles(clone)
      let bounds = mindmap_export_bounds(mindmap)
      let svg = create_svg_element("svg", "")
      svg.setAttribute("xmlns", "http://www.w3.org/2000/svg")
      svg.setAttribute("width", bounds.width.to_string())
      svg.setAttribute("height", bounds.height.to_string())
      svg.setAttribute("viewBox", "0 0 \{bounds.width} \{bounds.height}")
      let foreign_object = create_svg_element("foreignObject", "")
      let (foreign_x, foreign_y, foreign_width, foreign_height) = mindmap_export_foreign_object_attrs(
        bounds,
      )
      foreign_object.setAttribute("x", foreign_x)
      foreign_object.setAttribute("y", foreign_y)
      foreign_object.setAttribute("width", foreign_width)
      foreign_object.setAttribute("height", foreign_height)
      style_of(foreign_object).set_property("overflow", "visible")
      let wrapper = create_element("div", "")
      wrapper.setAttribute("xmlns", "http://www.w3.org/1999/xhtml")
      let wrapper_style = style_of(wrapper)
      wrapper_style.set_property("position", "relative")
      wrapper_style.set_property("width", "\{bounds.width}px")
      wrapper_style.set_property("height", "\{bounds.height}px")
      wrapper_style.set_property("background", "transparent")
      wrapper_style.set_property("overflow", "visible")
      let (mindmap_x, mindmap_y, mindmap_width, mindmap_height) = mindmap_export_mindmap_frame_attrs(
        bounds,
      )
      let mindmap_style = style_of(clone)
      mindmap_style.set_property("position", "absolute")
      mindmap_style.set_property("left", "\{mindmap_x}px")
      mindmap_style.set_property("top", "\{mindmap_y}px")
      mindmap_style.set_property("width", "\{mindmap_width}px")
      mindmap_style.set_property("height", "\{mindmap_height}px")
      mindmap_style.set_property("min-height", "\{mindmap_height}px")
      mindmap_style.set_property("overflow", "visible")
      mindmap_style.set_property("background", "transparent")
      mindmap_style.set_property("--pan-x", "0px")
      mindmap_style.set_property("--pan-y", "0px")
      mindmap_style.set_property("--zoom", "1")
      wrapper.as_node().appendChild(clone.as_node()) |> ignore
      foreign_object.as_node().appendChild(wrapper.as_node()) |> ignore
      svg.as_node().appendChild(foreign_object.as_node()) |> ignore
      let measure_host = attach_mindmap_export_measure_host(svg)
      match build_mindmap_export_connector_layer(svg, clone) {
        Some(connectors) =>
          svg
          .as_any()
          ._call("insertBefore", [connectors.as_any(), foreign_object.as_any()])
          |> ignore
        None => ()
      }
      measure_host.remove()
      restore_mindmap_export_view(mindmap, view_state)
      render_ui()
      Some(svg)
    }
    None => None
  }
}

///|
fn attach_mindmap_export_measure_host(svg : @dom.Element) -> @dom.Element {
  let host = create_element("div", "")
  let style = style_of(host)
  style.set_property("position", "fixed")
  style.set_property("left", "-100000px")
  style.set_property("top", "-100000px")
  style.set_property("width", "0")
  style.set_property("height", "0")
  style.set_property("overflow", "visible")
  style.set_property("opacity", "0")
  style.set_property("pointer-events", "none")
  style.set_property("z-index", "-1")
  append_child(host, svg)
  match @dom.document().body() {
    Some(body) => append_child(body.as_element(), host)
    None => append_child(@dom.document().documentElement(), host)
  }
  host
}

///|
fn build_mindmap_export_connector_layer(
  export_svg : @dom.Element,
  mindmap : @dom.Element,
) -> @dom.Element? {
  match mindmap.querySelector(".mindmap-stage") {
    Some(stage) => {
      let nodes : Array[@dom.Element] = stage.querySelectorAll(
        ".node[data-node-index]",
      )
      if nodes.length() <= 1 {
        return None
      }
      let export_rect = element_rect(export_svg)
      let stage_rect = element_rect(stage)
      let width = max_double(1.0, stage_rect.width).ceil().to_int()
      let height = max_double(1.0, stage_rect.height).ceil().to_int()
      let (layer_x, layer_y, layer_width, layer_height) = mindmap_export_connector_layer_attrs(
        export_left=export_rect.left,
        export_top=export_rect.top,
        stage_left=stage_rect.left,
        stage_top=stage_rect.top,
        stage_width=width,
        stage_height=height,
      )
      let svg = create_svg_element("svg", "mindmap-export-connectors")
      svg.setAttribute("x", layer_x)
      svg.setAttribute("y", layer_y)
      svg.setAttribute("width", width.to_string())
      svg.setAttribute("height", height.to_string())
      svg.setAttribute("viewBox", "0 0 \{layer_width} \{layer_height}")
      let svg_style = style_of(svg)
      svg_style.set_property("overflow", "visible")
      svg_style.set_property("pointer-events", "none")
      svg_style.set_property("mix-blend-mode", "multiply")
      svg_style.set_property("opacity", "0.92")
      let layout = stage_layout_kind(stage)
      let color = export_connector_color(stage)
      for node in nodes {
        match
          build_branch_line_node_baseline(
            layout,
            node,
            element_rect(node),
            stage_rect.left,
            stage_rect.top,
            1.0,
            color,
          ) {
          Some(path) => append_child(svg, path)
          None => ()
        }
      }
      for node in nodes {
        let parent_index = parse_int_or_default(
          node.getAttribute("data-parent-index").unwrap_or("-1"),
          -1,
        )
        if parent_index < 0 {
          continue
        }
        match find_node_by_index(nodes, parent_index) {
          Some(parent) =>
            match
              export_connector_geometry(
                layout,
                element_rect(parent),
                element_rect(node),
                parent,
                node,
                stage_rect.left,
                stage_rect.top,
              ) {
              Some(path_data) =>
                append_child(
                  svg,
                  build_export_connector_path(parent, node, path_data, color),
                )
              None => ()
            }
          None => ()
        }
      }
      Some(svg)
    }
    None => None
  }
}

///|
fn mindmap_export_connector_layer_attrs(
  export_left~ : Double,
  export_top~ : Double,
  stage_left~ : Double,
  stage_top~ : Double,
  stage_width~ : Int,
  stage_height~ : Int,
) -> (String, String, String, String) {
  (
    double_to_svg_number(stage_left - export_left),
    double_to_svg_number(stage_top - export_top),
    stage_width.to_string(),
    stage_height.to_string(),
  )
}

///|
fn mindmap_export_foreign_object_attrs(
  bounds : MindmapExportBounds,
) -> (String, String, String, String) {
  ("0", "0", bounds.width.to_string(), bounds.height.to_string())
}

///|
fn mindmap_export_mindmap_frame_attrs(
  bounds : MindmapExportBounds,
) -> (String, String, String, String) {
  (
    double_to_svg_number(bounds.mindmap_x),
    double_to_svg_number(bounds.mindmap_y),
    bounds.mindmap_width.to_string(),
    bounds.mindmap_height.to_string(),
  )
}

///|
fn remove_node_width_resize_handles(root : @dom.Element) -> Unit {
  for handle in root.querySelectorAll(".node-width-resize-handle") {
    handle.remove()
  }
}

///|
priv struct MindmapExportBounds {
  width : Int
  height : Int
  mindmap_x : Double
  mindmap_y : Double
  mindmap_width : Int
  mindmap_height : Int
}

///|
fn mindmap_export_bounds(mindmap : @dom.Element) -> MindmapExportBounds {
  let margin = mindmap_static_export_visual_margin()
  let mindmap_rect = element_rect(mindmap)
  let (content_left, content_top, content_right, content_bottom) = match
    mindmap.querySelector(".mindmap-stage") {
    Some(stage) =>
      match mindmap_export_visual_bounds(stage) {
        Some(bounds) => bounds
        None =>
          (
            mindmap_rect.left,
            mindmap_rect.top,
            mindmap_rect.right,
            mindmap_rect.bottom,
          )
      }
    None =>
      (
        mindmap_rect.left,
        mindmap_rect.top,
        mindmap_rect.right,
        mindmap_rect.bottom,
      )
  }
  let left = content_left - margin
  let top = content_top - margin
  let width = max_double(1.0, content_right - content_left + margin * 2.0)
    .ceil()
    .to_int()
  let height = max_double(1.0, content_bottom - content_top + margin * 2.0)
    .ceil()
    .to_int()
  MindmapExportBounds::{
    width,
    height,
    mindmap_x: mindmap_rect.left - left,
    mindmap_y: mindmap_rect.top - top,
    mindmap_width: max_double(1.0, mindmap_rect.width).ceil().to_int(),
    mindmap_height: max_double(1.0, mindmap_rect.height).ceil().to_int(),
  }
}

///|
fn mindmap_static_export_visual_margin() -> Double {
  48.0
}

///|
fn mindmap_export_visual_bounds(
  stage : @dom.Element,
) -> (Double, Double, Double, Double)? {
  match mindmap_node_bounds(stage) {
    Some(bounds) => {
      let nodes : Array[@dom.Element] = stage.querySelectorAll(
        ".node[data-node-index]",
      )
      let mut visual_bounds = bounds
      for node in nodes {
        visual_bounds = expand_export_bounds_with_element(visual_bounds, node)
      }
      for
        affordance in stage.querySelectorAll(
          ".node-actions, .node-action, .node-width-resize-handle",
        ) {
        visual_bounds = expand_export_bounds_with_element(
          visual_bounds, affordance,
        )
      }
      Some(visual_bounds)
    }
    None => None
  }
}

///|
fn expand_export_bounds_with_element(
  bounds : (Double, Double, Double, Double),
  element : @dom.Element,
) -> (Double, Double, Double, Double) {
  let rect = element_rect(element)
  if rect.width <= 0.0 && rect.height <= 0.0 {
    bounds
  } else {
    let (left, top, right, bottom) = bounds
    (
      min_double(left, rect.left),
      min_double(top, rect.top),
      max_double(right, rect.right),
      max_double(bottom, rect.bottom),
    )
  }
}

///|
fn normalize_export_connector_styles(mindmap : @dom.Element) -> Unit {
  match mindmap.querySelector(".mindmap-stage") {
    Some(stage) =>
      match stage.querySelector(".mindmap-connector-layer") {
        Some(layer) => layer.remove()
        None => ()
      }
    None => ()
  }
}

///|
fn normalize_static_export_selection_styles(mindmap : @dom.Element) -> Unit {
  let selected_nodes : Array[@dom.Element] = mindmap.querySelectorAll(
    ".node.is-selected",
  )
  for node in selected_nodes {
    toggle_class(node, "is-selected", false)
  }
}

///|
fn normalize_static_export_note_buttons(mindmap : @dom.Element) -> Unit {
  let buttons : Array[@dom.Element] = mindmap.querySelectorAll(
    ".node-action--note",
  )
  for button in buttons {
    button.setTextContent("")
    button.removeAttribute("data-action")
    button.removeAttribute("data-tip")
    button.removeAttribute("aria-label")
    button.removeAttribute("aria-expanded")
    let button_style = style_of(button)
    button_style.set_property("display", "none")
    button_style.set_property("pointer-events", "none")
    match button.closest(".node") {
      Some(node) => {
        match node.querySelector("[data-note-preview-for]") {
          Some(body) => {
            let body_style = style_of(body)
            body_style.set_property(
              "margin-top",
              static_export_note_body_margin_top(node),
            )
          }
          None => ()
        }
        match node.querySelector(".node-title") {
          Some(title) => {
            let title_style = style_of(title)
            title_style.set_property(
              "margin-top",
              static_export_note_title_shift(),
            )
          }
          None => ()
        }
      }
      None => ()
    }
  }
}

///|
fn static_export_note_body_margin_top(node : @dom.Element) -> String {
  static_export_note_body_margin_top_for_branch_line(
    has_class_name(node, "node--branch-line"),
  )
}

///|
fn static_export_note_body_margin_top_for_branch_line(
  is_branch_line : Bool,
) -> String {
  let _ = is_branch_line
  "4px"
}

///|
fn static_export_note_title_shift() -> String {
  "4px"
}

///|
fn export_connector_geometry(
  layout : StageLayoutKind,
  parent_rect : @dom.DOMRect,
  node_rect : @dom.DOMRect,
  parent_node : @dom.Element,
  node : @dom.Element,
  export_left : Double,
  export_top : Double,
) -> ConnectorPathData? {
  if layout is StageLayoutKind::Tree {
    let start_x = stage_local_x(rect_center_x(parent_rect), export_left, 1.0)
    let start_y = stage_local_y(
      export_tree_connector_parent_anchor_y(parent_rect, parent_node),
      export_top,
      1.0,
    )
    let end_x = stage_local_x(rect_center_x(node_rect), export_left, 1.0)
    let end_y = stage_local_y(
      export_tree_connector_child_anchor_y(node_rect, node),
      export_top,
      1.0,
    )
    let span_y = abs_double(end_y - start_y)
    let bend = min_double(44.0, max_double(16.0, span_y * 0.4))
    Some(ConnectorPathData::{
      start_x,
      start_y,
      control1_x: start_x,
      control1_y: start_y + bend,
      control2_x: end_x,
      control2_y: end_y - bend,
      end_x,
      end_y,
    })
  } else {
    connector_geometry(
      layout, parent_rect, node_rect, parent_node, node, export_left, export_top,
      1.0,
    )
  }
}

///|
fn build_export_connector_path(
  parent_node : @dom.Element,
  node : @dom.Element,
  path_data : ConnectorPathData,
  color : String,
) -> @dom.Element {
  let path = build_connector_path(parent_node, node, path_data)
  path.setAttribute("stroke", color)
  path.setAttribute("stroke-opacity", "0.92")
  path
}

///|
fn export_connector_color(stage : @dom.Element) -> String {
  if has_class_name(stage, "mindmap-stage--fill") {
    "#7ca5d4"
  } else {
    "#94b6db"
  }
}

///|
fn download_mindmap_svg(filename : String) -> Unit {
  let svg = build_mindmap_export_svg()
  if svg.length() == 0 {
    return
  }
  download_link_from_data_url(
    filename,
    "data:image/svg+xml;charset=utf-8,\{@global.encodeURIComponent(svg)}",
  )
}

///|
fn download_mindmap_png(filename : String) -> Unit {
  ignore(
    @core.Promise::new(async fn(resolve, _reject) {
      download_mindmap_png_async(filename)
      resolve(())
    }),
  )
}

///|
/// Rasterize the generated SVG through a canvas and download it as PNG.
///
/// Image sources are inlined first when possible because canvas export becomes
/// blocked if the SVG references external image data.
async fn download_mindmap_png_async(filename : String) -> Unit {
  let svg_element = match build_mindmap_export_svg_element() {
    Some(svg) => svg
    None => return
  }
  let width = parse_int_or_default(
    svg_element.getAttribute("width").unwrap_or("0"),
    0,
  )
  let height = parse_int_or_default(
    svg_element.getAttribute("height").unwrap_or("0"),
    0,
  )
  if width <= 0 || height <= 0 {
    return
  }
  let scale = png_export_scale(width, height)
  let output_width = (width.to_double() * scale).round().to_int()
  let output_height = (height.to_double() * scale).round().to_int()
  svg_element.setAttribute("width", output_width.to_string())
  svg_element.setAttribute("height", output_height.to_string())
  inline_png_export_images(svg_element)
  let svg = serialize_svg_export_element(svg_element)
  let image = create_element("img", "")
  let image_element = @dom.HTMLImageElement::cast_from_element(image)
  let export_url = "data:image/svg+xml;charset=utf-8,\{@global.encodeURIComponent(svg)}"
  image_element
  .as_event_target()
  .addEventListener("load", fn(_) {
    let canvas = create_element("canvas", "")
    let canvas_element = @dom.HTMLCanvasElement::cast_from_element(canvas)
    canvas_element.width = output_width
    canvas_element.height = output_height
    let ctx : @canvas.CanvasRenderingContext2D = @core.identity(
      canvas_element.getContext("2d"),
    )
    ctx.clearRect(0.0, 0.0, output_width.to_double(), output_height.to_double())
    ctx.drawImageScaled(
      image_element.as_any(),
      0.0,
      0.0,
      output_width.to_double(),
      output_height.to_double(),
    )
    download_link_from_data_url(
      filename,
      canvas_element.toDataURL(image_type="image/png"),
    )
  })
  image_element.as_event_target().addEventListener("error", fn(_) { () })
  image_element.src = export_url
}

///|
async fn inline_png_export_images(svg_element : @dom.Element) -> Unit {
  let images : Array[@dom.Element] = svg_element.querySelectorAll(
    ".markdown-image",
  )
  for image in images {
    let src = image.getAttribute("src").unwrap_or("")
    if should_inline_png_export_image_src(src) {
      let data_url = fetch_image_as_data_url(src) catch { _ => "" }
      if data_url.length() > 0 {
        image.setAttribute("src", data_url)
      }
    }
  }
}

///|
fn should_inline_png_export_image_src(src : String) -> Bool {
  let trimmed = src.trim().to_owned()
  if trimmed.length() == 0 {
    return false
  }
  let lower = trimmed.to_lower()
  !(lower.has_prefix("data:") || lower.has_prefix("blob:"))
}

///|
async fn fetch_image_as_data_url(src : String) -> String {
  let response = @dom.window().fetch(src)
  if !response.ok {
    return ""
  }
  let blob_promise : @core.Promise[@core.Any] = response
    .as_any()
    ._call("blob", [])
    .cast()
  read_blob_as_data_url(blob_promise.wait())
}

///|
async fn read_blob_as_data_url(blob : @core.Any) -> String {
  let resolvers : @core.PromiseResolvers[String] = @core.Promise::withResolvers()
  let reader = @file.FileReader::new()
  reader.set_onload(fn(_) {
    resolvers.resolve(reader.as_any()["result"].to_string())
  })
  reader.set_onerror(fn(_) { resolvers.resolve("") })
  reader.as_any()._call("readAsDataURL", [blob]) |> ignore
  resolvers.promise.wait()
}

///|
fn png_export_scale(width : Int, height : Int) -> Double {
  let raw_dpr = @dom.window().devicePixelRatio()
  let preferred = if raw_dpr.is_nan() || raw_dpr < 2.0 {
    2.0
  } else if raw_dpr > 3.0 {
    3.0
  } else {
    raw_dpr
  }
  let max_side = 8192.0
  let max_side_scale = min_double(
    max_side / width.to_double(),
    max_side / height.to_double(),
  )
  let capped = min_double(preferred, max_side_scale)
  if capped < 1.0 {
    1.0
  } else {
    capped
  }
}

///|
fn serialize_svg_export_element(element : @dom.Element) -> String {
  close_svg_void_elements(element.outerHTML())
}

///|
/// Convert HTML void elements inside exported SVG markup to XML syntax.
///
/// Browser `outerHTML` can emit `<br>` or `<input>` inside `foreignObject`;
/// SVG consumers and rasterizers expect the self-closing XML form.
fn close_svg_void_elements(source : String) -> String {
  let out = StringBuilder()
  let mut cursor = 0
  while cursor < source.length() {
    match find_svg_void_tag_start(source, cursor) {
      Some(start) => {
        if start > cursor {
          out.write_string(source[cursor:start].to_owned())
        }
        let end_ = find_tag_end(source, start)
        if end_ < 0 {
          out.write_string(source[start:].to_owned())
          return out.to_string()
        }
        if end_ > start && source[end_ - 1] == '/' {
          out.write_string(source[start:end_ + 1].to_owned())
        } else {
          out.write_string(source[start:end_].to_owned())
          out.write_string(" />")
        }
        cursor = end_ + 1
      }
      None => {
        out.write_string(source[cursor:].to_owned())
        cursor = source.length()
      }
    }
  }
  out.to_string()
}

///|
fn find_svg_void_tag_start(source : String, start : Int) -> Int? {
  let mut cursor = start
  while cursor < source.length() {
    if match_svg_void_tag(source, cursor) is Some(_) {
      return Some(cursor)
    }
    cursor += 1
  }
  None
}

///|
fn match_svg_void_tag(source : String, start : Int) -> String? {
  if start < 0 ||
    start + 1 >= source.length() ||
    source[start] != '<' ||
    source[start + 1] == '/' {
    return None
  }
  let tags = [
    "area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "param",
    "source", "track", "wbr",
  ]
  for tag in tags {
    let tag_start = start + 1
    let tag_end = tag_start + tag.length()
    if tag_end <= source.length() &&
      source[tag_start:tag_end].to_owned() == tag &&
      (tag_end == source.length() || is_tag_name_boundary(source[tag_end])) {
      return Some(tag)
    }
  }
  None
}

///|
fn is_tag_name_boundary(ch : UInt16) -> Bool {
  ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r' || ch == '/' || ch == '>'
}

///|
fn find_tag_end(source : String, start : Int) -> Int {
  let mut cursor = start
  let mut quote : UInt16 = 0
  while cursor < source.length() {
    let ch = source[cursor]
    if quote != 0 {
      if ch == quote {
        quote = 0
      }
    } else if ch == '"' || ch == '\'' {
      quote = ch
    } else if ch == '>' {
      return cursor
    }
    cursor += 1
  }
  -1
}

///|

///|
fn render_app_shell_html() -> String {
  let prefix =
    #|<main class="app-shell">
    #|  <header class="topbar">
    #|    <div class="topbar-group">
    #|      <span class="brand-title">MoonMarkMind</span>
    #|      <span class="section-title">MD文本</span>
    #|      <button type="button" class="tool-button tool-button--red" id="new-document">新建</button>
    #|      <button type="button" class="tool-button tool-button--green" id="upload-markdown">上传</button>
    #|      <button type="button" class="tool-button tool-button--blue" id="download-markdown">下载</button>
    #|      <button type="button" class="tool-button tool-button--soft" id="load-sample">示例</button>
    #|    </div>
    #|    <div class="topbar-group topbar-group--controls">
    #|      <span class="section-title">脑图</span>
    #|      <label class="tool-select-wrap">
    #|        <span class="tool-select-label">类型</span>
    #|        <select id="layout-select" class="tool-select">
    #|          <option value="horizontal">思维图</option>
    #|          <option value="single-right">逻辑图</option>
    #|          <option value="vertical">树状图</option>
    #|        </select>
    #|      </label>
    #|      <label class="tool-select-wrap">
    #|        <span class="tool-select-label">样式</span>
    #|        <select id="style-select" class="tool-select">
    #|          <option value="line">线条</option>
    #|          <option value="fill">填充</option>
    #|        </select>
    #|      </label>
    #|      <label class="tool-select-wrap">
    #|        <span class="tool-select-label">层级</span>
    #|        <select id="detail-select" class="tool-select">
    #|          <option value="small">最小</option>
    #|          <option value="custom-small" hidden>最小</option>
    #|          <option value="medium">中等</option>
    #|          <option value="custom-medium" hidden>中等</option>
    #|          <option value="all">全部</option>
    #|          <option value="custom-all" hidden>全部</option>
    #|        </select>
    #|      </label>
    #|      <label class="tool-select-wrap">
    #|        <span class="tool-select-label">导出</span>
    #|        <select id="export-select" class="tool-select tool-select--accent">
    #|          <option value="" hidden selected>选择</option>
    #|          <option value="png">.PNG</option>
    #|          <option value="svg">.SVG</option>
    #|          <option value="html">.HTML</option>
    #|        </select>
    #|      </label>
    #|    </div>
    #|  </header>
    #|
    #|  <section class="workspace">
    #|    <aside class="editor-panel">
    #|      <div class="editor-surface">
    #|        <div class="editor-chrome">
    #|          <div class="editor-chrome__lights" aria-hidden="true">
    #|            <span class="editor-chrome__light editor-chrome__light--red"></span>
    #|            <span class="editor-chrome__light editor-chrome__light--yellow"></span>
    #|            <span class="editor-chrome__light editor-chrome__light--green"></span>
    #|          </div>
    #|          <span class="editor-chrome__title">Markdown</span>
    #|          <span class="editor-chrome__badge">notes.md</span>
    #|        </div>
    #|        <div class="editor-body">
    #|          <pre class="editor-gutter" id="input-gutter" aria-hidden="true">1</pre>
    #|          <textarea id="input" spellcheck="false" placeholder="# MoonMarkMind&#10;&#10;## Links&#10;- [MoonBit Package](https://mooncakes.io/)&#10;&#10;## Features&#10;### Lists&#10;- item"></textarea>
    #|        </div>
    #|      </div>
    #|    </aside>
    #|
    #|    <div class="workspace-divider" id="workspace-divider" role="separator" aria-orientation="vertical" aria-label="调整左右面板宽度">
    #|      <div class="workspace-divider__track"></div>
    #|      <div class="workspace-divider__handle"></div>
    #|    </div>
    #|
    #|    <section class="mindmap-panel">
    #|      <div class="mindmap-toolbar">
    #|        <div class="mindmap-toolbar__actions">
  let middle =
    #|        </div>
    #|        <div class="mindmap-toolbar__side">
    #|          <div class="mindmap-side-tools">
  let suffix =
    #|          </div>
    #|          <div class="mindmap-zoom">
    #|            <div class="zoom-strip">
    #|              <button type="button" class="zoom-chip" id="zoom-out" aria-label="缩小">
    #|                <span class="tool-icon tool-icon--compact" aria-hidden="true">
    #|                  <svg viewBox="0 0 24 24" fill="none">
    #|                    <path d="M6 12h12"></path>
    #|                  </svg>
    #|                </span>
    #|              </button>
    #|              <span class="zoom-value" id="zoom-value" title="双击编辑缩放比例">100%</span>
    #|              <input type="text" class="zoom-edit" id="zoom-edit" value="100%" aria-label="编辑缩放比例" />
    #|              <button type="button" class="zoom-chip" id="zoom-in" aria-label="放大">
    #|                <span class="tool-icon tool-icon--compact" aria-hidden="true">
    #|                  <svg viewBox="0 0 24 24" fill="none">
    #|                    <path d="M12 6v12"></path>
    #|                    <path d="M6 12h12"></path>
    #|                  </svg>
    #|                </span>
    #|              </button>
    #|            </div>
    #|          </div>
    #|        </div>
    #|      </div>
    #|
    #|      <div class="mindmap-canvas-shell">
    #|        <div class="mindmap-surface">
    #|          <div class="mindmap" id="mindmap"></div>
    #|        </div>
    #|        <pre id="output" class="ascii-output"></pre>
    #|      </div>
    #|    </section>
    #|  </section>
    #|</main>
  let shell = prefix +
    render_primary_toolbar() +
    middle +
    render_secondary_toolbar() +
    suffix
  shell
}

///|
fn render_primary_toolbar() -> String {
  [
    render_toolbar_icon_button(
      action="new-branch",
      tip="新建分支 · Enter",
      icon=icon_branch(),
    ),
    render_toolbar_icon_button(
      action="new-child",
      tip="新建子节点 · Tab",
      icon=icon_child(),
    ),
    render_toolbar_icon_button(
      action="delete-node",
      tip="删除当前节点 · Delete",
      icon=icon_trash(),
    ),
    render_toolbar_icon_button(
      action="edit-node",
      tip="编辑节点 · 双击",
      icon=icon_edit(),
    ),
    render_toolbar_icon_button(
      action="move-up",
      tip="上移 · Ctrl+Up",
      icon=icon_arrow_up(),
    ),
    render_toolbar_icon_button(
      action="move-down",
      tip="下移 · Ctrl+Down",
      icon=icon_arrow_down(),
    ),
    render_toolbar_icon_button(
      action="toggle-node",
      tip="收起或展开 · Space",
      icon=icon_fold(),
    ),
    render_toolbar_icon_button(
      action="insert-node",
      tip="插入……",
      icon=icon_insert(),
    ),
  ].join("")
}

///|
fn render_secondary_toolbar() -> String {
  [
    render_aux_icon_button_with_id(
      id="undo-action",
      tip="撤回 · Ctrl+Z",
      icon=icon_undo(),
    ),
    render_aux_icon_button_with_id(
      id="redo-action",
      tip="重做 · Ctrl+Y",
      icon=icon_redo(),
    ),
    render_aux_icon_button_with_id(
      id="fit-view",
      tip="适配画布",
      icon=icon_fit_view(),
    ),
    render_aux_icon_button_with_id(
      id="recenter-view",
      tip="回中视图 · 双击画布空白处",
      icon=icon_play(),
    ),
    render_aux_icon_button(tip="帮助", icon=icon_help()),
  ].join("")
}

///|
fn render_toolbar_icon_button(
  action~ : String,
  tip~ : String,
  icon~ : String,
) -> String {
  "<button type=\"button\" class=\"mindmap-tool\" data-toolbar-action=\"\{action}\" data-tip=\"\{tip}\" aria-label=\"\{tip}\">\{icon}</button>"
}

///|
fn render_aux_icon_button(tip~ : String, icon~ : String) -> String {
  "<button type=\"button\" class=\"mindmap-aux-button\" data-tip=\"\{tip}\" aria-label=\"\{tip}\">\{icon}</button>"
}

///|
fn render_aux_icon_button_with_id(
  id~ : String,
  tip~ : String,
  icon~ : String,
) -> String {
  "<button type=\"button\" class=\"mindmap-aux-button\" id=\"\{id}\" data-tip=\"\{tip}\" aria-label=\"\{tip}\">\{icon}</button>"
}

///|
fn icon_shell(body : String) -> String {
  "<span class=\"tool-icon\" aria-hidden=\"true\">\{body}</span>"
}

///|
fn icon_branch() -> String {
  icon_shell(
    (
      #|<svg viewBox="0 0 24 24" fill="none">
      #|  <circle cx="7" cy="6" r="2"></circle>
      #|  <circle cx="17" cy="9" r="2"></circle>
      #|  <circle cx="17" cy="17" r="2"></circle>
      #|  <path d="M7 8v8"></path>
      #|  <path d="M9 9h6"></path>
      #|  <path d="M9 17h6"></path>
      #|</svg>
    ),
  )
}

///|
fn icon_child() -> String {
  icon_shell(
    (
      #|<svg viewBox="0 0 24 24" fill="none">
      #|  <rect x="3.5" y="4.5" width="6.5" height="5.2" rx="1.5"></rect>
      #|  <path d="M10 7.1h3.1c2.4 0 4.4 2 4.4 4.4v2.7"></path>
      #|  <rect x="13.8" y="14.2" width="6.7" height="5.3" rx="1.5"></rect>
      #|  <path d="M17.15 12.7v4"></path>
      #|  <path d="M15.15 14.7h4"></path>
      #|</svg>
    ),
  )
}

///|
fn icon_trash() -> String {
  icon_shell(
    (
      #|<svg viewBox="0 0 24 24" fill="none">
      #|  <path d="M5 7h14"></path>
      #|  <path d="M9 7V5h6v2"></path>
      #|  <path d="M8 9v8"></path>
      #|  <path d="M12 9v8"></path>
      #|  <path d="M16 9v8"></path>
      #|  <path d="M6 7l1 12h10l1-12"></path>
      #|</svg>
    ),
  )
}

///|
fn icon_edit() -> String {
  icon_shell(
    (
      #|<svg viewBox="0 0 24 24" fill="none">
      #|  <path d="M4 20l4.2-1 9.1-9.1-3.2-3.2L5 15.8 4 20z"></path>
      #|  <path d="M13.8 5.9l3.2 3.2"></path>
      #|</svg>
    ),
  )
}

///|
fn icon_arrow_up() -> String {
  icon_shell(
    (
      #|<svg viewBox="0 0 24 24" fill="none">
      #|  <path d="M12 18V6"></path>
      #|  <path d="M7 11l5-5 5 5"></path>
      #|</svg>
    ),
  )
}

///|
fn icon_arrow_down() -> String {
  icon_shell(
    (
      #|<svg viewBox="0 0 24 24" fill="none">
      #|  <path d="M12 6v12"></path>
      #|  <path d="M17 13l-5 5-5-5"></path>
      #|</svg>
    ),
  )
}

///|
fn icon_fold() -> String {
  icon_shell(
    (
      #|<svg viewBox="0 0 24 24" fill="none">
      #|  <rect x="5" y="5.5" width="5" height="3.5" rx="1"></rect>
      #|  <rect x="5" y="14.5" width="5" height="3.5" rx="1"></rect>
      #|  <path d="M10 7.25h4.2c2.1 0 3.8 1.7 3.8 3.8v1.1"></path>
      #|  <path d="M14.8 15.2l3.2 3.2 3.2-3.2"></path>
      #|</svg>
    ),
  )
}

///|
fn icon_insert() -> String {
  icon_shell(
    (
      #|<svg viewBox="0 0 24 24" fill="none">
      #|  <rect x="5" y="6" width="14" height="12" rx="2"></rect>
      #|  <path d="M12 9v6"></path>
      #|  <path d="M9 12h6"></path>
      #|</svg>
    ),
  )
}

///|
fn icon_undo() -> String {
  icon_shell(
    (
      #|<svg viewBox="0 0 24 24" fill="none">
      #|  <path d="M8.8 7.2 5.2 10.8l3.6 3.6"></path>
      #|  <path d="M6 10.8h7.1c3.2 0 5.8 2.6 5.8 5.8"></path>
      #|</svg>
    ),
  )
}

///|
fn icon_redo() -> String {
  icon_shell(
    (
      #|<svg viewBox="0 0 24 24" fill="none">
      #|  <path d="M15.2 7.2 18.8 10.8l-3.6 3.6"></path>
      #|  <path d="M18 10.8h-7.1c-3.2 0-5.8 2.6-5.8 5.8"></path>
      #|</svg>
    ),
  )
}

///|
fn icon_play() -> String {
  icon_shell(
    (
      #|<svg viewBox="0 0 24 24" fill="none">
      #|  <circle cx="12" cy="12" r="6.5"></circle>
      #|  <path d="M12 3.8v2.4"></path>
      #|  <path d="M12 17.8v2.4"></path>
      #|  <path d="M3.8 12h2.4"></path>
      #|  <path d="M17.8 12h2.4"></path>
      #|  <circle cx="12" cy="12" r="1.6" fill="currentColor" stroke="none"></circle>
      #|</svg>
    ),
  )
}

///|
fn icon_fit_view() -> String {
  icon_shell(
    (
      #|<svg viewBox="0 0 24 24" fill="none">
      #|  <path d="M8 5.5H5.5V8"></path>
      #|  <path d="M16 5.5h2.5V8"></path>
      #|  <path d="M8 18.5H5.5V16"></path>
      #|  <path d="M16 18.5h2.5V16"></path>
      #|  <rect x="8.3" y="8.3" width="7.4" height="7.4" rx="1.4"></rect>
      #|</svg>
    ),
  )
}

///|
fn icon_help() -> String {
  icon_shell(
    (
      #|<svg viewBox="0 0 24 24" fill="none">
      #|  <circle cx="12" cy="12" r="8"></circle>
      #|  <path d="M9.8 9.6a2.5 2.5 0 0 1 4.7 1.2c0 1.8-2.5 2.2-2.5 4"></path>
      #|  <circle cx="12" cy="17.3" r="0.9" fill="currentColor" stroke="none"></circle>
      #|</svg>
    ),
  )
}

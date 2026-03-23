///|
fn render_app_shell_html() -> String {
  let shell =
    #|<main class="app-shell">
    #|  <header class="topbar">
    #|    <div class="topbar-group">
    #|      <span class="topbar-title">Markdown</span>
    #|      <button type="button" class="tool-button tool-button--red" id="new-document">新建</button>
    #|      <button type="button" class="tool-button tool-button--green" id="upload-markdown">上传</button>
    #|      <button type="button" class="tool-button tool-button--blue" id="download-markdown">下载</button>
    #|      <button type="button" class="tool-button tool-button--soft" id="load-sample">示例</button>
    #|    </div>
    #|    <div class="topbar-group topbar-group--controls">
    #|      <span class="topbar-title">MindMap</span>
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
    #|        <textarea id="input" spellcheck="false" placeholder="# MoonMarkMind&#10;&#10;## Links&#10;- [MoonBit Package](https://mooncakes.io/)&#10;&#10;## Features&#10;### Lists&#10;- item"></textarea>
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
    #|          <button type="button" class="mindmap-tool" data-tip="Enter">新建分支</button>
    #|          <button type="button" class="mindmap-tool" data-tip="Tab">新建子节点</button>
    #|          <button type="button" class="mindmap-tool" data-tip="Delete">删除</button>
    #|          <button type="button" class="mindmap-tool" data-tip="双击">编辑</button>
    #|          <button type="button" class="mindmap-tool" data-tip="拖拽">上移 / 下移</button>
    #|          <button type="button" class="mindmap-tool" data-tip="点击">收起 / 展开</button>
    #|        </div>
    #|        <div class="mindmap-zoom">
    #|          <div class="zoom-strip">
    #|            <button type="button" class="zoom-chip" id="zoom-out">-</button>
    #|            <span class="zoom-value" id="zoom-value">100%</span>
    #|            <button type="button" class="zoom-chip" id="zoom-in">+</button>
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
  shell
}

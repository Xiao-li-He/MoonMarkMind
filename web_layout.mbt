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
    #|          <option value="medium">中等</option>
    #|          <option value="all">全部</option>
    #|        </select>
    #|      </label>
    #|      <label class="tool-select-wrap">
    #|        <span class="tool-select-label">导出</span>
    #|        <select id="export-select" class="tool-select tool-select--accent">
    #|          <option value="none">选择</option>
    #|          <option value="markdown">Markdown</option>
    #|          <option value="ascii">ASCII</option>
    #|          <option value="html">HTML</option>
    #|        </select>
    #|      </label>
    #|    </div>
    #|  </header>
    #|
    #|  <section class="workspace">
    #|    <aside class="editor-panel">
    #|      <div class="panel-head">
    #|        <strong>Markdown</strong>
    #|        <span>编辑真源文本</span>
    #|      </div>
    #|      <div class="editor-surface">
    #|        <textarea id="input" spellcheck="false" placeholder="# MoonMarkMind&#10;&#10;## Links&#10;- [MoonBit Package](https://mooncakes.io/)&#10;&#10;## Features&#10;### Lists&#10;- item"></textarea>
    #|      </div>
    #|    </aside>
    #|
    #|    <section class="mindmap-panel">
    #|      <div class="panel-head">
    #|        <strong>MindMap</strong>
    #|        <span>双击编辑，拖拽重排</span>
    #|      </div>
    #|
    #|      <div class="mindmap-toolbar">
    #|        <div class="mindmap-tool">新建分支<br /><small>Enter</small></div>
    #|        <div class="mindmap-tool">新建子节点<br /><small>Tab</small></div>
    #|        <div class="mindmap-tool">删除<br /><small>Delete</small></div>
    #|        <div class="mindmap-tool">编辑<br /><small>双击</small></div>
    #|        <div class="mindmap-tool">上移 / 下移<br /><small>拖拽</small></div>
    #|        <div class="mindmap-tool">收起 / 展开<br /><small>点击</small></div>
    #|      </div>
    #|
    #|      <div class="mindmap-surface">
    #|        <div class="mindmap" id="mindmap"></div>
    #|      </div>
    #|
    #|      <div class="mindmap-footer">
    #|        <div class="zoom-strip">
    #|          <button type="button" class="zoom-chip" disabled>-</button>
    #|          <span class="zoom-value">100%</span>
    #|          <button type="button" class="zoom-chip" disabled>+</button>
    #|        </div>
    #|        <pre id="output" class="ascii-output"></pre>
    #|      </div>
    #|    </section>
    #|  </section>
    #|</main>
  shell
}

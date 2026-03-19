const input = document.querySelector("#input");
const output = document.querySelector("#output");
const mindmap = document.querySelector("#mindmap");
const renderButton = document.querySelector("#render");
const sampleButton = document.querySelector("#load-sample");
const layoutButtons = document.querySelectorAll("[data-layout-mode]");

const collapsedNodes = new Set();
let currentDocumentRoot = null;
let dragState = null;
let editingNodeId = null;
let moonMarkMind = null;
let layoutMode = "horizontal";

function clearDropIndicators() {
  for (const element of mindmap.querySelectorAll(".drop-before, .drop-after")) {
    element.classList.remove("drop-before", "drop-after");
  }
}

function loadModel(markdown, resetUi = false) {
  if (!moonMarkMind) {
    return;
  }
  if (resetUi) {
    collapsedNodes.clear();
    editingNodeId = null;
  }
  input.value = markdown;
  output.textContent = moonMarkMind.renderAsciiMindmap(markdown);
  currentDocumentRoot = JSON.parse(moonMarkMind.outlineJson(markdown));
  renderFromModel();
}

function handleAddChild(node) {
  const title = window.prompt("New node title", "New node");
  if (!title || !moonMarkMind) {
    return;
  }
  const nextMarkdown = moonMarkMind.addChildHeading(input.value, node.flat_index, title.trim());
  loadModel(nextMarkdown);
}

function handleDelete(node) {
  const confirmed = window.confirm(`Delete "${node.title}" and its children?`);
  if (!confirmed || !moonMarkMind) {
    return;
  }
  const nextMarkdown = moonMarkMind.deleteHeading(input.value, node.flat_index);
  loadModel(nextMarkdown, true);
}

function createNodeCard(node, path, isCenter = false) {
  const card = document.createElement("div");
  const hasChildren = node.children.length > 0;
  const isCollapsed = collapsedNodes.has(node.flat_index);
  const isEditing = editingNodeId === node.flat_index;
  const editable = !node.synthetic;

  card.className = isCenter ? "node node--center" : "node";
  card.dataset.level = String(node.level);
  card.dataset.collapsed = String(isCollapsed);
  card.dataset.path = path.join(".");

  if (hasChildren) {
    card.classList.add("is-clickable");
    card.addEventListener("click", () => {
      if (editingNodeId === node.flat_index) {
        return;
      }
      if (collapsedNodes.has(node.flat_index)) {
        collapsedNodes.delete(node.flat_index);
      } else {
        collapsedNodes.add(node.flat_index);
      }
      renderFromModel();
    });
  }

  if (!isCenter && editable) {
    card.draggable = !isEditing;
    card.classList.add("is-draggable");
    card.addEventListener("dragstart", (event) => {
      dragState = { path, flatIndex: node.flat_index };
      card.classList.add("is-dragging");
      event.dataTransfer.effectAllowed = "move";
      event.dataTransfer.setData("text/plain", node.flat_index.toString());
    });

    card.addEventListener("dragend", () => {
      dragState = null;
      clearDropIndicators();
      card.classList.remove("is-dragging");
    });

    card.addEventListener("dragover", (event) => {
      if (!dragState) {
        return;
      }
      const sourceParent = dragState.path.slice(0, -1).join(".");
      const targetParent = path.slice(0, -1).join(".");
      if (sourceParent !== targetParent || dragState.path.join(".") === path.join(".")) {
        return;
      }

      event.preventDefault();
      clearDropIndicators();
      const rect = card.getBoundingClientRect();
      const placeAfter = event.clientY > rect.top + rect.height / 2;
      card.classList.add(placeAfter ? "drop-after" : "drop-before");
    });

    card.addEventListener("drop", (event) => {
      if (!dragState || !moonMarkMind) {
        return;
      }
      const sourceParent = dragState.path.slice(0, -1).join(".");
      const targetParent = path.slice(0, -1).join(".");
      if (sourceParent !== targetParent || dragState.path.join(".") === path.join(".")) {
        return;
      }

      event.preventDefault();
      const rect = card.getBoundingClientRect();
      const placeAfter = event.clientY > rect.top + rect.height / 2;
      clearDropIndicators();
      const nextMarkdown = moonMarkMind.moveHeading(
        input.value,
        dragState.flatIndex,
        node.flat_index,
        placeAfter,
      );
      loadModel(nextMarkdown);
    });
  }

  const meta = document.createElement("small");
  meta.textContent = `Level ${node.level}`;
  card.append(meta);

  if (isEditing) {
    const editor = document.createElement("input");
    editor.type = "text";
    editor.value = node.title;
    editor.className = "node-editor";
    editor.addEventListener("click", (event) => {
      event.stopPropagation();
    });
    editor.addEventListener("keydown", (event) => {
      if (!moonMarkMind) {
        return;
      }
      if (event.key === "Enter") {
        const nextMarkdown = moonMarkMind.renameHeading(
          input.value,
          node.flat_index,
          editor.value.trim(),
        );
        editingNodeId = null;
        loadModel(nextMarkdown);
      } else if (event.key === "Escape") {
        editingNodeId = null;
        renderFromModel();
      }
    });
    editor.addEventListener("blur", () => {
      if (!moonMarkMind) {
        return;
      }
      const nextMarkdown = moonMarkMind.renameHeading(
        input.value,
        node.flat_index,
        editor.value.trim(),
      );
      editingNodeId = null;
      loadModel(nextMarkdown);
    });
    card.append(editor);
    queueMicrotask(() => {
      editor.focus();
      editor.select();
    });
  } else {
    const title = document.createElement("strong");
    title.textContent = node.title;
    if (editable) {
      title.addEventListener("dblclick", (event) => {
        event.stopPropagation();
        editingNodeId = node.flat_index;
        renderFromModel();
      });
    }
    card.append(title);
  }

  const actions = document.createElement("div");
  actions.className = "node-actions";

  const addButton = document.createElement("button");
  addButton.type = "button";
  addButton.className = "node-action";
  addButton.textContent = "+";
  addButton.title = "Add child node";
  addButton.addEventListener("click", (event) => {
    event.stopPropagation();
    handleAddChild(node);
  });
  actions.append(addButton);

  if (!isCenter && editable) {
    const deleteButton = document.createElement("button");
    deleteButton.type = "button";
    deleteButton.className = "node-action node-action--danger";
    deleteButton.textContent = "x";
    deleteButton.title = "Delete node";
    deleteButton.addEventListener("click", (event) => {
      event.stopPropagation();
      handleDelete(node);
    });
    actions.append(deleteButton);
  }

  if (hasChildren) {
    const toggle = document.createElement("button");
    toggle.type = "button";
    toggle.className = "node-action";
    toggle.textContent = isCollapsed ? "+" : "-";
    toggle.title = isCollapsed ? "Expand node" : "Collapse node";
    toggle.setAttribute("aria-label", isCollapsed ? "Expand node" : "Collapse node");
    toggle.setAttribute("aria-expanded", String(!isCollapsed));
    toggle.addEventListener("click", (event) => {
      event.stopPropagation();
      if (collapsedNodes.has(node.flat_index)) {
        collapsedNodes.delete(node.flat_index);
      } else {
        collapsedNodes.add(node.flat_index);
      }
      renderFromModel();
    });
    actions.append(toggle);
  }

  card.append(actions);
  return card;
}

function renderBranchNode(entry, direction) {
  const { node, path } = entry;
  const item = document.createElement("div");
  item.className = `branch-item branch-item--${direction}`;
  item.dataset.collapsed = String(collapsedNodes.has(node.flat_index));

  item.append(createNodeCard(node, path));

  if (node.children.length > 0 && !collapsedNodes.has(node.flat_index)) {
    const children = document.createElement("div");
    children.className = `branch-children branch-children--${direction}`;

    for (let index = 0; index < node.children.length; index += 1) {
      children.append(
        renderBranchNode({ node: node.children[index], path: [...path, index] }, direction),
      );
    }

    item.append(children);
  }

  return item;
}

function renderColumn(entries, direction) {
  const column = document.createElement("div");
  column.className = `branch-column branch-column--${direction}`;

  for (const entry of entries) {
    column.append(renderBranchNode(entry, direction));
  }

  return column;
}

function renderVerticalTree(node, path, isRoot = false) {
  const tree = document.createElement("div");
  tree.className = "vertical-tree";
  tree.append(createNodeCard(node, path, isRoot));

  if (node.children.length > 0 && !collapsedNodes.has(node.flat_index)) {
    const children = document.createElement("div");
    children.className = "vertical-tree__children";

    for (let index = 0; index < node.children.length; index += 1) {
      const childWrap = document.createElement("div");
      childWrap.className = "vertical-tree__child";
      childWrap.append(renderVerticalTree(node.children[index], [...path, index]));
      children.append(childWrap);
    }

    tree.append(children);
  }

  return tree;
}

function renderSingleRightTree(node, path, isRoot = false) {
  const row = document.createElement("div");
  row.className = "single-right-tree__node";
  row.append(createNodeCard(node, path, isRoot));

  if (node.children.length > 0 && !collapsedNodes.has(node.flat_index)) {
    const children = document.createElement("div");
    children.className = "single-right-tree__children";

    for (let index = 0; index < node.children.length; index += 1) {
      children.append(renderSingleRightTree(node.children[index], [...path, index]));
    }

    row.append(children);
  }

  return row;
}

function renderHorizontalMindmap(center) {
  const leftEntries = [];
  const rightEntries = [];

  if (!collapsedNodes.has(center.flat_index)) {
    for (let index = 0; index < center.children.length; index += 1) {
      const entry = { node: center.children[index], path: [index] };
      if (index % 2 === 0) {
        rightEntries.push(entry);
      } else {
        leftEntries.push(entry);
      }
    }
  }

  const stage = document.createElement("div");
  stage.className = "mindmap-stage";
  stage.append(renderColumn(leftEntries, "left"));

  const centerWrap = document.createElement("div");
  centerWrap.className = "center-wrap";
  centerWrap.append(createNodeCard(center, [], true));
  stage.append(centerWrap);

  stage.append(renderColumn(rightEntries, "right"));
  return stage;
}

function renderVerticalMindmap(center) {
  const stage = document.createElement("div");
  stage.className = "mindmap-stage mindmap-stage--vertical";

  const rootWrap = document.createElement("div");
  rootWrap.className = "vertical-root";
  rootWrap.append(renderVerticalTree(center, [], true));

  stage.append(rootWrap);
  return stage;
}

function renderSingleRightMindmap(center) {
  const stage = document.createElement("div");
  stage.className = "mindmap-stage mindmap-stage--single-right";

  const tree = document.createElement("div");
  tree.className = "single-right-tree";
  tree.append(renderSingleRightTree(center, [], true));

  stage.append(tree);
  return stage;
}

function renderFromModel() {
  if (!currentDocumentRoot) {
    return;
  }

  const center = currentDocumentRoot;
  let stage = null;

  if (layoutMode === "vertical") {
    stage = renderVerticalMindmap(center);
  } else if (layoutMode === "single-right") {
    stage = renderSingleRightMindmap(center);
  } else {
    stage = renderHorizontalMindmap(center);
  }

  mindmap.replaceChildren(stage);
}

function rebuildFromInput() {
  loadModel(input.value, true);
}

sampleButton.addEventListener("click", () => {
  if (!moonMarkMind) {
    return;
  }
  loadModel(moonMarkMind.sampleMarkdown(), true);
});

renderButton.addEventListener("click", rebuildFromInput);
input.addEventListener("input", rebuildFromInput);

for (const button of layoutButtons) {
  button.addEventListener("click", () => {
    layoutMode = button.dataset.layoutMode ?? "horizontal";
    for (const candidate of layoutButtons) {
      const active = candidate === button;
      candidate.classList.toggle("is-active", active);
      candidate.setAttribute("aria-pressed", String(active));
    }
    renderFromModel();
  });
}

async function init() {
  const bundle = await import(`./main.bundle.js?v=${Date.now()}`);
  moonMarkMind = bundle.MoonMarkMind ?? globalThis.MoonMarkMind;
  loadModel(moonMarkMind.sampleMarkdown(), true);
}

init().catch((error) => {
  console.error("Failed to initialize MoonMarkMind bundle.", error);
  output.textContent = "Failed to load MoonBit bundle. Rebuild with build-web.ps1 and refresh.";
});
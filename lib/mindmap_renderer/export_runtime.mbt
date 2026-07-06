///|
/// Runtime used by standalone HTML exports to match the browser measured
/// connector behavior used by app/web.
pub fn render_export_runtime_script() -> String {
  (
    #|<script>
    #|(function () {
    #|  function hasClass(el, name) { return el && el.classList && el.classList.contains(name); }
    #|  function num(value, fallback) {
    #|    var parsed = parseFloat(value);
    #|    return Number.isFinite(parsed) ? parsed : fallback;
    #|  }
    #|  function layoutKind(stage) {
    #|    if (hasClass(stage, "mindmap-stage--vertical")) return "tree";
    #|    if (hasClass(stage, "mindmap-stage--single-right")) return "logic";
    #|    return "mindmap";
    #|  }
    #|  function centerX(rect) { return (rect.left + rect.right) / 2; }
    #|  function centerY(rect) { return (rect.top + rect.bottom) / 2; }
    #|  function localX(x, left, zoom) { return (x - left) / zoom; }
    #|  function localY(y, top, zoom) { return (y - top) / zoom; }
    #|  function branchLineBaselineOffset(node) { return hasClass(node, "node--center") ? 0.9 : 0.7; }
    #|  function nodeAnchorY(rect, node) {
    #|    return hasClass(node, "node--branch-line") ? rect.bottom - branchLineBaselineOffset(node) : centerY(rect);
    #|  }
    #|  function strokeWidth(node, parent) {
    #|    if (hasClass(node, "node--branch-line")) {
    #|      var width = hasClass(node, "node--center") ? 1.8 : (num(node.getAttribute("data-depth"), 0) === 1 ? 1.5 : 1.25);
    #|      if (hasClass(parent, "node--branch-line")) {
    #|        var parentWidth = hasClass(parent, "node--center") ? 1.8 : (num(parent.getAttribute("data-depth"), 0) === 1 ? 1.5 : 1.25);
    #|        return Math.max(width, parentWidth);
    #|      }
    #|      return width;
    #|    }
    #|    return num(node.getAttribute("data-depth"), 0) === 1 ? 2.8 : 2.0;
    #|  }
    #|  function pathData(layout, parent, node, stageRect, zoom) {
    #|    var pr = parent.getBoundingClientRect();
    #|    var nr = node.getBoundingClientRect();
    #|    var pcx = localX(centerX(pr), stageRect.left, zoom);
    #|    var pcy = localY(centerY(pr), stageRect.top, zoom);
    #|    var ncx = localX(centerX(nr), stageRect.left, zoom);
    #|    var ncy = localY(centerY(nr), stageRect.top, zoom);
    #|    var pay = localY(nodeAnchorY(pr, parent), stageRect.top, zoom);
    #|    var nay = localY(nodeAnchorY(nr, node), stageRect.top, zoom);
    #|    if (layout === "tree") {
    #|      var sy = localY(pr.bottom, stageRect.top, zoom);
    #|      var ey = localY(nr.top, stageRect.top, zoom);
    #|      var bendY = Math.min(44, Math.max(16, Math.abs(ey - sy) * 0.4));
    #|      return { sx: pcx, sy: sy, c1x: pcx, c1y: sy + bendY, c2x: ncx, c2y: ey - bendY, ex: ncx, ey: ey };
    #|    }
    #|    if (layout === "logic") {
    #|      var sx = localX(pr.right, stageRect.left, zoom);
    #|      var ex = localX(nr.left, stageRect.left, zoom);
    #|      var bendX = Math.min(36, Math.max(14, Math.abs(ex - sx) * 0.28));
    #|      return { sx: sx, sy: pay, c1x: sx + bendX, c1y: pay, c2x: ex - bendX, c2y: nay, ex: ex, ey: nay };
    #|    }
    #|    var direction = ncx >= pcx ? 1 : -1;
    #|    var startX = localX(direction > 0 ? pr.right : pr.left, stageRect.left, zoom);
    #|    var endX = localX(direction > 0 ? nr.left : nr.right, stageRect.left, zoom);
    #|    var span = Math.abs(endX - startX);
    #|    var isBranch = hasClass(parent, "node--branch-line") || hasClass(node, "node--branch-line");
    #|    if (isBranch) {
    #|      var vertical = Math.abs(nay - pay);
    #|      var handle = Math.min(Math.max(14, span * 0.46), Math.min(68, Math.max(22, span * 0.34 + vertical * 0.2)));
    #|      return { sx: startX, sy: pay, c1x: startX + direction * handle, c1y: pay, c2x: endX - direction * handle, c2y: nay, ex: endX, ey: nay };
    #|    }
    #|    var pull = Math.min(30, Math.max(12, span * 0.26));
    #|    var settle = Math.min(40, Math.max(14, span * 0.38));
    #|    var midY = pcy + (ncy - pcy) * 0.2;
    #|    return { sx: startX, sy: pay, c1x: startX + direction * pull, c1y: midY, c2x: endX - direction * settle, c2y: nay, ex: endX, ey: nay };
    #|  }
    #|  function appendPath(svg, d, stroke, width) {
    #|    var path = document.createElementNS("http://www.w3.org/2000/svg", "path");
    #|    path.setAttribute("d", d);
    #|    path.setAttribute("fill", "none");
    #|    path.setAttribute("stroke", stroke);
    #|    path.setAttribute("stroke-opacity", "0.9");
    #|    path.setAttribute("stroke-width", String(width));
    #|    path.setAttribute("stroke-linecap", "round");
    #|    path.setAttribute("stroke-linejoin", "round");
    #|    path.setAttribute("vector-effect", "non-scaling-stroke");
    #|    svg.appendChild(path);
    #|  }
    #|  function nodeVisible(node) {
    #|    var container = node.closest(".branch-item, .vertical-tree, .single-right-tree__node");
    #|    return !(container && container.hasAttribute("hidden"));
    #|  }
    #|  function setHidden(element, hidden) {
    #|    if (!element) return;
    #|    if (hidden) {
    #|      element.setAttribute("hidden", "");
    #|      element.style.setProperty("display", "none", "important");
    #|    } else {
    #|      element.removeAttribute("hidden");
    #|      element.style.removeProperty("display");
    #|    }
    #|  }
    #|  function renderConnectors(root) {
    #|    var stage = root.querySelector(".mindmap-stage");
    #|    if (!stage) return;
    #|    var existing = stage.querySelector(".mindmap-connector-layer");
    #|    if (existing) existing.remove();
    #|    var nodes = Array.prototype.slice.call(stage.querySelectorAll(".node[data-node-index]")).filter(nodeVisible);
    #|    if (nodes.length <= 1) return;
    #|    var rect = stage.getBoundingClientRect();
    #|    var svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    #|    svg.setAttribute("class", "mindmap-connector-layer");
    #|    svg.setAttribute("width", String(Math.max(1, Math.ceil(rect.width))));
    #|    svg.setAttribute("height", String(Math.max(1, Math.ceil(rect.height))));
    #|    svg.setAttribute("viewBox", "0 0 " + Math.max(1, Math.ceil(rect.width)) + " " + Math.max(1, Math.ceil(rect.height)));
    #|    var layout = layoutKind(stage);
    #|    var stroke = hasClass(stage, "mindmap-stage--fill") ? "#7ca5d4" : "#94b6db";
    #|    nodes.forEach(function (node) {
    #|      var parentIndex = node.getAttribute("data-parent-index");
    #|      if (parentIndex === null || parentIndex === "-1") return;
    #|      var parent = stage.querySelector('.node[data-node-index="' + parentIndex + '"]');
    #|      if (!parent || !nodeVisible(parent)) return;
    #|      var data = pathData(layout, parent, node, rect, 1);
    #|      appendPath(svg, "M " + data.sx + " " + data.sy + " C " + data.c1x + " " + data.c1y + ", " + data.c2x + " " + data.c2y + ", " + data.ex + " " + data.ey, stroke, strokeWidth(node, parent));
    #|    });
    #|    stage.insertBefore(svg, stage.firstChild);
    #|  }
    #|  function applyCollapsed(root) {
    #|    var cards = Array.prototype.slice.call(root.querySelectorAll(".node[data-node-index]"));
    #|    function parentOf(index) {
    #|      var card = root.querySelector('.node[data-node-index="' + index + '"]');
    #|      return card ? card.getAttribute("data-parent-index") : "-1";
    #|    }
    #|    function hiddenByAncestor(index) {
    #|      var cursor = parentOf(index);
    #|      while (cursor !== null && cursor !== "-1") {
    #|        var parent = root.querySelector('.node[data-node-index="' + cursor + '"]');
    #|        if (parent && parent.getAttribute("data-collapsed") === "true") return true;
    #|        cursor = parentOf(cursor);
    #|      }
    #|      return false;
    #|    }
    #|    cards.forEach(function (card) {
    #|      var index = card.getAttribute("data-node-index");
    #|      var container = card.closest(".branch-item, .vertical-tree, .single-right-tree__node");
    #|      if (container && card.getAttribute("data-parent-index") !== "-1") setHidden(container, hiddenByAncestor(index));
    #|      var button = card.querySelector('[data-action="toggle"]');
    #|      if (button) {
    #|        var collapsed = card.getAttribute("data-collapsed") === "true";
    #|        button.setAttribute("aria-expanded", String(!collapsed));
    #|        button.classList.toggle("node-action--collapsed", collapsed);
    #|        button.textContent = collapsed ? (card.getAttribute("data-hidden-count") || "") : "";
    #|      }
    #|    });
    #|    renderConnectors(root);
    #|  }
    #|  function bind(root) {
    #|    root.addEventListener("click", function (event) {
    #|      var toggle = event.target.closest('[data-action="toggle"]');
    #|      if (toggle) {
    #|        var card = toggle.closest(".node[data-node-index]");
    #|        if (card) {
    #|          card.setAttribute("data-collapsed", String(card.getAttribute("data-collapsed") !== "true"));
    #|          applyCollapsed(root);
    #|          event.preventDefault();
    #|        }
    #|        return;
    #|      }
    #|      var note = event.target.closest('[data-action="toggle-note"]');
    #|      if (note) {
    #|        var noteCard = note.closest(".node[data-node-index]");
    #|        var body = noteCard && noteCard.querySelector("[data-note-preview-for]");
    #|        if (body) {
    #|          var nextHidden = !body.hasAttribute("hidden");
    #|          setHidden(body, nextHidden);
    #|          note.setAttribute("aria-expanded", String(!nextHidden));
    #|          renderConnectors(root);
    #|          event.preventDefault();
    #|        }
    #|      }
    #|    });
    #|    window.addEventListener("resize", function () { renderConnectors(root); });
    #|    applyCollapsed(root);
    #|    setTimeout(function () { renderConnectors(root); }, 60);
    #|    setTimeout(function () { renderConnectors(root); }, 240);
    #|  }
    #|  document.addEventListener("DOMContentLoaded", function () {
    #|    Array.prototype.slice.call(document.querySelectorAll(".moonmarkmind-export")).forEach(bind);
    #|  });
    #|})();
    #|</script>
  )
}

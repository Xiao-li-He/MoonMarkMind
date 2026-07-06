///|
pub(all) struct MindmapStyleDeclaration {
  property : String
  value : String
}

///|
pub(all) struct MindmapStyleRule {
  selector : String
  class_name : String
  ancestor_class : String?
  declarations : Array[MindmapStyleDeclaration]
}

///|
fn mindmap_decl(property : String, value : String) -> MindmapStyleDeclaration {
  { property, value }
}

///|
fn mindmap_rule(
  selector : String,
  class_name : String,
  declarations : Array[MindmapStyleDeclaration],
  ancestor_class? : String,
) -> MindmapStyleRule {
  { selector, class_name, ancestor_class, declarations }
}

///|
pub fn mindmap_style_rules() -> Array[MindmapStyleRule] {
  [
    mindmap_rule(".moonmarkmind-export", "moonmarkmind-export", [
      mindmap_decl("box-sizing", "border-box"),
      mindmap_decl("min-width", "100%"),
      mindmap_decl("min-height", "100%"),
      mindmap_decl("padding", "48px"),
      mindmap_decl("color", "#23384d"),
      mindmap_decl("background", "#f6fbff"),
      mindmap_decl(
        "font-family", "\"Segoe UI\", \"PingFang SC\", \"Microsoft YaHei\", sans-serif",
      ),
      mindmap_decl("line-height", "1.45"),
    ]),
    mindmap_rule(".mindmap", "mindmap", [
      mindmap_decl("width", "100%"),
      mindmap_decl("min-height", "620px"),
      mindmap_decl("overflow", "visible"),
    ]),
    mindmap_rule(".mindmap-content", "mindmap-content", [
      mindmap_decl("display", "inline-block"),
      mindmap_decl("min-width", "100%"),
      mindmap_decl("transform", "none"),
    ]),
    mindmap_rule(".mindmap-stage", "mindmap-stage", [
      mindmap_decl("position", "relative"),
      mindmap_decl("display", "inline-flex"),
      mindmap_decl("align-items", "center"),
      mindmap_decl("justify-content", "center"),
      mindmap_decl("min-width", "100%"),
      mindmap_decl("gap", "44px"),
    ]),
    mindmap_rule(".mindmap-stage--radial", "mindmap-stage--radial", [
      mindmap_decl("align-items", "center"),
    ]),
    mindmap_rule(".mindmap-stage--fill", "mindmap-stage--fill", [
      mindmap_decl("--mindmap-connector-color", "#7ca5d4"),
      mindmap_decl("--mindmap-connector-accent", "#5c88a8"),
    ]),
    mindmap_rule(".mindmap-stage--branch-line", "mindmap-stage--branch-line", [
      mindmap_decl("--mindmap-connector-color", "#94b6db"),
      mindmap_decl("--mindmap-connector-accent", "#5c88a8"),
    ]),
    mindmap_rule(".mindmap-stage--line", "mindmap-stage--line", [
      mindmap_decl("--mindmap-connector-color", "#94b6db"),
      mindmap_decl("--mindmap-connector-accent", "#5c88a8"),
    ]),
    mindmap_rule(
      ".mindmap-stage--single-right",
      "mindmap-stage--single-right",
      [mindmap_decl("justify-content", "flex-start")],
    ),
    mindmap_rule(".mindmap-stage--vertical", "mindmap-stage--vertical", [
      mindmap_decl("align-items", "flex-start"),
    ]),
    mindmap_rule(".center-wrap", "center-wrap", [
      mindmap_decl("display", "flex"),
      mindmap_decl("align-items", "center"),
      mindmap_decl("justify-content", "center"),
      mindmap_decl("flex", "0 0 auto"),
    ]),
    mindmap_rule(".branch-column", "branch-column", [
      mindmap_decl("display", "flex"),
      mindmap_decl("flex-direction", "column"),
      mindmap_decl("gap", "24px"),
      mindmap_decl("min-width", "220px"),
    ]),
    mindmap_rule(".branch-column--left", "branch-column--left", [
      mindmap_decl("align-items", "flex-end"),
    ]),
    mindmap_rule(".branch-column--right", "branch-column--right", [
      mindmap_decl("align-items", "flex-start"),
    ]),
    mindmap_rule(".branch-item", "branch-item", [
      mindmap_decl("position", "relative"),
      mindmap_decl("display", "flex"),
      mindmap_decl("align-items", "center"),
      mindmap_decl("gap", "20px"),
    ]),
    mindmap_rule(".branch-item--left", "branch-item--left", [
      mindmap_decl("justify-content", "flex-end"),
    ]),
    mindmap_rule(".branch-item--right", "branch-item--right", [
      mindmap_decl("justify-content", "flex-start"),
    ]),
    mindmap_rule(".branch-children", "branch-children", [
      mindmap_decl("display", "flex"),
      mindmap_decl("flex-direction", "column"),
      mindmap_decl("gap", "18px"),
      mindmap_decl(
        "border-left", "2px solid var(--mindmap-connector-color, #94b6db)",
      ),
      mindmap_decl("padding-left", "26px"),
    ]),
    mindmap_rule(".branch-children--left", "branch-children--left", [
      mindmap_decl("align-items", "flex-end"),
      mindmap_decl("border-left", "0"),
      mindmap_decl(
        "border-right", "2px solid var(--mindmap-connector-color, #94b6db)",
      ),
      mindmap_decl("padding-left", "0"),
      mindmap_decl("padding-right", "26px"),
    ]),
    mindmap_rule(".branch-children--right", "branch-children--right", [
      mindmap_decl("align-items", "flex-start"),
    ]),
    mindmap_rule(".branch-item__head", "branch-item__head", [
      mindmap_decl("position", "relative"),
      mindmap_decl("flex", "0 0 auto"),
    ]),
    mindmap_rule(".single-right-tree", "single-right-tree", [
      mindmap_decl("display", "flex"),
      mindmap_decl("align-items", "center"),
      mindmap_decl("gap", "24px"),
    ]),
    mindmap_rule(".single-right-tree__node", "single-right-tree__node", [
      mindmap_decl("position", "relative"),
      mindmap_decl("display", "flex"),
      mindmap_decl("align-items", "center"),
      mindmap_decl("gap", "24px"),
    ]),
    mindmap_rule(".single-right-tree__head", "single-right-tree__head", [
      mindmap_decl("position", "relative"),
      mindmap_decl("flex", "0 0 auto"),
    ]),
    mindmap_rule(
      ".single-right-tree__children",
      "single-right-tree__children",
      [
        mindmap_decl("display", "flex"),
        mindmap_decl("flex-direction", "column"),
        mindmap_decl("gap", "18px"),
        mindmap_decl(
          "border-left", "2px solid var(--mindmap-connector-color, #94b6db)",
        ),
        mindmap_decl("padding-left", "26px"),
      ],
    ),
    mindmap_rule(".vertical-root", "vertical-root", [
      mindmap_decl("display", "flex"),
      mindmap_decl("flex-direction", "column"),
      mindmap_decl("align-items", "center"),
    ]),
    mindmap_rule(".vertical-tree", "vertical-tree", [
      mindmap_decl("position", "relative"),
      mindmap_decl("display", "flex"),
      mindmap_decl("flex-direction", "column"),
      mindmap_decl("align-items", "center"),
      mindmap_decl("gap", "22px"),
    ]),
    mindmap_rule(".vertical-tree__children", "vertical-tree__children", [
      mindmap_decl("display", "flex"),
      mindmap_decl("align-items", "flex-start"),
      mindmap_decl("justify-content", "center"),
      mindmap_decl("gap", "28px"),
      mindmap_decl("padding-top", "28px"),
      mindmap_decl(
        "border-top", "2px solid var(--mindmap-connector-color, #94b6db)",
      ),
    ]),
    mindmap_rule(".vertical-tree__child", "vertical-tree__child", [
      mindmap_decl("position", "relative"),
    ]),
    mindmap_rule(".node", "node", [
      mindmap_decl("position", "relative"),
      mindmap_decl("display", "inline-flex"),
      mindmap_decl("flex-direction", "column"),
      mindmap_decl("align-items", "center"),
      mindmap_decl("justify-content", "center"),
      mindmap_decl("min-width", "120px"),
      mindmap_decl("max-width", "280px"),
      mindmap_decl("padding", "12px 16px"),
      mindmap_decl("color", "#23384d"),
      mindmap_decl("background", "#ffffff"),
      mindmap_decl("border", "2px solid var(--mindmap-node-border, #d7e3ef)"),
      mindmap_decl("border-radius", "14px"),
      mindmap_decl("box-shadow", "0 14px 34px rgba(72, 100, 132, 0.14)"),
      mindmap_decl("text-align", "center"),
      mindmap_decl("word-break", "break-word"),
    ]),
    mindmap_rule(
      ".moonmarkmind-export--line .node",
      "node",
      [
        mindmap_decl("background", "transparent"),
        mindmap_decl("border-color", "var(--mindmap-connector-color, #7fa6cb)"),
        mindmap_decl("box-shadow", "none"),
      ],
      ancestor_class="moonmarkmind-export--line",
    ),
    mindmap_rule(".node--center", "node--center", [
      mindmap_decl("min-width", "180px"),
      mindmap_decl("padding", "18px 22px"),
      mindmap_decl("color", "#15364a"),
      mindmap_decl("border-color", "#69b6d6"),
      mindmap_decl("box-shadow", "0 18px 40px rgba(68, 148, 179, 0.2)"),
    ]),
    mindmap_rule(".node--line", "node--line", [
      mindmap_decl("background", "#ffffff"),
    ]),
    mindmap_rule(".node--fill", "node--fill", [
      mindmap_decl("color", "#163348"),
      mindmap_decl(
        "background", "linear-gradient(180deg, #ffffff 0%, #f1f8ff 100%)",
      ),
    ]),
    mindmap_rule(".node--branch-line", "node--branch-line", [
      mindmap_decl("border-radius", "8px"),
      mindmap_decl("border-width", "0 0 3px"),
      mindmap_decl("box-shadow", "none"),
    ]),
    mindmap_rule(".node-title", "node-title", [
      mindmap_decl("display", "block"),
      mindmap_decl("font-size", "15px"),
      mindmap_decl("font-weight", "700"),
      mindmap_decl("letter-spacing", "0"),
      mindmap_decl("line-height", "1.35"),
    ]),
    mindmap_rule(
      ".node--center .node-title",
      "node-title",
      [mindmap_decl("font-size", "18px")],
      ancestor_class="node--center",
    ),
    mindmap_rule(".node-note-rail", "node-note-rail", [
      mindmap_decl("width", "100%"),
      mindmap_decl("margin-top", "10px"),
    ]),
    mindmap_rule(".node-body", "node-body", [
      mindmap_decl("width", "100%"),
      mindmap_decl("max-width", "260px"),
      mindmap_decl("padding", "8px 10px"),
      mindmap_decl("color", "#44546a"),
      mindmap_decl("background", "rgba(248, 251, 254, 0.95)"),
      mindmap_decl("border", "1px solid #dce8f2"),
      mindmap_decl("border-radius", "10px"),
      mindmap_decl("font-size", "12px"),
      mindmap_decl("text-align", "left"),
    ]),
    mindmap_rule(
      ".moonmarkmind-export--small .node-body",
      "node-body",
      [mindmap_decl("display", "none")],
      ancestor_class="moonmarkmind-export--small",
    ),
    mindmap_rule(
      ".moonmarkmind-export--medium .node-body",
      "node-body",
      [mindmap_decl("display", "none")],
      ancestor_class="moonmarkmind-export--medium",
    ),
    mindmap_rule(".node-body-preview", "node-body-preview", [
      mindmap_decl("text-align", "left"),
    ]),
    mindmap_rule(".node-body-block", "node-body-block", [
      mindmap_decl("position", "relative"),
      mindmap_decl("box-sizing", "border-box"),
      mindmap_decl("width", "100%"),
    ]),
  ]
}

///|
/// Render the shared mind-map visual rules as CSS for standalone exports.
pub fn mindmap_style_css() -> String {
  let blocks = []
  for rule in mindmap_style_rules() {
    let declarations = []
    for declaration in rule.declarations {
      declarations.push("\{declaration.property}: \{declaration.value};")
    }
    blocks.push("\{rule.selector} { \{declarations.join(" ")} }")
  }
  blocks.join("\n")
}

///|
/// One CSS-style declaration in the shared Markdown visual spec.
pub(all) struct MarkdownStyleDeclaration {
  property : String
  value : String
}

///|
/// One shared Markdown visual rule.
pub(all) struct MarkdownStyleRule {
  selector : String
  class_name : String
  tag_name : String?
  ancestor_class : String?
  declarations : Array[MarkdownStyleDeclaration]
}

///|
fn markdown_decl(property : String, value : String) -> MarkdownStyleDeclaration {
  MarkdownStyleDeclaration::{ property, value }
}

///|
fn markdown_rule(
  selector : String,
  class_name : String,
  tag_name : String?,
  ancestor_class : String?,
  declarations : Array[MarkdownStyleDeclaration],
) -> MarkdownStyleRule {
  MarkdownStyleRule::{
    selector,
    class_name,
    tag_name,
    ancestor_class,
    declarations,
  }
}

///|
/// Shared visual rules for Markdown HTML fragments emitted by this package.
pub fn markdown_style_rules() -> Array[MarkdownStyleRule] {
  [
    markdown_rule(".markdown-heading", "markdown-heading", None, None, [
      markdown_decl("margin", "0 0 0.45em"),
      markdown_decl("line-height", "1.25"),
    ]),
    markdown_rule(".markdown-heading--h1", "markdown-heading--h1", None, None, [
      markdown_decl("font-size", "1.55em"),
    ]),
    markdown_rule(".markdown-heading--h2", "markdown-heading--h2", None, None, [
      markdown_decl("font-size", "1.35em"),
    ]),
    markdown_rule(".markdown-heading--h3", "markdown-heading--h3", None, None, [
      markdown_decl("font-size", "1.2em"),
    ]),
    markdown_rule(".markdown-heading--h4", "markdown-heading--h4", None, None, [
      markdown_decl("font-size", "1.05em"),
    ]),
    markdown_rule(".markdown-heading--h5", "markdown-heading--h5", None, None, [
      markdown_decl("font-size", "1.05em"),
    ]),
    markdown_rule(".markdown-heading--h6", "markdown-heading--h6", None, None, [
      markdown_decl("font-size", "1.05em"),
    ]),
    markdown_rule(".markdown-paragraph", "markdown-paragraph", None, None, [
      markdown_decl("margin", "0 0 0.75em"),
      markdown_decl("white-space", "normal"),
    ]),
    markdown_rule(".markdown-strong", "markdown-strong", None, None, [
      markdown_decl("font-weight", "800"),
    ]),
    markdown_rule(".markdown-emphasis", "markdown-emphasis", None, None, [
      markdown_decl("font-style", "italic"),
    ]),
    markdown_rule(".markdown-inline-code", "markdown-inline-code", None, None, [
      markdown_decl("display", "inline-block"),
      markdown_decl("padding", "1px 4px"),
      markdown_decl("border-radius", "5px"),
      markdown_decl("background", "rgba(32, 57, 82, 0.1)"),
      markdown_decl("color", "#28415d"),
      markdown_decl("font-family", "\"Cascadia Mono\", Consolas, monospace"),
      markdown_decl("font-size", "0.92em"),
    ]),
    markdown_rule(".markdown-strike", "markdown-strike", None, None, [
      markdown_decl("text-decoration", "line-through"),
      markdown_decl("opacity", "0.74"),
    ]),
    markdown_rule(".markdown-link", "markdown-link", None, None, [
      markdown_decl("color", "#2c70ce"),
      markdown_decl("text-decoration", "underline"),
      markdown_decl("text-underline-offset", "2px"),
    ]),
    markdown_rule(".markdown-image", "markdown-image", None, None, [
      markdown_decl("display", "block"),
      markdown_decl("max-width", "100%"),
      markdown_decl("max-height", "96px"),
      markdown_decl("height", "auto"),
      markdown_decl("width", "auto"),
      markdown_decl("margin", "0"),
      markdown_decl("border-radius", "6px"),
      markdown_decl("object-fit", "contain"),
    ]),
    markdown_rule(".markdown-list", "markdown-list", None, None, [
      markdown_decl("margin", "0 0 0.75em"),
      markdown_decl("padding-left", "1.35em"),
    ]),
    markdown_rule(
      ".markdown-list .markdown-list",
      "markdown-list",
      None,
      Some("markdown-list__item"),
      [markdown_decl("margin", "0.18em 0 0")],
    ),
    markdown_rule(".markdown-list__item", "markdown-list__item", None, None, [
      markdown_decl("margin", "0.12em 0"),
    ]),
    markdown_rule(".markdown-task", "markdown-task", None, None, [
      markdown_decl("display", "flex"),
      markdown_decl("align-items", "flex-start"),
      markdown_decl("gap", "6px"),
      markdown_decl("margin", "0 0 0.75em"),
    ]),
    markdown_rule(".markdown-task--title", "markdown-task--title", None, None, [
      markdown_decl("display", "inline-flex"),
      markdown_decl("align-items", "center"),
      markdown_decl("margin", "0"),
    ]),
    markdown_rule(".markdown-task__check", "markdown-task__check", None, None, [
      markdown_decl("width", "13px"),
      markdown_decl("height", "13px"),
      markdown_decl("margin", "2px 0 0 0"),
      markdown_decl("flex", "0 0 auto"),
    ]),
    markdown_rule(".markdown-code-block", "markdown-code-block", None, None, [
      markdown_decl("margin", "0 0 0.85em"),
      markdown_decl("padding", "9px 10px"),
      markdown_decl("border-radius", "6px"),
      markdown_decl("background", "rgba(32, 57, 82, 0.08)"),
      markdown_decl("overflow-x", "auto"),
    ]),
    markdown_rule(
      ".markdown-code-block__code",
      "markdown-code-block__code",
      None,
      None,
      [
        markdown_decl("font-family", "\"Cascadia Mono\", Consolas, monospace"),
        markdown_decl("font-size", "0.92em"),
        markdown_decl("white-space", "pre"),
      ],
    ),
    markdown_rule(".markdown-table", "markdown-table", None, None, [
      markdown_decl("width", "100%"),
      markdown_decl("border-collapse", "collapse"),
      markdown_decl("font-size", "11px"),
      markdown_decl("line-height", "1.35"),
      markdown_decl("overflow", "hidden"),
      markdown_decl("margin", "0 0 0.85em"),
    ]),
    markdown_rule(
      ".markdown-table th",
      "",
      Some("TH"),
      Some("markdown-table"),
      [
        markdown_decl("padding", "3px 5px"),
        markdown_decl("border", "1px solid rgba(167, 190, 214, 0.5)"),
        markdown_decl("vertical-align", "top"),
        markdown_decl("word-break", "break-word"),
        markdown_decl("font-weight", "800"),
        markdown_decl("background", "rgba(214, 230, 245, 0.5)"),
      ],
    ),
    markdown_rule(
      ".markdown-table td",
      "",
      Some("TD"),
      Some("markdown-table"),
      [
        markdown_decl("padding", "3px 5px"),
        markdown_decl("border", "1px solid rgba(167, 190, 214, 0.5)"),
        markdown_decl("vertical-align", "top"),
        markdown_decl("word-break", "break-word"),
      ],
    ),
  ]
}

///|
/// Render the shared Markdown visual rules as CSS for standalone HTML exports.
pub fn markdown_style_css() -> String {
  let blocks = []
  for rule in markdown_style_rules() {
    let declarations = []
    for declaration in rule.declarations {
      declarations.push("\{declaration.property}: \{declaration.value};")
    }
    blocks.push("\{rule.selector} { \{declarations.join(" ")} }")
  }
  blocks.join("\n")
}

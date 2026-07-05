///|
/// One CSS-style declaration in the shared math visual spec.
pub(all) struct MathStyleDeclaration {
  property : String
  value : String
}

///|
/// One shared math visual rule.
///
/// `class_name` is the target class used by MoonBit DOM styling paths.
/// `ancestor_class` is optional and represents selectors such as
/// `.markdown-math-sqrt--tall .markdown-math-sqrt__svg`.
pub(all) struct MathStyleRule {
  selector : String
  class_name : String
  ancestor_class : String?
  declarations : Array[MathStyleDeclaration]
}

///|
fn math_decl(property : String, value : String) -> MathStyleDeclaration {
  MathStyleDeclaration::{ property, value }
}

///|
fn math_rule(
  selector : String,
  class_name : String,
  ancestor_class : String?,
  declarations : Array[MathStyleDeclaration],
) -> MathStyleRule {
  MathStyleRule::{ selector, class_name, ancestor_class, declarations }
}

///|
/// Shared visual rules for the HTML produced by this package.
pub fn math_style_rules() -> Array[MathStyleRule] {
  [
    math_rule(".markdown-math", "markdown-math", None, [
      math_decl("font-family", "\"Cambria Math\", \"Times New Roman\", serif"),
      math_decl("color", "#24384f"),
      math_decl("line-height", "1.35"),
      math_decl("max-width", "100%"),
      math_decl("box-sizing", "border-box"),
    ]),
    math_rule(".markdown-math--inline", "markdown-math--inline", None, [
      math_decl("display", "inline-flex"),
      math_decl("align-items", "center"),
      math_decl("vertical-align", "middle"),
      math_decl("padding", "0 2px"),
    ]),
    math_rule(".markdown-math--block", "markdown-math--block", None, [
      math_decl("display", "flex"),
      math_decl("justify-content", "center"),
      math_decl("width", "100%"),
      math_decl("padding", "6px 4px"),
      math_decl("text-align", "center"),
      math_decl("overflow-x", "auto"),
      math_decl("overflow-y", "hidden"),
      math_decl("font-size", "1.05em"),
    ]),
    math_rule(".markdown-math-frac", "markdown-math-frac", None, [
      math_decl("display", "inline-flex"),
      math_decl("flex-direction", "column"),
      math_decl("align-items", "stretch"),
      math_decl("vertical-align", "middle"),
      math_decl("margin", "0 2px"),
      math_decl("line-height", "1.1"),
    ]),
    math_rule(".markdown-math-frac__num", "markdown-math-frac__num", None, [
      math_decl("border-bottom", "1px solid currentColor"),
      math_decl("padding", "0 4px 2px"),
      math_decl("text-align", "center"),
    ]),
    math_rule(".markdown-math-frac__den", "markdown-math-frac__den", None, [
      math_decl("padding", "2px 4px 0"),
      math_decl("text-align", "center"),
    ]),
    math_rule(".markdown-math-sqrt", "markdown-math-sqrt", None, [
      math_decl("display", "inline-block"),
      math_decl("position", "relative"),
      math_decl("vertical-align", "-0.1em"),
      math_decl("margin", "0 2px"),
      math_decl("line-height", "1"),
    ]),
    math_rule(
      ".markdown-math-sqrt__symbol",
      "markdown-math-sqrt__symbol",
      None,
      [
        math_decl("display", "inline-block"),
        math_decl("font-size", "1.5em"),
        math_decl("line-height", "0.72"),
        math_decl("padding-right", "0"),
        math_decl("transform", "translateY(0.1em) scaleX(0.9)"),
        math_decl("transform-origin", "right bottom"),
      ],
    ),
    math_rule(
      ".markdown-math-sqrt__radical",
      "markdown-math-sqrt__radical",
      None,
      [
        math_decl("position", "absolute"),
        math_decl("left", "0"),
        math_decl("right", "0"),
        math_decl("top", "0"),
        math_decl("bottom", "0"),
        math_decl("overflow", "hidden"),
        math_decl("pointer-events", "none"),
      ],
    ),
    math_rule(".markdown-math-sqrt__svg", "markdown-math-sqrt__svg", None, [
      math_decl("display", "block"),
      math_decl("width", "400em"),
      math_decl("height", "1.12em"),
      math_decl("max-width", "none"),
    ]),
    math_rule(
      ".markdown-math-sqrt--tall .markdown-math-sqrt__svg",
      "markdown-math-sqrt__svg",
      Some("markdown-math-sqrt--tall"),
      [math_decl("height", "2.25em")],
    ),
    math_rule(".markdown-math-sqrt__path", "markdown-math-sqrt__path", None, [
      math_decl("fill", "currentColor"),
    ]),
    math_rule(
      ".markdown-math-sqrt__radicand",
      "markdown-math-sqrt__radicand",
      None,
      [
        math_decl("display", "inline-block"),
        math_decl("position", "relative"),
        math_decl("padding", "0.18em 0.12em 0 0.86em"),
        math_decl("line-height", "1"),
        math_decl("z-index", "1"),
      ],
    ),
    math_rule(
      ".markdown-math-sqrt--tall .markdown-math-sqrt__radicand",
      "markdown-math-sqrt__radicand",
      Some("markdown-math-sqrt--tall"),
      [math_decl("padding", "0.32em 0.14em 0 0.96em")],
    ),
    math_rule(".markdown-math-lines", "markdown-math-lines", None, [
      math_decl("display", "inline-flex"),
      math_decl("flex-direction", "column"),
      math_decl("align-items", "center"),
      math_decl("gap", "4px"),
      math_decl("max-width", "100%"),
    ]),
    math_rule(".markdown-math-row", "markdown-math-row", None, [
      math_decl("display", "inline-flex"),
      math_decl("align-items", "center"),
      math_decl("justify-content", "center"),
      math_decl("white-space", "nowrap"),
    ]),
    math_rule(
      ".markdown-math-row--aligned",
      "markdown-math-row--aligned",
      None,
      [
        math_decl("display", "inline-grid"),
        math_decl("grid-auto-flow", "column"),
        math_decl("grid-auto-columns", "max-content"),
        math_decl("column-gap", "6px"),
        math_decl("align-items", "center"),
        math_decl("justify-content", "center"),
      ],
    ),
    math_rule(".markdown-math-align-cell", "markdown-math-align-cell", None, [
      math_decl("display", "inline-flex"),
      math_decl("align-items", "center"),
      math_decl("white-space", "nowrap"),
    ]),
    math_rule(".markdown-math-scripted", "markdown-math-scripted", None, [
      math_decl("display", "inline-flex"),
      math_decl("align-items", "baseline"),
      math_decl("vertical-align", "middle"),
      math_decl("line-height", "1"),
    ]),
    math_rule(".markdown-math sup", "sup", Some("markdown-math"), [
      math_decl("display", "inline-block"),
      math_decl("font-size", "0.68em"),
      math_decl("line-height", "1"),
      math_decl("vertical-align", "baseline"),
      math_decl("transform", "translateY(-0.48em)"),
      math_decl("margin-left", "1px"),
    ]),
    math_rule(".markdown-math sub", "sub", Some("markdown-math"), [
      math_decl("display", "inline-block"),
      math_decl("font-size", "0.68em"),
      math_decl("line-height", "1"),
      math_decl("vertical-align", "baseline"),
      math_decl("transform", "translateY(0.28em)"),
      math_decl("margin-left", "1px"),
    ]),
    math_rule(".markdown-math-sqrt__index", "markdown-math-sqrt__index", None, [
      math_decl("position", "absolute"),
      math_decl("left", "-0.34em"),
      math_decl("top", "-0.34em"),
      math_decl("font-size", "0.62em"),
      math_decl("line-height", "1"),
      math_decl("align-self", "flex-start"),
      math_decl("z-index", "2"),
    ]),
    math_rule(".markdown-math-text", "markdown-math-text", None, [
      math_decl("font-family", "inherit"),
      math_decl("font-style", "normal"),
    ]),
    math_rule(".markdown-math-op", "markdown-math-op", None, [
      math_decl("font-family", "inherit"),
      math_decl("font-style", "normal"),
      math_decl("padding", "0 1px"),
    ]),
  ]
}

///|
/// Render the shared math visual rules as CSS for standalone HTML exports.
pub fn math_style_css() -> String {
  let blocks = []
  for rule in math_style_rules() {
    let declarations = []
    for declaration in rule.declarations {
      declarations.push("\{declaration.property}: \{declaration.value};")
    }
    blocks.push("\{rule.selector} { \{declarations.join(" ")} }")
  }
  blocks.join("\n")
}

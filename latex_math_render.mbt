///|
priv enum LatexMathNode {
  MathRow(Array[LatexMathNode])
  MathText(String)
  MathSymbol(String)
  MathFrac(Array[LatexMathNode], Array[LatexMathNode])
  MathSqrt(String?, Array[LatexMathNode])
  MathSupSub(LatexMathNode, LatexMathNode?, LatexMathNode?)
  MathTextSpan(String)
  MathLineBreak
  MathAlignSep
}

///|
fn render_latex_math_inline_html(source : String) -> SafeHtml {
  let normalized = normalize_latex_inline_source(source)
  let nodes = parse_latex_math_nodes(normalized.trim().to_string())
  SafeHtml::{ value: render_latex_math_nodes(nodes, inline=true) }
}

///|
fn render_latex_math_block_html(source : String) -> SafeHtml {
  let normalized = normalize_latex_block_source(source)
  let nodes = parse_latex_math_nodes(normalized.trim().to_string())
  SafeHtml::{ value: render_latex_math_block_nodes(nodes) }
}

///|
fn normalize_latex_inline_source(source : String) -> String {
  let parts = []
  let mut pending_space = false
  for ch in source {
    if ch == '\n' || ch == '\r' || ch == '\t' {
      pending_space = true
    } else {
      if pending_space {
        parts.push(" ")
        pending_space = false
      }
      parts.push(ch.to_string())
    }
  }
  parts.join("")
}

///|
fn normalize_latex_block_source(source : String) -> String {
  source.replace(old="\r\n", new="\n").replace(old="\r", new="\n")
}

///|
fn parse_latex_math_nodes(source : String) -> Array[LatexMathNode] {
  parse_latex_until(source, 0, None).0
}

///|
fn parse_latex_until(
  source : String,
  start : Int,
  stop : UInt16?,
) -> (Array[LatexMathNode], Int) {
  let nodes = []
  let mut cursor = start
  while cursor < source.length() {
    match stop {
      Some(stop_char) =>
        if source[cursor] == stop_char {
          return (nodes, cursor + 1)
        }
      None => ()
    }
    if source[cursor] == '}' || source[cursor] == ']' {
      return (nodes, cursor + 1)
    } else if source[cursor] == '{' {
      let parsed = parse_latex_until(source, cursor + 1, Some('}'))
      nodes.push(MathRow(parsed.0))
      cursor = parsed.1
    } else if source[cursor] == '^' || source[cursor] == '_' {
      let parsed = read_latex_script_atom(source, cursor + 1)
      match parsed {
        Some((script, after_script)) => {
          apply_latex_script(nodes, source[cursor] == '^', script)
          cursor = after_script
        }
        None => {
          nodes.push(MathText(source[cursor:cursor + 1].to_string()))
          cursor += 1
        }
      }
    } else if source[cursor] == '\\' {
      if cursor + 1 < source.length() && source[cursor + 1] == '\\' {
        nodes.push(MathLineBreak)
        cursor += 2
        if cursor < source.length() && source[cursor] == '\n' {
          cursor += 1
        }
      } else {
        let (command, after_command) = read_latex_command_name(
          source,
          cursor + 1,
        )
        if command == "over" {
          let denominator = parse_latex_until(source, after_command, stop)
          return ([MathFrac(nodes, denominator.0)], denominator.1)
        } else {
          match parse_latex_command_node(source, command, after_command) {
            Some((node, after_node)) => {
              nodes.push(node)
              cursor = after_node
            }
            None =>
              if command.length() == 0 {
                nodes.push(MathText("\\"))
                cursor += 1
              } else {
                nodes.push(MathText("\\\{command}"))
                cursor = after_command
              }
          }
        }
      }
    } else if source[cursor] == '&' {
      nodes.push(MathAlignSep)
      cursor += 1
    } else if source[cursor] == '\n' {
      nodes.push(MathLineBreak)
      cursor += 1
    } else {
      let (text, after_text) = read_latex_plain_text(source, cursor)
      nodes.push(MathText(text))
      cursor = after_text
    }
  }
  (nodes, cursor)
}

///|
fn apply_latex_script(
  nodes : Array[LatexMathNode],
  is_sup : Bool,
  script : LatexMathNode,
) -> Unit {
  if nodes.length() == 0 {
    nodes.push(if is_sup { MathText("^") } else { MathText("_") })
    nodes.push(script)
    return
  }
  let base_node = nodes[nodes.length() - 1]
  let _ = nodes.pop()
  match base_node {
    MathSupSub(base, sub, sup) =>
      nodes.push(
        if is_sup {
          MathSupSub(base, sub, Some(script))
        } else {
          MathSupSub(base, Some(script), sup)
        },
      )
    _ =>
      nodes.push(
        if is_sup {
          MathSupSub(base_node, None, Some(script))
        } else {
          MathSupSub(base_node, Some(script), None)
        },
      )
  }
}

///|
fn read_latex_script_atom(
  source : String,
  start : Int,
) -> (LatexMathNode, Int)? {
  let cursor = latex_skip_spaces(source, start)
  if cursor >= source.length() {
    return None
  }
  if source[cursor] == '{' {
    let parsed = parse_latex_until(source, cursor + 1, Some('}'))
    Some((MathRow(parsed.0), parsed.1))
  } else if source[cursor] == '\\' {
    if cursor + 1 < source.length() && source[cursor + 1] == '\\' {
      Some((MathText(" "), cursor + 2))
    } else {
      let (command, after_command) = read_latex_command_name(source, cursor + 1)
      match parse_latex_command_node(source, command, after_command) {
        Some((node, after_node)) => Some((node, after_node))
        None =>
          if command.length() == 0 {
            Some((MathText("\\"), cursor + 1))
          } else {
            Some((MathText("\\\{command}"), after_command))
          }
      }
    }
  } else {
    Some((MathText(source[cursor:cursor + 1].to_string()), cursor + 1))
  }
}

///|
fn parse_latex_command_node(
  source : String,
  command : String,
  after_command : Int,
) -> (LatexMathNode, Int)? {
  match command {
    "frac" =>
      match read_latex_group_source(source, after_command) {
        Some((num, after_num)) =>
          match read_latex_group_source(source, after_num) {
            Some((den, after_den)) =>
              Some(
                (
                  MathFrac(
                    parse_latex_math_nodes(num),
                    parse_latex_math_nodes(den),
                  ),
                  after_den,
                ),
              )
            None => None
          }
        None => None
      }
    "sqrt" => {
      let (root_index, after_index) = read_latex_optional_bracket(
        source, after_command,
      )
      match read_latex_group_source(source, after_index) {
        Some((body, after_body)) =>
          Some((MathSqrt(root_index, parse_latex_math_nodes(body)), after_body))
        None => None
      }
    }
    "text" =>
      match read_latex_group_source(source, after_command) {
        Some((text, after_text)) => Some((MathTextSpan(text), after_text))
        None => None
      }
    "left" | "right" => read_latex_delimiter(source, after_command)
    _ =>
      match latex_command_symbol_html(command) {
        Some(symbol) => Some((MathSymbol(symbol), after_command))
        None => None
      }
  }
}

///|
fn read_latex_delimiter(source : String, start : Int) -> (LatexMathNode, Int)? {
  let cursor = latex_skip_spaces(source, start)
  if cursor >= source.length() {
    return None
  }
  if source[cursor] == '\\' {
    let (command, after_command) = read_latex_command_name(source, cursor + 1)
    match latex_command_symbol_html(command) {
      Some(symbol) => Some((MathSymbol(symbol), after_command))
      None => Some((MathText("\\\{command}"), after_command))
    }
  } else {
    Some((MathText(source[cursor:cursor + 1].to_string()), cursor + 1))
  }
}

///|
fn read_latex_group_source(source : String, start : Int) -> (String, Int)? {
  let cursor = latex_skip_spaces(source, start)
  if cursor >= source.length() || source[cursor] != '{' {
    return None
  }
  let mut depth = 1
  let mut index = cursor + 1
  while index < source.length() {
    if source[index] == '{' {
      depth += 1
    } else if source[index] == '}' {
      depth -= 1
      if depth == 0 {
        return Some((source[cursor + 1:index].to_string(), index + 1))
      }
    }
    index += 1
  }
  None
}

///|
fn read_latex_optional_bracket(source : String, start : Int) -> (String?, Int) {
  let cursor = latex_skip_spaces(source, start)
  if cursor >= source.length() || source[cursor] != '[' {
    return (None, start)
  }
  let mut depth = 1
  let mut index = cursor + 1
  while index < source.length() {
    if source[index] == '[' {
      depth += 1
    } else if source[index] == ']' {
      depth -= 1
      if depth == 0 {
        return (Some(source[cursor + 1:index].to_string()), index + 1)
      }
    }
    index += 1
  }
  (None, start)
}

///|
fn read_latex_command_name(source : String, start : Int) -> (String, Int) {
  let mut cursor = start
  while cursor < source.length() && is_latex_ascii_letter(source[cursor]) {
    cursor += 1
  }
  if cursor == start && cursor < source.length() {
    return (source[cursor:cursor + 1].to_string(), cursor + 1)
  }
  (source[start:cursor].to_string(), cursor)
}

///|
fn read_latex_plain_text(source : String, start : Int) -> (String, Int) {
  let mut cursor = start
  while cursor < source.length() &&
        source[cursor] != '{' &&
        source[cursor] != '}' &&
        source[cursor] != '^' &&
        source[cursor] != '_' &&
        source[cursor] != '\\' &&
        source[cursor] != '&' &&
        source[cursor] != '\n' {
    cursor += 1
  }
  (source[start:cursor].to_string(), cursor)
}

///|
fn latex_skip_spaces(source : String, start : Int) -> Int {
  let mut cursor = start
  while cursor < source.length() &&
        (source[cursor] == ' ' || source[cursor] == '\t') {
    cursor += 1
  }
  cursor
}

///|
fn is_latex_ascii_letter(ch : UInt16) -> Bool {
  (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z')
}

///|
fn render_latex_math_block_nodes(nodes : Array[LatexMathNode]) -> String {
  let rows = split_latex_math_rows(nodes)
  let row_html = []
  for row in rows {
    row_html.push(render_latex_math_row(row))
  }
  safe_html_element(
    "span",
    class_name="markdown-math-lines",
    attrs="",
    children=row_html,
  ).value
}

///|
fn render_latex_math_row(nodes : Array[LatexMathNode]) -> SafeHtml {
  let cells = split_latex_math_align_cells(nodes)
  if cells.length() <= 1 {
    safe_html_element("span", class_name="markdown-math-row", attrs="", children=[
      SafeHtml::{ value: render_latex_math_nodes(nodes, inline=false) },
    ])
  } else {
    let rendered_cells = []
    for cell in cells {
      rendered_cells.push(
        safe_html_element(
          "span",
          class_name="markdown-math-align-cell",
          attrs="",
          children=[
            SafeHtml::{ value: render_latex_math_nodes(cell, inline=false) },
          ],
        ),
      )
    }
    safe_html_element(
      "span",
      class_name="markdown-math-row markdown-math-row--aligned",
      attrs="",
      children=rendered_cells,
    )
  }
}

///|
fn split_latex_math_rows(
  nodes : Array[LatexMathNode],
) -> Array[Array[LatexMathNode]] {
  let rows = []
  let current = []
  for node in nodes {
    match node {
      MathLineBreak => {
        rows.push(current.copy())
        current.clear()
      }
      _ => current.push(node)
    }
  }
  if current.length() > 0 || rows.length() == 0 {
    rows.push(current)
  }
  rows
}

///|
fn split_latex_math_align_cells(
  nodes : Array[LatexMathNode],
) -> Array[Array[LatexMathNode]] {
  let cells = []
  let current = []
  for node in nodes {
    match node {
      MathAlignSep => {
        cells.push(current.copy())
        current.clear()
      }
      _ => current.push(node)
    }
  }
  cells.push(current)
  cells
}

///|
fn render_latex_math_nodes(
  nodes : Array[LatexMathNode],
  inline~ : Bool,
) -> String {
  let parts = []
  for node in nodes {
    parts.push(render_latex_math_node(node, inline~))
  }
  parts.join("")
}

///|
fn render_latex_math_node(node : LatexMathNode, inline~ : Bool) -> String {
  match node {
    MathRow(children) => render_latex_math_nodes(children, inline~)
    MathText(text) => safe_html_text(text).value
    MathSymbol(symbol) => symbol
    MathFrac(numerator, denominator) =>
      safe_html_element("span", class_name="markdown-math-frac", attrs="", children=[
        safe_html_element(
          "span",
          class_name="markdown-math-frac__num",
          attrs="",
          children=[
            SafeHtml::{ value: render_latex_math_nodes(numerator, inline~) },
          ],
        ),
        safe_html_element(
          "span",
          class_name="markdown-math-frac__den",
          attrs="",
          children=[
            SafeHtml::{ value: render_latex_math_nodes(denominator, inline~) },
          ],
        ),
      ]).value
    MathSqrt(root_index, body) => {
      let children = []
      match root_index {
        Some(index) =>
          children.push(
            safe_html_element(
              "span",
              class_name="markdown-math-sqrt__index",
              attrs="",
              children=[safe_html_text(index)],
            ),
          )
        None => ()
      }
      children.push(
        safe_html_element(
          "span",
          class_name="markdown-math-sqrt__symbol",
          attrs="",
          children=[SafeHtml::{ value: "&radic;" }],
        ),
      )
      children.push(
        safe_html_element(
          "span",
          class_name="markdown-math-sqrt__radicand",
          attrs="",
          children=[SafeHtml::{ value: render_latex_math_nodes(body, inline~) }],
        ),
      )
      safe_html_element(
        "span",
        class_name="markdown-math-sqrt",
        attrs="",
        children~,
      ).value
    }
    MathSupSub(base, sub, sup) => {
      let children = [
        SafeHtml::{ value: render_latex_math_node(base, inline~) },
      ]
      match sub {
        Some(sub_node) =>
          children.push(
            safe_html_element("sub", class_name="", attrs="", children=[
              SafeHtml::{ value: render_latex_math_node(sub_node, inline~) },
            ]),
          )
        None => ()
      }
      match sup {
        Some(sup_node) =>
          children.push(
            safe_html_element("sup", class_name="", attrs="", children=[
              SafeHtml::{ value: render_latex_math_node(sup_node, inline~) },
            ]),
          )
        None => ()
      }
      safe_html_element(
        "span",
        class_name="markdown-math-scripted",
        attrs="",
        children~,
      ).value
    }
    MathTextSpan(text) =>
      safe_html_element("span", class_name="markdown-math-text", attrs="", children=[
        safe_html_text(text),
      ]).value
    MathLineBreak => if inline { " " } else { "" }
    MathAlignSep => if inline { " " } else { "" }
  }
}

///|
fn latex_command_symbol_html(command : String) -> String? {
  match command {
    "alpha" => Some("&alpha;")
    "beta" => Some("&beta;")
    "gamma" => Some("&gamma;")
    "delta" => Some("&delta;")
    "epsilon" => Some("&epsilon;")
    "theta" => Some("&theta;")
    "lambda" => Some("&lambda;")
    "mu" => Some("&mu;")
    "pi" => Some("&pi;")
    "rho" => Some("&rho;")
    "sigma" => Some("&sigma;")
    "tau" => Some("&tau;")
    "phi" => Some("&phi;")
    "omega" => Some("&omega;")
    "Gamma" => Some("&Gamma;")
    "Delta" => Some("&Delta;")
    "Theta" => Some("&Theta;")
    "Lambda" => Some("&Lambda;")
    "Pi" => Some("&Pi;")
    "Sigma" => Some("&Sigma;")
    "Phi" => Some("&Phi;")
    "Omega" => Some("&Omega;")
    "times" => Some("&times;")
    "cdot" => Some("&middot;")
    "pm" => Some("&plusmn;")
    "le" | "leq" => Some("&le;")
    "ge" | "geq" => Some("&ge;")
    "neq" | "ne" => Some("&ne;")
    "approx" => Some("&asymp;")
    "infty" => Some("&infin;")
    "sum" => Some("&sum;")
    "prod" => Some("&prod;")
    "int" => Some("&int;")
    "rightarrow" | "to" => Some("&rarr;")
    "leftarrow" => Some("&larr;")
    "Rightarrow" => Some("&rArr;")
    "Leftarrow" => Some("&lArr;")
    "leftrightarrow" => Some("&harr;")
    "in" => Some("&isin;")
    "notin" => Some("&notin;")
    "subset" => Some("&sub;")
    "subseteq" => Some("&sube;")
    "supset" => Some("&sup;")
    "supseteq" => Some("&supe;")
    "cup" => Some("&cup;")
    "cap" => Some("&cap;")
    "emptyset" => Some("&empty;")
    "forall" => Some("&forall;")
    "exists" => Some("&exist;")
    "nabla" => Some("&nabla;")
    "partial" => Some("&part;")
    "ldots" | "dots" => Some("&hellip;")
    "sin" | "cos" | "tan" | "log" | "ln" | "lim" | "max" | "min" =>
      Some(
        safe_html_element("span", class_name="markdown-math-op", attrs="", children=[
          safe_html_text(command),
        ]).value,
      )
    "," => Some(" ")
    ";" => Some("&nbsp;")
    ":" => Some("&nbsp;")
    "{" => Some("{")
    "}" => Some("}")
    _ => None
  }
}

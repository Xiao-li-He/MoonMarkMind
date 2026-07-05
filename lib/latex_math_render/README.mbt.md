# latex_math_render

`latex_math_render` 是 MoonMarkMind 的轻量 LaTeX 公式渲染包，用于把行内和块级公式转换为安全 HTML fragment，并提供 SVG fragment 输出入口。

它只处理 MoonMarkMind 节点渲染所需的常见公式子集，不是完整 LaTeX 引擎。

## Install / Import

在使用方 `moon.pkg` 中导入：

```text
import {
  "Xiao-li-He/MoonMarkMind/lib/latex_math_render" @math
}
```

## Quick Start

```mbt check
///|
test {
  let html = render_latex_math_inline_html("\\frac{x}{y}")
  assert_true(html.contains("markdown-math-frac"))
  assert_true(html.contains("x"))
  assert_true(html.contains("y"))
}
```

## Core APIs

### 行内公式 HTML

```mbt check
///|
test {
  let html = render_latex_math_inline_html("x^2 + y_1")
  assert_true(html.contains("markdown-math"))
  assert_true(html.contains("x"))
}
```

### 块级公式 HTML

```mbt check
///|
test {
  let html = render_latex_math_block_html("\\sqrt{x}")
  assert_true(html.contains("markdown-math-sqrt"))
  assert_true(html.contains("x"))
}
```

### SVG fragment

```mbt check
///|
test {
  let svg = render_latex_math_inline_svg("\\frac{x}{y}")
  assert_true(svg.contains("<svg"))
  assert_true(svg.contains("markdown-math"))
}
```

### Math visual style

```mbt check
///|
test {
  let css = math_style_css()
  assert_true(css.contains("markdown-math-frac"))
  assert_true(css.contains("markdown-math-sqrt__svg"))
}
```

## SafeHtml

如果调用方希望显式区分“已转义/可嵌入”的 HTML，可以使用 `SafeHtml` 版本：

```mbt check
///|
test {
  let safe = render_latex_math_inline_safe_html("\\alpha")
  assert_true(safe.value.contains("alpha"))
}
```

## Notes

- 输入中的普通文本会进行 HTML 转义，避免直接注入 HTML。
- 当前覆盖分式、根号、上下标、希腊字母和常见行内/块级公式展示。
- SVG 输出是为了导出链路预留的 fragment 能力，后续可以扩展为更完整的公式排版。

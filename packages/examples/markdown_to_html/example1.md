# MoonMarkMind Markdown to HTML example

This paragraph includes **strong text**, _emphasis_, ~~deleted text~~,
`inline code`, a [safe link](https://example.com/docs), and an inline
formula $x^2 + \alpha$.

![MoonMarkMind logo](../../../web/logo.png)

## Tasks

- [ ] Draft the public API
- [x] Render Markdown to HTML
- [X] Keep unsafe input escaped

## Table

| Feature | Status | Notes |
|---|---|---|
| Strong | ok | `**text**` |
| Math | ok | `$x^2$` |
| Table | ok | pipe table |

## Code

```moonbit
let html = @markdown_to_html.render("Hello **MoonBit**")
println(html)
```

## Inline Math

Pythagorean theorem: $x^2 + y^2 = z^2$.

Greek letters and operators: $\alpha + \beta \pm \gamma \cdot \delta$.

Subscripts and superscripts: $a_i^2 + b_{n+1} = c^{k-1}$.

## Square Roots and Fractions

Simple root: $\sqrt{x}$.

Quadratic formula:
$x = {-b \pm \sqrt{b^2 - 4ac} \over 2a}$.

Indexed root: $\sqrt[n]{x + 1}$.

Nested fraction: $\sqrt{\frac{a_1 + b^2}{c + d}}$.

## Block Math

$$
\frac{a_1}{b^2} + \sqrt{x}
$$

$$
x = {-b \pm \sqrt{b^2 - 4ac} \over 2a}
$$

$$
\sqrt[n]{\frac{x^2 + 1}{y_0 - 3}}
$$

## Aligned Math

$$
a &= b + c \\
x &= {-b \pm \sqrt{b^2 - 4ac} \over 2a} \\
y &= \sqrt[n]{x^2 + 1}
$$

## Unsafe HTML

Unsafe HTML should be escaped:
<script>alert("xss")</script>

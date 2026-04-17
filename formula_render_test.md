# 公式渲染测试

## 行内公式

普通行内公式：$x^2 + y^2 = z^2$

希腊字母与运算符：$\alpha + \beta \pm \gamma \cdot \delta$

上下标组合：$a_i^2 + b_{n+1} = c^{k-1}$

## 根号

普通根号：$\sqrt{x}$

带上标的根号：$\sqrt{b^2 - 4ac}$

二次公式：$x = {-b \pm \sqrt{b^2 - 4ac} \over 2a}$

带根指数：$\sqrt[n]{x + 1}$

根号内含分式：$\sqrt{\frac{a_1 + b^2}{c + d}}$

嵌套根号：$\sqrt{1 + \sqrt{x^2 + 1}}$

## 分式

普通分式：$\frac{a}{b}$

复杂分式：$\frac{x^2 + 2x + 1}{\sqrt{x} + 1}$

over 语法：${-b \pm \sqrt{b^2 - 4ac} \over 2a}$

## 块级公式

$$
\frac{a_1}{b^2} + \sqrt{x}
$$

$$
x = {-b \pm \sqrt{b^2 - 4ac} \over 2a}
$$

$$
\sqrt[n]{\frac{x^2 + 1}{y_0 - 3}}
$$

## 多行对齐

$$
a &= b + c \\
x &= {-b \pm \sqrt{b^2 - 4ac} \over 2a} \\
y &= \sqrt[n]{x^2 + 1}
$$

## 与正文混排

这一段同时包含中文、英文和公式：当判别式 $\Delta = b^2 - 4ac$ 大于零时，方程 $ax^2 + bx + c = 0$ 有两个不同实根。

另一个根号密集段落：$\sqrt{x}$、$\sqrt{x + y}$、$\sqrt{\frac{x}{y}}$、$\sqrt[n]{x}$ 应该都保持根号顶部横线连续。

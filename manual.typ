#import "@preview/mitex:0.2.6"
#import "@preview/pinit:0.2.2"
#import "@preview/cetz:0.2.2"

//函数图像
#import "@preview/simple-plot:0.3.0": plot

//公式编号
#import "@preview/equate:0.3.2": equate

// 开启标题编号以便于观察效果
#set heading(numbering: "1.1")
#show: equate.with(breakable: true, sub-numbering: true, number-mode: "label")

// 1. 在一级和二级标题处重置公式计数器
#show heading: it => {
  if it.level <= 2 {
    counter(math.equation).update(0)
  }
  it
}

//Typst Logo
#let typst = {
  set text(
    size: 1.05em,
    font: "Buenard",
    weight: "bold",
    fill: rgb("#239dad"),
  )
  box({
    text("t")
    text("y")
    h(0.035em)
    text("p")
    h(-0.025em)
    text("s")
    h(-0.015em)
    text("t")
  })
}

// 2. 将一级和二级标题序号拼接到公式编号中
#set math.equation(numbering: (..nums) => context {
  let h = counter(heading).get()
  
  if h.len() > 0 {
    // 获取一级标题序号
    let h1 = h.at(0)
    // 获取二级标题序号，若当前处于一级标题下但还未出现二级标题，则默认补 0
    let h2 = h.at(1, default: 0) 
    
    // 使用 "(1.1.1)" 三段式占位符：一级标题.二级标题.公式序号
    //numbering("(1.1.1)", h1, h2, ..nums)

  // 使用 "(1.1)" 三段式占位符：一级标题.公式序号
    numbering("(1.1)", h1, ..nums)
  } else {
    numbering("(1)", ..nums)
  }
}, supplement: none)

//交换图
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

//列表
#import "@preview/itemize:0.2.0" as el
#show: el.default-enum-list.with(auto-resuming: auto)

//七彩盒子
#import "@preview/showybox:2.0.4": showybox

//定理环境
#import "@preview/ctheorems:1.1.3": *
#show: thmrules.with(qed-symbol: $square$)
#set heading(numbering: "1.1.")

//颜色表
#let tblue = rgb("#0066FF")
#let dblue = rgb("0044FF")
#let torange = rgb("#E66F00")
#let tgreen = rgb("#10B981")
#let tred = rgb("#EF4444")

// 1. 定义一个桥接函数，整合 ctheorems 逻辑与 showybox 外观
#let showy_thmbox(
  identifier,
  head,
  counter-key: auto,
  base: "heading",
  base_level: 1, //计数器层级
  accent: tblue,
  body-fill: auto,
) = { 
  if counter-key == auto {
    counter-key = identifier
  }

  // 编写自定义的渲染回调函数
  let boxfmt(name, number, body, title: auto, ..blockargs) = {
    // 动态拼接 showybox 的标题 (例如："定理 1.1" 或 "定理 1.1 (勾股定理)")
    let title-text = [#head]
    if number != none {
      title-text += [ #number]
    }
    if name != none {
      title-text += [ (#name)]
    }

    let formatted-title = text(
      font: "Source Han Sans SC", 
      weight: "medium", 
      title-text
    )
    let panel-fill = if body-fill == auto {
      accent.lighten(90%)
    } else {
      body-fill
    }

    // 返回你设计的 showybox 样式
    showybox(
      title-style: (
        boxed-style: (
          anchor: (x: left, y: horizon),
          radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt),
        )
      ),
      frame: (
        title-color: accent,
        body-color: accent.lighten(100%),
        border-color: accent,
        radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt)
      ),
      title: formatted-title,  // <- 使用格式化后的标题
      body
    )
  }

  // counter-key 决定共用哪一套编号；supplement 仍保留各自环境名称以便引用显示
  return thmenv(counter-key, base, base_level, boxfmt).with(supplement: head)
}


// 2. theorem / corollary / definition / conclusion 共用 theorem 计数器，
// 这样它们会得到同一条连续编号：定理 2.1、结论 2.2、推论 2.3 ...
#let theorem = showy_thmbox(
  "theorem",
  "定理",
  accent: tblue,
)

#let corollary = showy_thmbox(
  "corollary",
  "推论",
  counter-key: "theorem",
  accent: torange,
)

#let definition = showy_thmbox(
  "definition",
  "定义",
  counter-key: "theorem",
  accent: tblue,
)

#let conclusion = showy_thmbox(
  "conclusion",
  "结论",
  counter-key: "theorem",
  accent: tgreen,
)

#let example = thmplain("example", "例子").with(numbering: none)



#let thmproof(..args) = thmplain(
..args,
namefmt: it => it,
bodyfmt: proof-bodyfmt,
..args.named()
).with(numbering: none)

#let proof = thmproof("proof", "证明")
//


//白色QED
#show: thmrules.with(qed-symbol: $square$)

//字体设置
#set text(
  font: ("New Computer Modern", "SimSun"), 
  lang: "zh",
  region: "cn"
)

// 当触发 strong 样式时，将字体切换为黑体
#show strong: set text(font: ("New Computer Modern", "SimHei"))

// 数学字体设置
//#show math.equation: set text(font: ("New Computer Modern Math", "SimSun"))

//页码设置

#set page(
  numbering: "1", // 虽然 footer 覆盖了自动显示，但 numbering 定义了页码的格式
  footer: context [
    #set text(size: 9pt, fill: black)
    #grid(
      columns: (1fr, 1fr, 1fr), // 将页脚分为左、中、右三等份
      align: (left, center, right),
      [], // 左侧：留空
      counter(page).display(), // 中间：显示当前页码
      [Written by #typst] // 右侧：你的文字
    )
  ]
)

//标题设置
#show title: set text(size: 17pt)
#show title: set align(center)
#show title: set block(below: 1.2em)

//问题计数器盒子
// 统一的全局问题计数器
#show ref: it => {
  let el = it.element
  if el != none and el.func() == metadata {
    let value = el.value
    if value.at("kind", default: none) == "problem-ref" {
      [#value.prefix #value.h1.#value.h2.#value.p]
    } else {
      it
    }
  } else {
    it
  }
}

#let prob-ref(label) = context {
  let value = query(label).first().value
  [#value.prefix #value.h1.#value.h2.#value.p]
}

#let prob-counter-key(h1, h2) = "problem-" + str(h1) + "-" + str(h2)

// 当遇到一级标题（level: 1）时，将 prob-counter 重置为 0

// 1. 定义基础函数，使用 level 参数控制难度级别：
// 0 代表普通，1 代表单星，2 代表多星(⁂)
#let prob-box-base(body, level: 0, label: none) = context {
  // 所有级别共用同一个计数器步进
  
  // 根据 level 动态设置前缀文本
  let title-prefix = if level == 0 {
    "例题"
  } else if level == 1 {
    "*例题"
  } else if level == 2{
    "⁑例题"
  } else if level == 3{
    "⁂例题 "
  } else if level == 4{
    "⌘例题"
  } else {
    "⚝例题"
  }
  
  // 根据 level 动态设置主题颜色
  let theme-color = if level == 0 {
    blue            // 普通：蓝色
  } else if level == 1 {
    rgb("0044FF")   // 单星
  } else if level == 2{
    rgb("6600FF")   // 双星
  } else if level == 3{
    rgb("0000CC")
  } else if level == 4{
    rgb("660000")
  } else {
    rgb("000000")
  }

  let heading-num = counter(heading).get()
  let h1-num = heading-num.at(0, default: 0)
  let h2-num = heading-num.at(1, default: 0)
  let prob-counter = counter(prob-counter-key(h1-num, h2-num))
  prob-counter.step()
  let p-num = prob-counter.get().first() + 1
  let anchor = if label == none {
    []
  } else {
    [#metadata((kind: "problem-ref", prefix: title-prefix, h1: h1-num, h2: h2-num, p: p-num)) #label]
  }
  
  [
    #anchor
    #showybox(
      title: [#text(font: "Source Han Sans SC", weight: "medium")[#title-prefix #h1-num.#h2-num.#p-num]],
      // 获取当前章节号和例题号
    
    frame: (
      border-color: theme-color,
      title-color: theme-color.lighten(30%),
      body-color: theme-color.lighten(95%),
      footer-color: theme-color.lighten(80%)
    )
    )[#body]
  ]
}

// 2. 封装出三个便捷的接口供日常使用
#let prob-box(body, label: none) = prob-box-base(body, level: 0, label: label)
#let star-prob-box(body, label: none) = prob-box-base(body, level: 1, label: label)
#let doublestar-prob-box(body, label: none) = prob-box-base(body, level: 2, label: label)
#let threestar-prob-box(body, label: none) = prob-box-base(body, level: 3, label: label)
#let fourstar-prob-box(body, label: none) = prob-box-base(body, level: 4, label: label)
#let fivestar-prob-box(body, label: none) = prob-box-base(body, level: 5, label: label)
//

#show heading: set block(above: 1.4em, below: 1em)
#show heading: set text(font: "Source Han Sans SC", weight:"regular") // 设置所有标题为思源黑体

#show heading.where(level: 1): body => {
    set align(center)
    body
} 
 
//标题
#align(center)[
  //#v(0em)
  #text(size: 20pt, weight: "bold")[考研数学手册] 
  
  #v(-1em)
  #text(size: 11pt)[非数学系 $dot.c$ 数学一]

  #v(-0.5em)
  #text(size: 10pt)[Written by #typst]
]

//行间公式左对齐
#let left-eq(body) = {
  show math.equation: set align(left)
  body
}

//正文

= 函数

== 乘法公式

立方和公式: $a^3+b^3=(a+b)(a^2-a b+b^2)$

立方差公式: $a^3-b^3 = (a-b)(a^2 + a b + b^2)$

完全立方公式: $(a plus.minus b)^3= a^3 + plus.minus 3a^2 b +3 a b^2 plus.minus b^3$

== 三角恒等式

#theorem("辅助角公式")[
  $ a sin x + b cos x = sqrt(a^2+b^2)sin(x+phi), tan phi = b/a $

  $ a sin x - b cos x = sqrt(a^2+b^2)sin(x-phi), tan phi = b/a $
]<辅助角>
#proof([of @辅助角])[
  $(a / sqrt(a^2 + b^2))^2 + (b / sqrt(a^2 + b^2))^2 = 1$

  也就是说在一个单位圆中，不妨设$cos phi = a / sqrt(a^2 + b^2) , quad sin phi = b / sqrt(a^2 + b^2)$

  注意到: $a sin x + b cos x = sqrt(a^2 + b^2) (a / sqrt(a^2 + b^2) sin x + b / sqrt(a^2 + b^2) cos x)$

  代入原式得: $sqrt(a^2 + b^2) (cos phi sin x + sin phi cos x) = sqrt(a^2 + b^2) sin (phi + x) , quad tan phi = b / a$
/*
  类似地, 设$& sin phi = a / sqrt(a^2 + b^2) , quad cos phi = b / sqrt(a^2 + b^2)$

  则有$sqrt(a^2 + b^2) (sin phi sin x + cos phi cos x) = sqrt(a^2 + b^2) cos (x - phi) , quad tan phi = a / b$
*/
]

#theorem("和角公式")[
  $ sin (alpha plus.minus beta) & = sin alpha cos beta plus.minus cos alpha sin beta\
cos (alpha plus.minus beta) & = cos alpha cos beta minus.plus sin alpha sin beta\
tan (alpha plus.minus beta) & = frac(tan alpha plus.minus tan beta, 1 minus.plus tan alpha tan beta) $<和角公式>
]<和角公式>

#theorem("二倍角公式")[
  $ sin 2 alpha & = 2 sin alpha cos alpha\
cos 2 alpha & = cos^2 alpha - sin^2 alpha = 2 cos^2 alpha - 1 = 1 - 2 sin^2 alpha $
]

#theorem("半角公式")[
  $ sin^2 x/2 &= (1- cos x)/2\
  cos^2 x/2 &= (1+cos x)/2\
  tan^2 x/2 &= frac(1 - cos x, 1 + cos x) = frac(sin^2 x, (1 + cos x)^2) = frac((1 - cos x)^2, sin^2 x )#<eq:tan_half>\
  1 - cos x &= 2 sin^2 x/2\
  1 + cos x &= 2 cos^2 x/2 $ 
  ]
<半角公式>
#proof([of @半角公式])[
我们只证明@eq:tan_half 

$ tan^2 x/2 &= frac(1 - cos x, 1 + cos x) = frac((1 - cos x) (1 + cos x), (1 + cos x)^2) = frac(sin^2 x, (1 + cos x)^2)\
tan^2 x/2 &= frac(1 - cos x, 1 + cos x) = frac((1 - cos x)^2, (1 + cos x) (1 - cos x)) = frac((1 - cos x)^2, sin^2 x) $
]

#theorem("积化和差公式")[
  $ sin alpha cos beta = frac(sin (alpha + beta) + sin (alpha - beta), 2)\
cos alpha sin beta = frac(sin (alpha + beta) - sin (alpha - beta), 2)\
cos alpha cos beta = frac(cos (alpha + beta) + cos (alpha - beta), 2)\
sin alpha sin beta = frac(cos (alpha - beta) - cos (alpha + beta), 2) $
]
#proof[非常简单, 使用和角公式轻松证明]

#theorem("和差化积公式")[
  $ sin alpha + sin beta  & = 2 sin frac(alpha + beta, 2) cos frac(alpha - beta, 2) #<eq:和差化积>\ 
sin alpha - sin beta  & = 2 cos frac(alpha + beta, 2) sin frac(alpha - beta, 2) \
cos alpha + cos beta &= 2 cos frac(alpha + beta, 2) cos frac(alpha - beta, 2) \
cos alpha - cos beta  & = - 2 sin frac(alpha + beta, 2) sin frac(alpha - beta, 2) $]

#proof[ 以@eq:和差化积 为例, 仍然使用和角公式

$ sin (alpha + beta) = sin alpha cos beta + cos alpha sin beta $ <eq:和差化积_1>

$ sin (alpha - beta) = sin alpha cos beta - cos alpha sin beta $ <eq:和差化积_2>

@eq:和差化积_1 + @eq:和差化积_2 得

$ sin (alpha + beta) + sin (alpha - beta) = 2 sin alpha cos beta $

令 $X = alpha+beta, Y = alpha-beta$, 那么有$display(alpha = (X+Y)/2), display(beta=(X-Y)/2) $

于是我们有$sin X+sin Y = 2display(sin (X+Y)/2 cos (X-Y)/2)$, 这正是 @eq:和差化积.
]

== 反三角函数恒等式

#theorem("反正切函数恒等式")[$ arctan theta + arctan 1/theta = pi/2 $]<反正切函数恒等式>

为了理解 @反正切函数恒等式 , 我们可以画一个三角形. 记某个锐角为$alpha= arctan theta$, 那么有$display(theta = tan alpha)$, 于是另一个角有$display(tan(pi/2-alpha) = 1/theta)$, 即$display(arctan 1/theta = pi/2 - alpha)$, 故有$display(arctan theta + arctan 1/theta = pi/2)$

== 万能公式

万能公式的推导具有一定技巧性, 所以不再给出推导过程, 会背即可.

设$display(u = tan x/2)$, 则有

$
sin x = frac(2 u, 1+u^2), #h(1.5em) cos x = frac(1-u^2,1+u^2), #h(1.5em) tan x = frac(2 u,1-u^2), #h(1.5em) "d"x = frac(2"d"u, 1+u^2)
$


#pagebreak()

= 极限与连续

== 七种未定式

$0/0,oo/oo,0dot oo , oo - oo, 1^(oo), oo^0, 0^0$

== 泰勒公式（麦克劳林公式）

当 $x -> 0$ 时，有

#grid(
  columns: (1fr, 1fr),  // 分为平分的左右两栏
  row-gutter: 1em,    // 设置行间距，让公式看起来不拥挤

$ sin x = x - x^3/6 + o(x^3) $,
$ cos x = 1 - x^2/2 + x^4/24 + o(x^4) $,

$ arcsin x = x + x^3/6 + o(x^3) $,
$ ln(1+x) = x - x^2/2 + x^3/3 + o(x^3) $,

$ tan x = x + x^3/3 + o(x^3) $,
$ e^x = 1 + x + x^2/2! + x^3/3! + o(x^3) $,

$ arctan x = x - x^3/3 + o(x^3) $,
$ (1+x)^alpha = 1 + alpha x + (alpha(alpha-1))/2! x^2 + o(x^2) $
)

== 极限二级结论

#conclusion("求极限结论①")[
  $ lim_(x arrow.r oo) (frac(a x + b_1, a x + b_2))^(h x + c) = upright(e)^(frac(h (b_1 - b_2), a)) $

]

#conclusion("脱帽法")[
设原式为$alpha(x)$, $alpha(x)$是一个无穷小量. 解出$f(x)$, 然后替代题目条件式中的$f(x)$即可.
]

#conclusion("Exp函数的差")[$"e"^f-"e"^q="e"^q ("e"^(f-q) -1)$]

#pagebreak()

= 导数与微分

== 基本导数公式

#grid(
  columns: (1fr, 1fr, 1fr),  // 分为平分的三栏
  row-gutter: 1em,    // 设置行间距，让公式看起来不拥挤

$(C)' = 0$,
$(x^mu)' = mu x^(mu-1)$,
$(sin x)'=cos x$,
$(cos x)'=-sin x$,
$(tan x)'=sec^2 x$,
$(cot x)'=-csc^2 x$,
$(sec x)'=sec x tan x$,
$(csc x)'=-csc x cot x$,
$(a^x)' = a^x ln a(a>0,a eq.not 1)$,
$("e"^x)="e"^x$,
$display((log_a x)'=frac(1,x ln a))(a>0,a eq.not 1)$,
$display((ln x)'=1/x)$,
$display((arcsin x)'=frac(1,sqrt(1-x)))$,
$display((arccos x)'=-frac(1,sqrt(1-x)))$,
$display((arctan x)'=frac(1,1+x^2))$,
$display((op("arccot") x)'=-frac(1,1+x^2) )$,
)

== 导数的定义

函数$f(x)$在$x_0$处的导数定义

+ $ f'(x_0)=lim_(Delta x -> 0)frac(f(x_0+Delta x)-f(x_0),Delta x) $

+ $ f'(x_0)=lim_(x->x_0)frac(f(x)-f(x_0),x-x_0) $

+ $ f'(x_0)=frac(f[x_0+phi(x)]-f(x_0),phi(x)),lim_(x->x_0)phi(x)=0 $ 

== 隐函数求导

+ 直接法: 把因变量$y$视为$y(x)$, 对两边$x$同时求导

+ 公式法: $display(frac(dif y,dif x) = - frac(F'_x (x,y),F'_y (x,y)))$

== 参数方程求导

+ 一阶导数: $display(frac(dif y,dif x)=frac(dif y,dif t)dot frac(dif t,dif x))$

+ 二阶导数: $display(frac(dif^2 y,dif x^2)=frac(dif y',dif x)=frac(dif y',dif t)dot frac(dif t,dif x))$

== 变限积分求导公式

+ $display(F(x) = integral_a^x f(t)dif t), F'(x)=f(x)$

+ $display(F(x)=integral_a^(g(x))f(t)dif t), F'(x)=f[g(x)]g'(x)$

+ $display(F(x)=integral_(h(x))^a f(t)dif t), F'(x)=-f[h(x)]h'(x)$

+ $display(F(x)=integral_(h(x))^(g(x))f(t)dif t), display(F'(x)=integral_a^(g(x))f(t)dif t + integral_h(x)^a f(t)dif t) = F[g(x)]g'(x)-f[h(x)]h'(x)$

+ $display(F(x)=integral_a^x f(t)g(x)dif t)$

$display(F'(x)=[g(x)integral_a^x f(t)]' = g'(x) integral_a^x f(t) + f(x)g(x))$

== 高阶导数求导公式

+ $display( ("e"^(a x + b))^((n)) = a^n "e"^(a x + b)     )$

+ $display( [sin(a x + b)]^((n)) = a^n sin(a x + b + frac(n pi, 2)) )$

+ $display( [cos(a x + b)]^((n)) = a^n cos(a x + b + frac(n pi, 2)) )$

+ $display( (frac(1,a x + b))^((n)) = frac((-1)^n a^n n!,(a x + b)^n)  )$

+ $display( [ln(a x + b)]^((n)) = frac((-1)^(n-1)a^n (n-1)!,(a x+b)^n) )$

== Leibniz 公式

$display( (f g)^n = sum_(k=0)^n binom(n,k) f^((n-k))g^k )$

#pagebreak()

= 不定积分

== 积分表

#left-eq[ + $ integral x^mu "d"x = 1/(mu + 1) x^(mu+1)+C $
+ $ integral 1/sqrt(f(x)) "d"f(x) = 2sqrt(f(x)) +C $ 
+ $ integral upright(e)^x "d"x = "e"^x +C $
+ $ integral a^x "d"x = a^x/(ln a) + C $
+ $ integral 1/x "d"x = ln|x|+C $
+ $ integral sin x "d"x = - cos x + C $
+ $ integral cos x "d"x = sin x + C $
+ $ integral tan x "d"x = - ln|cos x| + C $
+ $ integral cot x "d"x = ln|sin x| + C $
+ $ integral sec x = ln|sec x + tan x| + C $
+ $ integral csc x = - ln|csc x + cot x| + C = ln|csc x - cot x| + C $
+ $ integral sin^2 x "d"x = - 1/4 sin 2 x + 1/2 x + C $
+ $ integral cos^2 "d"x = 1/4 sin 2 x + 1/2 x + C $
+ $ integral tan^2 x "d"x = tan x - x + C $
+ $ integral sec^2 x "d"x = tan x + C $
+ $ integral csc^2 x "d"x = - cot x + C $
+ $ integral sin^3 x"d"x =- cos x + 1/3 cos^3 x + C $
+ $ integral cos^3 x "d"x = sin x - 1/3 sin^3 x + C $
+ $ integral sec^3 x "d"x = 1/2 sec x tan x + 1/2 ln abs(sec x + tan x)+C $
+ $ integral csc^3 x dif x = -1/2 csc x cot x + 1/2 ln abs(csc x - cot x) + C $
+ $ integral sec^4 x dif x = 1/3 tan^3 x + tan x +C $
+ $ integral csc^4 x dif x = -1/3 cot^3 x - cot x = C $
+ $ integral ("d"x)/sqrt(1-x^2) = arcsin x + C = - arccos x + C $
+ $ integral 1/(1+x^2) "d"x = arctan x + C $
+ $ integral ("d"x)/sqrt(a^2 - x^2) = arcsin x/a + C $
+ $ integral ("d"x)/(a^2 + x^2) = 1/a arctan x/a + C $]

#el.resume() //继续序号
#left-eq[+ $ integral frac("d"x, sqrt(a^2+x^2))"d"x = ln abs(x+sqrt(x^2+a^2))+C #<uint:tan> $]

#proof([of @uint:tan])[
  设$t=a tan theta, "d"x = a sec^2 theta "d"theta$.

  $
  integral ("d"x)/(a^2 + x^2) = integral sec theta "d"theta = ln abs(x+sqrt(x^2+a^2))+C
  $
]

#el.resume() //继续序号
#left-eq[ + $ integral ("d"x)/(sqrt(x^2 plus.minus a^2)) = ln abs(x+sqrt(x^2 plus.minus a^2)) + C #<uint:sec> $]

#proof([of @uint:sec])[
 不失一般性, 使用第二换元法, 令$x = a sec theta$ , $"d"x = a sec theta tan theta "d"theta$,
 根据公式$sec^2 x = tan^2 x + 1$, 有$sec theta = x/a, tan theta = sqrt(x^2-a^2)/a$
$ integral ("d"x)/sqrt(x^2 -a^2) &= 1/a integral frac(a sec theta tan theta, a tan theta)"d"theta = 1/a integral sec theta "d"theta \
&= ln lr(|sec theta + tan theta |)= ln lr(|x/a+frac(sqrt(x^2-a^2),a)|)\
&= ln lr(|frac(x+sqrt(x^2-a^2),a)|)= ln lr(|x+sqrt(x^2-a^2)|) + C
$

]

#el.resume() //继续序号
#left-eq[ + $ integral ("d"x)/(1+"e"^x) = x - ln(1+"e"^x)+C #<uint:e> $]

#proof([of @uint:e])[
  $ integral frac("e"^x"d"x, "e"^x (1+"e"^x)) &= integral frac("d"("e"^x), "e"^x (1+"e"^x)) = integral ("d"t)/t(1+t) = integral 1/t - 1/(1+t) "d"t \
  &= ln t - ln abs(1+t) = x - ln(1+"e"^x) +C  $

]

#el.resume() //继续序号
#left-eq[ + $ integral frac(upright(d) x, a^2 - x^2) = frac(1, 2 a) ln lr(|frac(a + x, a - x)|) + C #<uint:ax> $
]

#proof([of @uint:ax])[
  $ integral ("d"x)/(a^2-x^2) = integral ("d"x)/((a+x)(a-x)) $


使用待定系数法, $ integral ("d"x)/((a+x)(a-x)) &= A/(a+x) - B/(a-x)\
&= frac(A(a-x)-B(a+x),(a+x)(a-x))=1
 $

待入特殊值,$x=a\&-a$, 可以解出$display(a=1/(2a)), display(b=-1/(2a))$

$ integral ("d"x)/(a^2-x^2) &= integral ("d"x)/((a+x)(a-x))\
&= 1/(2a) (integral 1/(x+a) - integral 1/(x-a))
&= 1/(2a) ln abs((x+a)/(x-a))+C
 $
]

#el.resume() //继续序号
#left-eq[ + $ integral frac(upright(d) x, x^2 - a^2) = frac(1, 2 a) ln lr(|frac(x - a, x + a)|) + C #<uint:xa> $
]

#proof([of @uint:xa])[
  $ integral frac(upright(d) x, x^2 - a^2) & = integral frac(1, (x + a) (x - a)) upright(d) x\
 & = frac(1, 2 a) integral frac(1, x - a) - frac(1, x + a)\
 & = frac(1, 2 a) (ln lr(|x - a|) - ln lr(|x + a|))\
 & = frac(1, 2 a) ln lr(|frac(x - a, x + a)|) + C . $
]

#el.resume() //继续序号
#left-eq[ + $ integral upright(e) ^(a x)sin  b x  dif x &=frac(1, a^(2)+b^(2))mat(delim: "|", (  upright(e) ^(a x )  )  ^(prime ),  (  sin  b x   )  ^(prime ); upright(e) ^(a x ),  sin  b x ;)  \
&=frac(1, a^(2)+b^(2))(  a upright(e) ^(a x)sin  b x-b upright(e) ^(a x)cos  b x  )  +C #<uint:eaxsin> $
]

#el.resume() //继续序号
#left-eq[ + $ integral "e"^(a x)cos b x "d"x &= 1/(a^2+b^2) 
mat(
  ("e"^(a x))', (cos b x)';
  "e"^(a x), cos b x;
  delim: "|" 
)\
&= 1/(a^2+b^2)(a"e"^(a x) cos b x + b "e"^(a x) sin b x) + C #<uint:eaxcos>
 $ ]

#proof([@uint:eaxsin 和 @uint:eaxcos])[
  我们使用欧拉方程进行证明

#theorem("欧拉方程")[
  $ "e"^("i"theta) = cos theta + "i"sin theta $
]

$ "e"^((a+"i"b)x) &= "e"^(a x) dot "e"^("i"b x) \
&= "e"^(a x) dot (cos b x + "i" sin b x)
$

构造复积分$display(I_c = integral "e"^((a+"i"b)x)"d"x=integral "e"^(a x)cos b x "d"x + "i"integral "e"^(a x)sin b x "d"x)$

于是, 复积分的实部就是$display(integral "e"^(a x)cos b x "d"x)$, 虚部就是$"i"integral "e"^(a x)sin b x "d"x$

易知$display(integral "e"^((a+"i"b)x)"d"x = frac( "e"^((a+"i"b)x),a+"i"b)+C)$, 接下来我们要分离复积分的实部和虚部.

$
frac( "e"^((a+"i"b)x),a+"i"b) &= frac( "e"^((a+"i"b)x)(a-"i"b),(a+"i"b)(a-"i"b)) \
&= frac(a-"i"b,a^2+b^2) dot "e"^(a x)(cos b x + "i"sin b x)\
&= frac("e"^(a x),a^2+b^2) dot (a-"i"b)(cos b x + "i"sin b x)\
&= frac("e"^(a x),a^2+b^2) a cos b x + b sin b x + "i"frac("e"^(a x),a^2+b^2)(a sin b x - b cos b x)
$

故得证.

]

#el.resume() //继续序号
#left-eq[ + $ integral ln x upright(d) x = x ln x - x + C $
+ $ integral x ln x "d"x = 1/2 x^2 ln x - 1/4 x^2 + C $
+ $ integral arctan x "d"x = x arctan x - 1/2 ln(1+x^2) + C $
+ $ integral arcsin x "d"x = x arcsin x + sqrt(1-x^2) + C $
]

#el.resume() //继续序号
#left-eq[ + $ integral sqrt(a^2+x^2)dif x  = 1/2 [x sqrt(x^2+a^2) + a^2 ln (sqrt(x^2+a^2) + x)]+ C $  ]
#left-eq[ + $ integral frac("d"x, a^2 sin^2 x+b^2cos^2 x) = frac(1,a b) arctan frac(a tan x,b)+C $]
#left-eq[ + $ integral frac(dif x,(a sin x + b cos x)^2) = - 1/a frac(1,a tan x + b) + C $]



== 可以使用交换图计算的分部积分

- $display(integral x^m "e"^(lambda x)"d"x)$

- $display(integral x^m sin a x "d"x)$
  
- $display(integral x^m cos a x "d"x)$


== 第二换元法

- 对于$sqrt(a^2-x^2)$, 设$x=a sin t$
- 对于$sqrt(a^2+x^2)$, 设$x = a tan t$
- 对于$sqrt(x^2-a^2)$, 设$x= a sec t$

#theorem([毕达哥拉斯三角恒等式])[
  $
  sin^2 theta + cos^2 theta &= 1\
  1 + tan^2 theta &= sec^2 theta\
  1 + cot^2 theta &= csc^2 theta
  $
]

== 有理函数积分

有理函数积分主要是为了解决下面的积分

#grid(
  columns: (1fr, 1fr),  // 分为平分的左右两栏
  row-gutter: 1em,    // 设置行间距，让公式看起来不拥挤

  $display( integral 1/(x+a)"d"x)$,
  $display( integral 1/(x+a)^n)$,

  $display(integral frac(m x+n, a x^2 + b x + c))$,
  $display(integral frac(m x+n, (a x^2 + b x + c)^n))$
)

== 不定积分的定理

#theorem([原函数存在定理])[
  设$I$是一个区间, 函数$f: I-> RR or CC$在$I$上存在一个原函数$F$, 即$F'(x) = f(x), x in I$, 那么$F$在$I$上必连续
]

#proof[
  根据条件, 可知$F$在$I$上处处可导. 又由微积分中的基本定理可知: 
  
  #align(center)[函数在一点可导$=>$在该点连续.]
  所以, $F$在$I$上必连续.
]

== 不定积分的二级结论

#conclusion([二次有理函数积分展开式])[
  $ integral frac("d"x, (x-1)(x^2+1)) = integral frac(A,x-1) + frac(B x+C,x^2+1) $
]

#conclusion("三角函数线性分式积分")[
  #v(1em)
对于形如$display(integral frac(a sin x + b cos x, c sin x + d cos x))$的线性表达式, 我们可以设

$
"分子" = A "分母" + B("分母")'
$

根据题目条件求出系数$A$和$B$后, 于是有

$
integral frac(a sin x + b cos x, c sin x + d cos x) &= integral A dif x + integral frac(B("分母")',"分母")dif x\
&= A x + B ln abs("分母") + C
$

]

== 常见没有初等解析解的积分

$display(integral "e"^(a x) tan b x)$

== 需要注意的凑微分函数

#grid(
  columns: (1fr, 1fr),  // 分为平分的左右两栏
  row-gutter: 2em,    // 设置行间距，让公式看起来不拥挤

  $(x ln x)' = ln x + 1$, 

  $display(frac(ln x, x) = frac(1-ln x,x^2))$,

  $(x"e"^x)' = "e"^x (1+x)$,

  $display(frac("e"^x,x) = frac(x"e"^x-"e"^x,x^2))$
)

= 定积分

== 定积分计算公式

#el.isolated-resume-enum[

#left-eq[ + $ integral_0^(pi/2) f(sin x)dif x = integral_0^(pi/2) f(cos x)dif x #<int_cal_01> $ ]

#proof[用区间再现公式证明]

#left-eq[ + $ integral_0^pi f(sin x)dif x = 2 integral_0^(pi/2) f(sin x)dif x $]

#left-eq[ + $ integral_0^pi f(abs(cos x))dif x = 2 integral_0^(pi/2) f(cos x)dif x $]

#left-eq[ + (Wallis 积分)$ I_n = integral_0^(pi/2) sin^n x dif x = integral_0^(pi/2) cos^n x dif x = cases(display(frac(n-1,n)dot frac(n-3,n-2) dots.c 1/2 dot text(fill: #rgb("F000F0"),pi/2))\, #h(1em) & n "is even",display(frac(n-1,n)dot frac(n-3,n-2) dots.c 2/3 dot 1)\, & n "is odd")  $]

#left-eq[ + (区间再现公式) $ integral_a^b f(x)dif x = integral_a^b f(a+b-x)dif x = 1/2 integral_a^b [f(x)+f(a+b-x)]dif x $]

]

== 定积分计算技巧

#el.isolated-resume-enum[
+ 对称性(奇偶性)

设$f(x)$在$[-a,a]$上连续, 则有

$
integral_(-a)^a f(x)dif x = integral_0^a [f(x)+f(-x)]dif x = cases(display(2integral_0^a f(x)dif x)\,&若 f(x)"为偶函数",0\, & 若 f(x)"为奇函数")
$

因为$display(f(x)=frac(f(x)+f(-x),2) + frac(f(x)-f(-x),2))$, 所以有

$
integral_(-a)^(a)f(x)dif x = integral_(-a)^a frac(f(x)+f(-x),2)dif x = integral_0^a f(x)+f(-x)dif x
$

#el.resume() //继续序号
+ 周期性

设$f(x)$是连续函数, 周期为$T$, 则

$forall a$, 有

- 
$
integral_a^(a+T) f(x) dif x = integral_0^T f(x)dif x = integral_(-T/2)^(T/2)f(x)dif x = dots.c
$

-
$
n in bb(N)_+ , "有" integral_a^(a+n T)f(x)dif x = n integral_0^T f(x)dif x
$
]

== 定积分的概念

#theorem("定积分的运算性质")[
设$f(x),g(x)$在$[a,b]$上可积, 则  
  $ integral_a^b [f(x)+g(x)]dif x = integral_a^b f(x)dif x + integral_a^b g(x)dif x $
$ integral_a^b k f(x)dif x = k integral_a^b f(x)dif x, k in bb(R) $
]

#theorem("定积分的区间可加性")[
  设$f(x)$在$[a,b]$上可积, $c in [a,b]$, 则
  $
  integral_a^b f(x)dif x = integral_a^c f(x)dif x + integral_c^b f(x)dif x
  $
]

#theorem("定积分的比较性质")[
  设函数$f(x)$在区间$[a,b]$上可积, 且$f(x)>=0$, 则$display(integral_a^b f(x)dif x >= 0)$
]

#corollary("定积分的保序性")[设$f(x),g(x)$在$[a,b]$上可积, 并且$f(x)<=g(x)$, 则
$ integral_a^b f(x)dif x <= integral_a^b g(x)dif x $
]

#corollary("定积分绝对值不等式")[
  设函数$f(x)$在$[a,b]$上可积, 那么函数$abs(f(x))$在$[a,b]$上也可积, 并且函数$abs(f(x))$在$[a,b]$上也可积, 并有
  $ abs(integral_a^b f(x)dif x) <= integral_a^b abs(f(x))dif x   $
]

#corollary("定积分估值定理")[
  设函数$f(x)$在$[a,b]$上可积, 且存在常数$m$和$M$, 满足不等式$m<=f(x)<=M$, 则
  $ m(b-a)<= integral_a^b f(x)dif x <= M(b-a) $
]

== 定积分的几何意义

- $display(integral_0^a sqrt(a^2-x^2)dif x = 1/4 pi a^2)$

- $display(integral_0^a sqrt(2a x - x^2)dif x = integral_0^a sqrt(a^2 - (x-a)^2)dif x = 1/4 pi a^2)$

== 反常积分

#el.isolated-resume-enum[

+ 无穷区间反常积分

设$F(x)$是$f(x)$在相应区间上的一个原函数

(1)若$display(integral_a^(+oo)f(x)dif x = lim_(x->+oo)F(x)-F(a)  )$极限存在, 称反常积分收敛, 否则发散

(2)若$display(integral_(-oo)^b f(x)dif x = F(b) - lim_(x->-oo)F(x)  )$极限存在, 称反常积分收敛, 否则发散

(3)若$display(integral_(-oo)^b f(x)dif x = integral_(-oo)^(x_0) f(x)dif x + integral_(x_0)^(+oo) f(x)dif x  )$右端的两个积分都收敛, 称反常积分收敛, 否则发散

#el.resume() //继续序号
+ 无界函数的反常积分(瑕积分)

瑕点: 使$f(x)$无界的点

(1)若$x=a$是瑕点, 则$display(integral_a^b f(x)dif x = F(b) - lim_(x->a^+)F(x))$极限存在, 称反常积分收敛, 否则发散

(2)若$x=b$是瑕点, 则$display(integral_a^b f(x)dif x = lim_(x->b^-)F(x) - F(a))$极限存在, 称反常积分收敛, 否则发散

(3)若$c in (a,b)$是瑕点, 则$display(integral_a^b f(x)dif x = integral_a^c f(x)dif x + integral_c^b f(x)dif x)$右端的两个积分都收敛, 称反常积分收敛, 否则发散
]

== 反常积分的性质与判定

#el.isolated-resume-enum[

+ (线性性质I) 若无穷积分$display(integral_a^(+oo)f(x)dif x)$收敛, 则对$forall k in bb(R)$, 有$display(integral_a^(+oo)k f(x)dif x)$收敛, 且 #v(.5em) $display(integral_a^(+oo)k f(x)dif x =k integral_a^(+oo)f(x)dif x )$

+ (线性性质II) 若无穷积分$display(integral_a^(+oo)f(x)dif x)$与$display(integral_a^(+oo)g(x)dif x)$收敛, 则无穷积分 #v(.5em) $display(integral_a^(+oo)[f(x)   plus.minus g(x)]dif x  )$也收敛, 且$display(integral_a^(+oo)[f(x)   plus.minus g(x)]dif x = integral_a^(+oo)f(x)dif x plus.minus integral_a^(+oo)g(x)dif x)$

+ 若$a>0$, 则

$
integral_a^(+oo)frac(dif x,x^p) = cases( display(frac(a^(1-p),p-1)\,&p>1),+oo\,&p<=1)
$

特别地$display(integral_1^(+oo)frac(dif x,x^p) = cases( display(frac(1,p-1)\,&p>1),+oo\,&p<=1))$

#v(.5em)

#proof[ $display(integral_a^(+oo)frac(dif x,x^p) =  lim_(x->+oo) frac(1,1-p)x^(1-p) - frac(a^(1-p),1-p) )$, 当$1-p>=0$, 发散; $1-p<0$, 收敛  ]

#v(.5em)

#el.resume() //继续序号
+ 若$a>1$, 则

$
integral_a^(+oo)frac(dif x,x ln^p x) = cases(display(frac(ln^(1-p)a,p-1))\,&p>1,+oo\,&p<=1)
$

#v(.5em)

特别地$display(integral_e^(+oo)frac(dif x,x ln^p x) = cases(display(frac(1,p-1))\,&p>1,+oo\,&p<=1)
)$

#v(.5em)

#el.resume() //继续序号
+ #{ 
  set math.equation(numbering: none)
  $ integral_0^(+oo) x"e"^(-k x)dif x = cases(display(1/(k^2)\,&k>0),+oo\,&k<=0) $
  }

#v(.5em)

#proof[ $ integral_0^(+oo) x"e"^(-k x)dif x &= - lr((x"e"^(-k x))/k|)_0^(+oo) - lr(("e"^(-k x))/k^2|)_0^(+oo)\
 &= -1/k lim_(x->+oo)x"e"^(-k x)- 1/k^2 lim_(x->+oo)"e"^(-k x)+1/k^2 $]

一般地, $display(integral_0^(+oo) x^n"e"^(-k x)dif x(n>0))$, 当$k>0$收敛, 当$k<=0$时发散

#el.resume() //继续序号
+ #{ 
  set math.equation(numbering: none)
  $ integral_a^b frac(dif x,(x-a)^q) = cases(display(frac((b-a)^(1-q),1-q))\,&q<1,+oo\,&q>=1) $
  }
]

== 判断反常积分敛散性

+ 设函数$f(x), g(x)$在区间$[a,+oo]$上连续, 并且$0<=f(x)<=g(x)(a<=x<+oo)$, 则

  ① 当$display(integral_a^(+oo)g(x)dif x)$收敛时, $display(integral_a^(+oo)f(x)dif x)$收敛 

  ② 当$display(integral_a^(+oo)f(x)dif x)$发散时,  $display(integral_a^(+oo)g(x)dif x)$发散

#strong["大收小收, 小散大散"]
















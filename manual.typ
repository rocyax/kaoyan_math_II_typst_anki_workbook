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

// 快捷输入粗体
/*
#let vbr(x) = $bold(upright(#x))$

#let aa = $vbr(a)$
#let bb = $vbr(b)$
#let cc = $vbr(c)$
#let dd = $vbr(d)$
#let ee = $vbr(e)$
#let ff = $vbr(f)$
#let gg = $vbr(g)$
#let hh = $vbr(h)$
#let ii = $vbr(i)$
#let jj = $vbr(j)$
#let kk = $vbr(k)$
#let ll = $vbr(l)$
#let mm = $vbr(m)$
#let nn = $vbr(n)$
//#let oo = $vbr(o)$
#let pp = $vbr(p)$
#let qq = $vbr(q)$
#let rr = $vbr(r)$
#let ss = $vbr(s)$
#let tt = $vbr(t)$
#let uu = $vbr(u)$
#let vv = $vbr(v)$
#let ww = $vbr(w)$
#let xx = $vbr(x)$
#let yy = $vbr(y)$
#let zz = $vbr(z)$
*/


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

//#pagebreak()

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








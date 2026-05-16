#import "@preview/mitex:0.2.6"
#import "@preview/pinit:0.2.2"
#import "@preview/cetz:0.2.2"
#import "@preview/physica:0.9.8"

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
#let twostar-prob-box(body, label: none) = prob-box-base(body, level: 2, label: label)
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
  #text(size: 20pt, weight: "bold")[考研数学习题集] 
  
  #v(-1em)
  #text(size: 11pt)[非数学系 $dot.c$ 数学二]

  #v(-0.5em)
  #text(size: 10pt)[吴家宝]

  #v(-0.5em)
  #text(size: 10pt)[Written by #typst]

  配合Anki复习效果更佳

  当前进度: #strong[定积分] 
]

//行间公式左对齐
#let left-eq(body) = {
  show math.equation: set align(left)
  body
}

//正文

= 初等数学

= 函数与极限

== 极限计算题


#prob-box[求极限 $ display(lim_(n-> oo) n sin pi/n ) $]

$ lim_(n-> oo) n sin pi/n = n dot pi/n = pi $

#prob-box[求极限 $ display(lim_(x->1)(1-x)tan (pi x)/2) $ ]

$ lim_(x->1)(1-x)tan (pi x)/2 &= lim_(x->1)frac((1-x)sin (pi x)/2, cos (pi x)/2) \
&=^(L') lim_(x->1)frac(-1, -pi/2 sin (pi x)/2)=2/pi  
$

#prob-box[求极限 $ lim_(x->-oo)x(sqrt(x^2+1)+x) $]

$ lim_(x->-oo)x(sqrt(x^2+1)+x) &= lim_(x->-oo) frac(x(x^2+1-x^2), sqrt(x^2+1)-x)\
&= lim_(x->-oo)frac(x,sqrt(x^2(1+1/x^2))-x)\
&= lim_(x->-oo)frac(x, text(fill: #red, -x) sqrt(1+1/x^2) - x) \
&= lim_(x->-oo) frac(1, -sqrt(1+1/x^2)-1) = -1/2
$
#prob-box[$ lim_(x->-1)(1/(1+x)-3/(1+x^3)) $]

$ lim_(x->-1)(1/(1+x)-3/(1+x^3)) &= lim_(x->-1)(1/(1+x) - frac(3, (1+x)(x^2-x+1)))\
&= lim_(x->-1)(frac(x^2-x-2,(1+x)(x^2-x+1)))\
&= lim_(x->-1) (x-2)/(x^2-x+1) = -1. 
 $

#prob-box[$ lim_(x->0)frac("e"^(1/x)+1,"e"^(1/x)-1) arctan 1/x $]

#grid(
  columns: (40%, 60%),
  gutter: 1.5em,

  // 左列：用 block/box 控制这一列里的排版宽度
  [
    #align(center)[
      #figure(
        plot(
          width: 5.5,   // 单位是 cm，不要写 100%
          height: 5.0,  // 单位是 cm

          xmin: -4.0,
          xmax: 4.0,
          ymin: -2.0,
          ymax: 8.0,

          xlabel: $x$,
          ylabel: $y$,
          show-grid: "major",

          (fn: x => calc.exp(1.0 / x), domain: (-4.0, -0.08)),
          (fn: x => calc.exp(1.0 / x), domain: (0.08, 4.0)),
        ),
        caption: [函数 $y = "e"^(1/x)$ 的图像],
      )
    ]
  ],

  // 右列：文字
  [
    $ lim_(x->0^+)frac("e"^(1/x)+1,"e"^(1/x)-1) arctan 1/x &= lim_(x->0^+)frac(1+ 1/"e"^(1/x),1-1/"e"^(1/x))arctan 1/x = pi/2 \
     lim_(x->0^-)frac("e"^(1/x)+1,"e"^(1/x)-1) arctan 1/x &= -1 dot (-pi/2) = pi/2
     $

     故$display(lim_(x->0^+)frac("e"^(1/x)+1,"e"^(1/x)-1) arctan 1/x = pi/2).$ 
  ]
)

#prob-box[$ lim_(x->oo)frac((x+a)^(x+a)(x+b)^(x+b),(x+a+b)^(2x+a+b)) $]

使用二级结论:

#conclusion("求极限结论①")[
  $ lim_(x arrow.r oo) (frac(a x + b_1, a x + b_2))^(h x + c) = upright(e)^(frac(h (b_1 - b_2), a)) $

]

$ lim_(x arrow.r oo) frac((x + a)^(x + a) (x + b)^(x + b), (x + a + b)^(2 x + a + b))  & = lim_(x arrow.r oo) frac((x + a)^(x + a) (x + b)^(x + b), (x + a + b)^(x + a) (x + a + b)^(x + b))\
 & = lim_(x arrow.r oo) (frac(x + a, x + a + b))^(x + a) dot.op lim_(x arrow.r oo) (frac(x + b, x + a + b))^(x + b)\
 & = upright(e)^(- b) dot.op upright(e)^(- a) = upright(e)^(- (a + b)) $

#prob-box[
  设$k>0$, 若$display(lim_(x->0)frac(arctan k x^2 + k x^2 f(x),x^6)=0)$, 且$display(lim_(x->0)frac(1+f(x), x^4)=1)$, 则$k=$
]

#conclusion("脱帽法")[
设原式为$alpha(x)$, $alpha(x)$是一个无穷小量. 解出$f(x)$, 然后替代第二个式子中的$f(x)$即可.
]

使用"脱帽法", 设$alpha(x)$是一个无穷小量, 令:

$ frac(arctan k x^2 + k x^2 f (x), x^6) = alpha (x) $

则

$ f (x) = frac(alpha (x) x^6 - arctan k x^2, k x^2) $

$ lim_(x arrow.r 0) frac(1 + frac(alpha (x) x^6 - upright(a r c) tan k x^2, k x^2), x^4) & = lim_(x arrow.r 0) frac(k x^2 - arctan k x^2 + alpha (x) x^6, k x^6)\
 & = lim_(x arrow.r 0) frac(k x^2 - [k x^2 - frac(k^3 x^6, 3) + o (k^3 x^6)] + underbrace(alpha (x), 0) x^6, k x^6)\
 & = k^2 / 3 $

易得$k=sqrt(3)$.

#prob-box[
  求极限:$ lim_(x arrow.r pi / 4) (tan x)^(tan 2 x) $
]

$ lim_(x arrow.r pi / 4)((sin x )/( cos x))^(frac(sin 2x, cos 2x)) &= exp( lim_(x arrow.r pi / 4) frac(sin 2x, cos 2x) ((sin x )/( cos x)-1) ) \
&=  exp(- sqrt(2)lim_(x arrow.r pi / 4) frac(sin x - cos x, cos 2x) ) \
&=^L' exp(-sqrt(2) lim_(x arrow.r pi / 4) frac(cos x + sin x, 2 sin 2x)) \
&= "e"^(-1)
 $


#prob-box[求极限: $ lim_(x arrow.r 0) frac(tan (tan x) - sin (sin x), tan x - sin x) $
]

$ lim_(x arrow.r 0) frac(tan (tan x) - sin (sin x), tan x - sin x) & = lim_(x arrow.r 0) frac(tan x + frac(tan^3 x, 3) + o (tan^3 x) - [sin x - frac(sin^3 x, 6) + o (sin^3 x)], x^3 / 2)\
 & = lim_(x arrow.r 0) frac(x^3 / 2 + frac(2 tan^3 x + sin^3 x, 6) + o (x^3), x^3 / 2) = 2 . $



#prob-box[求极限:$ lim_(x arrow.r 0) frac(sqrt(1 + 2 sin x) - x - 1, x ln (1 + x)) $
]

本题最关键的步骤是对分子根式有理化(应该不难看出). 如果不这样做的话, 解法会变得非常复杂.

$ 
lim_(x arrow.r 0) frac(sqrt(1 + 2 sin x) - x - 1, x ln (1 + x)) = lim_(x arrow.r 0) frac(1 + 2 sin x - (x + 1)^2, x^2) dot.op frac(1, sqrt(1 + 2 sin x) + x + 1)\
= 1 / 2 lim_(x arrow.r 0) frac(- x^2 + 2 sin x - 2 x, x^2)\
= 1 / 2 lim_(x arrow.r 0) frac(- x^2 + o (x^2), x^2) = - 1 / 2 . 
$

#prob-box[求极限:$ lim_(x arrow.r + oo) (2 / pi upright(a r c) tan x)^x $]

$ lim_(x arrow.r + oo) (2 / pi upright(a r c) tan x)^x &= exp [lim_(x arrow.r + oo) x (2 / pi upright(a r c) tan x - 1)] \
&= exp [lim_(x arrow.r + oo) frac(2 / pi upright(a r c) tan x - 1,1/x)]\
&=^L' exp [2/pi lim_(x arrow.r + oo) frac(1/(1+x^2),- 1/x^2)]="e"^(-2/pi)
$

#prob-box[求极限: $ lim_(x arrow.r 0^(+)) (arcsin x)^(tan x) $]

这是$0^0$型未定式.

$ lim_(x arrow.r 0^(+)) ("arc" sin x)^(tan x) & = exp [lim_(x arrow.r 0^(+)) tan x ln upright(a r c) sin x]\
 & = exp [lim_(x arrow.r 0^(+)) x ln upright(a r c) sin x]\
 & = exp [lim_(x arrow.r 0^(+)) frac(ln upright(a r c) sin x, 1 / x)]\
 & attach(=,t:upright(L^prime)) exp [lim_(x arrow.r 0^(+)) frac(frac(1, arctan x) dot.op 1 / sqrt(1 - x^2), - 1 / x^2)]\
 & = upright(e)^0 = 1 . $

#prob-box[求极限: $ lim_(x arrow.r 0^(+)) frac(1 - sqrt(cos x), x (1 - cos sqrt(x))) $]

$ lim_(x arrow.r 0^(+)) frac(1 - sqrt(cos x), x (1 - cos sqrt(x))) = lim_(x arrow.r 0^(+)) frac(1 - cos x, x (1 - cos sqrt(x))) dot.op frac(1, 1 + sqrt(cos x)) attach(=, t:"Trivial") 1 / 2 . $


#star-prob-box[求极限: $ lim_(x arrow.r 2) frac(root(4, x + 14) - 2, x^2 - 4) $]

令$t=x-2$, 原式为:

$ lim_(x arrow.r 2) frac(root(4, x + 14) - 2, x^2 - 4)  & = lim_(t arrow.r 0) frac(root(4, t + 16) - 2, t (t + 4))\
 & = lim_(t arrow.r 0) frac(2 [root(4, t / 16 + 1) - 1], t (t + 4))\
 &= lim_(t arrow.r 0)frac(2 dot 1/64, t+4) = 1 / 128 $

本题最关键的地方是要努力使用等价无穷小公式$(1+x)^alpha - 1 ~ alpha x$

#prob-box[求极限$ lim_(x arrow.r + oo) [(x^3 - x^2 + x / 2) upright(e)^(1 / x) - sqrt(x^6 + 1)] $]

倒代换, 令$t=1/x$, 则有

$
lim_(t arrow.r 0^+)[(1/t^3-1/t^2+1/(2t))"e"^t-sqrt(1/t^6+1)] &= lim_(t arrow.r 0^+)frac((t^2/2-t+1)"e"^t-sqrt(t^6+1),t^3)\
&= lim_(t arrow.r 0^+)frac((t^2/2-t+1)(1+t+t^2/2+t^3/6)-1,t^3)\
&= lim_(t arrow.r 0^+)frac(t^3/2-t^3/2+t^3/6,t^3)=1/6
$

#star-prob-box[已知$display(lim_(x arrow.r pi) frac(sqrt(sin x / 2) - 1, A (x - pi)^k) = 1)$, 求$A$和$k$的值
]

$
lim_(x arrow.r pi) frac(sqrt(sin x / 2) - 1, A (x - pi)^k) &= lim_(x arrow.r pi) frac(sqrt(1+ sin x / 2 -1) - 1, A (x - pi)^k)\
&= lim_(x arrow.r pi) frac(1/2[sin x / 2 - 1], A (x - pi)^k)\
&= 1/2 lim_(x arrow.r pi) frac(cos (x/2 -pi/2) - 1, A (x - pi)^k)\
&= 1/2 lim_(x arrow.r pi) frac(cos ((x-pi)/2) - 1, A (x - pi)^k)\
&= 1/2 lim_(x arrow.r pi) frac(-(x-pi)^2/8, A (x - pi)^k)
$

所以有$display(-1/(16A(x-pi)^(k-2))=1)$, 解得$A=display(-1/16), k=2$

#twostar-prob-box[求极限$ lim_(x arrow.r 0) frac(cos (x upright(e)^x) - upright(e)^(- x^2 / 2 dot.op upright(e)^(2 x)), x^4) $
]

$
lim_(x arrow.r 0) frac(cos (x upright(e)^x) - exp (- x^2 / 2 dot.op upright(e)^(2 x)), x^4) & = lim_(x arrow.r 0) frac(cos (x upright(e)^x) - exp (- x^2 / 2 dot.op upright(e)^(2 x)), x^4 dot.op text(fill: #rgb("F000F0"),upright(e)^(4 x) )) dot.op text(fill: #rgb("F000F0"),upright(e)^(4 x) )\
 & = lim_(x arrow.r 0) frac(cos (x upright(e)^x) - exp (- x^2 / 2 dot.op upright(e)^(2 x)), x^4 dot.op upright(e)^(4 x)) dot.op lim_(x arrow.r 0) upright(e)^(4 x)\
 & = lim_(x arrow.r 0) frac(cos (x upright(e)^x) - exp (- x^2 / 2 dot.op upright(e)^(2 x)), (x upright(e)^x)^4)\
 & = lim_(t arrow.r 0) frac(cos t - upright(e)^(- t^2 / 2), t^4)\
 & = lim_(t arrow.r 0) frac((1 - t^2 / 2 + t^4 / 24) - (1 - t^2 / 2 + t^4 / 8), t^4) = - 1 / 12
$

#prob-box[求极限$ lim_(x arrow.r + oo) (root(3, x^3 + x^2 + 1) - sqrt(x^2 + x + 1)) $]

倒代换, 令$t=1/x$

$ lim_(x arrow.r + oo) (root(3, x^3 + x^2 + 1) - sqrt(x^2 + x + 1)) & = lim_(t arrow.r 0^(+)) (root(3, frac(1 + t + t^2, t^3)) - sqrt(frac(1 + t + t^2, t^2)))\
 & = lim_(t arrow.r 0^(+)) 1 / t [root(3, 1 + t + t^2) - sqrt(1 + t + t^2)]\
 & = lim_(t arrow.r 0^(+)) frac((1 + t + t^2)^(1 / 3) - (1 + t + t^2)^(1 / 2), t)\
 & attach(=,t:L') - 1 / 6 . $

#prob-box[求极限:$ lim_(x arrow.r 0) frac(sqrt(cos x) - root(3, 1 + sin^2 x), x^2) $]

对于这种高次带根号的式子, 常使用$(1+x)^(alpha) -1~alpha x$等价无穷小代换

$ lim_(x arrow.r 0) frac(sqrt(cos x) - root(3, 1 + sin^2 x), x^2) & = lim_(x arrow.r 0) frac(sqrt(1 + cos x - 1) - 1 - (root(3, 1 + sin^2 x) - 1), x^2)\
 & = lim_(x arrow.r 0) frac(sqrt(1 + cos x - 1) - 1, x^2) - lim_(x arrow.r 0) frac(root(3, 1 + sin^2 x) - 1, x^2)\
 & = - 7 / 12 $

#prob-box[求极限:$ lim_(x arrow.r 0) frac((1 + x)^(1 / x) - upright(e)^(cos x), root(3, 1 + x) - 1) $]

#conclusion("Exp函数的差")[$"e"^f-"e"^q="e"^q ("e"^(f-q) -1)$]

$ lim_(x arrow.r 0) frac((1 + x)^(1 / x) - upright(e)^(cos x), root(3, 1 + x) - 1) & = lim_(x arrow.r 0) frac(upright(e)^(frac(ln (x + 1), x)) - upright(e)^(cos x), root(3, 1 + x) - 1)\
 & = lim_(x arrow.r 0) frac(upright(e)^(cos x) (upright(e)^(frac(ln (x + 1), x) - cos x) - 1), 1 / 3 x)\
 & = lim_(x arrow.r 0) frac(upright(e)^(cos x) [frac(ln (x + 1), x) - cos x], 1 / 3 x)\
 & = 3 upright(e) lim_(x arrow.r 0) frac(frac(ln (x + 1), x) - cos x, x) = - frac(3 upright(e), 2) .\
 $

#prob-box[求极限:$ lim_(x arrow.r 0) 1 / x^3 [(frac(cos x + 2 cos 2 x, 3))^x - 1] $]

$ lim_(x arrow.r 0) 1 / x^3 [(frac(cos x + 2 cos 2 x, 3))^x - 1] & = lim_(x arrow.r 0) 1 / x^3 [exp (x ln frac(cos x + 2 cos 2 x, 3)) - 1]\
 & = lim_(x arrow.r 0) frac(frac(cos x + 2 cos 2 x, 3) - 1, x^2)\
 & = lim_(x arrow.r 0) frac(cos x + 2 cos 2 x - 3, 3 x^2)\
 &attach(=,t:"Taylor") - 3 / 2 $

#star-prob-box[求数列极限:$ lim_(n arrow.r oo) sin (sqrt(4 n^2 + n) pi) $]

(法一)
$ lim_(n arrow.r oo) sin (sqrt(4 n^2 + n) pi) & = lim_(n arrow.r oo) sin (sqrt(4 n^2 + n) pi - 2 n pi)\
 & = lim_(n arrow.r oo) sin [(sqrt(4 n^2 + n) - 2 n) pi]\
 & = lim_(n arrow.r oo) sin [(frac((sqrt(4 n^2 + n) - 2 n) (sqrt(4 n^2 + n) + 2 n), (sqrt(4 n^2 + n) + 2 n))) pi]\
 & = lim_(n arrow.r oo) sin [frac(n pi, sqrt(4 n^2 + n) + 2 n)]\
 & = lim_(n arrow.r oo) sin [frac(pi, sqrt(4 + 1 / n) + 2)]\
 & = sin pi / 4 = sqrt(2) / 2 . $

(法二)使用Taylor公式

$
 lim_(n arrow.r oo) sin (sqrt(4 n^2 + n) pi) &= lim_(n arrow.r oo) sin (2 n pi sqrt(1+frac(1,4n)))\
 &= sin lr([2 n pi dot (1+frac(1,8n))])\
 &= sin (2 n pi + pi/4) = sin pi/4 = sqrt(2)/2
$


#prob-box[求极限:$ lim_(x->oo)frac((2x-3)^20 (3x+2)^30,(2x+1)^50) $]

$ lim_(x->oo)frac((2x-3)^20 (3x+2)^30,(2x+1)^50)&= lim_(x->oo)frac((2x-3)^20/x^20 (3x+2)^30/x^30,(2x+1)^50/x^50) \
&= lim_(x->oo)frac((2-3/x)^20(3+2/x)^30,(2+1/x)^50)\
&= lim_(x->oo) frac(2^20 dot 3^30 , 2^50) = (3/2)^30 
$


== 极限综合题

#pagebreak()

= 导数与微分

== 导数计算题

#prob-box[设$display(f(x)=x+(x-1)arcsin sqrt(frac(x,x+1)))$, 求$f'(1)$]

$
f'(1) &= lim_(x->1) frac(x+(x-1)arcsin sqrt(frac(x,x+1))-1,x-1)\
&= lim_(x->1)frac(x-1,x-1) + lim_(x->1)frac((x-1)arcsin sqrt(frac(x,x+1)),x-1) = 1+ pi/4
$

#prob-box[求$display(tan(x+y+pi/4)="e"^y)$在$(0,0)$处的切线方程是]

设切线方程$y-0=k(x-0)$, 对隐函数求导得$y'=-2$, 所以方程为$y=-2x$

== 导数概念题

#prob-box[设$display(f(x) = cases(frac(abs(x^(2)- 1), x - 1)\,& x != 1, 2\,& x = 1,))$, 则在点$x=1$处函数$f(x)$为

#grid(
  columns: (1fr, 1fr),  // 分为平分的左右两栏
  row-gutter: 1em,    // 设置行间距，让公式看起来不拥挤

  "A.不连续",
  "B.连续, 但不可导",
  "C.可导, 但导数不连续",
  "D.可导, 且导数连续"
)
]

正确答案A.

$ lim_(x->1^+)f(x)= frac(x^2-1,x-1)= x + 1 = 2\
  lim_(x->1^-)f(x)= frac(1-x^2,x-1)=-(x+1)=-2
 $

由于函数左右极限不相等, $display(lim_(x->1)f(x))$不存在, 故函数在$x=1$处不连续.

#prob-box[设函数$f(x)$对任意的$x$均满足等式$f(1+x)=a f(x)$, 且有$f'(0)=b$, 其中$a,b$为非零常数, 则

#grid(
  columns: (1fr, 1fr),  // 分为平分的左右两栏
  row-gutter: 1em,    // 设置行间距，让公式看起来不拥挤

[A. $f(x)$在$x=1$不可导],
[B. $f(x)$在$x=1$可导, 且$f'(1)=a$],
[C. $f(x)$在$x=1$可导, 且$f'(1)=b$],
[D. $f(x)$在$x=1$可导, 且$f'(1)=a b$],
)
]

当$x=0$时, 有$f(1)=a f(0)$

$
f'(1) = lim_(x->0)frac(f(1+x)-f(1),x) = a frac(f(x)-f(0),x) = a b
$

#prob-box[$f'(0)$存在, 且$f(0)=0$, 则$ lim_(x->0) frac(f(1-cos 2x), x sin x)= #h(2em) lim_(x->0)frac(f(x^2),sin^2 (x/3))= $]

$
lim_(x->0) frac(1-cos 2x, x sin x) = lim_(x->0) frac(f(1-cos 2x) - f(0),1 - cos 2x - 0) dot frac(1 - cos 2x,x sin x) = 2 f'(0)\
lim_(x->0)frac(f(x^2),sin^2 (x/3)) = lim_(x->0)frac(f(x^2)-f(0),x^2-0) dot frac(x^2,sin^2 (x/3)) = 9 f'(0)
$

#prob-box[已知$alpha,beta$是常数, $f(x)$可导, 求$
lim_(Delta->0)frac(f(x+alpha Delta x)-f(x-beta Delta x),Delta x)
$]

$
lim_(Delta->0)frac(f(x+alpha Delta x)-f(x-beta Delta x),Delta x) &= alpha lim_(Delta->0)frac(f(x+alpha Delta x)-f(x),alpha Delta x) + beta lim_(Delta->0)frac(f(x- beta Delta x)-f(x),- beta Delta x)\
&= (alpha + beta)f'(x)
$

#prob-box[若$display(f(x)= cases(g(x)cos 1/x\,& x eq.not 0 ,0 \, & x eq 0))$, 而$g(0)=g'(0)=0$, 则$f'(0)=$]

$
f'(0) = lim_(x->0)frac(f(x)-f(0), x-0) = lim_(x->0) frac(g(x)cos 1/x , x)=lim_(x->0)frac(g(x)-g(0),x-0)cos 1/x =lim_(x->0) g'(0) cos 1/x = 0
$





#pagebreak()

= 不定积分

== 不定积分计算

#prob-box[求不定积分$ integral (a / x + a^2 / x^2 + a^3 / x^3 + a^4 / x^4) upright(d) x $]

$ integral (a / x + a^2 / x^2 + a^3 / x^3 + a^4 / x^4) upright(d) x = a ln lr(|x|) - a^2 / x - a^3 / 2 x^(- 2) - a^4 / 3 x^(- 3) + C $

#prob-box[求不定积分$ integral frac(3, 1 + x^2) - 2 / sqrt(1 - x^2) upright(d) x $]

$ integral frac(3, 1 + x^2) - 2 / sqrt(1 - x^2) upright(d) x = 3 arctan x - 2 arcsin x + C $

#prob-box[求不定积分$ integral frac(1, x^2 + 1) - frac(1, x^2 - 1) upright(d) x $]

$ integral frac(1, x^2 + 1) - frac(1, x^2 - 1) upright(d) x = arctan x - 1 / 2 ln lr(|frac(x - 1, x + 1)|) + C $

#prob-box[求不定积分$ integral upright(e)^(upright(e)^x sin x) (sin x + cos x) upright(e)^x upright(d) x $]

$ integral upright(e)^(upright(e)^x sin x) (sin x + cos x) upright(e)^x upright(d) x & = integral upright(e)^(upright(e)^x sin x) (upright(e)^x sin x)^prime upright(d) x\
 & = integral upright(e)^(upright(e)^x sin x) upright(d) (upright(e)^x sin x)\
 & = integral upright(e)^t upright(d) t = upright(e)^t + C = upright(e)^(upright(e)^x sin x) + C\
 $

#prob-box[求不定积分$ integral upright(e)^(tan 1 / x) / x^2 sec^2 1 / x upright(d) x $]

注意到$ (tan 1 / x) prime = - 1 / x^2 sec^2 1 / x $

则有$ integral upright(e)^(tan 1 / x) / x^2 sec^2 1 / x upright(d) x = - integral upright(e)^(tan 1 / x) upright(d) tan 1 / x = - upright(e)^(tan 1 / x) + C $

#prob-box[求不定积分$ integral frac(upright(d) x, root(3, 2 - 3 x)) $]

$ integral frac(upright(d) x, root(3, 2 - 3 x)) = - 1 / 3 integral frac(upright(d) (2 - 3 x), root(3, 2 - 3 x)) = - 1 / 2 (2 - 3 x)^(2 / 3) + C $

#prob-box[求不定积分$ integral frac(sin sqrt(x), sqrt(x)) upright(d) x $]

$ integral frac(sin sqrt(x), sqrt(x)) upright(d) x = 2 integral sin sqrt(x) upright(d) sqrt(x) = - 2 cos sqrt(x) + C $

#prob-box[求不定积分$ integral frac(upright(d) x, 2 + 3 x^2) $]

根据积分表$ integral frac(upright(d) x, a^2 + x^2) = 1 / a arctan x / a + C $

$ integral frac(upright(d) x, 2 + 3 x^2) = 1 / sqrt(3) integral frac(upright(d) (sqrt(3) x), (sqrt(2))^2 + (sqrt(3) x)^2) = 1 / sqrt(6) arctan frac(sqrt(6) x, 2) + C $


#prob-box[求不定积分$ integral frac(upright(d) x, 2 - 3 x^2) $]

根据积分表$display(integral frac(upright(d) x, a^2 - x^2) = frac(1, 2 a) ln lr(|frac(a + x, a - x)|) + C)$

$ integral frac(upright(d) x, 2 - 3 x^2) = 1 / sqrt(3) integral frac(upright(d) (sqrt(3) x), (sqrt(2))^2 - (sqrt(3) x)^2) = frac(1, 2 sqrt(6)) ln abs(frac(sqrt(2) + sqrt(3) x, sqrt(2) - sqrt(3) x))   + C $

#prob-box[求不定积分$ integral 1 / sqrt(3 x^2 - 2) upright(d) x $]

根据积分表$display(integral frac(upright(d) x, sqrt(x^2 plus.minus a^2)) = ln lr(|x + sqrt(x^2 plus.minus a^2)|) + C)$

$ integral 1 / sqrt(3 x^2 - 2) upright(d) x = 1 / sqrt(3) integral frac(upright(d) (sqrt(3) x), (sqrt(3) x)^2 - (sqrt(2))^2) = 1 / sqrt(3) ln lr(|sqrt(3) x + sqrt(3 x^2 - 2)|) + C $

#prob-box[求不定积分$ integral sec x "d"x $]

根据积分表$ integral sec x upright(d) x = ln lr(|sec x + tan x|) + C $

#prob-box[求不定积分$ integral tan^4 x sec^2 x upright(d) x $]

$ integral tan^4 x sec^2 x upright(d) x = integral tan^4 x upright(d) (tan x) = 1 / 5 tan^5 x + C $

#prob-box[求不定积分$ integral frac(2 x - 1, sqrt(1 - x^2)) upright(d) x $]

$
integral frac(2 x - 1, sqrt(1 - x^(2)))dif x & = integral frac(2 x, sqrt(1 - x^(2)))dif x - integral frac(1, sqrt(1 - x^(2)))dif x \ & = - integral frac(1, sqrt(1 - x^(2)))dif(- x^(2)) - integral frac(1, sqrt(1 - x^(2)))dif x \ & = - 2 sqrt(1 - x^(2))- arcsin x + C
$

#prob-box[求不定积分$ integral frac(2 x - 1, sqrt(x^2 - x)) upright(d) x $]

$ integral frac(2 x - 1, sqrt(x^2 - x)) upright(d) x = integral 1 / sqrt(x^2 - x) upright(d) (x^2 - x) = 2 sqrt(x^2 - x) + C $

#prob-box[求不定积分$ integral x / sqrt(2 - 3 x^2) upright(d) x $]

$ integral x / sqrt(2 - 3 x^2) upright(d) x = - 1 / 6 integral 1 / sqrt(2 - 3 x^2) upright(d) (2 - 3 x^2) = - 1 / 3 sqrt(2 - 3 x^2) + C $

#prob-box[求不定积分$ integral x sin x "d"x $]

使用交换图(第一行求导, 第二行积分)

#align(center)[
  #let (a0,b0,a1,b1,a2,b2) = ((0,0), (0,1), (1,0), (1,1), (2,0), (2,1))
  #diagram(
    // 控制节点间的水平和垂直间距
    spacing: (4em, 2em), 
    node(a0, $x$),
    node(a1, $1$),
    node(a2, $0$),
    node(b0, $sin x$),
    node(b1, $-cos x$),
    node(b2, $-sin x$),

// 批量生成 a0->a1->a2 和 b0->b1->b2 的连线
  ..((a0, a1, a2), (b0, b1, b2)).map(chain => {
    // 对每一组节点，生成相邻节点间的连线
    range(chain.len() - 1).map(i => edge(chain.at(i), chain.at(i+1), "->"))
  }).flatten(),

    edge(a0, b1, $+$, "->", label-side: left, label-pos: 0.5, label-sep: -1pt),
    edge(a1, b2, $-$, "->", label-side: left, label-pos: 0.5, label-sep: -1pt),
  )
]

故答案为$ integral x sin x upright(d) x = - x cos x + sin x + C $

#prob-box[求不定积分$ integral x ln x "d"x $]

$
1/2 integral ln x "d"x^2 &= x^2 ln x - integral x^2 "d"(ln x)\
&=  x^2 ln x - integral x "d"x \
&= 1/2 x^2 ln x - 1/4 x^2 + C
$

#prob-box[求不定积分$ integral x^2 ln x "d"x $]

$ integral x^2 ln x upright(d) x = 1 / 3 integral ln x upright(d) x^3 = 1 / 3 (x^3 ln x - integral x^2 upright(d) x) = 1 / 3 x^3 ln x - 1 / 9 x^3 + C $

#prob-box[求不定积分$ integral x^2 arctan x "d"x $]

$ integral x^2 arctan x upright(d) x = 1 / 3 integral arctan x upright(d) x^3 & = 1 / 3 [x^3 arctan x - integral frac(x^3, 1 + x^2) upright(d) x]\
 & = 1 / 3 [x^3 arctan x - 1 / 2 integral frac(x^2, 1 + x^2) upright(d) x^2]\
 & = 1 / 3 [x^3 arctan x - 1 / 2 integral 1 - frac(1, 1 + x^2) upright(d) x^2]\
 & = 1 / 3 x^3 arctan x - 1 / 6 x^2 + 1 / 6 ln (1 + x^2) + C $

#prob-box[求不定积分$ integral x^2 sin x "d"x $]

使用交换图

#align(center)[
  #let (a0,b0,a1,b1,a2,b2,a3,b3) = ((0,0), (0,1), (1,0), (1,1), (2,0), (2,1),(3,0),(3,1))
  #diagram(
    // 控制节点间的水平和垂直间距
    spacing: (4em, 2em), 
    node(a0, $x^2$),
    node(a1, $2x$),
    node(a2, $2$),
    node(a3, $0$),
    node(b0, $sin x$),
    node(b1, $-cos x$),
    node(b2, $-sin x$),
    node(b3, $cos x$),

// 批量生成 a0->a1->a2 和 b0->b1->b2 的连线
  ..((a0, a1, a2,a3), (b0, b1, b2,b3)).map(chain => {
    // 对每一组节点，生成相邻节点间的连线
    range(chain.len() - 1).map(i => edge(chain.at(i), chain.at(i+1), "->"))
  }).flatten(),

    edge(a0, b1, $+$, "->", label-side: left, label-pos: 0.5, label-sep: -1pt),
    edge(a1, b2, $-$, "->", label-side: left, label-pos: 0.5, label-sep: -1pt),
    edge(a2, b3, $+$, "->", label-side: left, label-pos: 0.5, label-sep: -1pt),
  )
]

故答案为

$ integral x^2 sin x "d"x = - x^2 cos x + 2 x sin x + 2 cos x +C $

#prob-box[求不定积分$ integral ln^2 x "d"x $]

$
integral ln^2 x "d"x &= x ln^2 x - integral x "d"(ln^2 x)\
&= x ln^2 x - 2 integral ln x "d"x\
&= x ln^2 x - 2 x ln x + 2 x + C
$

#prob-box[求不定积分$ integral x ln (x-1) "d"x $]

$
integral x ln (x-1) "d"x &= 1/2 integral ln(x-1)"d"(x^2)\
&= 1/2 lr([x^2 ln(x-1) - integral x^2 "d"[ln(x-1)]])\
&= 1/2 lr([x^2 ln(x-1) - integral frac(x^2-1+1,x-1)"d"x ])\
&= 1/2 lr([x^2 ln(x-1) - integral (x+1)"d"x - integral 1/(x-1)"d"x ])\
&= 1/2 x^2 ln(x-1) - 1/4 x^2 - 1/2 x - 1/2 ln(x-1) + C
$

#prob-box[求不定积分$ integral (ln^3 x) / x^2 "d"x $]

令$ln x = t , x = upright(e)^t , upright(d) x = upright(e)^t upright(d) t$,

使用交换图

#align(center)[
  #let (a0,b0,a1,b1,a2,b2,a3,b3,a4,b4) = ((0,0),(0,1),(1,0),(1,1),(2,0),(2,1),(3,0),(3,1),(4,0),(4,1))
  #diagram(
    // 控制节点间的水平和垂直间距
    spacing: (4em, 2em), 
    node(a0, $t^3$),
    node(a1, $3t^2$),
    node(a2, $6t$),
    node(a3, $6$),
    node(a4, $0$),
    node(b0, $"e"^(-t)$),
    node(b1, $-"e"^(-t)$),
    node(b2, $"e"^(-t)$),
    node(b3, $-"e"^(-t)$),
    node(b4, $"e"^(-t)$),

// 批量生成 a0->a1->a2 和 b0->b1->b2 的连线
  ..((a0,a1,a2,a3,a4), (b0,b1,b2,b3,b4)).map(chain => {
    // 对每一组节点，生成相邻节点间的连线
    range(chain.len() - 1).map(i => edge(chain.at(i), chain.at(i+1), "->"))
  }).flatten(),

    edge(a0, b1, $+$, "->", label-side: left, label-pos: 0.5, label-sep: -1pt),
    edge(a1, b2, $-$, "->", label-side: left, label-pos: 0.5, label-sep: -1pt),
    edge(a2, b3, $+$, "->", label-side: left, label-pos: 0.5, label-sep: -1pt),
    edge(a3, b4, $-$, "->", label-side: left, label-pos: 0.5, label-sep: -1pt),
  )
]

故答案为$ integral (ln^3 x) / x^2 "d"x = - frac(ln^3 x, x) - frac(3 ln^2 x, x) - frac(6 ln x, x) - 6 / x + C $

#prob-box[求不定积分$ integral((ln x) / x)^3"d"x $]

令$t=ln x$, 后续过程平凡

$ integral (frac(ln x, x))^3 upright(d) x = - frac(ln^3 x, 2 x^2) - frac(3 ln^2 x, 4 x^2) - frac(3 ln x, 4 x^2) - frac(3, 8 x^2) + C $

#prob-box[求不定积分$ integral (arcsin x)^2 "d"x $]

设$x=sin t, "d"x = cos t "d"t$

$
integral (arcsin x)^2 "d"x &= integral t^2 cos t "d"t\
&= x arcsin^2 x + 2 arcsin x sqrt(1-x^2) - 2 x + C
$

#conclusion("反三角函数恒等式")[

#grid(
  columns: (30%, 70%),
  gutter: 1.5em,

  // 左列：用 block/box 控制这一列里的排版宽度
  [
    #image("Geogebra/反三角恒等式.svg", width: 70%)
  ],

  [
    如何求$cos(arcsin x)$的值?

    我们设$theta = arcsin x$, 则$x = sin theta$. 我们就能画出左图的图像.

    于是有$display(cos(arcsin x) = cos theta = sqrt(1-x^2))$
  ]

)  
]

#prob-box[求不定积分$ integral "e"^sqrt(3x+9)"d"x $]

设$t=sqrt(3x+9), x= 1/3 (t^2-9), "d"x = 2/3 t "d"t$

于是原式$ integral "e"^sqrt(3x+9)"d"x = 2/3 integral "e"^t "d"t = 2/3 (sqrt(3x+9)"e"^sqrt(3x+9) - "e"^sqrt(3x+9))+C $

#prob-box[求不定积分$ integral arcsin x "d"x $]

$
integral arcsin x "d"x &= x arcsin x - integral x "d"(arcsin x)\
&= x arcsin x - integral x/sqrt(1-x^2) "d"x\
&= x arcsin x + 1/2 integral 1/sqrt(t) "d"t\
&= x arcsin x + sqrt(1-x^2) + C
$

#prob-box([求不定积分$ integral 1/(x sqrt(1-x^2))"d"x $], label:<ex:4.1.28>)

设$x = sin t, "d"x = cos t "d"t, sqrt(1-x^2)=cos t$

$
integral 1/(x sqrt(1-x^2))"d"x &= integral csc t "d"t \
&= - ln abs(csc t + cot t)
&= - ln abs(1/x + sqrt(1-x^2)/x) + C
$



#star-prob-box[求不定积分$ integral frac(arcsin x, x^2)"d"x $ ]

(法一: 三角换元)

设$t=arcsin x, x = sin t, "d"t = cos t "d"t $

$
integral frac(arcsin x, x^2)"d"x &= integral frac(t cos t, sin^2 t)"d"t\
&= - integral t "d"(1/(sin t))\
&= -[t/(sin t)- integral csc t "d"t]\
&= - t/(sin t) - ln abs(csc t - cot t)\
&= - (arcsin x)/x - ln abs(1/x + sqrt(1/x^2-1))+C
$

(法二: 代数换元)根据 @ex:4.1.28 的结果, 可知

$
integral arcsin x "d"x &= integral arcsin x "d"(-1/x)\
&= - (arcsin x)/x + integral 1/(x sqrt(1-x^2))"d"x\
&= - (arcsin x)/x - ln abs(1/x + sqrt(1/x^2-1))+C
$

#prob-box[求不定积分$ integral frac(root(5, 1-2x+x^2),1-x)"d"x $]

$
integral frac(root(5, 1-2x+x^2),1-x)"d"x &= - integral frac(root(5,(1-x)^2),1-x) "d"(1-x)\
&= - 5/2(1-x)^(2/5) + C
$

#prob-box[求不定积分$ integral frac("d"x, sin^2(2x+pi/4)) $]

$
integral frac("d"x, sin^2(2x+pi/4)) &= 1/2 integral csc^2 (2x+pi/4)"d"(2x+pi/4)\
&= - 1/2 cot (2x+pi/4) + C
$

#prob-box[求不定积分$ integral 1/(1+cos x)"d"x $]

$
integral 1/(1+cos x)"d"x &= integral 1/(2 cos^2 x/2)"d"x\
&= integral sec^2 x/2 "d"(x/2)\
&= tan x/2 + C
$

#prob-box[求不定积分$ integral ("d"x)/(1-cos x) $]

$
integral ("d"x)/(1-cos x)  &= integral frac("d"(x/2),sin^2(x/2))\
&= integral csc^2 (x/2) "d"(x/2)\
&= - cot x/2 + C
$

#prob-box[求不定积分$ integral ("d"x)/(1+sin x) $]

$
integral ("d"x)/(1+sin x) &= integral frac(1-sin x , (1+sin x)(1-sin x))"d"x\
&= integral frac(1- sin x, cos^2 x)"d"x\
&= integral sec^2 x + integral 1/(cos^2 x) "d"(cos x)\
&= tan x - 1/(cos x) + C\
&= - (cos x)/(1+sin x) + C
$

#prob-box[求不定积分$ integral sin^3 x "d"x $]

$
integral sin^3 "d"x = - integral sin^2 x "d"(cos x) = - integral (1-cos^2 x)"d"(cos x) = - cos x + 1/3 cos^3 x + C
$

#prob-box[求不定积分$ integral cos^3 x "d"x $]

$
integral cos^3 x "d"x = integral cos^2 x "d"(sin x) = integral (1-sin^2 x)"d"(sin x) = sin x - 1/3 sin^3 x + C
$

#prob-box[求不定积分$ integral frac(x, (x+1)(x+2)(x+3))"d"x $]

有理函数积分, 使用待定系数法

$
integral frac(x, (x+1)(x+2)(x+3))"d"x &= integral frac(A,x+1)+frac(B,x+2)+frac(C,x+3)"d"x
$

在分子上, 我们有
$
x = A(x+2)(x+3) + B(x+1)(x+3) + C(x+1)(x+2)
$

使用特殊值法, 令$x=-1,-2,-3$, 解得:

$
cases(
  A= -1/2,
  B= 2,
  C=-3/2 
)
$

所以原积分为

$
integral frac(x, (x+1)(x+2)(x+3))"d"x &= -1/2 ln abs(x+1) + 2 ln abs(x+2) - 3/2 ln abs(x+3) + C
$


#prob-box[求不定积分 $ integral frac("d"x, (1+x)(x^2-1)) $]

$
integral frac("d"x, (1+x)(x^2-1)) &= integral frac("d"x,(1+x)^2(x-1))\
&= integral frac(A,1+x) + frac(B,(1+x)^2) + frac(C,x-1) "d"x \
$

使用特殊值法, 解得$A=1/4,B=-1/2,C=1/4$

所以答案为$ integral frac("d"x, (1+x)(x^2-1)) = -1/4 ln abs(1+x) + frac(1,2(1+x))+ 1/4 ln abs(x-1) + C $

#prob-box[求不定积分 $ integral frac("d"x, (x-1)(x^2+1)) $ ]

#conclusion([二次有理函数积分展开式])[
  $ integral frac("d"x, (x-1)(x^2+1)) = integral frac(A,x-1) + frac(B x+C,x^2+1) $
]

所以有

$
A(x^2+1)+(B x+C)(x-1) &= 1\
(A+B)x^2+(C-B)x+A-C&=1 
$

使用待定系数法

$
cases(
  A-C=1,A+B=0,C-B=0
)
$

解得: $A=1/2, B=-1/2, C=-1/2$. 所以原式:

$
integral frac("d"x, (x-1)(x^2+1)) &= 1/2 integral frac(1,x-1)"d"x - 1/2 integral frac(x+1,x^2+1)"d"x\
&= 1/2 integral frac(1,x-1)"d"x - 1/4 integral frac(1,x^2+1)"d"x^2 - 1/2 integral frac(1,x^2+1)"d"x\
&= 1/2 ln abs(x-1) - 1/4 ln (x^2+1) - 1/2 arctan x + C
$

#prob-box[求不定积分$ integral frac(x^2+1,(x+1)^2(x-1))"d"x $]

$
integral frac(x^2+1,(x+1)^2(x-1))"d"x &= integral frac(A,x+1) + frac(B,(x+1)^2) + frac(C,x-1) "d"x 
$

在分子上, 我们有

$
(x+1)(x-1)A + (x-1)B + (x+1)^2 C = x^2 + 1
$

使用特殊值法, 解得: $A=1/2, B=-1, C=1/2$. 最后有

$
integral frac(x^2+1,(x+1)^2(x-1))"d"x = 1/2 ln abs(x+1) + frac(1,x+1) + 1/2 ln abs(x-1) + C
$

#prob-box[求不定积分$ integral frac(1,x^4-1)"d"x $]

(法一)

$
integral frac(1,x^4-1)"d"x &= integral frac(1,(x^2+1)(x+1)(x-1))"d"x\
&= integral frac(A,x+1) + frac(B,x-1) + frac(C x + D, x^2+1)"d"x
$

使用待定系数法和特殊值法可得:$A=-1/4, B=1/4, C=0, D=-1/2$

后续过程平凡 $ integral frac(1,x^4-1)"d"x = 1/4 ln abs(frac(x-1,x+1)) - 1/2 arctan x + C $

(法二:积分表法)

$
integral frac(1,x^4-1)"d"x &= integral frac(1,(x^2+1)(x^2-1))"d"x\
&= -1/2 lr([integral frac(1,x^2+1)"d"x - integral frac(1,x^2-1)"d"x])\
&= -1/2 lr([arctan x - 1/2 ln abs(frac(x-1,x+1))])\
&= 1/4 ln abs(frac(x-1,x+1)) - 1/2 arctan x + C
$

#prob-box[求不定积分$ integral frac("d"x,1+root(3,x+1)) $]

根式是非常讨厌的, 一般使用换元法把根式替换掉.

令$t=root(3,x+1), x=t^3-1, "d"x = 3t^2"d"t$,

$
integral frac("d"x,1+root(3,x+1)) &= 3 integral frac(t^2,1+t)"d"t #<exf:4.1.42-1>
$

@exf:4.1.42-1 是一个有理假分式, 不能使用有理函数积分法, 需要使用其他代数方法求解.

$
3 integral frac(t^2,1+t)"d"t &= 3 integral frac(t^2-1+1,1+t)"d"t\
&= 3 lr([integral frac((t+1)(t-1),t+1)"d"t + integral frac(1,t+1)"d"t])\
&= 3/2 (x+1)^(2/3) - 3 root(3,x+1) +  3 ln abs(1+root(3,x+1)) + C 
$

#prob-box[求不定积分$ integral frac((sqrt(x))^3-1,sqrt(x)+1)"d"x $]

令$t=sqrt(x), 2 t "d"t = "d"x$, 则有

$
integral frac((sqrt(x))^3-1,sqrt(x)+1)"d"x &= 2 integral frac(t^4-t,t+1) "d"t\
$

使用长除法, 让$t^4 - t$长除$t+1$, 可得$t^4-t = (t+1)(t^3-t^2+t)-2t$

$
integral frac((sqrt(x))^3-1,sqrt(x)+1)"d"x &= 2 integral frac(t^4-t,t+1) "d"t\
&= 2 integral (t^3 - t^2 + t)"d"t -2 integral frac(t,t+1)"d"t\
&= 2 integral (t^3 - t^2 + t)"d"t -2 integral frac(t+1-1,t+1)"d"t\
&= 1/2 x^2 - 2/3 sqrt(x^3) + x - 4 sqrt(x) + 4 ln abs(1+sqrt(x)) + C
$

#prob-box[求不定积分$ integral sin^2 x "d"x $]

$
integral sin^2 x "d"x = 1/2 integral (1-cos 2x)"d"x = - 1/4 sin 2 x + 1/2 x + C
$

#prob-box[求不定积分$ integral frac(1,1+sin x+cos x)"d"x $]

定式题. 使用万能公式

$
integral frac(1,1+sin x+cos x)"d"x &= integral frac(2"d"u,(1+frac(2u,1+u^2)+frac(1-u^2,1+u^2))1+u^2)\
&= integral frac(2 "d"u,2u+2)\
&= ln abs(1+tan x/2) + C
$

#star-prob-box[求不定积分$ integral frac("d"x, a^2 sin^2 x+b^2cos^2 x) $]

$
integral frac("d"x, a^2 sin^2 x+b^2cos^2 x) &= integral frac("d"x,cos^2 x (a^2 tan^2 x+b^2))\
&= 1/a integral frac(1,a^2 tan^2 x+b^2)"d"(a tan x)\
&= frac(1,a b) arctan frac(a tan x,b)+C
$

#prob-box[求不定积分$ integral frac("d"x, 3+sin^2 x) $]

本题使用到的积分表:

#rect($ integral frac("d"x, a^2 sin^2 x+b^2cos^2 x) = frac(1,a b) arctan frac(a tan x,b)+C $)


$
integral frac("d"x, 3+sin^2 x) &= integral frac("d"x, 3(sin^2 x+cos^2 x)+sin^2 x )\
&= integral frac("d"x, 4 sin^2 x + 3 cos^2 x)\
&= frac(1,2 sqrt(3))arctan frac(2 tan x,sqrt(3)) + C
$

#prob-box[求不定积分$ integral frac("d"x, 3+cos x) $]

万能公式

$
integral frac("d"x, 3+cos x) &= integral frac(frac("d"u,1+u^2),3+frac(1-u^2,1+u^2))\
&= integral frac("d"u,2+u^2)\
&= frac(1,sqrt(2)) arctan frac(tan x/2, sqrt(2)) + C
$

#prob-box[求不定积分$ integral sqrt(1-x^2)arcsin x "d"x $]

令$t=arcsin x, x = sin t, "d"x = cos t "d"t$,

$
integral sqrt(1-x^2)arcsin x "d"x &= integral t cos^2 t "d"t\
&= integral t (frac(1+cos 2t,2))"d"t\
&= 1/4 arcsin^2 x + 1/2 x arcsin x sqrt(1-x^2) - 1/4 x^2 + C
$

#prob-box([求不定积分$ integral frac(arccos x, sqrt((1-x^2)^3))"d"x $], label:<ex:4.1.50>)

令$t= arccos x, x= cos t, "d"x = - sin t"d"t$

$
integral frac(arccos x, sqrt((1-x^2)^3))"d"x &= - integral frac(t,sin^2 t)"d"t\
&= - integral t csc^2 t "d"t = integral t "d"(cot t)\
&= t cot t - integral cot t "d"t\
&= t cot t - ln abs(sin t)\
&= frac(x arccos x, sqrt(1-x^2)) - ln sqrt(1-x^2) + C  
$

#star-prob-box[求不定积分$ integral frac(arcsin x,x^2) dot frac(1+x^2,sqrt(1-x^2))"d"x $]

$
integral frac(arcsin x,x^2) dot frac(1+x^2,sqrt(1-x^2))"d"x &= integral arcsin x dot frac(1+x^2,x^2sqrt(1-x^2))"d"x\
&= integral frac(arcsin x, x^2sqrt(1-x^2))"d"x + integral frac(arcsin x,sqrt(1-x^2))"d"x\
&stretch(=)^(t=arcsin x)_("d"x = cos t"d"t) integral  frac(t,sin^2 t)"d"t + integral arcsin x "d"(arcsin x)\
&= integral t csc^2 t "d"t + 1/2 arcsin^2 x\
&= - frac(arcsin x sqrt(1-x^2),x) + ln abs(x) + 1/2 arcsin^2 x + C
$

$display(integral t csc^2 t) $的解法参见文档 @ex:4.1.50

#prob-box[求不定积分$ integral frac(x^3 arccos x,sqrt(1-x^2))"d"x $]

本题使用到的积分表:

#rect($
integral sin^3 x"d"x =- cos x + 1/3 cos^3 x + C\
integral cos^3 x"d"x = sin x - 1/3 sin^3 x + C
$)


令$t=arccos x, cos t =x, "d"x=-sin t"d"t$

$
integral frac(x^3 arccos x,sqrt(1-x^2))"d"x &= - integral t cos^3 t "d"t\
&= -integral t cos t (1- sin^2 t)dif t\
&= - integral t "d"(sin t - 1/3 sin^3 t)\
&= - lr([t sin t - 1/3 t sin^3 t - integral (sin t - 1/3 sin^3 t)"d"t])\
&= arccos x lr([1/3 (sqrt(1-x^2))^3 - sqrt(1-x^2)]) - 2/3 x - 1/9 x^3 + C
$

#prob-box[求不定积分$ integral (x^2-1)^3"d"x $]

$
integral (x^2-1)^3"d"x &= integral (x^2)^3 - 3 x^4 + 3 x^2 - 1\
&= 1/7 x^7 - 3/5 x^5 + x^3 -x + C
$

#twostar-prob-box[求不定积分$ integral frac(1,root(3,(x-1)^2(x+1)^4)) $]

// 原式可化为

// $
//  integral frac(1,(x-1)^frac(2,3)(x+1)^frac(4,3))"d"x = integral (x-1)^(-frac(2,3))(x+1)^(-frac(4,3))"d"x
// $

注意到

$
"d"(frac(root(3,x-1),root(3,x+1))) = 2/3 (x-1)^(-frac(2,3)) (x+1)^(-frac(4,3))"d"x
$

于是原式

$
integral frac(1,root(3,(x-1)^2(x+1)^4))"d"x &= integral (x-1)^(-frac(2,3))(x+1)^(-frac(4,3))"d"x\
&= 3/2 integral "d"(frac(root(3,x-1),root(3,x+1)))\
&= 3/2 frac(root(3,x-1),root(3,x+1)) + C
$

#prob-box([求不定积分$ integral frac(x^4,1+x^2)"d"x $], label: <ex:4.1.55>)

$
integral frac(x^4,1+x^2)"d"x &= integral frac(x^4-1+1,1+x^2)"d"x\
&= 1/3 x^3 - x + arctan x + C
$


#prob-box[求不定积分$ integral sqrt(frac(1-x,1+x))"d"x $]

$
integral sqrt(frac(1-x,1+x))"d"x &= integral sqrt(frac((1-x)^2,(1+x)(1-x)))"d"x\
&= integral frac(1-x,sqrt(1-x^2))"d"x\
&= arcsin x + sqrt(1-x^2) + C
$

#prob-box[求不定积分$ integral frac(3x^4+2x^2,x^2+1)"d"x $]

根据 @ex:4.1.55, 有积分表

#rect($
&integral frac(x^4,1+x^2)"d"x = 1/3 x^3 - x + arctan x +C\
&integral frac(x^2,1+ x^2)"d"x = x -arctan x + C
$)

$
integral frac(3x^4+2x^2,x^2+1)"d"x &= 3 integral frac(x^4,x^2+1)"d"x + 2 integral frac(x^2,x^2+1)"d"x\
&= x^3 - x + arctan x + C
$

#prob-box[求不定积分$ integral frac(1+2x^2,x^2(1+x^2))"d"x $]

$
integral frac(1+2x^2,x^2(1+x^2))"d"x &= integral frac((1+x^2)+x^2,x^2(1+x^2))"d"x\
&= integral 1/x^2"d"x + integral frac(1,1+x^2)"d"x\
&= - 1/x + arctan x + C
$

#prob-box[求不定积分$ integral frac(sqrt(1+x^2)+sqrt(1-x^2),sqrt(1-x^4))"d"x $]

$
integral frac(sqrt(1+x^2)+sqrt(1-x^2),sqrt(1-x^4))"d"x &= integral frac(sqrt(1+x^2),sqrt((1+x^2)(1-x^2))) + frac(sqrt(1-x^2),sqrt((1+x^2)(1-x^2)))\
&= integral frac(1,sqrt(1-x^2))"d"x + integral frac(1,sqrt(1+x^2))"d"x\
&= arcsin x + ln (sqrt(1+x^2)+x) + C
$

#prob-box[求不定积分$ integral 2^x"e"^x"d"x $]

根据积分表

#rect($
integral a^x "d"x = frac(a^x,ln a) + C
$)

$
 integral 2^x"e"^x"d"x &= integral (2"e")^x"d"x &= frac((2"e")^x,ln(2"e")) &= frac((2"e")^x,ln 2+1) + C
$

#prob-box[求不定积分$ integral frac("e"^(3x)+1,"e"^x+1)"d"x $]

$
integral frac("e"^(3x)+1,"e"^x+1)"d"x &= integral frac(("e"^x+1)("e"^(2x)-"e"^x+1),"e"^x+1)"d"x\
&= 1/2 "e"^(2x) - "e"^x +x +C
$

#prob-box[求不定积分$ integral frac("d"x,x sqrt(1+x^2))"d"x $]

(法一)第二类换元法, 令$x= tan theta, "d"x = sec^2 theta "d"theta$

$
integral frac("d"x,x sqrt(1+x^2))"d"x &= integral csc theta "d"theta \
&= -ln abs(frac(sqrt(x^2+1)+1,x)) + C
$

(法二)

$
integral frac("d"x,x sqrt(1+x^2))"d"x &= integral frac(dif x, x^2 sqrt(1/x^2+1))\
&= - integral frac(dif (1/x), sqrt((1/x)^2+1))\
&= -ln abs(frac(sqrt(x^2+1)+1,x)) + C
$

#prob-box[求不定积分$ integral (2^x+3^x)^2"d"x $]

注意运算律

#rect($
a^x dot b^x = (a b)^x
$)

$
integral (2^x+3^x)^2"d"x &= integral 2^(2x) + 3^(2x) + 2 dot 2^x dot 3^x "d"x \
&= integral 4^x + 9^x + 2 dot 6^x "d"x\
&= frac(4^x,ln 4) + frac(9^x, ln 9) + 2 dot frac(6^x, ln 6) +C
$

#prob-box[求不定积分$  integral max lr({1,x^2,x^3})"d"x $]

分段函数不定积分. 

$
integral max lr({1,x^2,x^3})"d"x &= integral cases(
  x^2\, & x< -1,
  1\, & -1 <=  x < 1,
  x^3\, & x>= 1
)\
&= cases(
  1/3 x^3 + C_1\, & x< -1,
  x+C\, & -1<= x < 1,
  1/4 x^4 + C_3\, & x>= 1
)
$

根据原函数连续定理(定理4.3)可知

$
cases(
  -1/3 + C_1 = -1 + C,
  1/4 + C_3 = 1 + C
)
$

解得$C_1=-2/3 +C, C_3=3/4 + C$

故答案为

$
cases(
  1/3 x^3 - 2/3 + C\, & x< -1,
  x+C\, & -1<= x < 1,
  1/4 x^4 + 3/4+C\, & x>= 1
)
$


#star-prob-box([求不定积分$ integral sqrt(1+cos 2x)"d"x $], label: <ex:4.1.65>)

在本题中, $k in ZZ$ 

// #grid(
//   columns: (40%, 60%),
//   gutter: 1.5em,

$
integral sqrt(1+cos 2x)"d"x &= integral sqrt(2 cos^2 x)"d"x\
&= sqrt(2) integral abs(cos x)"d"x\
&= cases(
  display(sqrt(2)integral cos x + A_k\, & x in lr([2k pi - pi/2 , 2k pi + pi/2])) ,
  display(-sqrt(2) integral cos x + B_k\, & x in (2k pi + pi/2, 2k pi + frac(3 pi,2))) 
)\
&= cases(
  display(sqrt(2)sin x + A_k\, & x in lr([2k pi - pi/2 , 2k pi + pi/2])) ,
  display(-sqrt(2)sin x + B_k\, & x in (2k pi + pi/2, 2k pi + frac(3 pi,2))) 
)
$

这个积分有两类拼接点, 第一个是$A_k$和$B_k$($2k pi + pi/2$), 第二个是$A_k$和$A_(k+1)$($2k pi - pi/2, 2k pi + frac(3 pi,2)$). 则有

$
cases(
  display(sqrt(2) sin(2k pi + pi/2)+A_k=-sqrt(2)sin(2k pi + pi/2)+B_k),
  display(-sqrt(2)sin(2k pi + frac(3 pi,2))+B_k=sqrt(2)sin (2k pi - pi/2)+A_(k+1)) 
)
$

解得$B_k=A_k+2sqrt(2)$, $A_(k+1)=B_k+2sqrt(2)$. 即$A_(k+1)=A_k+4sqrt(2)$, 所以$A_k=4 sqrt(2)+C$

所以最终答案为:

$
integral sqrt(1+cos 2x)"d"x &= cases(
  display(sqrt(2)sin x + 4k sqrt(2) + C\, & x in lr([2k pi - pi/2 , 2k pi + pi/2])) ,
  display(-sqrt(2)sin x + 4k sqrt(2) + 2sqrt(2) + C\, & x in (2k pi + pi/2, 2k pi + frac(3 pi,2))))
$

//由 @fig-increaseabs 得, 

#grid(
  columns: (50%, 50%),
  gutter: 1.5em,

[
#figure(
image("Geogebra/ex4.1.65-01.png", width: 100%),
caption: [不断增长的绝对值函数积分]
)
],

[
#figure(
image("Geogebra/ex4.1.65-02.png", width: 100%),
caption: [两个$2sqrt(2)$的由来]
)
]

)

为什么周期函数$sin x$不需要加复杂的常数, 而$abs(cos x)$就需要呢? 这是因为$sin x$的净面积为零.

#grid(
  columns: (50%, 50%),
  gutter: 1.5em,

[
  #figure(
    image("Geogebra/ex4.1.65-03.png"),
    caption: [月光族]
  )
],

[
  #figure(
    image("Geogebra/ex4.1.65-04.png"),
    caption: [貔貅]
  )
]
)


#star-prob-box[求不定积分$ integral sqrt(1-sin 2x)"d"x $]

在本题中, $k in ZZ$ 

$
integral sqrt(1-sin 2x)"d"x &= integral sqrt(sin^2 x+cos^2 x - 2 sin x cos x)"d"x\
&= integral abs(sin x - cos x)"d"x\
&= sqrt(2)integral abs(sin(x-pi/4))"d"x\
&= cases(
  display(sqrt(2)integral sin(x-pi/4)"d"x\, & x in lr([2k pi + pi/4, (2k+1)pi + pi/4])) ,
  display(-sqrt(2) integral sin (x-pi/4)"d"x\, & x in ((2k+1)pi+pi/4, (2k+2)pi+pi/4))
)\
&= cases(
  display(-sqrt(2) cos(x-pi/4) + A_k\, & x in lr([2k pi +pi/4, (2k+1)pi +pi/4])),
  display(sqrt(2)cos(x-pi/4)+ B_k\, & x in ((2k+1)pi+pi/4, (2k+2)pi+pi/4))
)
$

根据原函数存在定理, 再根据 @ex:4.1.55, 解得$B_k = A_k + 2sqrt(2) ,A_(k+1)=A_k + 4sqrt(2)$

故答案为

$
integral sqrt(1-sin 2x)"d"x = cases(
  display(-sqrt(2) cos(x-pi/4) + 4sqrt(2)k + C\, & x in lr([2k pi + pi/4, (2k+1)pi + pi/4])),
  display(sqrt(2)cos(x-pi/4)+ 4sqrt(2)k + 2sqrt(2) + C\, & x in ((2k+1)pi+pi/4, (2k+2)pi+pi/4))
)
$


#prob-box[求不定积分$ integral tan^2 x dif x $]

$
integral tan^2 x dif x = integral (sec^2 x - 1)dif x = tan x - x + C
$

#prob-box[求不定积分$ integral cot^2 x dif x $]

$
integral cot^2 x dif x = integral (csc^2 x - 1)dif x = - cot x - x + C
$

#prob-box[求不定积分$ integral frac(1,16-x^4)dif x $]

(法一)有理函数积分通法

$
integral frac(1,16-x^4)dif x &= integral frac(1,(x^2+4)(2+x)(2-x))dif x\
&= integral frac(A x+B,x^2+4)+frac(C,2+x)+frac(D,2-x)dif x\
$

使用系数比较法, 解线性方程组, 解得$A=0,B=1/8,C=1/32,D=1/32$, 所以有

$
integral frac(1,16-x^4)dif x = 1/16 arctan x/2 + 1/32 ln abs(frac(2+x,2-x)) + C
$

(法二)积分表法

$
integral frac(1,16-x^4)dif x &= integral frac(A,4-x^2) + frac(B,4+x^2) dif x\
&= 1/8 integral frac(1,4-x^2) + frac(1,4+x^2) dif x\
&= 1/16 arctan x/2 + 1/32 ln abs(frac(2+x,2-x)) + C
$

#prob-box[求不定积分$ integral frac(ln tan x,cos x sin x)dif x $]

注意到

#rect(
$ (ln tan x)' = frac(1,cos x sin x) $)

所以$ integral frac(ln tan x,cos x sin x)dif x = integral ln tan x dif(ln tan x) = 1/2 (ln tan x)^2 + C $

#prob-box[求不定积分$ integral frac(dif x, x+ sqrt(1-x^2)) $]

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
] <con:linear_sin_integral>

使用第二换元法, 令$x=sin t, dif x = cos t dif t$, 于是有

$
integral frac(dif x, x+ sqrt(1-x^2)) &= integral frac(cos t dif t, sin t + cos t)\
$

使用 @con:linear_sin_integral , 我们有$display(cos t = A(sin t + cos t)+B(sin t+cos t)')$, 解得$A=B=1/2$

所以有

$
integral frac(dif x, x+ sqrt(1-x^2)) &= 1/2 t + 1/2 ln abs(sin t + cos t) + C\
&= 1/2 arcsin x + 1/2 ln abs(x+sqrt(1-x^2)) + C
$

#prob-box[求不定积分$ integral frac(2 sin x + 3 cos x,5 sin x + 7 cos x)dif x $]

使用 @con:linear_sin_integral 解得$A=31/74, B=1/74$, 于是有

$
 integral frac(2 sin x + 3 cos x,5 sin x + 7 cos x)dif x &= 31/74 x + 1/74 ln abs(5 sin x + 7 cos x) + C 
$


#prob-box[求不定积分$ integral frac((arctan sqrt(x))^2,sqrt(x)(1+x)) dif x $]

注意到$ (arctan sqrt(x))' = frac(1,2sqrt(x)(1+x)) $

所以有$ integral frac((arctan sqrt(x))^2,sqrt(x)(1+x)) dif x &= 2 integral (arctan sqrt(x))^2 dif (arctan sqrt(x)) \
&= 2/3 (arctan sqrt(x))^3 + C
$

#prob-box[求不定积分$ integral frac(x^2,(1+x^2)^2)dif x $]

令$x=tan t, dif x = sec^2 t dif t$

$
integral frac(x^2,(1+x^2)^2)dif x &= integral sin^2 dif t\
&= 1/2 t - 1/2 sin t cos t\
&= 1/2 arctan x - 1/2 frac(x,1+x^2) + C 
$


#prob-box[求不定积分$ integral frac(1,(1+"e"^x)^2)dif x $]

$
integral frac(1,(1+"e"^x)^2)dif x &= integral frac(1,"e"^x (1+"e"^x)^2) dif("e"^x)\
&= integral frac(1 + "e"^x - "e"^x ,"e"^x (1+"e"^x)^2) dif("e"^x)\
&= integral frac(1,"e"^x (1+"e"^x))dif "e"^x - integral frac(1,(1+"e"^x)^2)dif (1+"e"^x)\
&= x - ln(1+"e"^x) + frac(1,1+"e"^x) + C
$

#prob-box[求不定积分$ integral frac(sin x cos x,1+sin^4 x)dif x $]

设$u=sin^2 x, dif u = 2 sin x cos x dif x, dif x = display(frac(dif u, 2 sin x cos x))$

$
integral frac(sin x cos x,1+sin^4 x)dif x &= integral frac(1, 1+u^2) dot  frac(dif u,2) = 1/2 arctan(sin^2 x)+C
$

#prob-box[求不定积分$ integral frac(dif x,x(x^6+4)) $]

$
integral frac(dif x,x(x^6+4)) &= integral frac(x^5 dif x,x^6(x^6+4))\
&stretch(=)^(u=x^6) integral frac(x^5 dot frac(dif u,6x^5),u(u+4))\
&= 1/24 integral lr([1/u - frac(1,u+4)])dif u\
&= 1/24 lr([ln x^6 - ln(x^6+4)])+C
$

#prob-box[求不定积分$ integral frac(dif x, sin 2x + 2 sin x) $]

用万能代换,

$
integral frac(dif x, sin 2x + 2 sin x) &= integral frac(frac(1,1+u^2)dif u ,frac(2u,u^2+1) dot frac(1-u^2,1+u^2)+frac(2u,u^2+1))\
&= integral frac(1+u^2,4u) dif u\
&= 1/4 ln lr(|tan x/2|) + 1/8 tan^2 x/2 + C
$

#prob-box[求不定积分$ integral frac(ln(sin x), sin^2 x)dif x $]

$
integral frac(ln(sin x), sin^2 x)dif x &= - integral ln sin x dif (cot x)\
&= -ln sin x cot x - cot x - x + C
$


#prob-box[求不定积分 $ integral frac(1,x^3+1)dif x $]

有理函数不定积分

$
integral frac(1,x^3+1)dif x &= integral frac(1,(1-x)(x^2-x+1))dif x\
&= 1/3 ln abs(1+x) - 1/3 integral frac(x-2,x^2-x+1)dif x\
&= 1/3 ln abs(1+x) - 1/3 integral frac(x-1/2+3/2,x^2-x+1)dif x\
&= 1/3 ln |1+x| - 1/3 lr([1/2 integral frac(dif(x^2-x+1),x^2-x+1)+3/2 integral frac(1,x^2-x+1)dif x])\
&= 1/3 ln abs(1+x) - 1/6 ln(x^2-x+1) + frac(sqrt(3),3)arctan frac(2sqrt(3)(x-1/2),3) + C
$

#prob-box[求不定积分 $ integral frac(x, x^3-1)dif x $ ]

设$display(integral frac(x, x^3-1)dif x = integral frac(A,1-x) + frac(B x+C,x^2-x+1))$, 解得$A=1/3,B=-1/3,C=1/3$

$
integral frac(x, x^3-1)dif x &= 1/3 ln abs(x-1) - 1/3 integral frac(x-1,x^2+x+1)dif x\
&= 1/3 ln abs(x-1) - 1/3 integral frac(x+1/2-3/2,x^2+x+1)dif x\
&= 1/3 ln abs(x-1) - 1/3 lr([1/2 integral frac(dif(x^2+x+1),x^2+x+1)-3/2 integral frac(1,(x+1/2)^2+(sqrt(3)/2)^2)dif x])\
&= 1/3 ln abs(x-1)-1/6 ln(x^2+x+1) + sqrt(3)/3 arctan frac(2sqrt(3)(x+1/2),3) + C
$


#prob-box([求不定积分 $ integral frac(1,x^4+1)dif x $], label: <ex:4.1.82>)

$
integral frac(1,x^4+1)dif x &= 1/2 lr([ integral frac(x^2+1,x^4+1)dif x - integral frac(x^2-1,x^4+1)dif x])\
&=1/2 lr([ integral  frac(frac(1, x^(2))+1, x^(2)+frac(1, x^(2)))dif x+integral  frac(frac(1, x^(2))-1, x^(2)+frac(1, x^(2)))dif x ])\
&=1/2[ integral  frac(dif( x-1/x ), ( x-1/x ) ^(2)+2)-integral  frac(dif( x+1/x ), ( x+1/x ) ^(2)-2) ]\
&=frac(1,2sqrt(2))arctan frac(x-1/x,sqrt(2))-frac(1,4sqrt(2))ln(frac(x+1/x-sqrt(2),x+1/x+sqrt(2)))+C
$

#prob-box[求不定积分 $ integral sqrt(frac(1-x,1+x))frac(dif x,x) $]

$
integral sqrt(frac(1-x,1+x))frac(dif x,x) &= integral frac(1-x,x sqrt(1-x^2))dif x\
&= - integral frac(dif (1/x),sqrt((1/x)^2-1)) - integral frac(1,sqrt(1-x^2))dif x\
&= - ln abs(1/x + sqrt(1/x^2-1)) - arcsin x + C
$

#prob-box[求不定积分 $ integral frac(1,x^4(1+x^2)) dif x $]

分子需要进行代数恒等变换, 技巧是"括号外的幂与括号内的幂的差值"(本题为$4 - 2 = 2$)

$
integral frac(1,x^4(1+x^2)) dif x &= integral frac(1+x^2-x^2,x^4(1+x^2))dif x\
&= integral 1/x^4 - (1/x^2 - frac(1,1+x^2))dif x\
&= -frac(1,3x^3) + 1/x + arctan x + C
$

#prob-box[求不定积分 $ integral frac(1,x(1+x^4)) dif x $]

$
integral frac(1,x(1+x^4)) dif x  &= integral frac(x^3,x^4(1+x^4))dif x\
&= 1/4 integral frac(dif x^4,x^4(1+x^4))\
&= 1/4 ln frac(x^4,1+x^4) + C
$

#prob-box[求不定积分 $ integral x "e"^x cos x dif x $]

注意到: $ (1/2 "e"^x (sin x + cos x))' = "e"^x cos x $

所以

$
integral x "e"^x cos x dif x &= 1/2 integral x dif("e"^x sin x + "e"^x cos x)\
&= 1/2 lr([x"(e"^x sin x + "e"^x cos x)- integral "e"^x sin x dif x + integral "e"^x cos x dif x])\
&= 1/2 lr([x"(e"^x sin x + "e"^x cos x)- 1/2 ("e"^x cos x + "e"^x sin x)- 1/2 ("e"^x sin x - "e"^x cos x) ])\
&= 1/2 lr([x"(e"^x sin x + "e"^x cos x)-"e"^x sin x]) + C 
$

#prob-box([求不定积分 $ integral cos ln x dif x $], label:<ex:4.1.87> )

(法一): 换元法

令$t=ln x, x= "e"^t, dif x = "e"^t dif t$, 则

$
integral cos ln x dif x &= integral "e"^t cos t dif t \
&= 1/2 (x cos ln x + x sin ln x) + C
$

(法二): 分部积分法

$
integral cos ln x dif x &= x cos ln x + integral x sin ln x 1/x dif x\
&= x cos ln x + x sin ln x - integral cos ln x dif x\
&= 1/2 (x cos ln x + x sin ln x) + C
$

#prob-box[求不定积分 $ integral sin ln x dif x $]

解题方法与 @ex:4.1.87 完全相同, 答案是 $display(1/2(x sin ln x - x cos ln x)+C)$

#prob-box[求不定积分 $ integral "e"^x sin^2 x dif x $]

$
integral "e"^x sin^2 x dif x &= 1/2 integral "e"^x (1-cos 2x)dif x\
&= 1/2 (integral "e"^x dif x - integral "e"^x cos 2x dif x)\
&= 1 / 2 "e"^x - 1 / 10 ("e"^x cos 2 x + 2 "e"^x sin 2 x) + C 
$

#prob-box[求不定积分 $ integral x^n ln x dif x $]

(法一)
$
integral x^n ln x dif x &= frac(1,n+1) integral ln x dif (x^(n+1))\
&= frac(1,n+1)(x^(n+1)ln x - frac(1,n+1)x^(n+1)) + C 
$

(法二)令$ln x = t$

$
integral x^n ln x dif x  &= integral t "e"^n(t+1) dif t\
&= frac(t,n+1)"e"^((n+1)t) - frac(1,(n+1)^2)"e"^((n+1)t)\
&= frac(1,n+1)x^(n+1)ln x - frac(1,(n+1)^2)x^(n+1) + C
$

#prob-box[求不定积分 $ integral x ln frac(1+x,1-x)dif x $]

$
integral x ln frac(1+x,1-x)dif x &= 1/2 integral ln frac(1+x,1-x)dif(x^2)\
&= 1/2 [ x^2 ln frac(1+x,1-x) + 2 integral frac(1-x^2-1,1-x^2)dif x]\
&= 1/2 x^2 ln frac(1+x,1-x) + x - 1/2 ln abs(frac(1+x,1-x)) + C
$

#prob-box[求不定积分 $ integral arctan sqrt(x)dif x $]

令$t=sqrt(x)$

$
integral arctan sqrt(x)dif x &= integral arctan t dif(t^2)\
&= x arctan sqrt(x) + arctan sqrt(x) - sqrt(x) + C
$

#prob-box[求不定积分 $ integral x^2 ln frac(1-x,1+x)dif x $]

$
integral x^2 ln frac(1-x,1+x)dif x &= 1/3 integral ln frac(1-x,1+x)dif (x^3)\
&= 1/3 (x^3 ln frac(1-x,1+x) - x^2 - ln abs(x^2-1) ) + C
$

#prob-box[求不定积分 $ integral frac(x ln(x+sqrt(1+x^2)), sqrt(1+x^2))dif x $]

注意到 $ (sqrt(1+x^2))' = frac(x,sqrt(1+x^2)) $

$
integral frac(x ln(x+sqrt(1+x^2)), sqrt(1+x^2))dif x &= integral ln(x+sqrt(1+x^2)) dif (sqrt(1+x^2))\
&= sqrt(1 + x^2) ln (x + sqrt(1 + x^2)) - x + C
$

#prob-box([求不定积分 $ integral frac(1,(1+x^2)^2)dif x $],label: <ex:4.1.95>)

令$x= tan t, dif x = sec^2 t dif t$

$
integral frac(1,(1+x^2)^2)dif x &= integral cos^2 t dif t \
&= 1/2 arctan x + 1/2 frac(x,1+x^2) + C
$

#prob-box[求不定积分$ integral arctan(x^2) dif x $]

$
integral arctan(x^2) dif x &= x arctan x^2 - 2 integral frac(x^2,1+x^4)dif x\
&= x arctan x^2 - 2 integral frac(x^2+1+x^2-1,1+x^4)dif x
$

然后利用 @ex:4.1.82 的结论即可, 答案是$ integral arctan(x^2) dif x = x arctan (x^2) - 1 / sqrt(2) arctan frac(x - 1 / x, sqrt(2)) - frac(1, 2 sqrt(2)) ln (frac(x + 1 / x - sqrt(2), x + 1 / x + sqrt(2))) + C $

#prob-box([求不定积分$ integral frac("e"^(arctan x), (1+x^2)^(3/2))dif x $], label: <ex:4.1.97>)

令$x=tan t, dif x = sec^2 t dif t$

$
integral frac("e"^(arctan x), (1+x^2)^(3/2))dif x &= integral "e"^t cos t dif t\
&= 1/2 "e"^(arctan x) frac(1+x,sqrt(1+x^2))+C
$

#prob-box[求不定积分$ integral "e"^(2x) sin^2 x dif x $]

$
integral "e"^(2x) sin^2 x dif x &= integral "e"^(2x) (1-cos 2x)dif x\
&= 1 / 4 "e"^(2 x) - 1 / 8 ("e"^(2 x) cos 2 x + "e"^(2 x) sin 2 x) + C 
$

#prob-box[求不定积分$ integral frac(arctan "e"^x, "e"^x)dif x $]

注意到$("e"^(-x))'=-"e"^(-x)$

$
integral frac(arctan "e"^x, "e"^x)dif x &= - integral arctan "e"^x dif ("e"^(-x))\
&= - frac(arctan "e"^x, "e"^x) + x - 1/2 ln(1+"e"^(2x)) + C
$

#prob-box[求不定积分$ integral frac(x"e"^x,(x+1)^2)dif x $]

注意到$display((frac(1,x+1))' = - frac(1,(x+1)^2))$

$
integral frac(x"e"^x,(x+1)^2)dif x &= - integral x "e"^x dif frac(1,x+1)\
&= - frac(x "e"^x,x+1) + "e"^x + C
$

#prob-box[求不定积分 $ integral frac(arctan x,x^2(1+x^2))dif x $]

$
integral frac(arctan x,x^2(1+x^2))dif x &= integral arctan (1/x^2 - frac(1,1+x^2)) dif x \
&= - integral arctan x dif 1/x - integral arctan x dif (arctan x)\
&= - frac(arctan x, x) + 1/2 ln frac(x^2,1+x^2) - 1/2 arctan^2 x + C
$

#prob-box[求不定积分 $ integral "e"^(2x)(tan x+1)^2 dif x $ ]
 
$
integral "e"^(2x)(tan x+1)^2 dif x &= integral "e"^(2x)(tan^2 x+1+2tan x)dif x\
&= integral "e"^(2x)(tan^2 x + 1)dif x + 2 integral "e"^(2x) tan x dif x\
&= integral "e"^(2x)dif tan x + 2 integral "e"^(2x) tan x dif x\
&= "e"^(2x) tan x - 2 integral "e"^(2x)tan x + 2 integral "e"^(2x) tan x dif x\
&= "e"^(2x) tan x + C
$

#prob-box[求不定积分$ integral frac(arctan "e"^x, "e"^(2x))dif x $]

$
integral frac(arctan "e"^x, "e"^(2x))dif x &= -1/2 integral arctan "e"^x dif ("e"^(-2x))\
&= - 1/2 (frac(arctan "e"^x, "e"^(2x)) + 1/"e"^x + arctan "e"^x) + C
$

#prob-box[求不定积分$ integral frac(1,"e"^x + "e"^(-x))dif x $]

$
integral frac(1,"e"^x + "e"^(-x))dif x &= integral frac(1, "e"^(-x)("e"^(2x)-1))dif x\
&= frac(1,"e"^(2x)+1)dif x = arctan "e"^x + C 
$

#prob-box[求不定积分$ integral frac(1,sqrt(x(1+x)))dif x $]

$
integral frac(1,sqrt(x(1+x)))dif x = 2 integral frac(1,sqrt(1^2+(sqrt(x))^2))dif sqrt(x) = 2 ln (sqrt(x)+sqrt(1+x))+C
$

#prob-box[求不定积分$ integral frac(dif x, sqrt((x^2+a^2)^3)) $]

第二换元法, 令$x= a tan t, dif x = a sec^2 t dif t$

$ integral frac(dif x, sqrt((x^2+a^2)^3)) = 1/a^2 integral cos t = frac(x,a^2 sqrt(x^2+a^2)) + C $

#prob-box[求不定积分 $ integral frac(dif x, sqrt((x^2-a^2)^3)) $]

第二换元法, 令$x= a sec t, dif x = a sec t tan t dif t$

$ integral frac(dif x, sqrt((x^2-a^2)^3)) = -1/a^2 dot 1/(sin t) = - frac(x, a^2 sqrt(x^2-a^2))+C $ 

#prob-box[求不定积分 $ integral frac(sqrt(x^2-4),x)dif x $]

$
integral frac(sqrt(x^2-4),x)dif x &= integral frac(x^2-4,x sqrt(x^2-4))dif x\
&= integral frac(x,sqrt(x^2-4))dif x - 4 integral frac(1,x sqrt(x^2-4))dif x\
&= 1/2 integral frac(1,sqrt(x^2-4))dif x^2 - 4 times [-1/2 integral frac(1,sqrt(1^2-(2/x)^2))dif (2/x)]\
&= sqrt(x^2-4) + 2 arcsin 2/x + C
$

#prob-box[求不定积分 $ integral tan sqrt(1+x^2) frac(x,sqrt(1+x^2))dif x $]

注意到$display((1+x^2)' = frac(x,sqrt(1+x^2)))$

$
integral tan sqrt(1+x^2) frac(x,sqrt(1+x^2))dif x &= integral tan sqrt(1+x^2) dif(sqrt(1+x^2))\
&= - ln abs(cos sqrt(1+x^2)) + C
$

#star-prob-box[求不定积分 $ integral sqrt(frac(x,1-x sqrt(x)))dif x $]

$
integral sqrt(frac(x,1-x sqrt(x)))dif x &= integral frac(sqrt(x),sqrt(1-x^(3/2)))dif x\
&= - 2/3 integral frac(1,sqrt(1-x^(3/2)))dif (1-x^(3/2))\
&= - 4/3 sqrt(1-x^(3/2))+C
$

#star-prob-box[求不定积分 $ integral frac(x,sqrt(1+x^2+sqrt((1+x^2)^3)))dif x $]

$
integral frac(x,sqrt(1+x^2+sqrt((1+x^2)^3)))dif x &= integral frac(x,sqrt(1+x^2+(1+x^2)^(3/2)))dif x\
&= integral frac(x, sqrt(1+x^2)(1+sqrt(1+x^2)))dif x\
&= integral frac(1,sqrt(1+sqrt(1+x^2)))dif sqrt(1+x^2)\
&= 2 sqrt(1+sqrt(1+x^2))+C
$

#prob-box[求不定积分 $ integral frac(x^3+1,(x^2+1)^2)dif x $]

$
integral frac(x^3+1,(x^2+1)^2)dif x &= 1/2 integral frac(x^2,(x^2+1)^2)dif x^2 + integral frac(1,(x^2+1)^2)dif x\
&= I_1 + I_2
$

$
I_1 &= 1/2 integral [ integral frac(x^2+1,(x^2+1)^2)dif (x^2+1) - integral frac(1,(x^2+1)^2)dif (x^2+1) ]\
&= 1/2 [ln(x^2+1) + frac(1,x^2+1)] 
$

设$x=tan t, dif x = sec^2 t dif t$

$
I_2 = 1/2 (arctan x + frac(x,1+x^2) )
$
 
所以$ integral frac(x^3+1,(x^2+1)^2)dif x = 1/2 [ ln(x^2+1) + frac(x+1,x^2+1) + arctan x ]+C $

#prob-box[求不定积分$ integral frac(dif x, sqrt("e"^(2x)+1)) $]

$
integral frac(dif x, sqrt("e"^(2x)+1)) &= integral frac(dif x, "e"^x sqrt(1+frac(1,"e"^(2x))))\
&= - integral frac(dif(1/"e"^x),sqrt(1^2+(1/"e"^x)^2))\
&= - ln abs(frac(1,"e"^x)+sqrt(1+frac(1,"e"^(2x))))+C
$

#prob-box[求不定积分 $ integral sqrt(frac("e"^x-1,"e"^x+1))dif x $]

$
integral sqrt(frac("e"^x-1,"e"^x+1))dif x &= integral frac("e"^x-1,sqrt("e"^(2x)-1))\
&= integral frac("e"^x,sqrt("e"^(2x)-1))dif x - integral frac(1,sqrt("e"^(2x)-1))dif x\
&= ln ("e"^x+sqrt("e"^(2x)-1)) + arcsin frac(1,"e"^x) + C
$
 
#prob-box[求不定积分$ integral frac(1,"e"^x (1+"e"^(2x)))dif x $]

(法一)

$
integral frac(1,"e"^x (1+"e"^(2x)))dif x &= integral frac(1+"e"^(2x)-"e"^(2x),"e"^x (1+"e"^(2x)))dif x
&= -"e"^x - arctan "e"^x + C
$

(法二)

令$t = "e"^(-x)$

$
- integral frac(1,1+"e"^(2x))dif("e"^(-x)) &= - integral frac(1,1+frac(1,t^2))dif t\
&= - [ integral dif t - integral frac(1,1+t^2)dif t]\
&= -"e"^(-x) + arctan"e"^(-x) + C 
$

因为$arctan "e"^x + arctan "e"^(-x) = pi/2$, 两种方法的答案差了一个常数, 故两个答案都是正确的.

#prob-box[求不定积分 $ integral sqrt(1+"e"^(2x))dif x $]

(法一)

$
integral sqrt(1+"e"^(2x))dif x &= integral frac(1+"e"^(2x),sqrt(1+"e"^(2x))) dif x\
&= integral frac(1,sqrt(1+"e"^(2x)))dif x + 1/2 integral frac(1,sqrt(1+"e"^(2x)))dif "e"^(2x)\
&= - ln ("e"^(-x) + sqrt("e"^(-2x) + 1)) + sqrt(1+"e"^(2x)) + C
$

另一个答案是$sqrt(1 + "e"^(2 x)) + ln (sqrt(1 + "e"^(2 x)) - 1) - x + C$, 这也是正确的, 因为

$
- ln ("e"^(-x) + sqrt("e"^(-2x) + 1)) &= - ln ["e"^(-x)(1+sqrt(1+"e"^(2x)))]\
&= x - ln(1+sqrt(1+"e"^(2x))) 
$

然后构造共轭式, 注意到$(sqrt(1 + "e"^(2 x)) - 1)(sqrt(1 + "e"^(2 x)) + 1) = "e"^(2x)$, 所以$display(sqrt(1 + "e"^(2 x)) + 1 = frac("e"^(2x),sqrt(1+"e"^(2x))-1))$, 所以有

$
x - ln(1+sqrt(1+"e"^(2x))) &= x - ln (frac("e"^(2x),sqrt(1+"e"^(2x))-1))\
&= -x + ln(sqrt(1+"e"^(2x))-1)
$

这正是我们想要的结果.

(法二) 

令$"e"^x = t = tan u, dif t = sec^2 u dif u$

$
integral sqrt(1+"e"^(2x))dif x &= integral sqrt(frac(t^2+1,t^2))dif t\
&= frac(1,sin u cos^2 u)dif u\
&= frac(sin u, sin^2 u cos^2 u)dif u\
&= - integral frac(1,(1-cos^2 u)cos^2 u)dif cos u\
&= sec u - 1/2 ln abs(frac(1- cos u,1+ cos u))
$

注意到$display(tan^2 x/2 =  frac(1-cos x,1+cos x) = frac(sin^2 x,(1+cos x)^2))$

$
sec u - 1/2 ln abs(frac(1- cos u,1+ cos u)) &= sec u + 1/2 ln abs(frac(1+ cos u,1- cos u))\
&= sec u + ln abs(frac(sin u , 1+ cos u))\
&= sqrt(1+"e"^(2x)) + ln (frac("e"^x,sqrt(1+"e"^(2x))+1))\
&= sqrt(1+"e"^(2x)) + x - ln(sqrt(1+"e"^(2x))+1)
$

这正是(方法一)所得出的结果.

#prob-box([求不定积分 $ integral "e"^x sqrt(1+"e"^(2x))dif x $], label: <ex:4.1.117>)

(法一)根据积分表

#rect($ integral sqrt(a^2+x^2)dif x  = 1/2 [x sqrt(x^2+a^2) + a^2 ln (sqrt(x^2+a^2) + x)]+ C $)

$
integral "e"^x sqrt(1+"e"^(2x))dif x &= integral sqrt(1+"e"^(2x))dif "e"^x\
&= 1/2["e"^x sqrt("e"^(2x)+1) + ln (sqrt("e"^(2x)+1) + "e"^x) ]+C
$

(法二)分部积分法

$
integral "e"^x sqrt(1+"e"^(2x))dif x &= integral sqrt(1+"e"^(2x))dif "e"^x\
&= "e"^x sqrt(1+"e"^(2x)) - integral frac("e"^(2x),sqrt(1+"e"^(2x)))dif "e"^x\
&= "e"^x sqrt(1+"e"^(2x)) - integral sqrt(1+"e"^x)dif "e"^x + integral frac(1,sqrt(1+"e"^(2x)))dif "e"^x
$

所以

$
integral sqrt(1+"e"^(2x))dif "e"^x = 1/2["e"^x sqrt("e"^(2x)+1) + ln (sqrt("e"^(2x)+1) + "e"^x) ]+C
$

#prob-box[求不定积分 $ integral frac(dif x,sqrt("e"^x+1)) $]

令$t=sqrt("e"^x+1), x=ln(t^2-1), dif x = frac(2t,t^2-1)dif t$

$
integral frac(dif x,sqrt("e"^x+1)) &= 2 integral frac(1,t^2-1)dif x\
&= 2 ln (frac(sqrt("e"^x+1)-1,sqrt("e"^x+1)+1))+C
$

#star-prob-box[求不定积分 $ integral frac(2^x dot 3^x , 9^x + 4^x)dif x $]

分子分母同时除以$9^x$

$
integral frac(2^x dot 3^x , 9^x + 4^x)dif x &= integral frac((2/3)^x,1+(2/3)^(2x))dif x\
&= 1/ln(2/3) integral frac(1,1+(2/3)^(2x))dif (2/3)^x\
&= frac(1,ln 2 - ln 3)arctan(2/3)^x + C
$

#star-prob-box[求不定积分 $ integral frac(1+ln x,x^(-x)+x^x)dif x $]

分子分母同时除以$x^(-x)$

$
integral frac(1+ln x,x^(-x)+x^x)dif x = integral frac(x^x (1+ln x),1+(x^x)^2)dif x
$

注意到$(x^x)' = (1+ ln x)x^x$, 所以有

$
integral frac(x^x (1+ln x),1+(x^x)^2)dif x = integral frac(1,1+(x^x)^2)dif x^x = arctan x^x + C
$

#prob-box[求不定积分$ integral frac(sqrt(ln tan x), sin 2x)dif x $]

注意到$(ln tan x)' = frac(1, sin x cos x)$

$
integral frac(sqrt(ln tan x), sin 2x)dif x &= 1/2 integral sqrt(ln tan x)dif (ln tan x)\
&= 1/3 (ln tan x )^(3/2) + C
$

#prob-box[求不定积分 $ integral frac(dif x, x ln x ln(ln x)) $]

$
integral frac(dif x, x ln x ln(ln x)) = integral frac(dif ln (ln x), ln(ln x)) = ln abs(ln ln x)+C
$

#prob-box[求不定积分 $ integral frac((1+2x^2)"e"^x^2,2-3x"e"^x^2)dif x $]

注意到$(2-3x"e"^x^2)'=-3["e"^x^2(2x^2+1)]$

$
integral frac((1+2x^2)"e"^x^2,2-3x"e"^x^2)dif x &= -1/3 integral frac(1,2-3x"e"^x^2)dif (2-3x"e"^x^2)\
&= -1/3 ln abs(2-3x"e"^x^2)+C
$

#prob-box[求不定积分 $ integral frac(dif x,(a sin x + b cos x)^2) $]

$
integral frac(dif x,(a sin x + b cos x)^2) &= integral frac(dif x,cos^2 x(a tan x + b)^2)\
&= 1/a integral frac(dif a tan x,(a tan x + b)^2)\
&= - 1/a frac(1,a tan x + b) + C
$

#star-prob-box[求不定积分 $ integral frac(cos x + x sin x , (x+ cos x)^2)dif x $]

$ integral frac(cos x + x sin x , (x+ cos x)^2)dif x &=integral frac(cos+x sin x,cos^2 x(x sec x +1)^2)dif x\
&= integral frac(sec x + x sec^2 x sin x, (x sec x + 1)^2)dif x\
&= integral frac(sec x + x sec x tan x, (x sec x + 1)^2)dif x\
&= integral frac(1,(1+x sec x)^2)dif (1+x sec x)\
&= - frac(1, 1+ x sec x)+C 
$

另一个答案$display(frac(x,x + cos x)+C)$也是正确的, 这是因为二者相差常数:

$
- frac(1, 1+ x sec x)+C = - frac(x+cos x-x,x+cos x) + C = frac(x,x+cos x)-1 + C
$

#star-prob-box[求不定积分 $ integral frac(x+sin x cos x , (x sin x + cos x)^2)dif x $]

$
integral frac(x+sin x cos x , (x sin x + cos x)^2)dif x &= integral frac(x + sin x cos x,cos^2 x(x tan x +1)^2)dif x  \
&= integral frac(x sec^2 x + tan x,(x tan x +1)^2)dif x\
&= integral frac(1,(x tan x + 1)^2)dif (x tan x + 1)\
&= - frac(1,x tan x + 1) + C
$

#star-prob-box[求不定积分$ integral frac(1-ln x, (x- ln x)^2)dif x $]

分子分母同时除以$x^2$

$
integral frac(1-ln x, (x- ln x)^2)dif x = integral frac(frac(1-ln x,x^2),(1-frac(ln x,x))^2)dif x
$

注意到$display((frac(ln x,x))' = frac(1-ln x,x^2))$

$
integral frac(frac(1-ln x,x^2),(1-frac(ln x,x))^2)dif x = - integral frac(dif (1-frac(ln x,x)), (1-frac(ln x,x))^2) = frac(x, x-ln x)+C
$

#prob-box[求不定积分 $ integral frac(1+x,x(1+x"e"^x))dif x $]

注意到$(x"e"^x)' = "e"^x (1+x)$

$
integral frac(1+x,x(1+x"e"^x))dif x &= integral frac((1+x)"e"^x,x"e"^x (1+x"e"^x))dif x\
&= integral frac(dif (x"e"^x)',x"e"^x (1+x"e"^x))\
&= x + ln abs(frac(x,x"e"^x+1))+C
$

#star-prob-box[求不定积分 $ integral frac(ln x + 2, x ln x (1+ x ln^2 x))dif x $]

注意到$(x ln^2 x)' = ln^2 x + 2 ln x$, 分子分母同时乘以$ln x$

$
integral frac(ln x + 2, x ln x (1+ x ln^2 x))dif x &= integral frac(ln^2 x + 2ln x, x ln^2 x (1+ x ln^2 x))dif x\
&=integral frac(dif (x ln^2 x), x ln^2 x (1+x ln^2 x))\
&= ln abs(frac(x ln^2 x , x ln^2 x +1))+C
$

#star-prob-box[求不定积分 $ integral x ln (1+x^2)arctan x dif x $]

记$u= arctan x, dif v = x ln (1+x^2) dif x$

$
v = integral x ln(1+x^2) dif x &= 1/2 integral ln(1+x^2)dif (x^2+1)\
&= 1/2 [(1+x^2)ln(1+x^2) - (1+x^2)] + C_1
$

$
& I = integral x ln (1+x^2)arctan x dif x = integral u dif v \
&= 1/2 arctan x [(1+x^2)ln(1+x^2) - (1+x^2)] - 1/2 integral [ ln(1+x^2)-1]dif x\
$

因为

$
integral ln(1+x^2) dif x &= x ln(1+x^2) - 2 integral frac(x^2,1+x^2)dif x
$

所以

$
I = 1/2 arctan x (1+x^2)ln(1+x^2) - 3/2 arctan x - 1/2 x^2 arctan x - 1/2 x (1+x^2) + 3/2 x + C
$

#prob-box[求不定积分 $ integral sqrt((x^2+x)"e"^x)(x^2+3x+1)"e"^x  dif x $]

注意到$display([(x^2+x)"e"^x)]' = (x^2+3x+1)"e"^x )$

$
integral sqrt((x^2+x)"e"^x)(x^2+3x+1)"e"^x  dif x &= integral sqrt((x^2+x)"e"^x) dif [(x^2+x)"e"^x]\
&= 2/3 [(x^2+x)"e"^x]^(3/2) + C
$

#star-prob-box[求不定积分 $ integral {frac(f(x),f'(x)) - frac(f^2(x)f''(x),[f'(x)]^3)}dif x $]

$
I = integral {frac(f(x),f'(x)) - frac(f^2(x)f''(x),[f'(x)]^3)}dif x &= integral frac(f(x),f'(x)){1- frac(f(x)f''(x),[f'(x)]^2)} dif x\
&= integral frac(f(x),f'(x)){frac( [f'(x)]^2 -  f(x)f''(x),[f'(x)]^2)} dif x
$

注意到

$
[frac(f(x),f'(x))]' = frac( [f'(x)]^2 -  f(x)f''(x),[f'(x)]^2)
$

所以

$
I = frac(f(x),f'(x)) dif [frac(f(x),f'(x))] = 1/2 [frac(f(x),f'(x))]^2 + C
$

#star-prob-box[求不定积分 $ integral frac(arcsin(1-x), sqrt(2x-x^2))dif x $]

注意到

$
[arcsin(1-x)]' = - frac(1,sqrt(2x-x^2))
$

所以

$
integral frac(arcsin(1-x), sqrt(2x-x^2))dif x &= - integral arcsin(1-x)dif arcsin(1-x)\
&= - 1/2 arcsin^2(1-x)  + C
$

#prob-box[求不定积分 $ integral tan^3 x sec x dif x $]

$
integral tan^3 x sec x dif x &= integral tan^2 x dif sec x\
&= 1/3 sec^3 x - sec x + C
$

#prob-box[求不定积分 $ integral sin^2 x cos^3 x dif x $]

$
integral sin^2 x cos^3 x dif x &= integral sin^2 x (1- sin^2 x)dif sin x\
&= 1/3 sin^3 x - 1/5 sin^5 x + C
$

#prob-box[求不定积分 $ integral sin 5x sin 7x dif x $]

根据积化和差公式$display(sin alpha sin beta = frac(cos (alpha - beta) - cos (alpha + beta), 2))$

$
integral sin 5x sin 7x dif x &= 1/2 integral [cos 2x - cos 12x]dif x\
&= 1/4 sin 2x - 1/24 sin 12x + C
$

#prob-box[求不定积分 $ integral frac(cot x, sqrt(sin x))dif x $]

$
integral frac(cot x, sqrt(sin x))dif x = integral frac(1,(sin x)^(3/2))dif sin x = - frac(2, sqrt(sin x))+C
$

#prob-box[求不定积分 $ integral sec^4 x dif x $]

$
integral sec^4 dif x = integral (tan^2 x + 1) dif tan x = 1/3 tan^3 x + tan x +C
$

#prob-box([求不定积分$ integral sec^5 x dif x $], label: <ex:4.1.139>)

$
integral sec^5 dif x &= integral sec^3 x dif tan x\
&= sec^3 x tan x - 3 integral (sec^2 x -1)sec^3 dif x\
4 integral sec^5 dif x &= sec^3 x tan x + 3 integral sec^3 dif x\
integral sec^5 dif x &= 1/4 sec^3 x tan x + 3/8 sec x tan x + 3/8 ln abs(sec x + tan x )+C
$

#prob-box[求不定积分$ integral sec^6 x dif x $]

可以使用 @ex:4.1.139 的方法, 也可以

$
integral sec^6 dif x &= integral sec^4 x dif tan x\
&= integral (tan^2 x + 1)^2 dif tan x\
&= 1/5 tan^5 x + 2/3 tan^3 x + tan x + C 
$

#prob-box[求不定积分$ integral csc^3 x dif x $]

$
integral csc^3 x dif x &= - integral csc x dif cot x\
&= - csc x cot x - integral csc x (csc^2 x - 1)dif x\
&= -1/2 csc x cot x + 1/2 ln abs(csc x - cot x) + C
$

#prob-box[求不定积分 $ integral csc^5 x dif x $]

$
integral csc^5 x dif x &= - integral csc^3 x dif cot x\
&= -1/4 csc^3 x cot x - 3/8 csc x cot x + 3/8 ln abs(csc x - cot x) + C
$

#prob-box[求不定积分 $ integral sqrt(tan x) dif x $]

令$sqrt(tan x)=t, dif x = frac(2t,1+t^4)dif t$

$
I = integral sqrt(tan x) dif x &= 2 integral frac(t^2,1+t^4)dif t\
&= 2 integral frac(t^2+1 + (t^2-1),t^4+1)dif t\
$

都学到这儿了. 大家都是高手, 后面就显然了.

$
I = frac(1,sqrt(2)) arctan frac(sqrt(tan x)-frac(1,sqrt(tan x)), sqrt(2)) + frac(1,2sqrt(2)) ln abs(frac(
  sqrt(tan x)+frac(1,sqrt(tan x))-sqrt(2), sqrt(tan x)+frac(1,sqrt(tan x))+sqrt(2)
)) + C
$

#prob-box[求不定积分 $ integral tan^4 x dif x $]

$
integral tan^4 x dif x &= integral tan^2 x (sec^2 x - 1)dif x\
&= integral tan^2 x sec^2 x dif x - integral tan^2 x dif x\
&= 1/3 tan^3 x - tan x + x +C
$

#prob-box[求不定积分 $ integral tan^5 x dif x $]

$
integral tan^5 x dif x &= integral tan^3 x (sec^2 x - 1)dif x\
&= integral tan^3 x dif tan x - integral tan x(sec^2 x -1 )dif x\
&= 1/4 tan^4 x - 1/2 tan^2 x - ln abs(cos x) + C
$

另一个答案是$1/4 tan^4 x - 1/2 sec^2 x - ln abs(cos x) + C$. 这也是正确的. 因为$1+tan^2 x = sec^2 x$, 二者只相差一个常数.

#prob-box[求不定积分 $ integral "e"^x frac(1-x,x^2)dif x $]

注意到$display(frac("e"^x,x) = frac(x"e"^x-"e"^x,x^2))$

所以

$
integral "e"^x frac(1-x,x^2)dif x = - integral dif(frac("e"^x,x)) = frac("e"^x,x) + C
$

#prob-box[求不定积分 $ integral frac(x^3,x^8-2)dif x $]

$
integral frac(x^3,x^8-2)dif x &= 1/4 integral frac(dif x^4,(x^4)^2-(sqrt(2))^2)\
&= frac(1,8sqrt(2)) ln abs(frac(x^4-sqrt(2),x^4+sqrt(2)))+C
$

#prob-box[求不定积分 $ integral frac(dif x,sqrt(x)(1+x)) dif x $]

$
integral frac(dif x,sqrt(x)(1+x)) dif x &= 2 integral frac(dif x,1+(sqrt(x))^2)dif (sqrt(x))^2\
&= 2 arctan sqrt(x) + C
$

#star-prob-box[求不定积分 $ integral frac(sin x cos x, sqrt(a^2 sin^2 x + b^2 cos^2 x))dif x (|a| eq.not |b|) $]

$
integral frac(sin x cos x, sqrt(a^2 sin^2 x + b^2 cos^2 x))dif x &= 1/2 integral frac(dif sin^2 x, sqrt(a^2 sin^2 x + b^2 (1-sin^2 x)))dif x\
&= frac(1,2(a^2-b^2)) integral frac(dif [(a^2-b^2)sin^2 x + b^2],sqrt((a^2-b^2)sin^2 x + b^2))\
&=  frac(sqrt((a^2-b^2)sin^2 x + b^2),a^2-b^2)+C
$

#prob-box[求不定积分 $ integral frac(dif x,sin^2 x root(4,cot x)) $]

$
integral frac(dif x,sin^2 x root(4,cot x)) &= integral frac(csc^2 x dif x , root(4,cot x))\
&= - 4/3 (cot x)^(3/4) + C
$

#prob-box[求不定积分 $ integral frac(cos x , sqrt(2+cos 2x))dif x $]

$
integral frac(cos x , sqrt(2+cos 2x))dif x &= integral frac(cos x, sqrt(2 sin^2 x + 2 cos^2 x + cos^2 x - sin^2 x))dif x\
&= integral frac(cos x,sqrt(3-2 sin^2 x))dif x\
&= integral frac(1,sqrt(3- 2 sin^2 x))dif sin x\
&= 1/sqrt(2) arcsin frac(sqrt(6) sin x, 3) + C
$

#prob-box[求不定积分 $ integral frac(sin x cos x, sin^4 x + cos^4 x)dif x $]

$
integral frac(sin x cos x, sin^4 x + cos^4 x)dif x &= 1/2 integral frac(dif sin^2 x, (sin^2x)^2 + (1-sin^2 x)^2)\
&= 1/4 integral frac(dif (sin^2 x - 1/2),(sin^2 x - 1/2 )^2 + (1/2)^2)\
&= 1/2 arctan [2(sin^2 x -1/2)]\
&= 1/2 arctan (cos 2x) + C
$

#prob-box[求不定积分 $ integral frac(1,1-x^2)ln abs(frac(1+x,1-x))dif x $]

注意到

$
(ln frac(1+x,1-x))' = frac(2,1-x^2)
$

所以

$
integral frac(1,1-x^2)ln frac(1+x,1-x)dif x &= 1/2 integral frac(1+x,1-x)dif(ln frac(1+x,1-x))\
&= 1/4(ln frac(1+x,1-x))^2 + C
$

#star-prob-box[求不定积分 $ integral frac(sin x cos x , sin x + cos x)dif x $]

$
integral frac(sin x cos x , sin x + cos x)dif x &= 1/2 integral frac((sin x + cos x)^2-1,sin x + cos x)dif x\
&= 1/2 integral (sin x +cos x)dif x - 1/2 integral frac(1,sin x + cos x)dif x\
&= 1/2 sin x - 1/2 cos x - frac(1,2sqrt(2)) ln abs(csc(x+pi/4) - cot(x+pi/4)) + C
$

#prob-box[求不定积分 $ integral frac(ln x,(1+x^2)^(3/2))dif x $ ]

令$x = tan t, dif x = sec^2 t dif t$

$ 
integral frac(ln x,(1+x^2)^(3/2))dif x &= integral ln tan t dif (sin t)\
&= frac(x ln x,sqrt(1+x^2)) - ln abs(sqrt(1+x^2)+x)+C
$

#prob-box[求不定积分 $ integral frac(dif x, sqrt(x(4-x))) $]

$
integral frac(dif x, sqrt(x(4-x))) = 2 integral frac(dif sqrt(x), sqrt(2^2 -(sqrt(x))^2)) = 2 arcsin frac(sqrt(x),2)+C
$

#prob-box[求不定积分 $ integral frac(x+5,x^2-6x+13)dif x $]

$
integral frac(x+5,x^2-6x+13)dif x &= integral frac(1/2 dif (x^2-6x+13),x^2-6x+13) + integral frac(8,x^2-6x+13)dif x\
&= 1/2 ln (x^2-6x+13) + 4 arctan frac(x-3,2) + C 
$

#prob-box[求不定积分 $ integral frac(op("arccot") "e"^x, "e"^x)dif x $]

(法一)分部积分法

$
integral frac(op("arccot") "e"^x, "e"^x)dif x &= - integral op("arccot")"e"^x dif("e"^(-x))\
&= - frac(op("arccot")"e"^x, "e"^x) - x + 1/2 ln(1+"e"^(2x)) + C
$

(法二)三角换元法

令$t=op("arccot")"e"^x, dif x = - frac(1,sin t cos t)dif t$

$
integral frac(op("arccot") "e"^x, "e"^x)dif x &= - integral t dif tan t\
&= - frac(op("arccot")"e"^x, "e"^x) - ln frac("e"^x,sqrt(1+"e"^(2x))) + C
$

这两个答案是等价的, 因为

$
 - ln frac("e"^x,sqrt(1+"e"^(2x))) = - [ln("e"^x) - ln(1+"e"^(2x))^(1/2)] = - x + 1/2 ln(1+"e"^(2x)) 
$

#star-prob-box[求不定积分 $ integral frac(x"e"^x , sqrt("e"^x-1))dif x $]

$
I = integral frac(x"e"^x , sqrt("e"^x-1))dif x &= integral frac(x dif ("e"^x-1),sqrt("e"^x-1))\
&= 2 integral x dif sqrt("e"^x-1)\
&= 2 x sqrt("e"^x - 1) - 2 integral sqrt("e"^x - 1)dif x
$

记$I_1 = integral sqrt("e"^x - 1)dif x$, 设$t =sqrt("e"^x-1), dif x = frac(2 t,t^2 +1)dif t$

$
I_1 = 2 integral frac(t^2,t^2+1)dif t = 2 (sqrt("e"^x-1) - arctan sqrt("e"^x-1))
$

$
I = 2 x sqrt("e"^x - 1) - 4 sqrt("e"^x-1) + 4 arctan sqrt("e"^x-1) + C
$

#prob-box[求不定积分 $ integral frac(dif x,(2x^2+1)sqrt(1+x^2)) $]

令$x = tan t, dif x = sec^2 t dif t$, 后续步骤显然

$
integral frac(dif x,(2x^2+1)sqrt(1+x^2)) = arctan frac(x,sqrt(1+x^2)) + C
$

#prob-box[求不定积分 $ integral frac(x "e"^(arctan x), (1+x^2)^(3/2))dif x $]

本题与 @ex:4.1.97 有些类似

令$x = tan t, dif x = sec^2 t dif t$

$
integral frac(x "e"^(arctan x), (1+x^2)^(3/2))dif x &= integral "e"^t sin t dif t\
&= 1/2 "e"^(arctan x) frac(x-1,sqrt(1+x^2))+C
$

#prob-box[求不定积分 $ integral frac(arcsin "e"^x , "e"^x)dif x $]

$
I = integral frac(arcsin "e"^x , "e"^x)dif x &= - integral arcsin"e"^x dif ("e"^(-x))\
&= - "e"^(-x) arcsin "e"^x + integral frac(1,sqrt(1-"e"^(2x)))dif x
$

$
I_2 = integral frac(1,sqrt(1-"e"^(2x)))dif x &= - integral frac(1, sqrt("e"^(-2x)-1))dif ("e"^(-x))\
&= - ln ("e"^(-x)+sqrt("e"^(-2x)-1))
$

$
I = - "e"^(-x) arcsin "e"^x - ln ("e"^(-x)+sqrt("e"^(-2x)-1)) + C
$


#star-prob-box[求不定积分 $ integral x^2 sqrt(x^2+a^2)dif x $]

本题与 @ex:4.1.117 有些类似

(法一)三角换元

三角换元比较难算, 但大家未来都是优秀的研究生, 这点儿计算量不足为惧.

令$x = a tan t$

$
integral x^2 sqrt(x^2+a^2)dif x &= a^4 integral (sec^2 t - 1)sec^3 t dif t\
&= a^4 (integral sec^5 t dif t - integral sec^3 t dif t)\
&= frac(x(sqrt(x^2+a^2))^3,4) - frac(a^2 x sqrt(x^2+a^2),8) - a^4/8 ln(sqrt(x^2+a^2) + x) + C
$

(法二)分部积分法

$
I = integral x^2 sqrt(x^2+a^2)dif x &= 1/2 integral x sqrt(x^2 + a^2)dif (x^2+a^2)\
&= 1/3 integral x dif (x^2+a^2)^(3/2)\
&= 1/3 x(x^2+a^2)^(3/2) - 1/3 integral (x^2+a^2)sqrt(x^2+a^2) dif x\
&= 1/3 x(x^2+a^2)^(3/2) - 1/3 integral x^2 sqrt(x^2+a^2) dif x - frac(a^2,3) integral sqrt(x^2+a^2) dif x
$

出现循环项, 所以

$
I = frac(x(sqrt(x^2+a^2))^3,4) - frac(a^2 x sqrt(x^2+a^2),8) - a^4/8 ln(sqrt(x^2+a^2) + x) + C
$

#prob-box[求不定积分 $ integral frac(1,x^2)sqrt(frac(1-x,1+x))dif x $]

设$x = sin t, dif x = cos t dif t$

$
integral frac(1,x^2)sqrt(frac(1-x,1+x))dif x &= integral frac(1,x^2 sqrt(1-x^2)) dif x - integral frac(1,x sqrt(1-x^2))dif x\
&= integral csc^2 t dif t - integral csc t dif t\
&= - frac(sqrt(1-x^2),x) - ln abs(frac(1-sqrt(1-x^2),x))+C
$

= 定积分

== 定积分计算题

#prob-box[求定积分 $ integral_0^1 x^2 sqrt(1-x^2)dif x $]

令$x = sin t , 0 <= t <= pi/2$

$
I = integral_0^1 x^2 sqrt(1-x^2)dif x = integral_0^(pi/2) sin^2 t sqrt(1-sin^2 t) cos t dif t\
$

因为$display(sqrt(1-sin^2 t) >= 0)$

$
I = 1/4 integral_0^(pi/2) sin^2 2 t dif t = pi/16
$

#prob-box[求定积分 $ integral_0^4 frac(ln x,sqrt(x))dif x $]

$
integral_0^4 frac(ln x,sqrt(x))dif x &= 2 integral_1^4 ln x dif sqrt(x)\
&= 2 [lr(sqrt(x)ln x |)_1^4 - integral_1^4 frac(1,sqrt(x))dif x ]\
&= 8 ln 2 -4 
$

#prob-box[求定积分 $ integral_0^1 floor("e"^x)dif x $]

$x in [0,1], "e"^x in [1,"e"]$

$
floor("e"^x) = cases(1\,& -<= x < ln 2, 2\, & ln <= x <= 1)
$

$
integral_0^1 floor("e"^x)dif x = integral_0^(ln 2)dif x + integral_(ln 2)^1 2 dif x = 2 - ln 2
$

#prob-box[求定积分 $ integral_0^(pi/2) frac(sin x,sin x + cos x)dif x $ ]

#rect($ integral_0^(pi/2) f(sin x)dif x = integral_0^(pi/2) f(cos x)dif x $)

$
integral_0^(pi/2) frac(sin x,sin x + cos x)dif x &= integral_0^(pi/2) frac(cos x,cos x + sin x)dif x\
&= 1/2 [integral_0^(pi/2) frac(sin x + cos x, sin x + cos x)dif x ]\
&= pi/4
$

#prob-box[求定积分 $ integral_(pi/2)^(pi/2) (x^3 + sin^2 x)cos^2 x dif x $]

$
I &= integral_(pi/2)^(pi/2) x^3 cos^2 x dif x + integral_(pi/2)^(pi/2) sin^2 x cos^2 x dif x\
&= 0 + 2 integral_0^(pi/2)cos^2 x dif x - 2 integral_0^(pi/2) cos^4 x dif x\
&= pi/8
$

#prob-box[求定积分 $ integral_(-2 pi)^(4 pi) abs(sin^5 x)dif x $]

根据周期性

$
I= 6 integral_0^(pi)sin^5 x dif x = 12 integral_0^(pi/2) sin^5 x dif x
$

根据Wallis公式, 有

$
I = 12 times 4/5 times 2/3 = 32/5
$

#prob-box[求反常积分 $ integral_1^(+oo) frac(1,x sqrt(x-1))dif x $]

设$sqrt(x-1) = t, t in (0, +oo)$

$
integral_1^(+oo) frac(1,x sqrt(x-1))dif x = 2 integral_0^(+oo) frac(1,t^2+1)dif t = pi 
$

#prob-box[求反常积分$ integral_0^(+oo)frac(dif x,(1+x^2)^2)  $]

根据 @ex:4.1.95 , 有

$
I = lr(1/2 arctan x|)_0^(+oo) + lr(frac(x,2(1+x^2))|)_0^(+oo) = pi/4
$


== 定积分概念题

#prob-box[求极限$ lim_(n-> oo)(frac(1,n+1)+frac(1,n+2)+frac(1,n+3)+ dots + frac(1,n+n)) $]

记原极限为$I$, 我们要对这个结构敏感: $display(integral_0^1 f(x)dif x = lim_(n->oo)1/n sum_(n=1)^(oo) f(i/n))$

$
I&=1/n (frac(1,1+1/n)+frac(1,1+2/n)+frac(1,1+3/n)+ dots + frac(1,1+n/n))\
&= lim_(n->oo)1/n sum_(n=1)^(oo) f(frac(1,1+i/n))\
&= integral_0^1 frac(1,1+x) dif x = ln 2
$

#prob-box[求极限$ lim_(n-> oo) n(frac(1,1+n^2)+frac(2^2,1+n^2)+ dots + frac(1,n^2+n^2)) $]

$
I &= lim_(n-> oo) 1/n (frac(1,1+(1/n)^2)+frac(1,1+(2/n)^2)+ dots + frac(1,1+(n/n)^2))\
&= lim_(n-> oo) 1/n sum_(i=1)^n frac(1,1+(i/n)^2)\
&= integral_0^1 frac(1,1+x^2)dif x = arctan x |_0^1 = pi/4
$

#prob-box[$p>0$, 计算积分$display(integral_0^(+oo) x"e"^(-p x)dif x)$

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),  // 分为平分的左右两栏
  row-gutter: 1em,    // 设置行间距，让公式看起来不拥挤

[A. $p$],
[B. $display(1/p)$],
[C. $display(1/p^2)$],
[D. $oo$],
)
]

套公式即可

== 定积分证明题

#prob-box([讨论瑕积分$display(integral_(-1)^1 frac(1,x^2)dif x )$的敛散性],label:<ex:5.3.1> )

注意到$x=0$是瑕积分的瑕点, 所以

$
integral_(-1)^1 frac(1,x^2)dif x &= integral_(-1)^0 frac(1,x^2)dif x + integral_(0)^1 frac(1,x^2)dif x
$

因为

$
integral_(-1)^0 1/(x^2)dif x = lr(-1/x |)_(-1)^0 = lim_(x->oo)(-1/x)-1  = +oo
$

所以瑕积分$display(integral_(-1)^1 frac(1,x^2)dif x )$发散.

















































































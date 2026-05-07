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

  当前进度: #strong[不定积分] 
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

#prob-box[求极限 $ display(lim_(x->1)(1-x)tan (pi x)/2) $ ]

#prob-box[求极限 $ lim_(x->-oo)x(sqrt(x^2+1)+x) $]
#prob-box[$ lim_(x->-1)(1/(1+x)-3/(1+x^3)) $]

#prob-box[$ lim_(x->0)frac("e"^(1/x)+1,"e"^(1/x)-1) arctan 1/x $]

#prob-box[$ lim_(x->oo)frac((x+a)^(x+a)(x+b)^(x+b),(x+a+b)^(2x+a+b)) $]

#prob-box[
  设$k>0$, 若$display(lim_(x->0)frac(arctan k x^2 + k x^2 f(x),x^6)=0)$, 且$display(lim_(x->0)frac(1+f(x), x^4)=1)$, 则$k=$
]

#prob-box[
  求极限:$ lim_(x arrow.r pi / 4) (tan x)^(tan 2 x) $
]

#prob-box[求极限: $ lim_(x arrow.r 0) frac(tan (tan x) - sin (sin x), tan x - sin x) $
]

#prob-box[求极限:$ lim_(x arrow.r 0) frac(sqrt(1 + 2 sin x) - x - 1, x ln (1 + x)) $
]

#prob-box[求极限:$ lim_(x arrow.r + oo) (2 / pi upright(a r c) tan x)^x $]

#prob-box[求极限: $ lim_(x arrow.r 0^(+)) (arcsin x)^(tan x) $]

#prob-box[求极限: $ lim_(x arrow.r 0^(+)) frac(1 - sqrt(cos x), x (1 - cos sqrt(x))) $]

#star-prob-box[求极限: $ lim_(x arrow.r 2) frac(root(4, x + 14) - 2, x^2 - 4) $]

#prob-box[求极限$ lim_(x arrow.r + oo) [(x^3 - x^2 + x / 2) upright(e)^(1 / x) - sqrt(x^6 + 1)] $]

#star-prob-box[已知$display(lim_(x arrow.r pi) frac(sqrt(sin x / 2) - 1, A (x - pi)^k) = 1)$, 求$A$和$k$的值
]

#twostar-prob-box[求极限$ lim_(x arrow.r 0) frac(cos (x upright(e)^x) - upright(e)^(- x^2 / 2 dot.op upright(e)^(2 x)), x^4) $
]

#prob-box[求极限$ lim_(x arrow.r + oo) (root(3, x^3 + x^2 + 1) - sqrt(x^2 + x + 1)) $]

#prob-box[求极限:$ lim_(x arrow.r 0) frac(sqrt(cos x) - root(3, 1 + sin^2 x), x^2) $]

#prob-box[求极限:$ lim_(x arrow.r 0) frac((1 + x)^(1 / x) - upright(e)^(cos x), root(3, 1 + x) - 1) $]

#prob-box[求极限:$ lim_(x arrow.r 0) 1 / x^3 [(frac(cos x + 2 cos 2 x, 3))^x - 1] $]

#star-prob-box[求数列极限:$ lim_(n arrow.r oo) sin (sqrt(4 n^2 + n) pi) $]

#prob-box[求极限:$ lim_(x->oo)frac((2x-3)^20 (3x+2)^30,(2x+1)^50) $]

== 极限综合题

= 导数与微分

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

= 不定积分

== 不定积分计算

#prob-box[求不定积分$ integral (a / x + a^2 / x^2 + a^3 / x^3 + a^4 / x^4) upright(d) x $]

#prob-box[求不定积分$ integral frac(3, 1 + x^2) - 2 / sqrt(1 - x^2) upright(d) x $]

#prob-box[求不定积分$ integral frac(1, x^2 + 1) - frac(1, x^2 - 1) upright(d) x $]

#prob-box[求不定积分$ integral upright(e)^(upright(e)^x sin x) (sin x + cos x) upright(e)^x upright(d) x $]

#prob-box[求不定积分$ integral upright(e)^(tan 1 / x) / x^2 sec^2 1 / x upright(d) x $]

#prob-box[求不定积分$ integral frac(upright(d) x, root(3, 2 - 3 x)) $]

#prob-box[求不定积分$ integral frac(sin sqrt(x), sqrt(x)) upright(d) x $]

#prob-box[求不定积分$ integral frac(upright(d) x, 2 + 3 x^2) $]

#prob-box[求不定积分$ integral frac(upright(d) x, 2 - 3 x^2) $]

#prob-box[求不定积分$ integral 1 / sqrt(3 x^2 - 2) upright(d) x $]

#prob-box[求不定积分$ integral sec x "d"x $]

#prob-box[求不定积分$ integral tan^4 x sec^2 x upright(d) x $]

#prob-box[求不定积分$ integral frac(2 x - 1, sqrt(1 - x^2)) upright(d) x $]

#prob-box[求不定积分$ integral frac(2 x - 1, sqrt(x^2 - x)) upright(d) x $]

#prob-box[求不定积分$ integral x / sqrt(2 - 3 x^2) upright(d) x $]

#prob-box[求不定积分$ integral x sin x "d"x $]

#prob-box[求不定积分$ integral x ln x "d"x $]

#prob-box[求不定积分$ integral x^2 ln x "d"x $]

#prob-box[求不定积分$ integral x^2 arctan x "d"x $]

#prob-box[求不定积分$ integral x^2 sin x "d"x $]

#prob-box[求不定积分$ integral ln^2 x "d"x $]

#prob-box[求不定积分$ integral x ln (x-1) "d"x $]

#prob-box[求不定积分$ integral (ln^3 x) / x^2 "d"x $]

#prob-box[求不定积分$ integral((ln x) / x)^3"d"x $]

#prob-box[求不定积分$ integral (arcsin x)^2 "d"x $]

#prob-box[求不定积分$ integral "e"^sqrt(3x+9)"d"x $]

#prob-box[求不定积分$ integral arcsin x "d"x $]

#prob-box([求不定积分$ integral 1/(x sqrt(1-x^2))"d"x $], label:<ex:4.1.28>)

#star-prob-box[求不定积分$ integral frac(arcsin x, x^2)"d"x $ ]

#prob-box[求不定积分$ integral frac(root(5, 1-2x+x^2),1-x)"d"x $]

#prob-box[求不定积分$ integral frac("d"x, sin^2(2x+pi/4)) $]

#prob-box[求不定积分$ integral 1/(1+cos x)"d"x $]

#prob-box[求不定积分$ integral ("d"x)/(1-cos x) $]

#prob-box[求不定积分$ integral ("d"x)/(1+sin x) $]

#prob-box[求不定积分$ integral sin^3 x "d"x $]

#prob-box[求不定积分$ integral cos^3 x "d"x $]

#prob-box[求不定积分$ integral frac(x, (x+1)(x+2)(x+3))"d"x $]

#prob-box[求不定积分 $ integral frac("d"x, (1+x)(x^2-1)) $]

#prob-box[求不定积分 $ integral frac("d"x, (x-1)(x^2+1)) $ ]

#prob-box[求不定积分$ integral frac(x^2+1,(x+1)^2(x-1))"d"x $]

#prob-box[求不定积分$ integral frac(1,x^4-1)"d"x $]

#prob-box[求不定积分$ integral frac("d"x,1+root(3,x+1)) $]

#prob-box[求不定积分$ integral frac((sqrt(x))^3-1,sqrt(x)+1)"d"x $]

#prob-box[求不定积分$ integral sin^2 x "d"x $]

#prob-box[求不定积分$ integral frac(1,1+sin x+cos x)"d"x $]

#star-prob-box[求不定积分$ integral frac("d"x, a^2 sin^2 x+b^2cos^2 x) $]

#prob-box[求不定积分$ integral frac("d"x, 3+sin^2 x) $]

#prob-box[求不定积分$ integral frac("d"x, 3+cos x) $]

#prob-box[求不定积分$ integral sqrt(1-x^2)arcsin x "d"x $]

#prob-box([求不定积分$ integral frac(arccos x, sqrt((1-x^2)^3))"d"x $], label:<ex:4.1.50>)

#star-prob-box[求不定积分$ integral frac(arcsin x,x^2) dot frac(1+x^2,sqrt(1-x^2))"d"x $]

#prob-box[求不定积分$ integral frac(x^3 arccos x,sqrt(1-x^2))"d"x $]

#prob-box[求不定积分$ integral (x^2-1)^3"d"x $]

#twostar-prob-box[求不定积分$ integral frac(1,root(3,(x-1)^2(x+1)^4)) $]

#prob-box([求不定积分$ integral frac(x^4,1+x^2)"d"x $], label: <ex:4.1.55>)

#prob-box[求不定积分$ integral sqrt(frac(1-x,1+x))"d"x $]

#prob-box[求不定积分$ integral frac(3x^4+2x^2,x^2+1)"d"x $]

#prob-box[求不定积分$ integral frac(1+2x^2,x^2(1+x^2))"d"x $]

#prob-box[求不定积分$ integral frac(sqrt(1+x^2)+sqrt(1-x^2),sqrt(1-x^4))"d"x $]

#prob-box[求不定积分$ integral 2^x"e"^x"d"x $]

#prob-box[求不定积分$ integral frac("e"^(3x)+1,"e"^x+1)"d"x $]

#prob-box[求不定积分$ integral frac("d"x,x sqrt(1+x^2))"d"x $]

#prob-box[求不定积分$ integral (2^x+3^x)^2"d"x $]

#prob-box[求不定积分$  integral max lr({1,x^2,x^3})"d"x $]

#star-prob-box([求不定积分$ integral sqrt(1+cos 2x)"d"x $], label: <ex:4.1.65>)

#star-prob-box[求不定积分$ integral sqrt(1-sin 2x)"d"x $]

#prob-box[求不定积分$ integral tan^2 x dif x $]

#prob-box[求不定积分$ integral cot^2 x dif x $]

#prob-box[求不定积分$ integral frac(1,16-x^4)dif x $]

#prob-box[求不定积分$ integral frac(ln tan x,cos x sin x)dif x $]

#prob-box[求不定积分$ integral frac(dif x, x+ sqrt(1-x^2)) $]

#prob-box[求不定积分$ integral frac(2 sin x + 3 cos x,5 sin x + 7 cos x)dif x $]

#prob-box[求不定积分$ integral frac((arctan sqrt(x))^2,sqrt(x)(1+x)) dif x $]

#prob-box[求不定积分$ integral frac(x^2,(1+x^2)^2)dif x $]

#prob-box[求不定积分$ integral frac(1,(1+"e"^x)^2)dif x $]

#prob-box[求不定积分$ integral frac(sin x cos x,1+sin^4 x)dif x $]

#prob-box[求不定积分$ integral frac(dif x,x(x^6+4)) $]

#prob-box[求不定积分$ integral frac(dif x, sin 2x + 2 sin x) $]

#prob-box[求不定积分$ integral frac(ln(sin x), sin^2 x)dif x $]

#prob-box[求不定积分 $ integral frac(1,x^3+1)dif x $]

#prob-box[求不定积分 $ integral frac(x, x^3-1)dif x $ ]

#prob-box([求不定积分 $ integral frac(1,x^4+1)dif x $], label: <ex:4.1.82>)

#prob-box[求不定积分 $ integral sqrt(frac(1-x,1+x))frac(dif x,x) $]

#prob-box[求不定积分 $ integral frac(1,x^4(1+x^2)) dif x $]

#prob-box[求不定积分 $ integral frac(1,x(1+x^4)) dif x $]

#prob-box[求不定积分 $ integral x "e"^x cos x dif x $]

#prob-box([求不定积分 $ integral cos ln x dif x $], label:<ex:4.1.87> )

#prob-box[求不定积分 $ integral sin ln x dif x $]

#prob-box[求不定积分 $ integral "e"^x sin^2 x dif x $]

#prob-box[求不定积分 $ integral x^n ln x dif x $]

#prob-box[求不定积分 $ integral x ln frac(1+x,1-x)dif x $]

#prob-box[求不定积分 $ integral arctan sqrt(x)dif x $]

#prob-box[求不定积分 $ integral x^2 ln frac(1-x,1+x)dif x $]

#prob-box[求不定积分 $ integral frac(x ln(x+sqrt(1+x^2)), sqrt(1+x^2))dif x $]

#prob-box[求不定积分 $ integral frac(1,(1+x^2)^2)dif x $]

#prob-box[求不定积分$ integral arctan(x^2) dif x $]

#prob-box([求不定积分$ integral frac("e"^(arctan x), (1+x^2)^(3/2))dif x $], label: <ex:4.1.97>)

#prob-box[求不定积分$ integral "e"^(2x) sin^x dif x $]

#prob-box[求不定积分$ integral frac(arctan "e"^x, "e"^x)dif x $]

#prob-box[求不定积分$ integral frac(x"e"^x,(x+1)^2)dif x $]

#prob-box[求不定积分 $ integral frac(arctan x,x^2(1+x^2))dif x $]

#prob-box[求不定积分 $ integral "e"^(2x)(tan x+1)^2 dif x $ ]

#prob-box[求不定积分$ integral frac(arctan "e"^x, "e"^(2x))dif x $]

#prob-box[求不定积分$ integral frac(1,"e"^x + "e"^(-x))dif x $]

#prob-box[求不定积分$ integral frac(1,sqrt(x(1+x)))dif x $]

#prob-box[求不定积分$ integral frac(dif x, sqrt((x^2+a^2)^3)) $]

#prob-box[求不定积分 $ integral frac(dif x, sqrt((x^2-a^2)^3)) $]

#prob-box[求不定积分 $ integral frac(sqrt(x^2-4),x)dif x $]

#prob-box[求不定积分 $ integral tan sqrt(1+x^2) frac(x,sqrt(1+x^2))dif x $]

#star-prob-box[求不定积分 $ integral sqrt(frac(x,1-x sqrt(x)))dif x $]

#star-prob-box[求不定积分 $ integral frac(x,sqrt(1+x^2+sqrt((1+x^2)^3)))dif x $]

#prob-box[求不定积分 $ integral frac(x^3+1,(x^2+1)^2)dif x $]

#prob-box[求不定积分$ integral frac(dif x, sqrt("e"^(2x)+1)) $]

#prob-box[求不定积分 $ integral sqrt(frac("e"^x-1,"e"^x+1))dif x $]

#prob-box[求不定积分$ integral frac(1,"e"^x (1+"e"^(2x)))dif x $]

#prob-box[求不定积分 $ integral sqrt(1+"e"^(2x))dif x $]

#prob-box([求不定积分 $ integral "e"^x sqrt(1+"e"^(2x))dif x $], label: <ex:4.1.117>)

#prob-box[求不定积分 $ integral frac(dif x,sqrt("e"^x+1)) $]

#star-prob-box[求不定积分 $ integral frac(2^x dot 3^x , 9^x + 4^x)dif x $]

#star-prob-box[求不定积分 $ integral frac(1+ln x,x^(-x)+x^x)dif x $]

#prob-box[求不定积分$ integral frac(sqrt(ln tan x), sin 2x)dif x $]

#prob-box[求不定积分 $ integral frac(dif x, x ln x ln(ln x)) $]

#prob-box[求不定积分 $ integral frac((1+2x^2)"e"^x^2,2-3x"e"^x^2)dif x $]

#prob-box[求不定积分 $ integral frac(dif x,(a sin x + b cos x)^2) $]

#star-prob-box[求不定积分 $ integral frac(cos x + x sin x , (x+ cos x)^2)dif x $]

#star-prob-box[求不定积分 $ integral frac(x+sin x cos x , (x sin x + cos x)^2)dif x $]

#star-prob-box[求不定积分$ integral frac(1-ln x, (x- ln x)^2)dif x $]

#prob-box[求不定积分 $ integral frac(1+x,x(1+x"e"^x))dif x $]

#star-prob-box[求不定积分 $ integral frac(ln x + 2, x ln x (1+ x ln^2 x))dif x $]

#star-prob-box[求不定积分 $ integral x ln (1+x^2)arctan x dif x $]

#prob-box[求不定积分 $ integral sqrt((x^2+x)"e"^x)(x^2+3x+1)"e"^x  dif x $]

#star-prob-box[求不定积分 $ integral {frac(f(x),f'(x)) - frac(f^2(x)f''(x),[f'(x)]^3)}dif x $]

#star-prob-box[求不定积分 $ integral frac(arcsin(1-x), sqrt(2x-x^2))dif x $]

#prob-box[求不定积分 $ integral tan^3 x sec x dif x $]

#prob-box[求不定积分 $ integral sin^2 x cos^3 x dif x $]

#prob-box[求不定积分 $ integral sin 5x sin 7x dif x $]

#prob-box[求不定积分 $ integral frac(cot x, sqrt(sin x))dif x $]

#prob-box[求不定积分 $ integral sec^4 x dif x $]

#prob-box([求不定积分$ integral sec^5 x dif x $], label: <ex:4.1.139>)

#prob-box[求不定积分$ integral sec^6 x dif x $]

#prob-box[求不定积分$ integral csc^3 x dif x $]

#prob-box[求不定积分 $ integral csc^5 x dif x $]

#prob-box[求不定积分 $ integral sqrt(tan x) dif x $]

#prob-box[求不定积分 $ integral tan^4 x dif x $]

#prob-box[求不定积分 $ integral tan^5 x dif x $]

#prob-box[求不定积分 $ integral "e"^x frac(1-x,x^2)dif x $]

#prob-box[求不定积分 $ integral frac(x^3,x^8-2)dif x $]

#prob-box[求不定积分 $ integral frac(dif x,sqrt(x)(1+x)) dif x $]

#star-prob-box[求不定积分 $ integral frac(sin x cos x, sqrt(a^2 sin^2 x + b^2 cos^2 x))dif x (|a| eq.not |b|) $]

#prob-box[求不定积分 $ integral frac(dif x,sin^2 x root(4,cot x)) $]

#prob-box[求不定积分 $ integral frac(cos x , sqrt(2+cos 2x))dif x $]

#prob-box[求不定积分 $ integral frac(sin x cos x, sin^4 x + cos^4 x)dif x $]

#prob-box[求不定积分 $ integral frac(1,1-x^2)ln abs(frac(1+x,1-x))dif x $]

#star-prob-box[求不定积分 $ integral frac(sin x cos x , sin x + cos x)dif x $]

#prob-box[求不定积分 $ integral frac(ln x,(1+x^2)^(3/2))dif x $ ]

#prob-box[求不定积分 $ integral frac(dif x, sqrt(x(4-x))) $]

#prob-box[求不定积分 $ integral frac(x+5,x^2-6x+13)dif x $]

#prob-box[求不定积分 $ integral frac(op("arccot") "e"^x, "e"^x)dif x $]

#star-prob-box[求不定积分 $ integral frac(x"e"^x , sqrt("e"^x-1))dif x $]

#prob-box[求不定积分 $ integral frac(dif x,(2x^2+1)sqrt(1+x^2)) $]

#prob-box[求不定积分 $ integral frac(x "e"^(arctan x), (1+x^2)^(3/2))dif x $]

#prob-box[求不定积分 $ integral frac(arcsin "e"^x , "e"^x)dif x $]

#star-prob-box[求不定积分 $ integral x^2 sqrt(x^2+a^2)dif x $]

#prob-box[求不定积分 $ integral frac(1,x^2)sqrt(frac(1-x,1+x))dif x $]


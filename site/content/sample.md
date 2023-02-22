+++
title = "Sample"
description = "Test Page"

[extra]
ToC = true
edit = true
math = true
+++

Here's a general demo of how things look! [^1]

Written in [**Markdown**](https://www.markdownguide.org/), rendered using Zola's `pulldown-cmark` parser

# Content

[_Jet Brains_](https://www.jetbrains.com/lp/mono/) fonts are used for additional ligatures and irresistible **_style_**!

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## Code

Features built-in Syntax Highlighting ~~styled by CSS~~

**Inline** Code: `println!("Hello World!");`

**Multi-line** Code:

```rs
fn foo(arg: String) -> Result<u32, Io::Error> {
  println!("Nice!"); // LGTM
  if 1 != 0 {
    println!("How many ligatures can I contrive??");
    println!("Turns out a lot! ==> -/-> <!-- <$> >>=");
  }
  Ok(42)
}
```

## List

- 1
  - a
  - b
  - c
- [ ] 2
- [x] 3

## Table

| Left | Center | Right |
| :--- | :----: | ----: |
| 1    |   A    |     ! |
| 2    |   B    |     @ |
| 3    |   C    |     # |
| 4    |   D    |     $ |

## Block Quote

> Do not fall in love with people like me. I will take you to museums, and parks, and monuments, and kiss you in every beautiful place, so that you can never go back to them without tasting me like blood in your mouth. I will destroy you in the most beautiful way possible. And when I leave you will finally understand, why storms are named after people.
>
> --> **Caitlyn Siehl**
>
> > Heroes get remembered, but legends never die
> >
> > --> **Babe Ruth**

## Math

Supports Math Type-Setting using [$\KaTeX$](http://khan.github.io/KaTeX/)

```
$$
f(x) = \int_{-\infty}^\infty\hat f(\xi)\,e^{2 \pi i \xi x}\,d\xi
$$
```

$$
f(x) = \int_{-\infty}^\infty\hat f(\xi)\,e^{2 \pi i \xi x}\,d\xi
$$

## Dropdown

<details>
<summary><b>SPOILER</b></summary>

I'm not a fool to be fooled by a fool, you fool ;)

</details>

# Media

Supports wide range of Multi-Media using [_shortcodes_](https://www.getzola.org/documentation/content/shortcodes/)

## Image

{{ figure(src="https://raw.githubusercontent.com/maydayv7/dotfiles/b384f1914f030f1e12ae58cc2b78512a378bf4c9/files/images/wallpapers/Island.jpg", alt="Island", style="border-style: inset; border-radius: 15px; width: 100%;", caption="A Nice Wallpaper", caption_style="font-weight: bold;") }}

## Video

Here's a sample video played using **_YouTube_** $\copyright$

{{ youtube(id="C0DPdy98e4c") }}

# Headers

# I

## II

### III

#### IV

---

[^1]: This is a FOOTNOTE!

(() => {
  const elements = document.querySelectorAll(".markdown .arithmatex");
  if (!elements.length) return;
  const css = document.createElement("link");
  css.rel = "stylesheet";
  css.href = "/math/katex.css";
  document.head.appendChild(css);
  const script = document.createElement("script");
  script.src = "/js/katex.js";
  script.onload = () => {
    for (const element of elements) {
      const text = element.textContent.trim();
      const displayMode = text.startsWith("\\[");
      const delimited = displayMode || text.startsWith("\\(");
      window.katex.render(delimited ? text.slice(2, -2) : text, element, {
        displayMode,
        throwOnError: false,
        trust: false,
      });
      if (displayMode) element.tabIndex = 0;
    }
  };
  document.head.appendChild(script);
})();

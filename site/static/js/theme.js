(() => {
  const selector = document.getElementById("theme-select");
  let current = document.getElementById("site-theme");
  if (!selector || !current) return;
  const allowed = new Set([...selector.options].map((option) => option.value));
  let pending;

  function changeTheme(theme) {
    if (!allowed.has(theme)) return;
    if (pending) {
      pending.remove();
      pending = null;
    }
    if (theme === current.dataset.theme) {
      selector.value = theme;
      return;
    }
    const link = document.createElement("link");
    link.rel = "stylesheet";
    link.href = new URL(`${theme}.css`, current.href).href;
    link.dataset.theme = theme;
    pending = link;
    link.onload = () => {
      if (pending !== link) return;
      current.replaceWith(link);
      link.id = "site-theme";
      current = link;
      pending = null;
      selector.value = theme;
      document.cookie = `theme_color=${theme}; path=/; max-age=31536000; SameSite=Lax`;
    };
    link.onerror = () => {
      if (pending !== link) return;
      link.remove();
      pending = null;
      selector.value = current.dataset.theme;
    };
    document.head.appendChild(link);
  }

  selector.addEventListener("change", () => changeTheme(selector.value));
  const saved = document.cookie.match(/(?:^|;\s*)theme_color=([^;]*)/);
  if (saved && allowed.has(saved[1])) changeTheme(saved[1]);
})();

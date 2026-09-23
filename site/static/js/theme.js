(() => {
  const selector = document.getElementById("theme-select");
  if (!selector) return;
  const root = document.documentElement;
  const allowed = new Set([...selector.options].map((option) => option.value));

  function applyTheme(theme) {
    if (!allowed.has(theme)) return;
    root.dataset.theme = theme;
    selector.value = theme;
  }

  selector.addEventListener("change", () => {
    const theme = selector.value;
    applyTheme(theme);
    const domain = selector.dataset.cookieDomain;
    const shared =
      domain &&
      (location.hostname === domain ||
        location.hostname.endsWith(`.${domain}`));
    const secure = location.protocol === "https:" ? "; Secure" : "";
    document.cookie = `site_theme=${theme}; path=/; max-age=31536000; SameSite=Lax${secure}${shared ? `; Domain=${domain}` : ""}`;
  });

  applyTheme(root.dataset.theme);
  window.addEventListener("pageshow", () => {
    const saved = document.cookie.match(/(?:^|;\s*)site_theme=([^;]*)/);
    if (saved) applyTheme(saved[1]);
  });
})();

(() => {
  const phone = matchMedia(
    getComputedStyle(document.documentElement)
      .getPropertyValue("--phoneWidth")
      .trim(),
  );
  const menus = [
    [
      document.querySelector(".menu-trigger"),
      document.getElementById("mobile-menu"),
    ],
    [
      document.querySelector(".menu-inner-list-more-trigger"),
      document.getElementById("more-menu"),
    ],
  ].filter(([button, panel]) => button && panel);

  function setOpen(button, panel, open) {
    panel.classList.toggle("hidden", !open);
    button.setAttribute("aria-expanded", String(open));
  }
  for (const [button, panel] of menus) {
    setOpen(button, panel, false);
    button.addEventListener("click", () =>
      setOpen(button, panel, button.getAttribute("aria-expanded") !== "true"),
    );
    document.addEventListener("click", (event) => {
      if (!button.contains(event.target) && !panel.contains(event.target))
        setOpen(button, panel, false);
    });
    document.addEventListener("keydown", (event) => {
      if (
        event.key === "Escape" &&
        button.getAttribute("aria-expanded") === "true"
      ) {
        setOpen(button, panel, false);
        button.focus();
      }
    });
    phone.addEventListener("change", () => setOpen(button, panel, false));
  }
  const form = document.querySelector(".pagination__form");
  if (form)
    form.addEventListener("submit", (event) => {
      event.preventDefault();
      if (!form.reportValidity()) return;
      const page = Number(form.elements.page.value);
      location.href =
        page === 1
          ? form.action.replace(/page\/$/, "")
          : `${form.action}${page}/`;
    });
})();

document.querySelectorAll(".comments-collapsible").forEach((button) => {
  const content = document.getElementById(button.getAttribute("aria-controls"));
  const thread = content.querySelector(".comments-content");
  const loader = thread.querySelector("script[data-src]");
  const reducedMotion = matchMedia("(prefers-reduced-motion: reduce)");
  let loaded = false;
  let open = false;
  let hideTimer;

  const resize = new ResizeObserver(() => {
    if (open) content.style.maxHeight = `${thread.scrollHeight}px`;
  });
  resize.observe(thread);

  button.addEventListener("click", () => {
    open = !open;
    clearTimeout(hideTimer);
    button.setAttribute("aria-expanded", String(open));
    button.classList.toggle("active", open);
    button.textContent = open ? "Hide Comments" : "Show Comments";
    content.inert = !open;

    if (open) {
      content.hidden = false;
      void content.offsetHeight;
      content.style.maxHeight = `${thread.scrollHeight}px`;
    } else {
      content.style.maxHeight = "0px";
      if (reducedMotion.matches) content.hidden = true;
      else
        hideTimer = setTimeout(() => {
          content.hidden = true;
        }, 220);
    }

    if (!open || loaded) return;
    loaded = true;
    thread.querySelector('[role="status"]')?.remove();
    if (thread.id === "disqus_thread") {
      window.disqus_config = function () {
        this.page.url = content.dataset.url;
        this.page.identifier = content.dataset.url;
      };
    }
    const script = document.createElement("script");
    for (const attribute of loader.attributes) {
      if (!["type", "data-src"].includes(attribute.name))
        script.setAttribute(attribute.name, attribute.value);
    }
    script.src = loader.dataset.src;
    script.async = true;
    script.onerror = () => {
      loaded = false;
      script.remove();
      const status = document.createElement("p");
      status.setAttribute("role", "status");
      status.textContent =
        "Comments could not load. Close and reopen to retry.";
      thread.append(status);
    };
    thread.append(script);
  });
});

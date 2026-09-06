(() => {
  const input = document.getElementById("search");
  if (!input) return;
  const container = input.closest(".search-container");
  const panel = document.getElementById("search-results");
  const items = panel.querySelector(".search-results__items");
  const status = panel.querySelector('[role="status"]');
  let engine;
  let library;
  let timer;
  let revision = 0;

  function loadEngine() {
    if (engine) return engine;
    if (!library) {
      library = new Promise((resolve, reject) => {
        if (window.Fuse) return resolve();
        const script = document.createElement("script");
        script.src = input.dataset.library;
        script.onload = resolve;
        script.onerror = () => {
          script.remove();
          library = null;
          reject(new Error("Search library unavailable"));
        };
        document.head.appendChild(script);
      });
    }
    engine = Promise.all([
      library,
      fetch(input.dataset.index).then((response) => {
        if (!response.ok) throw new Error("Search index unavailable");
        return response.json();
      }),
    ])
      .then(
        ([, index]) =>
          new Fuse(index, {
            keys: [
              { name: "title", weight: 2 },
              { name: "body", weight: 1 },
            ],
            minMatchCharLength: 2,
            threshold: 0.3,
            ignoreLocation: true,
          }),
      )
      .catch((error) => {
        engine = null;
        throw error;
      });
    return engine;
  }

  function show(visible) {
    panel.style.display = visible ? "block" : "none";
  }

  function close() {
    revision++;
    clearTimeout(timer);
    panel.removeAttribute("aria-busy");
    show(false);
  }

  function teaser(body, terms) {
    const lower = body.toLowerCase();
    const matches = terms
      .map((term) => lower.indexOf(term.toLowerCase()))
      .filter((index) => index >= 0);
    const start = Math.max(0, (matches.length ? Math.min(...matches) : 0) - 40);
    const text =
      (start ? "…" : "") +
      body.slice(start, start + 200) +
      (body.length > start + 200 ? "…" : "");
    const paragraph = document.createElement("div");
    const pattern = new RegExp(
      terms
        .map((term) => term.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"))
        .join("|"),
      "gi",
    );
    let position = 0;
    for (const match of text.matchAll(pattern)) {
      paragraph.append(text.slice(position, match.index));
      const bold = document.createElement("b");
      bold.textContent = match[0];
      paragraph.append(bold);
      position = match.index + match[0].length;
    }
    paragraph.append(text.slice(position));
    return paragraph;
  }

  async function search() {
    const term = input.value.trim();
    const request = ++revision;
    items.replaceChildren();
    if (!term) return show(false);
    show(true);
    status.textContent = "Searching…";
    panel.setAttribute("aria-busy", "true");
    try {
      const fuse = await loadEngine();
      if (request !== revision) return;
      const results = fuse.search(term);
      status.textContent = results.length
        ? `${results.length} ${results.length === 1 ? "result" : "results"}${results.length > 10 ? " (showing 10)" : ""}`
        : "No results found.";
      const fragment = document.createDocumentFragment();
      for (const { item } of results.slice(0, 10)) {
        const url = new URL(item.url, location.href);
        if (url.origin !== location.origin) continue;
        const row = document.createElement("li");
        row.className = "search-results__item";
        const title = document.createElement("h2");
        title.className = "title";
        const link = document.createElement("a");
        link.href = url.href;
        link.textContent = item.title;
        title.append(link);
        row.append(
          title,
          teaser((item.body || "").replace(/§/g, ""), term.split(/\s+/)),
        );
        const more = document.createElement("a");
        more.href = url.href;
        const label = document.createElement("i");
        label.textContent = "Read More →";
        more.append(label);
        row.append(more);
        fragment.append(row);
      }
      items.append(fragment);
    } catch {
      if (request === revision)
        status.textContent = "Search could not load. Try typing again.";
    } finally {
      if (request === revision) panel.removeAttribute("aria-busy");
    }
  }

  input.addEventListener("focus", () => {
    loadEngine().catch(() => {});
    if (input.value.trim()) search();
  });
  input.addEventListener("input", () => {
    revision++;
    clearTimeout(timer);
    if (!input.value.trim()) return close();
    timer = setTimeout(search, 150);
  });
  container.addEventListener("keydown", (event) => {
    if (event.key === "Escape") {
      input.focus();
      close();
    }
  });
  document.addEventListener("click", (event) => {
    if (!container.contains(event.target)) close();
  });
  container.addEventListener("focusout", (event) => {
    if (!container.contains(event.relatedTarget)) close();
  });
})();

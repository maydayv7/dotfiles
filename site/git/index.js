function getCookie(cookieHeader, name) {
  if (!cookieHeader) return null;
  const cookies = cookieHeader.split(";");

  for (const cookie of cookies) {
    const [k, ...v] = cookie.trim().split("=");
    if (k === name) return v.join("=");
  }
  return null;
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    // Theme Switching
    if (url.pathname === "/style.css") {
      const theme = getCookie(request.headers.get("Cookie"), "theme_color");
      if (["black", "blue"].includes(theme)) {
        const themeUrl = new URL(url);
        themeUrl.pathname = themeUrl.pathname.replace(
          "style.css",
          `style-${theme}.css`,
        );

        const themed = await env.ASSETS.fetch(new Request(themeUrl, request));

        if (themed.ok) {
          const headers = new Headers(themed.headers);
          headers.set("Vary", "Cookie");
          headers.set("Cache-Control", "private, no-cache");
          return new Response(themed.body, {
            status: themed.status,
            headers,
          });
        }
      }
    }

    // Serve assets
    const response = await env.ASSETS.fetch(request);
    if (url.pathname === "/style.css") {
      const headers = new Headers(response.headers);
      headers.set("Vary", "Cookie");
      headers.set("Cache-Control", "private, no-cache");
      return new Response(response.body, { status: response.status, headers });
    }
    return response;
  },
};

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (url.hostname === "www.maydayv7.cc") {
      url.hostname = "maydayv7.cc";
      url.protocol = "https:";
      return Response.redirect(url, 308);
    }
    // Curl
    const userAgent = request.headers.get("User-Agent") || "";
    if (userAgent.toLowerCase().startsWith("curl")) {
      if (url.pathname === "/") {
        url.pathname = "/curl.txt";
        const response = await env.ASSETS.fetch(new Request(url, request));
        const headers = new Headers(response.headers);
        headers.append("Vary", "User-Agent");
        return new Response(response.body, {
          status: response.status,
          headers,
        });
      }
    }

    // Serve Website
    const response = await env.ASSETS.fetch(request);
    if (
      response.ok &&
      /^\/processed_images\/[^/]+\.[a-f0-9]{16}\.[a-z0-9]+$/.test(url.pathname)
    ) {
      const headers = new Headers(response.headers);
      headers.set("Cache-Control", "public, max-age=31536000, immutable");
      return new Response(response.body, { status: response.status, headers });
    }
    if (url.pathname !== "/") return response;
    const headers = new Headers(response.headers);
    headers.append("Vary", "User-Agent");
    return new Response(response.body, { status: response.status, headers });
  },
};

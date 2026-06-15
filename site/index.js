export default {
  async fetch(request, env) {
    // Curl
    const userAgent = request.headers.get("User-Agent") || "";
    if (userAgent.toLowerCase().startsWith("curl")) {
      const url = new URL(request.url);
      if (url.pathname === "/") {
        url.pathname = "/curl.txt";
        return env.ASSETS.fetch(new Request(url.toString()));
      }
    }

    // Serve Website
    return env.ASSETS.fetch(request);
  },
};

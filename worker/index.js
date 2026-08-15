function withSecurityHeaders(response) {
  var headers = new Headers(response.headers);
  headers.set("Referrer-Policy", "strict-origin-when-cross-origin");
  headers.set("X-Content-Type-Options", "nosniff");
  headers.set("X-Frame-Options", "SAMEORIGIN");

  return new Response(response.body, {
    status: response.status,
    statusText: response.statusText,
    headers: headers,
  });
}

async function fetchStaticAsset(request, env) {
  var response = await env.ASSETS.fetch(request);
  if (response.status !== 404) return response;

  var url = new URL(request.url);
  var hasFileExtension = /\/[^/]+\.[^/]+$/.test(url.pathname);
  if (!hasFileExtension) {
    url.pathname = url.pathname.replace(/\/$/, "") + "/index.html";
    return env.ASSETS.fetch(new Request(url.toString(), request));
  }

  return response;
}

export default {
  async fetch(request, env) {
    if (request.method !== "GET" && request.method !== "HEAD") {
      return new Response("Method Not Allowed", {
        status: 405,
        headers: { Allow: "GET, HEAD" },
      });
    }

    var response = await fetchStaticAsset(request, env);
    return withSecurityHeaders(response);
  },
};

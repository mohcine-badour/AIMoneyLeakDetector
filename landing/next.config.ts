import path from "node:path";
import type { NextConfig } from "next";

// The site is fully static: every page is rendered at build time into `out/`.
// Nothing needs a server, so it can be hosted on any static host.
const nextConfig: NextConfig = {
  output: "export",
  // /privacy -> /privacy/index.html, which every static host serves without rewrites.
  trailingSlash: true,
  images: {
    // The image optimizer needs a server. The screenshots in public/screens are
    // already resized WebP files.
    unoptimized: true,
  },
  turbopack: {
    // This folder is the project root (it sits inside the app's repository).
    root: path.join(__dirname),
    rules: {
      "*.css": {
        loaders: ["@tailwindcss/turbopack"],
        as: "*.css",
      },
    },
  },
};

export default nextConfig;

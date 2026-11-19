// Simple line icons drawn for this page (24×24, currentColor stroke).

import type { SVGProps } from "react";

const base: SVGProps<SVGSVGElement> = {
  width: 24,
  height: 24,
  viewBox: "0 0 24 24",
  fill: "none",
  stroke: "currentColor",
  strokeWidth: 1.7,
  strokeLinecap: "round",
  strokeLinejoin: "round",
  "aria-hidden": true,
};

export const IconStack = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <rect x="3" y="4" width="18" height="5" rx="2" />
    <rect x="3" y="11" width="18" height="5" rx="2" />
    <path d="M6 20h12" />
  </svg>
);

export const IconBell = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <path d="M6 9a6 6 0 1 1 12 0c0 5 2 6.5 2 6.5H4S6 14 6 9Z" />
    <path d="M10 19a2 2 0 0 0 4 0" />
  </svg>
);

export const IconHourglass = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <path d="M7 3h10M7 21h10" />
    <path d="M8 3c0 4 8 5 8 9s-8 5-8 9M16 3c0 4-8 5-8 9s8 5 8 9" />
  </svg>
);

export const IconScan = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <path d="M4 8V6a2 2 0 0 1 2-2h2M16 4h2a2 2 0 0 1 2 2v2M20 16v2a2 2 0 0 1-2 2h-2M8 20H6a2 2 0 0 1-2-2v-2" />
    <path d="M8 9h8M8 12h6M8 15h4" />
  </svg>
);

export const IconChart = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <path d="M4 20V10M10 20V4M16 20v-7M22 20H2" />
  </svg>
);

export const IconDoor = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <path d="M14 4h4a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2h-4" />
    <path d="M10 16l4-4-4-4M14 12H4" />
  </svg>
);

export const IconScale = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <path d="M12 4v16M7 20h10M5 8h14" />
    <path d="M5 8l-3 6a3 3 0 0 0 6 0L5 8ZM19 8l-3 6a3 3 0 0 0 6 0l-3-6Z" />
  </svg>
);

export const IconLock = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <rect x="4" y="10" width="16" height="11" rx="2.5" />
    <path d="M8 10V7a4 4 0 0 1 8 0v3M12 14.5v2.5" />
  </svg>
);

export const IconCheck = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <path d="M5 12.5l4.5 4.5L19 7.5" />
  </svg>
);

export const IconArrowDown = (p: SVGProps<SVGSVGElement>) => (
  <svg {...base} {...p}>
    <path d="M12 4v15M6 13l6 6 6-6" />
  </svg>
);

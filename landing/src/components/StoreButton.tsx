import Image from "next/image";
import Magnet from "@/components/reactbits/Magnet";
import { APP_STORE_URL } from "@/lib/site";

/** The download button, pulled slightly toward the pointer (React Bits Magnet). */
export default function StoreButton({ className = "", onPaper = false }: { className?: string; onPaper?: boolean }) {
  return (
    <Magnet padding={56} magnetStrength={5} maxOffset={10} wrapperClassName={className}>
      <a
        href={APP_STORE_URL}
        className={`store-badge ${onPaper ? "on-paper" : ""}`}
        rel="noopener"
        aria-label="Download Kichta on the App Store"
      >
        <Image src="/app-icon.png" alt="" width={34} height={34} className="rounded-[9px]" priority />
        <span className="flex flex-col leading-none text-left">
          <span className="text-[11px] font-medium text-white/70">Download on the</span>
          <span className="mt-1 text-[19px] font-semibold tracking-tight">App Store</span>
        </span>
      </a>
    </Magnet>
  );
}

import Image from "next/image";
import GradientText from "@/components/reactbits/GradientText";
import Reveal from "@/components/Reveal";
import StoreButton from "@/components/StoreButton";
import { MIN_IOS, TAGLINE } from "@/lib/site";

export default function FinalCta() {
  return (
    <section className="px-3 pb-3 sm:px-4 sm:pb-4">
      <div className="relative isolate mx-auto max-w-[1400px] overflow-hidden rounded-[36px] bg-night py-24 text-center text-white sm:rounded-[56px] sm:py-32">
        <div
          aria-hidden="true"
          className="absolute bottom-[-260px] left-1/2 -z-10 h-[520px] w-[900px] -translate-x-1/2 rounded-full bg-glow/30 blur-[130px]"
        />
        <Reveal className="container-page flex flex-col items-center" stagger={0.1}>
          <Image
            src="/app-icon.png"
            alt="Kichta app icon"
            width={96}
            height={96}
            className="rounded-[24px] shadow-[0_20px_60px_-10px_rgb(79_124_255/0.6)]"
          />
          <h2 className="mt-10 max-w-[820px] text-[clamp(2.3rem,6vw,4.6rem)] font-semibold leading-[1.02] tracking-[-0.035em]">
            Know before{" "}
            <GradientText
              colors={["#8fb0ff", "#4f7cff", "#b6a8ff", "#8fb0ff"]}
              animationSpeed={7}
              className="serif-accent !inline-flex pr-1"
            >
              you&rsquo;re charged.
            </GradientText>
          </h2>
          <p className="mt-6 max-w-[520px] text-[17px] leading-relaxed text-white/60">{TAGLINE}</p>
          <StoreButton className="mt-10" />
          <p className="mt-5 text-[13px] text-white/45">Free · iPhone &amp; iPad · iOS {MIN_IOS} or later</p>
        </Reveal>
      </div>
    </section>
  );
}

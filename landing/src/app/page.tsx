import Faq from "@/components/Faq";
import Features from "@/components/Features";
import FinalCta from "@/components/FinalCta";
import Hero from "@/components/Hero";
import Insights from "@/components/Insights";
import Privacy from "@/components/Privacy";
import Reminders from "@/components/Reminders";
import SiteFooter from "@/components/SiteFooter";
import SiteHeader from "@/components/SiteHeader";
import Statement from "@/components/Statement";

export default function Home() {
  return (
    <>
      <SiteHeader />
      <main id="main">
        <Hero />
        <Statement />
        <Reminders />
        <Features />
        <Insights />
        <Privacy />
        <Faq />
        <FinalCta />
      </main>
      <SiteFooter />
    </>
  );
}

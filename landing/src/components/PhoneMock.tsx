import { EXAMPLE_MONTHLY, EXAMPLE_UPCOMING, money, renewsIn } from "@/lib/example";

/**
 * An illustration of Kichta's Home tab, drawn in HTML with the app's own palette and
 * labels ("Good morning", "Monthly spending", "Upcoming payments"). Example data only.
 */
export default function PhoneMock({ className = "" }: { className?: string }) {
  const upcoming = EXAMPLE_UPCOMING.slice(0, 4);

  return (
    <div
      className={`relative w-[300px] rounded-[52px] bg-[#16181f] p-[10px] shadow-[0_40px_120px_-30px_rgb(79_124_255/0.55),0_0_0_1px_rgb(255_255_255/0.12)_inset] ${className}`}
      role="img"
      aria-label="Illustration of the Kichta Home screen with example subscriptions: monthly spending and upcoming payments."
    >
      <div className="relative overflow-hidden rounded-[43px] bg-paper text-ink" aria-hidden="true">
        {/* Status bar */}
        <div className="flex items-center justify-between px-7 pt-3.5 pb-1 text-[12px] font-semibold">
          <span>9:41</span>
          <span className="h-[26px] w-[86px] rounded-full bg-black" />
          <span className="flex items-center gap-1">
            <span className="inline-block h-[9px] w-[15px] rounded-[3px] border border-ink/70 p-[1px]">
              <span className="block h-full w-3/4 rounded-[1px] bg-ink" />
            </span>
          </span>
        </div>

        <div className="px-4 pt-3 pb-4">
          <p className="text-[12px] text-ink-2">Good morning</p>
          <p className="mt-0.5 text-[20px] font-semibold tracking-tight">Home</p>

          {/* Monthly hero card */}
          <div className="mt-3 rounded-[20px] bg-ink p-4 text-white">
            <p className="text-[11px] text-white/60">Monthly spending</p>
            <p className="mt-1 text-[30px] font-semibold leading-none tracking-tight">{money(EXAMPLE_MONTHLY)}</p>
            <div className="mt-3 flex items-center justify-between border-t border-white/10 pt-2.5 text-[11px]">
              <span className="text-white/60">Per year</span>
              <span className="font-medium">{money(EXAMPLE_MONTHLY * 12)}</span>
            </div>
          </div>

          {/* Upcoming payments */}
          <div className="mt-4 flex items-baseline justify-between">
            <p className="text-[13px] font-semibold">Upcoming payments</p>
            <p className="text-[11px] text-ink-2">This month</p>
          </div>
          <ul className="mt-2 divide-y divide-line rounded-[18px] bg-card px-3 shadow-[0_1px_0_rgb(0_0_0/0.03)]">
            {upcoming.map((sub) => (
              <li key={sub.name} className="flex items-center gap-2.5 py-2.5">
                <span className="tile h-8 w-8 text-[13px]" style={{ background: sub.color }}>
                  {sub.letter}
                </span>
                <span className="min-w-0 flex-1">
                  <span className="block truncate text-[13px] font-medium">{sub.name}</span>
                  <span className="block text-[11px] text-ink-2">Renews {renewsIn(sub.days)}</span>
                </span>
                <span className="text-[13px] font-semibold tabular-nums">{money(sub.amount)}</span>
              </li>
            ))}
          </ul>

          {/* Trial */}
          <div className="mt-3 flex items-center gap-2.5 rounded-[16px] bg-warn-bg px-3 py-2.5 text-warn">
            <span className="tile h-8 w-8 bg-[#b7791f] text-[13px]">D</span>
            <span className="flex-1">
              <span className="block text-[13px] font-medium">Design app trial</span>
              <span className="block text-[11px] opacity-80">Ends in 2 days</span>
            </span>
            <span className="rounded-full bg-white/70 px-2 py-0.5 text-[10px] font-semibold">Trial</span>
          </div>
        </div>

        {/* Tab bar */}
        <div className="grid grid-cols-4 border-t border-line bg-card/90 px-2 pt-2 pb-5 text-center text-[10px] text-ink-3">
          {["Home", "Subscriptions", "Insights", "Settings"].map((tab, i) => (
            <span key={tab} className={i === 0 ? "font-semibold text-ink" : ""}>
              <span className={`mx-auto mb-1 block h-[18px] w-[18px] rounded-[6px] ${i === 0 ? "bg-ink" : "bg-muted-bg"}`} />
              {tab}
            </span>
          ))}
        </div>
      </div>
    </div>
  );
}

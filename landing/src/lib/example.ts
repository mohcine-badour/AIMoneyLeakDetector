// Example data for the illustrations. Generic service names only: the page never shows
// third-party brands. Labels mirror the app (lib/core/constants/app_strings.dart).

export type ExampleSub = {
  name: string;
  letter: string;
  color: string;
  amount: number;
  category: string;
  /** Days until the next renewal. */
  days: number;
};

export const EXAMPLE_SUBS: ExampleSub[] = [
  { name: "Gym", letter: "G", color: "#e0703a", amount: 34, category: "Fitness", days: 3 },
  { name: "Streaming", letter: "S", color: "#c8364b", amount: 15.49, category: "Entertainment", days: 1 },
  { name: "Movie club", letter: "M", color: "#4f46b8", amount: 11.99, category: "Entertainment", days: 9 },
  { name: "Music", letter: "♪", color: "#1f9d6b", amount: 10.99, category: "Music", days: 12 },
  { name: "News", letter: "N", color: "#2b2b2b", amount: 8, category: "News", days: 17 },
  { name: "Cloud storage", letter: "C", color: "#3b82f6", amount: 2.99, category: "Storage", days: 21 },
];

/** Same wording as the app: "renews tomorrow", "renews in 3 days". */
export const renewsIn = (days: number) => (days === 1 ? "tomorrow" : `in ${days} days`);

export const EXAMPLE_UPCOMING = [...EXAMPLE_SUBS].sort((a, b) => a.days - b.days);

export const EXAMPLE_MONTHLY = EXAMPLE_SUBS.reduce((sum, s) => sum + s.amount, 0);

export const EXAMPLE_BY_CATEGORY = Object.entries(
  EXAMPLE_SUBS.reduce<Record<string, number>>((acc, s) => {
    acc[s.category] = (acc[s.category] ?? 0) + s.amount;
    return acc;
  }, {}),
)
  .map(([category, amount]) => ({ category, amount, share: amount / EXAMPLE_MONTHLY }))
  .sort((a, b) => b.amount - a.amount);

export const money = (value: number) =>
  value.toLocaleString("en-US", { style: "currency", currency: "USD", minimumFractionDigits: 2 });

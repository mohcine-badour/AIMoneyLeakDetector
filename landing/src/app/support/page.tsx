import type { Metadata } from "next";
import DocPage from "@/components/DocPage";
import { MIN_IOS, PRIVACY_URL, SUPPORT_EMAIL, TERMS_URL } from "@/lib/site";

export const metadata: Metadata = {
  title: "Support · Kichta",
  description: "Help with Kichta: common questions, troubleshooting and how to contact support.",
  alternates: { canonical: "/support/" },
};

// Same answers as the previous support page (docs/support.html) and the app.
const QUESTIONS: { q: string; a: string }[] = [
  { q: "Do I need to create an account?", a: "No. Kichta doesn't need an account or a sign-in." },
  {
    q: "Does Kichta connect to my bank account?",
    a: "No. Kichta doesn't connect to bank accounts or read your banking information. You add subscriptions yourself, or scan a receipt and confirm the details.",
  },
  {
    q: "Where is my subscription information stored?",
    a: "On your device, in an encrypted database. There's no Kichta cloud account and no server copy of your list.",
  },
  {
    q: "Does Kichta cancel subscriptions for me?",
    a: "No. Kichta helps you keep track of renewal dates and reminds you before you're charged. Its cancellation guide shows the steps and can draft a message, but you cancel with the merchant yourself.",
  },
  {
    q: "Can I track free trials?",
    a: "Yes. Add a trial with its end date and Kichta reminds you before it turns into a paid subscription.",
  },
  {
    q: "How do I add a subscription?",
    a: "Open Kichta, tap the add button, then pick a service from the list or add a custom subscription. Enter the price, billing cycle and next renewal date. You can also scan a receipt.",
  },
  {
    q: "How do reminders work?",
    a: "Kichta schedules local notifications on your device 3 days, 24 hours and 2 hours before a renewal or the end of a trial. You can turn reminders off in Settings.",
  },
  {
    q: "How do I delete my data?",
    a: "Open Settings and tap Delete my data. This removes your subscriptions, trials, usage counts, onboarding answers, reminder preference and other local app data from the device. Uninstalling Kichta removes it too.",
  },
];

const TROUBLESHOOTING: { title: string; steps: string[] }[] = [
  {
    title: "The app isn't behaving as expected",
    steps: [
      "Make sure you're on the latest version of Kichta.",
      "Close and reopen the app.",
      "Restart your device if needed.",
      "If the problem continues, contact support.",
    ],
  },
  {
    title: "A reminder doesn't appear",
    steps: [
      "Check that reminders are on in Kichta's Settings.",
      "Check that notifications are allowed for Kichta in iOS Settings.",
      "Make sure the subscription or trial has a valid date.",
    ],
  },
];

export default function SupportPage() {
  return (
    <DocPage
      eyebrow="Support"
      title="Kichta Support"
      intro="Answers to common questions, a few fixes, and how to reach us."
    >
      <h2 id="contact">Contact support</h2>
      <p>
        Found a problem or have a question or feedback? Email{" "}
        <a href={`mailto:${SUPPORT_EMAIL}`}>{SUPPORT_EMAIL}</a>. Kichta is published by Mohcine Badour.
      </p>
      <p>
        When you report a bug, please include your device model, iOS version, Kichta version and a short
        description of what happened.
      </p>

      <h2 id="questions">Common questions</h2>
      {QUESTIONS.map(({ q, a }) => (
        <div key={q}>
          <h3>{q}</h3>
          <p>{a}</p>
        </div>
      ))}

      <h2 id="troubleshooting">Troubleshooting</h2>
      {TROUBLESHOOTING.map(({ title, steps }) => (
        <div key={title}>
          <h3>{title}</h3>
          <ul>
            {steps.map((s) => (
              <li key={s}>{s}</li>
            ))}
          </ul>
        </div>
      ))}

      <h2 id="about">About Kichta</h2>
      <p>
        Kichta works on iPhone and iPad with iOS {MIN_IOS} or later. Read the <a href={PRIVACY_URL}>Privacy Policy</a>{" "}
        and the <a href={TERMS_URL}>Terms of Use</a>.
      </p>
    </DocPage>
  );
}

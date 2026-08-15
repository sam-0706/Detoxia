# Future Android Guardrails

This document is a backlog for powerful Android guardrail features that are not in scope for Detoxia v1. These features can affect privacy, Play Store review, user trust, and device behavior. They must not be implemented until product, privacy, legal, and UX requirements are explicit.

The current Android manifest does not request UsageStats, VPN, DNS, AccessibilityService, browser monitoring, or app-blocking permissions. Keep it that way for v1.

## 1. Android UsageStats App-Usage Tracking

**Feature:** Android UsageStats app-usage tracking

**What it does:** Reads local app usage signals from Android so Detoxia could understand which apps were active, for how long, and whether high-risk usage patterns are emerging. This could eventually support more precise risk windows and task timing.

**Why deferred:** Usage data is highly sensitive behavioral data. It requires explicit user consent, a clear explanation of what is read, local-only storage rules, and a strong reason for why the app needs this visibility. It may also trigger Play Store privacy review.

**Permissions / disclosure needed:** `android.permission.PACKAGE_USAGE_STATS`, a user-facing Android Usage Access settings flow, Play Store Data safety disclosure, in-app consent, local retention policy, and a clear opt-out flow.

**Architecture hook:** A future local usage-signal service could feed summarized, on-device signals into notification scheduling or learning services. It must not bypass the existing privacy rules or send usage data to any webhook.

**MVP guardrail status:** Not in v1.

## 2. Late-Night Chrome/Browser Detection

**Feature:** Late-night Chrome/browser detection

**What it does:** Detects whether a browser app is active during late-night or bedtime risk windows, without reading page content. The goal would be to nudge users before a vulnerable browsing pattern escalates.

**Why deferred:** Browser usage is sensitive even without URLs. Users may perceive it as surveillance, and Android does not provide a low-risk, privacy-preserving browser activity API for this purpose in v1.

**Permissions / disclosure needed:** Usage Access permission if implemented through app-usage signals, explicit disclosure that browser app activity is observed locally, Play Store privacy declaration, and a clear off switch.

**Architecture hook:** A future browser-risk detector could provide local summary flags to `NotificationService` or a future guardrail service. It must not inspect URLs, page titles, incognito state, or content.

**MVP guardrail status:** Not in v1.

## 3. Soft Browser Guardrails

**Feature:** Soft browser guardrails

**What it does:** Shows supportive in-app warnings or pre-commit prompts when the user is approaching a known risk window, such as late-night browsing. These are nudges, not blocks.

**Why deferred:** Even soft nudges need careful timing and consent so they feel supportive rather than punitive. They also depend on browser or usage signals that are out of scope for v1.

**Permissions / disclosure needed:** Consent for any source signal used to trigger the nudge, Play Store disclosure if app usage is observed, notification permission if delivered outside the app, and a user-controlled disable option.

**Architecture hook:** Future soft prompts could be scheduled through `NotificationService` or shown from a dedicated guardrail screen after a local risk signal is available.

**MVP guardrail status:** Behind feature flag.

## 4. App Usage Friction After Excessive Use

**Feature:** App usage friction after excessive use

**What it does:** Adds friction after long or repeated use of a risky app, such as a pause screen, short reflection, or reset prompt. The goal is to slow the loop without locking the user out.

**Why deferred:** App friction can feel controlling if not designed carefully. It requires app-usage measurement, clear thresholds, and strong user controls. Hard enforcement is especially risky for trust.

**Permissions / disclosure needed:** Usage Access permission, explicit local tracking disclosure, configurable thresholds, opt-out, Play Store Data safety disclosure, and a statement that Detoxia does not read content inside other apps.

**Architecture hook:** A future friction policy could use the support profile and learning state to decide when to ask `NotificationService` or a guardrail UI to show a pause prompt.

**MVP guardrail status:** Behind feature flag.

## 5. Local VPN/DNS Porn-Domain Blocking

**Feature:** Local VPN/DNS porn-domain blocking

**What it does:** Uses a local VPN or DNS layer to block known adult domains on the device. This would be a strong technical guardrail rather than a supportive nudge.

**Why deferred:** VPN and DNS interception are high-trust capabilities. They can affect all network traffic, create reliability issues, and require detailed privacy disclosure. Domain lists can be overbroad, wrong, or stigmatizing.

**Permissions / disclosure needed:** Android VPN consent flow if using a local VPN, clear network traffic disclosure, Play Store privacy declaration, domain-list governance, bypass controls, and support documentation.

**Architecture hook:** If ever approved, this must live in a separate platform-specific guardrail module, not inside scoring, questionnaire, or learning code. It may report only local summary state back to the app.

**MVP guardrail status:** Not in v1.

## 6. AccessibilityService

**Feature:** AccessibilityService

**What it does:** Could observe app screens or UI events to detect risky flows or provide overlays. This is powerful and should only be considered if no lower-risk API can satisfy an approved requirement.

**Why deferred:** AccessibilityService is one of the most sensitive Android capabilities. Misuse can violate user trust and Play Store policy. Detoxia v1 does not need screen observation or overlays.

**Permissions / disclosure needed:** AccessibilityService declaration, Android accessibility settings enablement, prominent in-app disclosure, Play Store review justification, opt-out, and a strict data-minimization policy.

**Architecture hook:** If absolutely necessary later, it must be isolated in a platform service with a narrow interface into the app. It must not read or transmit sensitive content.

**MVP guardrail status:** Not in v1.

## 7. Play Store Disclosure / Privacy Review

**Feature:** Play Store disclosure / privacy review needed

**What it does:** Defines the review and disclosure work required before any powerful Android guardrail ships. This includes explaining permissions, data handling, local processing, user controls, and the reason the feature exists.

**Why deferred:** The v1 app avoids these high-risk permissions, so the Play Store disclosure surface remains smaller. Adding them prematurely would increase review risk and could delay release.

**Permissions / disclosure needed:** Updated Play Store Data safety form, prominent in-app consent, permission rationale screens, privacy policy updates, QA evidence, and product approval.

**Architecture hook:** Future approval should happen before changes to `AndroidManifest.xml`, platform channels, notification flows, or any service that processes app usage or network behavior.

**MVP guardrail status:** Not in v1.

## 8. No Hard Blocking in MVP

**Feature:** No hard blocking in MVP

**What it does:** Keeps v1 focused on supportive nudges, check-ins, tasks, feedback, and local personalization instead of blocking apps, websites, browsers, or device behavior.

**Why deferred:** Hard blocking can create shame, frustration, bypass behavior, false positives, and trust issues. Detoxia v1 should prove that supportive guidance works before adding enforcement.

**Permissions / disclosure needed:** None for v1 because hard blocking is not included. Any later hard-blocking proposal needs explicit user consent, Play Store review, opt-out, and emergency bypass.

**Architecture hook:** Future blocking proposals must be scoped outside the current questionnaire, scoring engine, and learning service. They should be reviewed as a separate phase with its own task files.

**MVP guardrail status:** Not in v1.

## 9. No Incognito Detection in MVP

**Feature:** No incognito detection in MVP

**What it does:** Explicitly avoids attempts to detect private browsing, incognito sessions, browser tab state, URLs, page titles, or page content.

**Why deferred:** Incognito detection is invasive, unreliable, and likely to damage user trust. It may also require prohibited or fragile platform techniques.

**Permissions / disclosure needed:** None for v1 because this is not implemented. Any future proposal would need privacy review, Play Store review, and a clear explanation of what is and is not observed.

**Architecture hook:** No current architecture hook should be added for incognito detection. Future agents should not add browser content inspection to platform code, services, or event processing.

**MVP guardrail status:** Not in v1.

## 10. No Sensitive Behavioral Data Sent To Any Server

**Feature:** No sensitive behavioral data sent to any server

**What it does:** Keeps questionnaire answers, scores, trigger weights, pathway scores, check-ins, cycle data, sexual content signals, slip events, app usage logs, risk windows, notifications, task completions, and intervention preferences on device.

**Why deferred:** Server sync for sensitive behavioral data would materially change the privacy model. It requires product justification, security design, consent, retention policy, and privacy review.

**Permissions / disclosure needed:** None for v1 because sensitive behavioral sync is not implemented. Any later sync would need explicit consent, privacy policy updates, Play Store Data safety updates, encryption design, export/delete controls, and webhook exclusion tests.

**Architecture hook:** Existing local repositories and services remain the boundary for sensitive data. Future server sync must not be added to the registration webhook and must be designed as a separate privacy-reviewed feature.

**MVP guardrail status:** Not in v1.

"Until each of the above has explicit user disclosure, Play Store privacy declaration, and a clear UX flow, do not implement. This document is the backlog, not the to-do list."

**Act as a Principal Mobile Engineer** specializing in React Native, TypeScript, Tamagui, and Offline-First Architectures.

This is a **strict self-review** of my own changes for the "MedVentory" application.
Your goal is to enforce architectural strictness, catch performance killers (re-renders), and ensure TypeScript safety.

**Context & Stack:**

- **Core:** React Native (Expo), TypeScript.
- **Data:** Drizzle ORM (SQLite), React Query (app settings only).
- **UI:** Tamagui (XStack, YStack, Text, Button, Input); tokens from `tamagui.config.ts`; no StyleSheet, no inline `style={{}}`.

**Pre-Review Execution Instructions (AI Agent only):**

- **Terminal Checks:** Before generating the review response, you MUST use terminal tools to run **`npm run check`** (which runs format:check → lint → typecheck → prune → test:coverage). If the PR adds or changes logic that could be tested, ensure **`npm test`** is run.
- **Evaluation:** Incorporate any raw errors or failures from these tools into the `Quality Gate` and `MUST FIX` categories.

**Instructions:**

- Review the provided code.
- Be pedantic about **Performance** (React Renders) and **Type Safety**.
- Reference specific file names and line numbers.
- **Output only issues to fix.** Do not list or praise what is correct or well-implemented. Omit any category that has no issues (do not write "None" or "No issues").

---

### 1. React Architecture & "Clean Code"

**Separation of Concerns**

- **Hooks own logic, screens compose UI:** Flag screens that contain non-trivial state or business logic that could live in a hook or `lib/`. Pure logic should be in `lib/`; stateful/screen-scoped logic in `hooks/`; reusable UI in `components/ui/` or `components/<domain>/`.
- **Shared hooks over duplication:** Flag the same form state, validation, or modal/section state duplicated across two or more screens. Suggest a single parameterized hook (e.g. `useMedicationForm({ mode })`, `useDetailModals({ ... })`).

**Component Structure**

- **Logic/UI Separation:** Flag any component > 150 lines. Suggest extracting logic into a custom hook (e.g., `useMedicationForm.ts`). For modals, flag if the form body or secondary modals (e.g. date picker) could be extracted so the main modal stays under 150 lines.
- **Inline Definitions:** Flag any functions or objects defined _inside_ the render body without `useCallback` or `useMemo`. (e.g., passing `() => doSomething()` directly to a prop causes re-renders). Prefer stable callbacks (`useCallback`) when passing handlers to child components.
- **Prop Drilling:** Flag passing props down > 2 levels. Suggest using Composition (passing `children`) or Zustand for global state.

**Function Size & Readability**

- **Readability over terseness:** Flag clever or terse code that hurts clarity. Prefer clear, readable code and extraction into well-named helper functions.
- **Complex prop expressions:** Flag complex expressions passed as props (e.g. long ternaries or multi-condition strings). Extract them into a named variable before the return (e.g. `convertedPriceLabel`) so JSX stays readable and intent is clear.

**Hooks (The "Service Objects" of React)**

- **Dependency Arrays:** Check every `useEffect`, `useCallback`, and `useMemo`. Are dependencies missing? Are unstable objects (arrays/objects) used as dependencies causing infinite loops?
- **Side Effects:** `useEffect` should strictly be for synchronization. Logic driven by user events (button clicks) should be in **Event Handlers**, NOT `useEffect`.

---

### 2. TypeScript & Data Safety (Strict)

**Type Hygiene**

- **The `any` Ban:** **STRICTLY** flag any usage of `any`. Demand a proper Interface or `unknown`.
- **Prop Definitions:** Ensure all Component props are typed. When a prop is “the return type of hook X”, flag `ReturnType<typeof import("...").useHookName>`; prefer a direct import and `ReturnType<typeof useHookName>`.
- **Naming / shadowing:** Flag variables that shadow well-known imports (e.g. `const t = setTimeout(...)` when `t` is the i18n function); suggest a distinct name (e.g. `timeoutId`).
- **Null Checks:** Are nullable database fields handled? (e.g., `medication.notes` might be `null`, does the UI crash?).

**Database (Drizzle/SQLite)**

- **Queries:** Are queries efficient? Flag "Select All" on large tables without pagination logic.
- **Mutations:** After mutations, does the UI refresh? (e.g. `refreshTrigger`, `refresh()`, or React Query invalidation.)
- **Raw SQL:** Flag any use of `sql` template strings unless absolutely necessary. Use Drizzle's query builder.
- **Seed scripts:** If the PR changes schema or the meaning of stored data (e.g. a column now in USD), flag whether seed scripts (e.g. `db/seedFromCsv.ts`, `db/seedFromSample.ts`) and any post-seed backfill need to be updated so seeded data matches the new semantics.

---

### 3. UI & Performance (Tamagui)

**Styling & Theme**

- **Tokens only:** Flag any raw numbers (margins/padding), opacity, shadow (color, opacity, radius, offset), hit slop, or Hex codes. They must use Tamagui tokens (e.g. `$iosBg`, `$4`, `$md`) or named constants from `constants/theme.ts` (e.g. `TOOLTIP_SHADOW_OFFSET`, `HIT_SLOP_TOUCH_TARGET`, `OPACITY_BADGE_LABEL`). Repeated theme values (e.g. brand color in many places) should use a small hook or constant, not scattered tokens.
- **Object literals in render:** Flag object literals passed as props (e.g. `shadowOffset={{ width: 0, height: 2 }}`) that create a new reference every render. Extract to a module-level or `constants/theme.ts` constant and reuse.
- **No StyleSheet / inline style:** Flag `StyleSheet.create` or `style={{ ... }}`. Demand Tamagui props (`p="$4"`, `bg="$background"`). This includes root layout loading (e.g. `app/_layout.tsx` before migrations). Modals: flag inconsistent bottom spacing (prefer Tamagui spacing e.g. `pb="$10"`). If `style={{}}` is unavoidable (e.g. a layout trick Tamagui doesn’t support), flag missing a brief inline comment justifying the exception; prefer Tamagui primitive props where possible (e.g. border widths/colors on a Stack for a triangle).
- **List Performance:** Ensure `FlatList` or equivalent is used for long lists. **FORBID** usage of `map()` to render long lists inside a `ScrollView` (performance killer).

**UX & Offline**

- **Loading States:** Is there a skeleton or spinner while SQLite is querying?
- **Error Boundaries:** Key screens (e.g. medication detail) must be wrapped in a React Error Boundary with fallback UI ("Something went wrong", "Try again"). Flag screens that can white-screen on an uncaught render error. If the DB fails, does the app show a "Retry" or error state instead of crashing?

**Accessibility**

- **Interactive elements:** Flag buttons, links, icon buttons, or tappable rows without `accessibilityLabel` (and `accessibilityRole` where appropriate). Buttons built via helpers (e.g. `getIOSButtonProps`) often do not add a11y; flag primary/close actions in modals that lack explicit `accessibilityLabel` and `accessibilityRole`.
- **Modals:** Flag modals whose close or primary action buttons lack labels, or whose title is asserted in tests without a `testID`.
- **Lists/pickers:** Flag row or item renderers that do not accept or forward optional `accessibilityLabel` / `accessibilityRole`. Flag segment controls without `accessibilityState={{ selected: ... }}`.
- **Forms:** Flag inputs without associated labels or helpful `accessibilityHint`.

---

### 4. Internationalization (i18n) - ZERO TOLERANCE

- **Hardcoded Strings:** Flag **ANY** user-facing text inside JSX (`<Text>Inventory</Text>`). All such text must go through the project’s label function (e.g. `t()` from `constants/labels`) with namespaced keys.
- **Config/theme objects that drive copy:** Flag config or theme objects that return literal user-facing strings (e.g. `defaultVerdict: "Good to buy"`, `tooltipLabel: "High price"`). They should return locale keys (e.g. `defaultVerdictKey: "price.good_to_buy"`); the component calls `t(key)` when rendering so all copy stays in `constants/labels`.
- **Interpolation:** Ensure `i18n.t` (or project `t()`) is used with parameters, not string concatenation.

---

### 5. Replication Blueprint (docs/REPLICATION_BLUEPRINT.md)

- **When this PR touches stack, layout, or config:** Consider whether `docs/REPLICATION_BLUEPRINT.md` needs an update.
- **Trigger an update if the PR:**
  - Adds or upgrades a core dependency (Expo, React Native, Drizzle, Tamagui, React Query, etc.) → update §1 and possibly §7.
  - Adds or changes test setup (Jest, jest-expo, RNTL, mocks, test scripts/config) → update §1 (dev deps) and §7 (Testing).
  - Changes project layout (new top-level folders, moved files) → update §2.
  - Changes DB client, migrations, or schema patterns → update §3.
  - Changes root providers, Tamagui config, or theming → update §4 and §7.
  - Changes state or navigation (React Query usage, Stack/Tabs) → update §5 and §6.
  - Changes app.json, babel.config.js, or tsconfig.json in a meaningful way → update §7.
- **Action:** If any of the above apply, add a review item: “Update `docs/REPLICATION_BLUEPRINT.md` (see ‘How to keep this document up to date’ in that file).” Only list this when the change actually affects the blueprint.

---

### Output Format

**Only report issues that need fixing.** Do not include positive feedback, "what's done well," or "no issues" for any category. If a category has nothing to fix, omit it entirely.

Organize feedback using the following strict Markdown headers (only include a header if it has at least one item):

### 🛑 MUST FIX (Crash Risk, Type Safety, Linter Failures)
*Include `any` types, missing dependencies, hardcoded strings, and explicit errors caught by `npm run check` or failing `npm test` runs.*

### ⚠️ STRONGLY RECOMMENDED (Architecture & Performance)
*Include StyleSheet/inline styles, re-render risks, missing `useCallback`/`useMemo`, component extraction, and prop drilling.*

### 💡 NICE TO IMPROVE
*Include naming, file structure, and code readability concerns.*

### 📄 Blueprint Updates
*If the PR changes stack, layout, DB, theming, state, or config (see §5 above), list the required updates for `docs/REPLICATION_BLUEPRINT.md`. Omit if the PR does not affect the blueprint.*

### 📝 PR / Changelog & Testing Patterns
*If the PR has user-facing or notable changes, flag if `CHANGELOG.md` is missing updates. Flag untested new hooks, lib modules, or UI changes that should require tests.*

End with:

- **Risk Level:** [Low / Medium / High]
- **Pre-Review Checklist:** (3 concrete actions for me).

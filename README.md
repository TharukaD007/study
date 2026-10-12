# Daymark (Study OS layout), updated build

Your original dashboard (Dashboard, Calendar, Planner, Focus studio, Study log, Subjects, Past papers, Analytics, Revision wheel, Habits, Goals, Notes vault, Workout, Reset & fitness, Settings) with these changes:

## Fixes
- **Dates now use your local time zone.** The old code used UTC (`toISOString`), which in Sri Lanka (UTC+5:30) put calendar cells, streaks and "today" on the wrong day, especially between midnight and 5:30 am.
- **Recurring tasks**: a "Repeats" option (daily / weekdays / weekly) on the planner form. Copies are generated for the next 60 days, even if the original date is in the past. Deleting one copy skips that date; deleting the original removes its upcoming copies.
- **Habit notes**: a ✎ button on each habit adds an optional note for the selected day (why it was missed, what triggered a slip).
- **Safer loading**: every save, import and cloud pull is rebuilt through one normaliser (correct shapes, clamped numbers, sanitised ids). A save that cannot be parsed is kept under `daymark_rebuilt_v1_unreadable` instead of being overwritten.
- **Import**: validates the file shape, shows what it contains, and downloads a backup of your current data before replacing it. Reset also downloads a backup first. Exports are now wrapped with a format/version header; old plain exports still import.
- **Timer** now runs off the clock, so it stays accurate in background tabs and on phones.

## New
- **Exam countdown** in the top bar and on Settings (days and weeks; handles empty or past dates).
- **Weekly study targets** per subject (Settings), shown on Subjects and in the weekly review.
- **Topic confidence** (0–5 per topic). The revision wheel now favours low-confidence topics when drawing from the syllabus.
- **Weekly review** and **daily journal** on Analytics.
- **Focus-timer settings** (focus, short break, long break) and an **AMOLED theme** (this device only).
- **PWA**: manifest and icon linked, service worker registered (HTTPS or localhost only). `sw.js` cache bumped to v2.
- **Optional cloud sync** (Settings, bottom): your own Supabase project, plain REST calls, no library. Rejects secret / service-role keys. Run `supabase_schema.sql` first.

## Not applicable to this layout
Workout snapshots, plan editing and import/export of workout plans belong to the other (4-page) layout. This layout's Workout page is a simple log with no plans, so there is nothing to snapshot. The two layouts also cannot share one Supabase row: sync refuses to overwrite a cloud copy saved by the other layout.

## Run locally
Open `index.html`, or for PWA testing run `python -m http.server 8000` in this folder and open `http://localhost:8000`.

## Limitations
- Sync copies a whole snapshot. If two devices change data while apart, you choose which copy to keep (a backup of this device is downloaded first). Export a backup before your first sync.
- Your Supabase session is stored in this browser's local storage. Use only the anon / publishable key and test RLS with two accounts before storing private data.
- Tested headlessly in Chromium (Sri Lanka time zone) for: loading, recurring tasks, habit notes, confidence, settings, weekly review, import validation, and a mocked sync round-trip. Not tested on real devices or a real Supabase project.

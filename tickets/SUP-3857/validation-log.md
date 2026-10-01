# SUP-3857: validation log and Jira trail

Ticket: [BD] When you select Relaunch, the MD WK does not update to new value.
Worked by Vikram CM, 2026-09-28 → 2026-09-29, in a boden-configs Claude
session. Solution note: `knowledge/notes/SUP-3857.md`. State:
`tickets/SUP-3857/state.json`.

**Outcome:** Olga confirmed and the ticket is **Done**. There was no code or
config change. The fix is Postgres trigger DDL, which QA and Staging/Bonus
already have. Follow-up: check Prod's triggers.

## Environments

| Env | App URL | Postgres | plan_current |
|---|---|---|---|
| QA | https://asst.qa.bd.s5stratos.com/ (also https://qa.boden.oci.s5stratos.com/) | QA `bd` | 2026-W39 (at test time) |
| Staging / Upgrade (**"Bonus"**) | https://upgrade.boden.s5stratos.com/ | the Bonus server, which is the app's live DB | 2026-W40 |
| ~~"Staging"~~ stale copy | n/a (the app doesn't use it) | `172.16.80.198:5432 / bd` | 2025-W20. Last write 2025-06-19. **Don't triage against it** |

## Timeline

| When | What |
|---|---|
| 2026-06-15 | Suhel Rehman: tested, "Working as Expected" in QA. The new MD holds after replan. |
| 2026-07-09 | Jatin Rana: "We need to figure out what changed in QA to make it work." Olga Gervits: works in QA, not in Upgrade. |
| 2026-09-28 | Triage. Config, frontend, backend and replan ruled out; the revert happens at save, in Postgres. The Evereve trigger pattern led to the `md_trigger_on_update` lock. |
| 2026-09-28 | A QA vs "Staging" trigger diff showed the lock only in "Staging". **That dump came from the stale server.** |
| 2026-09-29 | The stale server was identified: `bd_serviceparams` was 2025-W20 while the UI showed 2026-W40, and it had no writes since 2025-06-19. The user switched to Bonus. |
| 2026-09-29 | Bonus DDL, 10 triggers and 5 functions: identical to QA (diffed mechanically). |
| 2026-09-29 | Relaunch retest on Bonus passed (below). The Jira comment was posted mentioning Olga. |
| 2026-09-29 | **Olga Gervits: "Great, I think we can close them".** The ticket was moved to **Done**. |

## Test runs

### QA: K0853 Edie Fair Isle Jumper, Red-REE

| | MD Wk | Exit Wk | Relaunch Wk |
|---|---|---|---|
| Before | 2026-W52 | 2027-W12 | (empty) |
| After Style Edit | 2026-W51 | 2027-W04 | (empty) |
| After Assortment by Floorsheet | 2026-W50 | 2027-W04 | (empty) |

Result: **working as expected**. These were MD/Exit edits with no relaunch,
so this run checks that the save holds in QA.

### Staging (Bonus): B2962AQU (Boys, location CG17)

Before: dbt 2026-W22, act_dbt 2026-W22, **MD 2026-W39**, Exit 2026-W52, no
relaunch, plan_current **2026-W40**. The item is in MD.

| # | Screen | Relaunch / MD / Exit set | Item in MD before? | Result |
|---|---|---|---|---|
| 1 | Style Edit → Lifecycle Parameters → **Relaunch** row | W41 / W43 / W44 | **yes** (the ticket's case) | ✅ New MD held after replan and a UI refresh |
| 2 | Assortment by Floorset → Style Color Parameters popup → green ✓ | W42 / W46 / W50 | no (MD was W43 after run 1) | ✅ Held. Doesn't exercise the lock |
| 3 | Same popup | W47 / W49 / W52 | no | ✅ Postgres after replan: `erlstmkdnwk` 2026-W49, `exitdate` 2026-W52, `mkdnwks` 3, `last_rcpt_wk`/`lastdcorder` 2026-W43 |

Notes:
- On an in-MD item, the Debut/MD/Exit row only allows editing Exit, because
  `WeekRangePicker.tsx` disables passed weeks. This is expected. Relaunch
  through the **Relaunch** row instead; a Relaunch later than the old MD
  unlocks MD.
- The Style Edit screenshot showed Exit W44 for Blue-AQU, but the row query
  said W52. This wasn't resolved.
- Wks at FP showed 27 (counted Debut W22 → W49) rather than being counted
  from Relaunch. That's a separate issue (see the note's Gotchas).

### Items changed in Bonus (for restore, only if the reporter asks)

Before-state at CG17, from `~/Documents/Notes/SUP-3857.txt`. All had MD
2026-W39, Exit 2026-W52, no relaunch, and plan_current 2026-W40. Original MD
is now in the past, so the UI can't restore it; use SQL.

| product | dbt_wk | act_dbt_wk | md_wk | exitdate |
|---|---|---|---|---|
| B2962AQU | 2026-W22 | 2026-W22 | 2026-W39 | 2026-W52 |
| B3002ECR | 2026-W13 | 2026-W13 | 2026-W39 | 2026-W52 |
| B3180GRY | 2026-W13 | 2026-W13 | 2026-W39 | 2026-W52 |
| B3180LRD | 2026-W13 | 2026-W13 | 2026-W39 | 2026-W52 |
| B3180NAV | 2026-W05 | 2026-W05 | 2026-W39 | 2026-W52 |

K0853REE was also "updated to same" in Staging. Only B2962AQU's test steps
were recorded in detail.

## Jira comments

The Atlassian connector wasn't authorized, so comments were drafted in the
session and posted by hand.

**Withdrawn (don't reuse):** a root-cause/fix comment saying "Staging still
has the lock; recreate the two triggers in Upgrade". It was based on the
stale server and is wrong for Bonus.

**Permission to test in Staging.** This is the 2026-W40 version. Whether it
was posted wasn't recorded.

```text
Hi,

To reproduce SUP-3857 in Staging (Upgrade) and then confirm the fix, I need to update lifecycle parameters and replan a few items there.

What I'd do
- Pick 2–3 items that are in markdown as of Staging's current week (2026-W40)
- Set a new Relaunch Wk, MD Wk and Exit Wk on each, then replan
- Check MD Wk in Style Edit and Assortment by Floorset before and after the replan

Impact
- Only those items change: their lifecycle values, and their plan numbers, because replan regenerates their plan
- Staging only; nothing in QA or Prod is affected
- I'll note each item's current values first so they can be put back afterwards if needed

Is it OK for me to test this in Staging? If there are items I should avoid, or specific items you'd like me to use, please let me know. I'll post the items used and the results here.

Thanks
```

**Retest result, mentioning Olga (posted):**

```text
Hi @Olga Gervits,

I've retested SUP-3857 in Staging (Upgrade), and the new MD Wk now holds after a relaunch.

What I tested (B2962AQU, Boys, Direct and Marketplace):

1. Style Edit: the item was already in markdown (MD Wk 2026-W39, current week 2026-W40). I set Relaunch Wk 2026-W41, MD Wk 2026-W43 and Exit Wk 2026-W44, saved and replanned. The new MD Wk stayed.

2. Assortment by Floorset: in the Style Color Parameters popup I set Relaunch Wk 2026-W47, MD Wk 2026-W49 and Exit Wk 2026-W52, clicked the checkmark and replanned. The grid and the popup both show MD Wk 2026-W49, and the saved data shows the same.

Staging now behaves the same as QA. The database rule that used to reset MD Wk back to the old week for items already in markdown matches QA's version in Staging, so no code or config change was needed.

Could you please confirm it's working as expected on your side? If you'd like to retest, use an item that's currently in markdown and follow the original steps.

Next, I'll check that Prod has the same setup and update here.

Note: B2962AQU's lifecycle values were changed for this test. Let me know if you'd like them put back.

Thanks
```

**Olga Gervits' reply:** "Great, I think we can close them". The ticket
moved to **Done**.

## Open follow-ups

1. **Prod trigger check.** The comment above promised it, and it wasn't done
   before closure. Run `trigger-snapshots.sql` §B step 1. If Prod has the
   lock, apply §B through the DB change process.
2. **Version-control the trigger DDL.** A snapshot now lives in
   `customers/BOD/db/bd_ma_stylecolorchannelattributes.sql`.
3. **Candidate ticket:** Wks at FP and Initial Intake Wk are computed from
   Debut rather than Relaunch.
4. **Tell DevOps about the stale server** `172.16.80.198 / bd`, so nobody
   else triages against it.

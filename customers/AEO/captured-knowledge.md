# Captured knowledge — AEO

Facts captured from users during ticket work, newest first. Each entry is
stamped with source + who + when. Promote durable facts into the proper
knowledge file (profile.md, a primer, a runbook) and prune here.
Generated/appended by `tooling/triage/learn.py`.



## [gotcha] 2026-10-14
aeo.aeo_sku_temp_flow_flag.net_sls_u is stylecolor-grain: the stylecolor's units are repeated on every SKU (product) row, not split by size (QA 2026_W21: every SKU of CO0123_4882_064 = 695 = its p_history_agg weekly total). Never sum it across SKUs for a stylecolor total (it multiplies by size count); use p_history_agg (product = stylecolor). This is what made the Cat Summary companion image favour many-size items — see knowledge/notes/SUP-4610.md.
_(source: SUP-4610 · captured: 2026-10-14)_

## [env] 2026-08-10
AEO staging OCI config bucket: aeo-aeo-1-staging-config, region us-ashburn-1, prefix aeo/asst/configuration/.
_(source: SUP-4486 · captured: 2026-08-10)_

## [gotcha] 2026-08-10
Bulk 'Sync from aeo/asst/configuration bucket' commits in aeo-configs are NOT guaranteed additive — they have silently commented out HAVING clauses in shared pivot includes (e.g. history_product_ty_ly_lly.ftl, commit 6f19a4b 2026-06-08), regressing config that was previously correct. Always git-diff a sync commit; check sibling grain-variant includes (_sku/_style/_stylecolor) individually since they can diverge.
_(source: SUP-4486 · by: vignesh.n · captured: 2026-08-10)_


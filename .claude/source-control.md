# source-control configuration

Team-tracked layer of the source-control plugin's layered config seam. Key names, valid values, and
resolution order are defined upstream in
<https://github.com/melodic-software/claude-code-plugins/blob/main/plugins/source-control/reference/config-resolution.md>.

This file carries PR-body convention keys only. It carries no `babysit_loop_*` keys and is therefore
**not** an adoption of the babysit merge lane — see that reference's "Baseline activation is tracked
adoption". Adding any `babysit_loop_*` key here activates the lane's baseline merge rung and is a
separate, deliberate decision.

## pr_body_required_sections

- Summary
- Test plan
- Related

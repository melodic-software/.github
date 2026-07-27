# source-control configuration

Team-tracked layer of the source-control plugin's layered config seam. Key names, valid values, and
resolution order are defined upstream in
<https://github.com/melodic-software/claude-code-plugins/blob/main/plugins/source-control/reference/config-resolution.md>.

This file carries a tracked `babysit_loop_*` key and is therefore an adoption of the babysit merge
lane — see that reference's "Baseline activation is tracked adoption". The merge rung is set
explicitly rather than left to the baseline default; the merge-rung ladder and the ratification rule
that makes this reviewed file the recorded baseline are defined in
<https://github.com/melodic-software/claude-code-plugins/blob/main/docs/conventions/loop-lane/README.md>.

## pr_body_required_sections

- Summary
- Test plan
- Related

## babysit_loop_merge

c3-autonomous

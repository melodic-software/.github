# source-control configuration

Team-tracked layer of the source-control plugin's layered config seam. Key names, valid values, and
resolution order are defined upstream in
<https://github.com/melodic-software/claude-code-plugins/blob/main/plugins/source-control/reference/config-resolution.md>;
the merge-rung ladder and the ratification rule that makes this reviewed file the recorded baseline
are defined in
<https://github.com/melodic-software/claude-code-plugins/blob/main/docs/conventions/loop-lane/README.md>.

## subject_pattern

Conventional Commits

## pr_title_pattern

Same as `subject_pattern`.

## pr_body_required_sections

- Summary
- Fix
- Verification
- Related

## babysit_loop_merge

c3-autonomous

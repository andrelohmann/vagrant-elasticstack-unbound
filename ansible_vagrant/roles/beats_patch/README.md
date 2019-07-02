Beats that get installed by "apt install" use option parameter "-e" in their *beat.service unitfile.

Parameter "-e" is logging to stderr, so no logfiles are written.

This patch fixes this behaviour for all installed beats.

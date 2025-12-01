# Agent Guidelines for Arch Installation Scripts

## Build/Test Commands
- **Run installer**: `chmod +x install.sh && ./install.sh` (orchestrates all 3 phases)
- **Run individual script**: `chmod +x 0X-<name>.sh && ./0X-<name>.sh` (scripts 01-07 run in sequence)
- **Syntax check**: `bash -n <script>.sh` validates syntax without execution
- **Test in VM**: Boot Arch ISO, clone repo, run `./install.sh`, follow prompts through all 3 phases

## Code Style
- **Structure**: Bash with `#!/bin/bash` shebang, `set -e` at top, header comment with part number and "For Chicago, USA timezone with Zen kernel"
- **Variables**: UPPERCASE for user-configurable (DISK, USERNAME, PART1), always double-quote: `"${VAR}"`
- **Error Handling**: Explicit confirmation prompts before destructive ops (`read -p "Are you sure? (yes/no): "`), exit with clear error messages
- **Formatting**: Echo progress with `===` delimiters, blank lines between sections, completion messages with next steps
- **Naming**: Descriptive variable names matching purpose, avoid single-letter vars except loop counters

## Key Conventions
- Scripts are sequential installation steps requiring live Arch environment (no unit tests)
- Each script checks prerequisites and provides clear instructions for next phase
- Color codes: RED for errors, GREEN for success, YELLOW for warnings (in install.sh)
- State tracking via `/tmp/arch-install-state` and `/root/arch-install/.install-state`

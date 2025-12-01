# Agent Guidelines for Arch Installation Scripts

## Build/Test Commands
- **Run installer**: `chmod +x install.sh && ./install.sh` (orchestrates all 3 phases)
- **Run individual script**: `chmod +x 0X-<name>.sh && ./0X-<name>.sh` (scripts 01-07 run in sequence)
- **Syntax check**: `bash -n <script>.sh` validates syntax without execution
- **Test in VM**: Boot Arch ISO, clone repo, run `./install.sh`, follow prompts through all 3 phases

## Code Style
- **Structure**: Bash with `#!/bin/bash` shebang, `set -e` immediately after, header comment with part number and "For Chicago, USA timezone with Zen kernel"
- **Variables**: UPPERCASE for user-configurable (DISK, USERNAME, PART1), always double-quote: `"${VAR}"`, use descriptive names
- **User Input**: Validate destructive operations with `read -p "Are you sure? (yes/no): " CONFIRM` then check `[ "$CONFIRM" != "yes" ]` to exit
- **Chroot Operations**: Use `arch-chroot /mnt <command>` pattern for commands executed in the installed system (Phase 1 scripts only)
- **Formatting**: Echo progress with `=== Section Name ===`, blank lines between sections, clear completion messages with next steps
- **Error Handling**: Exit with descriptive error messages, check prerequisites (e.g., `if ! command -v sbctl &> /dev/null`), use `set -e` for automatic error exits

## Key Conventions
- Scripts are sequential installation steps requiring live Arch environment (no unit tests possible)
- Each script provides clear instructions for next phase at completion
- Color codes (install.sh only): `RED='\033[0;31m'` for errors, `GREEN='\033[0;32m'` for success, `YELLOW='\033[1;33m'` for warnings
- State tracking via `/tmp/arch-install-state` (Phase 1) and `/root/arch-install/.install-state` (Phases 2-3)
- Partition naming logic: detect nvme/mmcblk devices and append 'p' (`${DISK}p1`) vs standard devices (`${DISK}1`)

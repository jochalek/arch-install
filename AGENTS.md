# Agent Guidelines for Arch Installation Scripts

## Build/Test Commands
- **Run installer**: `chmod +x install.sh && ./install.sh` (orchestrates all phases)
- **Run individual script**: `chmod +x <script>.sh && ./<script>.sh` (scripts 01-07, in order)
- **Syntax check**: `bash -n <script>.sh` or `bash -n install.sh`
- **Test in VM**: Boot Arch ISO, clone repo, run `./install.sh`, follow prompts through phases
- **No unit tests**: These are sequential installation scripts requiring live Arch environment

## Code Style

### Script Structure
- Bash scripts with `#!/bin/bash` shebang
- Use `set -e` at top (fail on error)
- Header comment with part number, purpose, and "For Chicago, USA timezone with Zen kernel"
- Echo progress with `===` delimiters for major sections

### Variables & Naming
- UPPERCASE for user-configurable variables (DISK, USERNAME, PART1, PART2)
- Double-quote all variables: `"${DISK}"`, `"${USERNAME}"`
- Use descriptive variable names matching their purpose

### Error Handling
- Explicit confirmation prompts before destructive operations (`read -p "Are you sure? (yes/no): "`)
- Check return values with conditionals, exit with error message if needed
- Clear error messages explaining what went wrong and how to fix it

### Formatting
- Blank lines between logical sections
- Echo status messages before and after major operations
- End scripts with completion message and next step instruction

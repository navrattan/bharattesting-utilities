# BharatTesting Dev Kit — Start Here

## What's Inside

```
bharattesting-dev-kit/
├── docs/
│   └── BharatTesting_Developer_Spec.pdf   ← 50-page complete spec (source of truth)
├── CLAUDE.md                               ← Agent master instruction file (auto-read by Claude Code)
├── TASKS.md                                ← 67 ordered build tasks across 6 phases
├── RULES.md                                ← Hard constraints, coding patterns, quality gates
├── setup.sh                                ← Bootstrap script (run first)
├── .claudeignore                           ← Files the agent should skip
└── .claude/
    ├── settings.json                       ← Agent permissions (allow/deny commands)
    └── commands/
        ├── next-task.md                    ← /next-task — pick up next incomplete task
        ├── check-quality.md                ← /check-quality — run all quality gates
        └── progress.md                     ← /progress — show build progress bar
```

## How to Use

### Option A: Claude Code Agent (Recommended)
```bash
# 1. Unzip this kit
unzip BharatTesting_Dev_Kit.zip
cd bharattesting-dev-kit

# 2. Run bootstrap
chmod +x setup.sh && ./setup.sh

# 3. Start Claude Code in the project
cd bharattesting-utilities
claude

# 4. The agent reads CLAUDE.md automatically. Then run:
/next-task
```

### Option B: Human Developer
1. Read `docs/BharatTesting_Developer_Spec.pdf` cover to cover (50 pages)
2. Run `setup.sh` to scaffold the monorepo
3. Follow `TASKS.md` in exact order — check off each subtask as you go
4. Follow `RULES.md` constraints at all times
5. Before every commit, run the quality gates in `RULES.md` Section "Quality Gates"

## Project Summary
- **5 free developer tools** in one Flutter app (Android + iOS + Web)
- **100% offline, privacy-first, zero backend, open source (MIT)**
- Tools: Document Scanner, Image Reducer, PDF Merger, String-to-JSON, Indian Data Faker
- Tech: Flutter 3.29+ / Riverpod / GoRouter / Material 3 / Dark mode default
- Owner: Navrattan — all PRs require owner approval

## Questions?
Everything is answered in the spec PDF. If truly stuck, create a GitHub Issue.

---
BTQA Services Pvt Ltd — Bengaluru, India — April 2026

Read TASKS.md and count:
1. Total number of tasks (lines with `- [ ]` or `- [x]`)
2. Completed tasks (lines with `- [x]`)
3. Remaining tasks (lines with `- [ ]`)
4. Current phase (which Phase header the next uncompleted task falls under)
5. Next 3 tasks to complete

Show a progress bar and summary like:
```
Progress: ████████░░░░░░░░ 32/67 tasks (48%)
Phase: 3 — Core Logic: JSON Converter + Image Reducer
Next up:
  - Task 3.1: JSON Converter Core
  - Task 3.2: JSON Converter UI
  - Task 3.3: Image Reducer Core
```

# HW1 — Reliable Swift Domain Logic

See [Tasks and Grades](TASKS_AND_GRADES.md) for the 12-point base breakdown
and the optional 4-point bonus.

This is an individual assignment. You may discuss ideas, but the implementation, tests, plan, evidence, and explanations you submit must be your own. If you use an AI tool or agent, disclose the task, your review, and your decision in `AGENT_WORKLOG.md`; you remain responsible for all submitted work.

## Start here

This template deliberately compiles before the domain behavior is implemented. Its supplied public tests initially fail at `Implement StudyItem validation`. Your first task is to implement the required behavior while preserving the published public API and supplied public tests.

Run the complete local test suite with exactly:

```sh
swift test
```

Add at least six meaningful tests of your own in addition to the unchanged starter tests. Record useful, non-sensitive evidence of your plan, review, and test runs in `PLAN.md`, `AGENT_WORKLOG.md`, and the curated `artifacts/` directory.

## Submission contract

Submit these two lines through the course submission channel, using the full SHA from `git rev-parse HEAD`:

```text
Public repository URL: https://github.com/<account>/<repository>
Commit SHA: <full 40-character SHA>
```

Keep the repository public and the submitted commit reachable through the grading and appeal period. Do not alter the required public API or supplied public tests.

This assignment uses no GitHub Actions workflow. Staff will clone your submitted public repository at the submitted SHA and run private hidden tests locally against a temporary copy.

See the course handout for the complete requirements, scoring, and optional bonus.

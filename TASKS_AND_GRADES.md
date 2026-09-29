# Homework 1 — Tasks and Grades

**Individual assignment · 12 base points + up to 4 optional bonus points**

Create an individual public repository from this template. Submit its URL and
the full 40-character SHA of your final commit through the course channel. The
private staff grader checks that exact commit locally.

## Base tasks — 12 points

| Task | Points | What the private grader checks |
| --- | ---: | --- |
| 1. Validation and errors | 2 | Blank titles, non-positive minutes, required error cases, and title-before-minutes precedence. |
| 2. Codable boundaries | 2 | Validated `StudyItem` decoding, keyed `StudyPlan` decoding, and top-level JSON-array decoding. |
| 3. Duplicates and ordering | 2 | First duplicate-ID reporting and deterministic title-then-ID ordering. |
| 4. Queries and completion | 2 | Category queries, incomplete-minute total, unknown IDs, and idempotent completion. |
| 5. Your XCTest contribution | 2 | At least six distinct student-authored `test…` methods in `XCTestCase` subclasses, beyond the supplied starter tests. |
| 6. Submission and evidence | 2 | Required API and files, `README.md` with `swift test`, `PLAN.md`, `AGENT_WORKLOG.md`, and a selected artifact. |
| **Base total** | **12** | |

## Optional harder task — up to 4 bonus points

Implement:

```swift
public mutating func importMerging(_ importedItems: [StudyItem]) throws
```

The bonus is worth **4 points** only when all core behavior tasks (1–4) pass.
It must reject duplicate incoming IDs without changing the plan, replace
existing IDs at their current positions, append genuinely new IDs in ascending
ID order, and remain atomic if an import fails.

## Before submitting

- Run `swift test` locally.
- Keep the public API and supplied public tests intact.
- Submit the public repository URL and full commit SHA.
- Keep that commit publicly reachable through grading and appeals.

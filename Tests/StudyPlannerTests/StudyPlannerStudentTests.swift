import XCTest
@testable import StudyPlanner

final class StudyPlannerStudentTests: XCTestCase {

    // MARK: - Task 1: Validation and errors

    func testNonPositiveEstimatedMinutesIsRejected() {
        XCTAssertThrowsError(
            try StudyItem(id: "x", title: "Valid title", estimatedMinutes: 0, category: .reading)
        ) { error in
            XCTAssertEqual(error as? StudyPlanError, .nonPositiveEstimatedMinutes)
        }
    }

    func testTitleValidationTakesPrecedenceOverMinutes() {
        // Both a blank title and a non-positive minutes value are invalid;
        // blankTitle must be reported first.
        XCTAssertThrowsError(
            try StudyItem(id: "x", title: "   ", estimatedMinutes: -5, category: .reading)
        ) { error in
            XCTAssertEqual(error as? StudyPlanError, .blankTitle)
        }
    }

    // MARK: - Task 2: Codable boundaries

    func testValidatedStudyItemDecodingRejectsInvalidJSON() {
        let json = """
        {"id": "bad", "title": "  ", "estimatedMinutes": 10, "category": "reading", "isCompleted": false}
        """.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(StudyItem.self, from: json)) { error in
            XCTAssertEqual(error as? StudyPlanError, .blankTitle)
        }
    }

    func testKeyedStudyPlanDecoding() throws {
        let json = """
        {"items": [
            {"id": "b", "title": "Beta", "estimatedMinutes": 15, "category": "practice", "isCompleted": false},
            {"id": "a", "title": "Alpha", "estimatedMinutes": 20, "category": "reading", "isCompleted": false}
        ]}
        """.data(using: .utf8)!

        let plan = try JSONDecoder().decode(StudyPlan.self, from: json)

        XCTAssertEqual(plan.items.map(\.title), ["Alpha", "Beta"])
    }

    func testTopLevelJSONArrayDecoding() throws {
        let url = Bundle.module.url(forResource: "study-items", withExtension: "json", subdirectory: "Fixtures")!
        let data = try Data(contentsOf: url)

        let plan = try StudyPlan.decode(from: data)

        XCTAssertEqual(plan.items.count, 3)
    }

    // MARK: - Task 3: Duplicates and ordering

    func testFirstDuplicateIDIsReported() throws {
        let items = try makeItems(ids: ["a", "b", "a", "b"])

        XCTAssertThrowsError(try StudyPlan(items: items)) { error in
            XCTAssertEqual(error as? StudyPlanError, .duplicateID("a"))
        }
    }

    func testItemsAreOrderedByTitleThenID() throws {
        let items = [
            try StudyItem(id: "z", title: "Same", estimatedMinutes: 10, category: .reading),
            try StudyItem(id: "a", title: "Same", estimatedMinutes: 10, category: .reading),
            try StudyItem(id: "m", title: "Alpha", estimatedMinutes: 10, category: .reading)
        ]

        let plan = try StudyPlan(items: items)

        XCTAssertEqual(plan.items.map(\.id), ["m", "a", "z"])
    }

    // MARK: - Task 4: Queries and completion

    func testItemsInCategoryFiltersCorrectly() throws {
        let items = [
            try StudyItem(id: "1", title: "Read", estimatedMinutes: 10, category: .reading),
            try StudyItem(id: "2", title: "Code", estimatedMinutes: 10, category: .practice),
            try StudyItem(id: "3", title: "Ship", estimatedMinutes: 10, category: .project)
        ]
        let plan = try StudyPlan(items: items)

        XCTAssertEqual(plan.items(in: .practice).map(\.id), ["2"])
    }

    func testMarkCompletedWithUnknownIDThrows() throws {
        let plan = try StudyPlan(items: [try StudyItem(id: "a", title: "A", estimatedMinutes: 10, category: .reading)])
        var mutablePlan = plan

        XCTAssertThrowsError(try mutablePlan.markCompleted(id: "missing")) { error in
            XCTAssertEqual(error as? StudyPlanError, .unknownID("missing"))
        }
    }

    func testMarkCompletedIsIdempotent() throws {
        var plan = try StudyPlan(items: [try StudyItem(id: "a", title: "A", estimatedMinutes: 10, category: .reading)])

        try plan.markCompleted(id: "a")
        try plan.markCompleted(id: "a")

        XCTAssertTrue(plan.items.first(where: { $0.id == "a" })!.isCompleted)
        XCTAssertEqual(plan.incompleteMinutes(), 0)
    }

    // MARK: - Bonus: importMerging

    func testImportMergingRejectsDuplicateIncomingIDsWithoutChangingPlan() throws {
        var plan = try StudyPlan(items: [try StudyItem(id: "a", title: "A", estimatedMinutes: 10, category: .reading)])
        let originalItems = plan.items

        let duplicateIncoming = [
            try StudyItem(id: "b", title: "B", estimatedMinutes: 5, category: .practice),
            try StudyItem(id: "b", title: "B2", estimatedMinutes: 5, category: .practice)
        ]

        XCTAssertThrowsError(try plan.importMerging(duplicateIncoming)) { error in
            XCTAssertEqual(error as? StudyPlanError, .duplicateID("b"))
        }
        XCTAssertEqual(plan.items, originalItems)
    }

    func testImportMergingReplacesAtCurrentPositionAndAppendsNewInAscendingIDOrder() throws {
        var plan = try StudyPlan(items: [
            try StudyItem(id: "a", title: "Alpha", estimatedMinutes: 10, category: .reading),
            try StudyItem(id: "b", title: "Beta", estimatedMinutes: 10, category: .reading)
        ])

        let replacedA = try StudyItem(id: "a", title: "Alpha Updated", estimatedMinutes: 99, category: .reading)
        let newZ = try StudyItem(id: "z", title: "New Z", estimatedMinutes: 5, category: .project)
        let newC = try StudyItem(id: "c", title: "New C", estimatedMinutes: 5, category: .project)

        try plan.importMerging([newZ, replacedA, newC])

        XCTAssertEqual(plan.items.map(\.id), ["a", "b", "c", "z"])
        XCTAssertEqual(plan.items.first(where: { $0.id == "a" })?.title, "Alpha Updated")
    }

    // MARK: - Helpers

    private func makeItems(ids: [String]) throws -> [StudyItem] {
        try ids.enumerated().map { index, id in
            try StudyItem(id: id, title: "Title \(index)", estimatedMinutes: 10, category: .reading)
        }
    }
}

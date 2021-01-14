import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(AVLTreeTests.allTests),
            testCase(BSTTests.allTests),
        ]
    }
#endif

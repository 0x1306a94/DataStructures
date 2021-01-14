import XCTest

import DataStructuresTests

var tests = [XCTestCaseEntry]()
tests += AVLTreeTests.allTests()
tests += BSTTests.allTests
XCTMain(tests)

import XCTest

import DataStructuresTests

var tests = [XCTestCaseEntry]()
tests += AVLTreeTests.allTests()
tests += BSTTests.allTests
tests += RBTests.allTests
XCTMain(tests)

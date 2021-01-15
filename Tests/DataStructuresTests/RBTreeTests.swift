//
//  File.swift
//
//
//  Created by king on 2021/1/15.
//

@testable import DataStructures
import XCTest

final class RBTreeTests: XCTestCase {
    func testRBTree() {
        let rb = RBTree<Int>()
        let array = [88, 53, 85, 21, 62, 18, 20, 78]
        array.forEach { rb.add(element: $0) }

        print(rb)
        print(rb.generateDot())
        XCTAssertEqual(rb.size, 8)
    }

    static var allTests = [
        ("testRBTree", testRBTree),
    ]
}

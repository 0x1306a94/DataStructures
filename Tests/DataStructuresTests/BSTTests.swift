//
//  BSTTests.swift
//
//
//  Created by king on 2021/1/14.
//

@testable import DataStructures
import XCTest

final class BSTTests: XCTestCase {
    func testBST() {
        let bst = AVL<Int>()
        let array: [Int] = [7, 4, 9, 2, 5, 8, 11]

        array.forEach { bst.add(element: $0) }

        print(bst)
        print(bst.generateDot())
        XCTAssertEqual(bst.size, 7)

        var traverseRes: [Int] = []
        bst.preorder { traverseRes.append($0); return false }
        XCTAssertEqual(traverseRes, [7, 4, 2, 5, 9, 8, 11])
        traverseRes.removeAll()

        bst.inorder { traverseRes.append($0); return false }
        XCTAssertEqual(traverseRes, [2, 4, 5, 7, 8, 9, 11])
        traverseRes.removeAll()

        bst.postorder { traverseRes.append($0); return false }
        XCTAssertEqual(traverseRes, [2, 5, 4, 8, 11, 9, 7])
        traverseRes.removeAll()

        bst.levelOrder { traverseRes.append($0); return false }
        XCTAssertEqual(traverseRes, [7, 4, 9, 2, 5, 8, 11])

        XCTAssertEqual(bst.height(), 3)

        XCTAssertEqual(bst.isComplete(), true)
    }

    static var allTests = [
        ("testBST", testBST),
    ]
}

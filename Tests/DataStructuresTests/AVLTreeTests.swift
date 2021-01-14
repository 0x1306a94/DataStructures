//
//  AVLTreeTests.swift
//
//
//  Created by king on 2021/1/13.
//

@testable import DataStructures
import XCTest

final class AVLTreeTests: XCTestCase {
    func testAVLTree() {
        let avl = AVL<Int>()
        let array = [85, 19, 69, 3, 7, 99, 95]
        array.forEach { avl.add(element: $0) }

        print(avl)
        print(avl.generateDot())
        XCTAssertEqual(avl.size(), 7)

        var traverseRes: [Int] = []
        avl.preorder { traverseRes.append($0); return false }
        XCTAssertEqual(traverseRes, [69, 7, 3, 19, 95, 85, 99])
        traverseRes.removeAll()

        avl.inorder { traverseRes.append($0); return false }
        XCTAssertEqual(traverseRes, [3, 7, 19, 69, 85, 95, 99])
        traverseRes.removeAll()

        avl.postorder { traverseRes.append($0); return false }
        XCTAssertEqual(traverseRes, [3, 19, 7, 85, 99, 95, 69])
        traverseRes.removeAll()

        avl.levelOrder { traverseRes.append($0); return false }
        XCTAssertEqual(traverseRes, [69, 7, 95, 3, 19, 85, 99])

        XCTAssertEqual(avl.height(), 3)

        XCTAssertEqual(avl.isComplete(), true)
    }

    static var allTests = [
        ("testAVLTree", testAVLTree),
    ]
}

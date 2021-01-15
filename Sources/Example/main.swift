//
//  main.swift
//
//
//  Created by king on 2021/1/14.
//

import DataStructures
import Foundation

func testAVL() {
    let avl = AVLTree<Int>()
    let array: [Int] = [85, 19, 69, 3, 7, 99, 95]

    array.forEach { avl.add(element: $0) }

    print(avl)
    assert(avl.size == 7, "size 错误")

    
    var traverseRes: [Int] = []
    avl.preorder { traverseRes.append($0); return false }
    assert(traverseRes == [69, 7, 3, 19, 95, 85, 99], "前序遍历错误")
    traverseRes.removeAll()

    avl.inorder { traverseRes.append($0); return false }
    assert(traverseRes == [3, 7, 19, 69, 85, 95, 99], "中序遍历错误")
    traverseRes.removeAll()

    avl.postorder { traverseRes.append($0); return false }
    assert(traverseRes == [3, 19, 7, 85, 99, 95, 69], "后序遍历错误")
    traverseRes.removeAll()

    avl.levelOrder { traverseRes.append($0); return false }
    assert(traverseRes == [69, 7, 95, 3, 19, 85, 99], "层序遍历错误")

    assert(avl.height() == 3, "计算树高度错误")

    assert(avl.isComplete(), "判断完全二叉树错误")
}

testAVL()

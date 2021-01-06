//
//  main.swift
//  DataStructures
//
//  Created by king on 2020/9/23.
//

import Foundation

let bst = AVLTree<Int>()

let set = Set((0 ..< 30).map { _ in Int(arc4random_uniform(128) + 1) * 2 })
let array = [85, 19, 69, 3, 7, 99, 95, 2, 1, 70, 44, 58, 11, 21, 14, 93, 57, 4, 56]
array.forEach { bst.add(element: $0) }
// set.forEach { bst.add(element: $0) }

print(bst)

// bst.invertTree()
// print(bst.predecessor(node: bst._root)?.element)
// print(bst.successor(node: bst._root)?.element)
// bst.remove(element: 1)
// bst.remove(element: 3)
// bst.remove(element: 12)
// bst.remove(element: 9)
let str = bst.generateDot()

print(str)
print(array)
var traverseRes: [Int] = []
bst.preorder { traverseRes.append($0); return false }
print("preorder:", traverseRes)
traverseRes.removeAll()
bst.inorder { traverseRes.append($0); return false }
print("inorder:", traverseRes)
traverseRes.removeAll()
bst.postorder { traverseRes.append($0); return false }
print("postorder:", traverseRes)
traverseRes.removeAll()
bst.levelOrder { traverseRes.append($0); return false }
print("levelOrder:", traverseRes)

print("height:", bst.height())
print("isComplete:", bst.isComplete())

internal class Item {}

public class A<E: Equatable> {
	internal func test(item: Item) {}
}

public class B<E: Equatable>: A<E> {
	override internal func test(item: Item) {}
}

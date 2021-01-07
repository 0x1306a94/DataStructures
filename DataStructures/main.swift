//
//  main.swift
//  DataStructures
//
//  Created by king on 2020/9/23.
//

import Foundation

func test() {
	let bst = AVLTree<Int>()

	let set = Set((0 ..< 30).map { _ in Int(arc4random_uniform(128) + 1) * 2 })
	let array = [85, 19, 69, 3, 7, 99, 95]
	array.forEach { bst.add(element: $0) }
	// set.forEach { bst.add(element: $0) }
	// bst.invertTree()
	// print(bst.predecessor(node: bst._root)?.element)
	// print(bst.successor(node: bst._root)?.element)
	// bst.remove(element: 1)
	// bst.remove(element: 3)
	// bst.remove(element: 12)
	// bst.remove(element: 99)
	// bst.remove(element: 85)
	// bst.remove(element: 95)

	print(bst)

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
}

func test2() {
	let set = Set(1 ... 100_0000).map { _ in Int(arc4random_uniform(100_0000) + 1) }
	let data = Array(set)

	var start = CFAbsoluteTimeGetCurrent()
	let bst = BinarySearchTree<Int>()
	data.forEach { bst.add(element: $0) }
	print("bst add 100_0000:", CFAbsoluteTimeGetCurrent() - start)
	start = CFAbsoluteTimeGetCurrent()
	let avl = AVLTree<Int>()
	data.forEach { avl.add(element: $0) }
	print("avl add 100_0000:", CFAbsoluteTimeGetCurrent() - start)
	start = CFAbsoluteTimeGetCurrent()
	data.forEach { bst.remove(element: $0) }
	print("bst remove 100_0000:", CFAbsoluteTimeGetCurrent() - start)
	start = CFAbsoluteTimeGetCurrent()
	data.forEach { avl.remove(element: $0) }
	print("avl remove 100_0000:", CFAbsoluteTimeGetCurrent() - start)
}

test()

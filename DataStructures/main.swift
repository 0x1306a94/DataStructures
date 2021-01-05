//
//  main.swift
//  DataStructures
//
//  Created by king on 2020/9/23.
//

import Foundation

let bst = BinarySearchTree<Int>()

let set = Set((0 ..< 30).map { _ in Int(arc4random_uniform(128) + 1) * 2 })
let array = [7, 4, 9, 2, 5]
array.forEach { bst.add(element: $0) }
//set.forEach { bst.add(element: $0) }

print(bst)

//print(bst.predecessor(node: bst._root)?.element)
//print(bst.successor(node: bst._root)?.element)
let str = bst.generateDot()
print(str)
print(array)
var levelArray: [Int] = []
bst.levelOrder { levelArray.append($0) }
print(levelArray)

print("height:", bst.height())
print("isComplete:", bst.isComplete())

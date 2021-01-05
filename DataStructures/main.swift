//
//  main.swift
//  DataStructures
//
//  Created by king on 2020/9/23.
//

import Foundation

let bst = BinarySearchTree<Float>()

let array: [Float] = [7, 4, 9, 2, 5, 8, 11, 1, 3, 2.5, 10, 12]
array.forEach { bst.add(element: $0) }

print(bst)

let str = bst.generateDot()

print(str)

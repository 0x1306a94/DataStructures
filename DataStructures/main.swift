//
//  main.swift
//  DataStructures
//
//  Created by king on 2020/9/23.
//

import Foundation

let bst = BST<Float>()

let array:[Float] = [7, 4, 9, 2, 5, 8, 11, 1, 3, 10, 12]
array.forEach { bst.add(element: $0) }

print(bst)
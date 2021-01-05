//
//  Tree.swift
//  DataStructures
//
//  Created by king on 2021/1/4.
//

import Foundation

/// 树
public class Tree<Element> {
	internal class Node<Element>: NSObject {
		var element: Element!
		var left: Node<Element>?
		var right: Node<Element>?
		var parent: Node<Element>?

		var isLeaf: Bool {
			return left == nil && right == nil
		}

		var hasTowChildren: Bool {
			return left != nil && right != nil
		}

		init(element: Element, parent: Node<Element>?) {
			self.element = element
			self.parent = parent
		}
	}

	internal var _size = 0
	internal var _root: Node<Element>?

	/// 节点总数
	func size() -> Int {
		return 0
	}

	/// 是否为空
	func empty() -> Bool {
		return _size == 0
	}

	/// 添加节点
	/// - Parameter element: 节点元素
	func add(element: Element) {}

	/// 移除节点
	/// - Parameter element: 节点元素
	func remove(element: Element) {}

	/// 是否包含某个元素
	/// - Parameter element: 节点元素
	func contains(element: Element) -> Bool {
		return false
	}

	func height() -> Int {
		return 0
	}

	func isComplete() -> Bool {
		return false
	}

	// MARK: - 翻转二叉树

	func invertTree() {
		guard let root = _root else { return }
		invertTree(node: root)
	}

	func invertTree(node: Node<Element>?) {
		guard let node = node else { return }

		// 前序递归遍历
//		let left = node.left
//		node.left = node.right
//		node.right = left
//
//		invertTree(node: node.left)
//		invertTree(node: node.right)

		// 后序递归遍历
//		invertTree(node: node.left)
//		invertTree(node: node.right)
//
//		let left = node.left
//		node.left = node.right
//		node.right = left

		// 中序递归遍历
//		invertTree(node: node.left)
//
//		let left = node.left
//		node.left = node.right
//		node.right = left
//
//		invertTree(node: node.left)

		// 层序遍历
		var queue = [node]
		while !queue.isEmpty {
			let top = queue.removeFirst()
			let left = top.left
			top.left = top.right
			top.right = left

			if let left = top.left {
				queue.append(left)
			}

			if let right = top.right {
				queue.append(right)
			}
		}
	}

	// MARK: - 前驱节点

	func predecessor(node: Node<Element>?) -> Node<Element>? {
		guard var n = node else { return node }

		var p = n.left
		// 前驱节点在左子树当中 node.left.right.right....
		if p != nil {
			while p!.right != nil {
				p = p!.right!
			}
			return p
		}

		// 从父节点, 祖父节点中寻找
		while n.parent != nil, n == n.parent?.left {
			n = n.parent!
		}

		// n.parent == nil
		// n == n.parent.right
		return n.parent
	}

	// MARK: - 后继节点

	func successor(node: Node<Element>?) -> Node<Element>? {
		guard var n = node else { return node }

		var p = n.right
		// 前驱节点在左子树当中 node.right.left.left....
		if p != nil {
			while p!.left != nil {
				p = p!.left!
			}
			return p
		}

		// 从父节点, 祖父节点中寻找
		while n.parent != nil, n == n.parent?.right {
			n = n.parent!
		}

		// n.parent == nil
		// n == n.parent.left
		return n.parent
	}
}

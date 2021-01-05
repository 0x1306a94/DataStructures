//
//  Tree.swift
//  DataStructures
//
//  Created by king on 2021/1/4.
//

import Foundation

/// 树
public class BinaryTree<Element> {
	internal class Node<Element>: NSObject {
		var element: Element!
		var left: Node<Element>?
		var right: Node<Element>?
		weak var parent: Node<Element>?

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
		return _size
	}

	/// 是否为空
	func empty() -> Bool {
		return _size == 0
	}

	/// 清空
	func clear() {
		_size = 0
		_root = nil
	}

	// MARK: - 遍历

	/// 前序遍历
	/// - Parameter visit: return true 中断遍历
	func preorder(_ visit: (Element) -> Bool) {
		guard let _ = _root else { return }

		var node = _root
		var stack: [Node<Element>] = []
		while node != nil || !stack.isEmpty {
			while node != nil {
				stack.append(node!)
				if visit(node!.element) {
					return
				}
				node = node?.left
			}

			while node == nil, !stack.isEmpty {
				node = stack.removeLast().right
			}
		}
	}

	/// 中序遍历
	/// - Parameter visit: return true 中断遍历
	func inorder(_ visit: (Element) -> Bool) {
		guard let _ = _root else { return }

		var node = _root
		var stack: [Node<Element>] = []
		while node != nil || !stack.isEmpty {
			while node != nil {
				stack.append(node!)
				node = node?.left
			}

			node = stack.removeLast()
			if visit(node!.element) {
				return
			}
			node = node?.right
		}
	}

	/// 后序遍历
	/// - Parameter visit: return true 中断遍历
	func postorder(_ visit: (Element) -> Bool) {
		guard let _ = _root else { return }

		var node = _root
		var pre: Node<Element>?
		var stack: [Node<Element>] = []
		while node != nil || !stack.isEmpty {
			while node != nil {
				stack.append(node!)
				node = node?.left
			}

			node = stack.last
			if node?.right == nil || node?.right == pre {
				// 当前结点为叶子结点 或者 当前结点的右孩子是上个访问结点
				// 更新上一次访问的结点
				pre = node
				if visit(stack.removeLast().element) { // 出栈，表示访问了当前结点
					return
				}
				// 让node到下一次循环再更新，避免发生空栈错误
				node = nil
			}
			else {
				node = node?.right
			}
		}
	}

	/// 层序遍历
	/// - Parameter visitor: return true 中断遍历
	func levelOrder(_ visitor: (Element) -> Bool) {
		guard let root = _root else { return }
		var queue: [Node<Element>] = [root]

		while !queue.isEmpty {
			let node = queue.removeFirst()
			if visitor(node.element!) {
				return
			}
			if let left = node.left {
				queue.append(left)
			}

			if let right = node.right {
				queue.append(right)
			}
		}
	}

	// MARK: - 前驱节点

	internal func predecessor(node: Node<Element>?) -> Node<Element>? {
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

	internal func successor(node: Node<Element>?) -> Node<Element>? {
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

extension BinaryTree {
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

	func height() -> Int {
		guard let root = _root else { return 0 }
		var queue: [Node<Element>] = [root]
		var height = 0
		var levelSize = 1

		while !queue.isEmpty {
			let node = queue.removeFirst()
			levelSize -= 1
			if let left = node.left {
				queue.append(left)
			}

			if let right = node.right {
				queue.append(right)
			}

			if levelSize == 0 {
				levelSize = queue.count
				height += 1
			}
		}
		return height
	}

	func isComplete() -> Bool {
		guard let root = _root else { return false }
		var queue: [Node<Element>] = [root]

		var leaf = false
		while !queue.isEmpty {
			let node = queue.removeFirst()
			if leaf, !node.isLeaf {
				return false
			}

			if let left = node.left {
				queue.append(left)
			}
			else if node.right != nil {
				// node.left == nil && node.right != nil
				return false
			}

			if let right = node.right {
				queue.append(right)
			}
			else {
				leaf = true
			}
		}

		return true
	}
}
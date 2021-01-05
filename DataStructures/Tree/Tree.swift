//
//  Tree.swift
//  DataStructures
//
//  Created by king on 2021/1/4.
//

/// 树
public class Tree<Element> {
	internal class Node<Element> {
		var element: Element!
		var left: Node<Element>?
		var right: Node<Element>?
		var parent: Node<Element>?

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
}

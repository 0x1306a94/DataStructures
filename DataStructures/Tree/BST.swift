//
//  BST.swift
//  DataStructures
//
//  Created by king on 2020/9/23.
//

import Foundation

infix operator <=>: DefaultPrecedence
public protocol BSTComparable {
	static func <=> (lhs: Self, rhs: Self) -> Int
}

public class BST<Element> where Element: BSTComparable {
	typealias BSTComparator = (Element, Element) -> Int

	private class Node<Element> {
		var element: Element!
		var left: Node<Element>?
		var right: Node<Element>?
		var parent: Node<Element>?

		init(element: Element, parent: Node<Element>?) {
			self.element = element
			self.parent = parent
		}
	}

	public private(set) var size: Int = 0

	private var root: Node<Element>?
	private let comparator: BSTComparator?
	init(comparator: BSTComparator? = nil) {
		self.comparator = comparator
	}
}

private extension BST {
	func compare(lhs: Element, rhs: Element) -> Int {
		guard let comparator = comparator else {
			return lhs <=> rhs
		}
		return comparator(lhs, rhs)
	}
}

public extension BST {
	func empty() -> Bool {
		return size == 0
	}

	func add(element: Element) {
		guard let root = root else {
			self.root = Node(element: element, parent: nil)
			size = 1
			return
		}

		var node: Node<Element>? = root
		var parent: Node<Element>? = root
		var cmp = 0

		while node != nil {
			cmp = compare(lhs: element, rhs: node!.element)
			parent = node
			if cmp < 0 {
				node = node?.left
			} else if cmp > 0 {
				node = node?.right
			} else {
				node?.element = element
				return
			}
		}
		if cmp < 0 {
			parent?.left = Node(element: element, parent: parent)
		} else {
			parent?.right = Node(element: element, parent: parent)
		}
		size += 1
	}
}

extension BSTComparable where Self: Comparable {
	public static func <=> (lhs: Self, rhs: Self) -> Int {
		if lhs < rhs {
			return -1
		} else if lhs > rhs {
			return 1
		}
		return 0
	}
}

extension Int: BSTComparable {}
extension Int8: BSTComparable {}
extension Int16: BSTComparable {}
extension Int32: BSTComparable {}
extension Int64: BSTComparable {}

extension UInt: BSTComparable {}
extension UInt8: BSTComparable {}
extension UInt16: BSTComparable {}
extension UInt32: BSTComparable {}
extension UInt64: BSTComparable {}

extension Float: BSTComparable {
	public static func <=> (lhs: Self, rhs: Self) -> Int {
		if lhs < rhs {
			return -1
		} else if lhs > rhs {
			return 1
		}
		return 0
	}
}

extension Double: BSTComparable {
	public static func <=> (lhs: Self, rhs: Self) -> Int {
		if lhs < rhs {
			return -1
		} else if lhs > rhs {
			return 1
		}
		return 0
	}
}

extension BST: CustomDebugStringConvertible {
	public var debugDescription: String {
		return "<\(Unmanaged.passUnretained(self).toOpaque())> bst size: \(size)"
	}
}

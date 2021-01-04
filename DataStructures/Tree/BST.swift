//
//  BST.swift
//  DataStructures
//
//  Created by king on 2020/9/23.
//

import Foundation

infix operator <=>: DefaultPrecedence
public protocol BSTComparable {
	/// 节点元素比较
	/// - Parameters:
	///   - lhs: 左节点元素
	///   - rhs: 右节点元素
	/// - Return:
	///   - lt: lhs < rhs
	///   - gt: lhs > rhs
	///   - eq: lhs == rhs
	static func <=> (lhs: Self, rhs: Self) -> ComparisonResult
}

public enum ComparisonResult {
	case lt // 小于
	case gt // 大于
	case eq // 等于
}

/// 二叉搜索树
public class BST<E>: Tree where E: BSTComparable {
	public typealias Element = E
	public typealias BSTComparator = (Element, Element) -> ComparisonResult

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

	private var _size: Int = 0
	private var root: Node<Element>?
	private let comparator: BSTComparator?
	init(comparator: BSTComparator? = nil) {
		self.comparator = comparator
	}
}

private extension BST {
	func compare(lhs: Element, rhs: Element) -> ComparisonResult {
		guard let comparator = comparator else { return lhs <=> rhs }
		return comparator(lhs, rhs)
	}
}

public extension BST {
	func size() -> Int {
		return _size
	}

	func empty() -> Bool {
		return _size == 0
	}

	func add(element: Element) {
		guard let root = root else {
			self.root = Node(element: element, parent: nil)
			_size = 1
			return
		}

		var node: Node<Element>? = root
		var parent: Node<Element>? = root
		var cmp: ComparisonResult = .eq

		while node != nil {
			cmp = compare(lhs: element, rhs: node!.element)
			parent = node
			switch cmp {
			case .lt: node = node?.left
			case .gt: node = node?.right
			default: node?.element = element; return
			}
		}
		if cmp == .lt {
			parent?.left = Node(element: element, parent: parent)
		} else {
			parent?.right = Node(element: element, parent: parent)
		}
		_size += 1
	}

	func remove(element: E) {}

	func contains(element: E) -> Bool {
		fatalError("暂未实现")
	}
}

public extension BSTComparable where Self: Comparable {
	static func <=> (lhs: Self, rhs: Self) -> ComparisonResult {
		if lhs < rhs {
			return .lt
		} else if lhs > rhs {
			return .gt
		}
		return .eq
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
	public static func <=> (lhs: Self, rhs: Self) -> ComparisonResult {
		if lhs < rhs {
			return .lt
		} else if lhs > rhs {
			return .gt
		}
		return .eq
	}
}

extension Double: BSTComparable {
	public static func <=> (lhs: Self, rhs: Self) -> ComparisonResult {
		if lhs < rhs {
			return .lt
		} else if lhs > rhs {
			return .gt
		}
		return .eq
	}
}

extension BST: CustomDebugStringConvertible {
	public var debugDescription: String {
		return "<\(Unmanaged.passUnretained(self).toOpaque())> bst size: \(size())"
	}
}

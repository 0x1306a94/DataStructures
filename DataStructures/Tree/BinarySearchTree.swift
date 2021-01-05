//
//  BinarySearchTree.swift
//  DataStructures
//
//  Created by king on 2020/9/23.
//

import Foundation

infix operator <=>: DefaultPrecedence
public protocol BinarySearchTreeComparable {
	/// 节点元素比较
	/// - Parameters:
	///   - lhs: 左节点元素
	///   - rhs: 右节点元素
	/// - Return:
	///   - lt: lhs < rhs
	///   - gt: lhs > rhs
	///   - eq: lhs == rhs
	static func <=> (lhs: Self, rhs: Self) -> BinarySearchTreeComparisonResult
}

public enum BinarySearchTreeComparisonResult {
	case lt // 小于
	case gt // 大于
	case eq // 等于
}

/// 二叉搜索树
public class BinarySearchTree<Element>: Tree<Element> where Element: BinarySearchTreeComparable {
	public typealias BinarySearchTreeComparator = (Element, Element) -> BinarySearchTreeComparisonResult

	private let comparator: BinarySearchTreeComparator?
	init(comparator: BinarySearchTreeComparator? = nil) {
		self.comparator = comparator
	}

	override func size() -> Int {
		return _size
	}

	override func empty() -> Bool {
		return _size == 0
	}

	override func add(element: Element) {
		guard let root = _root else {
			_root = Node(element: element, parent: nil)
			_size = 1
			return
		}

		var node: Node<Element>? = root
		var parent: Node<Element>? = root
		var cmp: BinarySearchTreeComparisonResult = .eq

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

	override func remove(element: Element) {}

	override func contains(element: Element) -> Bool {
		fatalError("暂未实现")
	}

	override func height() -> Int {
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

	override func isComplete() -> Bool {
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
			} else if node.right != nil {
				// node.left == nil && node.right != nil
				return false
			}

			if let right = node.right {
				queue.append(right)
			} else {
				leaf = true
			}
		}

		return true
	}
}

private extension BinarySearchTree {
	func compare(lhs: Element, rhs: Element) -> BinarySearchTreeComparisonResult {
		guard let comparator = comparator else { return lhs <=> rhs }
		return comparator(lhs, rhs)
	}
}

public extension BinarySearchTree {
	func levelOrder(_ visitor: (Element) -> Void) {
		guard let root = _root else { return }
		var queue: [Node<Element>] = [root]

		while !queue.isEmpty {
			let node = queue.removeFirst()
			visitor(node.element!)
			if let left = node.left {
				queue.append(left)
			}

			if let right = node.right {
				queue.append(right)
			}
		}
	}
}

public extension BinarySearchTreeComparable where Self: Comparable {
	static func <=> (lhs: Self, rhs: Self) -> BinarySearchTreeComparisonResult {
		if lhs < rhs {
			return .lt
		} else if lhs > rhs {
			return .gt
		}
		return .eq
	}
}

extension Int: BinarySearchTreeComparable {}
extension Int8: BinarySearchTreeComparable {}
extension Int16: BinarySearchTreeComparable {}
extension Int32: BinarySearchTreeComparable {}
extension Int64: BinarySearchTreeComparable {}
extension UInt: BinarySearchTreeComparable {}
extension UInt8: BinarySearchTreeComparable {}
extension UInt16: BinarySearchTreeComparable {}
extension UInt32: BinarySearchTreeComparable {}
extension UInt64: BinarySearchTreeComparable {}

extension Float: BinarySearchTreeComparable {
	public static func <=> (lhs: Self, rhs: Self) -> BinarySearchTreeComparisonResult {
		if lhs < rhs {
			return .lt
		} else if lhs > rhs {
			return .gt
		}
		return .eq
	}
}

extension Double: BinarySearchTreeComparable {
	public static func <=> (lhs: Self, rhs: Self) -> BinarySearchTreeComparisonResult {
		if lhs < rhs {
			return .lt
		} else if lhs > rhs {
			return .gt
		}
		return .eq
	}
}

extension BinarySearchTree: CustomDebugStringConvertible {
	public var debugDescription: String {
		return "\(type(of: self)) <\(Unmanaged.passUnretained(self).toOpaque())> size: \(size())"
	}
}

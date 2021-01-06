//
//  BinarySearchTree.swift
//  DataStructures
//
//  Created by king on 2020/9/23.
//

import Foundation

infix operator <=>: DefaultPrecedence
public protocol BinarySearchTreeComparable: Equatable {
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
public class BinarySearchTree<Element: BinarySearchTreeComparable>: BinaryTree<Element> {
	public typealias BinarySearchTreeComparator = (Element, Element) -> BinarySearchTreeComparisonResult

	internal let comparator: BinarySearchTreeComparator?
	public init(comparator: BinarySearchTreeComparator? = nil) {
		self.comparator = comparator
	}

	/// 添加节点
	/// - Parameter element: 节点元素
	public func add(element: Element) {
		guard let root = _root else {
			_root = createNode(element: element, parent: nil)
			_size = 1
			afterAdd(node: _root!)
			return
		}

		var node: Node? = root
		var parent: Node? = root
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
		let addNode = createNode(element: element, parent: parent)
		if cmp == .lt {
			parent?.left = addNode
		} else {
			parent?.right = addNode
		}
		_size += 1

		afterAdd(node: addNode)
	}

	/// 移除节点
	/// - Parameter element: 节点元素
	public func remove(element: Element) {
		guard let node = node(at: element) else { return }
		remove(node: node)
	}

	/// 是否包含某个元素
	/// - Parameter element: 节点元素
	public func contains(element: Element) -> Bool {
		guard let _ = node(at: element) else { return false }
		return true
	}

	internal func createNode(element: Element, parent: Node?) -> Node {
		return Node(element: element, parent: parent)
	}

	internal func afterAdd(node: Node) {}

	internal func afterRemove(node: Node) {}

	internal func remove(node: Node) {
		_size -= 1
		var n = node
		if node.hasTowChildren { // 度为2的节点
			// 用后继节点的值覆盖node 的值
			let s = successor(node: node)!
			node.element = s.element
			// 删除后继节点
			n = s
		}

		// 删除node节点, node的度必然是1或者0
		let replacement = n.left != nil ? n.left : n.right
		if replacement != nil { // node 是度为 1 的节点
			// 更新 parent
			replacement?.parent = n.parent
			// 更新 parent left 或者 right 指向
			if n.parent == nil { // node 是度为1的节点并且是根节点
				_root = replacement
			} else if n == n.parent?.left {
				n.parent?.left = replacement
			} else if n == n.parent?.right {
				n.parent?.right = replacement
			}
		} else if n.parent == nil { // 叶子节点, 并且是根节点
			_root = nil
		} else { // 叶子节点, 但不是根节点
			if n == n.parent?.left {
				n.parent?.left = nil
			} else {
				n.parent?.right = nil
			}
		}
	}

	internal func node(at element: Element) -> Node? {
		var node = _root
		while node != nil {
			switch compare(lhs: element, rhs: node!.element) {
			case .lt: node = node!.left
			case .gt: node = node!.right
			default: return node
			}
		}
		return nil
	}
}

private extension BinarySearchTree {
	func compare(lhs: Element, rhs: Element) -> BinarySearchTreeComparisonResult {
		guard let comparator = comparator else { return lhs <=> rhs }
		return comparator(lhs, rhs)
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

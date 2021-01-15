//
//  BST.swift
//  DataStructures
//
//  Created by king on 2020/9/23.
//

import Foundation

infix operator <=>: DefaultPrecedence
public protocol BSTComparable: Equatable {
    /// 节点元素比较
    /// - Parameters:
    ///   - lhs: 左节点元素
    ///   - rhs: 右节点元素
    /// - Return:
    ///   - lt: lhs < rhs
    ///   - gt: lhs > rhs
    ///   - eq: lhs == rhs
    static func <=> (lhs: Self, rhs: Self) -> BSTComparisonResult
}

public enum BSTComparisonResult {
    /// 小于
    case lt
    /// 大于
    case gt
    /// 等于
    case eq
}

public extension BSTComparable where Self: Comparable {
    static func <=> (lhs: Self, rhs: Self) -> BSTComparisonResult {
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
    public static func <=> (lhs: Self, rhs: Self) -> BSTComparisonResult {
        if lhs < rhs {
            return .lt
        } else if lhs > rhs {
            return .gt
        }
        return .eq
    }
}

extension Double: BSTComparable {
    public static func <=> (lhs: Self, rhs: Self) -> BSTComparisonResult {
        if lhs < rhs {
            return .lt
        } else if lhs > rhs {
            return .gt
        }
        return .eq
    }
}

public protocol BSTTreeable: BinaryTreeable {
    typealias BSTComparator = (Element, Element) -> BSTComparisonResult
    var comparator: BSTComparator? { get }
    init(comparator: BSTComparator?)

    func add(element: Element)
    func remove(element: Element)
    func contains(element: Element) -> Bool
}

internal extension BSTTreeable {
    func compare(lhs: Element, rhs: Element) -> BSTComparisonResult where Self: ITree, Self.Node.Element == Element, Element: BSTComparable {
        guard let comparator = comparator else { return lhs <=> rhs }
        return comparator(lhs, rhs)
    }
}

public extension BSTTreeable {
    /// 添加节点
    /// - Parameter element: 节点元素
    func add(element: Element) where Self: ITree, Self.Node.Element == Element, Element: BSTComparable, Self.Node.Extra == Void {
        guard let root = self.root else {
            self.root = createNode(element: element, parent: nil)
            self.size = 1
            afterAdd(node: self.root!)
            return
        }

        var node: Self.Node? = root
        var parent: Self.Node? = root
        var cmp: BSTComparisonResult = .eq

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
        self.size += 1

        afterAdd(node: addNode)
    }

    /// 移除节点
    /// - Parameter element: 节点元素
    func remove(element: Element) where Self: ITree, Self.Node.Element == Element, Element: BSTComparable {
        guard let node = node(at: element) else { return }
        remove(node: node)
    }

    /// 是否包含某个元素
    /// - Parameter element: 节点元素
    func contains(element: Element) -> Bool where Self: ITree, Self.Node.Element == Element, Element: BSTComparable {
        guard let _ = node(at: element) else { return false }
        return true
    }
}

internal extension BSTTreeable {
    func createNode(element: Element, parent: Self.Node?) -> Self.Node where Self: ITree, Self.Node.Element == Element, Element: BSTComparable, Self.Node.Extra == Void {
        return Self.Node(element: element, parent: parent, extra: ())
    }

    func afterAdd(node _: Self.Node) where Self: ITree {}

    func afterRemove(node _: Self.Node) where Self: ITree {}

    func remove(node: Self.Node) where Self: ITree {
        size -= 1
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
                self.root = replacement
            } else if n === n.parent?.left {
                n.parent?.left = replacement
            } else if n === n.parent?.right {
                n.parent?.right = replacement
            }
            afterRemove(node: replacement!)
        } else if n.parent == nil { // 叶子节点, 并且是根节点
            self.root = nil
            afterRemove(node: node)
        } else { // 叶子节点, 但不是根节点
            if n === n.parent?.left {
                n.parent?.left = nil
            } else {
                n.parent?.right = nil
            }

            afterRemove(node: node)
        }
    }

    func node(at element: Element) -> Self.Node? where Self: ITree, Self.Node.Element == Element, Element: BSTComparable {
        var node = self.root
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

/// 二叉搜索树
public class BSTree<Element>: ITree, BSTTreeable, CustomDebugStringConvertible where Element: BSTComparable {
    internal typealias Node = BinaryTreeNode<Element, Void>

    public typealias BSTComparator = (Element, Element) -> BSTComparisonResult

    public internal(set) var size = 0
    internal var root: Node?

    public internal(set) var comparator: BSTComparator?
    public required init(comparator: BSTComparator? = nil) {
        self.comparator = comparator
    }

    public var debugDescription: String {
        return "\(type(of: self)) <\(Unmanaged.passUnretained(self).toOpaque())> size: \(size)"
    }

    #if ENABLE_DEBUG
    deinit {
        print("\(type(of: self)) <\(Unmanaged.passUnretained(self).toOpaque())> deinit")
    }
    #endif
}

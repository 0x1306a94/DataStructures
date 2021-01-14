////
////  AVLTree.swift
////  DataStructures
////
////  Created by king on 2021/1/6.
////

internal extension BinaryTreeNode {
    func height() -> Int where Extra == Int {
        return extra
    }

    func blanceFactor() -> Int where Extra == Int {
        let leftHeight = left?.height() ?? 0
        let rightHeight = right?.height() ?? 0
        return leftHeight - rightHeight
    }

    func updateHeight() where Extra == Int {
        let leftHeight = left?.height() ?? 0
        let rightHeight = right?.height() ?? 0
        extra = 1 + max(leftHeight, rightHeight)
    }

    func tallerChild() -> BinaryTreeNode? where Extra == Int {
        let leftHeight = left?.height() ?? 0
        let rightHeight = right?.height() ?? 0
        if leftHeight > rightHeight {
            return left
        } else if leftHeight < rightHeight {
            return right
        }
        return isLeftChild ? left : right
    }
}

public protocol AVLTree: BBSTTree {}

internal extension AVLTree {
    func createNode(element: Element, parent: Node?) -> Node where NodeExtra == Int {
        return Node(element: element, parent: parent)
    }

    func isBlanced(node: Node) -> Bool where NodeExtra == Int {
        return abs(node.blanceFactor()) <= 1
    }

    func updateHeight(node: Node) where NodeExtra == Int {
        node.updateHeight()
    }

    func rebalance(grand: Node) where NodeExtra == Int {
        guard let parent = grand.tallerChild(), let node = parent.tallerChild() else { return }
        if parent.isLeftChild { // L
            if node.isLeftChild { // LL
                rotateRight(grand: grand)
            } else { // LR
                rotateLeft(grand: parent)
                rotateRight(grand: grand)
            }
        } else { // R
            if node.isLeftChild { // RL
                rotateRight(grand: parent)
                rotateLeft(grand: grand)
            } else { // RR
                rotateLeft(grand: grand)
            }
        }

        updateHeight(node: grand)
        updateHeight(node: parent)
    }
}

extension AVLTree {
    public func add(element: Element) where NodeExtra == Int, Element: BSTComparable {
        guard let root = _root else {
            _root = createNode(element: element, parent: nil)
            _size = 1
            afterAdd(node: _root!)
            return
        }

        var node: Node? = root
        var parent: Node? = root
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
        _size += 1

        afterAdd(node: addNode)
    }

    internal func afterAdd(node: Node) where NodeElement: BSTComparable, NodeExtra == Int {
        var _node = node
        while _node.parent != nil {
            _node = _node.parent!
            if isBlanced(node: _node) {
                // 更新高度
                updateHeight(node: _node)
            } else {
                // 回复平衡
                rebalance(grand: _node)
                break
            }
        }
    }

    internal func afterRemove(node: Node) where NodeElement: BSTComparable, NodeExtra == Int {
        var _node = node
        while _node.parent != nil {
            _node = _node.parent!
            if isBlanced(node: _node) {
                // 更新高度
                updateHeight(node: _node)
            } else {
                // 回复平衡
                rebalance(grand: _node)
            }
        }
    }
}

/// 平衡二叉搜索树
public class AVL<Element>: AVLTree, CustomDebugStringConvertible where Element: BSTComparable {
    public typealias NodeElement = Element
    public typealias NodeExtra = Int

    public typealias BSTComparator = (Element, Element) -> BSTComparisonResult

    public var _size = 0
    public var _root: BinaryTreeNode<NodeElement, NodeExtra>?

    public var comparator: BSTComparator?
    public required init(comparator: BSTComparator? = nil) {
        self.comparator = comparator
    }

    public var debugDescription: String {
        return "\(type(of: self)) <\(Unmanaged.passUnretained(self).toOpaque())> size: \(size())"
    }
}

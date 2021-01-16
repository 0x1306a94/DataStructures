////
////  AVL.swift
////  DataStructures
////
////  Created by king on 2021/1/6.
////

internal extension BinaryTreeNodeable {
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

    func tallerChild() -> Self? where Extra == Int {
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

public protocol AVLTreeable: BBSTTreeable {}

internal extension AVLTreeable {
    func createNode(element: Element, parent: Self.Node?) -> Self.Node where Self: ITree, Self.Node.Extra == Int, Self.Node.Element == Element {
        return Self.Node(element: element, parent: parent, extra: 1)
    }

    func isBlanced(node: Self.Node) -> Bool where Self: ITree, Self.Node.Extra == Int {
        return abs(node.blanceFactor()) <= 1
    }

    func updateHeight(node: Self.Node) where Self: ITree, Self.Node.Extra == Int {
        node.updateHeight()
    }

    func rebalance(grand: Self.Node) where Self: ITree, Self.Node.Extra == Int {
        guard let parent = grand.tallerChild(), let node = parent.tallerChild() else { return }
        if parent.isLeftChild { // L
            if node.isLeftChild { // LL
                rotateRight(grand)
            } else { // LR
                rotateLeft(parent)
                rotateRight(grand)
            }
        } else { // R
            if node.isLeftChild { // RL
                rotateRight(parent)
                rotateLeft(grand)
            } else { // RR
                rotateLeft(grand)
            }
        }

        updateHeight(node: grand)
        updateHeight(node: parent)
    }
}

extension AVLTreeable {
    public func add(element: Element) where Self: ITree, Self.Node.Extra == Int, Self.Node.Element == Element, Element: BSTComparable {
        guard let root = self.root else {
            self.root = createNode(element: element, parent: nil)
            size = 1
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
        size += 1

        afterAdd(node: addNode)
    }

    internal func afterAdd(node: Self.Node) where Self: ITree, Self.Node.Element: BSTComparable, Self.Node.Extra == Int {
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

    internal func afterRemove(node: Self.Node) where Self: ITree, Self.Node.Element: BSTComparable, Self.Node.Extra == Int {
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
public class AVLTree<Element>: ITree, AVLTreeable, CustomDebugStringConvertible where Element: BSTComparable {
    internal typealias Node = BinaryTreeNode<Element, Int>

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

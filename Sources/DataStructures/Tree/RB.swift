//
//  RB.swift
//
//
//  Created by king on 2021/1/15.
//

import Foundation

public protocol RBTreeable: BBSTTreeable {}

internal enum RBColor {
    case black, red
}

internal extension RBTreeable {
    func createNode(element: Element, parent: Self.Node?) -> Self.Node where Self: ITree, Self.Node.Extra == RBColor, Self.Node.Element == Element {
        return Self.Node(element: element, parent: parent, extra: .red)
    }

    @discardableResult
    func color(node: Self.Node?, color: RBColor) -> Self.Node? where Self: ITree, Self.Node.Extra == RBColor {
        node?.extra = color
        return node
    }

    @discardableResult
    func colorOf(node: Self.Node?) -> RBColor where Self: ITree, Self.Node.Extra == RBColor {
        return node?.extra ?? .black
    }

    @discardableResult
    func red(node: Self.Node?) -> Self.Node? where Self: ITree, Self.Node.Extra == RBColor {
        return color(node: node, color: .red)
    }

    @discardableResult
    func black(node: Self.Node?) -> Self.Node? where Self: ITree, Self.Node.Extra == RBColor {
        return color(node: node, color: .black)
    }

    func isRed(node: Self.Node?) -> Bool where Self: ITree, Self.Node.Extra == RBColor {
        return colorOf(node: node) == .red
    }

    func isBlack(node: Self.Node?) -> Bool where Self: ITree, Self.Node.Extra == RBColor {
        return colorOf(node: node) == .black
    }

    func afterAdd(node: Self.Node) where Self: ITree, Self.Node.Element: BSTComparable, Self.Node.Extra == RBColor {
        guard let parent = node.parent else {
            // 添加的是根节点 或者 上溢到达了根节点
            black(node: node)
            return
        }

        // 如果父节点是黑色，直接返回
        if isBlack(node: parent) {
            return
        }

        // 叔父节点
        let uncle = parent.sibling
        // 祖父节点
        let grand = red(node: parent.parent)

        if isRed(node: uncle) { // 叔父节点是红色【B树节点上溢】
            black(node: parent)
            black(node: uncle)
            // 把祖父节点当做是新添加的节点
            afterAdd(node: grand!)
            return
        }

        // 叔父节点不是红色
        if parent.isLeftChild { // L
            if node.isLeftChild { // LL
                black(node: parent)
            } else { // LR
                black(node: node)
                rotateLeft(parent)
            }
            rotateRight(grand!)
        } else { // R
            if node.isLeftChild { // RL
                black(node: node)
                rotateRight(parent)
            } else { // RR
                black(node: parent)
            }
            rotateLeft(grand!)
        }
    }

    func afterRemove(node: Self.Node) where Self: ITree, Self.Node.Element: BSTComparable, Self.Node.Extra == RBColor {
        // 如果删除的节点是红色
        // 或者 用以取代删除节点的子节点是红色
        if isRed(node: node) {
            black(node: node)
            return
        }

        guard let parent = node.parent else {
            // 删除的是根节点
            return
        }

        // 删除的是黑色叶子节点【下溢】
        // 判断被删除的node是左还是右
        let left = parent.left == nil || node.isLeftChild
        var sibling = left ? parent.right : parent.left
        if left { // 被删除的节点在左边，兄弟节点在右边
            if isRed(node: sibling) {
                black(node: sibling)
                red(node: parent)
                rotateLeft(parent)
                // 更换兄弟
                sibling = parent.right
            }

            // 兄弟节点必然是黑色
            if isBlack(node: sibling?.left), isBlack(node: sibling?.right) {
                // 兄弟节点没有1个红色子节点，父节点要向下跟兄弟节点合并
                let parentBlack = isBlack(node: parent)
                black(node: parent)
                red(node: sibling)
                if parentBlack {
                    afterRemove(node: parent)
                }
            } else { // 兄弟节点至少有1个红色子节点，向兄弟节点借元素
                // 兄弟节点的左边是黑色，兄弟要先旋转
                if isBlack(node: sibling?.right) {
                    rotateRight(sibling!)
                    sibling = parent.right
                }

                color(node: sibling, color: colorOf(node: parent))
                black(node: sibling?.right)
                black(node: parent)
                rotateLeft(parent)
            }
        } else { // 被删除的节点在右边，兄弟节点在左边
            if isRed(node: sibling) { // 兄弟节点是红色
                black(node: sibling)
                red(node: parent)
                rotateRight(parent)
                // 更换兄弟
                sibling = parent.left
            }

            if isBlack(node: sibling?.left), isBlack(node: sibling?.right) {
                // 兄弟节点没有1个红色子节点，父节点要向下跟兄弟节点合并
                let parentBlack = isBlack(node: parent)
                black(node: parent)
                red(node: sibling)
                if parentBlack {
                    afterRemove(node: parent)
                }
            } else { // 兄弟节点至少有1个红色子节点，向兄弟节点借元素
                // 兄弟节点的左边是黑色，兄弟要先旋转
                if isBlack(node: sibling?.left) {
                    rotateLeft(sibling!)
                    sibling = parent.left
                }

                color(node: sibling, color: colorOf(node: parent))
                black(node: sibling?.left)
                black(node: parent)
                rotateRight(parent)
            }
        }
    }
}

public extension RBTreeable {
    func add(element: Element) where Self: ITree, Self.Node.Extra == RBColor, Self.Node.Element == Element, Element: BSTComparable {
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
}

public class RBTree<Element>: ITree, RBTreeable, CustomDebugStringConvertible where Element: BSTComparable {
    internal typealias Node = BinaryTreeNode<Element, RBColor>

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

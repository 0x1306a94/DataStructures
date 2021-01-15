//
//  Tree.swift
//  DataStructures
//
//  Created by king on 2021/1/4.
//

import Foundation

public protocol BinaryTreeNodeable: class {
    associatedtype Element
    associatedtype Extra

    var element: Element! { get set }
    var extra: Extra! { get set }
    var left: Self? { get set }
    var right: Self? { get set }
    var parent: Self? { get set }

    init(element: Element, parent: Self?, extra: Extra)
}

internal extension BinaryTreeNodeable {
    var isLeaf: Bool {
        return left == nil && right == nil
    }

    var hasTowChildren: Bool {
        return left != nil && right != nil
    }

    var isLeftChild: Bool {
        return parent != nil && self === parent?.left
    }

    var isRighChild: Bool {
        return parent != nil && self === parent?.right
    }

    var sibling: Self? {
        if isLeftChild {
            return parent?.right
        }

        if isRighChild {
            return parent?.left
        }

        return nil
    }
}

internal final class BinaryTreeNode<Element, Extra>: BinaryTreeNodeable {
    var element: Element!
    var extra: Extra!
    var left: BinaryTreeNode<Element, Extra>?
    var right: BinaryTreeNode<Element, Extra>?
    weak var parent: BinaryTreeNode<Element, Extra>?

    required init(element: Element, parent: BinaryTreeNode<Element, Extra>?, extra: Extra) {
        self.element = element
        self.parent = parent
        self.extra = extra
    }
    #if ENABLE_DEBUG
    deinit {
        print("\(type(of: self)) <\(Unmanaged.passUnretained(self).toOpaque())> deinit -> element: \(element!) extra: \(extra!)")
    }
    #endif
}

internal protocol ITree: class where Node: BinaryTreeNodeable {
    associatedtype Node

    var size: Int { get set }
    var root: Node? { get set }
}

/// 二叉搜索树
public protocol BinaryTreeable: class {
    associatedtype Element

    var size: Int { get }
    var isEmpty: Bool { get }

    func clear()

    func preorder(_ visit: (Element) -> Bool)

    func inorder(_ visit: (Element) -> Bool)

    func postorder(_ visit: (Element) -> Bool)

    func levelOrder(_ visitor: (Element) -> Bool)

    func height() -> Int

    func isComplete() -> Bool

    func invertTree()
}

public extension BinaryTreeable {
    /// 节点总数
    /// 节点总数

    var isEmpty: Bool {
        return self.size == 0
    }

    /// 是否为空

    /// 清空
    func clear() where Self: ITree {
        self.size = 0
        self.root = nil
    }

    // MARK: - 遍历

    /// 前序遍历
    /// - Parameter visit: return true 中断遍历
    func preorder(_ visit: (Element) -> Bool) where Self: ITree, Self.Node.Element == Element {
//        guard let _ = _root else { return }
//
//        var node = _root
//        // 用数组模拟栈
//        var stack: [Node] = []
//
//        while true {
//            if node != nil {
//                // 访问节点
//                if visit(node!.element) {
//                    return
//                }
//                // 将右子节点入栈
//                if let right = node?.right {
//                    stack.append(right)
//                }
//                // 一直向左
//                node = node?.left
//            } else if stack.isEmpty {
//                return
//            } else {
//                node = stack.removeLast()
//            }
//        }

        guard let root = self.root else { return }

        // 用数组模拟栈
        var stack = [root]

        while !stack.isEmpty {
            let node = stack.removeLast()
            // 访问节点
            if visit(node.element) {
                return
            }

            if let right = node.right {
                stack.append(right)
            }

            if let left = node.left {
                stack.append(left)
            }
        }
    }

    /// 中序遍历
    /// - Parameter visit: return true 中断遍历
    func inorder(_ visit: (Element) -> Bool) where Self: ITree, Self.Node.Element == Element {
        guard let _ = self.root else { return }

        var node = self.root
        var stack: [Self.Node] = []
        while true {
            if node != nil {
                stack.append(node!)
                node = node?.left
            } else if stack.isEmpty {
                return
            } else {
                node = stack.removeLast()
                // 访问节点
                if visit(node!.element) {
                    return
                }
                // 让右节点同样做中序遍历
                node = node?.right
            }
        }
    }

    /// 后序遍历
    /// - Parameter visit: return true 中断遍历
    func postorder(_ visit: (Element) -> Bool) where Self: ITree, Self.Node.Element == Element {
        guard let root = self.root else { return }

        var stack = [root]
        // 记录上一次访问的节点
        var prev: Self.Node?
        while !stack.isEmpty {
            let top = stack.last!
            if top.isLeaf || (prev != nil && prev!.parent === top) {
                prev = stack.removeLast()
                // 访问节点
                if visit(prev!.element) {
                    return
                }

            } else {
                if let right = top.right {
                    stack.append(right)
                }

                if let left = top.left {
                    stack.append(left)
                }
            }
        }
    }

    /// 层序遍历
    /// - Parameter visitor: return true 中断遍历
    func levelOrder(_ visitor: (Element) -> Bool) where Self: ITree, Self.Node.Element == Element {
        guard let root = self.root else { return }
        var queue = [root]

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

    func height() -> Int where Self: ITree {
        guard let root = self.root else { return 0 }
        var queue = [root]
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

    func isComplete() -> Bool where Self: ITree {
        guard let root = self.root else { return false }
        var queue = [root]

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

    // MARK: - 翻转二叉树

    func invertTree() where Self: ITree {
        invertTree(node: self.root)
    }
}

internal extension BinaryTreeable {
    func invertTree(node: Self.Node?) where Self: ITree {
        guard let node = node else { return }

        // 前序递归遍历
        //        let left = node.left
        //        node.left = node.right
        //        node.right = left

        //        invertTree(node: node.left)
        //        invertTree(node: node.right)

        // 后序递归遍历
        //        invertTree(node: node.left)
        //        invertTree(node: node.right)

        //        let left = node.left
        //        node.left = node.right
        //        node.right = left

        // 中序递归遍历
        //        invertTree(node: node.left)

        //        let left = node.left
        //        node.left = node.right
        //        node.right = left

        //        invertTree(node: node.left)

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

    // MARK: - 前驱节点

    func predecessor(node: Self.Node?) -> Self.Node? where Self: ITree {
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
        while n.parent != nil, n === n.parent?.left {
            n = n.parent!
        }

        // n.parent == nil
        // n == n.parent.right
        return n.parent
    }

    // MARK: - 后继节点

    func successor(node: Self.Node?) -> Self.Node? where Self: ITree {
        guard var n = node else { return node }

        var p = n.right
        // 后继节点在右子树当中 node.right.left.left....
        if p != nil {
            while p!.left != nil {
                p = p!.left!
            }
            return p
        }

        // 从父节点, 祖父节点中寻找
        while n.parent != nil, n === n.parent?.right {
            n = n.parent!
        }

        // n.parent == nil
        // n == n.parent.left
        return n.parent
    }
}

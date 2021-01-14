//
//  Tree.swift
//  DataStructures
//
//  Created by king on 2021/1/4.
//

import Foundation

internal class BinaryTreeNode<Element> {
    var element: Element!
    var left: BinaryTreeNode<Element>?
    var right: BinaryTreeNode<Element>?
    weak var parent: BinaryTreeNode<Element>?

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

    init(element: Element, parent: BinaryTreeNode<Element>?) {
        self.element = element
        self.parent = parent
    }

    deinit {
        print("\(type(of: self)) deinit -> element: \(element!)")
    }
}

/// 树
public class BinaryTree<Element>: CustomDebugStringConvertible {
    internal typealias Node = BinaryTreeNode<Element>

    internal var _size = 0
    internal var _root: Node?

    /// 节点总数
    public func size() -> Int {
        return _size
    }

    /// 是否为空
    public func empty() -> Bool {
        return _size == 0
    }

    /// 清空
    public func clear() {
        _size = 0
        _root = nil
    }

    // MARK: - 遍历

    /// 前序遍历
    /// - Parameter visit: return true 中断遍历
    public func preorder(_ visit: (Element) -> Bool) {
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

        guard let root = _root else { return }

        // 用数组模拟栈
        var stack: [Node] = [root]

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
    public func inorder(_ visit: (Element) -> Bool) {
        guard let _ = _root else { return }

        var node = _root
        var stack: [Node] = []
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
    public func postorder(_ visit: (Element) -> Bool) {
        guard let root = _root else { return }

        var stack: [Node] = [root]
        // 记录上一次访问的节点
        var prev: Node?
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
    public func levelOrder(_ visitor: (Element) -> Bool) {
        guard let root = _root else { return }
        var queue: [Node] = [root]

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

    // MARK: - 前驱节点

    internal func predecessor(node: Node?) -> Node? {
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

    internal func successor(node: Node?) -> Node? {
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

    public var debugDescription: String {
        return "\(type(of: self)) <\(Unmanaged.passUnretained(self).toOpaque())>"
    }
}

public extension BinaryTree {
    // MARK: - 翻转二叉树

    func invertTree() {
        invertTree(node: _root)
    }

    internal func invertTree(node: Node?) {
        guard let node = node else { return }

        // 前序递归遍历
        //		let left = node.left
        //		node.left = node.right
        //		node.right = left
//
        //		invertTree(node: node.left)
        //		invertTree(node: node.right)

        // 后序递归遍历
        //		invertTree(node: node.left)
        //		invertTree(node: node.right)
//
        //		let left = node.left
        //		node.left = node.right
        //		node.right = left

        // 中序递归遍历
        //		invertTree(node: node.left)
//
        //		let left = node.left
        //		node.left = node.right
        //		node.right = left
//
        //		invertTree(node: node.left)

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

    func height() -> Int {
        guard let root = _root else { return 0 }
        var queue: [Node] = [root]
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

    func isComplete() -> Bool {
        guard let root = _root else { return false }
        var queue: [Node] = [root]

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

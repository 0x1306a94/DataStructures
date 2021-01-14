//
//  AVLTree.swift
//  DataStructures
//
//  Created by king on 2021/1/6.
//

import Foundation

internal class AVLTreeNode<Element>: BinaryTreeNode<Element> where Element: Equatable {
    var height = 1

    var blanceFactor: Int {
        let leftHeight = (left as? AVLTreeNode)?.height ?? 0
        let rightHeight = (right as? AVLTreeNode)?.height ?? 0
        return leftHeight - rightHeight
    }

    func updateHeight() {
        let leftHeight = (left as? AVLTreeNode)?.height ?? 0
        let rightHeight = (right as? AVLTreeNode)?.height ?? 0
        height = 1 + max(leftHeight, rightHeight)
    }

    func tallerChild() -> AVLTreeNode<Element>? {
        let leftHeight = (left as? AVLTreeNode)?.height ?? 0
        let rightHeight = (right as? AVLTreeNode)?.height ?? 0
        if leftHeight > rightHeight {
            return left as? AVLTreeNode
        } else if leftHeight < rightHeight {
            return right as? AVLTreeNode
        }
        return isLeftChild ? left as? AVLTreeNode : right as? AVLTreeNode
    }
}

public class AVLTree<Element>: BST<Element> where Element: BSTComparable {
    override internal func createNode(element: Element, parent: Node?) -> Node {
        return AVLTreeNode(element: element, parent: parent)
    }

    override internal func afterAdd(node: Node) {
        var _node = node as! AVLTreeNode<Element>
        while _node.parent != nil {
            _node = _node.parent as! AVLTreeNode<Element>
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

    override internal func afterRemove(node: Node) {
        var _node = node as! AVLTreeNode<Element>
        while _node.parent != nil {
            _node = _node.parent as! AVLTreeNode<Element>
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

internal extension AVLTree {
    func isBlanced(node: AVLTreeNode<Element>) -> Bool {
        return abs(node.blanceFactor) <= 1
    }

    func updateHeight(node: AVLTreeNode<Element>) {
        node.updateHeight()
    }

    func rebalance(grand: AVLTreeNode<Element>) {
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

        //		if parent.isLeftChild { // L
        //			if node.isLeftChild { // LL
        //				rotate(
        //					r: grand,
        //					a: node.left as? AVLTreeNode<Element>, b: node, c: node.right as? AVLTreeNode<Element>,
        //					d: parent,
        //					e: parent.right as? AVLTreeNode<Element>, f: grand, g: grand.right as? AVLTreeNode<Element>
        //				)
        //			} else { // LR
        //				rotate(
        //					r: grand,
        //					a: parent.left as? AVLTreeNode<Element>, b: parent, c: node.left as? AVLTreeNode<Element>,
        //					d: node,
        //					e: node.right as? AVLTreeNode<Element>, f: grand, g: grand.right as? AVLTreeNode<Element>
        //				)
        //			}
        //		} else { // R
        //			if node.isLeftChild { // RL
        //				rotate(
        //					r: grand,
        //					a: grand.left as? AVLTreeNode<Element>, b: grand, c: node.left as? AVLTreeNode<Element>,
        //					d: node,
        //					e: node.right as? AVLTreeNode<Element>, f: parent, g: parent.right as? AVLTreeNode<Element>
        //				)
        //			} else { // RR
        //				rotate(
        //					r: grand,
        //					a: grand.left as? AVLTreeNode<Element>, b: grand, c: parent.left as? AVLTreeNode<Element>,
        //					d: parent,
        //					e: node.left as? AVLTreeNode<Element>, f: node, g: node.right as? AVLTreeNode<Element>
        //				)
        //			}
        //		}
    }

    func rotate(
        r: AVLTreeNode<Element>?, // 子树的根节点
        a: AVLTreeNode<Element>?, b: AVLTreeNode<Element>?, c: AVLTreeNode<Element>?,
        d: AVLTreeNode<Element>?,
        e: AVLTreeNode<Element>?, f: AVLTreeNode<Element>?, g: AVLTreeNode<Element>?
    ) {
        // 让d成为这棵子树的根节点
        d?.parent = r?.parent
        if r?.isLeftChild ?? false {
            r?.parent?.left = d
        } else if r?.isRighChild ?? false {
            r?.parent?.right = d
        } else {
            _root = d
        }

        // a b c
        b?.left = a
        if a != nil {
            a?.parent = b
        }

        b?.right = c
        if c != nil {
            c?.parent = b
        }

        b?.updateHeight()

        // e f g
        f?.left = e
        if e != nil {
            e?.parent = f
        }

        f?.right = g
        if g != nil {
            f?.parent = f
        }

        f?.updateHeight()

        // b d f
        d?.left = b
        d?.right = f
        b?.parent = d
        f?.parent = d
        d?.updateHeight()
    }

    func rotateLeft(grand: AVLTreeNode<Element>) {
        let parent = grand.right
        let child = parent?.left
        grand.right = child
        parent?.left = grand

        afterRotate(grand: grand, parent: parent as? AVLTreeNode<Element>, child: child as? AVLTreeNode<Element>)
    }

    func rotateRight(grand: AVLTreeNode<Element>) {
        let parent = grand.left
        let child = parent?.right
        grand.left = child
        parent?.right = grand

        afterRotate(grand: grand, parent: parent as? AVLTreeNode<Element>, child: child as? AVLTreeNode<Element>)
    }

    func afterRotate(grand: AVLTreeNode<Element>?, parent: AVLTreeNode<Element>?, child: AVLTreeNode<Element>?) {
        // 让parent成为子树的根节点
        parent?.parent = grand?.parent
        if grand?.isLeftChild ?? false {
            grand?.parent?.left = parent
        } else if grand?.isRighChild ?? false {
            grand?.parent?.right = parent
        } else { // node 是root 节点
            _root = parent
        }

        // 更新child的parent
        if child != nil {
            child?.parent = grand
        }
        // 更新grand的parent
        grand?.parent = parent
        // 更新高度
        grand?.updateHeight()
        parent?.updateHeight()
    }
}

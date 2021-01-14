//
//  BBST.swift
//
//
//  Created by king on 2021/1/14.
//

public protocol BBSTTree: BSTTree {}

internal extension BBSTTree {
    func rotate(
        r: Node?, // 子树的根节点
        a: Node?, b: Node?, c: Node?,
        d: Node?,
        e: Node?, f: Node?, g: Node?
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

        // e f g
        f?.left = e
        if e != nil {
            e?.parent = f
        }

        f?.right = g
        if g != nil {
            f?.parent = f
        }

        // b d f
        d?.left = b
        d?.right = f
        b?.parent = d
        f?.parent = d
    }

    func rotateLeft(grand: Node) {
        let parent = grand.right
        let child = parent?.left
        grand.right = child
        parent?.left = grand

        afterRotate(grand: grand, parent: parent, child: child)
    }

    func rotateRight(grand: Node) {
        let parent = grand.left
        let child = parent?.right
        grand.left = child
        parent?.right = grand

        afterRotate(grand: grand, parent: parent, child: child)
    }

    func afterRotate(grand: Node?, parent: Node?, child: Node?) {
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
    }
}

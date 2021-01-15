//
//  BBST.swift
//
//
//  Created by king on 2021/1/14.
//

public protocol BBSTTree: BSTTree {}

internal extension BBSTTree {
    func rotate(
        r: Self.Node?, // 子树的根节点
        a: Self.Node?, b: Self.Node?, c: Self.Node?,
        d: Self.Node?,
        e: Self.Node?, f: Self.Node?, g: Self.Node?
    ) where Self: ITree {
        // 让d成为这棵子树的根节点
        d?.parent = r?.parent
        if r?.isLeftChild ?? false {
            r?.parent?.left = d
        } else if r?.isRighChild ?? false {
            r?.parent?.right = d
        } else {
            self.root = d
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

    func rotateLeft(grand: Self.Node) where Self: ITree {
        let parent = grand.right
        let child = parent?.left
        grand.right = child
        parent?.left = grand

        afterRotate(grand: grand, parent: parent, child: child)
    }

    func rotateRight(grand: Self.Node) where Self: ITree {
        let parent = grand.left
        let child = parent?.right
        grand.left = child
        parent?.right = grand

        afterRotate(grand: grand, parent: parent, child: child)
    }

    func afterRotate(grand: Self.Node?, parent: Self.Node?, child: Self.Node?) where Self: ITree {
        // 让parent成为子树的根节点
        parent?.parent = grand?.parent
        if grand?.isLeftChild ?? false {
            grand?.parent?.left = parent
        } else if grand?.isRighChild ?? false {
            grand?.parent?.right = parent
        } else { // Self.Node 是root 节点
            self.root = parent
        }

        // 更新child的parent
        if child != nil {
            child?.parent = grand
        }
        // 更新grand的parent
        grand?.parent = parent
    }
}

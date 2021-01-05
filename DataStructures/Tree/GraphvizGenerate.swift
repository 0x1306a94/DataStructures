//
//  GraphvizGenerate.swift
//  DataStructures
//
//  Created by king on 2021/1/4.
//

import Foundation

internal extension BinarySearchTree {
	/// 生成 Graphviz dot 规则, 可通过 https://dreampuf.github.io/GraphvizOnline 在线预览
	/// - Returns: Graphviz dot 规则文本
	func generateDot() -> String {
		guard let root = _root else { return "" }
		var dotArray: [String] = [
			"digraph G {{",
			"\tgraph [nodesep=0.1]",
			"\tnode [shape=circle]",
			"\tedge [arrowhead=vee]",
		]

		if root.left != nil || root.right != nil {
			let val = "\(String(describing: root.element!))"
			dotArray.append("\t\"\(val)\" [group=\"\(val)\", label=\"\(val)\"]")
		}

		func printNode(root: Node<Element>, out: inout [String]) {
			var target: Element?
			var distance = 0

			let rootVal = "\(String(describing: root.element!))"

			if root.left != nil {
				var leftMax = root.left!
				var leftDistance = 1
				while leftMax.right != nil {
					leftMax = leftMax.right!
					leftDistance += 1
				}

				// 找到root节点的root.left往下最右边的节点
				target = leftMax.element
				distance = leftDistance

				let leftVal = "\(String(describing: root.left!.element!))"
				if root.left?.left != nil || root.left?.right != nil {
					out.append("\t\"\(leftVal)\" [group=\"\(leftVal)\", label=\"\(leftVal)\"]")
				}

				// 生成root指向root.left的关系
				out.append("\t\"\(rootVal)\" -> \"\(leftVal)\"")

				printNode(root: root.left!, out: &out)
			}

			if root.left != nil || root.right != nil {
				out.append("\t\"_\(rootVal)\" [group=\"\(rootVal)\", label=\"\", width=0, style=invis]")
				out.append("\t\"\(rootVal)\" -> \"_\(rootVal)\" [style=invis]")
			}

			if root.right != nil {
				var rightMin = root.right!
				var rightDistance = 1
				while rightMin.left != nil {
					rightMin = rightMin.left!
					rightDistance += 1
				}

				// 找到root节点的root.right往下最左边的节点
				if rightDistance <= distance {
					target = rightMin.element
					distance = rightDistance
				}

				let rightVal = "\(String(describing: root.right!.element!))"
				if root.right?.left != nil || root.right?.right != nil {
					out.append("\t\"\(rightVal)\" [group=\"\(rightVal)\", label=\"\(rightVal)\"]")
				}

				// 生成root指向root.right的关系
				out.append("\t\"\(rootVal)\" -> \"\(rightVal)\"")

				printNode(root: root.right!, out: &out)
			}

			// 一个节点对应的占位节点应该与该节点的左子树的最大节点和右子树的最小节点中距离较近的那一个处于同一层
			if let e = target, distance > 1 {
				let val = "\(String(describing: e))"
				out.append("\t{{rank=same; \"_\(rootVal)\"; \"\(val)\"}}")
			}
		}

		printNode(root: root, out: &dotArray)
		dotArray.append("}}")
		return dotArray.joined(separator: "\n")
	}
}

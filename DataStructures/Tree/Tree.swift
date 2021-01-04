//
//  Tree.swift
//  DataStructures
//
//  Created by king on 2021/1/4.
//

/// 树
public protocol Tree {
	/// 关联节点元素类型
	associatedtype Element

	/// 节点总数
	func size() -> Int

	/// 是否为空
	func empty() -> Bool

	/// 添加节点
	/// - Parameter element: 节点元素
	func add(element: Element)

	/// 移除节点
	/// - Parameter element: 节点元素
	func remove(element: Element)

	/// 是否包含某个元素
	/// - Parameter element: 节点元素
	func contains(element: Element) -> Bool
}

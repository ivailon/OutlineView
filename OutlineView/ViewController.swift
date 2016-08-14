//
//  ViewController.swift
//  OutlineView
//
//  Created by Ivaylo Nikolov on 14/08/16.
//  Copyright © 2016 Ivaylo Nikolov. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSSearchFieldDelegate, NSOutlineViewDelegate {

	@IBOutlet var treeController: NSTreeController!
	@IBOutlet weak var outlineView: NSOutlineView!
	
	dynamic var tree: [treeItem] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		let item1 = treeItem(name: "Item I")
		item1.children = [treeItem(name: "Sub-item I"), treeItem(name: "Sub-item II"), treeItem(name: "Sub-item III")]
		tree.append(item1)
		let item2 = treeItem(name: "Item II")
		item2.children = [treeItem(name: "Sub-item I"), treeItem(name: "Sub-item II"), treeItem(name: "Sub-item III")]
		tree.append(item2)
	}
	
	func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
		if let item = item as? NSTreeNode, realItem = item.representedObject as? treeItem {
			return realItem.isLeaf ? outlineView.makeViewWithIdentifier("DataCell", owner: self) as! NSTableCellView : outlineView.makeViewWithIdentifier("HeaderCell", owner: self) as! NSTableCellView }
		return nil
	}
	
	override func controlTextDidChange(obj: NSNotification) {
		if let searchField = obj.object as? NSSearchField {
			if searchField.stringValue == "" {
				treeController.fetchPredicate = nil }
			else {
				let predicate = NSPredicate(format: "name contains %@", searchField.stringValue)
				print("Setting predicate: \(predicate.predicateFormat)")
				treeController.fetchPredicate = predicate }
			outlineView.reloadData() }
	}
}

class treeItem: NSObject {
	let name: String
	dynamic var isLeaf:		Bool		= true
	dynamic var children:	[treeItem]	= [] {
		didSet { if children.count > 0 { isLeaf = false } else { isLeaf = true } } }
	
	init(name: String) {
		self.name = name
	}
}
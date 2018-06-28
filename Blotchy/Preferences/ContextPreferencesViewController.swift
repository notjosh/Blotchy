//
//  ContextPreferencesViewController.swift
//  Blotchy
//
//  Created by Joshua May on 20/6/18.
//  Copyright © 2018 Joshua May. All rights reserved.
//

import Cocoa
import MASPreferences

class ContextPreferencesViewController: NSViewController {
    @IBOutlet var tableView: NSTableView!

    var contextService = ContextService.shared

    // MARK:- Actions
    @IBAction func handleSegmentedControlPressed(sender: Any) {
        enum Actions: Int {
            case add
            case remove
        }

        guard let segmented = sender as? NSSegmentedControl else {
            return
        }

        let segment = segmented.selectedSegment
        let tag = segmented.tag(forSegment: segment)
        guard
            let action = Actions(rawValue: tag)
            else {
                return
        }

        switch action {
        case .add:
            handleAddPressed(sender: sender)
        case .remove:
            handleRemovePressed(sender: sender)
        }
    }

    @IBAction func handleAddPressed(sender: Any) {
        tableView.reloadData()
    }

    @IBAction func handleRemovePressed(sender: Any) {
        let indexSet = tableView.selectedRowIndexes

        tableView.beginUpdates()

        indexSet.forEach { contextService.remove(at: $0) }
        tableView.removeRows(at: indexSet, withAnimation: .effectFade)

        tableView.endUpdates()
    }
}

extension ContextPreferencesViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return contextService.contexts.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let tableColumn = tableColumn else {
            return ""
        }

        let context = contextService.contexts[row]

        switch tableView.tableColumns.firstIndex(of: tableColumn) {
        case 0:
            return context.name
        case 1:
            return context.searchEngine.name
        case 2:
            return context.terms.joined(separator: ", ")
        default:
            return ""
        }
    }
}

extension ContextPreferencesViewController: NSTableViewDelegate {
}

extension ContextPreferencesViewController: MASPreferencesViewController {
    var viewIdentifier: String {
        return NSStringFromClass(type(of: self))
    }

    var toolbarItemLabel: String? {
        return NSLocalizedString("Contexts", comment: "Preferences tab label: Contexts")
    }
}

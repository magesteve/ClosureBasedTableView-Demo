//
//  ViewController.swift
//  ClosureBasedTableView Demo
//
//  Created by Steve Sheets on 7/6/20.
//  Copyright © 2020 Steve Sheets. All rights reserved.
//

import Cocoa
import ClosureBasedTableViewKit

// MARK: - Class

// Data to handle generic person information
class PersonData {

// MARK: - Properties
    
    /// Name Field
    public var name: String = ""
    
    /// Job Field
    public var job: String = ""
    
// MARK: - Lifecycle Methods

    init(_ name: String = "Name", _ job: String = "Job") {
        self.name = name
        self.job = job
    }

}

// Demo View Controller
class ViewController: NSViewController {
    
// MARK: - Outlets

    @IBOutlet weak var countingTable: SimpleClosureTableView?
    @IBOutlet weak var dwarfTable: SimpleClosureTableView?
    @IBOutlet weak var peopleTable: ArrayClosureTableView?

    @IBOutlet weak var addButton: NSButton?
    @IBOutlet weak var subtractButton: NSButton?

    @IBOutlet weak var statusLabel: NSTextField?

    // MARK: - Properties

        var dwarfs = ["Sleepy", "Doopy", "Doc", "Bashful", "Sneezy", "Grumpy", "Happy"]
        var workers = [PersonData("Fred", "Clerk"),
                        PersonData("Sue", "Clerk"),
                        PersonData("Ann", "Manager"),
                        PersonData("Jim", "Butcher") ]
        
    // MARK: - Lifecycles

        override func viewDidLoad() {
            super.viewDidLoad()

            if let countingTable = countingTable {
                countingTable.numberDataSource = { return 4 }
                countingTable.textDataSource = { n in
                    return "Line # " + String(n)
                }
                
                countingTable.selectionChangedEvent = { [weak self] n in
                    self?.showStatusLine("Counting Table selection changed row # " + String(n))
                }

                countingTable.doubleClickEvent = { [weak self] n in
                    self?.showStatusLine("Counting Table double click row # " + String(n))
                }
            }
                
            if let dwarfTable = dwarfTable {
                dwarfTable.arrayDataSource = { self.dwarfs }
                
                dwarfTable.selectionChangedEvent = { [weak self] n in
                    self?.showStatusLine("Dwarf Table selection changed row # " + String(n))
                }

                dwarfTable.doubleClickEvent = { [weak self] n in
                    self?.showStatusLine("Dwarf Table double click row # " + String(n))
                }
            }
            
            if let peopleTable = peopleTable {
                peopleTable.linkAddButton(addButton)
                peopleTable.linkSubtractButton(subtractButton)

                peopleTable.arrayDataSource = { [weak self] in
                    return self?.workers ?? []
                }
                peopleTable.column(referral:"name",  cell: { item in
                    guard let item = item as? PersonData else { return "" }
                    
                    return item.name
                }, edit: { item, text in
                    guard let item = item as? PersonData else { return }
                    
                    item.name = text
                })
                peopleTable.column(referral:"job",  cell: { item in
                    guard let item = item as? PersonData else { return "" }

                    return item.job
                }, edit: { item, text in
                    guard let item = item as? PersonData else { return }
                    
                    item.job = text
                })
                peopleTable.arrayChangedEvent = { [weak self] list in
                    guard let strongSelf = self, let newList = list as? [PersonData] else { return }
                    
                    strongSelf.workers = newList
                }
                peopleTable.newItemDataSource = { PersonData() }
            }
        }
        
    // MARK: - Public Method

        /// Show Text on the window
        /// - Parameter text: String to display
        public func showStatusLine(_ text: String) {
            guard let label = self.statusLabel else { return }
            
            label.stringValue = text
        }

    }


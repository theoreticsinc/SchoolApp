//
//  LeftViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

@objc protocol SidePanelViewControllerDelegate {
  optional func menuSelected(animal: MenuItems!)
}

@objc(SidePanelViewController)
class SidePanelViewController : UIViewController, UIApplicationDelegate {

  
  @IBOutlet weak var tableView: UITableView!
  var delegate: SidePanelViewControllerDelegate?

  var menuItems: Array<MenuItems>!
  
  struct TableView {
    struct CellIdentifiers {
      static let MenuCell = "MenuCell"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.reloadData()
  }
  
}

// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuItems.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.MenuCell, forIndexPath: indexPath) as! MenuCell
    cell.configureMenu(menuItems[indexPath.row])
    return cell
  }
  
}

// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let selectedMenu = menuItems[indexPath.row]
    delegate?.menuSelected!(selectedMenu)
  }
  
}

class MenuCell: UITableViewCell {
  
  @IBOutlet weak var menuImageView: UIImageView!
  @IBOutlet weak var imageNameLabel: UILabel!
  
  func configureMenu(menuItem: MenuItems) {
    menuImageView.image = menuItem.image
    imageNameLabel.text = menuItem.title
  }
  
}
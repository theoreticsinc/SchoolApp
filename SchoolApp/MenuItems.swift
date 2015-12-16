//
//  MenuItems.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit


class MenuItems {
  
  let title: String
  let image: UIImage?
  
  init(title: String, image: UIImage?) {
    self.title = title
    self.image = image
  }
  
  class func allMenus() -> Array<MenuItems> {
    return [ MenuItems(title: "Home", image: UIImage(named: "home-48.png")),
        MenuItems(title: "Newsletters", image: UIImage(named: "calendar-date-03-48.png")),
        MenuItems(title: "Facebook Like", image: UIImage(named: "positive-48.png")),
        MenuItems(title: "Event", image: UIImage(named: "bell-48.png")),
        MenuItems(title: "Most Viewed", image: UIImage(named: "view-48.png")),
        MenuItems(title: "Photos", image: UIImage(named: "camera-01-48.png")) ]
  }
  
  
}
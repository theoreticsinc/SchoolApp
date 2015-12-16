//
//  CenterViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

@objc
protocol CenterViewControllerDelegate {
  optional func toggleLeftPanel(callingController: String)
  optional func collapseSidePanels()
  optional func gotoMainController()
  optional func gotoNewslettersController()
  optional func gotoEventsController()
}

class CenterViewController: UIViewController, UITabBarControllerDelegate{
  
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    @IBOutlet weak var navTitle: UINavigationItem!
    
    @IBOutlet weak var todayLbl: UILabel!
    
    
    @IBOutlet weak var tabBar: UITabBar!
    
    
    var delegate: CenterViewControllerDelegate?
    
    
    // MARK: Button actions
    @IBAction func menuTapped(sender: AnyObject) {
        delegate?.toggleLeftPanel?("Main")
    }
  
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if nil == item.title {
            let tabArray = tabBar.items as NSArray!
            let tabItem0 = tabArray.objectAtIndex(2) as! UITabBarItem
            tabItem0.title = "Contact Us"
            let tabItem1 = tabArray.objectAtIndex(3) as! UITabBarItem
            tabItem1.title = "Notification"
        }
        else if item.title! == "Home" {
            //delegate?.gotoMainController!()
        }
        else if item.title! == "Events" {
            delegate?.gotoEventsController!()
        }
        else if item.title! == "Alerts" {
            delegate?.gotoNewslettersController?()
            /*
            
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
            let VC = storyboard.instantiateViewControllerWithIdentifier("NewsLetterViewController") as! NewsLetterViewController
            UIView.transitionFromView(self.view, toView: VC.view, duration: 1, options: UIViewAnimationOptions.CurveEaseIn, completion: nil)
            */
        }
        else if item.title! == "More" {
            let tabArray = tabBar.items as NSArray!
            let tabItem0 = tabArray.objectAtIndex(0) as! UITabBarItem
            tabItem0.title = "Contact Us"
            let tabItem1 = tabArray.objectAtIndex(1) as! UITabBarItem
            tabItem1.title = "Notification"
            
        }
        else if item.title! == "Notification" {
            self.sendNotif()
        }
        
    }
    
    func initNavBar() {
        let iView = UIImageView(frame: CGRectMake(0, 0, 40, 40))
        iView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "sas_logoname.png")
        iView.image = image
        navTitle.titleView = iView
        
        //Making NavigationController Transparent
        /*
        self.navigationController?.navigationBar.clipsToBounds = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        */
        //Making NavigationController Plain White
        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        todayLbl.textAlignment = NSTextAlignment.Justified
        todayLbl.text = "Today    " + formatter.stringFromDate(date)
        
        let str = "2013-07-21 19:32:00"
        
        let dateFor: NSDateFormatter = NSDateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        let yourDate: NSDate? = dateFor.dateFromString(str)
        
        print(yourDate)
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavBar()
        
        let tabArray = tabBar.items as NSArray!
        let tabItem = tabArray.objectAtIndex(0) as! UITabBarItem
        tabBar.selectedItem = tabItem
        tabItem.badgeValue = "34"
        
    }
    
    func sendNotif() {
        let localNotification = UILocalNotification();
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 15)
        localNotification.alertBody = "Walang Pasok Bukas dahil sa matinding paguulan"
        
        localNotification.timeZone = NSTimeZone.defaultTimeZone();
        localNotification.applicationIconBadgeNumber++;
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
    }
    
}

extension CenterViewController: SidePanelViewControllerDelegate {
  @objc func menuSelected(menuItem: MenuItems) {
    //imageView.image = menuItem.image
    //titleLabel.text = menuItem.title
    print(menuItem.title)
    let choice = menuItem.title
    if (choice == "Home") {
        delegate?.gotoMainController?()
    }
    else if (choice == "Newsletters") {
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        let VC = storyboard.instantiateViewControllerWithIdentifier("NewsLetterViewController") as! NewsLetterViewController
        UIView.transitionFromView(self.view, toView: VC.view, duration: 1, options: UIViewAnimationOptions.CurveEaseIn, completion: nil)
        */
        delegate?.gotoNewslettersController?()
    }
    delegate?.collapseSidePanels?()
  }
    
    
}
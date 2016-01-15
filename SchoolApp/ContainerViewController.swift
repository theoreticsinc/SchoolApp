//
//  ContainerViewController.swift
//  SlideOutNavigation
//
//  Created by Angelo Dizon on 03/08/2014.
//  Copyright (c) 2014 Angelo Dizon. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
  case BothCollapsed
  case LeftPanelExpanded
  case RightPanelExpanded
}

class ContainerViewController: UIViewController, NewsLetterViewControllerDelegate,EventsViewControllerDelegate {
    
    var currentController: String = "Main"
  
    var centerNavigationController: UINavigationController!
    var centerViewController: CenterViewController!
    var newsLetterViewController: NewsLetterViewController!
    var newsletterDetailsViewController: NewsletterDetailsViewController!
    var eventsViewController: EventsTableViewController!


  
  var currentState: SlideOutState = .BothCollapsed {
    didSet {
      let shouldShowShadow = currentState != .BothCollapsed
      showShadowForCenterViewController(shouldShowShadow)
    }
  }
  
  var leftViewController: SidePanelViewController?
  var rightViewController: SidePanelViewController?

  let centerPanelExpandedOffset: CGFloat = 60
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    centerViewController = UIStoryboard.centerViewController()
    centerViewController.delegate = self
    
    // wrap the centerViewController in a navigation controller, so we can push views to it
    // and display bar button items in the navigation bar
    centerNavigationController = UINavigationController(rootViewController: centerViewController)
    view.addSubview(centerNavigationController.view)
    addChildViewController(centerNavigationController)
    
    centerNavigationController.didMoveToParentViewController(self)
    
    //let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
    //centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
  }
    
    //SIDE PANELS
    
    func toggleLeftPanel(callingController: String) {
        currentController = callingController
        print("currentController = \(currentController)")
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func toggleRightPanel() {
        let notAlreadyExpanded = (currentState != .RightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController()
        }
        
        animateRightPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func collapseSidePanels() {
        switch (currentState) {
        case .RightPanelExpanded:
            toggleRightPanel()
        case .LeftPanelExpanded:
            toggleLeftPanel(currentController)
        default:
            break
        }
    }
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.leftViewController()
            leftViewController!.menuItems = MenuItems.allMenus()
            
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: SidePanelViewController) {
        sidePanelController.delegate = centerViewController
        
        view.insertSubview(sidePanelController.view, atIndex: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func addRightPanelViewController() {
        /*if (rightViewController == nil) {
        rightViewController = UIStoryboard.rightViewController()
        rightViewController!.animals = Animal.allDogs()
        
        addChildSidePanelController(rightViewController!)
        }*/
    }
    
    func animateLeftPanel(shouldExpand shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .BothCollapsed
                
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func animateRightPanel(shouldExpand shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .RightPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: -CGRectGetWidth(centerNavigationController.view.frame) + centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .BothCollapsed
                
                self.rightViewController!.view.removeFromSuperview()
                self.rightViewController = nil;
            }
        }
    }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
  
}

// MARK: CenterViewController delegate

extension ContainerViewController: CenterViewControllerDelegate {
    
    func gotoMainController() {
        
        //if (currentController == "Newsletters") {
            print("going to Main controller")
            centerNavigationController.view.removeFromSuperview()
            
            centerViewController = UIStoryboard.centerViewController()
            centerViewController.delegate = self
            centerNavigationController = UINavigationController(rootViewController: centerViewController)
            view.addSubview(centerNavigationController.view)
            addChildViewController(centerNavigationController)
        
        
    }
    func gotoNewslettersController() {
        
            print("going to newsLetters controller")
            centerNavigationController.view.removeFromSuperview()
            
            newsLetterViewController = UIStoryboard.newsLetterViewController()
            newsLetterViewController.delegate = self
            centerNavigationController = UINavigationController(rootViewController: newsLetterViewController)
            view.addSubview(centerNavigationController.view)
            addChildViewController(centerNavigationController)
        
        
    }
    func gotoNewsletterDetailsController() {
        //
        print(" going to newsletterDetailsViewController")
        centerNavigationController.view.removeFromSuperview()
        
        newsletterDetailsViewController = UIStoryboard.newsLetterDetailsViewController()
        //newsletterDetailsViewController.delegate = self
        centerNavigationController = UINavigationController(rootViewController: newsletterDetailsViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
    }
    func gotoEventsController() {
        
        print("going to Events controller")
        centerNavigationController.view.removeFromSuperview()
        
        eventsViewController = UIStoryboard.eventsViewController()
        eventsViewController.delegate = self
        centerNavigationController = UINavigationController(rootViewController: eventsViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
    }
    
  
}

extension ContainerViewController: UIGestureRecognizerDelegate {
  // MARK: Gesture recognizer
  
  func handlePanGesture(recognizer: UIPanGestureRecognizer) {
    let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
    
    switch(recognizer.state) {
    case .Began:
      if (currentState == .BothCollapsed) {
        if (gestureIsDraggingFromLeftToRight) {
          //addLeftPanelViewController()
        } else {
          addRightPanelViewController()
        }
        
        showShadowForCenterViewController(true)
      }
    case .Changed:
      recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
      recognizer.setTranslation(CGPointZero, inView: view)
    case .Ended:
      if (leftViewController != nil) {
        // animate the side panel open or closed based on whether the view has moved more or less than halfway
        let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
        animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
      } else if (rightViewController != nil) {
        let hasMovedGreaterThanHalfway = recognizer.view!.center.x < 0
        animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
      }
    default:
      break
    }
  }
}

private extension UIStoryboard {
  class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
  
  class func leftViewController() -> SidePanelViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("LeftViewController") as? SidePanelViewController
  }
  
  class func rightViewController() -> SidePanelViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("RightViewController") as? SidePanelViewController
  }
  
  class func centerViewController() -> CenterViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("CenterViewController") as? CenterViewController
  }
    /*
  class func newsLetterViewController() -> HomeViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("NewsLetterViewController") as? HomeViewController
  }*/
    
    class func newsLetterViewController() -> NewsLetterViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("NewsLetterViewController") as? NewsLetterViewController
    }
    
    class func newsLetterDetailsViewController() -> NewsletterDetailsViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("NewsLetterDetailsViewController") as? NewsletterDetailsViewController
    }
    
    class func eventsViewController() -> EventsTableViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("EventsTableViewController") as? EventsTableViewController
    }
  
}
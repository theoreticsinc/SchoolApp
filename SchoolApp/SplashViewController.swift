//
//  SplashViewController.swift
//  SchoolApp
//
//  Created by Angelo Dizon on 8/14/15.
//  Copyright (c) 2015 Theoretics Inc. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DELAY
        let delay = 4.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.loadRootControl()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadRootControl() {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let containerViewController = ContainerViewController()
        
        window!.rootViewController = containerViewController
        window!.makeKeyAndVisible()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

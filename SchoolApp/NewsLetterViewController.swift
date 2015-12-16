//
//  NewsLetterViewController.swift
//  SchoolApp
//
//  Created by Angelo Dizon on 8/14/15.
//  Copyright (c) 2015 Theoretics Inc. All rights reserved.
//

import UIKit
import CoreData

@objc
protocol NewsLetterViewControllerDelegate {
    optional func toggleLeftPanel(callingController: String)
    optional func gotoNewsletterDetailsController()
    optional func gotoMainController()
    optional func gotoNewslettersController()
    optional func gotoEventsController()
}

class NewsLetterViewController: UIViewController, NSFetchedResultsControllerDelegate, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tableView: UITableView!
    
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView()
    
    //Core Data
    var newsletterList = [NSManagedObject]()
    
    var delegate: NewsLetterViewControllerDelegate!
    
    let managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    var fetchedResultsController: NSFetchedResultsController?
    
    override func viewDidLoad() {
        
        //println("NewsLetter Loading...")
        super.viewDidLoad()
        initNavBar()
        
        let tabArray = tabBar.items as NSArray!
        let tabItem = tabArray.objectAtIndex(1) as! UITabBarItem
        tabBar.selectedItem = tabItem
        tabItem.badgeValue = "1"
        
        // Initialize Alert Controller
        actInd = UIActivityIndicatorView(frame: CGRectMake(0, -10, 50, 50)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.layer.cornerRadius = 5
        actInd.transform = CGAffineTransformMakeScale(1.75, 1.75)
        actInd.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.3)
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        view.addSubview(actInd)
        //actInd.startAnimating()
        
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        
        //self.getAllNamesfromCore("")
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: allNewsletterssFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
        } catch _ {
        }
        
        tableView.reloadData()
        
        //-----------------------
        
        
    }
    
    func allNewsletterssFetchRequest() -> NSFetchRequest {
        var error: NSError?
        let fetchRequest = NSFetchRequest(entityName:"Newsletters")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        let fetchedResults =
        managedObjectContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        
        if let results = fetchedResults {
            print("NEWSLETTERS COUNT: \(results.count)")
            newsletterList = results
        } else {
            //println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        return fetchRequest
    }
    
    override func viewDidAppear(animated: Bool) {
        
        updateListFromServer()
        
    }
    
    func sendNotif(alert: String) {
        let localNotification = UILocalNotification();
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        localNotification.alertBody = alert
        
        localNotification.timeZone = NSTimeZone.defaultTimeZone();
        localNotification.applicationIconBadgeNumber++;
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func menuTapped(sender: AnyObject) {
        delegate?.toggleLeftPanel?("Newsletters")
    }
   
    func initNavBar() {
        let iView = UIImageView(frame: CGRectMake(0, 0, 40, 40))
        iView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "jesu-logo.png")
        iView.image = image
        //navTitle.titleView = iView
        
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if nil == item.title {
            let tabArray = tabBar.items as NSArray!
            let tabItem0 = tabArray.objectAtIndex(2) as! UITabBarItem
            tabItem0.title = "Contact Us"
            let tabItem1 = tabArray.objectAtIndex(3) as! UITabBarItem
            tabItem1.title = "Notification"
        }
        else if item.title! == "Home" {
            delegate?.gotoMainController!()
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
            sendNotif("Weather Advisory: Thunderstorm alert - No Classes")
        }
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("newsletterList", forIndexPath: indexPath) 
    print("indexPath is:\(indexPath.row)")
        if let newsletter = fetchedResultsController?.objectAtIndexPath(indexPath) as? Newsletters {
            //if (nil != newsletter.name) {
                cell.textLabel?.text = newsletter.name
            //}
            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        //delegate!.gotoNewsletterDetailsController!()
        
        /*
        var controller: UINavigationController
        
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("nav2Details") as! UINavigationController
        //controller.yourTableViewArray = localArrayValue
        self.presentViewController(controller, animated: true, completion: nil)
        */
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        let detailsViewController = storyboard.instantiateViewControllerWithIdentifier("NewsLetterDetailsViewController") as! NewsletterDetailsViewController
        let newletter = newsletterList[indexPath.row]
        detailsViewController.name = newletter.valueForKey("name") as! String
        detailsViewController.details = newletter.valueForKey("details") as! String
        detailsViewController.pic_url = newletter.valueForKey("pic_url") as! String
        
        self.navigationController!.pushViewController(detailsViewController, animated: true)

    }
    
    func getAllNamesfromCore(name: String) {
    
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"Newsletters")
        
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        
        if let results = fetchedResults {
            newsletterList = results
        } else {
            //println("Could not fetch \(error), \(error!.userInfo)")
        }
        
    }
    
    func hasDuplicated(id : Int) -> Bool {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        var error: NSError?
        
        let entity =  NSEntityDescription.entityForName("Newsletters",
            inManagedObjectContext:
            managedContext)
        let predicate = NSPredicate(format: "(id = %@)", id)
        
        let fetchRequest = NSFetchRequest(entityName: "Newsletters")
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        
        if let results = fetchedResults {
            if results.count > 0 {
  /*
                var list1 = results
                println(results.count)
                println(list1[0].valueForKey("details") as? String)
  */
                return true
            }
            else {
                print("no match found")
                return false
            }
            
        } else {
            //println("Could not fetch \(error), \(error!.userInfo)")
            return false
        }
    }
    
    
    func saveNewsletter(id: Int, name: String?, details: String, date: String?, picURL : String) {
        let newNewsletters = NSEntityDescription.insertNewObjectForEntityForName("Newsletters", inManagedObjectContext: managedObjectContext!) as! Newsletters
        newNewsletters.name = name ?? ""
        newNewsletters.details = details ?? ""
        newNewsletters.id = id
        newNewsletters.pic_url = picURL ?? ""
        do {
            try managedObjectContext?.save()
        } catch _ {
        }
        
    }
    
    func checkID(id: Int, name: String?, details: String, date: String?, picURL : String) {
        print("ID: \(id)")
        var error: NSError?
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"Newsletters")
        
        fetchRequest.predicate = NSPredicate(format: "(id = %i)", id)
        fetchRequest.fetchLimit = 1
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        
        if let results = fetchedResults {
            print("Results.Count \(results.count)")
            var list1 = results
            var idRes = -1
            if (list1.count > 0) {
                idRes = list1[0].valueForKey("id") as! Int
                print("idRes = \(idRes)")
            }
            // Record not found
            if (id != idRes) {
                
                //NEW SAVE
                self.saveNewsletter(id, name: name, details:details, date: date, picURL: picURL)
                
            }
            // Old Record was found
            else {
              if (list1.count > 0) {
                
              }
              else {
                
                //NEW SAVE
                self.saveNewsletter(id, name: name, details:details, date: date, picURL: picURL)
              }
            }
        
        } else {
            //println("Could not fetch \(error), \(error!.userInfo)")
            
        }
        
        
    }

    func updateListFromServer() {
        self.actInd.startAnimating()
        DataManager.getConfigFromServer{ (configData) -> Void in
            let json = JSON(data: configData)
            //println("retrieving Config...")
            if let newsletterUrl = json["config"]["list"][0]["newsletters"].string  {
                print("*2* Config NewsList: \(newsletterUrl)")
                
                //------------------------------
                DataManager.getDataFromServer(newsletterUrl, success:{(data) -> Void in
                    let json = JSON(data: data)
                    if let news = json["newsletters"]["items"][1]["details"].string  {
                        print("*2* News: \(news)")
                            
                    }
                        //1
                    if let appArray = json["newsletters"]["items"].array {
                        //2
                        print(appArray)
                        //var apps = [AppModel]()
                        var count = 0
                        //3
                        for appDict in appArray {
                            let id: Int! = appDict["id"].int
                            let name: String! = appDict["name"].string
                            let details: String! = appDict["details"].string
                            let date: String! = appDict["date"].string
                            let pic_url: String! = appDict["pic_url"].string
                            
                            count++
                            /*var appURL: String? = appDict["im:image"][0]["label"].string
                            
                            var app = AppModel(name: appName, appStoreURL: appURL)
                            apps.append(app)*/
                            //4
                            //println(name)
                            //self.items.append(details)
                            print("\(id)\(name)\(details)\(date)")
                            self.tableView.beginUpdates()
                            self.checkID(id, name: name, details:details, date: date, picURL: pic_url)
                            self.tableView.endUpdates()
                            
                        }
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //self.getAllNamesfromCore("")
                            self.tableView.reloadData()
                            self.actInd.stopAnimating()
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        })
                    }
                })
                //------------------------------
                
            }
            
            
            
        }
        self.tableView.reloadData()
    }
    
    //MARK: NSFetchedResultsController Delegate Functions
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case NSFetchedResultsChangeType.Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Move:
            break
        case NSFetchedResultsChangeType.Update:
            break
        default:
            break
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
        }
        
        switch editingStyle {
        case .Delete:
            managedObjectContext?.deleteObject(fetchedResultsController?.objectAtIndexPath(indexPath) as! Newsletters)
            do {
                try managedObjectContext?.save()
            } catch _ {
            }
        case .Insert:
            break
        case .None:
            break
        }
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: NSManagedObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case NSFetchedResultsChangeType.Insert:
            tableView.insertRowsAtIndexPaths(NSArray(object: newIndexPath!) as [AnyObject] as [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Delete:
            tableView.deleteRowsAtIndexPaths(NSArray(object: indexPath!) as [AnyObject] as [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Move:
            tableView.deleteRowsAtIndexPaths(NSArray(object: indexPath!) as [AnyObject] as [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.insertRowsAtIndexPaths(NSArray(object: newIndexPath!) as [AnyObject] as [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Update:
            tableView.cellForRowAtIndexPath(indexPath!)
            break
        default:
            break
        }
    }
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    
    
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        
        let newNewsletters = NSEntityDescription.insertNewObjectForEntityForName("Newsletters", inManagedObjectContext: managedObjectContext!) as! Newsletters
        newNewsletters.name = "N: \(arc4random())"
        newNewsletters.details = "description: \(arc4random())"
        newNewsletters.id = NSNumber(unsignedInt: arc4random())
        do {
            //newNewsletters.id = 15
        
            try managedObjectContext?.save()
        } catch _ {
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "DetailSegue" {
            /*let destination = segue.destinationViewController as! DetailViewController
            if let indexPath = self.tableView?.indexPathForCell(sender as! UITableViewCell) {
            let object = fetchedResultsController?.objectAtIndexPath(indexPath) as? Newsletters
            destination.name = object?.name
            destination.age = object?.age.integerValue
            }*/
        }
    }
    

}
//
//  ViewController.swift
//  SegueDemo
//
//  Created by Ian MacCallum on 1/16/15.
//  Copyright (c) 2015 MacCDevTeam. All rights reserved.
//
import Foundation
import UIKit
import CoreData


class HomeViewController: UIViewController, NSFetchedResultsControllerDelegate, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource{
        @IBOutlet var tableView: UITableView!
    
    let managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    var fetchedResultsController: NSFetchedResultsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: allNewsletterssFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
        } catch _ {
        }
        
        tableView.reloadData()
        
        
    }
    
    func allNewsletterssFetchRequest() -> NSFetchRequest {
        var error: NSError?
        let fetchRequest = NSFetchRequest(entityName:"Newsletters")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        do {
            
            let fetchedResults = try self.managedObjectContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResults {
                print("COUNT: \(results.count)")
            } else {
                //println("Could not fetch \(error), \(error!.userInfo)")
            }
            
        } catch _ {
 
}
        

        return fetchRequest
    }
    
    //MARK: UITableView Data Source and Delegate Functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) 
        
        if let cellContact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Newsletters {
            cell.textLabel?.text = cellContact.name + " : " + cellContact.details
            
        }
        
        
        return cell
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
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case NSFetchedResultsChangeType.Insert:
            tableView.insertRowsAtIndexPaths(NSArray(object: newIndexPath!) as [AnyObject] as! [NSIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Delete:
            tableView.deleteRowsAtIndexPaths(NSArray(object: indexPath!) as [AnyObject] as! [NSIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case NSFetchedResultsChangeType.Move:
            tableView.deleteRowsAtIndexPaths(NSArray(object: indexPath!) as [AnyObject] as! [NSIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.insertRowsAtIndexPaths(NSArray(object: newIndexPath!) as [AnyObject] as! [NSIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
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
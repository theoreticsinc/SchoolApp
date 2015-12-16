//
//  DataManager.swift
//  TopApps
//
//  Created by Dani Arnaout on 9/2/14.
//  Edited by Eric Cerney on 9/27/14.
//  Copyright (c) 2014 Ray Wenderlich All rights reserved.
//

import Foundation

let TopAppURL = "https://itunes.apple.com/us/rss/topgrossingipadapplications/limit=3/json"
let ConfigURL = "http://184.95.54.213/schoolapp/configuration.json"

class DataManager {
  
    class func getTopAppsDataFromFileWithSuccess(filename: String!, success: (data: NSData) -> Void) {
    //1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
      //2
      let filePath = NSBundle.mainBundle().pathForResource(filename as String, ofType:"json")
   
      var readError:NSError?
      do {
          let data = try NSData(contentsOfFile:filePath!,
            options: NSDataReadingOptions.DataReadingUncached)
        success(data: data)
      } catch let error as NSError {
          readError = error
      } catch {
          fatalError()
      }
     })
    }
    
    class func getDataFromServer(url: String!, success: ((data: NSData!) -> Void)) {
       
        loadDataFromURL(NSURL(string: url)!, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                //3
                success(data: urlData)
            }
        })
    }
    
    class func getConfigFromServer(success: ((configData: NSData!) -> Void)) {
        
        /*var g_home_url = String(contentsOfURL: NSURL(string: ConfigURL)!, encoding: NSUTF8StringEncoding, error: nil)
        //println(g_home_url)
        //1
        //println(NSData(contentsOfURL: NSURL(string: ConfigURL)!))
        
        if let data = NSData(contentsOfURL: NSURL(string: ConfigURL)!) {
            //println("data: \(data)")
            success(configData: data)
        }*/
        loadDataFromURL(NSURL(string: ConfigURL)!, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                //3
                success(configData: urlData)
            }
        })
    }
    
    class func getTopAppsDataFromItunesWithSuccess(success: ((iTunesData: NSData!) -> Void)) {
        //1
        loadDataFromURL(NSURL(string: TopAppURL)!, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                //3
                success(iTunesData: urlData)
            }
        })
    }
    
    
    class func readFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
        var g_home_url = try? String(contentsOfURL: url, encoding: NSUTF8StringEncoding)
            
        
        
        })
        
    }
    class func loadDataSync(url: String) -> NSData?{
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOfURL: url){
                //imageURL.contentMode = UIViewContentMode.ScaleAspectFit
                //imageURL.image = UIImage(data: data)
                return data
            }
        }
        return nil
    }
  
  class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
    let session = NSURLSession.sharedSession()
    
    // Use NSURLSession to get data from an NSURL
    let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
      if let responseError = error {
        completion(data: nil, error: responseError)
      } else if let httpResponse = response as? NSHTTPURLResponse {
        if httpResponse.statusCode != 200 {
          let statusError = NSError(domain:"com.theoreticsinc", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
          completion(data: nil, error: statusError)
        } else {
          completion(data: data, error: nil)
        }
      }
    })
    
    loadDataTask.resume()
  }
    
    
    class func downloadImage(url: String!, success: ((imgData: NSData!) -> Void)) {
        //1
        //println("downloading image")
            loadDataFromURL(NSURL(string: url)!, completion:{(data, error) -> Void in
                //2
                if let urlData = data {
                    //3
                    success(imgData: urlData)
                }
            })
        }
    
    func getDataFromURL(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
    
}
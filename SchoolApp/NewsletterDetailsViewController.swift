//
//  NewsletterDetailsViewController.swift
//  SchoolApp
//
//  Created by Angelo Dizon on 9/10/15.
//  Copyright (c) 2015 Theoretics Inc. All rights reserved.
//

import UIKit


class NewsletterDetailsViewController: UIViewController {

    
    var name : String = ""
    var details : String = ""
    var pic_url : String = ""
    
    var pageNumbers = 3
    
    @IBOutlet weak var pgCtrl: UIPageControl!
    @IBOutlet weak var mainScroll: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    
    var descLbl = UILabel(frame: CGRectMake(0, 0, 200, 50))
    
    //var cloudimageView = UIImageView(image: UIImage(named: "cloudsBG.png"))
    
    var titleName = UILabel()
    var newletterDate = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let screen = UIScreen.mainScreen().bounds
        mainView.frame = CGRectMake(0, 0, screen.width, screen.height)
        self.loadMainScroll()

        titleName.frame = CGRectMake(20, 40, screen.width - 40, 20)
        titleName.textAlignment = NSTextAlignment.Justified
        titleName.text = name
        titleName.font = UIFont(name: "JosefinSans", size: 18)
        
        let bottomYtitleName = 40 + titleName.frame.size.height
        
        newletterDate.frame = CGRectMake(20, bottomYtitleName, screen.width - 40, 20)
        newletterDate.textAlignment = NSTextAlignment.Left
        newletterDate.text = "Date Today Sunday"
        newletterDate.font = UIFont(name: "JosefinSans-Thin", size: 18)
        
        let bottomYdate = bottomYtitleName + newletterDate.frame.size.height
        
        //descLbl.center = CGPointMake(160, 284)
        descLbl.frame = CGRectMake(20, bottomYdate, screen.width - 20, 200)
        descLbl.numberOfLines = 50
        descLbl.textAlignment = NSTextAlignment.Natural
        descLbl.text = details
        descLbl.font = UIFont(name: "JosefinSans", size: 18)
        // Set up the container view to hold your custom view hierarchy
        
        mainScroll.addSubview(titleName)
        mainScroll.addSubview(newletterDate)
        mainScroll.addSubview(descLbl)
        
        
        //var imageData = DataManager.getDataFromUrl(imageName)
        //imageView.image = [UIImage imageWithData:imageData];
        //let i = UIImage(data: imageData, scale: 1)
        
        //cloudimageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
        //self.view.addSubview(cloudimageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //println(name)
        //println(details)
        titleName.text = name
        
        self.showImage(pic_url)
        //cloudimageView.frame = CGRect(x: 100, y: 300, width: 100, height: 100)
        //cloudimageView.transform
    }
    
    //Async
    func showImageAsync(urlStr:String){
        
        dispatch_async(dispatch_get_main_queue()) {
            //var imageView = UIImageView()
            //var picData = DataManager.loadDataSync(urlStr)
            //var img = UIImage(data: picData!)!
            DataManager.downloadImage(urlStr, success:{(imgData) -> Void in
                let img = UIImage(data: imgData)
                let imageView = UIImageView(image: img)
                let screen = UIScreen.mainScreen().bounds
                imageView.image = UIImage(data: imgData)
                let bottomY = CGRectGetMaxY(self.newletterDate.frame)
                imageView.frame = CGRect(x: 20, y: bottomY + self.newletterDate.frame.size.height, width: screen.width - 40, height: 200)
                imageView.contentMode = .ScaleAspectFit;
                self.mainScroll.addSubview(imageView)
                
                let bottomYimg = CGRectGetMaxY(imageView.frame)
                //self.descLbl.frame = CGRectMake(20, bottomYimg + 50, 200, 40)
                self.descLbl.frame = CGRectMake(20, bottomYimg, screen.width - 20, 200)
                if (CGSizeEqualToSize(imageView.image!.size, CGSizeZero) == false) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
            })
            
        }
        
    }
    
    //Sync
    func showImage(urlStr:String){
        dispatch_async(dispatch_get_main_queue()) {
            let imageView = UIImageView()
            if let picData = DataManager.loadDataSync(urlStr) {
            let img = UIImage(data: picData)
    
                let screen = UIScreen.mainScreen().bounds
                imageView.image = img
                let bottomY = CGRectGetMaxY(self.newletterDate.frame)
                imageView.frame = CGRect(x: 20, y: bottomY + self.newletterDate.frame.size.height, width: screen.width - 40, height: 200)
                imageView.contentMode = .ScaleAspectFit;
                self.mainScroll.addSubview(imageView)
                
                let bottomYimg = CGRectGetMaxY(imageView.frame)
                //self.descLbl.frame = CGRectMake(20, bottomYimg + 50, 200, 40)
                self.descLbl.frame = CGRectMake(20, bottomYimg, screen.width - 20, 200)
                if (CGSizeEqualToSize(imageView.image!.size, CGSizeZero) == false) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
            }
        }
        
    }
    
    func loadMainScroll() {
        let mainScreen = UIScreen.mainScreen().bounds
        mainScroll.frame = CGRectMake(0, 0, mainScreen.width, mainScreen.height)
        mainScroll.bounds = mainScreen
        let height = mainScreen.height * CGFloat(pageNumbers)
        mainScroll.contentSize = CGSizeMake(mainScreen.width, height)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        // Load the pages that are now on screen
        //println("scrolling.")
        
        let pageWidth = scrollView.frame.size.width
        print("scrollView.contentOffset.x \(scrollView.contentOffset.x)")
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        pgCtrl.currentPage = page
    }

}

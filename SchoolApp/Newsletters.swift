//
//  Newsletters.swift
//  SchoolApp
//
//  Created by Angelo Dizon on 9/16/15.
//  Copyright (c) 2015 Theoretics Inc. All rights reserved.
//

import Foundation
import CoreData

class Newsletters: NSManagedObject {
   
    @NSManaged var name: String
    @NSManaged var details: String
    @NSManaged var pic_url: String
    @NSManaged var url_link: String
    @NSManaged var id: NSNumber
}

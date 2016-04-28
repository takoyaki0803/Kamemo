//
//  ConvertNSDate.swift
//  160111
//
//  Created by 20150301 on 2/11/16.
//  Copyright © 2016 ******. All rights reserved.
//

import UIKit

//日付をNSDateからStringの変換用のstruct
struct ConvertNSDate {
    
    //NSDate → Stringへの変換
    static func convertNSDateToString (date: NSDate) -> String {
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let dateString: String = dateFormatter.stringFromDate(date)
        return dateString
    }
}

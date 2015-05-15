//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Giuseppe Santaniello on 14/05/15.
//  Copyright (c) 2015 Giuseppe Santaniello. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL
    var title: String
    
    init(filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
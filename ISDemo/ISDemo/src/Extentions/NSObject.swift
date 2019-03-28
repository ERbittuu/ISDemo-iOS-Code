//
//  NSObject.swift
//  ISDemo
//
//  Created by Utsav Patel on 3/27/19.
//  Copyright © 2019 erbittuu. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }
}

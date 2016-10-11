//
//  Utils.swift
//  REST Tester
//
//  Created by Kenny Speer on 10/9/16.
//  Copyright © 2016 Kenny Speer. All rights reserved.
//

import Foundation

class Utils
{
    // function to use for debug printing, optionally set newVar to msg
    func dprint(msg: String, newVar: String) -> Void {
        var newVar = newVar
        print(msg)
        newVar = msg
        return
    }
}

//
//  File.swift
//  
//
//  Created by Tonny on 6/03/21.
//

import Foundation

public struct KPLog {
    static var log = false
    
    public static func log(_ log: Bool) {
        KPLog.log = log
    }
}


func print(_ item: @autoclosure () -> Any) {
    if KPLog.log {
        Swift.print("\nKP>", item(), terminator: "\n")
    }
}

func print(_ item0: @autoclosure () -> Any, _ item1: @autoclosure () -> Any) {
    if KPLog.log {
        Swift.print(["\nKP>", item0(), item1()].map { "\($0)" }.joined(separator: " "), terminator: "\n")
    }
}


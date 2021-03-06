//
//  File.swift
//  
//
//  Created by Tonny on 6/03/21.
//

import Foundation
import UIKit

typealias ViewID = Int
extension UIView {
    var id: ViewID { tag }
}

public class KPBinding<Model> {

    var modelKeyPath: AnyKeyPath!
    var id: ViewID!

    var updateViewWithModel: ((Model) -> (Bool))!
}

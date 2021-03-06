//
//  KPTwoWayView.swift
//  
//
//  Created by Tonny on 6/03/21.
//

import Foundation
import UIKit

public protocol KPTwoWayEventReceiver {
    func handleEvent()
    
    static var twoWayEvent: UIControl.Event { get }
}

public protocol KPTwoWayView: KPSelfOneWayView, KPTwoWayEventReceiver, UIControl {}

extension UITextField: KPTwoWayView {
    
    public static let twoWayEvent: UIControl.Event = .editingChanged
    
    public func handleEvent() {}
}

extension UISwitch: KPTwoWayView {
    
    public static let twoWayEvent: UIControl.Event = .valueChanged
    
    public func handleEvent() {}
}


extension UIButton: KPTwoWayView {
    
    public static let twoWayEvent: UIControl.Event = .touchUpInside
    
    public func handleEvent() {
        isSelected.toggle()
    }
}


extension UISlider: KPTwoWayView {
    
    public static let twoWayEvent: UIControl.Event = .valueChanged

    public func handleEvent() {}
}


extension UIStepper: KPTwoWayView {
    
    public static let twoWayEvent: UIControl.Event = .valueChanged
    
    public func handleEvent() {}
}

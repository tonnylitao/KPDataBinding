//
//  KPTwoWayBinding.swift
//  
//
//  Created by Tonny on 6/03/21.
//

import Foundation
import UIKit

typealias ViewTag = Int

public class KPTwoWayBinding<Model> {
    var modelKeyPath: AnyKeyPath!
    var updateView: ((Model) -> (Bool))!
    var updateModel: ((inout Model) -> (Bool))!
    
    var tag: ViewTag!
    var addTargetWithActionForEvent: ((Any?, Selector) -> ())!
    var removeTargetWithActionForEvent: ((Any?, Selector) -> ())!
    
    public init<V: UIControl, Value>(_ mKeyPath: WritableKeyPath<Model, Value>,
                                     _ view: V,
                                     _ event: UIControl.Event,
                                     updateView: @escaping (V, Value, Model) -> (),
                                     updateModel: @escaping (inout Model, V) -> ()) {
        
        modelKeyPath = mKeyPath
        self.updateModel = { [weak view] in
            guard let view = view else { return false }
            
            updateModel(&$0, view)
            
            return true
        }
        self.updateView = { [weak view] in
            guard let view = view else { return false }
            
            updateView(view, $0[keyPath: mKeyPath], $0)
            
            return true
        }
        
        tag = view.tag
        addTargetWithActionForEvent = { [weak view] in
            guard let view = view else { return }
            
            view.addTarget($0, action: $1, for: event)
        }
        
        removeTargetWithActionForEvent = { [weak view] in
            guard let view = view else { return }
            
            view.removeTarget($0, action: $1, for: event)
        }
    }
    
    public convenience init<V: KPTwoWayView>(_ mKeyPath: WritableKeyPath<Model, V.Value>,
                                             _ view: V,
                                             _ vKeyPath: ReferenceWritableKeyPath<V, V.Value>,
                                             _ event: UIControl.Event) {
        self.init(mKeyPath, view, event,
                  updateView: { view, value, _ in
                    view[keyPath: vKeyPath] = value
                  },
                  updateModel: { model, view in
                    model[keyPath: mKeyPath] = view[keyPath: vKeyPath]
                  })
    }
    
}


infix operator <=>

public extension KPTwoWayView {
    
    /*
     let bindings = [
        \User.name <=> nameField,
        \User.email <=> emailField
     ]
     */
    
    static func <=> <Model>(mKeyPath: WritableKeyPath<Model, Self.Value>, view: Self) -> KPTwoWayBinding<Model> {
        KPTwoWayBinding(mKeyPath, view, Self.keyPath, Self.twoWayEvent)
    }
}

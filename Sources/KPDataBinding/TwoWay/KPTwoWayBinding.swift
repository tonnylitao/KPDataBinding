//
//  KPTwoWayBinding.swift
//  
//
//  Created by Tonny on 6/03/21.
//

import Foundation
import UIKit

public class KPTwoWayBinding<Model>: KPBinding<Model> {
    
    var addTargetWithActionForEvent: ((Any?, Selector) -> ())!
    var removeTargetWithActionForEvent: ((Any?, Selector) -> ())!
    
    var viewUpdateModel:             ((inout Model) -> (Bool))!
    
    public init<V: KPTwoWayView>(_ mKeyPath: WritableKeyPath<Model, V.Value>,
                                 _ view: V,
                                 _ vKeyPath: ReferenceWritableKeyPath<V, V.Value>,
                                 _ event: UIControl.Event) {
        super.init()
        
        viewUpdateModel = { [weak view] in
            guard let view = view else { return false }
            
            $0[keyPath: mKeyPath] = view[keyPath: vKeyPath]
            
            return true
        }
        
        addTargetWithActionForEvent = { [weak view] in
            guard let view = view else { return }
            
            view.addTarget($0, action: $1, for: event)
        }
        
        removeTargetWithActionForEvent = { [weak view] in
            guard let view = view else { return }

            view.removeTarget($0, action: $1, for: event)
        }
        
        id = view.id
        modelKeyPath = mKeyPath
        
        updateViewWithModel = { [weak view] in
            guard let view = view else { return false }
            
            view[keyPath: vKeyPath] = $0[keyPath: mKeyPath]
            
            return true
        }
        
    }
    
    public init<V: UIControl, Value>(_ mKeyPath: WritableKeyPath<Model, Value>,
                                     _ view: V,
                                     _ event: UIControl.Event,
                                     _ updateView: @escaping (V, Value) -> (),
                                     _ updateModel: @escaping (Model, V) -> ()) {
        super.init()
        
        viewUpdateModel = { [weak view] in
            guard let view = view else { return false }
            
            updateModel($0, view)
            
            return true
        }
        
        addTargetWithActionForEvent = { [weak view] in
            guard let view = view else { return }
            
            view.addTarget($0, action: $1, for: event)
        }
        
        removeTargetWithActionForEvent = { [weak view] in
            guard let view = view else { return }

            view.removeTarget($0, action: $1, for: event)
        }
        
        id = view.id
        modelKeyPath = mKeyPath
        
        updateViewWithModel = { [weak view] in
            guard let view = view else { return false }
            
            updateView(view, $0[keyPath: mKeyPath])
            
            return true
        }
        
    }
}


infix operator <=>

public extension KPTwoWayView {
    
    static func <=> <Model>(mKeyPath: WritableKeyPath<Model, Self.Value>, view: Self) -> KPTwoWayBinding<Model> {
        KPTwoWayBinding(mKeyPath, view, Self.keyPath, Self.twoWayEvent)
    }
}

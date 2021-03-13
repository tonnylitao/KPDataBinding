//
//  KPOneWayBinding.swift
//  
//
//  Created by Tonny on 6/03/21.
//

import Foundation
import UIKit

public class KPOneWayBinding<Model> {
    var modelKeyPath: AnyKeyPath!
    var updateView: ((Model) -> (Bool))!
    
    public init<V: UIView, Value>(_ mKeyPath: KeyPath<Model, Value>,
                                  _ view: V,
                                  updateView: @escaping (V, Value, Model) -> ()) {
        modelKeyPath = mKeyPath
        
        self.updateView = { [weak view] model in
            guard let view = view else { return false }
            
            updateView(view, model[keyPath: mKeyPath], model)
            
            return true
        }
    }
    
    public convenience init<V: KPOneWayView>(_ mKeyPath: KeyPath<Model, V.Value>,
                                             _ view: V,
                                             _ vKeyPath: ReferenceWritableKeyPath<V, V.Value>) where V.View == V {
        self.init(mKeyPath, view, updateView: { view, value, model in
            view[keyPath: V.keyPath] = value
        })
    }
}


infix operator =>

public extension KPSelfOneWayView {
    
    /*
     let bindings = [s
        \User.aString => uiLabel,
        \User.aString => uiTextField,
        \User.aBool   => uiButton,
     ]
     */
    
    static func => <Model>(mKeyPath: WritableKeyPath<Model, Self.Value>, view: Self) -> KPOneWayBinding<Model> {
        KPOneWayBinding(mKeyPath, view, Self.keyPath)
    }
}

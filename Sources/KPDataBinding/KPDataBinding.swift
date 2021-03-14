//
//  KPDataBinding.swift
//
//
//  Created by Tonny on 6/03/21.
//

import UIKit

public class KPDataBinding<Model> {
    
    lazy private var _oneWayBindings = [KPOneWayBinding<Model>]()
    lazy private var _twoWayBindings = [KPTwoWayBinding<Model>]()
    
    public var model: Model! {
        didSet {
            _oneWayBindings.forEach {
                _ = $0.updateView(model)
            }
            _twoWayBindings.forEach {
                _ = $0.updateView(model)
            }
        }
    }
    
    public init(_ model: Model? = nil) {
        self.model = model
    }
    
    @objc func viewChanged(control: UIControl) {
        guard let eventReceiver = control as? KPTwoWayEventReceiver else {
            assert(false)
            return
        }
        
        eventReceiver.handleEvent()
        
        /*
         two way binding first
         */
        var affectedKeyPaths = Set<AnyKeyPath>()
        
        _twoWayBindings
            .filter { $0.tag == control.tag }
            .forEach {
                _ = $0.updateModel(&model)
                affectedKeyPaths.insert($0.modelKeyPath)
            }
        
        /*
         one way binding later
         */
        _oneWayBindings
            .filter { affectedKeyPaths.contains($0.modelKeyPath) }
            .forEach {
                _ = $0.updateView(model)
            }
    }
}

extension KPDataBinding {
    /*
     binding.oneWayBind(\.intProperty, textField) { view, value, _ in
        view.text = "\(value)"
     }
     */
    
    @discardableResult
    public func oneWayBind<V: UIView, Value>(_ mKeyPath: KeyPath<Model, Value>,
                                             _ view: V,
                                             updateView: @escaping (V, Value, Model) -> ()) -> Self {
        return bind(
            KPOneWayBinding(mKeyPath, view, updateView: updateView)
        )
    }
    
    /*
     binding.bind(\.name => nameField)
     
     binding.bind(
        \.name => nameField,
        \.email => emailField,
        KPOneWayBinding(\.intProperty, textField, updateView: { view, value in view.text = "\(value)" })
     )
     */
    
    @discardableResult
    public func bind(_ bindings: KPOneWayBinding<Model>...) -> Self {
        bindings.forEach { binding in
            if let m = model {
                _ = binding.updateView(m)
            }
            
            _oneWayBindings.append(binding)
        }
        
        return self
    }
    
}

extension KPDataBinding {
    /*
     binding.twoWayBind(\.intProperty, textField, updateView: { view, value, _ in
        view.text = "\(value)"
     }, updateModel: { model, view in
        model.intProperty = Int(view.text) ?? 0
     })
     */
    @discardableResult
    public func twoWayBind<V: KPTwoWayView, Value>(_ mKeyPath: WritableKeyPath<Model, Value>,
                                                   _ view: V,
                                                   updateView: @escaping (V, Value, Model) -> (),
                                                   updateModel: @escaping (inout Model, V) -> ()) -> Self {
        return bind(
            KPTwoWayBinding(
                mKeyPath, view, V.twoWayEvent, updateView: updateView, updateModel: updateModel
            )
        )
    }
    
    /*
    binding.bind(\.name => nameField)
    
    binding.bind(
       \.name <=> nameField,
       \.email <=> emailField,
       KPTwoWayBinding(\.intProperty, textField, updateView: { view, value, _ in
          view.text = "\(value)"
       }, updateModel: { model, view in
          model.intProperty = Int(view.text) ?? 0
       })
    )
    */
    @discardableResult
    public func bind(_ bindings: KPTwoWayBinding<Model>...) -> Self {
        bindings.forEach { binding in
            assert(binding.tag > 0)
            
            if let m = model {
                _ = binding.updateView(m)
            }
            
            _twoWayBindings.append(binding)
            
            binding.addTargetWithActionForEvent(self, #selector(viewChanged))
        }
        
        return self
    }
}


extension KPDataBinding {
    
    @discardableResult
    public func update<Value>(_ keyPath: WritableKeyPath<Model, Value>, with value: Value) -> Bool {
        model[keyPath: keyPath] = value
        
        let oneWayUpdated = _oneWayBindings.filter({ $0.modelKeyPath == keyPath && $0.updateView(model) })
        let twoWayUpdated = _twoWayBindings.filter({ $0.modelKeyPath == keyPath && $0.updateView(model) })
        
        return !oneWayUpdated.isEmpty || !twoWayUpdated.isEmpty
    }
}

extension KPDataBinding {
    
    public func unbind<Value>(_ keyPath: KeyPath<Model, Value>) {
        _oneWayBindings.removeAll { $0.modelKeyPath == keyPath }
        
        _twoWayBindings
            .filter { $0.modelKeyPath == keyPath }
            .forEach { $0.removeTargetWithActionForEvent(self, #selector(viewChanged)) }
        _twoWayBindings.removeAll { $0.modelKeyPath == keyPath }
    }
}

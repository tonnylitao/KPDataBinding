//
//  TwoWayBindingTests.swift
//  
//
//  Created by Tonny on 6/03/21.
//

import XCTest
@testable import KPDataBinding

class TwoWayBindingTests: XCTestCase {
    
    var binding: KPDataBinding<User>!
    
    var field: UITextField!
    var btn: UIButton!
    var switcher: UISwitch!
    var slider: UISlider!
    var stepper: UIStepper!
    
    override func setUpWithError() throws {
        field = UITextField(); field.tag = 1
        btn = UIButton(); btn.tag = 2
        switcher = UISwitch(); switcher.tag = 3
        slider = UISlider(); slider.tag = 4
        stepper = UIStepper(); stepper.tag = 5
        
        binding = KPDataBinding(User())
        XCTAssertNotNil(binding.model)
    }
    
    override func tearDownWithError() throws {}

    func testInitial() throws {
        binding.bind(
            KPTwoWayBinding(\.email, field),
            KPTwoWayBinding(\.likesTravel, btn),
            KPTwoWayBinding(\.isOnline, switcher),
            KPTwoWayBinding(\.activity, slider),
            KPTwoWayBinding(\.step, stepper)
        )
        
        XCTAssertEqual(field.text, "")
        XCTAssertFalse(btn.isSelected)
        XCTAssertEqual(switcher.isOn, false)
        XCTAssertEqual(slider.value, 0)
        XCTAssertEqual(stepper.value, 0)
    }
    
    func testInitialWithData() throws {
        let model = User.random
        binding.model = model
        binding.bind(
            KPTwoWayBinding(\.email, field),
            KPTwoWayBinding(\.likesTravel, btn),
            KPTwoWayBinding(\.isOnline, switcher),
            KPTwoWayBinding(\.activity, slider),
            KPTwoWayBinding(\.step, stepper)
        )
        
        XCTAssertEqual(field.text, binding.model.email)
        XCTAssertEqual(btn.isSelected, binding.model.likesTravel)
        XCTAssertEqual(switcher.isOn, binding.model.isOnline)
        XCTAssertEqual(slider.value, binding.model.activity)
        XCTAssertEqual(stepper.value, binding.model.step)
    }

    func testUpdate() throws {
        binding.bind(
            KPTwoWayBinding(\.email, field),
            KPTwoWayBinding(\.likesTravel, btn),
            KPTwoWayBinding(\.isOnline, switcher),
            KPTwoWayBinding(\.activity, slider),
            KPTwoWayBinding(\.step, stepper)
        )
        
        //
        var email: String? = "test@gmail.com"
        binding.update(\.email, with: email)
        XCTAssertEqual(binding.model.email, email)
        XCTAssertEqual(field.text, email)
        
        email = nil
        binding.update(\.email, with: email)
        XCTAssertEqual(binding.model.email, nil)
        XCTAssertEqual(field.text, "") //UITextField text is "" even set to nil
        
        //
        var likesTravel = false
        binding.update(\.likesTravel, with: likesTravel)
        XCTAssertEqual(binding.model.likesTravel, false)
        XCTAssertEqual(btn.isSelected, likesTravel)
        
        likesTravel = true
        binding.update(\.likesTravel, with: likesTravel)
        XCTAssertEqual(binding.model.likesTravel, true)
        XCTAssertEqual(btn.isSelected, likesTravel)
        
        //
        var isOnline = false
        binding.update(\.isOnline, with: isOnline)
        XCTAssertEqual(binding.model.isOnline, false)
        XCTAssertEqual(switcher.isOn, isOnline)
        
        isOnline = true
        binding.update(\.isOnline, with: isOnline)
        XCTAssertEqual(binding.model.isOnline, true)
        XCTAssertEqual(switcher.isOn, isOnline)
        
        //
        let activity: Float = 0.4
        binding.update(\.activity, with: activity)
        XCTAssertEqual(binding.model.activity, activity)
        XCTAssertEqual(slider.value, activity)
        
        //
        let step: Double = 0.1
        binding.update(\.step, with: step)
        XCTAssertEqual(binding.model.step, step)
        XCTAssertEqual(stepper.value, step)
    }

    func testUnbind() throws {
        binding.bind(
            KPTwoWayBinding(\.email, field),
            KPTwoWayBinding(\.likesTravel, btn),
            KPTwoWayBinding(\.isOnline, switcher),
            KPTwoWayBinding(\.activity, slider),
            KPTwoWayBinding(\.step, stepper)
        )
        
        
        binding.unbind(\.info)
        XCTAssertFalse(binding.update(\.info, with: ""))
        
        binding.unbind(\.email)
        XCTAssertFalse(binding.update(\.email, with: ""))
        
        binding.unbind(\.likesTravel)
        XCTAssertFalse(binding.update(\.likesTravel, with: true))
        
        binding.unbind(\.avatar)
        XCTAssertFalse(binding.update(\.avatar, with: nil))
        
        binding.unbind(\.isOnline)
        XCTAssertFalse(binding.update(\.isOnline, with: true))
        
        binding.unbind(\.activity)
        XCTAssertFalse(binding.update(\.activity, with: 0.1))
        
        binding.unbind(\.step)
        XCTAssertFalse(binding.update(\.step, with: 0.3))
    }
    
    func testOneStateToManyView() throws {
        let field1 = UITextField(); field1.tag = 1
        let field2 = UITextField(); field2.tag = 2
        let field3 = UITextField(); field3.tag = 3

        binding.bind(
            KPTwoWayBinding(\.info, field1),
            KPTwoWayBinding(\.info, field2),
            KPTwoWayBinding(\.info, field3)
        )
        
        //
        binding.update(\.info, with: "a new info")
        XCTAssertEqual(field1.text, binding.model.info)
        XCTAssertEqual(field2.text, binding.model.info)
        XCTAssertEqual(field3.text, binding.model.info)

        //
        binding.update(\.info, with: nil)
        XCTAssertEqual(field1.text, "")
        XCTAssertEqual(field2.text, "")
        XCTAssertEqual(field3.text, "")
    }

    func testManyStateToOneView() throws {
        binding.bind(
            KPTwoWayBinding(\.info, field),
            KPTwoWayBinding(\.email, field)
        )
        binding.model = .random

        //last binding
        XCTAssertEqual(field.text, binding.model.email)

        let newInfo = "a new Info"
        binding.update(\.info, with: newInfo)
        XCTAssertEqual(field.text, newInfo)

        let newEmail = "newEmail@test.com"
        binding.update(\.email, with: newEmail)
        XCTAssertEqual(field.text, newEmail)
    }
    
    func testUpdateView() throws {
        binding.bind(
            KPTwoWayBinding(\.amount, field, .editingChanged, updateView: { view, value, _ in
                view.text = "$\(value?.description ?? "")"
            }, updateModel: { model, view in
                var text = view.text
                text?.removeFirst()
                model.amount = Decimal(string: text ?? "")
            })
        )
        binding.model = .random
        XCTAssertEqual(field.text, "$\(binding.model.amount!.description)")

        
        let amount: Decimal = 100
        binding.update(\.amount, with: amount)
        XCTAssertEqual(binding.model.amount, amount)
        XCTAssertEqual(field.text, "$100")


        binding.update(\.amount, with: nil)
        XCTAssertNil(binding.model.amount)
        XCTAssertEqual(field.text, "$")
        
        field.text = "$200"
        binding.viewChanged(control: field)
        XCTAssertEqual(binding.model.amount, 200)
    }
    
    func testUpdateMultileViews() throws {
        let nzdField = UITextField(); nzdField.tag = 1
        let cnyField = UITextField(); cnyField.tag = 2
        
        binding.bind(
            KPTwoWayBinding(\.amount, nzdField, .editingChanged, updateView: { view, value, _ in
                view.text = "$\(value?.description ?? "")"
            }, updateModel: { model, view in
                var text = view.text
                text?.removeFirst()
                model.amount = Decimal(string: text ?? "")
            }),
            KPTwoWayBinding(\.amount, cnyField, .editingChanged, updateView: { view, value, _ in
                view.text = "¥\(((value ?? 0) * 4.5).description )"
            }, updateModel: { model, view in
                var text = view.text
                text?.removeFirst()
                model.amount = (Decimal(string: text ?? "") ?? 0) / 4.5
            })
        )

        
        binding.update(\.amount, with: 100)
        XCTAssertEqual(nzdField.text, "$100")
        XCTAssertEqual(cnyField.text, "¥450")
        
        nzdField.text = "$1000"
        binding.viewChanged(control: nzdField)
        XCTAssertEqual(binding.model.amount, 1000)
        XCTAssertEqual(cnyField.text, "¥4500")
        
        cnyField.text = "$45000"
        binding.viewChanged(control: cnyField)
        XCTAssertEqual(binding.model.amount, 10000)
        XCTAssertEqual(nzdField.text, "$10000")
    }

    static var allTests = [
        ("testInitial", testInitial),
        ("testInitialWithData", testInitialWithData),
        ("testUpdate", testUpdate),
        ("testUnbind", testUnbind),
        ("testOneStateToManyView", testOneStateToManyView),
        ("testManyStateToOneView", testManyStateToOneView),
        ("testUpdateView", testUpdateView),
        ("testUpdateMultileViews", testUpdateMultileViews)
    ]

}


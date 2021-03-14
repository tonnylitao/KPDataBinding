//
//  TwoWayOperatorBindingTests.swift
//  
//
//  Created by Tonny on 6/03/21.
//

import XCTest
@testable import KPDataBinding

class TwoWayOperatorBindingTests: XCTestCase {
    
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
            \.email <=> field,
            \.likesTravel <=> btn,
            \.isOnline <=> switcher,
            \.activity <=> slider,
            \.step <=> stepper
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
            \.email <=> field,
            \.likesTravel <=> btn,
            \.isOnline <=> switcher,
            \.activity <=> slider,
            \.step <=> stepper
        )
        
        XCTAssertEqual(field.text, binding.model.email)
        XCTAssertEqual(btn.isSelected, binding.model.likesTravel)
        XCTAssertEqual(switcher.isOn, binding.model.isOnline)
        XCTAssertEqual(slider.value, binding.model.activity)
        XCTAssertEqual(stepper.value, binding.model.step)
    }

    func testUpdate() throws {
        binding.bind(
            \.email <=> field,
            \.likesTravel <=> btn,
            \.isOnline <=> switcher,
            \.activity <=> slider,
            \.step <=> stepper
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
            \.email <=> field,
            \.likesTravel <=> btn,
            \.isOnline <=> switcher,
            \.activity <=> slider,
            \.step <=> stepper
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
            \.info <=> field1,
            \.info <=> field2,
            \.info <=> field3
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
            \.info <=> field,
            \.email <=> field
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

    static var allTests = [
        ("testInitial", testInitial),
        ("testInitialWithData", testInitialWithData),
        ("testUpdate", testUpdate),
        ("testUnbind", testUnbind),
        ("testOneStateToManyView", testOneStateToManyView),
        ("testManyStateToOneView", testManyStateToOneView)
    ]

}


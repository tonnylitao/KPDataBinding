//
//  OneWayOperatorTests.swift
//  
//
//  Created by Tonny on 6/03/21.
//

import XCTest
import Foundation
@testable import KPDataBinding

class OneWayOperatorTests: XCTestCase {
    var binding: KPDataBinding<User>!
    
    var lbl: UILabel!
    var field: UITextField!
    var btn: UIButton!
    var imgView: UIImageView!
    var switcher: UISwitch!
    var slider: UISlider!
    var stepper: UIStepper!
    
    override func setUpWithError() throws {
        lbl = UILabel()
        field = UITextField()
        btn = UIButton()
        imgView = UIImageView()
        switcher = UISwitch()
        slider = UISlider()
        stepper = UIStepper()
        
        binding = KPDataBinding(User())
        XCTAssertNotNil(binding.model)
    }
    
    override func tearDownWithError() throws {}
    
    func testInitial() throws {
        binding.bind(
            \.info => lbl,
            \.email => field,
            \.likesTravel => btn,
            \.avatar => imgView,
            \.isOnline => switcher,
            \.activity => slider,
            \.step => stepper
        )
        
        XCTAssertNil(lbl.text)
        XCTAssertEqual(field.text, "")
        XCTAssertFalse(btn.isSelected)
        XCTAssertNil(imgView.image)
        XCTAssertEqual(switcher.isOn, false)
        XCTAssertEqual(slider.value, 0)
        XCTAssertEqual(stepper.value, 0)
    }
    
    func testInitialWithData() throws {
        let model = User.random
        binding.model = model
        binding.bind(
            \.info => lbl,
            \.email => field,
            \.likesTravel => btn,
            \.avatar => imgView,
            \.isOnline => switcher,
            \.activity => slider,
            \.step => stepper
        )
        
        XCTAssertEqual(lbl.text, binding.model.info)
        XCTAssertEqual(field.text, binding.model.email)
        XCTAssertEqual(btn.isSelected, binding.model.likesTravel)
        XCTAssertEqual(imgView.image, binding.model.avatar)
        XCTAssertEqual(switcher.isOn, binding.model.isOnline)
        XCTAssertEqual(slider.value, binding.model.activity)
        XCTAssertEqual(stepper.value, binding.model.step)
    }
    
    func testUpdate() throws {
        binding.bind(
            \.info => lbl,
            \.email => field,
            \.likesTravel => btn,
            \.avatar => imgView,
            \.isOnline => switcher,
            \.activity => slider,
            \.step => stepper
        )
        
        //
        var info: String? = "new info"
        binding.update(\.info, with: info)
        XCTAssertEqual(binding.model.info, info)
        XCTAssertEqual(lbl.text, info)
        
        info = nil
        binding.update(\.info, with: info)
        XCTAssertEqual(binding.model.info, nil)
        XCTAssertEqual(lbl.text, nil)
        
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
            \.info => lbl,
            \.email => field,
            \.likesTravel => btn,
            \.avatar => imgView,
            \.isOnline => switcher,
            \.activity => slider,
            \.step => stepper
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
        let lbl1 = UILabel()
        let lbl2 = UILabel()
        let field3 = UITextField()
        
        binding.bind(
            \.info => lbl1,
            \.info => lbl2,
            \.info => field3
        )
        
        //
        binding.update(\.info, with: "a new info")
        XCTAssertEqual(lbl1.text, binding.model.info)
        XCTAssertEqual(lbl2.text, binding.model.info)
        XCTAssertEqual(field3.text, binding.model.info)
        
        //
        binding.update(\.info, with: nil)
        XCTAssertEqual(lbl1.text, nil)
        XCTAssertEqual(lbl2.text, nil)
        XCTAssertEqual(field3.text, "")
    }
    
    func testManyStateToOneView() throws {
        binding.bind(
            \.info => lbl,
            \.email => lbl
        )
        binding.model = .random
        
        //last binding
        XCTAssertEqual(lbl.text, binding.model.email)
        
        let newInfo = "a new Info"
        binding.update(\.info, with: newInfo)
        XCTAssertEqual(lbl.text, newInfo)
        
        let newEmail = "newEmail@test.com"
        binding.update(\.email, with: newEmail)
        XCTAssertEqual(lbl.text, newEmail)
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

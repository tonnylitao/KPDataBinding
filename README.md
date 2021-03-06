# KPDataBinding
DataBinding with Swift KeyPath
[https://github.com/tonnylitao/KPDataBinding](https://github.com/tonnylitao/KPDataBinding)

### One-way data binding
```swift
struct User {
    var name:   String?
}

let binding = KPDataBinding<User>()

binding.bind(
    \.name => uiLabel
)

binding.update(\.name, with: "Tonny")

//binding.model.name == "Tonny"
//uiLabel.text == "Tonny"
```
##### Customised one-way data binding

* render a customised data in view

```swift
struct User {
    var age: Int
}

binding.oneWayBind(\.age, ageLabel) { view, value, _ in
    view.text = "Your Age: \(value)"
}

binding.update(\.age, with: 10)

//binding.model.age == 10
//ageLabel.text == "Your Age: 10"
```

### Two-way data binding

```swift
struct User {
    var aString:    String?
    var isOn:       Bool
    var isSelected: Bool
    var isSelected: Bool
    var aFloat:     Float
    var aDouble:    Double
}

binding.bind([
    \.aString     <=> uiTextField,
    \.isOn        <=> uiSwitcher,
    \.isSelected  <=> uiButton,
    \.aFloat      <=> uiSlider,
    \.aDouble     <=> uiSteper,
])

//view value and model value will be equal 

//binding.model.isOn == uiSwitcher.isOn

//binding.model.isSelected == uiButton.isSelected

//binding.model.aFloat == uiSlider.value

//binding.model.aDouble == uiSteper.value
```

Note: This text of UITextField is @"" by default. https://developer.apple.com/documentation/uikit/uitextfield/1619635-text

```
binding.update(\.aString, with: nil)
//userViewModel.model.aString == nil
//uiTextField.text == ""

binding.update(\.aString, with: "A new String")
//binding.model.aString == "A new String"
//uiTextField.text == "A new String"
```

##### customised update logic for view and model in two-way data binding

```swift
binding.twoWayBind(\.age, ageSteper, 
	updateView: { view, value, _ in
		view.value = Double(value)
	}, 
	updateModel: { model, view in
		model.age = Int(view.value)
	}
)

//when ageSteper's value changed to 3.0
//binding.model.age == 3

//when age changed to 4
//uiSteper.value == 4.0

```

### Update model and view

Always update model through ViewModel, and the binding view will be updated automatically.

```
binding.update(\User.name, with: "A new Name")
```

### Unbind

```
binding.unbind(\User.name)
```

### How does KPDataBinding work?

```swift
model[keyPath: \User.name] = "Tonny"       //update model
view[keyPath: \UITextField.text] = "Tonny" //update view


view[keyPath: \UITextField.text] = model[keyPath: \User.name]  //update view from model


view.addTarget(self, #selector(viewChanged), for: event)
func viewChanged(view: UITextField) {
    model[keyPath: \User.name] = view[keyPath: \UITextField.text]  //update model from view
}
```

# Associated
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![Build Status](https://github.com/ATeamMac2014/Associated/workflows/Swift/badge.svg)

✨ Add associated property  for extension of protocol or class


## At a Glance

Add associated property  for extension of protocol

```swift

protocol FullNamed: class {
    var name: String {get set}
}

extension FullNamed where Self: AssociatedCompatible {
    var name: String {
        get {
            return self.associated.value(default: "")
        }
        
        set {
            self.associated.setValue(newValue)
        }
    }
}

class Person: FullNamed, AssociatedCompatible {
    
}

let person: FullNamed = Person()
person.name = "roger"
let name = person.name
XCTAssertEqual(name, "roger")
```

## Tips and Tricks

- You can use `Associated` to all of `NSObject` subclasses.

```swift
class Animal: NSObject {
}

extension Animal: FullNamed {
}

extension Animal {
    var age: Int? {
        get {
            return self.associated.value()
        }
        
        set {
            self.associated.setValue(newValue)
        }
    }
}

let animal = Animal()
animal.age = 100;
let age = animal.age
XCTAssertEqual(age, 100)
```

## Installation

- **Using [Swift Package Manager](https://swift.org/package-manager)**:

```swift
import PackageDescription

let package = Package(
  name: "MyAwesomeApp",
  dependencies: [
    .Package(url: "https://github.com/IMFWorks/Associated", majorVersion: 1),
  ]
)
```

## License

**Associated** is under Apache license. See the [LICENSE](LICENSE) file for more info.

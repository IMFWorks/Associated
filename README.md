# Associated
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
[![Build Status](https://travis-ci.org/devxoul/Then.svg?branch=master)](https://travis-ci.org/devxoul/Then)

✨ Add associated property  for extension of class or protocol


## At a Glance

Add associated property  for extension of protocol

```swift
let person: FullNamed = Person()
person.name = "roger"
let name = person.name
XCTAssertEqual(name, "roger")


protocol FullNamed: class {
    var name: String {get set}
}

// 给协议添加存储属性
extension FullNamed where Self: AssociatedCompatible {
    var name: String {
        get {
            return self.associated.value() as? String ?? ""
        }
        
        set {
            self.associated.setValue(newValue as Any)
        }
    }
}

class Person: FullNamed, AssociatedCompatible {
    
}

```

## Tips and Tricks

- You can use `Associated` to all of `NSObject` subclasses.

```swift
    
let animal = Animal()
animal.age = 100;
let age = animal.age
XCTAssertEqual(age, 100)
       
class Animal: NSObject {
}

extension Animal: FullNamed {
}

// 给扩展添加存储属性
extension Animal {
    var age: Int {
        get {
            return self.associated.value() as? Int ?? 0
        }
        
        set {
            self.associated.setValue(newValue as Any)
        }
    }
}
```

## Installation

- **Using [Swift Package Manager](https://swift.org/package-manager)**:

```swift
import PackageDescription

let package = Package(
  name: "MyAwesomeApp",
  dependencies: [
    .Package(url: "https://github.com/ATeamMac2014/Associated", majorVersion: 1),
  ]
)
```

## License

**Associated** is under Apache license. See the [LICENSE](LICENSE) file for more info.

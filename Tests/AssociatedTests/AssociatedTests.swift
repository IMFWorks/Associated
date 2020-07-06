import XCTest
@testable import Associated

final class AssociatedTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        //
        let person: FullNamed = Person()
        person.name = "roger"
        let name = person.name
        XCTAssertEqual(name, "roger")
        
        
        let animal = Animal()
        animal.age = 100;
        let age = animal.age
        XCTAssertEqual(age, 100)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

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

import XCTest
@testable import Associated

final class AssociatedTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let person: PersonProtocol = Person()
        person.name = "roger"
        let name = person.name
        XCTAssertEqual(name, "roger")
        
        
        let animal = Animal()
        animal.name = "tiger"
        let animalName = animal.name;
        XCTAssertEqual(animalName, "tiger")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

protocol PersonProtocol: class {
    var name: String {get set}
}

extension PersonProtocol where Self: AssociatedCompatible {
    var name: String {
        get {
            return self.associated.value() as? String ?? ""
        }
        
        set {
            self.associated.setValue(newValue as Any)
        }
    }
}

class Person: PersonProtocol, AssociatedCompatible {
    
}

class Animal: NSObject {
    var name: String? {
        get {
            return self.associated.value() as? String
        }
        
        set {
            self.associated.setValue(newValue as Any)
        }
    }
}

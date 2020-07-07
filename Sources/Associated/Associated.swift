 import Foundation
 
public struct Associated<Base> where Base: AnyObject {
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

extension Associated {
    public func setValue<T>(_ value: T, forName name: String = #function) {
        return AssociatedPropertys.globalAssociatedPropertys.setValue(value, forName: name , forObject: base)
    }
    
    public func value<T>(default: @autoclosure () -> T, forName name: String = #function) -> T {
        return AssociatedPropertys.globalAssociatedPropertys.value(fromObject: base, forName: name, default: `default`()) as! T
    }
    
    public func setValue<T>(_ value: T?, forName name: String = #function) {
        return AssociatedPropertys.globalAssociatedPropertys.setValue(value, forName: name , forObject: base)
    }
    
    public func value<T>(forName name: String = #function) -> T? {
        return AssociatedPropertys.globalAssociatedPropertys.value(fromObject: base, forName: name) as? T
    }
}
 
 private enum AssociatedPropertys {
     static let globalAssociatedPropertys = AssociatedProperty<AnyObject, Any>()
 }

/// A type that has Associated extensions.
public protocol AssociatedCompatible {
    /// Associated type
    associatedtype Base: AnyObject

    /// Associated extensions.
    var associated: Associated<Base> { get }
}

extension AssociatedCompatible where Self: AnyObject {
    /// Associated  extensions.
    public var associated: Associated<Self> {
        return Associated(self)
    }
}
 
extension NSObject: AssociatedCompatible {
    
}

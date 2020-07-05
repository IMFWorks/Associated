//
//  File.swift
//  
//
//  Created by 吴芮生 on 2020/7/3.
//

import Foundation

final public class AssociatedProperty<Object, Value> where Object: AnyObject {
    private var storage: [Weak<Object>: DictionaryWrapper<Value>] = [:]
    private let lock = NSRecursiveLock()

    // MARK: Initializing
    public init() {
        
    }
    
    // MARK: Getting and Setting Values
    public func value(fromObject object: Object, forName name: String) -> Value? {
        let weakObject = Weak(object)

        self.lock.lock()
        defer {
          self.lock.unlock()
        }

        return self.unsafeValue(fromObject: weakObject, forName: name)
    }

    public func value(fromObject object: Object
        ,forName name: String
        ,default: @autoclosure () -> Value) -> Value {
        
        let weakObject = Weak(object)
        self.lock.lock()
        defer {
            self.lock.unlock()
        }

        if let value = self.unsafeValue(fromObject: weakObject, forName: name) {
            return value
        }

        let defaultValue = `default`()
        self.unsafeSetValue(defaultValue, forName: name, forObject: weakObject)
        return defaultValue
    }

    public func forceCastedValue<T>(fromObject object: Object, forName name: String, default: @autoclosure () -> T) -> T {
        return self.value(fromObject: object, forName: name, default: `default`() as! Value) as! T
    }

    public func setValue(_ value: Value?, forName name: String, forObject object: Object) {
        let weakObject = Weak(object)
        self.lock.lock()
        defer {
            self.lock.unlock()
        }

        self.unsafeSetValue(value, forName: name, forObject: weakObject)
    }


    // MARK: Getting and Setting Values without Locking
    private func unsafeValue(fromObject object: Weak<Object>, forName name: String) -> Value? {
        guard let associatedPair = self.storage[object] else {
            return nil
        }

        return associatedPair.value(forKey: name)
    }

    private func unsafeSetValue(_ value: Value?, forName name: String, forObject object: Weak<Object>) {
        var associatedPair = self.storage[object];
        if associatedPair == nil {
            associatedPair = DictionaryWrapper<Value>(dictionary: Dictionary<String, Value>())
            self.storage[object] = associatedPair
            if let rawObject = object.object {
                installDeallocHook(to: rawObject)
            }
        }

        associatedPair?.setValue(value, forKey: name)
    }


    // MARK: Dealloc Hook
    private var deallocHookKey: Void?

    private func installDeallocHook(to object: Object) {
        let isInstalled = (objc_getAssociatedObject(object, &deallocHookKey) != nil)
        guard !isInstalled else { return }

        let weakKey = Weak(object)
        let hook = DeallocHook(handler: { [weak self] in
            self?.lock.lock()
            self?.storage.removeValue(forKey: weakKey)
            self?.lock.unlock()
        })
        objc_setAssociatedObject(object, &deallocHookKey, hook, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

// MARK: - Weak

private final class Weak<T>: Hashable where T: AnyObject {
  private let objectHashValue: Int
  weak var object: T?

  init(_ object: T) {
    self.objectHashValue = ObjectIdentifier(object).hashValue
    self.object = object
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(self.objectHashValue)
  }

  static func == (lhs: Weak<T>, rhs: Weak<T>) -> Bool {
    return lhs.objectHashValue == rhs.objectHashValue
  }
}

// MARK: - DeallocHook
private final class DeallocHook {
  private let handler: () -> Void

  init(handler: @escaping () -> Void) {
    self.handler = handler
  }

  deinit {
    self.handler()
  }
}

private final class DictionaryWrapper<Value> {
    var dictionary: Dictionary<String, Value>
    
    init(dictionary: Dictionary<String, Value>) {
        self.dictionary = dictionary
    }
    
    func value(forKey key: String) -> Value? {
        return dictionary[key]
    }
    
    func setValue(_ value: Value?, forKey key: String) {
      if let value = value {
        self.dictionary[key] = value
      } else {
        self.dictionary.removeValue(forKey: key)
      }
    }
}


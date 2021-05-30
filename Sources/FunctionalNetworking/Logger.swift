import Foundation

public func logger<T: Any>(_ value: T) -> T { dump(value); return value }

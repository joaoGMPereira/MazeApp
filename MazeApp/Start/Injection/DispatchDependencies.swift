import Dispatch

protocol HasMainQueue: AnyObject {
    var mainQueue: DispatchQueue { get }
}

protocol HasGlobalQueue {
    var globalQueue: DispatchQueue { get }
}

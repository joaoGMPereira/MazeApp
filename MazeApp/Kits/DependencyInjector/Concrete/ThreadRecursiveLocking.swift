import Foundation

protocol ThreadRecursiveLocking {
    func lock()
    func unlock()
}

extension NSRecursiveLock: ThreadRecursiveLocking {}

final class MutexRecursiveLock: ThreadRecursiveLocking {
    init() {
        pthread_mutexattr_init(&recursiveMutexAttr)
        pthread_mutexattr_settype(&recursiveMutexAttr, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&recursiveMutex, &recursiveMutexAttr)
    }
    @inline(__always)
    func lock() {
        pthread_mutex_lock(&recursiveMutex)
    }
    @inline(__always)
    func unlock() {
        pthread_mutex_unlock(&recursiveMutex)
    }
    private var recursiveMutex = pthread_mutex_t()
    private var recursiveMutexAttr = pthread_mutexattr_t()
}

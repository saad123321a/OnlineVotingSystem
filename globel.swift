import Foundation

enum CustomResult<T> {
    case success(T)
    case failure(Error)
}

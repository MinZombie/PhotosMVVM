import Foundation
@testable import PhotosMVVM

struct DummyData {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    var completionHandler: DataTaskCompletionHandler? = nil
    
    func completion() {
        completionHandler?(data, response, error)
    }
}

class StubURLSession: URLSessionProtocol {
    var dummy: DummyData?
    
    init(dummy: DummyData) {
        self.dummy = dummy
    }
    
    func dataTask(with url: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTaskProtocol {
        return StubURLSessionDataTask(dummy: dummy, completionHandler: completionHandler)
    }
    
    
}

class StubURLSessionDataTask: URLSessionDataTaskProtocol {
    var dummy: DummyData?
    
    init(
        dummy: DummyData?,
        completionHandler: DataTaskCompletionHandler?
    ) {
        self.dummy = dummy
        self.dummy?.completionHandler = completionHandler
    }
    
    func resume() {
        dummy?.completion()
    }
}

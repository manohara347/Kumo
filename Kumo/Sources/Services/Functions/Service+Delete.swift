import RxSwift

public extension Service {
    
    public func delete<Response: Decodable>(_ endpoint: String, parameters: [String: Any] = [:], keyedUnder key: String? = nil) -> Observable<Response> {
        return dataTask(method: .delete, endpoint, parameters: parameters, keyedUnder: key)
    }

    public func delete(_ endpoint: String, parameters: [String: Any] = [:]) -> Observable<Void> {
        return dataTask(method: .delete, endpoint, parameters: parameters)
    }

    public func delete(_ endpoint: String, parameters: [String: Any] = [:]) -> Observable<Any> {
        return dataTask(method: .delete, endpoint, parameters: parameters)
    }
    
}

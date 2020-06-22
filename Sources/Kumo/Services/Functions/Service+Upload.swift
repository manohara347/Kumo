import Combine
import Foundation

public extension Service {
    
    /// Uploads to an endpoint the provided file. The file is uploaded as form data
    /// under the supplied key.
    ///
    /// - Parameters:
    ///   - endpoint: the path extension corresponding to the endpoint
    ///   - file: the URL of the file to upload
    ///   - key: the name of form part under which to embed the file's data
    /// - Returns: an `AnyPublisher` which emits a single empty element upon success.
    func upload(_ endpoint: String, parameters: [String: Any] = [:], file: URL, under key: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            do {
                var request = try self.createRequest(method: .post, endpoint: endpoint, queryParameters: parameters)
                guard file.isFileURL else { throw UploadError.notAFileURL(file) }
                let form = try MultipartForm(file: file, under: key, encoding: .utf8)
                request.set(contentType: .multipartFormData(boundary: form.boundary))
                let task = self.session.uploadTask(with: request, from: form.data) {
                    let result: Result<Void, Error> = self.result(data: $0, response: $1, error: $2)
                    self.fulfill(promise: promise, for: result)
                }
                task.resume()
            } catch {
                promise(.failure(error))
            }
        }
        .receive(on: receivingScheduler)
        .eraseToAnyPublisher()
    }

    /// Uploads to an endpoint the provided file. The file is uploaded as form data
    /// under the supplied key.
    ///
    /// - Parameters:
    ///   - endpoint: the path extension corresponding to the endpoint
    ///   - file: the URL of the file to upload
    ///   - key: the name of form part under which to embed the file's data
    /// - Returns: an `AnyPublisher` which emits the progress of the upload.
//    func upload(_ endpoint: String, parameters: [String: Any] = [:], file: URL, under key: String) -> AnyPublisher<Double, Error> {
//        Future<URLSessionUploadTask, Error> { promise in
//            do {
//                var request = try self.createRequest(method: .post, endpoint: endpoint, queryParameters: parameters)
//                guard file.isFileURL else { throw UploadError.notAFileURL(file) }
//                let form = try MultipartForm(file: file, under: key, encoding: .utf8)
//                request.set(contentType: .multipartFormData(boundary: form.boundary))
//                let task = self.session.uploadTask(with: request, from: form.data) {
//                    let result: Result<Void, Error> = self.result(data: $0, response: $1, error: $2)
//                    switch result {
                      // TODO: how does this work, what does it mean for this error to happen potentially after we've promised success?
//                    case .failure(error): promise(.failure(error))
//                    case .success(): break
//                    }
//                }
//                promise(.success(task))
//                task.resume()
//            } catch {
//                promise(.failure(error))
//            }
//        }.flatMap { (task: URLSessionUploadTask) in
//            task.progress.kumo.fractionComplete
//                .eraseToAnyPublisher()
//                .setFailureType(to: Error)
//        }
////        return Observable.create { [self] observer in
////            do {
////                var request = try self.createRequest(method: .post, endpoint: endpoint, queryParameters: parameters)
////                guard file.isFileURL else { throw UploadError.notAFileURL(file) }
////                let form = try MultipartForm(file: file, under: key, encoding: .utf8)
////                request.set(contentType: .multipartFormData(boundary: form.boundary))
////                let task = self.session.uploadTask(with: request, from: form.data) {
////                    guard let error = self.resultToEvent(data: $0, response: $1, error: $2).error else {
////                        return observer.onCompleted()
////                    }
////                    observer.onError(error)
////                }
////                task.resume()
////                observer.onNext(task)
////                return Disposables.create(with: task.cancel)
////            } catch {
////                observer.onError(error)
////                return Disposables.create()
////            }
////        }
////            .observeOn(operationScheduler)
////            .flatMap { (task: URLSessionUploadTask) in
////                task.progress.rx.fractionComplete
////                    .takeWhile { $0 < 1 }
////            }
//    }
    
}

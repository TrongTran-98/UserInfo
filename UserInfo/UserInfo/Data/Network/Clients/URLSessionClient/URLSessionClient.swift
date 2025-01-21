//
//  URLSessionClient.swift
//  UserInfo
//

import Foundation

/// We can extend it with other Libs (ex: URLSession, Alamofire, etc... ) by conform NetworkClient to do the same purposes
/// Example:
/// **
/// AlamofireSessionClient: NetworkClient {
///     func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, any Error>) -> Void) {
///             ... handling response based on alamofire lib APIs
///     }
///}
/// That help us change and update new 3rd Lib or trending technology without modifying code base
/// In this case we are using the URLSession as a network lib
///
/// - If we want to use customize request() function of URLSession,
/// just inhering class URLSessionClient and override that function
///
/// - Additionally, if we want to change Mapper behavior or customize URLSession, just injecting them into intialize function
/// Example
/// ** let client = URLSessionClient(dataMapper: CustomMapper, session: CustomURLSession)
///
class URLSessionClient {
    
    private let session: URLSession
    private let dataMapper: URLSessionMapper
    
    init(dataMapper: URLSessionMapper = DefaultURLSessionMapper(), session: URLSession = URLSession.shared) {
        self.dataMapper = dataMapper
        self.session = session
    }
    
}

extension URLSessionClient: NetworkClient {
    
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, any Error>) -> Void) {
        do {
            let request = try endpoint.urlRequest()
            let dataTask = session.dataTask(with: request, completionHandler: { data, response, error in
                /// Catch error if needed
                if let error = error {
                    completion(.failure(error))
                    return
                }
                /// Data response handling
                do {
                    let decodedModel = try self.dataMapper.mapData(T.self, data: data, response: response)
                    completion(.success(decodedModel))
                } catch {
                    completion(.failure(error))
                }
            })
            /// Execute task
            dataTask.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
}

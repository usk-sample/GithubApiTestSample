//
//  ApiClient.swift
//  GithubApiTestSample
//
//  Created by Yusuke Hasegawa on 2021/07/29.
//

import Foundation

import Combine

protocol ApiClientProtocol: AnyObject {
    func searchRepositories(query: String) -> AnyPublisher<SearchRepositoryResponse, Error>
}

class ApiClient {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    private let baseUrl: String = "https://api.github.com"
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .default) {
        self.session = session
        self.decoder = decoder
    }
}

extension ApiClient: ApiClientProtocol {
    
    func searchRepositories(query: String) -> AnyPublisher<SearchRepositoryResponse, Error> {
        let queryString = query.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: baseUrl + "/search/repositories?q=\(queryString)")!
        let request = URLRequest(url: url)
        debugPrint(url.absoluteString)
        return session
            .dataTaskPublisher(for: request)
            .validateNetwork()
            .decode(type: SearchRepositoryResponse.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }
}

extension URLSession.DataTaskPublisher {
    
    public func validateNetwork() -> Publishers.TryMap<Self, Data> {
        
        return tryMap() { element -> Data in
            guard let httpResponse = element.response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                debugPrint(element.response)
                    throw URLError(.badServerResponse)
                }
            return element.data
        }
        
    }
}

extension JSONDecoder {
    static var `default`: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}

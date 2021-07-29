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
    
    private let baseUrl: String = "https://api.github.com"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension ApiClient: ApiClientProtocol {
    
    func searchRepositories(query: String) -> AnyPublisher<SearchRepositoryResponse, Error> {
        let url = URL(string: baseUrl + "/search/repositories")!
        let request = URLRequest(url: url)
        return session
            .dataTaskPublisher(for: request)
            .validateNetwork()
            .decode(type: SearchRepositoryResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

extension URLSession.DataTaskPublisher {
    
    public func validateNetwork() -> Publishers.TryMap<Self, Data> {
        
        return tryMap() { element -> Data in
            guard let httpResponse = element.response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            return element.data
        }
        
    }
}

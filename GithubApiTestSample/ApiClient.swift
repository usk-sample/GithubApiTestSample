//
//  ApiClient.swift
//  GithubApiTestSample
//
//  Created by Yusuke Hasegawa on 2021/07/29.
//

import Foundation

protocol ApiClientProtocol: AnyObject {
    func searchRepositories(query: String) -> URLSession.DataTaskPublisher
}

class ApiClient {
    
    private let session: URLSession
    
    private let baseUrl: String = "https://api.github.com/"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension ApiClient: ApiClientProtocol {
    
    func searchRepositories(query: String) -> URLSession.DataTaskPublisher {
        let url = URL(string: baseUrl + "search/repositories")!
        let request = URLRequest(url: url)
        return session.dataTaskPublisher(for: request)
    }
}

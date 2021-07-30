//
//  StubApiClient.swift
//  GithubApiTestSampleTests
//
//  Created by Yusuke Hasegawa on 2021/07/30.
//

import Combine
import Foundation

@testable import GithubApiTestSample

class StubApiClient {
    
    private let response: SearchRepositoryResponse
    private let failure: Bool
    
    init(response: SearchRepositoryResponse, failure: Bool) {
        self.response = response
        self.failure = failure
    }
    
}

extension StubApiClient: ApiClientProtocol {
    
    func searchRepositories(query: String) -> AnyPublisher<SearchRepositoryResponse, Error> {
        if failure {
            return Result<SearchRepositoryResponse, Error>.failure(URLError.init(.badServerResponse)).publisher.eraseToAnyPublisher()
        } else {
            return Result.Publisher.init(response).eraseToAnyPublisher()
        }
    }
    
}

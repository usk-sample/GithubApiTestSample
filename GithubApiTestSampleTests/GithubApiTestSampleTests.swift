//
//  GithubApiTestSampleTests.swift
//  GithubApiTestSampleTests
//
//  Created by Yusuke Hasegawa on 2021/07/29.
//

import XCTest

import Combine
import OHHTTPStubs
import OHHTTPStubsSwift
import ViewInspector

@testable import GithubApiTestSample

class GithubApiTestSampleTests: XCTestCase {

    private lazy var testBundle = Bundle.init(for: type(of: self))
    private var cancellations = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testModel() throws {
        
        guard let url = testBundle.url(forResource: "search_repositories", withExtension: "json"),
              let data = try? Data.init(contentsOf: url) else {
            XCTFail("json file not found")
            return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let response = try decoder.decode(SearchRepositoryResponse.self, from: data)
            
            XCTAssertTrue(response.totalCount == 40, "invalid total count")
            XCTAssertTrue(response.items.first?.license.key == "mit", "invalid License")

        } catch let error {
            debugPrint(error)
            XCTFail(error.localizedDescription)
        }
                
    }
    
    func testStubApi() throws {
        
        let apiClient = ApiClient()
        
        stub(condition: isHost("api.github.com") && isPath("/search/repositories")) { _ in
            let path = OHPathForFile("search_repositories.json", type(of: self))!
            return HTTPStubsResponse.init(fileAtPath: path,
                                          statusCode: 200,
                                          headers: ["Content-Type":"application/json"])
        }
        
        XCTContext.runActivity(named: "status 200") { activity in
            
            let expectation = expectation(description: activity.name)
            
            apiClient.searchRepositories(query: "apple")
                .sink { completion in
                    switch completion {
                    case .finished:
                        debugPrint("finished")
                    case .failure(let error):
                        debugPrint(error)
                    }
                    
                    XCTAssertTrue(completion == .finished, "must be finished response")
                    
                    expectation.fulfill()
                } receiveValue: { received in
                    debugPrint(received.response)
                    debugPrint(String.init(data: received.data, encoding: .utf8) ?? "null")
                }.store(in: &cancellations)

            
            wait(for: [expectation], timeout: 5)
            
            XCTAssertFalse(true, "must be failed with invalid response")
            
        }
        
        XCTContext.runActivity(named: "400 status") { _ in
            XCTAssertTrue(false, "must be error")
        }
        
        XCTContext.runActivity(named: "500 status") { _ in
            XCTAssertTrue(false, "must be error")
        }
        
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}

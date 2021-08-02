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

extension ContentView: Inspectable { }

class GithubApiTestSampleTests: XCTestCase {

    private lazy var testBundle = Bundle.init(for: type(of: self))
    private var cancellations = Set<AnyCancellable>()
    private var decoder: JSONDecoder = {
        let dec = JSONDecoder()
        dec.keyDecodingStrategy = .convertFromSnakeCase
        dec.dateDecodingStrategy = .iso8601
        return dec
    }()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// Test for Model of Response
    func testModel() throws {
        
        var data = try getData(fileName: "search_repositories")
        var response = try decoder.decode(SearchRepositoryResponse.self, from: data)
        
        XCTAssertTrue(response.totalCount == 40, "invalid total count")
        XCTAssertTrue(response.items.first?.license?.key == "mit", "invalid License")
        
        data = try getData(fileName: "search_repositories_apple")
        response = try decoder.decode(SearchRepositoryResponse.self, from: data)
        debugPrint(response.totalCount)
        
    }
    
    /// Test for API using HTTPStubs
    func testStubApi() throws {
        
        let apiClient = ApiClient()
        
        XCTContext.runActivity(named: "status 200") { activity in
            
            stub(condition: isHost("api.github.com") && isPath("/search/repositories")) { _ in
                let path = OHPathForFile("search_repositories.json", type(of: self))!
                return HTTPStubsResponse.init(fileAtPath: path,
                                              statusCode: 200,
                                              headers: ["Content-Type":"application/json"])
            }
            
            let expectation = expectation(description: activity.name)
            
            apiClient.searchRepositories(query: "apple")
                .sink { completion in
                    switch completion {

                    case .finished:
                        debugPrint("finished")
                        XCTAssertTrue(true, "must be finished response")

                    case .failure(let error):
                        debugPrint(error)
                        XCTFail(error.localizedDescription)
                    }
                    
                    expectation.fulfill()
                    
                } receiveValue: { received in
                    debugPrint(received)
                }.store(in: &cancellations)

            
            wait(for: [expectation], timeout: 5)
            
//            XCTAssertFalse(true, "must be failed with invalid response")
            
        }
        
        XCTContext.runActivity(named: "400 status") { activity in
            
            stub(condition: isHost("api.github.com") && isPath("/search/repositories")) { _ in
                let path = OHPathForFile("search_repositories.json", type(of: self))!
                return HTTPStubsResponse.init(fileAtPath: path,
                                              statusCode: 400,
                                              headers: ["Content-Type":"application/json"])
            }
            
            let expectation = expectation(description: activity.name)
            
            apiClient.searchRepositories(query: "apple")
                .sink { completion in
                    switch completion {

                    case .finished:
                        debugPrint("finished")
                        XCTFail("must be error")

                    case .failure(let error):
                        debugPrint("*** error")
                        debugPrint(error.localizedDescription)
                        XCTAssertTrue((error as NSError).code == URLError.badServerResponse.rawValue,
                                      "must be badServerResponse")
                    }
                    
                    expectation.fulfill()
                    
                } receiveValue: { received in
                    debugPrint(received)
                }.store(in: &cancellations)

            
            wait(for: [expectation], timeout: 5)
            
        }
        
    }
    
    /// Text using Github API
    func testGithubApi() throws {
        
        let apiClient = ApiClient()
        
        XCTContext.runActivity(named: "search apple") { activity in
            let expectation = expectation(description: activity.name)
            
            apiClient.searchRepositories(query: "apple swift format")
                .sink { completion in
                    switch completion {

                    case .finished:
                        debugPrint("finished")

                    case .failure(let error):
                        debugPrint(error)
                        XCTFail(error.localizedDescription)
                    }
                    
                    expectation.fulfill()
                    
                } receiveValue: { received in
                    debugPrint(received.items.count)
                }.store(in: &cancellations)
            
            wait(for: [expectation], timeout: 5.0)
            
        }
        
    }
    
    /// Test for ViewModel
    func testSearchViewModel() throws {
        
        let data = try getData(fileName: "search_repositories")
        let response = try decoder.decode(SearchRepositoryResponse.self, from: data)
                
        XCTContext.runActivity(named: "success") { activity in
            let expectation = expectation(description: activity.name)
        
            let viewModel = ViewModel.init(apiClient: StubApiClient(response: response, failure: false))
                        
            viewModel.search(query: "apple", debounce: 0.5)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                debugPrint(viewModel.items)
                XCTAssertTrue(!viewModel.items.isEmpty, "must have data")
                expectation.fulfill()
            }
            
            
            wait(for: [expectation], timeout: 5.0)
        }
        
        XCTContext.runActivity(named: "failure") { activity in
            let expectation = expectation(description: activity.name)

            let viewModel = ViewModel.init(apiClient: StubApiClient(response: response, failure: true))

            viewModel.search(query: "apple", debounce: 0.5)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                debugPrint(viewModel.errorMessage)
                XCTAssertTrue(viewModel.hasError, "must have error")
                
                expectation.fulfill()

            }
            
            wait(for: [expectation], timeout: 5.0)
        }
                
    }
    
    /// Test for View
    func testView() throws {
        
        try XCTContext.runActivity(named: "loading") { activity in
            let viewModel = ViewModel()
            viewModel.loading = true
            let view = ContentView(viewModel: viewModel)
                                
            add(XCTAttachment(image: view.snapshot()).setLifetime(.keepAlways))
            
            XCTAssertNoThrow(try view.inspect().vStack().group(2).progressView(0), "must have loading view")
            
        }
        
        XCTContext.runActivity(named: "has result") { activity in
            
            XCTAssertTrue(false, "must have result")
        }
        
        XCTContext.runActivity(named: "has error") { activity in
            XCTAssertTrue(false, "must have error")
        }
        
    }
    
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}

private extension GithubApiTestSampleTests {
    
    func getData(fileName: String, ext: String = "json") throws -> Data {
        guard let url = testBundle.url(forResource: fileName, withExtension: ext) else {
            throw NSError.init(domain: "App", code: NSFileNoSuchFileError, userInfo: nil)
        }
        return try Data.init(contentsOf: url)
    }
    
}

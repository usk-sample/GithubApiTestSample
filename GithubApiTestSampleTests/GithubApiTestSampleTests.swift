//
//  GithubApiTestSampleTests.swift
//  GithubApiTestSampleTests
//
//  Created by Yusuke Hasegawa on 2021/07/29.
//

import XCTest

import ViewInspector

@testable import GithubApiTestSample

class GithubApiTestSampleTests: XCTestCase {

    private lazy var testBundle = Bundle.init(for: type(of: self))
    
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
        
        XCTAssertTrue(false, "can not decode data")
        XCTAssertTrue(false, "invalid total count")
        
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}

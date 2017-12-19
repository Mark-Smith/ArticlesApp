//
//  ArticlesAppTests.swift
//  ArticlesAppTests
//
//  Created by Mark Smith on 17/12/2017.
//  Copyright © 2017 ___MARKSMITH___. All rights reserved.
//

import XCTest
@testable import ArticlesApp
//@testable import Suas
import Alamofire

class ArticlesAppTests: XCTestCase {
    
    var findArticleReducerUnderTest: FindArticleReducer!
    //var createRequestArticlesActionTest: func createRequestArticlesAction(page: Int) -> Action
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        findArticleReducerUnderTest = FindArticleReducer()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        findArticleReducerUnderTest = nil
        super.tearDown()
    }
    
    // XCTAssert to test model
    /*func testFindArticleReducer() -> FoundArticles? {
        // 1. given
        let article = Article(name: "", updated_at: Date.distantFuture, body: "")
        let foundArticles = FoundArticles(foundArticle: [article])
        let action = [Article(name: "", updated_at: Date.distantFuture, body: "")]
        
        // 1
        let promise = expectation(description: "Success: expected count of foundArticles")
        
        // 2. when
        _ = findArticleReducerUnderTest.reduce(state: foundArticles, action: action)
        
        // 3. then
        XCTAssertEqual(testFindArticleReducer()?.foundArticle.count, 3, "Count of found articles is wrong")
    }*/
    
    // Asynchronous test: success, failure, fast, slow
    func testCreateRequestArticlesActionGetsValidResponse() {
        // given
        let urlString = "https://support.zendesk.com/api/v2/help_center/en-us/sections/200623776/articles.json"
        let page = 1
        
        // 1
        let promise = expectation(description: "Success: valid response")
        
        // when
        //createRequestArticlesAction(page: page)
        Alamofire.request(urlString, parameters: ["page": String(page), "per_page": String(30)], encoding: URLEncoding.default)
            .validate()
            .responseJSON { (response) -> Void in

            if response.result.isSuccess {
                promise.fulfill()
            } else {
                XCTFail("Error: invalid response")
            }
        }
        
        // 3
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // Performance
    func test_CreateRequestArticlesAction_Performance() {
        let urlString = "https://support.zendesk.com/api/v2/help_center/en-us/sections/200623776/articles.json"
        let page = 1
        measure {
            //self.controllerUnderTest?.startDownload(track)
            
            Alamofire.request(urlString, parameters: ["page": String(page), "per_page": String(30)], encoding: URLEncoding.default)
                .validate()
                .responseJSON { (response) -> Void in
                    
                    /*if response.result.isSuccess {
                     promise.fulfill()
                     } else {
                     XCTFail("Error: invalid response")
                     }*/
            }
        }
    }
    
}

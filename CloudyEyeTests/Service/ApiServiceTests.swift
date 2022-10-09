//
//  ApiServiceTests.swift
//  CloudyEyeTests
//
//  Created by Youssef Donadeo on 08/10/22.
//

import XCTest
@testable import CloudyEye

class MockingURLProtocol: URLProtocol {
    // 1. Handler to test the request and return mock response.
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
 
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
 
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
 
    override func startLoading() {
      guard let handler = MockingURLProtocol.requestHandler else {
        fatalError("Handler is unavailable.")
      }
        
      do {
        // 2. Call handler with received request and capture the tuple of response and data.
        let (response, data) = try handler(request)
        
        // 3. Send received response to the client.
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        if let data = data {
          // 4. Send received data to the client.
          client?.urlProtocol(self, didLoad: data)
        }
        
        // 5. Notify request has been finished.
        client?.urlProtocolDidFinishLoading(self)
      } catch {
        // 6. Notify received error.
        client?.urlProtocol(self, didFailWithError: error)
      }
    }
 
    override func stopLoading() {}
}

struct MockRequest: Encodable{
    
}

struct MockResponse: Codable{
    let userID : Int
    let id : Int
    let title : String
    let body : String
}

struct MockError: Codable{
    let error: Bool
    let reason : String
}

class ApiServiceTests: XCTestCase {
    
    var apiClient: ApiService?
    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        apiClient = ApiService(urlSession: urlSession)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSuccessfulResponse() {
        // Prepare mock response.
        let response = MockResponse(userID: 5, id: 42, title: "URLProtocol Post", body: "Post body....")
        
        let encoder = JSONEncoder()
        var data: Data? = nil
        do{
            data = try encoder.encode(response)
        }catch{
            XCTFail("Error could not encode data")
        }
        
        // Set response in mock class.
        MockingURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        let mybody:MockRequest? = nil
        let promise = expectation(description: "Status code: 200")
        
        // Call API.
        apiClient?.fetch(ApiService.Endpoint.forcast(query: "aa"), body: mybody) { (result: Result<MockResponse, ApiService.Error>) in
            switch result {
                case .success(let post):
                    XCTAssertEqual(post.userID, response.userID, "Incorrect userID.")
                    XCTAssertEqual(post.id,  response.id, "Incorrect id.")
                    XCTAssertEqual(post.title, response.title, "Incorrect title.")
                    XCTAssertEqual(post.body, response.body, "Incorrect body.")
                    promise.fulfill()
                case .failure(let error):
                    XCTFail("Error was not expected: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)
    }

    func testBadRequestResponse() {
        // Prepare mock response.
        let response = MockError(error: true, reason: "This is a BadRequest")
        
        let encoder = JSONEncoder()
        var data: Data? = nil
        do{
            data = try encoder.encode(response)
        }catch{
            XCTFail("Error could not encode data")
        }
        
        // Set response in mock class.
        MockingURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        let mybody:MockRequest? = nil
        let promise = expectation(description: "Status code: 400")
        
        // Call API.
        apiClient?.fetch(ApiService.Endpoint.forcast(query: "aa"), body: mybody) { (result: Result<MockResponse, ApiService.Error>) in
            switch result {
                case .success(_):
                    XCTFail("Success response was not expected.")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, response.reason, "Incorrect Error.")
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testParsingFailure() {
        // Prepare mock response.
        let data: Data? = nil
        
        // Set response in mock class.
        MockingURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        let mybody:MockRequest? = nil
        let promise = expectation(description: "Data Response not decodable")
        
        // Call API.
        apiClient?.fetch(ApiService.Endpoint.forcast(query: "aa"), body: mybody) { (result: Result<MockResponse, ApiService.Error>) in
            switch result {
                case .success(_):
                    XCTFail("Success response was not expected.")
                case .failure(let error):
                    XCTAssertTrue(error.localizedDescription.contains("Could not decode data:"), "Incorrect Error.")
                    promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

//
//  ProfileServiceTests.swift
//  events-app-swiftui-uikit-lifecycleTests
//
//  Created by Gürhan Kuraş on 5/31/22.
//

import XCTest
@testable import events_app_swiftui_uikit_lifecycle



/*
extension HttpAPIClient {
    func jsonRequest<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> (), others: @escaping () throws -> ) {
        self.request(request) { result in
            switch result {
            case .success(let bundle):
                guard let data = bundle.data else {
                    completion(.failure(URLError.init(.badServerResponse)))
                    return
                }
                
                if 200 ..< 300 ~= bundle.response.statusCode {
                    do {
                        let decoded = try JSONDecoder.withFractionalSecondISO8601.decode(T.self, from: data)
                        completion(.success(decoded))
                    } catch  {
                        completion(.failure(error))
                    }
                }
                else {
                    
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
 */






/*
enum HTTPClientError: Error {
    case client()
    case server(HttpSt)
}
 */


class ProfileServiceTests: XCTestCase {
    
    func make200SUT() -> ProfileFetcher {
        let profileUser = ProfileUser(id: "123", email: "test@test.com", username: "test", linkedin: nil)
        let decoded = try! JSONEncoder().encode(profileUser)
        let client = HttpClientStub.init(result: .success(.init(data: decoded, response: .init(url: aURL, statusCode: 200, httpVersion: nil, headerFields: nil)!)))
        
        let sut = ProfileService(client: client)
        return sut
    }

    func test_fetchReturnsProfile_whenSuccessful() throws {
        let sut = make200SUT()
        
        var result: Result<ProfileUser, Error>?
        sut.fetchProfile(with: "123") { profileUserResult in
            result = profileUserResult
        }
        
        let user = try result?.get()
        
        XCTAssertNotNil(user)
    }
    
    func test_remoteFetch() throws {
        try XCTSkipIf(true, "")
        
        let store = InMemoryTokenStore()
        store.save("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjUyNTJjNmQ4LWMyOTQtNDA3OC1hMWQ5LTMyMjAzZDRlNjdiNiIsImVtYWlsIjoiZ3VyaGFua3VyYXNAaG90bWFpbC5jb20iLCJleHAiOjE2NTQwMjAzODIsImlhdCI6MTY1NDAxODU4Mn0.XsLuHl1VSTlwUycNdauO27MtGBhrxlt7mV9mdTHBZa4")
        let client = HttpAPIClient.shared.tokenSender(store: store)
        
        let sut = ProfileService(client: client)
        
        var result: Result<ProfileUser, Error>?
        let expectation = self.expectation(description: "network request")
        sut.fetchProfile(with: "5252c6d8-c294-4078-a1d9-32203d4e67b6") { profileUserResult in
            result = profileUserResult
            expectation.fulfill()
        }
        
        //let user = try result?.get()
        waitForExpectations(timeout: 4, handler: nil)
        switch result {
        case .success(let user):
            print(user)
            XCTAssertNotNil(user)

        case .failure(let error):
            print(error)
            XCTFail("Error")
        case .none:
            print("none")
        }
        
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

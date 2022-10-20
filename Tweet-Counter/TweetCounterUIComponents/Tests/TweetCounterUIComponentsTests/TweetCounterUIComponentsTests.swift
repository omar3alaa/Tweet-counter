import XCTest
@testable import TweetCounterUIComponents
import RxSwift

let MAXIMUM_CHARACTERS_ALLOWED = 20
final class TweetCounterUIComponentsTests: XCTestCase {
    var viewModel: TweetCounterViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    
    override func setUp() {
        super.setUp()
        viewModel = TweetCounterViewModel(tweetCounterManager: MockTweetCountManager())
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    }
    
    func testMaximumCharactersAllowed() {
        let disposeBag = DisposeBag()
        let expect = expectation(description: #function)
        let expectedResult = MAXIMUM_CHARACTERS_ALLOWED
        var actualResult: Int = 0
        viewModel.maximumCharactersAllowed.asObservable().subscribe(onNext: {
            actualResult = $0
            expect.fulfill()
        }).disposed(by: disposeBag)
        waitForExpectations(timeout: 1.0) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
            XCTAssertEqual(expectedResult, actualResult)
        }
    }
    
    func testTextViewPlaceholder() {
        let disposeBag = DisposeBag()
        let expect = expectation(description: #function)
        let expectedResult = "Start typing! You can enter up to \(MAXIMUM_CHARACTERS_ALLOWED) characters"
        var actualResult: String = ""
        viewModel.textViewPlaceholder.asObservable().subscribe(onNext: {
            actualResult = $0
            expect.fulfill()
        }).disposed(by: disposeBag)
        waitForExpectations(timeout: 1.0) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
            XCTAssertEqual(expectedResult, actualResult)
        }
    }
    
    func testWraningStateWhenTextIsUnderLimit() {
        let disposeBag = DisposeBag()
        let expect = expectation(description: #function)
        let expectedResult = false
        var actualResult: Bool = true
        viewModel.warningStateOn.asObservable().subscribe(onNext: {
            actualResult = $0
            expect.fulfill()
        }).disposed(by: disposeBag)
        let randomText = String.randomString(length: Int.random(in: 0..<MAXIMUM_CHARACTERS_ALLOWED))
        viewModel.tweetText.onNext(randomText)
        waitForExpectations(timeout: 1.0) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
            XCTAssertEqual(expectedResult, actualResult)
        }
    }
    
    func testWraningStateWhenTextIsEqualsLimit() {
        let disposeBag = DisposeBag()
        let expect = expectation(description: #function)
        let expectedResult = false
        var actualResult: Bool = true
        viewModel.warningStateOn.asObservable().subscribe(onNext: {
            actualResult = $0
            expect.fulfill()
        }).disposed(by: disposeBag)
        let randomText = String.randomString(length: MAXIMUM_CHARACTERS_ALLOWED)
        viewModel.tweetText.onNext(randomText)
        waitForExpectations(timeout: 1.0) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
            XCTAssertEqual(expectedResult, actualResult)
        }
    }
    
    func testWraningStateWhenTextIsAboveLimit() {
        let disposeBag = DisposeBag()
        let expect = expectation(description: #function)
        let expectedResult = true
        var actualResult: Bool = false
        viewModel.warningStateOn.asObservable().subscribe(onNext: {
            actualResult = $0
            expect.fulfill()
        }).disposed(by: disposeBag)
        let randomText = String.randomString(length: Int.random(in: (MAXIMUM_CHARACTERS_ALLOWED+1)...1000))
        viewModel.tweetText.onNext(randomText)
        waitForExpectations(timeout: 1.0) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
            XCTAssertEqual(expectedResult, actualResult)
        }
    }
    
    func testTypedCharacters() {
        let disposeBag = DisposeBag()
        let expect = expectation(description: #function)
        let randomCharactersCount = Int.random(in: 0...1000)
        let expectedResult = "\(randomCharactersCount)/\(MAXIMUM_CHARACTERS_ALLOWED)"
        var actualResult: String = ""
        viewModel.typedCharacters.asObservable().subscribe(onNext: {
            actualResult = $0
            expect.fulfill()
        }).disposed(by: disposeBag)
        let randomText = String.randomString(length: randomCharactersCount)
        viewModel.tweetText.onNext(randomText)
        waitForExpectations(timeout: 1.0) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
            XCTAssertEqual(expectedResult, actualResult)
        }
    }
    
    func testRaminingCharacters() {
        let disposeBag = DisposeBag()
        let expect = expectation(description: #function)
        let randomCharactersCount = Int.random(in: 0...1000)
        let expectedResult = "\(MAXIMUM_CHARACTERS_ALLOWED - randomCharactersCount)"
        var actualResult: String = ""
        viewModel.remainingCharacters.asObservable().subscribe(onNext: {
            actualResult = $0
            expect.fulfill()
        }).disposed(by: disposeBag)
        let randomText = String.randomString(length: randomCharactersCount)
        viewModel.tweetText.onNext(randomText)
        waitForExpectations(timeout: 1.0) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
            XCTAssertEqual(expectedResult, actualResult)
        }
    }
}


class MockTweetCountManager: TweetCounterManagerProtocol {
    var maximumChractersAllowed: Int = MAXIMUM_CHARACTERS_ALLOWED
    
    func getTweetCountFor(tweet: String) -> Int {
        return tweet.count
    }
}

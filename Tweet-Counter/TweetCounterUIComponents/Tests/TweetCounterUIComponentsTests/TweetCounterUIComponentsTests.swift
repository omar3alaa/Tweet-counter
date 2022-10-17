import XCTest
@testable import TweetCounterUIComponents
import RxSwift

final class TweetCounterUIComponentsTests: XCTestCase {
    var viewModel: TweetCounterViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    
    override func setUp() {
        super.setUp()
        viewModel = TweetCounterViewModel(tweetCounterManager: TweetCounterManager())
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    }
    
    func testLol() {
        let disposeBag = DisposeBag()

        // 1
        let expect = expectation(description: #function)

        // 2
        let expectedColor = "278"

        // 3
        var result: String!

        // 1
        viewModel.remainingCharacters.asObservable()
          .subscribe(onNext: {
            // 2
            result = $0
            expect.fulfill()
          })
          .disposed(by: disposeBag)

        // 3
        viewModel.tweetText.onNext("Hi")

        // 4
        waitForExpectations(timeout: 1.0) { error in
          guard error == nil else {
            XCTFail(error!.localizedDescription)
            return
          }

          // 5
          XCTAssertEqual(expectedColor, result)
        }
    }
}

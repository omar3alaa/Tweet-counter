//
//  TweetCounterManagerTests.swift
//  
//
//  Created by Omar Alaa on 20/10/2022.
//
import XCTest
@testable import TweetCounterUIComponents
import RxSwift

final class TweetCounterManagerTests: XCTestCase {
    var manager: TweetCounterManager!
    private let config: Configuration? = Configuration.buildConfiguration()

    override func setUp() {
        super.setUp()
        manager = TweetCounterManager()
    }
    
    func testRegularTextLength() {
        let text = "Hi, Halan!"
        let textCount = text.count
        XCTAssertEqual(manager.getTweetCountFor(tweet: text), textCount)        
    }
    
    func testUrlTextLength() {
        guard let config = config else { return }
        let text = "https://github.com/omar3alaa"
        //Count here is characters count not following tweeter logic for calculating url length
        let textCount = text.count
        XCTAssertNotEqual(manager.getTweetCountFor(tweet: text), textCount)
        XCTAssertEqual(manager.getTweetCountFor(tweet: text), config.transformedURLLength)
    }
    
    func testEmojiTextLength() {
        let text = "❤️❤️❤️❤️"
        //Count here is characters count not following tweeter logic for calculating emoji length
        let textCount = text.count
        XCTAssertNotEqual(manager.getTweetCountFor(tweet: text), textCount)
        XCTAssertEqual(manager.getTweetCountFor(tweet: text), textCount * 2)
    }
    
    func testEmptyString() {
        let text = ""
        let textCount = text.count
        XCTAssertEqual(manager.getTweetCountFor(tweet: text), textCount)
    }
    
    func testWhiteSpacesString() {
        let text = "       \n     \n     "
        let textCount = text.count
        XCTAssertEqual(manager.getTweetCountFor(tweet: text), textCount)
    }
}

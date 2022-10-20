# Tweet-counter

## Description
An iOS application implemented using swift language, to count tweet characters just like [Twitter](https://www.twitter.com)!
Firstly, we have to know that [Twitter](https://www.twitter.com) has a special mechanism in counting characters and it's explained [here](https://developer.twitter.com/en/docs/counting-characters) in details.

Implementation of this app is focused on following the previously mentioned mechanism as far as possible.

## Project's structure

### 1. `Tweet-Counter` target:
The main project and made here as an example of how to use `Tweet counter`, It's architected with `VIPER` as it has reusable components that could be used in other modules, those reusable components such as `AuthorizeTwitterInteractor` & `PostTweetInteractor`.

### 2. `TweetCounterUIComponents` SPM:
A SPM used to encapsulate all UI components inside one package to be used by many internal projects, it now holds only the custom view `TweetCounter` with its relative files.
 * `TweetCounter` module here is architected with `MVVM with RxSwift` because it's somehow needs to be a reactive component as it's used to calculate length of user's input text while typing it.

### 3. `TweetCounterUtilities` SPM:
A SPM used to encapsulate all helpers, extensions, and any shared logic that could be used in multiple projects.


## Resources I've used to help me implement this repo
* [How Twitter counts characters.](https://developer.twitter.com/en/docs/counting-characters )
* [Twitter's latest configuration file.](https://github.com/twitter/twitter-text/blob/master/config/v3.json)
* [For understanding regex.](https://www.thisdot.co/blog/understanding-regex)
* [For regex checks.](https://regexr.com/3e48o)
* [Swift twitter-text repo.](https://github.com/nysander/twitter-text)
* [Advanced iOS App Architecture book](https://www.raywenderlich.com/books/advanced-ios-app-architecture/v4.0)
* [RxSwift: Reactive Programming with Swift book](https://www.raywenderlich.com/books/rxswift-reactive-programming-with-swift/v4.0)
* [To create local swift package manager.](https://useyourloaf.com/blog/creating-swift-packages-in-xcode/)
* [For testing RxSwift](https://www.raywenderlich.com/7408-testing-your-rxswift-code)


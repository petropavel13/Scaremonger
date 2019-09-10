//
//  Copyright (c) 2019 Touch Instinct
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the Software), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import RxSwift
import Scaremonger

struct ViewModel {
    private let sessionService: SessionService = SessionService()

    private let viewModelScaremonger: ScaremongerDispatcher

    init() {
        let logger = LoggingDispatcher { debugPrint("Got error: \($0)") }

        let renewSessionSubscriber = RenewSessionSubscriber(sessionService: sessionService)

        let forkDispatcher = ForkDispatcher(forkedSubscriber: renewSessionSubscriber) { ($0 as? ApiError) == .sessionExpired }
        forkDispatcher.subscribe(subscriber: Scaremonger.default)

        viewModelScaremonger = logger.connect(other: forkDispatcher) // inject logger before any other
    }

    func getProfile() -> Single<Profile> {
        return ProfileService(sessionService: sessionService)
            .getProfile()
            .scaremonger(in: viewModelScaremonger)
    }
}

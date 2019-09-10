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

import UIKit

public class AlertSubscriber: ScaremongerSubscriber {
    private let controllerToPresent: UIViewController

    private let title: String?
    private let message: String?
    private let retryTitle: String?
    private let cancelTitle: String?

    public init(controllerToPresent: UIViewController,
                title: String?,
                message: String?,
                retryTitle: String?,
                cancelTitle: String?) {

        self.controllerToPresent = controllerToPresent
        self.title = title
        self.message = message
        self.retryTitle = retryTitle
        self.cancelTitle = cancelTitle
    }

    public func onNext(error: Error, callback: @escaping RetryClosureType) -> Disposable {
        return presentAlertController(callback: callback,
                                      retryActionHandler: { callback(true) })
    }

    func presentAlertController(callback: @escaping RetryClosureType,
                                retryActionHandler: @escaping () -> Void) -> Disposable {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: retryTitle, style: .default) { _ in
            retryActionHandler()
        })
        alertController.addAction(UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            callback(false)
        })
        controllerToPresent.present(alertController, animated: true, completion: nil)

        return ScaremongerDisposable {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
}

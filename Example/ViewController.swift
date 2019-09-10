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
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var stateLabel: UILabel!

    private lazy var viewModel = ViewModel()

    private let disposeBag = DisposeBag()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        reload()
    }

    private func onDidReceive(profile: Profile) {
        stateLabel.text = "Got profile with name \(profile.name)"
    }

    private func onDidReceive(error: Error) {
        stateLabel.text = "Got error: \(error)"
    }

    @IBAction func reload(_ sender: UIButton? = nil) {
        stateLabel.text = "Loading..."

        viewModel.getProfile()
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] in self?.onDidReceive(profile: $0) },
                       onError: { [weak self] in self?.onDidReceive(error: $0) })
            .disposed(by: disposeBag)
    }
}


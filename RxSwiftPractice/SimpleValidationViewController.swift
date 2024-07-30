//
//  SimpleValidationViewController.swift
//  RxSwiftPractice
//
//  Created by t2023-m0032 on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

class SimpleValidationViewController: UIViewController {
    
    let usernameTextField = UITextField()
    let usernameValidLabel = UILabel()
    
    let passwordTextField = UITextField()
    let passwordValidLabel = UILabel()
    
    let doSomethingOutlet = UIButton()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(usernameTextField)
        view.addSubview(usernameValidLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordValidLabel)
        view.addSubview(doSomethingOutlet)
        usernameTextField.backgroundColor = .red
        usernameValidLabel.backgroundColor = .orange
        passwordTextField.backgroundColor = .yellow
        passwordValidLabel.backgroundColor = .green
        doSomethingOutlet.backgroundColor = .link
        usernameTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        usernameValidLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameValidLabel.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        passwordValidLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        doSomethingOutlet.snp.makeConstraints { make in
            make.top.equalTo(passwordValidLabel.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        usernameTextField.text = "Username has to be at least \(minimalUsernameLength) Characters"
        passwordTextField.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        let usernameValid = usernameTextField.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1)
        
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1}
            .share(replay: 1)
        
        usernameValid
            .bind(to: passwordTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        usernameValid
            .bind(to: usernameValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: passwordValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        everythingValid
            .bind(to: doSomethingOutlet.rx.isEnabled)
            .disposed(by: disposeBag)
        
        doSomethingOutlet.rx.tap
            .subscribe { [weak self] _ in self?.showAlert() }
            .disposed(by: disposeBag)
    }
    func showAlert() {
        let alert = UIAlertController(title: "RxExample", message: "This is wonderful", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
}

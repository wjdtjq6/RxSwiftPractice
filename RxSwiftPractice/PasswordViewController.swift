//
//  PasswordViewController.swift
//  RxSwiftPractice
//
//  Created by t2023-m0032 on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PasswordViewController: UIViewController {
    let passwordTextField = UITextField()
    let nextButton = UIButton()
    let descriptionLabel = UILabel()
    
    let validText = Observable.just("8자 이상 입력해주세요")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        bind()
    }
    func bind() {
        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = passwordTextField
            .rx
            .text
            .orEmpty
            .map { $0.count >= 8 }
        
        validation
            .bind(to: nextButton.rx.isEnabled, descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemPink : .lightGray
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        nextButton
            .rx
            .tap
            .bind(with: self) { owner, _ in
                print("show alert")
            }
            .disposed(by: disposeBag)
    }
    func configureHierarchy() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
    }
    func configureLayout() {
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(passwordTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    func configureUI() {
        view.backgroundColor = .white
        passwordTextField.placeholder = "비밀번호를 입력해주세요"
        nextButton.setTitle("다음", for: .normal)

    }
}

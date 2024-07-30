//
//  NumbersViewController.swift
//  RxSwiftPractice
//
//  Created by t2023-m0032 on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class NumbersViewController: UIViewController {
    let number1 = UITextField()
    let number2 = UITextField()
    let number3 = UITextField()
    let result = UILabel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(number1)
        view.addSubview(number2)
        view.addSubview(number3)
        view.addSubview(result)
        number1.backgroundColor = .link
        number2.backgroundColor = .yellow
        number3.backgroundColor = .cyan
        result.backgroundColor = .brown
        number1.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        number2.snp.makeConstraints { make in
            make.top.equalTo(number1.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        number3.snp.makeConstraints { make in
            make.top.equalTo(number2.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        result.snp.makeConstraints { make in
            make.top.equalTo(number3.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        
        Observable.combineLatest(number1.rx.text.orEmpty, number2.rx.text.orEmpty, number3.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
            return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
            }
        .map { $0.description }
        .bind(to: result.rx.text)
        .disposed(by: disposeBag)    }
}

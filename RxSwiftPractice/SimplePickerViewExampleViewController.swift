//
//  SimplePickerViewExampleViewController.swift
//  RxSwiftPractice
//
//  Created by t2023-m0032 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SimplePickerViewExampleViewController: UIViewController {
    let pickerView1 = UIPickerView()
    let pickerView2 = UIPickerView()
    let pickerView3 = UIPickerView()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(pickerView1)
        view.addSubview(pickerView2)
        view.addSubview(pickerView3)
        pickerView1.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(150)
        }
        pickerView2.snp.makeConstraints { make in
            make.top.equalTo(pickerView1.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(150)
        }
        pickerView3.snp.makeConstraints { make in
            make.top.equalTo(pickerView2.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(150)
        }
        Observable.just([1,2,3])
            .bind(to: pickerView1.rx.itemTitles) { _, item in
                return "\(item)"
            }
            .disposed(by: disposeBag)
        
        pickerView1.rx.modelSelected(Int.self)
            .subscribe { models in
                print("models selected 1: \(models)")
            }
            .disposed(by: disposeBag)
        
        Observable.just([1,2,3])
            .bind(to: pickerView2.rx.itemAttributedTitles) { _, item in
                return NSAttributedString(string: "\(item)",
                                          attributes: [
                                                NSAttributedString.Key.foregroundColor: UIColor.cyan,
                                                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue
                                        ])
            }
            .disposed(by: disposeBag)
        
        pickerView2.rx.modelSelected(Int.self)
            .subscribe { models in
                print("models selected 2: \(models)")
            }
            .disposed(by: disposeBag)
        
        Observable.just([UIColor.red, UIColor.green, UIColor.blue])
            .bind(to: pickerView3.rx.items) {_, item, _ in
                let view = UIView()
                view.backgroundColor = item
                return view
            }
            .disposed(by: disposeBag)
        
        pickerView3.rx.modelSelected(UIColor.self)
            .subscribe { models in
                print("models selected 3: \(models)")
            }
            .disposed(by: disposeBag)
    }
}

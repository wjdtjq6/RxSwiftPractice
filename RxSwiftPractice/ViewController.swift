//
//  ViewController.swift
//  RxSwiftPractice
//
//  Created by t2023-m0032 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController {
    let button = UIButton()
    let label = UILabel()
    
    let textField = UITextField()
    let secondLabel = UILabel()
    
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        firstExample()
    }
    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(button)
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(secondLabel)
        button.backgroundColor = .link
        label.backgroundColor = .systemPink
        
        button.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.height.width.equalTo(50)
        }
        label.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        textField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(label.snp.bottom).offset(20)
        }
        secondLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(textField.snp.bottom).offset(20)
        }
        textField.backgroundColor = .red
        secondLabel.backgroundColor = .orange
        
        
    }
    private func firstExample() {
        //1.
        button.rx.tap
            .subscribe { _  in
                self.label.text = "button clicked"
                print(self.next)
            } onError: { error in
                print(error)
            } onCompleted: {
                print("complete")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposebag)
        //2.
        button.rx.tap
            .subscribe { _ in
                self.label.text = "button clicked"
                print(self.next)
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposebag)
        //3.
        button.rx.tap
            .subscribe { [weak self]_ in
                self?.label.text = "button clicked"
                print(self?.next)
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposebag)
        //4.
        button.rx.tap
            .withUnretained(self)
            .subscribe { _ in
                self.label.text = "button clicked"
                print(self.next)
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposebag)
        //5.
        button.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.label.text = "button clicked"
                print(self.next)
            }, onDisposed: { owner in
                print("disposed")
            })
            .disposed(by: disposebag)
        //UIkit이기때문에 달라진 특성
        //6.
        //subscribe: thread 상관x, 백그라운드동작 가능성
        //==>보라색 오류 뜰 수 있음!!
        button.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                DispatchQueue.main.async {
                    owner.label.text = "button clicked"
                }
            }, onDisposed: { owner in
                print("disposed")
            })
            .disposed(by: disposebag)
        //7.
        button.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                owner.label.text = "button clicked!!"
            } onDisposed: { owner in
                print("disposed")
            }
            .disposed(by: disposebag)
        //8.메인쓰레드로 동작시켜주는 친구는 왜 안만들어주냐 + 애초에 error 안받는 친구는 없음? =>nil
        button.rx.tap
            .bind(with: self) { owner, _ in
                owner.label.text = "button clicked"
            }
            .disposed(by: disposebag)
            //=======여기까지만 이해하면 됨!=======
        //9.
        button
            .rx
            .tap
            .map{"button clicked"}
            .bind(to: label.rx.text)
            .disposed(by: disposebag)
    }

}


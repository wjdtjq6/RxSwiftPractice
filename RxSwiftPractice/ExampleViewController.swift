//
//  ExampleViewController.swift
//  RxSwiftPractice
//
//  Created by t2023-m0032 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ExampleViewController: UIViewController {
    let simplePickerView = UIPickerView()
    
    let simpleTableView = UITableView()
    let simpleLabel = UILabel()

    let simpleSwitch = UISwitch()
    
    let signName = UITextField()
    let signEmail = UITextField()
    let signButton = UIButton()
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        //2.
        //setPickerView()
        //setTableView()
        //setSwitch()
        //setSign()
        //3.
        //just()
        //of()
        //from()
        take()
    }
    func configureHierarchy() {
        view.backgroundColor = .white
        view.addSubview(simplePickerView)
        view.addSubview(simpleTableView)
        view.addSubview(simpleLabel)
        view.addSubview(simpleSwitch)
        view.addSubview(signName)
        view.addSubview(signEmail)
        view.addSubview(signButton)
    }
    func configureLayout() {
        simplePickerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        simpleTableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        simpleLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        simpleSwitch.snp.makeConstraints { make in
            make.bottom.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        signName.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(100)
        }
        signEmail.snp.makeConstraints { make in
            make.top.equalTo(signName.snp.bottom).offset(10)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(100)
        }
        signButton.snp.makeConstraints { make in
            make.top.equalTo(signEmail.snp.bottom).offset(10)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(100)
        }
    }
    func configureUI() {
        simplePickerView.backgroundColor = .green
        signName.backgroundColor = .red
        signEmail.backgroundColor = .orange
        signButton.backgroundColor = .yellow
    }
    //2.
    func setPickerView() {
        let items = Observable.just([
            "영화",
            "애니메이션",
            "드라마",
            "기타"
        ])
        items
            .bind(to: simplePickerView.rx.itemTitles) { (row, element) in
            return element
        }
        .disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    func setTableView() {
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First item",
            "Second item",
            "Third item"
        ])
        items
            .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element) @ row \(row)"
                return cell
            }
            .disposed(by: disposeBag)
        
        simpleTableView.rx.modelSelected(String.self)
            .map { data in
                "\(data)를 클릭했습니다."
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    func setSwitch() {
        Observable.of(false) //just: single element / of: variable number of elements
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    func setSign() {
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
        return "name은 \(value1)이고, 이메일은 \(value2)입니다"
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        signName.rx.text.orEmpty //String
            .map { $0.count < 4 } //Int
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        signEmail.rx.text.orEmpty //String
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        signButton.rx.tap
            .subscribe { _ in
                self.showAlert()
            }
            //.bind(to: showAlert())
            .disposed(by: disposeBag)
    }
    func showAlert() {
        let alert = UIAlertController(title: "프로필 설정", message: "프로필이 설정되었습니다.", preferredStyle: .alert)
        
        let open = UIAlertAction(title: "열기", style: .default)
        let delete = UIAlertAction(title: "삭제", style: .destructive)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(cancel)
        alert.addAction(delete)
        alert.addAction(open)
        
        present(alert, animated: true)
        
    }
    //3.
    func just() {
        let itemsA = [3.3, 4.0 ,5.0 ,2.0, 3.6, 4.8]
        
        Observable.just(itemsA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just = \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
    }
    func of() {
        let itemsA = [3.3, 4.0 ,5.0 ,2.0, 3.6, 4.8]
        let itemsB = [2.3, 2.0 ,1.3]

        Observable.of(itemsA, itemsB)
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
    }
    func from() {
        let itemsA = [3.3, 4.0 ,5.0 ,2.0, 3.6, 4.8]

        Observable.from(itemsA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
    }
    func take() {
        Observable.repeatElement("Jimmy")
            .take(5)
            .subscribe { value in
                print("repeat - \(value)")
            } onError: { error in
                print("repeat - \(error)")
            } onCompleted: {
                print("repeat completed")
            } onDisposed: {
                print("repeat disposed")
            }
            .disposed(by: disposeBag)
    }
}

//
//  SimpleTableViewExampleViewController.swift
//  RxSwiftPractice
//
//  Created by t2023-m0032 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast
import SnapKit

class SimpleTableViewExampleViewController: UIViewController, UITableViewDelegate {
    let tableView = UITableView()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.backgroundColor = .link
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) {
                (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(String.self)
            .subscribe { value in
            self.view.makeToast("\(value)")
        }
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemAccessoryButtonTapped
            .subscribe { indexPath in
                self.view.makeToast("Tapped Detail @ \(indexPath.section),\(indexPath.row)")
            }
            .disposed(by: disposeBag)

    }
}

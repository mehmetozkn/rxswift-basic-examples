//
//  ViewController.swift
//  DynamicallyAddItemNormalTable
//
//  Created by Mehmet Ozkan on 5.02.2024.
//

import UIKit
import RxSwift
import RxCocoa


var customCells = [
    CustomCell(imageName: "house", title: "Home"),
    CustomCell(imageName: "gear", title: "Settings")
]

struct CustomCell {
    let imageName: String
    let title: String
}

struct CustomCellViewModel {
    var items = PublishSubject<[CustomCell]>()
    
    func fetchItems(){
        items.onNext(customCells)
    }
}

class ViewController: UIViewController {
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Add a Item", for: .normal)
        return button
    }()
    
    
    private let viewModel = CustomCellViewModel()
    
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(button)
        
        tableView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: Int(self.view.frame.width),
                                 height: Int(self.view.frame.height * 0.8))
        
        button.frame = CGRect(x: 150, y: 700, width: 100, height: 50)
        
        bindTableData()
        buttonClicked()
    }
    
    private func addItem() {
        customCells.append(CustomCell(imageName: "bell", title: "Activity"))

    }
    
    private func buttonClicked() {
        button.rx.tap
            .subscribe(onNext: {
                print(customCells.count)
                self.addItem()
                self.viewModel.fetchItems()

            })
            .disposed(by: bag)
    }
    
    private func bindTableData() {
        // Bind items to table
        viewModel.items
            .bind(
            to: tableView.rx.items(
                cellIdentifier: "cell",
                cellType: UITableViewCell.self)
            
        ) { row, model, cell  in
            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageName)
        }.disposed(by: bag)
        
        // Bind a model selected handler
        tableView.rx.modelSelected(CustomCell.self)
            .bind { product in
                print(product)
            }.disposed(by: bag)
        
        
        // fetch items
        viewModel.fetchItems()
    }
}




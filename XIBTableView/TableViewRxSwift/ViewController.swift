//
//  ViewController.swift
//  TableViewRxSwift
//
//  Created by Mehmet Ozkan on 2.02.2024.
//

import Alamofire
import UIKit
import RxSwift
import RxCocoa


struct ProductModel : Decodable {
    let id: Int
    let name: String
    let price: Int
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let products: BehaviorRelay<[ProductModel]> = BehaviorRelay(value:  [])
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        setTableView()
        fetchProducts()

    }
    
    private func setTableView() {
        products
            .bind(to: tableView.rx.items(
                cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                    cell.textLabel?.text = element.name
                }
                .disposed(by: disposeBag)
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        fetchProducts()
    }
    
    private func fetchProducts() {
         AF.request("http://localhost:8080/v1/product/getAll")
             .responseDecodable(of: [ProductModel].self) { [weak self] response in
                 switch response.result {
                 case .success(let products):
                     self?.products.accept(products)
                 case .failure(let error):
                     print("Error fetching products: \(error)")
                 }
             }
     }
}


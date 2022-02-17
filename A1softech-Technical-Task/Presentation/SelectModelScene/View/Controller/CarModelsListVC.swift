//
//  CarModelsListVC.swift
//  A1softech-Technical-Task
//
//  Created by Mohamed El-Naggar on 2/15/22.
//

import UIKit
import RxSwift
import RxCocoa

class CarModelsListVC: UIViewController {
    deinit { print("\(self.className) deinit") }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var emptyView: UIView!
    
    var carMakeId: Int!
    var carModelsViewModel: CarModelsViewModel?
    var disposeBag = DisposeBag()
    var carModels: [CarModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        carModelsViewModel = CarModelsViewModel(carMakeId: carMakeId)
        subscribeOnLoading()
        subscribeOnReceivingCars()
        subscribeOnEmptyModels()
        subscribeOnCarTableSelection()
        subscribeOnCarModelsTablePrefetchingRows()
        loadModelsNextPage()
    }
    
    func loadModelsNextPage() {
        carModelsViewModel?.loadCarModelNextPage()
    }
    
    func subscribeOnLoading() {
        self.carModelsViewModel?.isLoadingBehavior.bind(to: self.loadingView.rx.isLoading).disposed(by: disposeBag)
    }
    
    func subscribeOnEmptyModels() {
        carModelsViewModel?.noModelsAvailableBehavior.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.emptyView.isHidden = !$0
            self.tableView.isHidden = $0
        }).disposed(by: disposeBag)
    }
    
    func subscribeOnReceivingCars() {
            self.carModelsViewModel?.carModelsSubject.bind(to: self.rx.carModels).disposed(by: disposeBag)
        self.carModelsViewModel?.carModelsSubject
            .bind(to: self.tableView.rx.items(
                    cellIdentifier: CarModelTableCell.className,
                    cellType: CarModelTableCell.self)) { (row, model, cell) in
                cell.model = model
            }.disposed(by: disposeBag)
    }
    
    func subscribeOnCarTableSelection() {
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(CarModel.self))
            .bind { [weak self] (index, model) in
                guard let self = self else { return }
                let detailsPage = Storyboard.ModelDetails.instantiate(CarModelDetailsVC.self)
                detailsPage.makeNiceName = model.makeNiceName
                detailsPage.modelNiceName = model.name
                self.navigationController?.pushViewController(detailsPage, animated: true)
            }.disposed(by: disposeBag)
    }
    
    func subscribeOnCarModelsTablePrefetchingRows() {
        tableView.rx.prefetchRows.bind { [weak self] (indexPaths) in
            guard let self = self else { return }
            for index in indexPaths {
                if index.row >= self.carModels.count - 2 {
                    self.loadModelsNextPage()
                    break
                }
            }
        }.disposed(by: disposeBag)
    }
}

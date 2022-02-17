//
//  CarsViewController.swift
//  A1softech-Technical-Task
//
//  Created by Mohamed El-Naggar on 2/14/22.
//

import UIKit
import RxSwift

class CarsViewController: UIViewController {
    deinit { print("\(self.className) deinit") }
    
    @IBOutlet weak var carsTable: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    
    var carsListVieWModel = CarsListViewModel()
    var disposeBag = DisposeBag()
    var vehicles: [Vehicle] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeOnLoading()
        subscribeOnReceivingCars()
        subscribeOnCarTableSelection()
        subscribeOnCarTablePrefetchingRows()
        loadNextVehiclesPage()
    }
    
    func loadNextVehiclesPage() {
        carsListVieWModel.loadNextVehiclesPage()
    }
    
    func subscribeOnLoading() {
        self.carsListVieWModel.isLoadingBehavior.bind(to: self.loadingView.rx.isLoading).disposed(by: disposeBag)
    }
    
    func subscribeOnReceivingCars() {
        self.carsListVieWModel.carsSubject.bind(to: self.rx.vehicles).disposed(by: disposeBag)
        self.carsListVieWModel.carsSubject
            .bind(to: self.carsTable.rx.items(
                    cellIdentifier: SelectMakeCarCell.className,
                    cellType: SelectMakeCarCell.self)) { (row, vehicle, cell) in
                cell.vehicle = vehicle
            }.disposed(by: disposeBag)
    }
    
    func subscribeOnCarTableSelection() {
        Observable.zip(carsTable.rx.itemSelected, carsTable.rx.modelSelected(Vehicle.self))
            .bind { (index, car) in
                let carModelsVC = Storyboard.SelectModel.instantiate(CarModelsListVC.self)
                carModelsVC.carMakeId = car.id
                self.navigationController?.pushViewController(carModelsVC, animated: true)
            }.disposed(by: disposeBag)
    }
    
    func subscribeOnCarTablePrefetchingRows() {
        carsTable.rx.prefetchRows.bind { [weak self] (indexPaths) in
            guard let self = self else { return }
            for index in indexPaths {
                if index.row >= self.vehicles.count - 2 {
                    self.loadNextVehiclesPage()
                    break
                }
            }
        }.disposed(by: disposeBag)
    }
}

//
//  ViewController.swift
//  Restaurant
//
//  Created by Raul Mantilla on 14/09/21.
//

import UIKit
import Foundation
import Combine

class RestaurantsViewController: UIViewController {
    
    @Published var showPickerView = false
    @Published var selectedPickerOption: RestaurantViewModel.SortBy! = .popularity
    
    private var viewModel: RestaurantViewModel = RestaurantViewModel()
    var subscriptions = [AnyCancellable]()
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var textField: UITextField!
    @IBOutlet private var sortButton: UIButton!
    @IBOutlet private var sortPicker: UIPickerView!
    @IBOutlet private var pickerToolBar: UIToolbar! {
        didSet {
            pickerToolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.$restaurants
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] value in
                self?.updateUI()
            })
            .store(in: &subscriptions)
        
        $showPickerView
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self  else { return }
                self.pickerToolBar.isHidden = !value
                self.sortPicker.isHidden = !value
                self.selectedPickerOption = self.viewModel.sortingValue
                self.sortPicker.selectRow(self.selectedPickerOption.rawValue, inComponent: 0, animated: false)
            })
            .store(in: &subscriptions)
        
        self.viewModel.action.send(.getRestaurants)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sortRestaurant()
    }
    
    private func updateUI() {
        self.tableView.reloadData()
        self.sortButton.setTitle(self.viewModel.sortingValue.toString(), for: .normal)
    }
    
    func sortRestaurant() {
        self.viewModel.action.send(.sortRestaurant(by: selectedPickerOption))
    }
    
    @objc
    private func onDoneButtonTapped(_ sender: UIButton) {
        showPickerView = false
        sortRestaurant()
    }
    
    @IBAction private func sortButtonTapped(_ sender: UIButton) {
        showPickerView = true
    }
}

extension RestaurantsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let restaurant = self.viewModel.restaurants[safe: indexPath.row],
           let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantsTableViewCell.self), for: indexPath) as? RestaurantsTableViewCell {
            let data = RestaurantsTableViewCellData(name: restaurant.name, status: restaurant.status.toRestaurantStatus().rawValue, sorting: viewModel.sortingValue.toString(), sortingValue: viewModel.restaurantSortedValue(restaurant).description)
            cell.updateUI(data)
            return cell
        }
        return UITableViewCell()
        
    }
}

extension RestaurantsViewController: UIPickerViewDelegate, UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 8
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return RestaurantViewModel.SortBy(rawValue: row)?.toString()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPickerOption = RestaurantViewModel.SortBy(rawValue: row)
    }
}

extension RestaurantsViewController: UITextFieldDelegate  {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.viewModel.action.send(.sortRestaurantBy(text: string))
            return true;
        }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

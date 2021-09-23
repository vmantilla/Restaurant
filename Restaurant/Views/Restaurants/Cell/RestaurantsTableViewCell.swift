//
//  RestaurantsTableViewCell.swift
//  Restaurant
//
//  Created by Raul Mantilla on 14/09/21.
//

import UIKit

struct RestaurantsTableViewCellData {
    let name: String
    let status: String
    let sorting: String
    let sortingValue: String
}

class RestaurantsTableViewCell: UITableViewCell {
    
    @IBOutlet var restaurantName: UILabel! {
        didSet {
            restaurantName.textColor = Asset.Colors.Text.textDark.color
            restaurantName.font = FontFamily.Poppins.bold.font(size: 18)
        }
    }
    
    @IBOutlet var restaurantStatus: UILabel! {
        didSet {
            restaurantStatus.textColor = Asset.Colors.primaryColor.color
            restaurantStatus.font = FontFamily.Poppins.medium.font(size: 14)
        }
    }
    
    @IBOutlet var filterSort: UILabel! {
        didSet {
            filterSort.textColor = Asset.Colors.Text.textDark.color
            filterSort.font = FontFamily.Poppins.regular.font(size: 14)
        }
    }
    
    @IBOutlet var restaurantSortingValue: UILabel! {
        didSet {
            restaurantSortingValue.textColor = Asset.Colors.Text.textDark.color
            restaurantSortingValue.font = FontFamily.Poppins.regular.font(size: 14)
        }
    }
    
    func updateUI(_ data: RestaurantsTableViewCellData) {
        self.restaurantName.text = data.name
        self.restaurantStatus.text = data.status.capitalized
        self.filterSort.text = data.sorting
        self.restaurantSortingValue.text = data.sortingValue
        self.setupShadow()
    }
    
    private func setupShadow() {
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.contentView.layer.shadowRadius = 3
        self.contentView.layer.shadowOpacity = 0.3
        self.contentView.layer.shadowPath = UIBezierPath(roundedRect: self.contentView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.contentView.layer.shouldRasterize = true
        self.contentView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
}

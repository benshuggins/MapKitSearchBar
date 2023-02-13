//
//  LocationSearchTC.swift
//  UIsearchController
//
//  Created by Ben Huggins on 2/12/23.
//
import UIKit
import MapKit

class LocationsSearchTC: UITableViewCell {
    
    static let identifier = "SearchCell"
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    let addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.textAlignment = .left
        return addressLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(addressLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       titleLabel.frame = CGRect(x: 5, y: 5, width: 300, height: contentView.frame.size.height-10)
     addressLabel.frame = CGRect(x: 5, y: 20, width: 300, height: contentView.frame.size.height-10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureSelectedItem(selectedItem: CLPlacemark) {
        let address = "\(selectedItem.thoroughfare ?? ""), \(selectedItem.locality ?? ""), \(selectedItem.subLocality ?? ""), \(selectedItem.administrativeArea ?? ""), \(selectedItem.postalCode ?? ""), \(selectedItem.country ?? "")"
        titleLabel.text = selectedItem.name
        addressLabel.text = address
    }
}

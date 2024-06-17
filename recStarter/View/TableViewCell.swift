//
//  TableViewCell.swift
//  recStarter
//
//  Created by dumbo on 14.06.2024.
//
import UIKit

class TableViewCell: UITableViewCell {

    lazy var peripheralLabel: UILabel = {
        let textLabel = UILabel()
        
        textLabel.text = ""
        textLabel.font = .boldSystemFont(ofSize: 10)
        textLabel.textColor = .black
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    lazy var rssiLabel: UILabel = {
        let textLabel = UILabel()
        
        textLabel.text = ""
        textLabel.font = .boldSystemFont(ofSize: 10)
        textLabel.textColor = .black
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  TableViewCell.swift
//  recStarter
//
//  Created by dumbo on 14.06.2024.
//
import UIKit

class TableViewCell: UITableViewCell {
    static var cellID = "MyCellID"
    
    var peripheralLabel: UILabel = {
        let textLabel = UILabel()
        
        textLabel.text = "PERIPHERAL"
        textLabel.font = .systemFont(ofSize: 23)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    var rssiLabel: UILabel = {
        let textLabel = UILabel()
        
        textLabel.text = "RSSI"
        textLabel.font = .systemFont(ofSize: 23)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()

    override func prepareForReuse() {
        rssiLabel.text = ""
        peripheralLabel.text = ""
        accessoryType = .none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(peripheralLabel)
        addSubview(rssiLabel)
        setupConstraints()
        accessoryType = .detailButton
        
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(peripheralLabel)
        addSubview(rssiLabel)
        setupConstraints()
        accessoryType = .detailButton 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupConstraints(){
        peripheralLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        peripheralLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        peripheralLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        peripheralLabel.heightAnchor.constraint(equalToConstant: 25)
        
        rssiLabel.topAnchor.constraint(equalTo: peripheralLabel.bottomAnchor).isActive = true
        rssiLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        rssiLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        rssiLabel.heightAnchor.constraint(equalToConstant: 25)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

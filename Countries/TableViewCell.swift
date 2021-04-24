//
//  TableViewCell.swift
//  Countries
//
//  Created by Muhammad Jbara on 22/04/2021.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    // MARK: - Interstitial StyleNoneCell
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
}

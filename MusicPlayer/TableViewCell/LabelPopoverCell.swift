//
//  LabelPopoverCell.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 18.10.2022.
//

import UIKit

class LabelPopoverCell: UITableViewCell {
    static let height: CGFloat = UIScreen.main.bounds.height * 0.05
    var label: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLabel() {
        self.label = UILabel()
        self.label.frame.size.width = UIScreen.main.bounds.width
        self.label.frame.size.height = LabelPopoverCell.height
        self.label.text = "text"
        self.label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width * 0.055, weight: .init(rawValue: UIScreen.main.bounds.width * 0.000535044))
        self.contentView.addSubview(self.label)
    }
}

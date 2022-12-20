//
//  PopoverVC.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 18.10.2022.
//

import UIKit

protocol DelegatePopoverVC: AnyObject {
    func imagineView()
    func deleteSongs()
}

class PopoverVC: UIViewController {
    var tableViewPopover: UITableView!
    let LabelName = ["Add to playlist", "Delete"]
    
    weak var myDelegate: DelegatePopoverVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createTableViewPopover()
        self.view.backgroundColor = .red
    }
    
    private func createTableViewPopover() {
        self.tableViewPopover = UITableView()
        self.tableViewPopover.frame.size.width = self.view.frame.width
        self.tableViewPopover.frame.size.height = self.view.frame.height
        
        self.tableViewPopover.backgroundColor = .white
        self.view.addSubview(self.tableViewPopover)
        self.tableViewPopover.dataSource = self
        self.tableViewPopover.delegate = self
    }
}

extension PopoverVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.LabelName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idCell = "popoverTableView"
        var cell = tableView.dequeueReusableCell(withIdentifier: idCell) as? LabelPopoverCell
        if cell == nil {
            cell = LabelPopoverCell.init(style: .value1, reuseIdentifier: idCell)
        }
        cell?.backgroundColor = .white
        cell?.label.text = " \(self.LabelName[indexPath.row])"
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LabelPopoverCell.height
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            self.myDelegate.imagineView()
        } else if indexPath.row == 1 {
            self.myDelegate.deleteSongs()
        }
        
        self.dismiss(animated: true)
    }
}

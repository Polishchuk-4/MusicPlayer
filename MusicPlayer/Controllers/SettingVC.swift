//
//  SettingVC.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 28.08.2022.
//

import UIKit

class SettingVC: UITableViewController {
    var nameCell: [String] = ["Display", "Text", "Equalizer"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.createImgViewBackground()
        self.navigationController?.tabBarController?.tabBar.isHidden = false

    }
    
    private func createImgViewBackground() {
        let imgView = UIImageView()
        imgView.frame.size = UIScreen.main.bounds.size
        imgView.image = UIImage.init(contentsOfFile: UIImage.nameSelectedImage.path)
        imgView.contentMode = .scaleAspectFill
        let vie_w = UIView()
        vie_w.frame.size = UIScreen.main.bounds.size
        vie_w.addSubview(imgView)
        self.tableView.backgroundView = vie_w
    }
    
    private func settingNavBar() {
        let customView = UIView()
        customView.frame.size.height = self.navigationController!.navigationBar.frame.height
        customView.frame.size.width = self.navigationController!.navigationBar.frame.width
        
        let label = UILabel()
        label.frame.size.width = customView.frame.width / 2
        label.frame.size.height = customView.frame.height
        label.center.y = customView.center.y
        label.text = "Setting"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: customView.frame.height / 1.2, weight: .light)
        customView.addSubview(label)
        
//        let imgView = UIImageView()
        self.navigationItem.titleView = customView
    }
}


//MARK: - UITableViewDataSourse, UITableViewDelegate -
extension SettingVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameCell.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idCell = "SettingVC"
        var cell = tableView.dequeueReusableCell(withIdentifier: idCell)
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: idCell)
        }
        cell?.textLabel?.text = self.nameCell[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 25)
        cell?.textLabel?.textColor = .white
        cell?.backgroundColor = .clear
        cell?.selectionStyle = .none
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = SettingDisplayBackgroundVC()
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

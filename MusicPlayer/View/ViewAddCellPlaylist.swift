//
//  ViewAddCellPlaylist.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 21.10.2022.
//

import UIKit

protocol ViewAddCellPlaylistDelegate {
    func createPlaylist(name: String, image: UIImage?)
}

class ViewAddCellPlaylist: UIView {
    var labelViewAddCellPlaylist: UILabel!
    var imgViewAddCellPlaylist: UIImageView!
    var textFieldAddCellPlaylist: UITextField!
    var buttonCreateAddCellPlaylist: UIButton!
    var buttonCancelAddCellPlaylist: UIButton!
    
    var myDelegate: ViewAddCellPlaylistDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createViewAddCellPlaylist()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViewAddCellPlaylist() {
        self.frame.size.width = UIScreen.main.bounds.width - CGFloat.offset * 4
        self.frame.size.height = UIScreen.main.bounds.height * 0.25
        self.frame.origin.x = CGFloat.offset * 2
        self.center.y = UIScreen.main.bounds.height / 2
        self.backgroundColor = .systemBlue
        self.layer.cornerRadius = self.frame.height * 0.05
        
        self.createLabelViewAddCellPlaylist()
        self.createImgViewViewAddCellPlaylist()
        self.createTextFieldAddCellPlaylist()
        self.createButtonCreateAddCellPlaylist()
        self.createButtonCancelAddCellPlaylist()
    }
    
    private func createLabelViewAddCellPlaylist() {
        self.labelViewAddCellPlaylist = UILabel()
        self.labelViewAddCellPlaylist.frame.size.width = self.frame.width - CGFloat.offset * 2
        self.labelViewAddCellPlaylist.frame.size.height = self.frame.height / 3 - CGFloat.offset
        self.labelViewAddCellPlaylist.frame.origin.x = CGFloat.offset
        self.labelViewAddCellPlaylist.frame.origin.y = CGFloat.offset
        self.labelViewAddCellPlaylist.text = "New playlist"
        self.labelViewAddCellPlaylist.font = UIFont.systemFont(ofSize: self.frame.height * 0.15, weight: .light)
        self.labelViewAddCellPlaylist.textColor = .white
        self.labelViewAddCellPlaylist.textAlignment = .left
        self.addSubview(self.labelViewAddCellPlaylist)
    }
    
    private func createImgViewViewAddCellPlaylist() {
        self.imgViewAddCellPlaylist = UIImageView()
        self.imgViewAddCellPlaylist.frame.size.width = self.frame.height / 3 - CGFloat.offset
        self.imgViewAddCellPlaylist.frame.size.height = self.imgViewAddCellPlaylist.frame.width
        self.imgViewAddCellPlaylist.frame.origin.x = CGFloat.offset
        self.imgViewAddCellPlaylist.frame.origin.y = self.labelViewAddCellPlaylist.frame.origin.y + self.labelViewAddCellPlaylist.frame.height + CGFloat.offset
        self.imgViewAddCellPlaylist.layer.cornerRadius = self.imgViewAddCellPlaylist.frame.height * 0.1
        let image = "photo".getSymbol(pointSize: self.imgViewAddCellPlaylist.frame.width / 2, weight: .light)
        self.imgViewAddCellPlaylist.image = image
        self.imgViewAddCellPlaylist.contentMode = .scaleAspectFit
        self.imgViewAddCellPlaylist.tintColor = UIColor.white.withAlphaComponent(0.6)
        self.imgViewAddCellPlaylist.backgroundColor = UIColor.systemGray3.withAlphaComponent(0.4)
        self.addSubview(self.self.imgViewAddCellPlaylist)
    }
    
    private func createTextFieldAddCellPlaylist() {
        self.textFieldAddCellPlaylist = UITextField()
        self.textFieldAddCellPlaylist.frame.size.width = self.frame.width - self.imgViewAddCellPlaylist.frame.width - CGFloat.offset * 3
        self.textFieldAddCellPlaylist.frame.size.height = self.imgViewAddCellPlaylist.frame.height
        self.textFieldAddCellPlaylist.frame.origin.y = self.imgViewAddCellPlaylist.frame.origin.y
        self.textFieldAddCellPlaylist.frame.origin.x = self.imgViewAddCellPlaylist.frame.width + CGFloat.offset * 2
        self.textFieldAddCellPlaylist.placeholder = "NamePlaylist"
        self.textFieldAddCellPlaylist.leftView = UIView(frame: CGRect(x: 0, y: 0, width: self.textFieldAddCellPlaylist.frame.height / 3, height: 0))
        self.textFieldAddCellPlaylist.leftViewMode = .always
        self.textFieldAddCellPlaylist.font = UIFont.systemFont(ofSize: self.frame.height * 0.1, weight: .light)
        self.textFieldAddCellPlaylist.textColor = .white
        self.textFieldAddCellPlaylist.tintColor = .white
        self.textFieldAddCellPlaylist.layer.borderWidth = self.textFieldAddCellPlaylist.frame.height * 0.02
        self.textFieldAddCellPlaylist.layer.borderColor = UIColor.white.cgColor
        self.textFieldAddCellPlaylist.layer.cornerRadius = self.textFieldAddCellPlaylist.frame.height * 0.2
        self.addSubview(self.textFieldAddCellPlaylist)
        self.textFieldAddCellPlaylist.becomeFirstResponder()
        
        self.textFieldAddCellPlaylist.delegate = self
    }
    
    private func createButtonCreateAddCellPlaylist() {
        self.buttonCreateAddCellPlaylist = UIButton()
        self.buttonCreateAddCellPlaylist.frame.size.width = self.frame.width * 0.2
        self.buttonCreateAddCellPlaylist.frame.size.height = self.frame.height * 0.18
        self.buttonCreateAddCellPlaylist.frame.origin.x = self.frame.width - self.buttonCreateAddCellPlaylist.frame.width - CGFloat.offset
        self.buttonCreateAddCellPlaylist.frame.origin.y = self.frame.height - self.buttonCreateAddCellPlaylist.frame.height - CGFloat.offset
        self.buttonCreateAddCellPlaylist.layer.cornerRadius = self.buttonCreateAddCellPlaylist.frame.height * 0.1
        self.buttonCreateAddCellPlaylist.setTitle("create", for: .normal)
        self.buttonCreateAddCellPlaylist.setTitleColor(.white, for: .normal)
        self.buttonCreateAddCellPlaylist.titleLabel?.font = UIFont.systemFont(ofSize: self.frame.width * 0.07, weight: .light)
        self.addSubview(self.buttonCreateAddCellPlaylist)
        self.buttonCreateAddCellPlaylist.addTarget(self, action: #selector(sendDataPlaylist), for: .touchUpInside)
    }
    
    private func createButtonCancelAddCellPlaylist() {
        self.buttonCancelAddCellPlaylist = UIButton()
        self.buttonCancelAddCellPlaylist.frame.size = self.buttonCreateAddCellPlaylist.frame.size
        self.buttonCancelAddCellPlaylist.frame.origin.x = self.buttonCreateAddCellPlaylist.frame.origin.x - self.buttonCancelAddCellPlaylist.frame.width - CGFloat.offset
        self.buttonCancelAddCellPlaylist.frame.origin.y = self.buttonCreateAddCellPlaylist.frame.origin.y
        self.buttonCancelAddCellPlaylist.layer.cornerRadius = self.buttonCreateAddCellPlaylist.layer.cornerRadius
        self.buttonCancelAddCellPlaylist.setTitle("cancel", for: .normal)
        self.buttonCancelAddCellPlaylist.setTitleColor(.white, for: .normal)
        self.buttonCancelAddCellPlaylist.titleLabel?.font = self.buttonCreateAddCellPlaylist.titleLabel?.font
        self.addSubview(self.buttonCancelAddCellPlaylist)
        self.buttonCancelAddCellPlaylist.addTarget(self, action: #selector(cancelVC), for: .touchUpInside)
    }
    
    @objc private func cancelVC() {
        self.removeFromSuperview()
    }
    
    deinit {
        print("deinit View")
    }
    
    @objc func sendDataPlaylist() {
        self.myDelegate.createPlaylist(name: self.textFieldAddCellPlaylist.text!, image: nil)
        self.removeFromSuperview()
    }
}

//MARK: - UITextFieldDelegate -
extension ViewAddCellPlaylist: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendDataPlaylist()
        return true
    }
}

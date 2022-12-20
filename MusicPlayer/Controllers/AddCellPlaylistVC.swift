//
//  AddCellPlaylistView.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 06.10.2022.
//

import UIKit

class AddCellPlaylistVC: UIViewController {
    var customView: UIView!
    var labelView: UILabel!
    var imgViewPlaylist: UIImageView!
    var textFieldView: UITextField!
    var buttonCreate: UIButton!
    var buttonCancel: UIButton!
    var playlist: Playlist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingCustonmView()
        self.createLabelView()
        self.createImgViewPlayslist()
        self.createTextFieldView()
        self.createButtonCreate()
        self.createButtonCancel()
    }
    
    private func settingCustonmView() {
        self.customView = UIView()
        self.customView.frame.size.width = UIScreen.main.bounds.width - CGFloat.offset * 4
        self.customView.frame.size.height = UIScreen.main.bounds.height * 0.25
        self.customView.frame.origin.x = CGFloat.offset * 2
        self.customView.center.y = UIScreen.main.bounds.height / 2
        self.customView.backgroundColor = .systemBlue
        self.customView.layer.cornerRadius = self.customView.frame.height * 0.05
        self.view.addSubview(self.customView)
    }
    
    private func createLabelView() {
        self.labelView = UILabel()
        self.labelView.frame.size.width = self.customView.frame.width - CGFloat.offset * 2
        self.labelView.frame.size.height = self.customView.frame.height / 3 - CGFloat.offset
        self.labelView.frame.origin.x = CGFloat.offset
        self.labelView.frame.origin.y = CGFloat.offset
        self.labelView.text = "New playlist"
        self.labelView.font = UIFont.systemFont(ofSize: self.customView.frame.height * 0.15, weight: .light)
        self.labelView.textColor = .white
        self.labelView.textAlignment = .left
        self.customView.addSubview(self.labelView)
    }
    
    private func createImgViewPlayslist() {
        self.imgViewPlaylist = UIImageView()
        self.imgViewPlaylist.frame.size.width = self.customView.frame.height / 3 - CGFloat.offset
        self.imgViewPlaylist.frame.size.height = self.imgViewPlaylist.frame.width
        self.imgViewPlaylist.frame.origin.x = CGFloat.offset
        self.imgViewPlaylist.frame.origin.y = self.labelView.frame.origin.y + self.labelView.frame.height + CGFloat.offset
        self.imgViewPlaylist.layer.cornerRadius = self.imgViewPlaylist.frame.height * 0.2
        let image = "photo".getSymbol(pointSize: self.imgViewPlaylist.frame.width / 2, weight: .light)
        self.imgViewPlaylist.image = image
        self.imgViewPlaylist.contentMode = .scaleAspectFit
        self.imgViewPlaylist.tintColor = UIColor.white.withAlphaComponent(0.6)
        self.imgViewPlaylist.backgroundColor = UIColor.systemGray3.withAlphaComponent(0.4)
        
        self.customView.addSubview(self.imgViewPlaylist)
    }
    
    private func createTextFieldView() {
        self.textFieldView = UITextField()
        self.textFieldView.frame.size.width = self.customView.frame.width - self.imgViewPlaylist.frame.width - CGFloat.offset * 3
        self.textFieldView.frame.size.height = self.imgViewPlaylist.frame.height
        self.textFieldView.frame.origin.y = self.imgViewPlaylist.frame.origin.y
        self.textFieldView.frame.origin.x = self.imgViewPlaylist.frame.width + CGFloat.offset * 2
        self.textFieldView.placeholder = "NamePlaylist"
        self.textFieldView.leftView = UIView(frame: CGRect(x: 0, y: 0, width: self.textFieldView.frame.height / 3, height: 0))
        self.textFieldView.leftViewMode = .always
        self.textFieldView.font = UIFont.systemFont(ofSize: self.customView.frame.height * 0.1, weight: .light)
        self.textFieldView.textColor = .white
        self.textFieldView.tintColor = .white
        self.textFieldView.layer.borderWidth = self.textFieldView.frame.height * 0.02
        self.textFieldView.layer.borderColor = UIColor.white.cgColor
        self.textFieldView.layer.cornerRadius = self.textFieldView.frame.height * 0.2
        self.customView.addSubview(self.textFieldView)
        self.textFieldView.delegate = self
        self.textFieldView.becomeFirstResponder()
    }
    
    private func createButtonCreate() {
        self.buttonCreate = UIButton()
        self.buttonCreate.frame.size.width = self.customView.frame.width * 0.2
        self.buttonCreate.frame.size.height = self.customView.frame.height * 0.18
        self.buttonCreate.frame.origin.x = self.customView.frame.width - self.buttonCreate.frame.width - CGFloat.offset
        self.buttonCreate.frame.origin.y = self.customView.frame.height - self.buttonCreate.frame.height - CGFloat.offset
        self.buttonCreate.layer.cornerRadius = self.buttonCreate.frame.height * 0.1
        self.buttonCreate.setTitle("create", for: .normal)
        self.buttonCreate.setTitleColor(.white, for: .normal)
        self.buttonCreate.titleLabel?.font = UIFont.systemFont(ofSize: self.customView.frame.width * 0.07, weight: .light)
        self.customView.addSubview(self.buttonCreate)
        self.buttonCreate.addTarget(self, action: #selector(createPlaylist), for: .touchUpInside)
    }
    
    @objc private func createPlaylist() {
        dismiss(animated: true)
    }
    
    private func createButtonCancel() {
        self.buttonCancel = UIButton()
        self.buttonCancel.frame.size = self.buttonCreate.frame.size
        self.buttonCancel.frame.origin.x = self.buttonCreate.frame.origin.x - self.buttonCancel.frame.width - CGFloat.offset
        self.buttonCancel.frame.origin.y = self.buttonCreate.frame.origin.y
        self.buttonCancel.layer.cornerRadius = self.buttonCreate.layer.cornerRadius
        self.buttonCancel.setTitle("cancel", for: .normal)
        self.buttonCancel.setTitleColor(.white, for: .normal)
        self.buttonCancel.titleLabel?.font = self.buttonCreate.titleLabel?.font
        self.customView.addSubview(self.buttonCancel)
        self.buttonCancel.addTarget(self, action: #selector(cancelVC), for: .touchUpInside)
    }
    
    @objc private func cancelVC() {
        CoreDataManager.shared.delete(playlist: self.playlist)
        self.dismiss(animated: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        CoreDataManager.shared.delete(playlist: self.playlist)
        self.dismiss(animated: true)
    }
}

extension AddCellPlaylistVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.becomeFirstResponder()
        self.dismiss(animated: true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.playlist.name = textField.text
        CoreDataManager.shared.saveContext()
    }
}

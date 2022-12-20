//
//  SettingDisplayVC.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 21.09.2022.
//

import UIKit

class SettingDisplayBackgroundVC: UIViewController {
    var imgViewBackgroundVC: UIImageView!
    var imgViewExampleBackgroundImage: UIImageView!
    var collectionViewChooseImage: UICollectionView!
    var images: [String] = ["nightMountain.jpeg", "img.jpeg", "darkSky.jpeg", "lightSea.jpeg", "city.jpeg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createImgViewBackgroundVC()
        self.settingNavVC()
        self.createExampleImgViewBackground()
        self.createCollectionViewChooseImage()
        self.collectionViewChooseImage.register(ChooseBackgroundImageCell.self, forCellWithReuseIdentifier: "ChooseBackgroundImageCell")
    }
    
    func createImgViewBackgroundVC() {
        self.imgViewBackgroundVC = UIImageView()
        self.imgViewBackgroundVC.frame.size = UIScreen.main.bounds.size
        
        let image = UIImage.init(contentsOfFile: UIImage.nameSelectedImage.path)
        self.imgViewBackgroundVC.image = image
        

        self.imgViewBackgroundVC.contentMode = .scaleAspectFill
        
        self.view.addSubview(self.imgViewBackgroundVC)
        
        self.blurImage(imgView: self.imgViewBackgroundVC)

    }
    
    func blurImage(imgView: UIImageView) {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = imgView.bounds
        view.addSubview(blurredEffectView)
    }
    
    func settingNavVC() {
        let customView = UIView()
        customView.frame.size.height = self.navigationController!.navigationBar.frame.height
        customView.frame.size.width = self.navigationController!.navigationBar.frame.width
        
        self.navigationItem.titleView = customView
    }
    
    private func createExampleImgViewBackground() {
        self.imgViewExampleBackgroundImage = UIImageView()
        self.imgViewExampleBackgroundImage.frame.size.width = UIScreen.main.bounds.width - CGFloat.offset * 8
        self.imgViewExampleBackgroundImage.frame.size.height = UIScreen.main.bounds.height - self.navigationController!.navigationBar.frame.height * 7
        self.imgViewExampleBackgroundImage.frame.origin.x = CGFloat.offset * 4
        self.imgViewExampleBackgroundImage.frame.origin.y =  self.navigationItem.titleView!.frame.height * 2.2
        self.imgViewExampleBackgroundImage.backgroundColor = .white
        self.imgViewExampleBackgroundImage.image = UIImage.init(contentsOfFile: UIImage.nameSelectedImage.path)
        self.imgViewExampleBackgroundImage.contentMode = .scaleAspectFill
        self.imgViewExampleBackgroundImage.clipsToBounds = true
        self.view.addSubview(self.imgViewExampleBackgroundImage)
    }
    
    private func createCollectionViewChooseImage() {
        self.collectionViewChooseImage = UICollectionView(frame: CGRect(x: CGFloat.offset * 1.5,
                                                                        y: self.imgViewExampleBackgroundImage.frame.origin.y + self.imgViewExampleBackgroundImage.frame.height + CGFloat.offset,
                                                                        width: UIScreen.main.bounds.width - CGFloat.offset * 3,
                                                                        height: UIScreen.main.bounds.height - self.imgViewExampleBackgroundImage.frame.origin.y - self.imgViewExampleBackgroundImage.frame.height - CGFloat.offset * 2), collectionViewLayout: self.createLoyoutColletionViewChooseSection())
        self.collectionViewChooseImage.backgroundColor = UIColor.systemGray2.withAlphaComponent(0.2)
        self.view.addSubview(self.collectionViewChooseImage)
        self.collectionViewChooseImage.dataSource = self
        self.collectionViewChooseImage.delegate = self
    }
    
    private func createLoyoutColletionViewChooseSection() -> UICollectionViewFlowLayout {
        let loyout = UICollectionViewFlowLayout()
        loyout.scrollDirection = .horizontal
        loyout.minimumLineSpacing = CGFloat.offset
        return loyout
    }
    
}

extension SettingDisplayBackgroundVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseBackgroundImageCell", for: indexPath) as! ChooseBackgroundImageCell
        cell.imgVeiw.frame = cell.bounds
        
        if indexPath.row == 0 {
            cell.imgVeiw.image = UIImage.init(systemName: "photo")
            cell.imgVeiw.contentMode = .scaleAspectFit
            cell.imgVeiw.tintColor = .white
        } else {
            cell.imgVeiw.image = UIImage(named: self.images[indexPath.row - 1])
            cell.imgVeiw.contentMode = .scaleAspectFill
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            return
        } else {
            UserDefaultsManager.shared.nameImageBackground = self.images[indexPath.row - 1]
            let nameImage = self.images[indexPath.row - 1]
            let image = UIImage(named: nameImage)
            image?.saveImageToFile()
            self.imgViewExampleBackgroundImage.image = UIImage.init(contentsOfFile: UIImage.nameSelectedImage.path)
            self.imgViewBackgroundVC.image = UIImage.init(contentsOfFile: UIImage.nameSelectedImage.path)
        }
        
        collectionView.reloadData()
    }
}

extension SettingDisplayBackgroundVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.2, height: collectionView.frame.height)
    }
}

extension SettingDisplayBackgroundVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let key = UIImagePickerController.InfoKey.originalImage
        var image = info[key] as? UIImage
        if image?.imageOrientation != .up {
            image = self.removeOrientationImage(image: image!)
        }
        image?.saveImageToFile()
        
        let photo = UIImage.init(contentsOfFile: UIImage.nameSelectedImage.path)
        
        self.imgViewBackgroundVC.image = photo
        self.imgViewExampleBackgroundImage.image = photo
        self.dismiss(animated: true)
    }
    
    private func removeOrientationImage(image: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: CGSize(width: image.size.width, height: image.size.height)))
        let imageNormal = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageNormal!
    }
    
}
 

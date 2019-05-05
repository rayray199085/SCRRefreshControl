//
//  SCRAnimeRefreshView.swift
//  RefreshControlBackup
//
//  Created by Stephen Cao on 4/5/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit
private let supermanImageViewCenterVerticalOffset: CGFloat = 3
class SCRAnimeRefreshView: SCRRefreshView {

    @IBOutlet weak var buildingImageView: UIImageView!
    @IBOutlet weak var earthImageView: UIImageView!
    @IBOutlet weak var supermanImageView: UIImageView!
    
    override var refreshControlViewHeight: CGFloat{
        didSet{
            if refreshControlViewHeight <= bounds.height * 0.2{
                return
            }
            // scale from 0.2 to 1.0
            var scale = refreshControlViewHeight / bounds.height
            scale = (scale > 1.0) ? 1.0 : scale
            supermanImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    override class func refreshView()->SCRAnimeRefreshView{
        let nib = UINib(nibName: "SCRAnimeRefreshView", bundle: Bundle(for: SCRAnimeRefreshView.self))
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! SCRAnimeRefreshView
        return v
    }
    override func awakeFromNib() {
        setupUI()
    }
}
extension SCRAnimeRefreshView{
    /// load mages from bundle
    private func setupUI(){
       guard let buildingImage1 = loadImage(imageName: "icon_building_loading_1@2x"),
        let buildingImage2 = loadImage(imageName: "icon_building_loading_2@2x"),
        let earthImage = loadImage(imageName: "icon_earth@2x"),
        let supermanImage1 = loadImage(imageName: "icon_small_superman_loading_1@2x"),
        let supermanImage2 = loadImage(imageName: "icon_small_superman_loading_2@2x") else{
            return
        }
        buildingImageView.image = UIImage.animatedImage(with: [buildingImage1,buildingImage2], duration: 0.5)
        
        earthImageView.image = earthImage
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.duration = 3.0
        anim.toValue = -Double.pi * 2
        anim.repeatCount = MAXFLOAT
        anim.isRemovedOnCompletion = false
        earthImageView.layer.add(anim, forKey: nil)
        
        supermanImageView.image = UIImage.animatedImage(with: [supermanImage1,supermanImage2], duration: 0.3)
        supermanImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        supermanImageView.center.y = earthImageView.frame.origin.y + supermanImageViewCenterVerticalOffset
        supermanImageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
    }
}


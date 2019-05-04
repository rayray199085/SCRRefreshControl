//
//  SCRefreshView.swift
//  SCRefreshControl
//
//  Created by Stephen Cao on 2/5/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

class SCRRefreshView: UIView {
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var refreshState: SCRefreshState = .normal{
        didSet{
            switch refreshState {
            case .normal:
                hintLabel.text = "Pull down"
                loadingIndicator.stopAnimating()
                arrowImageView.isHidden = false
                arrowImageView.rotateVertically(reset: true)
            case .pulling:
                hintLabel.text = "Release"
                arrowImageView.rotateVertically(angle: Double.pi, reset: false)
            case .willRefresh:
                hintLabel.text = "Loading"
                arrowImageView.isHidden = true
                loadingIndicator.startAnimating()
            }
        }
    }
    
    class func refreshView()->SCRRefreshView{
        let nib = UINib(nibName: "SCRRefreshView", bundle: Bundle(for: SCRRefreshView.self))
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! SCRRefreshView
        return v
    }
    override func awakeFromNib() {
        let frameworkBundle = Bundle(for: SCRRefreshView.self)
        guard let bundlePath = frameworkBundle.path(forResource: "Resources", ofType: "bundle", inDirectory: nil),
              let bundle = Bundle(path: bundlePath),
              let imagePath = bundle.path(forResource: "tableview_pull_refresh@2x", ofType: "png", inDirectory: "images") else{
            return
        }
        arrowImageView.image = UIImage(contentsOfFile: imagePath)
        arrowImageView.sizeToFit()
    }
}


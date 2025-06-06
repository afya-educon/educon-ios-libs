//
//  HPFalconViewController.swift
//  MXParallaxHeader
//
//  Created by Hien Pham on 03/04/2021.
//  Copyright (c) 2021 Hien Pham. All rights reserved.
//

import UIKit
import MXParallaxHeader

class HPFalconViewController: UIViewController, MXParallaxHeaderDelegate {

    @IBOutlet weak var falcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parallaxHeader?.delegate = self
    }
    
    // MARK: - MXParallaxHeaderDelegate

    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        let angle = parallaxHeader.progress * CGFloat(Double.pi) * 2
        self.falcon.transform = CGAffineTransform.identity.rotated(by: angle)
        print("progress \(parallaxHeader.progress)")
    }

}

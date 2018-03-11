//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by Chen Weiru on 11/03/2018.
//  Copyright © 2018 ChenWeiru. All rights reserved.
//

import UIKit

class EmojiArtView: UIView {

    var backgourdImage:UIImage?{
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        backgourdImage?.draw(in: bounds)
    
    }
   

}

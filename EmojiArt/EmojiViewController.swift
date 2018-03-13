//
//  EmojiViewController.swift
//  EmojiArt
//
//  Created by Chen Weiru on 11/03/2018.
//  Copyright © 2018 ChenWeiru. All rights reserved.
//

import UIKit

class EmojiViewController: UIViewController,UIDropInteractionDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
   
    

    
    @IBOutlet weak var dropZone: UIView!{
        didSet{
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
        
    }
    
    var emojiArtView =  EmojiArtView()

    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(emojiArtView)
        }
    }
    
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeight.constant = scrollView.contentSize.height
        scrollViewWidth.constant = scrollView.contentSize.width
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return emojiArtView
    }
    
    var emojiArtBackgoundImage:UIImage?{
        get{
          return  emojiArtView.backgourdImage
        }
        set{
            scrollView?.zoomScale = 1.0
            emojiArtView.backgourdImage = newValue
            let size = newValue?.size ?? CGSize.zero
            emojiArtView.frame = CGRect(origin:CGPoint.zero, size:size)
            scrollView?.contentSize = size
            scrollViewHeight?.constant = size.height
            scrollViewWidth?.constant = size.width
            if let dropZone = self.dropZone, size.width > 0, size.height > 0{
                scrollView?.zoomScale = max(dropZone.bounds.size.width / size.width, dropZone.bounds.size.height / size.height)
                
            }
            
            
            
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    
    
    @IBOutlet weak var emojiCollectionView: UICollectionView!{
        didSet{
            emojiCollectionView.dataSource = self
            emojiCollectionView.delegate = self
        }
    }
    
    var emojis =  "😀😎👀🐬🐱🌹🌸🌈🛴✈️🌂⚽️🚗❤️🍉🍈🍎".map { String($0)}
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
        if let emojiCell = cell as? EmojiCollectionViewCell{
            let text = NSAttributedString(string: emojis[indexPath.item], attributes: [.font:font])
            emojiCell.label.attributedText = text
        }
        return cell
     }
    
    
    private var font:UIFont{
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(64.0))
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation:.copy)
    }
    
    var imageFetcher:ImageFetcher!
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        imageFetcher = ImageFetcher(){(url, image) in
            DispatchQueue.main.async {
                self.emojiArtBackgoundImage  = image
            }
            
        }
        
        session.loadObjects(ofClass: NSURL.self){ nsurls in
            
            if let url = nsurls.first as? URL{
            self.imageFetcher.fetch(url)
            }}
        session.loadObjects(ofClass: UIImage.self){ images in
            if let image = images.first as? UIImage{
            self.imageFetcher.backup = image
            
        }
        }
        
    }
    
    





}


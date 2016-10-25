//
//  DisplayImageViewController.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 22/10/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation
import UIKit

class DisplayImageViewController: UIViewController, UIScrollViewDelegate{
    
    var itemImageView: UIImageView!;
    var scrollView: UIScrollView!;
    var itemImage: UIImage!;
    
    
    override func viewDidLoad() {
        
        itemImageView = UIImageView(image: itemImage);
        
        scrollView = UIScrollView(frame: view.bounds);
        scrollView.backgroundColor = UIColor.black;
        scrollView.contentSize = itemImageView.bounds.size
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
        scrollView.delegate = self;
        
        scrollView.addSubview(itemImageView);
        view.addSubview(scrollView);

        view.addSubview(scrollView);
        
        scrollView.delegate = self;
        scrollView.indicatorStyle = .white;
        
        setZoomScale();
        
        
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (DisplayImageViewController.handlingTaps(_:)));
        view.addGestureRecognizer(tapGestureRecognizer);
        
    }
    
    
    func handlingTaps(_ sender: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil);
    }
    
    func viewForZooming(in: UIScrollView)-> UIView?{
        return itemImageView;
    }
    
    func setZoomScale() {
        
        let imageViewSize = itemImageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale);


        scrollView.zoomScale = min(widthScale, heightScale);
        
        
        
    }
    override func viewWillLayoutSubviews() {
        setZoomScale();
    }
    //MARK: - placing the image in the center of the screen:
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let imageViewSize = itemImageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }

    
    
}

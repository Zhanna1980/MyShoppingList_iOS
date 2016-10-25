//
//  ImagePickerHelper.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 13/10/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

// protocol for actions with chosen photo
protocol PhotoWasPickedDelegate{
   func photoWasPicked(image: UIImage);
}

// ImagePickerHelper. Helper methods to pick an image from camera or photo library
class ImagePickerHelper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var viewController: UIViewController;
    var cameraController: UIImagePickerController;
    var delegate: PhotoWasPickedDelegate?;
    
    init(viewController: UIViewController){
        self.viewController = viewController;
        self.cameraController = UIImagePickerController();

    }
    
    // choose the appropriate source type according to the given parameter
    func pickPhoto(shouldTakeNewPhoto: Bool){
        let sourceType = shouldTakeNewPhoto ? UIImagePickerControllerSourceType.camera : UIImagePickerControllerSourceType.photoLibrary;
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            
            cameraController.sourceType = sourceType;
            cameraController.mediaTypes = [kUTTypeImage as String];
            cameraController.allowsEditing = true;
            cameraController.delegate = self;
            viewController.present(cameraController, animated: true, completion: nil);
        }
        else{
            let alertController = UIAlertController(title: nil, message: "Camera or photo library is not available.", preferredStyle: .alert);
            let actionOK = UIAlertAction(title: "Ok", style: .default, handler: nil);
            alertController.addAction(actionOK);
            viewController.present(alertController, animated: true, completion: nil);

        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.delegate = nil;
        picker.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let receivedImage = info[UIImagePickerControllerOriginalImage] as! UIImage;
        if let theDelegate = delegate{
            theDelegate.photoWasPicked(image: receivedImage);
        }
        picker.delegate = nil;
        picker.dismiss(animated: true, completion: nil);
    }
    
}

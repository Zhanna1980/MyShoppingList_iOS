//
//  Checkbox.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 03/10/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation
import UIKit

protocol CheckboxWasCheckedDelegate {
    func checkboxWasChecked(checkbox: Checkbox);
}

class Checkbox: UIImageView{
    
    fileprivate static let checkedImage: UIImage = #imageLiteral(resourceName: "checkbox-checked");
    fileprivate static let uncheckedImage: UIImage = #imageLiteral(resourceName: "checkbox-unchecked");
    fileprivate var _position: CGPoint;
    fileprivate var _isChecked: Bool = false;
    //fileprivate var animator: UIDynamicAnimator = UIDynamicAnimator();
    var delegate: CheckboxWasCheckedDelegate?;
    
    init(position: CGPoint) {
        
        self._position = position;
        super.init(frame: CGRect(x: position.x, y: position.y, width: 20, height: 20));
        self.image = Checkbox.uncheckedImage;
        self.contentMode = .scaleAspectFit;
        self.isUserInteractionEnabled = true;
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Checkbox.checkboxChecked(_:)));
        self.addGestureRecognizer(tapGestureRecognizer);
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isChecked: Bool {
        get{
            return self._isChecked;
        }
    }
    
    func setChecked(checked: Bool){
        if checked {
            self.image = Checkbox.checkedImage;
            self._isChecked = true;
        }
        else{
            self.image = Checkbox.uncheckedImage;
            self._isChecked = false;
        }
    }
    
    func checkboxChecked(_ sender: UITapGestureRecognizer){

        let frameOriginal: CGRect = self.frame;
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            self.frame = CGRect(x:self.frame.midX,y:self.frame.midY, width:0,height: 0 );
                }, completion: { finished in
        
                UIView.animate(withDuration: 0.1, animations: {() -> Void in
            
                    self.frame = frameOriginal;
                    if self._isChecked {
                        self.image = #imageLiteral(resourceName: "checkbox-unchecked");
                        self._isChecked = false;
                    }
                    else{
                        self.image = #imageLiteral(resourceName: "checkbox-checked");
                        self._isChecked = true;
                    }
                    }, completion: nil);
            });
    
        if let theDelegate = delegate{
            theDelegate.checkboxWasChecked(checkbox: self);
        }
    }
    
    
}

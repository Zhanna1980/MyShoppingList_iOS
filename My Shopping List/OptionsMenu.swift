//
//  OptionsMenu.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 05/10/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation
import UIKit

// protocol for performing chosen action from options menu
protocol OptionWasSelectedDelegate {
    func optionWasSelected (optionIndex: Int);
}

// Options menu and its properties
class OptionsMenu: UIView{
    static let viewToBeHiddenTag: Int = 65453;
    fileprivate var _superview: UIView;
    fileprivate var _optionWidth: CGFloat;
    let margin:  CGFloat = 2;
    var max: CGFloat = 5;
    var options: [UIView];
    var optionWasSelectedDelegate: OptionWasSelectedDelegate?;
    
    init(view: UIView, options: [Option]){
        self._superview = view;
        self.options = [UIView]();
        let numberOfOptions:CGFloat = CGFloat(options.count > 0 ? options.count : 1);
        self._optionWidth = (view.frame.width - 10 - margin*(numberOfOptions-1))/numberOfOptions;
        super.init(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 90));
        self.backgroundColor = UIColor.white;
        self.alpha = 0;
        self._superview.addSubview(self);
        for option in options{
            addOption(icon: option.optionIcon, label: option.optionName);
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Add an option with specified text and image
    fileprivate func addOption(icon: UIImage, label: String){
        let container = UIView(frame: CGRect(x: max, y: self.frame.origin.y + 30, width: _optionWidth, height: self.frame.height - 30));
        container.setBorder();
        self.addSubview(container);
        
        let optionIcon = UIImageView(frame: CGRect(x: 0, y: 5, width: 20, height: 20));
        optionIcon.image = icon;
        optionIcon.contentMode = .scaleAspectFit;
        optionIcon.center.x = _optionWidth / 2;
        container.addSubview(optionIcon);
        
        let optionText = UILabel(frame: CGRect(x: 0, y: optionIcon.frame.maxY, width: container.frame.width, height: 30));
        optionText.text = label;
        optionText.textAlignment = .center;
        optionText.font = UIFont.systemFont(ofSize: 11);
        optionText.numberOfLines = 2;
        optionText.lineBreakMode = .byWordWrapping;
        optionText.center.x = _optionWidth / 2;
        container.addSubview(optionText);
        
        container.tag = options.count;
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OptionsMenu.optionSelected(_:)));
        container.addGestureRecognizer(tapGestureRecognizer);
        options.append(container);
        
        max = max + _optionWidth + margin;
    }
    
    // functions for using by viewControllers
    func hide(){
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.alpha = 0 ;
            }, completion: nil);
        
        _superview.viewWithTag(OptionsMenu.viewToBeHiddenTag)?.alpha = 1;
    }
    
    func show(){
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.alpha = 0.8 ;
            }, completion: nil);
        
        _superview.viewWithTag(OptionsMenu.viewToBeHiddenTag)?.alpha = 0;
    }
    
    // user chose an option:
    func optionSelected(_ sender: UITapGestureRecognizer){
        let optionIndex: Int = (sender.view?.tag)!;
        if let theDelegate = optionWasSelectedDelegate{
            theDelegate.optionWasSelected(optionIndex: optionIndex);
        }
    }
    
    
}

// Option item class
class Option{
    let optionName:String;
    let optionIcon: UIImage;
    
    init(icon: UIImage, label: String){
        self.optionName = label;
        self.optionIcon = icon;
    }
}

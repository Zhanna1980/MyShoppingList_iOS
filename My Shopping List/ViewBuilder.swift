//
//  ViewBuilder.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 26/10/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation
import UIKit

//Class with methods for adding typical views
class ViewBuilder{
    
    // add system button with text
     static func addSimpleSystemButton(frame: CGRect, title: String, addToView view: UIView)->UIButton{
        let button = UIButton(type: .system);
        button.frame = frame;
        button.setTitle(title, for: .normal);
        view.addSubview(button);
        return button;
    }

    // add system button 50x50
    static func addSquareSystemButton(position: CGPoint, title: String, addToView view: UIView)->UIButton{
        let button = baseButton(position: position, addToView: view, type: .system);
        button.setTitle(title, for: .normal);
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30);
        return button;
    }
    
    // add custom button with icon 50x50
    static func addSquareButtonWithIcon(position: CGPoint, icon: UIImage, addToView view: UIView)->UIButton{
        let button = baseButton(position: position, addToView: view, type: .custom);
        button.contentMode = .scaleAspectFit;
        button.setImage(icon, for: .normal);
        return button;
    }
    
    //function used inside the class for creating basic button.
    static fileprivate func baseButton(position: CGPoint, addToView view: UIView, type: UIButtonType)->UIButton{
        let button = UIButton(type: type);
        button.frame = CGRect(x: position.x, y: position.y, width: 50, height: 50);
        button.backgroundColor = UIColor.white;
        button.setBorder();
        button.alpha = 0.8;
        view.addSubview(button);
        return button;
    }
    
    // add textField
    static func addTextField(frame: CGRect, addToView view: UIView)->UITextField{
        let textField = UITextField(frame: frame);
        textField.borderStyle = .roundedRect;
        textField.setBorder();
        textField.backgroundColor = UIColor.white;
        textField.alpha = 0.8;
        view.addSubview(textField);
        return textField;
    }
    
    //add label
    static func addLabel(frame: CGRect, text: String, addToView view: UIView)->UILabel{
        let label = UILabel(frame: frame);
        label.text = text;
        view.addSubview(label);
        return label;
    }
}

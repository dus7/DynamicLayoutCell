//
//  ObjcWrapper.swift
//  DynamicLayoutCell
//
//  Created by Mariusz Spiewak on 26/10/2017.
//  Copyright © 2017 Mariusz Śpiewak. All rights reserved.
//

import UIKit

/**
 *  This is needed to have common API for both swift and objc version and not subclass the
 *  original DynamicLayoutCell class since it contains generics.
 *  Once we get rid of the objc use-cases we can completely remove this.
 */
@objc public protocol GenericLayoutViewAPI {
    var layoutDefinition: LayoutDefinition { get }
    var rootView: UIView { get }
    
    var cellModel: LayoutViewModel { get }
    
    func setLayoutDefinition(_ definition: LayoutDefinition) throws
}


/**
 *  Use this to CREATE DynamicLayoutCell in objc code. If you have a DynamicLayoutCell created from swift,
 *  you should cast it to id<GenericLayoutViewAPI> to use inside objc. Having said that,
 *  using this in swift <-> objc is limited.
 */
@objc class GenericDynamicLayoutCell : UITableViewCell, GenericLayoutViewAPI {
    
    private var underlyingCell: GenericLayoutViewAPI?
    
    @objc func populate(originalCell: GenericLayoutViewAPI) {
        if underlyingCell !== originalCell {
            underlyingCell = originalCell
        }
    }
    
    var rootView: UIView {
        return underlyingCell?.rootView ?? UIView()
    }
    
    @objc var layoutDefinition: LayoutDefinition {
        return underlyingCell?.layoutDefinition ?? DummyLayoutDefinition()
    }
    
    @objc var cellModel: LayoutViewModel { return (underlyingCell?.cellModel)! }
    
    @objc func setLayoutDefinition(_ definition: LayoutDefinition) throws {
        try underlyingCell?.setLayoutDefinition(definition)
        
        contentView.addSubview(rootView)
        
        contentView.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-[mainView]-|",
                                           options: [],
                                           metrics: nil,
                                           views: ["mainView" : rootView]))
        contentView.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-[mainView]-|",
                                           options: [],
                                           metrics: nil,
                                           views: ["mainView" : rootView]))
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//extension GenericDynamicLayoutCell {
//    @objc static func twoLineCell(reuseIdentifier: String) -> GenericLayoutViewAPI {
//        return DynamicLayoutCell<TwoLineModel>(style: .default, reuseIdentifier: reuseIdentifier)
//    }
//}


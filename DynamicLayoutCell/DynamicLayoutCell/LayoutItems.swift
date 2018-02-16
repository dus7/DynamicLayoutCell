//
//  LayoutItems.swift
//  DynamicLayoutCell
//
//  Created by Mariusz Spiewak on 28/10/2017.
//  Copyright © 2017 Mariusz Śpiewak. All rights reserved.
//

import UIKit
final public class ChevronItem: LayoutItem {
    
    static let chevronSize: CGFloat = 23
    static let defaultChevronImage = UIImage(named: "chevron")
    
    public override init(binding: String?) {
        super.init(binding: binding)
        
        isRequired = true
        priority = .lowest
        minWidth = ChevronItem.chevronSize
        maxWidth = ChevronItem.chevronSize
        minHeight = ChevronItem.chevronSize
        horizontalAlignment = .fill
        verticalAlignment = .center
    }
    
    override public func createElement(_ bindings: inout [String : UIView]) -> ContentElement {
        let imageView = UIImageView()
        imageView.image = ChevronItem.defaultChevronImage
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }
}

final public class MultilineLabelItem: LabelItem {
    
    override public func createElement(_ bindings: inout [String : UIView]) -> ContentElement {
        let label = super.createElement(&bindings) as! UILabel
        label.numberOfLines = 0
        return label
    }
}

public class LabelItem: LayoutItem {
    override public func createElement(_ bindings: inout [String : UIView]) -> ContentElement {
        let label = UILabel()
        // Required for text items so they wont be clipped horizontally
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }
}

final public class ButtonItem: LayoutItem {
    
    public override var category: LayoutItemCategory {
        get { return .primary }
        set {}
    }
    
    public override init(binding: String?) {
        super.init(binding: binding)
        
        idiom = .actionable
    }
    
    override public func createElement(_ bindings: inout [String : UIView]) -> ContentElement {
        let button = UIButton()
        // Required for text items so they wont be clipped horizontally
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        return button
    }
}

final public class ImageItem: LayoutItem {
    
    override public init(binding: String?) {
        super.init(binding: binding)
        
        isRequired = true
    }
    
    override public func createElement(_ bindings: inout [String : UIView]) -> ContentElement {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }
}

/**
 *  Custom item lets you insert a 'placeholder' in the layout for displaying not-yet-defined UIView.
 *  `createCustomElement` closure needs to be defined before generating a model from the layout (before applying a layout on the cell).
 *  Although there is a closure creating an item, you should create a separate instance of the Layout for each 'configuration' of the layout,
 *  and then bind this layout with the cell. E.g. if you consider using this for containing textView and stackView,
 *  you should create two layout instances - one creating textView and another a stackView.
 */
public final class CustomItem: LayoutItem {
    
    public var createCustomElement: (() -> ContentElement)?
    
    override public func createElement(_ bindings: inout [String : UIView]) -> ContentElement {
        if let createCustomElement = createCustomElement {
            return createCustomElement()
        } else {
            return super.createElement(&bindings)
        }
    }
}

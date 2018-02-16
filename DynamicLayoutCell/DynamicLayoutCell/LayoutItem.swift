//
//  LayoutDefinition.swift
//  DynamicLayoutCell
//
//  Created by Mariusz Spiewak on 18/09/2017.
//  Copyright © 2017 Mariusz Śpiewak. All rights reserved.
//

import UIKit

/**
 *  Adopt this protocol when creating own layout for DynamicLayoutCell
 */
@objc public protocol LayoutDefinition {
    
    /**
     *  Main layout item, containing all items that needs to be displayed
     */
    var rootContentItem: LayoutItem { get }
}

/**
 *  Defines the item's information significance in context of presented information.
 */
@objc public enum LayoutItemCategory: Int {
    /// Body font is used by default.
    case primary
    /// Subheadline font is used by default.
    case secondary
    /// Footnote font is used by default.
    case supplementary
    /// Defines that no information is carried by the item. E.g. container or empty view.
    case plain
}

/**
 *  Defines how the item should be rendered regarding to
 *  expected user interaction and/or its role in layout.
 */
@objc public enum LayoutItemIdiom: Int {
    case plain
    case value
    case input
    case destructive
    case actionable
}

/**
 *  Defines the alignment of element view inside the container.
 *  `fill` means the view is constrained to item's top and bottom margins.
 *  In other cases at least one constraint becomes 'flexible' (>=0)
 */
@objc public enum LayoutItemVerticalAlignment: UInt {
    // Bottom margin is 'flexible'
    case top
    case center
    case bottom
    case fill
}

/**
 *  Defines the alignment of element view inside the container.
 *  `fill` means the view is constrained to item's left and right margins
 *  In other cases at least one constraint becomes 'flexible' (>=0)
 */
@objc public enum LayoutItemHorizontalAlignment: UInt {
    case left
    case center
    case right
    case fill
}

/**
 *  Is subtracted from hugging priority of the item. You are free to use the rawValue
 *  to tweak the layout. Initial value of the priority is the UIView default (250).
 */
@objc public enum LayoutItemPriority: Int {
    case primary = 249
    case highest = 10
    case high = 5
    case normal = 0
    case low = -5
    case lower = -10
    case lowest = -750
}

@objc open class LayoutItem: NSObject, ContainerProxy {
    
    /**
     *  Works only when item is inside container
     */
    public var minWidth: CGFloat?
    
    /**
     *  Works only when item is inside container
     */
    public var maxWidth: CGFloat?
    
    /**
     *  Works only when item is inside container
     */
    public var minHeight: CGFloat?
    
    /**
     *  Works only when item is inside container
     */
    public var maxHeight: CGFloat?
    
    /**
     *  See LayoutItemHorizontalAlignment documentation for details
     */
    public var horizontalAlignment: LayoutItemHorizontalAlignment = .fill
    
    /**
     *  See LayoutItemVerticalAlignment documentation for details
     */
    public var verticalAlignment: LayoutItemVerticalAlignment = .fill
    
    /**
     *  See LayoutItemPriority documentation for details
     */
    public var priority: LayoutItemPriority = .normal
    
    /**
     *  Sets the outside spacing for the item. These values are ignored when element is empty.
     *  Values can be negative, which will overlap views unless they clip subviews
     */
    public var margins: UIEdgeInsets = UIEdgeInsets.zero
    
    /**
     *  Sets the compression resistance of both axes to required
     *
     *  If you need to make sure that the whole element will be displayed without clipping
     *  set this property to `true`. Note that for text-based items vertical compression resistance
     *  is already set to required, to prevent horizontal clipping.
     */
    public var isRequired: Bool = false
    
    /**
     *  Used for applying style
     *
     *  See `LayoutItemCategory` for details
     */
    public var category: LayoutItemCategory = .plain
    
    /**
     *  Used for applying style
     *
     *  See `LayoutItemIdiom` for details
     */
    public var idiom: LayoutItemIdiom = .plain
    
    /**
     *  In general this is used by `LayoutDefinition` and equals `DefaultStyleDefinition`
     *  initially. Regardless, you can use this property on each of the element to
     *  apply custom style definition. The value must be set prior to creating element
     *  (setting layout definition on a DynamicLayoutCell).
     */
    public var styleDefinition: LayoutItemStyleDefinition = DefaultStyleDefinition()
    
    /**
     *  This closure is called when all constraints and bindings are applied to the created
     *  element. Use this to fine-tune the object that was created by the layout item.
     */
    public var onCreate: ((_ element: ContentElement)->Void)?
    
    /**
     *  Binding identifier used to couple created view with the model
     */
    private(set) var binding: String? = nil
    
    /**
     *  Creates an element defined by the item.
     *  Override this method when you create your own LayoutItem.
     *  Bindings can be ignored in subclass if it's not capable of containing other items.
     */
    public func createElement(_ bindings: inout [String:UIView]) -> ContentElement {
        return UIView()
    }
    
    public init(binding: String? = nil) {
        super.init()
        
        self.binding = binding
    }
    
    // MARK: Internal
    
    internal final func createInContainer(_ bindings: inout [String:UIView]) -> DynamicLayoutContainerView {
        let element = create(&bindings)
        let container = DynamicLayoutContainerView()
        
        container.margins = margins
        container.maxWidth = maxWidth
        container.minWidth = minWidth
        container.maxHeight = maxHeight
        container.minHeight = minHeight
        container.verticalAlignment = verticalAlignment
        container.horizontalAlignment = horizontalAlignment
        
        container.installContentElement(element)
        return container
    }
    
    internal final func create(_ bindings: inout [String:UIView]) -> ContentElement {
        let element = createElement(&bindings)
        applyLayoutSettings(element.view)
        element.applyStyle(styleDefinition.style(for: category, idiom: idiom))
        bind(element, bindings: &bindings)
        onCreate?(element)
        
        return element
    }
    
    internal final func applyLayoutSettings(_ view: UIView) {
        if isRequired {
            view.setContentCompressionResistancePriority(.required, for: .horizontal)
            view.setContentCompressionResistancePriority(.required, for: .vertical)
        }
        
        if priority != .normal {
            let currentVHuggingPriority = view.contentHuggingPriority(for: .vertical).rawValue
            view.setContentHuggingPriority(.init(currentVHuggingPriority - Float(priority.rawValue)), for: .vertical)
            let currentHHuggingPriority = view.contentHuggingPriority(for: .horizontal).rawValue
            view.setContentHuggingPriority(.init(currentHHuggingPriority - Float(priority.rawValue)), for: .horizontal)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    internal final func bind(_ element: ContentElement, bindings: inout [String:UIView]) {
        if let bindingString = binding {
            bindings[bindingString] = element.view
        }
    }
}

// MARK: -

/**
 *  Generic container item class
 *
 *  Inherit from this class to create a custom container item
 */
open class LayoutContainerItem: LayoutItem {
    
    /**
     *  Axis of the container in which the items are laid out
     */
    var axis: UILayoutConstraintAxis
    

    public final var items: [LayoutItem] {
        didSet {
            updateStyleForContent()
        }
    }
    
    public final override var styleDefinition: LayoutItemStyleDefinition {
        didSet {
            updateStyleForContent()
        }
    }
    
    private final func updateStyleForContent() {
        for item in items {
            item.styleDefinition = styleDefinition
        }
    }
    
    public init(direction: UILayoutConstraintAxis,
         items: [LayoutItem],
         binding: String? = nil)
    {
        
        self.axis = direction
        self.items = items
        
        super.init(binding: binding)
    }
}

// MARK: -

open class ContainerItem: LayoutContainerItem {
    
    public convenience init(direction: UILayoutConstraintAxis, items: [LayoutItem] = []) {
        self.init(direction: direction,
                  items: items,
                  binding: nil)
        
        self.axis = direction
        self.items = items
    }
    
    public class func horizontal(_ items: [LayoutItem]) -> ContainerItem {
        return ContainerItem(direction: .horizontal, items: items)
    }
    
    public class func vertical(_ items: [LayoutItem]) -> ContainerItem {
        return ContainerItem(direction: .vertical, items: items)
    }
    
    override public final func createElement(_ bindings: inout [String:UIView]) -> ContentElement {
        let subviews = items.flatMap{ return $0.createInContainer(&bindings) }
        let view = UIStackView(arrangedSubviews: subviews)
        
        view.axis = axis
        view.alignment = .fill
        view.distribution = .fill
        
        return view
    }
}

//
//  ContentElement.swift
//  DynamicLayoutCell
//
//  Created by Mariusz Spiewak on 21/10/2017.
//  Copyright © 2017 Mariusz Śpiewak. All rights reserved.
//

import UIKit

/**
 *  Element created based on `LayoutItem`.
 *  Usually it is the view itself, with additional capabilities.
 *
 *  You can adopt this protocol on any object, which can control
 *  the content element in some way. For example you can implement
 *  an email input element which contains the input element and
 *  a dedicated validator and self-contained logic.
 */
@objc public protocol ContentElement: NSObjectProtocol {
    /// Returns `true` when the element is empty and can be collapsed to (0,0) size
    var isEmpty: Bool { get }
    /// The view of the element
    var view: UIView { get }
    /// Sets the visual style for the view
    func applyStyle(_ style: DynamicCellStyle)
    /// Prepares the element for reusing with different content
    func reuse()
}

extension UIView: ContentElement {
    @objc public var isEmpty: Bool { return subviews.isEmpty }
    @objc public var view: UIView { return self }
    @objc public func applyStyle(_ style: DynamicCellStyle) { }
    @objc public func reuse() { }
    
//    internal func updateConstraintsForContainerIfNeeded() {
//        if let container = superview as? ContainerView {
//            container.updateConstraints()
//        }
//    }
}

extension UIStackView {
    override public var isEmpty: Bool {
        return arrangedSubviews.reduce(true, { (previousResult, subview) -> Bool in
            let element = subview as ContentElement
            return element.isEmpty && previousResult
        })
    }
    override public func applyStyle(_ style: DynamicCellStyle) { }
    
//    open override func updateConstraints() {
//        updateConstraintsForContainerIfNeeded()
//        super.updateConstraints()
//    }
}

extension UITextField {
    override public var isEmpty: Bool { return text?.isEmpty ?? true }
    override public func applyStyle(_ style: DynamicCellStyle) {
        self.textColor = style.foregroundColor
        self.font = style.font
    }
    
    override public func reuse() { self.text = nil }
    
//    open override func updateConstraints() {
//        updateConstraintsForContainerIfNeeded()
//        super.updateConstraints()
//    }
}

extension UILabel {
    override public var isEmpty: Bool { return text?.isEmpty ?? true }
    
    override public func applyStyle(_ style: DynamicCellStyle) {
        self.textColor = style.foregroundColor
        self.font = style.font
    }
    
    override public func reuse() { self.text = nil }
    
//    open override func updateConstraints() {
//        updateConstraintsForContainerIfNeeded()
//        super.updateConstraints()
//    }
}

extension UIButton {
    override public var isEmpty: Bool { return false }
    override public func applyStyle(_ style: DynamicCellStyle) {
        self.setTitleColor(style.foregroundColor, for: .normal)
        self.titleLabel?.font = style.font
    }
    override public func reuse() {
        setTitle(nil, for: .normal)
        removeTarget(nil, action: nil, for: .allEvents)
    }
    
//    open override func updateConstraints() {
//        updateConstraintsForContainerIfNeeded()
//        super.updateConstraints()
//    }
}

extension UIImageView {
    override public var isEmpty: Bool { return image == nil }
    override public func applyStyle(_ style: DynamicCellStyle) { }
    override public func reuse() { self.image = nil }
    
//    open override func updateConstraints() {
//        updateConstraintsForContainerIfNeeded()
//        super.updateConstraints()
//    }
}

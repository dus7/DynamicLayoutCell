//
//  CellContainerView.swift
//  DynamicLayoutCell
//
//  Created by Mariusz Spiewak on 17/09/2017.
//  Copyright © 2017 Mariusz Śpiewak. All rights reserved.
//

import UIKit

/**
 *  See `LayoutItem` doc
 */
protocol ContainerProxy
{
    var minWidth: CGFloat? { get set }
    var maxWidth: CGFloat? { get set }
    var minHeight: CGFloat? { get set }
    var maxHeight: CGFloat? { get set }
    
    var margins: UIEdgeInsets { get set }
    
    var verticalAlignment: LayoutItemVerticalAlignment { get set }
    var horizontalAlignment: LayoutItemHorizontalAlignment { get set }
}

/**
 *  Container view that does the 'layout magic' for the container items.
 *  You should not care much about this object, unless you want to fix
 *  a bug (troll) or just use this in your view (yes, yes, you can do it :D).
 */
public final class DynamicLayoutContainerView: UIView, ContainerProxy {

    public var minWidth: CGFloat? { didSet { setNeedsUpdateConstraints() } }
    public var maxWidth: CGFloat? { didSet { setNeedsUpdateConstraints() } }
    public var minHeight: CGFloat? { didSet { setNeedsUpdateConstraints() } }
    public var maxHeight: CGFloat? { didSet { setNeedsUpdateConstraints() } }
    
    private(set) var installedElement: ContentElement?
    public var margins: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    public var verticalAlignment: LayoutItemVerticalAlignment = .center {
        didSet {
            topConstraint = nil
            bottomConstraint = nil
            setNeedsUpdateConstraints()
        }
    }
    
    public var horizontalAlignment: LayoutItemHorizontalAlignment = .left {
        didSet {
            leadingConstraint = nil
            trailingConstraint = nil
            setNeedsUpdateConstraints()
        }
    }
    
    private weak var leadingConstraint: NSLayoutConstraint?
    private weak var trailingConstraint: NSLayoutConstraint?
    private weak var topConstraint: NSLayoutConstraint?
    private weak var bottomConstraint: NSLayoutConstraint?
    private weak var centeringXConstraint: NSLayoutConstraint?
    private weak var centeringYConstraint: NSLayoutConstraint?
    
    private var zeroWidthConstraint: NSLayoutConstraint?
    private var zeroHeightConstraint: NSLayoutConstraint?
    private var minWidthConstraint: NSLayoutConstraint?
    private var minHeightConstraint: NSLayoutConstraint?
    private var maxHeightConstraint: NSLayoutConstraint?
    private var maxWidthConstraint: NSLayoutConstraint?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialConstraints()
        clipsToBounds = true
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        clipsToBounds = true
    }
    
    deinit {
        installedElement?.view.removeObserver(self, forKeyPath: "hidden")
    }
    
    public func installContentElement(_ contentElement: ContentElement) {
        guard contentElement !== self else {
            assertionFailure("You cannot install a container inside itself... I mean, come on, it's just silly.")
            return
        }
        
        guard contentElement !== installedElement else { return }
    
        removeInstalledElement()
        
        contentElement.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentElement.view)
        
        copyPriorities(from: contentElement.view)
        
        installedElement = contentElement
        installedElement?.view.addObserver(self,
                                           forKeyPath: "hidden",
                                           options: [.new],
                                           context: nil)
        setNeedsUpdateConstraints()
    }
    
    public func removeInstalledElement() {
        installedElement?.view.removeFromSuperview()
        installedElement?.view.removeObserver(self, forKeyPath: "hidden")
        setNeedsUpdateConstraints()
    }
    
    public override var isEmpty: Bool {
        return installedElement?.isEmpty ?? true
    }
    
    public override var view: UIView {
        return self
    }
        
    private func copyPriorities(from view: UIView) {
        let hcr = view.contentCompressionResistancePriority(for: .horizontal)
        let vcr = view.contentCompressionResistancePriority(for: .vertical)
        let hhp = view.contentHuggingPriority(for: .horizontal)
        let vhp = view.contentHuggingPriority(for: .vertical)
        setContentCompressionResistancePriority(hcr, for: .horizontal)
        setContentCompressionResistancePriority(vcr, for: .vertical)
        setContentHuggingPriority(hhp, for: .horizontal)
        setContentHuggingPriority(vhp, for: .vertical)
    }
    
    private func setupInitialConstraints() {
        zeroWidthConstraint = widthAnchor.constraint(equalToConstant: 0)
        zeroWidthConstraint?.priority = .init(999)
        
        zeroHeightConstraint = heightAnchor.constraint(equalToConstant: 0)
        zeroHeightConstraint?.priority = .init(999)
        
        maxWidthConstraint = widthAnchor.constraint(lessThanOrEqualToConstant: 0)
        maxWidthConstraint?.priority = .required
        
        maxHeightConstraint = heightAnchor.constraint(lessThanOrEqualToConstant: 0)
        maxHeightConstraint?.priority = .required
        
        minWidthConstraint = widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
        minWidthConstraint?.priority = .required
        
        minHeightConstraint = heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        minHeightConstraint?.priority = .required
    }
    
    private func updateCenteringConstraints(_ isEmpty: Bool) {
        guard let installedElement = installedElement else { return }
        
        if centeringXConstraint == nil {
            centeringXConstraint = installedElement.view.centerXAnchor.constraint(equalTo: centerXAnchor)
        }
        centeringXConstraint?.isActive = horizontalAlignment == .center && !isEmpty
        
        if centeringYConstraint == nil {
            centeringYConstraint = installedElement.view.centerYAnchor.constraint(equalTo: centerYAnchor)
        }
        centeringYConstraint?.isActive = verticalAlignment == .center && !isEmpty
    }
    
    private func updateHorizontalConstraints(_ isEmpty: Bool) {
        guard let installedElement = installedElement else { return }
        
        if leadingConstraint == nil {
            if horizontalAlignment == .left || horizontalAlignment == .fill {
                leadingConstraint = installedElement.view.leftAnchor.constraint(equalTo: leftAnchor, constant: margins.left)
            } else {
                leadingConstraint =
                    installedElement.view.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: margins.left)
            }
        }
        leadingConstraint?.isActive = true
        
        if trailingConstraint == nil {
            if horizontalAlignment == .right || horizontalAlignment == .fill {
                trailingConstraint = rightAnchor.constraint(equalTo:installedElement.view.rightAnchor , constant: margins.right)
            } else {
                trailingConstraint = installedElement.view.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: margins.right)
            }
        }
        trailingConstraint?.isActive = true
    }
    
    private func updateVerticalConstraints(_ isEmpty: Bool) {
        guard let installedElement = installedElement else { return }
        
        if topConstraint == nil {
            if verticalAlignment == .top || verticalAlignment == .fill {
                topConstraint = installedElement.view.topAnchor.constraint(equalTo: topAnchor, constant: margins.top)
            } else {
                topConstraint = installedElement.view.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: margins.top)
            }
        }
        topConstraint?.isActive = true
        
        if bottomConstraint == nil {
            if verticalAlignment == .bottom || verticalAlignment == .fill {
                bottomConstraint = bottomAnchor.constraint(equalTo: installedElement.view.bottomAnchor, constant: margins.bottom)
            } else {
                bottomConstraint = installedElement.view.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: margins.bottom)
            }
        }
        bottomConstraint?.isActive = true
    }
    
    private func updateSizeConstraints(_ isEmpty: Bool) {
        maxWidthConstraint?.constant = maxWidth ?? 0
        maxHeightConstraint?.constant = maxHeight ?? 0
        minWidthConstraint?.constant = minWidth ?? 0
        minHeightConstraint?.constant = minHeight ?? 0
        
        maxWidthConstraint?.isActive = maxWidth != nil && !isEmpty
        maxHeightConstraint?.isActive = maxHeight != nil && !isEmpty
        minWidthConstraint?.isActive = minWidth != nil && !isEmpty
        minHeightConstraint?.isActive = minHeight != nil && !isEmpty
    }
    
    private func updateConstraintsForEmptyState(_ isEmpty: Bool) {
        let margins: UIEdgeInsets = isEmpty ? .zero : self.margins
        
        leadingConstraint?.constant = margins.left
        trailingConstraint?.constant = margins.right
        topConstraint?.constant = margins.top
        bottomConstraint?.constant = margins.bottom
        
        zeroWidthConstraint?.isActive = isEmpty
        zeroHeightConstraint?.isActive = isEmpty
        
        let isEmptyIntrinsicSizeNonZero = isEmpty && !(installedElement?.view.intrinsicContentSize ?? CGSize.zero).equalTo(CGSize.zero)
        trailingConstraint?.isActive = !isEmptyIntrinsicSizeNonZero
        bottomConstraint?.isActive = !isEmptyIntrinsicSizeNonZero
        
        updateSizeConstraints(isEmpty)
    }
    
    public override func updateConstraints() {
        let isEmpty = self.isEmpty
        
        invalidateIntrinsicContentSize()
        
        guard installedElement != nil else {
            updateConstraintsForEmptyState(isEmpty)
            super.updateConstraints()
            return
        }
        
        updateCenteringConstraints(isEmpty)
        updateHorizontalConstraints(isEmpty)
        updateVerticalConstraints(isEmpty)
        
        updateConstraintsForEmptyState(isEmpty)
        
        super.updateConstraints()
    }
    
    public override var intrinsicContentSize: CGSize {
        guard let element = installedElement, !isEmpty else {
            return CGSize(width: UIViewNoIntrinsicMetric, height: UIViewNoIntrinsicMetric)
        }
        let size = element.view.intrinsicContentSize
        
        return CGSize(width: size.width + margins.left + margins.right,
                      height: size.height + margins.top + margins.bottom)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else { return }
        if keyPath == "hidden" {
            if let element = installedElement {
                isHidden = element.view.isHidden
            }
            
            setNeedsUpdateConstraints()
        }
    }
}

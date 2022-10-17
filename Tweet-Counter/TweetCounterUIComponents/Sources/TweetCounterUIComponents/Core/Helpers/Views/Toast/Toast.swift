//
//  Toast.swift
//  
//
//  Created by Omar Alaa on 17/10/2022.
//

import Foundation
import UIKit

public enum ToastImageName: String {
    case success = "successCheck"
    case error = "error-icon"
}
public enum ToastPosition {
    case top, bottom
}

public struct ToastUIModel {
    weak var viewToShowToast: UIView?
    let position: ToastPosition
    let addDismissButton: Bool
    let isToastDismissibleOnTap: Bool
    let shouldCountForSafeAreaLayout: Bool
    let backgroundColor: UIColor
    let foregroundColor: UIColor
    let verticalConstraintConstant: Int?
    let duration: Int?
    let cornerRadius: CGFloat
    
    public init(viewToShowToast: UIView?, position: ToastPosition = .bottom, addDismissButton: Bool = true, isToastDismissibleOnTap: Bool = true, backgroundColor: UIColor, foregroundColor: UIColor, verticalConstraintConstant: Int?, duration: Int? = 3, cornerRadius: CGFloat = 14) {
        self.viewToShowToast = viewToShowToast
        self.position = position
        self.addDismissButton = addDismissButton
        self.isToastDismissibleOnTap = isToastDismissibleOnTap
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.verticalConstraintConstant = verticalConstraintConstant
        self.duration = duration
        self.cornerRadius = cornerRadius
        if verticalConstraintConstant != nil {
            shouldCountForSafeAreaLayout = false
        } else {
            shouldCountForSafeAreaLayout = true
        }
    }
}

public class ToastDataModel {
    let iconImageName: ToastImageName?
    let actionButtonTitle: String?
    let message: String
    let actionButtonClosure: (() -> ())?
    
    public init(iconImageName: ToastImageName?, actionButtonTitle: String?, message: String, actionButtonClosure: (() -> ())?) {
        self.iconImageName = iconImageName
        self.actionButtonTitle = actionButtonTitle
        self.message = message
        self.actionButtonClosure = actionButtonClosure
    }
}
public class Toast: UIView {
    
    // MARK: - Outlets
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var dismissButtonContainerView: UIView!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var actionButtonContainerView: UIView!
    @IBOutlet private weak var actionButton: UIButton!
    
    // MARK: - Properties
    private var uiModel: ToastUIModel?
    private var dataModel: ToastDataModel?
    private var topAnchorConstraint: NSLayoutConstraint?
    private var bottomAnchorConstraint: NSLayoutConstraint?
    
    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    // MARK: - Public helpers
    public func configure(uiModel: ToastUIModel) {
        self.uiModel = uiModel
        if uiModel.addDismissButton {
            messageLabel.textAlignment = .natural
        }
        let closeIcon = UIImage(named: "close-icon", in: Bundle.module, with: nil)
        dismissButton.setImage(closeIcon, for: .normal)
        dismissButton.setImage(closeIcon, for: .selected)
        dismissButtonContainerView.isHidden = !uiModel.addDismissButton
        contentView.backgroundColor = uiModel.backgroundColor
        messageLabel.textColor = uiModel.foregroundColor
        iconImageView.tintColor = uiModel.foregroundColor
        dismissButton.tintColor = uiModel.foregroundColor
        contentView.roundCorners(withRadius: uiModel.cornerRadius)
        addTapGestureUponCanTapToDismissValue()
    }
    
    public func configure(dataModel: ToastDataModel) {
        self.dataModel = dataModel
        messageLabel.text = dataModel.message
        if let iconImageName = dataModel.iconImageName {
            imageContainerView.isHidden = false
            let iconImage = UIImage(named: iconImageName.rawValue, in: Bundle.module, with: nil)
            iconImageView.image = iconImage
            messageLabel.textAlignment = .natural
        } else {
            imageContainerView.isHidden = true
        }
        
        if let actionButtonTitle = dataModel.actionButtonTitle {
            actionButtonContainerView.isHidden = false
            actionButton.setTitle(actionButtonTitle, for: .normal)
            actionButton.setTitle(actionButtonTitle, for: .selected)
            messageLabel.textAlignment = .natural
        } else {
            actionButtonContainerView.isHidden = true
        }
        showToastView()
    }
    
    public func animateRemovingToastView() {
        guard superview != nil, let uiModel = uiModel else { return }
        switch uiModel.position {
        case .top:
            topAnchorConstraint?.constant = -100
        case .bottom:
            bottomAnchorConstraint?.constant = -100
        }
        UIView.animate(withDuration: 0.3) {
            uiModel.viewToShowToast?.layoutIfNeeded()
        } completion: { [weak self] isCompleted in
            guard let strongSelf = self else { return }
            if strongSelf.superview != nil && isCompleted {
                strongSelf.removeFromSuperview()
            }
        }
    }
}

// MARK: - Actions
private extension Toast {
    @IBAction func didTapDismissButton(_ sender: Any) {
        animateRemovingToastView()
    }
    
    @IBAction func didTapActionButton(_ sender: Any) {
        animateRemovingToastView()
        dataModel?.actionButtonClosure?()
    }
}

private extension Toast {
    func loadViewFromNib() {
        let bundle = Bundle.module
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func addTapGestureUponCanTapToDismissValue() {
        guard let uiModel = uiModel else { return }
        let canTapToDismiss = uiModel.isToastDismissibleOnTap
        contentView.isUserInteractionEnabled = canTapToDismiss
        if canTapToDismiss {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnToast))
            contentView.addGestureRecognizer(tapGesture)
        }
    }

    
    func showToastView() {
        guard let viewToShowToast = uiModel?.viewToShowToast else { return }
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        viewToShowToast.addSubview(self)
        setupToastView()
    }
    
    func setupToastView() {
        guard let uiModel = uiModel, let viewToShowToast = uiModel.viewToShowToast else { return }
        leadingAnchor.constraint(equalTo: viewToShowToast.leadingAnchor, constant: 16).isActive = true
        viewToShowToast.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16).isActive = true
        switch uiModel.position {
        case .top:
            let superViewtopAnchor = uiModel.shouldCountForSafeAreaLayout ? viewToShowToast.safeAreaLayoutGuide.topAnchor : viewToShowToast.topAnchor
            topAnchorConstraint = topAnchor.constraint(equalTo: superViewtopAnchor, constant: 0)
            topAnchorConstraint?.isActive = true
        case .bottom:
            let superViewBottomAnchor = uiModel.shouldCountForSafeAreaLayout ? viewToShowToast.safeAreaLayoutGuide.bottomAnchor : viewToShowToast.bottomAnchor
            bottomAnchorConstraint = superViewBottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
            bottomAnchorConstraint?.isActive = true
        }
        layoutIfNeeded()
        viewToShowToast.layoutIfNeeded()
        animateShowingToastView()
    }
    
    func animateShowingToastView() {
        guard let uiModel = uiModel else { return }
        switch uiModel.position {
        case .top:
            let verticalConstraintConstant = uiModel.verticalConstraintConstant ?? 16
            topAnchorConstraint?.constant = CGFloat(verticalConstraintConstant)
        case .bottom:
            let verticalConstraintConstant = uiModel.verticalConstraintConstant ?? 36
            bottomAnchorConstraint?.constant = CGFloat(verticalConstraintConstant)
        }
        isHidden = false

        UIView.animate(withDuration: 0.3) {
            uiModel.viewToShowToast?.layoutIfNeeded()
        }
        setupToastViewDuration()
    }
    
    func setupToastViewDuration() {
        guard let duration = uiModel?.duration else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(duration)) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.animateRemovingToastView()
        }
    }
    
    @objc func didTapOnToast() {
        animateRemovingToastView()
    }
}

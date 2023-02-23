//
//  SchoolsListStateView.swift
//  NYCSchools
//
//  Created by Cong Huynh on 2023-02-21.
//

import Foundation
import UIKit
import PureLayout

class SchoolsListStateView: UIView {
    private struct Constants {
        static let stackViewSpacing: CGFloat = 30
        static let stackViewInsets = UIEdgeInsets(top: 200,
                                                  left: 100,
                                                  bottom: 200,
                                                  right: 100)
        static let headerLabelWidth: CGFloat = 200
        static let iconImageSize = CGSize(width: 200,
                                          height: 200)
        static let headerLabelFontSize: CGFloat = 25
        static let messageLabelFontSize: CGFloat = 18
    }
    
    var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.headerLabelFontSize)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.messageLabelFontSize)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let stackView = UIStackView(forAutoLayout: ())
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        addSubview(stackView)
        
        stackView.autoPinEdgesToSuperviewEdges(with: Constants.stackViewInsets)
        stackView.addArrangedSubview(headerLabel)
        stackView.addArrangedSubview(messageLabel)
        
        
        headerLabel.autoSetDimension(.width,
                                     toSize: Constants.headerLabelWidth)
        messageLabel.autoSetDimension(.width,
                                      toSize: Constants.headerLabelWidth)
        
        stackView.addArrangedSubview(iconImageView)
        iconImageView.autoSetDimensions(to: Constants.iconImageSize)
    }
    
    func update(for state: SchoolListLoadState) {
        switch state {
        case .error:
            headerLabel.text = "school.loading.error.title".localized()
            messageLabel.text = "school.loading.error.description".localized()
            iconImageView.image = UIImage(named: "error")
        case .empty:
            headerLabel.text = "school.list.empty.title".localized()
            messageLabel.text = "school.list.empty.description".localized()
            iconImageView.image = UIImage(named: "customer")
        case .loaded:
            //loaded state this view will not be used, since
            //actual data in collection will be displayed.
            break
        }
    }
}

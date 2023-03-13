//
//  SchoolCollectionViewCell.swift
//  NYCSchools
//
//  Created by Cong Huynh on 2023-02-21.
//

import Foundation
import UIKit
import PureLayout

class SchoolCollectionViewCell: UICollectionViewCell {
    private var school: School?
    
    private struct Constants {
        static let leftInset: CGFloat = 10
        static let topInset: CGFloat = 10
        static let rightInset: CGFloat = 10
        static let bottomInset: CGFloat = 10
        static let borderWidth: CGFloat = 0.5
        static let imageHeight: CGFloat = 80
        static let cornerRadius: CGFloat = 10.0
        static let wrapperViewInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    // this is not a store property, this label is computed
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        return label
    }()
    
    private var cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        return label
    }()
    
    private var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        return label
    }()
    
    private var wrapperView: UIView = {
        let view = UIView(forAutoLayout: ())
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = Constants.borderWidth
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    // dont need to call these init directly, but we dequeue the collectionViewCell in the collectionViewDataSource.
    // it is called automatically by the UIKit functions to reuse the unused available cell to increase the performance
    // in case of there have millions of cells where there are only limited cells will be displayed on screen, and
    // when we scroll out, the collectionViewCell or tableViewCell will be recycled, dequeue the reusable cells, and
    // we should clean up the cell before we initialize it again.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override func prepareForReuse() {
            // prepare any clean up necessary to prepare the view for use again
    }
    
    private func setupViews() {
        backgroundColor = .white
        setupWrapperView()
        setupNameLabel()
        setupCityLabel()
        setupEmailLabel()
    }
    
    private func setupWrapperView() {
        addSubview(wrapperView)
        wrapperView.autoPinEdgesToSuperviewEdges(with: Constants.wrapperViewInsets) // from PureLayout
    }
    
    private func setupNameLabel() {
        wrapperView.addSubview(nameLabel)
        nameLabel.autoPinEdge(toSuperviewEdge: .leading,
                              withInset: Constants.leftInset)
        nameLabel.autoPinEdge(toSuperviewEdge: .trailing,
                              withInset: Constants.rightInset)
        nameLabel.autoPinEdge(toSuperviewEdge: .top,
                              withInset: Constants.topInset)
    }
    
    private func setupCityLabel() {
        wrapperView.addSubview(cityLabel)
        cityLabel.autoPinEdge(toSuperviewEdge: .leading,
                              withInset: Constants.leftInset)
        cityLabel.autoPinEdge(toSuperviewEdge: .trailing,
                              withInset: Constants.rightInset)
        cityLabel.autoPinEdge(.top,
                              to: .bottom,
                              of: nameLabel,
                              withOffset: Constants.topInset)
    }
    
    private func setupEmailLabel() {
        wrapperView.addSubview(emailLabel)
        emailLabel.autoPinEdge(toSuperviewEdge: .leading,
                               withInset: Constants.leftInset)
        emailLabel.autoPinEdge(toSuperviewEdge: .trailing,
                               withInset: Constants.rightInset)
        emailLabel.autoPinEdge(.top,
                              to: .bottom,
                              of: cityLabel,
                              withOffset: Constants.topInset)
        emailLabel.autoPinEdge(toSuperviewEdge: .bottom,
                               withInset: Constants.bottomInset)
    }
    
    func populate(_ school: School) {
        self.school = school
        nameLabel.text = school.schoolName
        cityLabel.text = school.city
        emailLabel.text = school.schoolEmail
    }
}

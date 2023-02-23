//
//  SchoolSATDetailsCollectionViewCell.swift
//  NYCSchools
//
//  Created by Cong Huynh on 2023-02-22.
//

import Foundation
import UIKit
import PureLayout

class SchoolSATDetailsCollectionViewCell: UICollectionViewCell {
    // data content of view cell
    private var schoolSAT: SchoolSAT?
    
    // custom insets of view cell
    private struct Constants {
        static let leftInset: CGFloat = 10
        static let topInset: CGFloat = 10
        static let rightInset: CGFloat = 10
        static let bottomInset: CGFloat = 10
        static let borderWidth: CGFloat = 0.5
        static let cornerRadius: CGFloat = 10.0
        static let wrapperViewInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        static let spacing: CGFloat = 3.0
    }
    
    // UI components computed
    private var numberOfSATTestTakersTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        return label
    }()
    
    private var numberOfSATTestTakersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        return label
    }()
    
    private var mathScoreTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        return label
    }()
    
    private var mathScoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        return label
    }()
    
    private var readingScoreTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        return label
    }()
    
    private var readingScoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        return label
    }()
    
    private var writingTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        return label
    }()
    
    private var writingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        return label
    }()
    
    private var wrapperView: UIView = {
        let view = UIView(forAutoLayout: ())
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = Constants.borderWidth
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView(forAutoLayout: ())
        stackView.spacing = Constants.spacing
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
    
    // initialize cell
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // auto layout using PureLayout
    private func setupViews() {
        backgroundColor = .white
        setupWrapperView()
        setupStackView()
    }
    
    private func setupWrapperView() {
        addSubview(wrapperView)
        wrapperView.autoPinEdgesToSuperviewEdges(with: Constants.wrapperViewInsets)
    }
    
    private func setupStackView() {
        wrapperView.addSubview(stackView)
        
        // pining edges of inner stackView to outter wrapperView
        stackView.autoPinEdge(toSuperviewEdge: .top,
                              withInset: Constants.topInset)
        stackView.autoPinEdge(toSuperviewEdge: .bottom,
                              withInset: Constants.bottomInset)
        stackView.autoPinEdge(toSuperviewEdge: .leading,
                              withInset: Constants.leftInset)
        stackView.autoPinEdge(toSuperviewEdge: .trailing,
                              withInset: Constants.rightInset)
        
        // labels
        stackView.addArrangedSubview(numberOfSATTestTakersTitleLabel)
        stackView.addArrangedSubview(numberOfSATTestTakersLabel)
        
        stackView.addArrangedSubview(mathScoreTitleLabel)
        stackView.addArrangedSubview(mathScoreLabel)
        
        stackView.addArrangedSubview(readingScoreTitleLabel)
        stackView.addArrangedSubview(readingScoreLabel)
        
        stackView.addArrangedSubview(writingTitleLabel)
        stackView.addArrangedSubview(writingLabel)
        
        // label titles
        numberOfSATTestTakersTitleLabel.text = "school.details.sat.number.test.takers.title".localized()
        mathScoreTitleLabel.text = "school.details.sat.math.title".localized()
        readingScoreTitleLabel.text = "school.details.sat.critical.reading.title".localized()
        writingTitleLabel.text = "school.details.sat.writing.title".localized()
    }
    
    // populate content of SchoolSATDetails cell
    func populate(schoolSAT: SchoolSAT) {
        numberOfSATTestTakersLabel.text = schoolSAT.numberOfSATTestTakers ?? ""
        mathScoreLabel.text = schoolSAT.mathAVGScore ?? ""
        readingScoreLabel.text = schoolSAT.criticalReadingAVGScore ?? ""
        writingLabel.text = schoolSAT.writingAVGScore ?? ""
    }
}

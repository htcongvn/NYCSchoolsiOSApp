//
//  SchoolDetailsViewController.swift
//  NYCSchools
//
//  Created by Cong Huynh on 2023-02-21.
//

import Foundation
import UIKit
import PureLayout
import CoreLocation

class SchoolDetailsViewController: UIViewController {
    private var sectionsList: [String] = ["school.details.section".localized(),
                                          "school.details.sat.section".localized(),
                                          "school.details.map.section".localized()]
    private var collectionView: UICollectionView?
    private let locationManager = CLLocationManager()
    
    var viewModel: SchoolDetailsViewModel?
    
    private struct Constants {
        static let schoolDetailsCellIdentifier: String = "schoolDetailsCell"
        static let detailsCellHeight: CGFloat = 360
        static let sectionHeaderIdentifier: String = "sectionHeader"
        static let sectionHeight: CGFloat = 50
        static let schoolSATCellIdentifier: String = "schoolSATDetailsCell"
        static let satCellHeight: CGFloat = 180
        static let schoolMapDetailsCellIdentifier: String = "schoolMapDetailsCell"
        static let mapCellHeight: CGFloat = 250
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel?.school.schoolName ?? ""
        view.backgroundColor = .white
        setupCollectionView()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // CLLocationAccuracy type
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: view.frame.size.width,
                                               height: Constants.detailsCellHeight)
        collectionViewLayout.headerReferenceSize = CGSize(width: view.frame.size.width,
                                                          height: Constants.sectionHeight)
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: view.frame,
                                          collectionViewLayout: collectionViewLayout)
        
        guard let collectionView = collectionView else {
            return
        }
        
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges()
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        
        //setup & customize CollectionViewFlowLayout
        collectionView.register(SchoolDetailsCollectionViewCell.self,
                                forCellWithReuseIdentifier: Constants.schoolDetailsCellIdentifier)
        collectionView.register(SchoolSATDetailsCollectionViewCell.self,
                                forCellWithReuseIdentifier: Constants.schoolSATCellIdentifier)
        collectionView.register(SchoolDetailsMapCollectionViewCell.self,
                                forCellWithReuseIdentifier: Constants.schoolMapDetailsCellIdentifier)
        collectionView.register(SchoolSectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: Constants.sectionHeaderIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension SchoolDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        // for now we have only 1 cell per section
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0: // school details cell configuration
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.schoolDetailsCellIdentifier,
                                                          for: indexPath)
            guard let schoolDetailsCell = cell as? SchoolDetailsCollectionViewCell,
                  let school = viewModel?.school else {
                return cell
            }
            schoolDetailsCell.populate(school: school)
            return schoolDetailsCell
        case 1: // sat cell configuration
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.schoolSATCellIdentifier,
                                                          for: indexPath)
            guard let schoolSATCell = cell as? SchoolSATDetailsCollectionViewCell,
                  let schoolSAT = viewModel?.schoolSAT else {
                return cell
            }
            schoolSATCell.populate(schoolSAT: schoolSAT)
            return schoolSATCell
        case 2: // map cell configuration
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.schoolMapDetailsCellIdentifier,
                                                          for: indexPath)
            guard let schoolMapCell = cell as? SchoolDetailsMapCollectionViewCell,
                  let school = viewModel?.school else {
                return cell
            }
            schoolMapCell.populate(school: school)
            return schoolMapCell
        default:
            // generic view cell configuration
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        // SchoolSectionHeaderView - section header element configuration
        if kind == UICollectionView.elementKindSectionHeader,
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                withReuseIdentifier: Constants.sectionHeaderIdentifier,
                                                                                for: indexPath) as? SchoolSectionHeaderView  {
            sectionHeader.headerLabel.text = sectionsList[indexPath.section]
            return sectionHeader
        }
        // generic UICollectionReusableView configuration
        return UICollectionReusableView()
    }
}

extension SchoolDetailsViewController: UICollectionViewDelegate {}

// cells' size configuration
extension SchoolDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0: // details cell size
            return CGSize(width: collectionView.bounds.width,
                          height: Constants.detailsCellHeight)
        case 1: // sat cell size
            return CGSize(width: collectionView.bounds.width,
                          height: Constants.satCellHeight)
        default:
            return CGSize(width: collectionView.bounds.width,
                          height: Constants.mapCellHeight)
        }
    }
}

extension SchoolDetailsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let localtion = locations.last else {
            print("Cannot get localtion!")
            return }
        print(localtion.coordinate.latitude)
        print(localtion.coordinate.longitude)
        
        NotificationCenter.default.post(name: NSNotification.Name("UserLocationAvailable"),
                                        object: localtion.coordinate)
    }
}

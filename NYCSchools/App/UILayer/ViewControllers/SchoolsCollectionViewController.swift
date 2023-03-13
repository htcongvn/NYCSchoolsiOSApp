//
//  ViewController.swift
//  NYCSchools
//
//  Created by Cong Huynh on 2023-02-17.
//

import UIKit
import Combine
import PureLayout
import MBProgressHUD

class SchoolsCollectionViewController: UIViewController {
    
    private let schoolsViewModel: SchoolsViewModel = SchoolsViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var collectionView: UICollectionView?
    private var loadingHUD: MBProgressHUD?
    private let refreshControl = UIRefreshControl()
    
    private struct Constants {
        static let cellIdentifier: String = "schoolCell"
        static let cellHeight: CGFloat = 100
        static let sectionHeaderIdentifier: String = "sectionHeader"
        static let sectionHeight: CGFloat = 50
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupBinders()
        setupLoadingHUD()
        retrieveSchoolData()
        setupRefreshControl()
        
        // localization
        title = "schools.list.nav.title".localized()
    }
    
    private func setupLoadingHUD() {
        guard let collectionView = collectionView else {
            return
        }
        loadingHUD = MBProgressHUD.showAdded(to: collectionView,
                                             animated: true)
        loadingHUD?.label.text = "loading.hud.title".localized()
        loadingHUD?.isUserInteractionEnabled = false
        loadingHUD?.detailsLabel.text = "loading.hud.subtitle".localized()
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "pull.to.refresh.title".localized())
        refreshControl.addTarget(self, action: #selector(refresh(anyObj:)), for: .valueChanged)
        collectionView?.addSubview(refreshControl)
    }
    
    @objc private func refresh(anyObj sender: AnyObject) {
        retrieveSchoolData()
        refreshControl.endRefreshing()
    }
    
    private func retrieveSchoolData() {
        removeStateView()
        loadingHUD?.show(animated: true)
        schoolsViewModel.getSchools()
        schoolsViewModel.getSchoolSATs()
    }
    
    private func setupCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: view.frame.size.width,
                                               height: Constants.cellHeight)
        collectionViewLayout.headerReferenceSize = CGSize(width: view.frame.size.width,
                                                          height: Constants.sectionHeight)
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: view.frame,
                                          collectionViewLayout: collectionViewLayout)
        
        guard let collectionView = collectionView else {
            return
        }
        
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges() // from PureLayout
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        
        // setup & customize flow support
        collectionView.register(SchoolCollectionViewCell.self,
                                forCellWithReuseIdentifier: Constants.cellIdentifier)
        
        collectionView.register(SchoolSectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: Constants.sectionHeaderIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupBinders() {
        // Subscribers which are listening to the Zip of publishers $schools and $schoolSATs.
        // When we use a custom publisher to announce that our object has changed, this must happen on the main thread.
        // We can use Combine to et up custom data flows and get the declarative data bindings between object’s
        // published properties (of SchoolsViewModel object) to the UI (SchoolsCollectionViewController) by subscribing
        // (using .sink) to any observable object’s publisher or custom publisher - the properties themselves - directly
        // via accessing the @Published property wrapper’s projected value (by prefixing its name with $
        // ($schools, $schoolSATs, $error),
        // and then update our UI accordingly like cancellable = viewModel.$schools.sink { newValueOfschools in {}} or
        // Publishers.Zip(schoolsViewModel.$schools,schoolsViewModel.$schoolSATs).sink { newValueOfpublishers in {} }
        //
        Publishers.Zip(schoolsViewModel.$schools,
                       schoolsViewModel.$schoolSATs)
            .receive(on: RunLoop.main) // ensure the data change announcement happens on the main thread
            .sink { [weak self] publishers in
                let schools = publishers.0
                let sats = publishers.1 // don't care
                
                guard let self = self,
                      let _ = schools else {
                    return
                }
                
                self.loadingHUD?.hide(animated: true)
                self.removeStateView()
                
                if self.schoolsViewModel.schools?.isEmpty == false { // sats can be nill
                    print("retrieved \(schools?.count ?? 0) schools, \(sats?.count ?? 0) sat results")
                    self.collectionView?.reloadData() // re-render the collectionView
                    
                    
                } else {
                    self.showEmptyState()
                }
            }
            .store(in: &cancellables)
        // We need to keep track of the cancellable object that Combine returns when we start our subscription using sink, since that subscription will only remain valid for as long as the returned AnyCancellable instance is retained.
        
        // Subscriber which is listening to publisher $error
        schoolsViewModel.$error
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let self = self else {
                    return
                }
                
                if let error = error {
                    self.loadingHUD?.hide(animated: true)
                    switch error {
                    case .networkingError(let errorMessage):
                        self.showErrorState(errorMessage)
                    }
                }
            }
            .store(in: &cancellables)
    }
}

/// Implementation of data source delegate for collection view to help with displaying schools
extension SchoolsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return schoolsViewModel.schoolSectionsList?[section].schools.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier,
                                                            for: indexPath) as? SchoolCollectionViewCell else {
            return UICollectionViewCell() // generic cell returned in case the specific cell as we defined canot be created
        }
        
        if let schoolSection = schoolsViewModel.schoolSectionsList?[indexPath.section] {
            let school = schoolSection.schools[indexPath.item]
            cell.populate(school)
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return schoolsViewModel.schoolSectionsList?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        // section header
        if kind == UICollectionView.elementKindSectionHeader,
           let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: Constants.sectionHeaderIdentifier,
                                                                               for: indexPath)
            as? SchoolSectionHeaderView {
            sectionHeader.headerLabel.text = schoolsViewModel.schoolSectionsList?[indexPath.section].city
            return sectionHeader
        }
        // generic UICollectionReusableView
        return UICollectionReusableView()
    }
}

extension SchoolsCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let school =
            schoolsViewModel.schoolSectionsList?[indexPath.section].schools[indexPath.item],
           let schoolSAT = schoolsViewModel.schoolSATDictionary[school.dbn] {
            let schoolDetailsVC = SchoolDetailsViewController()
            schoolDetailsVC.viewModel = SchoolDetailsViewModel(school: school,
                                                                           schoolSAT: schoolSAT)
//            present(schoolDetailsVC, animated: true)
            navigationController?.pushViewController(schoolDetailsVC,animated: true)
        }
    }
}

extension SchoolsCollectionViewController {
    func showErrorState(_ errorMessage: String) {
        let errorStateView = SchoolsListStateView(forAutoLayout: ())
        errorStateView.update(for: .error)
        collectionView?.backgroundView = errorStateView
    }
    
    func removeStateView() {
        collectionView?.backgroundView = nil
    }
    
    func showEmptyState() {
        let emptyStateView = SchoolsListStateView(forAutoLayout: ())
        emptyStateView.update(for: .empty)
        collectionView?.backgroundView = emptyStateView
    }
}

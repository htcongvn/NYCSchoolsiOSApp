//
//  ViewController.swift
//  NYCSchools
//
//  Created by Cong Huynh on 2023-02-17.
//

import UIKit

class ViewController: UIViewController {
    
    private let schoolsViewModel: SchoolsViewModel = SchoolsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        /*
         with MVC pattern we put too much business logic inside the view controller. MVVM design pattern solves this problem by
         seperating it into extra components
         <Data Layer: Models> <-------<UI Layer: ViewModels> ---> <Data Layer: Networking: <SchoolAPILogic protocol> <- - - <SchoolAPI implemetation>>
                             \          ^
                              \         |
         <UI Layer: Views> <--<UI Layer: View Controller>--> <UI Layer: Storyboards>
         */
        
        // There is async operation inside. How ViewController can know of that fact that when is ViewModel's completion.
        // We would use reactive frameworks that Apple highly recomends.
        // Or we tempirarily use callback @escaping closure
        // we user [weak self] because we want the closure not to strongly capture the values created like variables, instances
        // that can retain after the callback gets completed.
        schoolsViewModel.getSchools { [weak self] (schools, error) in
            if let error = error {
                let alert = UIAlertController(title: "Error",
                                              // this should be logged using framework like Firebase Crashlytics to avoid
                                              // such a lengthy overwhelming error message turns back to end user
                                              message: "Could not retrieve the schools: \(error.localizedDescription)",
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: "OK",
                                           style: .default)
                alert.addAction(action)
                self?.present(alert,
                              animated: true)
            }
            
            if let schools = schools {
                print("retrieved \(schools.count) schools")
            }
        }
        
    }


}


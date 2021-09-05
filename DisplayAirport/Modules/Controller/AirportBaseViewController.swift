//
//  ViewController.swift
//  DisplayAirport
//
//  Created by Balaji Chinnadurai on 4/9/21.
//

// Do any additional setup after loading the view.
//        let searchViewController = UISearchController()

import UIKit

class AirportDetailsViewController: UIViewController {
    var viewModel : AirportDetailsViewModel? = nil
    
    @IBOutlet weak var airportTableView: UITableView!
    @IBOutlet weak var airportSearchBar: UISearchBar!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        invokeRequest()
    }
    
    func setupView() {
        viewModel = AirportDetailsViewModel(view: self.view)
        self.airportTableView.separatorColor = .clear
    }
    
    func invokeRequest() {
        guard let airportViewModel = viewModel else {return}
        airportViewModel.isLoading(status: true)
        airportViewModel.getAirportDetails { result in
            airportViewModel.isLoading(status: false)
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.airportTableView.delegate = self
                    self.airportTableView.dataSource = self
                    self.airportTableView.reloadData()
                }
            case let .failure(errorModel):
                self.present(UIAlertController.showAlertWith(errorModel: errorModel),
                                           animated: true,
                                           completion: nil)
            }
        }
    }
}

extension AirportDetailsViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}


extension AirportDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let airportViewModel = viewModel else {return 1}
        return airportViewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let airportViewModel = viewModel else {return 1}
        return airportViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

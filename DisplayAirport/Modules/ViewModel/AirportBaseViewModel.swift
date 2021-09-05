//
//  AirportDetailsViewModel.swift
//  DisplayAirport
//
//  Created by Balaji Chinnadurai on 5/9/21.
//

import UIKit

class AirportDetailsViewModel : NSObject {
    lazy var response = [AirportDetailsModel]()
    var airportModel = [AirportModel]()
    var currentView:UIView
        
    init(view:UIView) {
        currentView = view
    }
        
    let title = "Airport Details"
    
    

//    func getCountryName(indexPath:IndexPath) -> String {
//        return getNumberOfSections()[indexPath.section]
//    }
//
//    func getAirportName(indexPath:IndexPath) -> String {
//        return getNumberOfRowsDetails(sectionName:getCountryName(indexPath:indexPath))[indexPath.row]
//    }
//
//    func getNumberOfRows(section:Int) -> Int {
//        return getNumberOfRowsDetails(sectionName: getNumberOfSections()[section]).count
//    }
    
    //    func getNumberOfRowsDetails(sectionName:String) ->[String] {
    //        var countryDetails = [String]()
    //        _ = response.map {
    //            guard let countryModel = $0.country, let countryName = countryModel.countryName, let airportName = $0.airportName else { return }
    //            if (countryName == sectionName) {
    //                countryDetails.append(airportName)
    //            }
    //        }
    //        return countryDetails.sorted()
    //    }

    private func getNumberOfCountry() -> [String] {
    var countrySet = Set<String>()
    _ = response.map {
        guard let countryModel = $0.country, let countryName = countryModel.countryName else {return}
            countrySet.insert(countryName)
        }
        return countrySet.sorted().map {$0}
    }
    
    func getNumberOfSections() -> Int {
        return  self.airportModel.count
    }
    
    func getAirportModel() {
        var airportModel = [AirportModel]()
        getNumberOfCountry().forEach { countryName in
            airportModel.append(AirportModel(countryName: countryName, detailsModel: createAirportModel(countryName: countryName)))
        }
        self.airportModel = airportModel
    }
    
    func getNumberOfRows(section:Int) -> Int {
        //let countryName = getAirportModel()[section].countryName
        
        return self.airportModel[section].detailsModel.count
        
//        let model = getAirportModel().filter({ $0.countryName == countryName})
//        return model.first?.detailsModel.count ?? 0
    }
    
    func getAirportName(indexPath:IndexPath) -> String {
        return self.airportModel[indexPath.section].detailsModel[indexPath.row].airportName ?? ""
        
        //return getNumberOfRowsDetails(sectionName:getCountryName(indexPath:indexPath))[indexPath.row]
    }

    
    private func createAirportModel(countryName:String) -> [AirportDetailsModel] {
        return response.filter { airportModel -> Bool in
            airportModel.country?.countryName == countryName
        }
    }
    
    func getTitleForHeaderInSection(section:Int) -> String {
        return self.airportModel[section].countryName
    }
    
    func getAirportDetails(completion: @escaping (Result<[AirportDetailsModel], ErrorModel>) -> Void) {
        let networkManager = NetworkManager()
                
        networkManager.getAirportDetails { [self] result in
            switch result {
            case let .success(result):
                self.response = result
                completion(.success(result))
            case .failure:
                completion(.failure(.downloadFailed))
            }
        }
    }
}

extension AirportDetailsViewModel {
    func isLoading(status: Bool) {
        status ? showCustomSpinner() : hideSpinner()
    }
    
    func hideSpinner() {
        let customSpinner = CustomSpinner()
        customSpinner.hideIndicator(spinnerView: self.currentView)
    }
    
    func showCustomSpinner() {
        let customSpinner = CustomSpinner()
        customSpinner.showIndicator(spinnerView:self.currentView, withTitle:"Loading ...")
    }
}

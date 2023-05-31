//
//  SearchCityVC.swift
//  Zodium
//
//  Created by tecH on 12/10/21.
//

import UIKit

protocol GetData{
    func getcity(data: String?)
}

class SearchCityVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var model = SignUpViewModelClass()
    var delegate: GetData?
    var name:String?
    var controllerNo: Int?
    var search = ""
    
    var searcCityhBody: [CitySeachBody]?
    var searchCountryBody: [CountrySearchBody]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model.delegate = self
        
        self.tableView.register(UINib.init(nibName:"SearchTableViewCell" , bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
      
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.backgroundColor = UIColor.clear

        txtSearch.delegate = self
        
        setUpUI()
    }
    
    func SearchCityAPI(){
        
        let otheruser = [Param.search : txtSearch.text!] as [String : Any]
        self.model.callSearchCityListApi(param: otheruser, onSucssesMsg:  CustomeAlertMsg.searchCityListFetched)
        
    }
    
    
    func SearchCountryAPI(){
        
        let otheruser = [Param.search : txtSearch.text!] as [String : Any]
        self.model.callSearchCountryListApi(param: otheruser, onSucssesMsg:  CustomeAlertMsg.searchCountryListFetched)
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        
        
        if controllerNo == 2 {
            
            if string.isEmpty
                {
                    search = String(search.dropLast())
                }
                else
                {
                    search=textField.text!+string
                }
            if search.count <= 3 {
                
                tableView.isHidden = true
            }else{
                tableView.isHidden = false
                self.searchCountryBody?.removeAll()
                SearchCityAPI()
                print("done")
            }
                return true
        }else if controllerNo == 1 {
            
            if string.isEmpty
                {
                    search = String(search.dropLast())
                }
                else
                {
                    search=textField.text!+string
                }
            if search.count <= 3 {
                
                tableView.isHidden = false
            }else{
                tableView.isHidden = false
                self.searcCityhBody?.removeAll()
                SearchCountryAPI()
                print("done")
            }
                return true
        }
        
        
        return true
        }
    
    
    
    func setUpUI(){
        
        if controllerNo == 2 {
            txtSearch.attributedPlaceholder = NSAttributedString(string: "Search City", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        }else if controllerNo == 1{
            txtSearch.attributedPlaceholder = NSAttributedString(string: "Search Country", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        }
        
    }
    
    
}
extension SearchCityVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if controllerNo == 2 {
            return searcCityhBody?.count ?? 0
        }else if controllerNo == 1 {
            return searchCountryBody?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.selectionStyle = .none
        
        if controllerNo == 2 {
            cell.lblName.text = searcCityhBody?[indexPath.row].city_name ?? ""
            return cell
        }else if controllerNo == 1 {
            cell.lblName.text = searchCountryBody?[indexPath.row].country_name ?? ""
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let del = delegate{
            self.dismiss(animated: true, completion: nil)
            
            if controllerNo == 2 {
                del.getcity(data: searcCityhBody?[indexPath.row].city_name ?? "")
            }else if controllerNo == 1 {
                del.getcity(data:searchCountryBody?[indexPath.row].country_name ?? "")
               
            }
            
            
           
        }
        
    }
}

extension SearchCityVC:ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
         if msg == CustomeAlertMsg.searchCityListFetched {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let encodedJson = try JSONDecoder().decode(CitySearchModelDataSave.self, from: jsondata)
                print(encodedJson)
            
                self.searcCityhBody = encodedJson.body ?? []
                
                tableView.reloadData()

            }catch {
            }
            
        }else if msg == CustomeAlertMsg.searchCountryListFetched {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let encodedJson = try JSONDecoder().decode(CountrySearchModelDataSave.self, from: jsondata)
                print(encodedJson)
            
                self.searchCountryBody = encodedJson.body ?? []
                
                tableView.reloadData()

            }catch {
            }
            
        }
        
    }
    
    func onFailure(msg: String) {
        print(msg)
        Alert.showSimple(msg)
    }
    
    
    
}

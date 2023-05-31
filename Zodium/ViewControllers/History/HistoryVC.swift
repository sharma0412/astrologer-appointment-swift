//
//  HistoryVC.swift
//  Zodium
//
//  Created by tecH on 30/11/21.
//

import UIKit

class HistoryVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var lblNoHistoryFound: UILabel!
    var model = HistoryViewModelClass()
    var historyData : [HistoryDataSave]?

    override func viewDidLoad() {
        super.viewDidLoad()

        noDataView.isHidden = true
        
        self.model.delegate = self
        
        self.tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        historyAPI()
    }
    
    
    func historyAPI(){
        let role = UserDefaults.standard.string(forKey: "role")
        let otheruser = [Param.role: role] as [String : Any]
        
        self.model.callHistoryApi(param: otheruser, onSucssesMsg:  CustomeAlertMsg.history)
        
    }

    @IBAction func btnClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension HistoryVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if historyData?.count == 0{
            noDataView.isHidden = false
        }else{
            noDataView.isHidden = true
        }
        
        return historyData?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        cell.selectionStyle = .none
        cell.lblName.text = historyData?[indexPath.row].user?.name ?? ""
        cell.lblMail.text = historyData?[indexPath.row].user?.email ?? ""
        cell.lblDate.text = historyData?[indexPath.row].user?.created_at?.convertUTCDateToLocal(format: "dd/mm/yyyy mm:ss") ?? ""
        let profileImage = historyData?[indexPath.row].user?.profile_image ?? ""
        if profileImage == "" {
            cell.userImageVIew.image = UIImage(named: "placeholder")
        }else{
            let url = URL(string: imageBaseUrl + profileImage)
            cell.userImageVIew.sd_setImage(with: url)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
extension HistoryVC:ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
        if  msg == CustomeAlertMsg.history {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response["body"], options: .prettyPrinted)
                let encodedJson = try JSONDecoder().decode(historyDataSave.self, from: jsondata)
                print(encodedJson)
                self.historyData = encodedJson
                
//                if historyData != nil{
//                    tableView.isHidden = true
//                    lblNoHistoryFound.isHidden = false
//                }else{
//                    tableView.isHidden = false
//                    lblNoHistoryFound.isHidden = true
//                }
                
                self.tableView.reloadData()

                
//                let url = URL(string:(imageBaseUrl + (encodedJson.profile_image ?? "")))
//                imgProfile.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "download"))
                
        
            }catch {
            }
            
        }

        }
 
    
    func onFailure(msg: String) {
        print(msg)
        Alert.showSimple(msg)
    }
    
    
}

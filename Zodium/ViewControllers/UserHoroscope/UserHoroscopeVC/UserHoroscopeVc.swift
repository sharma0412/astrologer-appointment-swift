//
//  UserHoroscopeVc.swift
//  Zodium
//
//  Created by tecH on 21/10/21.
//

import UIKit
import SDWebImage

class UserHoroscopeVc: UIViewController {

    let calendar = Calendar.current

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = MyHoroscopeViewModelClass()
    
    var horoScopeList:[HoroBody]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model.delegate = self
        
        self.collectionView.register(UINib(nibName: "UserHoroscopeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UserHoroscopeCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        horoscopeAPI()
    }
    
    func horoscopeAPI(){
       
        self.model.horoscopeListdApi(onSucssesMsg:  CustomeAlertMsg.horoscopeFetched)
        
    }
    
    
    @IBAction func btnClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
   
}

extension UserHoroscopeVc : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return horoScopeList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserHoroscopeCollectionViewCell", for: indexPath) as! UserHoroscopeCollectionViewCell
        cell.lblHoroName.text = horoScopeList?[indexPath.row].h_name ?? ""
        
        let url = URL(string:(imageBaseUrl + (horoScopeList?[indexPath.row].h_image ?? "")))
        cell.imgHoro.sd_setImage(with: url , placeholderImage:#imageLiteral(resourceName: "Profile"))
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/4, height: 120)
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserHoroscopeFullDetails") as! UserHoroscopeFullDetails
     
        vc.yourSign = horoScopeList?[indexPath.row].h_name ?? ""
        vc.Udescription = horoScopeList?[indexPath.row].h_description ?? ""
        vc.Udate = horoScopeList?[indexPath.row].created_at ?? ""
        
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension UserHoroscopeVc:ResponseProtocol{
    func onSucsses(msg: String, response: [String : Any]) {
        if  msg == CustomeAlertMsg.horoscopeFetched {
            do {
                let jsondata = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let encodedJson = try JSONDecoder().decode(horoDataSave.self, from: jsondata)
                print(encodedJson)

                self.horoScopeList = encodedJson.body
                
                collectionView.reloadData()
                
            }catch {
            }
            
        }
        
    }
    
    func onFailure(msg: String) {
        print(msg)
        Alert.showSimple(msg)
    }
    
    
    
}


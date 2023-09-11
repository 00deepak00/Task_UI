//
//  ViewControllerExtension.swift
//  Task_UI
//
//  Created by Newmac on 08/09/23.
//

import Foundation
import UIKit

//MARK:- Extension for TableViewDelegate delegate And UITableViewDataSource
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PlayCardTableView.dequeueReusableCell(withIdentifier: "PlayListCell") as! PlayListCell
        cell.selectionStyle  = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsVC")
        self.present(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewHeight = tableView.bounds.size.height
        return viewHeight - 150
    }
    
}

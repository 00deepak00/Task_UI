//
//  DetailsVCExtension.swift
//  Task_UI
//
//  Created by Newmac on 08/09/23.
//

import Foundation
import UIKit
//MARK:- Extension for UICollectionViewDelegate delegate And UICollectionViewDataSource
extension DetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardCollectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCVCell", for: indexPath) as! DetailsCVCell
        return cell
    }
}


//
//  ViewController.swift
//  Task_UI
//
//  Created by Newmac on 08/09/23.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var PlayCardTableView: UITableView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
      
}
// MARK: - Private Methods
extension ViewController{
    private func setupUI() {
        // Call any setup methods or configure UI elements here
    }
}

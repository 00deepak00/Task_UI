//
//  DetailsVC.swift
//  Task_UI
//
//  Created by Newmac on 08/09/23.
//

import UIKit
import WillBottomSheet

class DetailsVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var viewBG_BottomButton: NeumorphicView!
    @IBOutlet weak var viewBG_PlayBottomButton: NeumorphicView!
    @IBOutlet weak var btn_Download: UIButton!
    @IBOutlet weak var btn_CrossBottom: UIButton!
    @IBOutlet weak var width_btnCrossBottom: NSLayoutConstraint!
    @IBOutlet weak var viewBG_BottomSheet: UIView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

// MARK: - Private Methods
extension DetailsVC{
    private func setupUI() {
        setupCollectionViewLayout(collectionView: cardCollectionView)
        hideCrossButton()
        hidePlayButton()
    }
    
    private func hideCrossButton() {
        btn_CrossBottom.isHidden = true
        width_btnCrossBottom.constant = 0
    }
    private func hidePlayButton() {
        viewBG_PlayBottomButton.isHidden = true
    }
    
    
    private func handleDownloadButtonAction() {
        // Animate the appearance of the checkmark and fill half of the bottom button with green color
        UIView.animate(withDuration: 0.5, animations: {
            self.btn_CrossBottom.isHidden = false
            self.width_btnCrossBottom.constant = 40
            self.view.layoutIfNeeded()
        }) { _ in
            self.btn_CrossBottom.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            let width = self.viewBG_BottomButton.bounds.size.width
            self.fillHalfWidthInView(
                view: self.viewBG_BottomButton,
                withColor: .systemGreen,
                duration: 1.0,
                width: width
            ) {
                self.appearPlayButton()
            }
        }
    }
    
    private func appearPlayButton() {
        // Hide the cross button, show the play button, and animate its appearance from the bottom
        hideCrossButton()
        viewBG_PlayBottomButton.isHidden = false
        viewBG_BottomButton.isHidden = true
        viewBG_PlayBottomButton.frame.origin.y = UIScreen.main.bounds.maxY
        let finalYPosition = UIScreen.main.bounds.maxY - 100
        
        // Animate the play button to appear from the bottom
        UIView.animate(withDuration: 0.8) {
            self.viewBG_PlayBottomButton.frame.origin.y = finalYPosition
        }
        
        // Blink the play button
        blinkView(viewBG_PlayBottomButton, withColor: .systemBlue, duration: 0.1, repeatCount: 0.5)
    }
    
    private func fillHalfWidthInView(view: UIView, withColor color: UIColor, duration: TimeInterval, width: CGFloat, completion: (() -> Void)? = nil) {
        let halfWidth = width
        let coloredView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: view.frame.size.height))
        coloredView.backgroundColor = color
        view.addSubview(coloredView)
        UIView.animate(withDuration: duration, animations: {
            coloredView.frame.size.width = halfWidth
        }) { _ in
            coloredView.removeFromSuperview()
            completion?()
        }
    }
    
    private func blinkView(_ view: UIView, withColor color: UIColor, duration: TimeInterval, repeatCount: Float) {
        let originalColor = view.backgroundColor
        view.backgroundColor = color
        
        UIView.animate(withDuration: duration, delay: 0, options: [.repeat, .autoreverse], animations: {
            view.backgroundColor = originalColor
        }, completion: nil)
    }
    
    private func setupCollectionViewLayout(collectionView: UICollectionView) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let width = collectionView.bounds.size.width / 1.3
        let height = collectionView.bounds.size.height
        layout.itemSize = CGSize(width: width, height: height)
        collectionView.collectionViewLayout = layout
    }
    
    private func openBottomSheetView(){
        let controller = BottomsheetController()
        controller.viewActionType = .tappedDismiss
        controller.overlayBackgroundColor = UIColor.black.withAlphaComponent(0.6)
        controller.addContentsView(self.viewBG_BottomSheet)
        DispatchQueue.main.async {
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    
}
// MARK: - Button Actions
extension DetailsVC{
    @IBAction func btn_ActionDismiss(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func btn_ActionDownload(_ sender: UIButton) {
        handleDownloadButtonAction()
    }
    
    @IBAction func btn_Action_CrossBottom(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func btn_Action_PlayBottom(_ sender: UIButton) {
        // Handle play button action
        self.openBottomSheetView()
    }
}

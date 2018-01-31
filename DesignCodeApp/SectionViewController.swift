//
//  SectionViewController.swift
//  DesignCodeApp
//
//  Created by Meng To on 12/11/17.
//  Copyright © 2017 Meng To. All rights reserved.
//

import UIKit

class SectionViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
	@IBOutlet weak var scrollView: UIScrollView!
	var section: [String: String]!
    var sections: [[String: String]]!
    var indexPath: IndexPath!
	@IBOutlet weak var subHeadVisualEffectView: UIVisualEffectView!
	@IBOutlet weak var closeVisualEffectView: UIVisualEffectView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = section["title"]
        captionLabel.text = section["caption"]
        bodyLabel.text = section["body"]
        coverImageView.image = UIImage(named: section["image"]!)
        progressLabel.text = "\(indexPath.row+1) / \(sections.count)"
    }
	@IBAction func closeButtonTapped(_ sender: UIButton) {
		dismiss(animated: true)
	}
	
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

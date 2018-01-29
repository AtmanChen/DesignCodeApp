//
//  SectionViewController.swift
//  DesignCodeApp
//
//  Created by Meng To on 12/11/17.
//  Copyright © 2017 Meng To. All rights reserved.
//

import UIKit

class SectionViewController: UIViewController {

    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var section: [String: String]!
    var sections: [[String: String]]!
    var indexPath: IndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        captionLabel.text = section["caption"]
        titleLabel.text = section["title"]
        coverImageView.image = UIImage(named: section["image"]!)
        bodyLabel.text = section["body"]
        progressLabel.text = "\(indexPath.row + 1) / \(sections.count)"
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var closeButtonTapped: UIButton!
}

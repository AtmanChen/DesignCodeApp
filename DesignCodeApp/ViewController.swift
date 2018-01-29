//
//  ViewController.swift
//  DesignCodeApp
//
//  Created by Meng To on 11/14/17.
//  Copyright © 2017 Meng To. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var playVisualEffectView: UIVisualEffectView!
    var isStatusBarHidden = false
	@IBOutlet weak var chapterCollectionView: UICollectionView!
	@IBOutlet weak var heroView: UIView!
	@IBOutlet weak var chapterView: UIView!
	@IBOutlet weak var bookView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBAction func playButtonTapped(_ sender: Any) {
        let urlString = "https://player.vimeo.com/external/235468301.hd.mp4?s=e852004d6a46ce569fcf6ef02a7d291ea581358e&profile_id=175"
        let url = URL(string: urlString)
        let player = AVPlayer(url: url!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		scrollView.delegate = self
        titleLabel.alpha = 0
        deviceImageView.alpha = 0
        playVisualEffectView.alpha = 0
		chapterCollectionView.delegate = self
		chapterCollectionView.dataSource = self
        UIView.animate(withDuration: 1) {
            self.titleLabel.alpha = 1
            self.deviceImageView.alpha = 1
            self.playVisualEffectView.alpha = 1
        }
        addBlurStatusBar()
        setStatusBarBackgroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        isStatusBarHidden = false
        UIView.animate(withDuration: 0.5) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToSection" {
            let toViewController = segue.destination as! SectionViewController
            let indexPath = sender as! IndexPath
            let section = sections[indexPath.row]
            toViewController.section = section
            toViewController.indexPath = indexPath
            toViewController.sections = sections
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.5) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    func addBlurStatusBar() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let blur = UIBlurEffect(style: .dark)
        let blurStatusBar = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: statusBarHeight))
        blurStatusBar.effect = blur
        view.addSubview(blurStatusBar)
    }
    
    func setStatusBarBackgroundColor(_ color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {
            return
        }
        statusBar.backgroundColor = color
    }
    
	fileprivate func animateCell(cellFrame: CGRect) -> CATransform3D {
		let angleFromX = Double((-cellFrame.origin.x) / 10)
		let angle = CGFloat((angleFromX * Double.pi) / 180)
		var transform = CATransform3DIdentity
		transform.m34 = -1.0/1000
		let rotation = CATransform3DRotate(transform, angle, 0, 1, 0)
		var scaleFromX = (1000 - (cellFrame.origin.x - 200)) / 1000
		let scaleMax: CGFloat = 1.0
		let scaleMin: CGFloat = 0.0
		if scaleFromX > scaleMax {
			scaleFromX = scaleMax
		}
		if scaleFromX < scaleMin {
			scaleFromX = scaleMin
		}
		let scale = CATransform3DScale(CATransform3DIdentity, scaleFromX, scaleFromX, 1)
		return CATransform3DConcat(rotation, scale)
	}
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return sections.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath) as! SectionCollectionViewCell
		let section = sections[indexPath.item]
		cell.titleLabel.text = section["title"]
		cell.descriptionLabel.text = section["caption"]
		cell.backgroundImageView.image = UIImage(named: section["image"]!)
		cell.layer.transform = animateCell(cellFrame: cell.frame)
		return cell
	}
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "HomeToSection", sender: indexPath)
    }
}

extension ViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offsetY = scrollView.contentOffset.y
		if offsetY < 0 {
			heroView.transform = CGAffineTransform(translationX: 0, y: offsetY)
			playVisualEffectView.transform = CGAffineTransform(translationX: 0, y: -offsetY/3)
			titleLabel.transform = CGAffineTransform(translationX: 0, y: -offsetY/3)
			deviceImageView.transform = CGAffineTransform(translationX: 0, y: -offsetY/4)
			backgroundImageView.transform = CGAffineTransform(translationX: 0, y: -offsetY/5)
		}
		if let collectionView = scrollView as? UICollectionView {
			for cell in collectionView.visibleCells as! [SectionCollectionViewCell] {
				let indexPath = chapterCollectionView.indexPath(for: cell)!
				let attributes = collectionView.layoutAttributesForItem(at: indexPath)!
				let frame = collectionView.convert(attributes.frame, to: view)
				let translationX = frame.origin.x / 5
				cell.backgroundImageView.transform = CGAffineTransform(translationX: translationX, y: 0)
				cell.layer.transform = animateCell(cellFrame: frame)
			}
		}
	}
	
	
}

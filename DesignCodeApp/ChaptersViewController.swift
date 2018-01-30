//
//  ChaptersViewController.swift
//  DesignCodeApp
//
//  Created by Huangyongle on 2018/1/30.
//  Copyright © 2018年 Meng To. All rights reserved.
//

import UIKit

class ChaptersViewController: UIViewController {

	@IBOutlet weak var chapter1CollectionView: UICollectionView!
	override func viewDidLoad() {
        super.viewDidLoad()
		chapter1CollectionView.delegate = self
		chapter1CollectionView.dataSource = self
    }
	
	fileprivate func animateCell(cellFrame: CGRect) -> CATransform3D {
		let angleFromX = Double((-cellFrame.origin.x) / 10)
		let angle = CGFloat((angleFromX * Double.pi) / 180)
		var transform = CATransform3DIdentity
		transform.m34 = -1.0/1000
		let rotation = CATransform3DRotate(transform, angle, 0, 1, 0)
		var scaleFromX = (1000 - (cellFrame.origin.x - 200)) / 1000
		let scaleMax: CGFloat = 1.0
		let scaleMin: CGFloat = 0.6
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

extension ChaptersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
}

extension ChaptersViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
//		if offsetY < 0 {
//			heroView.transform = CGAffineTransform(translationX: 0, y: offsetY)
//			playVisualEffectView.transform = CGAffineTransform(translationX: 0, y: -offsetY/3)
//			titleLabel.transform = CGAffineTransform(translationX: 0, y: -offsetY/3)
//			deviceImageView.transform = CGAffineTransform(translationX: 0, y: -offsetY/4)
//			backgroundImageView.transform = CGAffineTransform(translationX: 0, y: -offsetY/5)
//		}
		if let collectionView = scrollView as? UICollectionView {
			for cell in collectionView.visibleCells as! [SectionCollectionViewCell] {
				let indexPath = chapter1CollectionView.indexPath(for: cell)!
				let attributes = collectionView.layoutAttributesForItem(at: indexPath)!
				let frame = collectionView.convert(attributes.frame, to: view)
				let translationX = frame.origin.x / 5
				cell.backgroundImageView.transform = CGAffineTransform(translationX: translationX, y: 0)
				cell.layer.transform = animateCell(cellFrame: frame)
			}
		}
	}
}

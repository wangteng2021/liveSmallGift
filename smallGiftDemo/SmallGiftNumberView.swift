//
//  SmallGiftNumberView.swift
//  smallGiftDemo
//
//  Created by 王腾 on 2025/3/10.
//

import UIKit
protocol SmallGiftNumberViewProtocol {
    func scrollEnd()
}

class SmallGiftNumberView: UIView {
    
    var delegate:SmallGiftNumberViewProtocol?
    var isScrollEnd = true
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var imageArray = ["s_0","s_1","s_2","s_3","s_4","s_5","s_6","s_7","s_8","s_9"]
    var numbers:Int? {
        didSet {
            for index in 0 ..< ((numbers ?? 0) + 1) {
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .vertical
                layout.itemSize = CGSize(width: 15, height: 18)
                let view = UICollectionView(frame: CGRect(x: CGFloat(index) * 15, y: 0, width: 15, height: 18),collectionViewLayout: layout)
                view.dataSource = self
                view.delegate = self
                view.register(SmallGiftNumberCCell.self, forCellWithReuseIdentifier: "SmallGiftNumberCCell")
                view.tag = 1000 + index
                view.isHidden = true
                view.reloadData()
                addSubview(view)
            }
        }
    }
    
    var destinationNumber:Int64? {
        
        didSet {
            if isScrollEnd == false {
                return
            }
            scroll()
        }
    }
    
    private func scroll() {
        isScrollEnd = false
        let numberStr = "\(destinationNumber ?? 0)"
        
        let singleDigits = numberStr.map { String($0) }
        
        if singleDigits.count > numbers ?? 0 {
            numbers = singleDigits.count
        }
        /// 支持几位数字
        switch singleDigits.count {
        case 1:
            if let pagerView = viewWithTag(1000) as? UICollectionView {
                pagerView.isHidden = false
            }
            if let pagerView = viewWithTag(1001) as? UICollectionView {
                pagerView.isHidden = false
                pagerView.scrollToItem(at: IndexPath(item: Int(destinationNumber ?? 0), section: 0), at: .bottom, animated: true)
            }
            break
        case 2,3,4:
            if let pagerView = viewWithTag(1000) as? UICollectionView {
                pagerView.isHidden = false
            }
            for index in 0 ..< singleDigits.count {
                let valueStr = singleDigits[index]
                let value = Int(valueStr) ?? 0
                if let pagerView = viewWithTag(1000 + index + 1) as? UICollectionView {
                    pagerView.isHidden = false
                    pagerView.scrollToItem(at: IndexPath(item: Int(value), section: 0), at: .bottom, animated: true)
                }
            }
            break
        default:
            break
        }
        startScaleAnimation()
    }
    
    func startScaleAnimation() {
        
        transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(stopNumberAnimation), object: nil)
        perform(#selector(stopNumberAnimation), with: nil, afterDelay: 0.1)
    }
    @objc func stopNumberAnimation() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        } completion: { _ in
            
        }
    }
    
}
extension SmallGiftNumberView:UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1000 {
            return 1
        }
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmallGiftNumberCCell", for: indexPath) as? SmallGiftNumberCCell
        if collectionView.tag == 1000 {
            cell?.imageName = "s_X"
        } else {
            cell?.imageName = imageArray[indexPath.item]
        }
        return cell ?? SmallGiftNumberCCell()
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isScrollEnd = true
        }
        
    }
}


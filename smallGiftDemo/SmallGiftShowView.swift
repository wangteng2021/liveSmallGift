//
//  SmallGiftShowView.swift
//  smallGiftDemo
//
//  Created by 王腾 on 2025/3/10.
//

import UIKit

class SmallGiftShowView: UIView {
    
    lazy var showViews: [SmallGiftView] = {
        var array = [SmallGiftView]()
        return array
    }()
    
    lazy var viewLocations: [Int] = {
        var array = [Int]()
        return array
    }()
    func add(model:SmallGiftModel) {
        
        var oldGiftSmallView:SmallGiftView?
        let toList = model.toList ?? []
        var hasOld = false
        if subviews.count <= 0 {
            hasOld = false
        }
        for oldView in subviews {
            if oldView is SmallGiftView {
                let oldGiftView = oldView as? SmallGiftView
                if oldGiftView?.model?.id == model.id {
                    hasOld = true
                    oldGiftSmallView = oldGiftView
                }
            }
        }
        for view in showViews.reversed() {
            let isEqual = areArraysEqual(view.model?.toList ?? [], toList) { $0.id == $1.id}
            if view.model?.id == model.id && isEqual {
                oldGiftSmallView = view
                hasOld = true
                print("是同一个人再送")
            } else {
                
                hasOld = false
            }
            
        }
        if hasOld == false {
            let giftView = SmallGiftView(frame: CGRect(x: -screenW(), y: 70, width: screenW(), height: 50))
            giftView.tag = -1
            giftView.isHidden = true
            giftView.handle = {[weak self] in
                if giftView.tag == -1 {
                    if self?.getMinLocation() == 0 {
                        self?.viewLocations.removeAll(where: {$0 == 1})
                    } else {
                        self?.viewLocations.removeAll(where: {$0 == 0})
                    }
                }
                self?.showViews.removeAll(where: {$0 == giftView})
                self?.viewLocations.removeAll(where: {giftView.tag == $0})
                giftView.removeFromSuperview()
                print("占用位置\(self?.viewLocations ?? [])----\(giftView.tag)")
                if let cacheView = self?.showViews.first,let cacheModel = cacheView.model {
                    if self?.hasLocation() == true {
                        cacheView.tag = self?.getMinLocation() ?? 0
                        cacheView.isHidden = false
                        cacheView.snp.remakeConstraints { make in
                            make.trailing.equalTo((self?.snp.leading)!).offset(-20)
                            make.top.equalTo(self!).offset(70 * CGFloat((cacheView.tag)))
                        }
                        
                        
                        if self?.viewLocations.contains(cacheView.tag) == false {
                            self?.viewLocations.append(cacheView.tag)
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self?.showViews.removeAll(where: {$0 == cacheView})
                        self?.showSmallAnimation(view: cacheView, model: cacheModel)
                    }
                }
            }
            giftView.model = model
            
            addSubview(giftView)
            if hasLocation() {
                giftView.isHidden = false
                giftView.tag = getMinLocation()
                print("最小的位置\(giftView.tag)")
                giftView.snp.remakeConstraints { make in
                    make.trailing.equalTo(self.snp.leading).offset(-20)
                    make.top.equalTo(self).offset(70 * CGFloat(giftView.tag))
                }
                layoutIfNeeded()
                if !viewLocations.contains(giftView.tag) {
                    viewLocations.append(giftView.tag)
                }
                showSmallAnimation(view: giftView,model: model)
            } else {
                showViews.append(giftView)
            }
            print("占用位置礼物数量-\(showViews.count)")
        } else {
            oldGiftSmallView?.isHidden = false
            oldGiftSmallView?.model = model
            oldGiftSmallView?.startNumberAnimation()
            oldGiftSmallView?.begainShow()
            if oldGiftSmallView?.tag == -1 && hasLocation() {
                oldGiftSmallView?.tag = getMinLocation()
                
                if !viewLocations.contains(oldGiftSmallView?.tag ?? 0) {
                    viewLocations.append(oldGiftSmallView?.tag ?? 0)
                }
                oldGiftSmallView?.snp.remakeConstraints { make in
                    make.trailing.equalTo(self.snp.leading).offset(-20)
                    make.top.equalTo(self).offset(53 * CGFloat(oldGiftSmallView?.tag ?? 0))
                }
                showSmallAnimation(view: oldGiftSmallView!, model: model)
            }
        }
    }
    
    
    func showSmallAnimation(view:SmallGiftView,model:SmallGiftModel) {

        if view.tag < 0 {
            return
        }
        // 找出缺失的数字
        DispatchQueue.main.async {
            let min = view.tag
            if view.superview == nil {
                self.addSubview(view)
            }
            if min == 0 {
                view.begainShow()
                UIView.animate(withDuration: 0.25) {
                    view.snp.remakeConstraints { make in
                        make.leading.top.equalTo(self)
                        make.height.equalTo(50)
                    }
                    self.layoutIfNeeded()
                } completion: { _ in

                }
                
                
            } else if min == 1 {
                view.begainShow()
                UIView.animate(withDuration: 0.25) {
                    view.snp.remakeConstraints { make in
                        make.leading.equalTo(self)
                        make.top.equalTo(self).offset(70)
                        make.height.equalTo(50)
                    }
                    self.layoutIfNeeded()
                } completion: { _ in

                }
                
            }
        }
        
        
    }
    
    func hasLocation() -> Bool {
        
        
        return getMinLocation() >= 0
    }
    
    func getMinLocation() -> Int {
        // 创建一个包含所有可能数字的集合
        let allNumbers: Set = [0, 1]

        // 将数组转换为集合
        let numberSet = Set(viewLocations)
        // 找出缺失的数字
        let missingNumbers = allNumbers.subtracting(numberSet)
        if numberSet.count == allNumbers.count {
            
            return -1
        }
        return missingNumbers.min() ?? -1
    }
    
    func areArraysEqual<T>(_ a: [T], _ b: [T], compare: (T, T) -> Bool) -> Bool {
        guard a.count == b.count else { return false }
        for (i, element) in a.enumerated() {
            if !compare(element, b[i]) {
                return false
            }
        }
        return true
    }
}

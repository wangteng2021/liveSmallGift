//
//  SmallGiftView.swift
//  smallGiftDemo
//
//  Created by 王腾 on 2025/3/10.
//

import UIKit

class SmallGiftView: UIView {
    
    let bgWidth = 195.0
    typealias IMESmallGiftViewDismissHandle = (()->Void)
    var handle:IMESmallGiftViewDismissHandle?
    lazy var allInfoView: UIView = {
        var view = UIView()
        return view
    }()
    lazy var bgView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 40 / 2.0
        view.layer.masksToBounds = true
        
        //        view.size = CGSize(width: bgWidth, height: 40)
        //        view.ime_gradientColors(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), [UIColor.IME_hexColorAlpha(hex: "#0C0719", alpha: 0.8).cgColor,UIColor.IME_hexColorAlpha(hex: "#0C0719", alpha: 0.2).cgColor], [0,1])
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var sendUserImageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
    lazy var giftImageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
    lazy var sendNameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor.red
        label.text = ""
        return label
    }()
    
    lazy var rewardLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var numberView: SmallGiftNumberView = {
        var view = SmallGiftNumberView()
        view.numbers = 4
        view.isHidden = true
        return view
    }()
    
    lazy var timesView: UIView = {
        var view = UIView()
        view.isHidden = true
        return view
    }()
    
    lazy var timesImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "lucky_times_ward")
        return imageView
    }()
    
    lazy var lightImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "lucky_times_light")
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(allInfoView)
        allInfoView.snp.remakeConstraints { make in
            make.edges.equalTo(self)
            make.width.equalTo(screenW())
            make.height.equalTo(40)
        }
        allInfoView.addSubview(bgView)
        bgView.snp.remakeConstraints { make in
            make.bottom.equalTo(self)
            make.leading.equalTo(self).offset(10)
            make.width.equalTo(bgWidth)
            make.height.equalTo(40)
        }
        
        allInfoView.addSubview(sendUserImageView)
        sendUserImageView.snp.remakeConstraints { make in
            make.leading.equalTo(bgView).offset(3)
            make.width.height.equalTo(34)
            make.centerY.equalTo(bgView)
        }
        allInfoView.addSubview(sendNameLabel)
        sendNameLabel.snp.remakeConstraints { make in
            make.leading.equalTo(sendUserImageView.snp.trailing).offset(10)
            make.top.equalTo(sendUserImageView)
        }
        
        allInfoView.addSubview(rewardLabel)
        rewardLabel.snp.remakeConstraints { make in
            make.leading.equalTo(sendNameLabel)
            make.width.equalTo(100)
            make.bottom.equalTo(sendUserImageView)
        }
        allInfoView.addSubview(giftImageView)
        giftImageView.snp.remakeConstraints { make in
            make.trailing.equalTo(bgView).offset(-3)
            make.bottom.equalTo(sendUserImageView)
            make.width.height.equalTo(34)
        }
        allInfoView.addSubview(numberView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var model:SmallGiftModel? {
        
        didSet {
            sendUserImageView.image = UIImage(named: model?.avatar ?? "")
            
            sendNameLabel.text = model?.name
            rewardLabel.text = "送给" + (model?.toName ?? "")
            
            numberView.destinationNumber = model?.giftCount
            numberView.isHidden = false
            let numberCount = "\(model?.giftCount ?? 0)"
            numberView.snp.remakeConstraints { make in
                make.leading.equalTo(bgView.snp.trailing).offset(5)
                make.centerY.equalTo(bgView)
                make.width.equalTo(CGFloat(numberCount.count) * 15)
                make.height.equalTo(18)
            }
            
        }
    }
    func begainShow() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(giftViewTimer), object: nil)
        
        perform(#selector(giftViewTimer),with: nil, afterDelay: 3.0)
    }
    @objc func startNumberAnimation() {
        numberView.isHidden = false
    }
    @objc func stopNumberAnimation() {
        //        UIView.animate(withDuration: 0.1) {
        //            self.numberView.transform = .identity
        //        } completion: { _ in
        //
        //        }
    }
    
    @objc func giftViewTimer() {
        if handle != nil {
            handle?()
        }
    }
}

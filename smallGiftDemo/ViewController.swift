//
//  ViewController.swift
//  smallGiftDemo
//
//  Created by 王腾 on 2025/3/10.
//

import UIKit

class ViewController: UIViewController {

    var count:Int64 = 0
    lazy var giftShowView: SmallGiftShowView = {
        var view = SmallGiftShowView(frame: CGRect(x: 0, y: 100, width: 270, height: 110))
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(giftShowView)
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        count += 1
        let model = SmallGiftModel()
        model.id = Int64(arc4random() % 5)
        model.name = "张三"
        model.toName = "李四"
        model.avatar = "\(arc4random() % 2)"
        model.giftCount = count
        let userModel = SmallGiftToListModel()
        userModel.id = Int64(arc4random() % 5)
        model.toList = [userModel]
        giftShowView.add(model: model)
    }


}


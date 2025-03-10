//
//  SmallGiftModel.swift
//  smallGiftDemo
//
//  Created by 王腾 on 2025/3/10.
//

import UIKit

class SmallGiftModel: NSObject {

    var avatar = ""
    var name = ""
    var toName = ""
    var giftCount:Int64 = 0
    var id:Int64 = 0
    var toList:[SmallGiftToListModel]?
}
class SmallGiftToListModel: NSObject{
    var id:Int64 = 0
}

//
//  MainVM.swift
//  ExampleAVPlayer
//
//  Created by 황재현 on 4/18/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa



/// 뷰모델
class MainVM: NSObject {
    var buttonName = BehaviorSubject<String>(value: "정지")
}

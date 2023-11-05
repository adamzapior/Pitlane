//
//  AdaptiveLayoutHelper.swift
//  Pitlane
//
//  Created by Adam Zapiór on 05/11/2023.
//

/// If the width is greater than the height, you should choose HResized, respectively if the height is greater than the width, you should choose VResized. If the width and the height are equal, you should choose HResized.
//  https://rodionartyukhin.medium.com/adaptive-layout-programmatically-in-swift-4c900324b9ca
//  https://rodionartyukhin.medium.com/adaptive-layout-for-ios-in-swift-20842307116f

import UIKit

enum Dimension {
    case width
    case height
}

enum Device {
    case iPhone5S
    case iPhone8
    case iPhone8Plus
    case iPhone11Pro
    case iPhone11ProMax
    case iPhone12
    case iPhone12ProMax
    case iPhone15
    
    static let baseScreenSize: Device = .iPhone8
}

extension Device: RawRepresentable {
    typealias RawValue = CGSize
    
    init?(rawValue: CGSize) {
        switch rawValue {
        case CGSize(width: 320, height: 568):
            self = .iPhone5S
        case CGSize(width: 375, height: 667):
            self = .iPhone8
        case CGSize(width: 414, height: 736):
            self = .iPhone8Plus
        case CGSize(width: 375, height: 812):
            self = .iPhone11Pro
        case CGSize(width: 414, height: 896):
            self = .iPhone11ProMax
        case CGSize(width: 390, height: 844):
            self = .iPhone12
        case CGSize(width: 428, height: 926):
            self = .iPhone12ProMax
        case CGSize(width: 393, height: 852):
            self = .iPhone15
        default:
            return nil
        }
    }
    
    var rawValue: CGSize {
        switch self {
        case .iPhone5S:
            return CGSize(width: 320, height: 568)
        case .iPhone8:
            return CGSize(width: 375, height: 667)
        case .iPhone8Plus:
            return CGSize(width: 414, height: 736)
        case .iPhone11Pro:
            return CGSize(width: 375, height: 812)
        case .iPhone11ProMax:
            return CGSize(width: 414, height: 896)
        case .iPhone12:
            return CGSize(width: 390, height: 844)
        case .iPhone12ProMax:
            return CGSize(width: 428, height: 926)
        case .iPhone15:
            return CGSize(width: 393, height: 852)
        }
    }
}



func adapted(dimensionSize: CGFloat, to dimension: Dimension) -> CGFloat {
    let screenWidth  = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var ratio: CGFloat = 0.0
    var resultDimensionSize: CGFloat = 0.0
    
    switch dimension {
    case .width:
        ratio = dimensionSize / Device.baseScreenSize.rawValue.width
        resultDimensionSize = screenWidth * ratio
    case .height:
        ratio = dimensionSize / Device.baseScreenSize.rawValue.height
        resultDimensionSize = screenHeight * ratio
    }
    
    return resultDimensionSize
}

func resized(size: CGSize, basedOn dimension: Dimension) -> CGSize {
    let screenWidth  = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var ratio:  CGFloat = 0.0
    var width:  CGFloat = 0.0
    var height: CGFloat = 0.0
    
    switch dimension {
    case .width:
        ratio  = size.height / size.width
        width  = screenWidth * (size.width / Device.baseScreenSize.rawValue.width)
        height = width * ratio
    case .height:
        ratio  = size.width / size.height
        height = screenHeight * (size.height / Device.baseScreenSize.rawValue.height)
        width  = height * ratio
    }
    
    return CGSize(width: width, height: height)
}


extension Int {
    var VAdapted: CGFloat {
        adapted(dimensionSize: CGFloat(self), to: .height)
    }
    
    var HAdapted: CGFloat {
        adapted(dimensionSize: CGFloat(self), to: .width)
    }
}

extension Array where Element == Int {
    var VResized: CGSize {
        guard self.count == 2 else { fatalError("You have to specify 2 values: [width, height]") }
        return resized(size: CGSize(width: self[0], height: self[1]), basedOn: .height)
    }
    
    var HResized: CGSize {
        guard self.count == 2 else { fatalError("You have to specify 2 values: [width, height]") }
        return resized(size: CGSize(width: self[0], height: self[1]), basedOn: .width)
    }
}

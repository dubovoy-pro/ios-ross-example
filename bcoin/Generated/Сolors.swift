// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen


// MARK: - Color catalogs
import UIKit

internal extension UIColor {

  static let baseBlack = UIColor.color(named: "baseBlack")
  static let baseGray = UIColor.color(named: "baseGray")
  static let baseWhite = UIColor.color(named: "baseWhite")
  static let separator = UIColor.color(named: "separator")
  static let textGray1 = UIColor.color(named: "textGray1")
  static let textGray2 = UIColor.color(named: "textGray2")
  static let textGreen = UIColor.color(named: "textGreen")
  static let textRed = UIColor.color(named: "textRed")


  private static func color(named: String) -> UIColor {
      let bundle = Bundle(for: BundleColorsToken.self)
      return UIColor(named: named, in: bundle, compatibleWith: nil)!	  
  }
}

private final class BundleColorsToken {}


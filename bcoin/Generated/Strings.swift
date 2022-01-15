// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {

  internal enum AssetsDetails {
    /// Market Cap
    internal static let marketCap = Strings.tr("Localizable", "assetsDetails.marketCap")
    /// Supply
    internal static let supply = Strings.tr("Localizable", "assetsDetails.supply")
    /// Assets Details
    internal static let title = Strings.tr("Localizable", "assetsDetails.title")
    /// Volume (24h)
    internal static let volumeUsd24Hr = Strings.tr("Localizable", "assetsDetails.volumeUsd24Hr")
  }

  internal enum AssetsTab {
    /// Assets
    internal static let title = Strings.tr("Localizable", "assetsTab.title")
  }

  internal enum Content {
    /// Try searching for
    /// other keywords
    internal static let noDataSubtitle = Strings.tr("Localizable", "content.noDataSubtitle")
    /// No assets
    /// found
    internal static let noDataTitle = Strings.tr("Localizable", "content.noDataTitle")
  }

  internal enum Error {
    /// OK
    internal static let alertOk = Strings.tr("Localizable", "error.alertOk")
    /// Error
    internal static let alertTitle = Strings.tr("Localizable", "error.alertTitle")
    /// You exceeded your 200 request(s) rate limit of your FREE plan
    internal static let limitsExceeded = Strings.tr("Localizable", "error.limitsExceeded")
    /// An unknown error has occurred
    internal static let unknown = Strings.tr("Localizable", "error.unknown")
  }

  internal enum SettingsTab {
    /// Icon
    internal static let icon = Strings.tr("Localizable", "settingsTab.icon")
    /// Settings
    internal static let title = Strings.tr("Localizable", "settingsTab.title")
  }

  internal enum WatchlistTab {
    /// Delete
    internal static let delete = Strings.tr("Localizable", "watchlistTab.delete")
    /// Your Watchlist will appear here
    internal static let noDataHeader = Strings.tr("Localizable", "watchlistTab.noDataHeader")
    /// No assets yet
    internal static let noDataTitle = Strings.tr("Localizable", "watchlistTab.noDataTitle")
    /// Watchlist
    internal static let title = Strings.tr("Localizable", "watchlistTab.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type

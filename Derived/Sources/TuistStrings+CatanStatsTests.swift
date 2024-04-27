// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
public enum CatanStatsTestsStrings {

  public enum CastleColors {
  /// Blue
    public static let blue = CatanStatsTestsStrings.tr("Localizable", "castleColors.blue")
    /// Green
    public static let green = CatanStatsTestsStrings.tr("Localizable", "castleColors.green")
    /// Yellow
    public static let yellow = CatanStatsTestsStrings.tr("Localizable", "castleColors.yellow")
  }

  public enum GameHistory {
  /// Game history
    public static let navigationBarTitle = CatanStatsTestsStrings.tr("Localizable", "gameHistory.navigationBarTitle")
    /// Game %d
    public static func sectionTitle(_ p1: Int) -> String {
      return CatanStatsTestsStrings.tr("Localizable", "gameHistory.sectionTitle",p1)
    }
  }

  public enum NewRoll {
  /// Roll stats
    public static let navigationBarTitle = CatanStatsTestsStrings.tr("Localizable", "newRoll.navigationBarTitle")
  }

  public enum TabBar {
  /// Game list
    public static let historyPageTitle = CatanStatsTestsStrings.tr("Localizable", "tabBar.historyPageTitle")
    /// New roll
    public static let rollsPageTitle = CatanStatsTestsStrings.tr("Localizable", "tabBar.rollsPageTitle")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension CatanStatsTestsStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = CatanStatsTestsResources.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
// swiftlint:enable all
// swiftformat:enable all

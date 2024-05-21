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
  /// %@ Castle
  public static func castleDescription(_ p1: Any) -> String {
    return CatanStatsTestsStrings.tr("Localizable", "castleDescription",String(describing: p1))
  }
  /// Ship
  public static let shipDescription = CatanStatsTestsStrings.tr("Localizable", "shipDescription")

  public enum CastleColor {
  /// Blue
    public static let blue = CatanStatsTestsStrings.tr("Localizable", "castleColor.blue")
    /// Green
    public static let green = CatanStatsTestsStrings.tr("Localizable", "castleColor.green")
    /// Yellow
    public static let yellow = CatanStatsTestsStrings.tr("Localizable", "castleColor.yellow")
  }

  public enum GameDetails {
  /// Actual count
    public static let actualCount = CatanStatsTestsStrings.tr("Localizable", "gameDetails.actualCount")
    /// Rolled %d
    public static func diceCell(_ p1: Int) -> String {
      return CatanStatsTestsStrings.tr("Localizable", "gameDetails.diceCell",p1)
    }
    /// Expected count
    public static let expectedCount = CatanStatsTestsStrings.tr("Localizable", "gameDetails.expectedCount")
  }

  public enum GameList {
  /// Delete
    public static let deleteActionTitle = CatanStatsTestsStrings.tr("Localizable", "gameList.deleteActionTitle")
    /// Game history
    public static let navigationBarTitle = CatanStatsTestsStrings.tr("Localizable", "gameList.navigationBarTitle")
    /// Game %d
    public static func sectionTitle(_ p1: Int) -> String {
      return CatanStatsTestsStrings.tr("Localizable", "gameList.sectionTitle",p1)
    }
  }

  public enum NewRoll {
  /// Roll stats
    public static let navigationBarTitle = CatanStatsTestsStrings.tr("Localizable", "newRoll.navigationBarTitle")
  }

  public enum RollSection {
  /// Rolls
    public static let rolls = CatanStatsTestsStrings.tr("Localizable", "rollSection.rolls")
    /// Ship and castles
    public static let shipAndCastles = CatanStatsTestsStrings.tr("Localizable", "rollSection.shipAndCastles")
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

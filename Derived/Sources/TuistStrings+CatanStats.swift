// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
public enum CatanStatsStrings {
  /// %@ Castle
  public static func castleDescription(_ p1: Any) -> String {
    return CatanStatsStrings.tr("Localizable", "castleDescription",String(describing: p1))
  }
  /// Ship
  public static let shipDescription = CatanStatsStrings.tr("Localizable", "shipDescription")

  public enum CastleColor {
  /// Blue
    public static let blue = CatanStatsStrings.tr("Localizable", "castleColor.blue")
    /// Green
    public static let green = CatanStatsStrings.tr("Localizable", "castleColor.green")
    /// Yellow
    public static let yellow = CatanStatsStrings.tr("Localizable", "castleColor.yellow")
  }

  public enum GameDetails {
  /// Actual count
    public static let actualCount = CatanStatsStrings.tr("Localizable", "gameDetails.actualCount")
    /// Rolled %d
    public static func diceCell(_ p1: Int) -> String {
      return CatanStatsStrings.tr("Localizable", "gameDetails.diceCell",p1)
    }
    /// Expected count
    public static let expectedCount = CatanStatsStrings.tr("Localizable", "gameDetails.expectedCount")
  }

  public enum GameList {
  /// Delete
    public static let deleteActionTitle = CatanStatsStrings.tr("Localizable", "gameList.deleteActionTitle")
    /// Current
    public static let gameCellCurrentLabel = CatanStatsStrings.tr("Localizable", "gameList.gameCellCurrentLabel")
    /// Game history
    public static let navigationBarTitle = CatanStatsStrings.tr("Localizable", "gameList.navigationBarTitle")
    /// Game %d
    public static func sectionTitle(_ p1: Int) -> String {
      return CatanStatsStrings.tr("Localizable", "gameList.sectionTitle",p1)
    }
    /// Activate
    public static let setCurrentActionTitle = CatanStatsStrings.tr("Localizable", "gameList.setCurrentActionTitle")
  }

  public enum NewRoll {
  /// Roll stats
    public static let navigationBarTitle = CatanStatsStrings.tr("Localizable", "newRoll.navigationBarTitle")
    /// Create a new game on the second tab before proceeding
    public static let overlayWarningText = CatanStatsStrings.tr("Localizable", "newRoll.overlayWarningText")
  }

  public enum RollSection {
  /// Rolls
    public static let rolls = CatanStatsStrings.tr("Localizable", "rollSection.rolls")
    /// Ship and castles
    public static let shipAndCastles = CatanStatsStrings.tr("Localizable", "rollSection.shipAndCastles")
  }

  public enum TabBar {
  /// Game list
    public static let historyPageTitle = CatanStatsStrings.tr("Localizable", "tabBar.historyPageTitle")
    /// New roll
    public static let rollsPageTitle = CatanStatsStrings.tr("Localizable", "tabBar.rollsPageTitle")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension CatanStatsStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = CatanStatsResources.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
// swiftlint:enable all
// swiftformat:enable all

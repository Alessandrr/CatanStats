//
//  NewGameViewController.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 24.06.24.
//

import Foundation

import UIKit

protocol NewGameViewControllerProtocol: AnyObject {
	func renderErrorStatus(_ errors: ValidationErrors)
	func gameCreated()
}

final class NewGameViewController: UIViewController {
	enum PlayerCount: Int, CaseIterable, CustomStringConvertible {
		case three = 3
		case four = 4

		static let defaultCount = 3

		var description: String {
			switch self {
			case .three:
				"3 players"
			case .four:
				"4 players"
			}
		}
	}

	// MARK: Private properties
	private var input = NewGameUserInput(
		gameTitle: "",
		playerCount: PlayerCount.defaultCount,
		playerNames: Array(repeating: "", count: PlayerCount.allCases.map { $0.rawValue }.max() ?? 0)
	)
	private var validationErrors = ValidationErrors(validationErrors: [])

	private lazy var gameTitleField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "New game"
		textField.borderStyle = .roundedRect
		textField.addTarget(self, action: #selector(didChangeGameTitle), for: .editingDidEnd)
		return textField
	}()

	private lazy var playerCountControl: UISegmentedControl = {
		let playerCountControl = UISegmentedControl(items: PlayerCount.allCases.map { $0.description })
		playerCountControl.selectedSegmentIndex = 0
		playerCountControl.addTarget(self, action: #selector(didSelectPlayerCount), for: .valueChanged)
		return playerCountControl
	}()

	private lazy var playerNamesTableView: UITableView = {
		let tableView = UITableView()
		tableView.register(PlayerNameTableViewCell.self, forCellReuseIdentifier: PlayerNameTableViewCell.reuseIdentifier)
		tableView.separatorStyle = .none
		tableView.dataSource = self
		return tableView
	}()

	// MARK: Dependencies
	var presenter: NewGamePresenterProtocol?

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}

	// MARK: Private methods
	@objc private func didSelectCancel() {
		dismiss(animated: true)
	}

	@objc private func didSelectSave() {
		view.endEditing(true)
		presenter?.createGame(with: input)
	}

	@objc private func didSelectPlayerCount() {
		input.playerCount = PlayerCount.allCases[playerCountControl.selectedSegmentIndex].rawValue
		playerNamesTableView.reloadSections(IndexSet([0]), with: .automatic)
	}

	@objc private func didChangeGameTitle() {
		input.gameTitle = gameTitleField.text ?? ""
	}
}

extension NewGameViewController: NewGameViewControllerProtocol {
	func renderErrorStatus(_ errors: ValidationErrors) {
		validationErrors = errors
		playerNamesTableView.reloadSections(IndexSet([0]), with: .automatic)
	}

	func gameCreated() {
		dismiss(animated: true)
	}
}

// MARK: UI Setup
private extension NewGameViewController {
	func setupUI() {
		view.backgroundColor = .systemBackground

		navigationItem.leftBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .cancel,
			target: self,
			action: #selector(didSelectCancel)
		)

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .save,
			target: self,
			action: #selector(didSelectSave)
		)

		navigationItem.title = CatanStatsStrings.NewGame.navigationBarTitle
		layout()
	}

	func layout() {
		gameTitleField.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(gameTitleField)
		playerCountControl.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(playerCountControl)
		playerNamesTableView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(playerNamesTableView)

		NSLayoutConstraint.activate([
			gameTitleField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			gameTitleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Sizes.Padding.large),
			gameTitleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizes.Padding.large),
			gameTitleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Sizes.Padding.large),

			playerCountControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			playerCountControl.topAnchor.constraint(equalTo: gameTitleField.bottomAnchor, constant: Sizes.Padding.large),
			playerCountControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizes.Padding.large),
			playerCountControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Sizes.Padding.large),

			playerNamesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizes.Padding.large),
			playerNamesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Sizes.Padding.large),
			playerNamesTableView.topAnchor.constraint(equalTo: playerCountControl.bottomAnchor, constant: Sizes.Padding.large),
			playerNamesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Sizes.Padding.large)
		])
	}
}

// MARK: UITableViewDataSource
extension NewGameViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		PlayerCount.allCases[playerCountControl.selectedSegmentIndex].rawValue
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: PlayerNameTableViewCell.reuseIdentifier,
			for: indexPath
		) as? PlayerNameTableViewCell else {
			return UITableViewCell()
		}

		cell.configure(at: indexPath, delegate: self, currentInput: input.playerNames[indexPath.row])

		if validationErrors.hasError(forPlayerAtIndex: indexPath.row) {
			cell.configureError(at: indexPath)
		}

		return cell
	}
}

// MARK: UITextFieldDelegate
extension NewGameViewController: UITextFieldDelegate {
	func textFieldDidEndEditing(_ textField: UITextField) {
		let playerName = textField.text ?? ""
		input.playerNames[textField.tag] = playerName
	}
}

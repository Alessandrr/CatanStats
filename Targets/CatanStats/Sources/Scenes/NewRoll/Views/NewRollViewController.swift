//
//  NewRollViewController.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 04.04.24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

protocol NewRollViewControllerProtocol: AnyObject {
	func renderOverlay(newRollsDisabled: Bool)
	func renderCurrentPlayer(_ name: String)
}

final class NewRollViewController: UIViewController {

	// MARK: Internal properties
	override var canBecomeFirstResponder: Bool {
		true
	}

	// MARK: Private properties
	private var collectionView: UICollectionView!
	private var dataSource: UICollectionViewDiffableDataSource<RollSection, DiceModel>!
	private var sections: [RollSection]
	private let overlayView = NewRollOverlayView()

	// MARK: Dependencies
	var presenter: NewRollPresenterProtocol?
	private var sectionLayoutProviderFactory: SectionLayoutProviderFactory
	private var modelProvider: GameModelProviderProtocol

	// MARK: Initialization
	init(
		sectionLayoutProviderFactory: SectionLayoutProviderFactory,
		modelProvider: GameModelProviderProtocol,
		sections: [RollSection] = RollSection.allCases
	) {
		self.sectionLayoutProviderFactory = sectionLayoutProviderFactory
		self.modelProvider = modelProvider
		self.sections = sections
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		configureCollectionView()
		configureDataSource()
		setupUI()
		presenter?.initialSetup()
	}

	override func viewDidAppear(_ animated: Bool) {
		becomeFirstResponder()
		navigationItem.rightBarButtonItem?.isEnabled = overlayView.isHidden
	}

	override func viewWillDisappear(_ animated: Bool) {
		resignFirstResponder()
	}

	// MARK: Private methods
	private func configureCollectionView() {
		let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
		view.addSubview(collectionView)
		collectionView.delegate = self
		collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		collectionView.isScrollEnabled = false
		collectionView.register(NewRollCell.self, forCellWithReuseIdentifier: NewRollCell.reuseIdentifier)
		self.collectionView = collectionView
	}

	private func configureDataSource() {
		dataSource = UICollectionViewDiffableDataSource
		<RollSection, DiceModel>(collectionView: collectionView) { (collectionView, indexPath, newDiceModel)
			-> UICollectionViewCell? in
			guard let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: NewRollCell.reuseIdentifier,
				for: indexPath
			) as? NewRollCell else { return UICollectionViewCell() }

			cell.configure(with: newDiceModel)
			return cell
		}

		var snapshot = NSDiffableDataSourceSnapshot<RollSection, DiceModel>()
		snapshot.appendSections(sections)
		for section in sections {
			snapshot.appendItems(modelProvider.makeModelsForSection(section), toSection: section)
		}
		dataSource.apply(snapshot)
	}

	@objc private func undoRollSelected() {
		presenter?.undoRoll()
	}
}

// MARK: Layout
extension NewRollViewController {
	private func setupUI() {
		navigationItem.title = CatanStatsStrings.NewRoll.navigationBarTitle
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.sizeToFit()

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .undo,
			target: self,
			action: #selector(undoRollSelected)
		)

		overlayView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(overlayView)
		NSLayoutConstraint.activate([
			overlayView.topAnchor.constraint(equalTo: collectionView.topAnchor),
			overlayView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			overlayView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
			overlayView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor)
		])
	}

	private func generateLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { [unowned self] sectionIndex, _ in
			let section = sections[sectionIndex]
			let layoutProvider = sectionLayoutProviderFactory.makeSectionProvider(for: section)
			return layoutProvider.generateLayoutSection()
		}

		return layout
	}
}

// MARK: NewRollViewControllerProtocol
extension NewRollViewController: NewRollViewControllerProtocol {
	func renderOverlay(newRollsDisabled: Bool) {
		overlayView.isHidden = !newRollsDisabled
	}

	func renderCurrentPlayer(_ name: String) {
		navigationItem.title = "\(name) rolls"
	}
}

// MARK: UIResponder
extension NewRollViewController {
	override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		if motion == .motionShake {
			undoRollSelected()
		}
	}
}

// MARK: UICollectionViewDelegate
extension NewRollViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let cell = collectionView.cellForItem(at: indexPath) as? NewRollCell {
			cell.animateTap()
		}
		guard let diceModel = dataSource.itemIdentifier(for: indexPath) else { return }
		presenter?.didSelectRollItem(diceModel)
	}
}

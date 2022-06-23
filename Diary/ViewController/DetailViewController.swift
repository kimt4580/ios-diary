//
//  DetailViewController.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/15.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private lazy var detailView = DetailView(frame: view.frame)
    private let persistenceManager = PersistenceManager.shared
    private var diaryData: DiaryModel
    
    override func loadView() {
        super.loadView()
        detailView.backgroundColor = .systemBackground
        self.view = detailView
    }
    
    init(diaryData: DiaryModel) {
        self.diaryData = diaryData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarTitle()
        detailView.setUpView(diaryData: diaryData)
        registerKeyboardNotifications()
        setNavigationBarRightButton()
    }
}

// MARK: - Method

extension DetailViewController {
    
    private func setNavigationBarTitle() {
        navigationItem.title = diaryData.createdAt.formattedDate
    }
    
    private func setNavigationBarRightButton() {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(navigationBarRightButtonTapped)
        )
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func navigationBarRightButtonTapped() {
        
    }
}

// MARK: - Keyboard Method

extension DetailViewController {
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        )?.cgRectValue else { return }
        detailView.mainScrollView.contentInset = .init(
            top: .zero,
            left: .zero,
            bottom: keyboardSize.height,
            right: .zero
        )
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        detailView.mainScrollView.contentInset = .init(
            top: .zero,
            left: .zero,
            bottom: .zero,
            right: .zero
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let title = detailView.titleField.text
        let body = detailView.descriptionView.text
        
        diaryData = DiaryModel(title: title, body: body, createdAt: diaryData.createdAt, id: diaryData.id)
        
        persistenceManager.update(diary: diaryData)
    }
}

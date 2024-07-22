//
//  BaseViewController.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

class BaseViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDefaultUI()
        configureUI()
        configureNavigation()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationTitle()
    }
    
    func configureUI() { }
    func configureLayout() { }
    func configureNavigation() { }
    
    func configureNavigationTitle() { }
    
    private func configureDefaultUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.topItem?.title = ""
    }
}

//
//  TopicViewController.swift
//  Polaroid
//
//  Created by gnksbm on 7/23/24.
//

import Combine
import UIKit

import SnapKit

final class TopicViewController: BaseViewController, View {
    private let viewDidLoadEvent = PassthroughSubject<Void, Never>()
    private let viewWillAppearEvent = PassthroughSubject<Void, Never>()
    private var cancelBag = CancelBag()
    
    private let profileButton = ProfileImageButton(
        type: .static,
        dimension: .width
    )
    private let titleLabel = UILabel().nt.configure {
        $0.text(Literal.NavigationTitle.ourTopic)
            .font(MPDesign.Font.largeNavigationTitle.with(weight: .bold))
    }
    private let collectionView = TopicCollectionView()
    
    override init() {
        super.init()
        viewModel = TopicViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadEvent.send(())
        showProgressView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        viewWillAppearEvent.send(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func bind(viewModel: TopicViewModel) {
        let output = viewModel.transform(
            input: TopicViewModel.Input(
                viewDidLoadEvent: viewDidLoadEvent, 
                viewWillAppearEvent: viewWillAppearEvent,
                profileTapEvent: profileButton.tapEvent,
                itemSelectEvent: collectionView.getItemSelectedEvent()
            )
        )
        
        output.currentUser
            .sink(with: self) { vc, user in
                vc.profileButton.setImage(
                    UIImage(data: user.profileImageData),
                    for: .normal
                )
            }
            .store(in: &cancelBag)
        
        output.imageDic
            .sink(with: self) { vc, itemDic in
                vc.collectionView.applyItem { section in
                    itemDic[section, default: []]
                }
                vc.hideProgressView()
            }
            .store(in: &cancelBag)
        
        output.onError
            .sink(with: self) { vc, _ in
                vc.showToast(message: "오류가 발생했습니다")
                vc.hideProgressView()
            }
            .store(in: &cancelBag)
        
        output.startProfileFlow
            .sink(with: self) { vc, _ in
                vc.navigationController?.pushViewController(
                    ProfileSettingViewController(flowType: .edit),
                    animated: true
                )
            }
            .store(in: &cancelBag)
        
        output.startDetailFlow
            .sink(with: self) { vc, image in
                vc.navigationController?.pushViewController(
                    DetailViewController(data: image),
                    animated: true
                )
            }
            .store(in: &cancelBag)
    }
    
    override func configureLayout() {
        [profileButton, titleLabel, collectionView].forEach {
            view.addSubview($0)
        }
        
        let padding = 20.f
        
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(safeArea).inset(padding / 2)
            make.trailing.equalTo(safeArea).inset(padding)
            make.width.equalTo(safeArea).multipliedBy(0.1)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(padding / 2)
            make.leading.equalTo(safeArea).inset(padding * 0.75)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
}

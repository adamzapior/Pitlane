//
//  ScheduleDetailsVC.swift
//  Pitlane
//
//  Created by Adam Zapiór on 03/11/2023.
//

import SnapKit
import UIKit

class ScheduleDetailsVC: UIViewController, UIScrollViewDelegate {
    // MARK: - Variables
    
    var race: RaceModel?
    
    // MARK: - UI Components
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let headerImageView = UIView()
    let imageView = UIImageView()
    
    let raceNameTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize, weight: .heavy)
        title.textColor = .UI.imageHeaderText
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        return title
    }()
    
    let detailsSubtitleLabel = UILabel()
    
    let scheduleSubtitleLabel = UILabel()

    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.UI.divider
        return view
    }()
    
    let roundInfoView = ScheduleInfoView()
    let seasonInfoView = ScheduleInfoView()
    let circuitInfoView = ScheduleInfoView()
    
    lazy var timetableView: ScheduleTimetableView = {
        let view = ScheduleTimetableView(practice1Text: race?.firstPractice.date ?? "Practice 1")
        return view
    }()
    
    let sessionStackView = UIStackView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = UIColor.UI.background
        navigationController?.navigationBar.tintColor = .red

        setupScrollView()
        setupContentView()
        
        setupHeader()
        setupImageView()
        setupRaceNameLabel()
        
        setupDetailsSubtitleLabel()
        setupRaceDetails()
        setupScheduleDetails()
        
        setupStackView()
        setupSessionViews()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(200)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
    }
    
    private func setupHeader() {
        scrollView.addSubview(headerImageView)
        
        headerImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        let headerImageViewBottom: NSLayoutConstraint!
        headerImageViewBottom = headerImageView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -20)
        headerImageViewBottom.priority = UILayoutPriority(rawValue: 900)
        headerImageViewBottom.isActive = true
    }
    
    private func setupImageView() {
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "schedule-header")
        imageView.contentMode = .scaleAspectFill
        headerImageView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(headerImageView.snp.leading)
            make.trailing.equalTo(headerImageView.snp.trailing)
            make.bottom.equalTo(headerImageView.snp.bottom)
        }

        let imageViewTopConstraint: NSLayoutConstraint!
        imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: view.topAnchor)
        imageViewTopConstraint.priority = UILayoutPriority(rawValue: 900)
        imageViewTopConstraint.isActive = true
    }
    
    private func setupRaceNameLabel() {
        headerImageView.addSubview(raceNameTitle)
        raceNameTitle.snp.makeConstraints { make in
            make.bottom.equalTo(headerImageView.snp.bottom).offset(-12)
            make.leading.equalTo(headerImageView.snp.leading).offset(18)
        }
                
        if let raceName = race?.raceName, raceName.contains("Grand Prix") {
            raceNameTitle.text = raceName.replacingOccurrences(of: "Grand Prix", with: "\nGrand Prix")
        } else {
            raceNameTitle.text = race?.raceName
        }
    }
    
    private func setupDetailsSubtitleLabel() {
        contentView.addSubview(detailsSubtitleLabel)
        detailsSubtitleLabel.text = "Details"
        detailsSubtitleLabel.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .semibold)
        detailsSubtitleLabel.textColor = .UI.primaryText
        
        detailsSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading).offset(12)
        }
    }
    
    private func setupRaceDetails() {
        contentView.addSubview(roundInfoView)
        contentView.addSubview(seasonInfoView)
        contentView.addSubview(circuitInfoView)
        contentView.addSubview(dividerView)
        
        roundInfoView.configureText(titleText: "ROUND", valueText: "\(race?.round ?? "-")")
        seasonInfoView.configureText(titleText: "SEASON", valueText: "\(race?.season ?? "-")")
        circuitInfoView.configureText(titleText: "CIRCUIT", valueText: "\(race?.circuit.circuitName ?? "-")")
        
        roundInfoView.snp.makeConstraints { make in
            make.top.equalTo(detailsSubtitleLabel.snp.bottom).offset(6)
            make.leading.equalTo(contentView.snp.leading).offset(6)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.5).offset(-10)
        }
      
        seasonInfoView.snp.makeConstraints { make in
            make.top.equalTo(detailsSubtitleLabel.snp.bottom).offset(6)
            make.trailing.equalTo(contentView.snp.trailing).offset(-6)
            make.width.equalTo(roundInfoView.snp.width)
        }
      
        circuitInfoView.snp.makeConstraints { make in
            make.top.equalTo(roundInfoView.snp.bottom).offset(12)
            make.leading.equalTo(contentView.snp.leading).offset(12)
            make.trailing.equalTo(contentView.snp.trailing).offset(-12)
        }
        
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(circuitInfoView.snp.bottom).offset(24)
            make.leading.equalTo(contentView.snp.leading).offset(12)
            make.trailing.equalTo(contentView.snp.trailing).offset(-12)
            make.height.equalTo(0.5)
        }
    }
    
    private func setupScheduleDetails() {
        contentView.addSubview(scheduleSubtitleLabel)
        scheduleSubtitleLabel.text = "Schedule"
        scheduleSubtitleLabel.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .semibold)
        scheduleSubtitleLabel.textColor = .UI.primaryText
        
        scheduleSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.top).offset(12)
            make.leading.equalTo(contentView.snp.leading).offset(12)
        }
    }
    
    private func setupStackView() {
        contentView.addSubview(sessionStackView)
        sessionStackView.axis = .vertical
        sessionStackView.distribution = .fill
        sessionStackView.alignment = .fill
        sessionStackView.spacing = 12
        
        sessionStackView.snp.makeConstraints { make in
            make.top.equalTo(scheduleSubtitleLabel.snp.bottom).offset(6)
            make.leading.equalTo(contentView.snp.leading).offset(12)
            make.trailing.equalTo(contentView.snp.trailing).offset(-12)
            make.bottom.equalTo(contentView.snp.bottom).offset(-50)
//            make.height.equalTo(300)
        }
    }
    
    private func setupSessionViews() {
        if let firstPracticeDate = race?.firstPractice.date, let firstPracticeTime = race?.firstPractice.time {
            let fp1View = TimetableItemView()
            sessionStackView.addArrangedSubview(fp1View)
            
            fp1View.configureText(practiceNameText: "First Practice", leftDaysText: "", dateText: "\(firstPracticeDate) \(firstPracticeTime)")
        }
        
        if let secondPracticeDate = race?.secondPractice.date, let secondPracticeTime = race?.secondPractice.time {
            let fp2View = TimetableItemView()
            fp2View.configureText(practiceNameText: "Second Practice", leftDaysText: "", dateText: "\(secondPracticeDate) \(secondPracticeTime)")
            sessionStackView.addArrangedSubview(fp2View)
        }
        
        if let thirdPracticeDate = race?.thirdPractice?.date, let thirdPracticeTime = race?.thirdPractice?.time {
            let fp3View = TimetableItemView()
            fp3View.configureText(practiceNameText: "Third Practice", leftDaysText: "", dateText: "\(thirdPracticeDate) \(thirdPracticeTime)")
            sessionStackView.addArrangedSubview(fp3View)
        }
        
        if let qualifyingDate = race?.qualifying.date, let qualifyingTime = race?.qualifying.time {
            let qualifyingView = TimetableItemView()
            qualifyingView.configureText(practiceNameText: "Qualifying", leftDaysText: "", dateText: "\(qualifyingDate) \(qualifyingTime)")
            sessionStackView.addArrangedSubview(qualifyingView)
        }
        
        if let sprintDate = race?.sprint?.date, let sprintTime = race?.sprint?.time {
            let sprintView = TimetableItemView()
            sprintView.configureText(practiceNameText: "Sprint", leftDaysText: "", dateText: "\(sprintDate) \(sprintTime)")
            sessionStackView.addArrangedSubview(sprintView)
        }
        
        if let raceDate = race?.firstPractice.date, let raceTime = race?.firstPractice.time {
            let raceView = TimetableItemView()
            raceView.configureText(practiceNameText: "Race", leftDaysText: "", dateText: "\(raceDate) \(raceTime)")
            sessionStackView.addArrangedSubview(raceView)
        }
    }
}

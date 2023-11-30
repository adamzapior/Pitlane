//
//  ScheduleDetailsVC.swift
//  Pitlane
//
//  Created by Adam Zapiór on 03/11/2023.
//

import SnapKit
import UIKit

class ScheduleDetailsVC: UIViewController, UIScrollViewDelegate {
    var race: ScheduleModel!
    
    // MARK: - UI Components
    
    let scrollView = UIScrollView()
    
    // Header
    
    let headerImageView = UIView()
    let imageView = UIImageView()
    let raceNameTitle = UILabel()
    
    // Content
    
    let contentView = UIView()
    let detailsSubtitleLabel = UILabel()
    
    /// Details
    
    let detailsContainer = UIView()
    let locationView = ScheduleDetailsLocationView()
    let roundInfoView = ScheduleDetailsView()
    let seasonInfoView = ScheduleDetailsView()
    let circuitInfoView = ScheduleDetailsView()
    let dividerView = UIView()
    
    /// Schedule
    
    let scheduleSubtitleLabel = UILabel()
    let scheduleStackView = UIStackView()
    let fp1View = ScheduleTimetableItemView()
    let qualifyingView = ScheduleTimetableItemView()
    let raceView = ScheduleTimetableItemView()
    
    lazy var fp2View = ScheduleTimetableItemView()
    lazy var fp3View = ScheduleTimetableItemView()
    lazy var sprintQualifyingView = ScheduleTimetableItemView()
    lazy var sprintView = ScheduleTimetableItemView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        view.maximumContentSizeCategory = .extraExtraExtraLarge
    }
    
    // MARK: - UI Setup
    
    /* View Hierarchy
      - ScrollView
          -- Header
             - ImageView
             - RaceNameLabel
          -- ContentView
             - DetailsSubtitleLabel
             - Details Container
                 -- Details Content
             - Divider
             - ScheduleSubtitleLabel
             - Schedule StackView
                 -- Schedule Content
     */
    
    private func setupUI() {
        view.backgroundColor = UIColor.UI.background
        navigationController?.navigationBar.tintColor = .red

        setupScrollView()
        setupContentView()
        
        setupHeader()
        setupImageView()
        setupRaceNameLabel()
        
        setupDetailsSubtitleLabel()
        setupDetailsContainer()
        setupRaceDetails()
        setupScheduleSubtitleLabel()
        
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
    
    // Header
    
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
        headerImageView.addSubview(imageView)
        
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "schedule-header")
        imageView.contentMode = .scaleAspectFill
        
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
        
        raceNameTitle.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize, weight: .heavy)
        raceNameTitle.textColor = .UI.imageHeaderText
        raceNameTitle.numberOfLines = 0
        raceNameTitle.lineBreakMode = .byWordWrapping
        
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
    
    // Content
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(200)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
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
    
    private func setupDetailsContainer() {
        contentView.addSubview(detailsContainer)
        
        detailsContainer.snp.makeConstraints { make in
            make.top.equalTo(detailsSubtitleLabel.snp.bottom).offset(6)
            make.leading.equalTo(contentView.snp.leading).offset(6)
            make.trailing.equalTo(contentView.snp.trailing).offset(-6)
        }
    }
    
    private func setupRaceDetails() {
        detailsContainer.addSubview(locationView)
        detailsContainer.addSubview(roundInfoView)
        detailsContainer.addSubview(seasonInfoView)
        detailsContainer.addSubview(circuitInfoView)
        detailsContainer.addSubview(dividerView)
        
        locationView.configure(with: race) // TODO:
        
        roundInfoView.configure(titleText: "ROUND", valueText: "\(race?.round ?? "-")")
        seasonInfoView.configure(titleText: "SEASON", valueText: "\(race?.season ?? "-")") 
        circuitInfoView.configure(titleText: "CIRCUIT", valueText: "\(race?.circuit.circuitName ?? "-")")
        
        locationView.snp.makeConstraints { make in
            make.top.equalTo(detailsContainer.snp.top)
            make.leading.equalTo(detailsContainer.snp.leading).offset(6)
            make.trailing.equalTo(detailsContainer.snp.trailing).offset(-6)
            make.height.equalTo(circuitInfoView.snp.height)
        }
        
        roundInfoView.snp.makeConstraints { make in
            make.top.equalTo(locationView.snp.bottom).offset(12)
            make.leading.equalTo(detailsContainer.snp.leading).offset(6)
            make.width.equalTo(detailsContainer.snp.width).multipliedBy(0.5).offset(-10)
            make.height.equalTo(circuitInfoView.snp.height)
        }
      
        seasonInfoView.snp.makeConstraints { make in
            make.top.equalTo(locationView.snp.bottom).offset(12)
            make.trailing.equalTo(detailsContainer.snp.trailing).offset(-6)
            make.width.equalTo(roundInfoView.snp.width)
            make.height.equalTo(circuitInfoView.snp.height)
        }
      
        circuitInfoView.snp.makeConstraints { make in
            make.top.equalTo(roundInfoView.snp.bottom).offset(12)
            make.leading.equalTo(detailsContainer.snp.leading).offset(6)
            make.trailing.equalTo(detailsContainer.snp.trailing).offset(-6)
        }
        
        dividerView.backgroundColor = UIColor.UI.divider
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(circuitInfoView.snp.bottom).offset(24)
            make.leading.equalTo(detailsContainer.snp.leading).offset(12)
            make.trailing.equalTo(detailsContainer.snp.trailing).offset(-12)
            make.height.equalTo(0.5)
        }
    }
    
    private func setupScheduleSubtitleLabel() {
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
        contentView.addSubview(scheduleStackView)
        
        scheduleStackView.axis = .vertical
        scheduleStackView.distribution = .fill
        scheduleStackView.alignment = .fill
        scheduleStackView.spacing = 12

        scheduleStackView.snp.makeConstraints { make in
            make.top.equalTo(scheduleSubtitleLabel.snp.bottom).offset(6)
            make.leading.equalTo(contentView.snp.leading).offset(12)
            make.trailing.equalTo(contentView.snp.trailing).offset(-12)
            make.bottom.equalTo(contentView.snp.bottom).offset(-50)
        }
    }
    
    /// Setup schedule stack view in order depend on weekend type (with or without sprint)
    private func setupSessionViews() {
        scheduleStackView.addArrangedSubview(fp1View)
        fp1View.configure(practiceNameText: "FIRST PRACTICE", dateText: "\(race.firstPractice.date.convertToScheduleDetails())")
        
        if race.sprint == nil {
            scheduleStackView.addArrangedSubview(fp2View)
            fp2View.configure(practiceNameText: "SECOND PRACTICE", dateText: "\(race.secondPractice!.date.convertToScheduleDetails())")

            scheduleStackView.addArrangedSubview(fp3View)
            fp3View.configure(practiceNameText: "THIRD PRACTICE", dateText: "\(race.thirdPractice!.date.convertToScheduleDetails())")
        }
        
        if race.sprint != nil {
            scheduleStackView.addArrangedSubview(qualifyingView)
            qualifyingView.configure(practiceNameText: "QUALIFYING", dateText: "\(race.qualifying.date.convertToScheduleDetails())")
            
            scheduleStackView.addArrangedSubview(sprintQualifyingView)
            sprintQualifyingView.configure(practiceNameText: "SPRINT QUALIFYING", dateText: "\(race.sprintQualifying!.date.convertToScheduleDetails())")

            scheduleStackView.addArrangedSubview(sprintView)
            sprintView.configure(practiceNameText: "SPRINT", dateText: "\(race.sprint!.date.convertToScheduleDetails())")
        }
        
        scheduleStackView.addArrangedSubview(qualifyingView)
        qualifyingView.configure(practiceNameText: "QUALIFYING", dateText: "\(race.qualifying.date.convertToScheduleDetails())")

        scheduleStackView.addArrangedSubview(raceView)
        raceView.configure(practiceNameText: "RACE", dateText: "\(race.date.convertToScheduleDetails())")
    }
}

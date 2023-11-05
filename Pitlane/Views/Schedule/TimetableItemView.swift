//
//  SchedulePracticeInfoView.swift
//  Pitlane
//
//  Created by Adam Zapiór on 05/11/2023.
//

import UIKit

class TimetableItemView: UIView {
    let practiceNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize, weight: .regular)
        return label
    }()
    
    let leftDaysLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI Setup
    
    func configureText(practiceNameText: String, leftDaysText: String, dateText: String) {
        practiceNameLabel.text = practiceNameText
        leftDaysLabel.text = leftDaysText
        dateLabel.text = dateText
    }
    
    private func formatDate(dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ssZ" // Aktualizacja formatu wejściowego do obsługi daty Zulu
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Ustawienie UTC jako strefy czasowej wejściowej

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd MMM 'o' HH:mm" // Możesz dostosować format wyjściowy do swoich potrzeb
            outputFormatter.locale = Locale.current // Użyj lokalizacji bieżącej, aby format daty odpowiadał ustawieniom regionu użytkownika
            outputFormatter.timeZone = TimeZone.current // Użyj bieżącej strefy czasowej użytkownika dla czasu lokalnego
            return outputFormatter.string(from: date).uppercased()
        } else {
            return ""
        }
    }

    
    private func setupUI() {
        backgroundColor = UIColor.UI.primaryContainer
        layer.cornerRadius = 10
        clipsToBounds = true
        
//        setupPracticeNameLabel()
//        setupLeftDaysLabel()
//        setupDateLabel()
        
        addSubview(practiceNameLabel)
        addSubview(leftDaysLabel)
        addSubview(dateLabel)
        
        practiceNameLabel.textColor = .UI.secondaryText

        practiceNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8) // Dodajemy margines górny
            make.leading.equalToSuperview().offset(12)
            make.trailing.lessThanOrEqualToSuperview().offset(-12) // Dodajemy ograniczenie trailing
        }

        leftDaysLabel.snp.makeConstraints { make in
            make.top.equalTo(practiceNameLabel.snp.bottom).offset(4) // Umieszczamy poniżej practiceNameLabel
            make.leading.equalToSuperview().offset(12)
            make.trailing.lessThanOrEqualToSuperview().offset(-12) // Dodajemy ograniczenie trailing
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(leftDaysLabel.snp.bottom).offset(4) // Umieszczamy poniżej leftDaysLabel
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-8) // Dodajemy margines dolny
        }
    }
    
//    private func setupPracticeNameLabel() {
//        addSubview(practiceNameLabel)
//
//        practiceNameLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(8)
//            make.centerY.equalTo(-12)
//            make.leading.equalTo(self.snp.leading).offset(12)
//        }
//    }
//
//    private func setupLeftDaysLabel() {
//        addSubview(leftDaysLabel)
//
//        leftDaysLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(12)
//            make.leading.equalTo(self.snp.leading).offset(12)
//        }
//    }
//
//    private func setupDateLabel() {
//        addSubview(dateLabel)
//
//        dateLabel.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.trailing.equalTo(self.snp.trailing).offset(-12)
//        }
//    }
}

//
//  ListCell.swift
//  veroDigitalSolutionCase
//
//  Created by Furkan Deniz Albaylar on 21.02.2024.
//

import UIKit


class ListCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let colorView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
    
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(colorView)


        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(colorView.snp.leading).offset(-10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(colorView.snp.leading).offset(-10)
            make.bottom.lessThanOrEqualToSuperview().inset(10)
        }
        
        colorView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(30)
        }
        
        colorView.layer.cornerRadius = 15
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
    }
    
    func configure(with task: TaskModel) {
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        if let colorCode = task.colorCode, let color = UIColor(hexString: colorCode) {
            colorView.backgroundColor = color
        } else {
            colorView.backgroundColor = .gray 
        }

    }
}





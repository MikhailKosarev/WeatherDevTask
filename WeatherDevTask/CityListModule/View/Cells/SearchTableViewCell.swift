//
//  SearchTableViewCell.swift
//  WeatherDevTask
//
//  Created by Mikhail on 07.12.2022.
//

import UIKit

protocol CitySearchDelegateProtocol: AnyObject {
    func searchTextChanged(searchText: String)
}

final class SearchTableViewCell: UITableViewCell {
    
    // MARK: - Static properties
    
    static let reuseID = "SearchTableViewCell"
    
    // MARK: - Internal properties
    
    weak var delegate: CitySearchDelegateProtocol?
    
    // MARK: - UI properties
    
    lazy var citySearchField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.textColor = .white
        searchTextField.tintColor = .white
        // color of search icon
        searchTextField.leftView?.tintColor = .gray
        // placeholder and it's color
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        return searchTextField
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        backgroundColor = .black
        contentView.addSubview(citySearchField)
    }
    
    private func setConstraints() {
        // set margins
        contentView.preservesSuperviewLayoutMargins = false
        let margins = contentView.layoutMarginsGuide
    
        NSLayoutConstraint.activate([
            // citySearchField
            citySearchField.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            citySearchField.topAnchor.constraint(equalTo: margins.topAnchor),
            citySearchField.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            citySearchField.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func searchTextChanged(_ sender: UISearchTextField) {
        guard let text = sender.text else { return }
        delegate?.searchTextChanged(searchText: text)
    }
}

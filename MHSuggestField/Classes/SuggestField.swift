//
//  SuggestField.swift
//  SuggestField
//
//  Created by Mazen on 07/25/2019.
//  Copyright © 2019 Mazen. All rights reserved.
//

import UIKit



@IBDesignable
public class SuggestField: UITextField {
    
    @IBInspectable public var tableHeight:CGFloat = 100
    @IBInspectable public var tableColor:UIColor = UIColor.white.withAlphaComponent(0.8)
    @IBInspectable public var cellColor:UIColor = UIColor.clear
    @IBInspectable public var separatorColor:UIColor = UIColor.lightGray
    @IBInspectable public var leftSeparatorInset:CGFloat = 20
    @IBInspectable public var rightSeparatorInset:CGFloat = 20
    @IBInspectable public var restrictValues:Bool = false
    @IBInspectable public var allowEmptyField:Bool = true
    @IBInspectable public var showToolbar:Bool = false
    @IBInspectable public var canFilterList:Bool = false
    
    public weak var suggestDelegate:SuggestFieldDelegate?
    
    public var datasource = [String]() {
        didSet {
            filteredSource = datasource
            tblChoices.reloadData()
        }
    }
    private var filteredSource = [String]()
    
    private var tblChoices = UITableView()
    private var virtualTextField:UITextField!
    private var shouldEndTextEditing = false
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        
        if let _ = self.superview {
            tblChoices.backgroundColor = tableColor
            tblChoices.separatorColor = separatorColor
            tblChoices.separatorInset.left = leftSeparatorInset
            tblChoices.separatorInset.right = rightSeparatorInset
            tblChoices.rowHeight = UITableViewAutomaticDimension
            
            tblChoices.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tblChoices.dataSource = self
            tblChoices.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tableTapped(recognizer:))))
            tblChoices.isHidden = true
            
            virtualTextField = UITextField(frame: self.frame)
            virtualTextField.isHidden = true
            virtualTextField.delegate = self
            
            if showToolbar {
                let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
                toolbar.setItems([UIBarButtonItem(title: "Cancel",
                                                  style: .done,
                                                  target: self,
                                                  action: #selector(toolbarCancelAction)),
                                  UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                  target: nil,
                                                  action: nil),
                                  UIBarButtonItem(title: "Done",
                                                  style: .done,
                                                  target: self,
                                                  action: #selector(toolbarDoneAction))
                    ], animated: false)
                self.inputAccessoryView = toolbar
            }
            
            if canFilterList {
                
                self.addTarget(self, action: #selector(filterText), for: .editingChanged)
            }
            
            self.delegate = self
            
            self.superview?.addSubview(tblChoices)
            self.superview?.insertSubview(virtualTextField, belowSubview: self)
        }
    }
    
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        tblChoices.frame = CGRect(x: self.frame.origin.x + 4,
                                  y: self.frame.origin.y + self.bounds.height,
                                  width: self.frame.size.width - 8,
                                  height: self.tableHeight)
    }
    
    @objc func tableTapped(recognizer: UIGestureRecognizer) {
        
        let touchPoint = recognizer.location(in: self.tblChoices)
        
        guard let index = tblChoices.indexPathForRow(at: touchPoint)
            else { return }
        
        self.text = self.filteredSource[index.row]
        self.shouldEndTextEditing = true
        self.resignFirstResponder()
    }
    
    @objc func toolbarCancelAction() {
        self.shouldEndTextEditing = true
        self.resignFirstResponder()
    }
    
    @objc func toolbarDoneAction() {
        self.shouldEndTextEditing = true
        self.resignFirstResponder()
    }
    
    @objc func filterText() {
        
        if let text = self.text {
            
            if text.count == 0 {
                
                filteredSource = datasource
                tblChoices.reloadData()
                
            } else {
                
                filteredSource = datasource.filter{$0.lowercased().contains(text.lowercased())}
                tblChoices.reloadData()
            }
        }
    }
    
}


extension SuggestField : UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        suggestDelegate?.suggestFieldDidBeginEditing(self)
        
        if self.datasource.isEmpty { return }
        self.filteredSource = self.datasource
        tblChoices.reloadData()
        tblChoices.isHidden = false
        
    }
    
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        tblChoices.isHidden = true
        self.shouldEndTextEditing = true
        self.resignFirstResponder()
        
        return true
    }
    
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if let text = self.text, self.restrictValues {
            
            if text.count == 0 && allowEmptyField {
                
                tblChoices.isHidden = true
                return true
                
            } else if !self.datasource.contains(text) {
                
                self.suggestDelegate?.alertNotInList(value: text)
                return false
                
            } else {
                
                tblChoices.isHidden = true
                return true
            }
        }
        
        tblChoices.isHidden = true
        shouldEndTextEditing = false
        
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        suggestDelegate?.suggestFieldDidEndEditing(self)
    }
    
}


extension SuggestField : UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = filteredSource[indexPath.row]
        cell?.backgroundColor = cellColor
        cell?.textLabel?.numberOfLines = 0
        
        return cell ?? UITableViewCell()
    }
}


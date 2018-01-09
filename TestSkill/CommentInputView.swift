//
//  CommentInputView.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 9/1/2018.
//  Copyright © 2018 Kwok Wai Yeung. All rights reserved.
//

import Foundation


protocol CommentInputViewDelegate {
    func handleSubmit(text:String)
}

class CommentInputView : UIView ,UITextViewDelegate {
    
    var delegate : CommentInputViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        self.backgroundColor = .white
        setupViewLayout()
    }
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewLayout(){
        self.addSubview(submitButton)
        submitButton.Anchor(top: topAnchor, left: nil, right: rightAnchor, bottom: nil, topPadding: 0, leftPadding: 0, rightPadding: 12, bottomPadding: 0, width: 50, height: 50)
        self.addSubview(self.commentTextField)
        commentTextField.Anchor(top: topAnchor, left: leftAnchor, right: submitButton.leftAnchor, bottom: bottomAnchor, topPadding: 0, leftPadding: 12, rightPadding: 0, bottomPadding: 0, width: 0)
        
        setupLineSeparatorView()
    }
    
    fileprivate func setupLineSeparatorView() {
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        addSubview(lineSeparatorView)
        lineSeparatorView.Anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0.5)
    }
    
    lazy var commentTextField: UITextView = {
        let tv = UITextView()
        tv.autocorrectionType = .no
        tv.spellCheckingType = .no
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.delegate = self
        tv.addSubview(self.placeholderLabel)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        self.placeholderLabel.Anchor(top: nil, left: tv.leftAnchor, right: nil, bottom: nil, topPadding: 0, leftPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        self.placeholderLabel.centerYAnchor.constraint(equalTo: tv.centerYAnchor).isActive = true
        return tv
    }()
    
    
    let submitButton : UIButton = {
        let sb = UIButton(type: .system)
        sb.setTitle("Submit", for: .normal)
        sb.setTitleColor(.black, for: .normal)
        sb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sb.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return sb
    }()
    
    lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Enter some text..."
        placeholderLabel.textColor = UIColor.lightGray
        return placeholderLabel
    }()

    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    @objc func handleSubmit(){
        guard let commentText = commentTextField.text else { return }
        delegate?.handleSubmit(text: commentText)
    }
    


    
}

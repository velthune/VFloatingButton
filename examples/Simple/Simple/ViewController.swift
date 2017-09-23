//
//  ViewController.swift
//  Simple
//
//  Created by Luca Davanzo on 08/07/16.
//  Copyright © 2017 Luca Davanzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, VFloatingButtonDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Private properties -
    
    private var floatingButton: VFloatingButton!
    
    // MARK: - Private outlets -
    
    @IBOutlet weak private var button: UIButton!
    @IBOutlet weak private var tableEntryAnimation: UITableView!
    @IBOutlet weak private var tableExitAnimation: UITableView!
    
    // MARK: - Private outlet constraints -
    
    @IBOutlet weak private var tableViewWidthConstraint: NSLayoutConstraint!
    
    // MARK: - View lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for t in [self.tableEntryAnimation, self.tableExitAnimation] {
            t?.delegate = self
            t?.dataSource = self
            t?.layer.borderColor = UIColor.gray.cgColor
            t?.layer.borderWidth = 1
        }
        self.setupFloatingButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableViewWidthConstraint.constant = self.view.frame.width / 2.0
    }
    
    private func setupFloatingButton() {
        var properties = VFloatingButtonProperties()
        properties.backgroundColor = .clear
        properties.viewButtonBackgroundColor = .clear
        properties.height = 60.0
        properties.width = 60.0
        properties.verticalMargin = 30.0
        properties.horizontalMargin = 20.0
        properties.entryAnimation = .bottom
        properties.exitAnimation = .bottom
        properties.animationOnTap = .magnify
        self.floatingButton = VFloatingButton(frameContainer: self.view.frame, properties: properties)
        self.floatingButton.delegate = self
        self.floatingButton.showBordersShadow(shadowOffset: 0.1)
        self.floatingButton.setImage(named: "icon", forState: .normal, contentMode: .scaleAspectFit)
        self.floatingButton.setImage(named: "icon", forState: .highlighted, contentMode: .scaleAspectFit)
        self.floatingButton.setImage(named: "icon", forState: .selected, contentMode: .scaleAspectFit)
        self.view.addSubview(self.floatingButton)
    }
    
    // MARK: - Floating button delegates -
    
    func floatingButtonWillDisappear(floatingButton: VFloatingButton) {
        self.button.setTitle("Show FAB", for: .normal)
    }
    
    func floatingButtonDidDisappear(floatingButton: VFloatingButton) {
        self.floatingButton.show(animated: false)
    }
    
    // MARK: - Table view datasource -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.row {
        case 0: cell.textLabel?.text = VFloatingButtonAnimationVersus.top.rawValue
        case 1: cell.textLabel?.text = VFloatingButtonAnimationVersus.bottom.rawValue
        case 2: cell.textLabel?.text = VFloatingButtonAnimationVersus.right.rawValue
        case 3: cell.textLabel?.text = VFloatingButtonAnimationVersus.left.rawValue
        case 4: cell.textLabel?.text = VFloatingButtonAnimationVersus.faraway.rawValue
        default:
            break
        }
        return cell
    }
    
    // MARK: - Table view delegates -
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var animation: VFloatingButtonAnimationVersus = .none
        switch indexPath.row {
        case 0: animation = .top
        case 1: animation = .bottom
        case 2: animation = .right
        case 3: animation = .left
        case 4: animation = .faraway
        default:
            break
        }
        if tableView == self.tableEntryAnimation {
            self.floatingButton.properties.entryAnimation = animation
        } else {
            self.floatingButton.properties.exitAnimation = animation
        }
        self.floatingButton.refresh()
    }
    
    // MARK: - IBActions -
    
    @IBAction func didTapOnButton(sender: AnyObject) {
        guard let button = sender as? UIButton else {
            return
        }
        if self.floatingButton.isVisible() {
            self.floatingButton.hide(animated: true)
            button.setTitle("Show FAB", for: .normal)
        } else {
            self.floatingButton.show(animated: true)
            button.setTitle("Hide FAB", for: .normal)
        }
    }
}

//
//  ViewController.swift
//  Ladder
//
//  Created by Aofei Sheng on 2018/3/23.
//  Copyright © 2018 Beijing Corestate Technology Co., Ltd. All rights reserved.
//

import KeychainAccess
import NetworkExtension
import UIKit

class ViewController: UITableViewController, UITextFieldDelegate {
	let mainKeychain = Keychain(service: Bundle.main.bundleIdentifier!)

	var sections = [TableViewSection]()

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.title = "Ladder"
		navigationController?.navigationBar.barStyle = .black
		navigationController?.navigationBar.tintColor = .white
		navigationController?.navigationBar.barTintColor = UIColor(red: 80 / 255, green: 140 / 255, blue: 240 / 255, alpha: 1)
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

		tableView.tableFooterView = UIView()
		tableView.sectionHeaderHeight = 20
		tableView.sectionFooterHeight = .leastNonzeroMagnitude
		tableView.rowHeight = 45
		tableView.separatorInset.left = 15

		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		gestureRecognizer.cancelsTouchesInView = false
		view.addGestureRecognizer(gestureRecognizer)

		let pacSection = TableViewSection()
		pacSection.headerHeight = 40
		pacSection.headerTitle = "PAC"
		sections.append(pacSection)

		let urlCell = TableViewCell(style: .textField)
		urlCell.textLabel?.text = "URL"
		urlCell.textField?.delegate = self
		urlCell.textField?.text = mainKeychain["pac_url"] ?? "https://aofei.org/pac"
		urlCell.textField?.keyboardType = .URL
		urlCell.textField?.textAlignment = .right
		urlCell.textField?.autocapitalizationType = .none
		urlCell.textField?.clearButtonMode = .never
		pacSection.cells.append(urlCell)

		let shadowsocksSection = TableViewSection()
		shadowsocksSection.headerHeight = 40
		shadowsocksSection.headerTitle = "Shadowsocks"
		sections.append(shadowsocksSection)

		let serverAddressCell = TableViewCell(style: .textField)
		serverAddressCell.textLabel?.text = "Server Address"
		serverAddressCell.textField?.delegate = self
		serverAddressCell.textField?.text = mainKeychain["shadowsocks_server_address"]
		serverAddressCell.textField?.keyboardType = .asciiCapable
		serverAddressCell.textField?.textAlignment = .right
		serverAddressCell.textField?.autocapitalizationType = .none
		serverAddressCell.textField?.clearButtonMode = .never
		shadowsocksSection.cells.append(serverAddressCell)

		let serverPortCell = TableViewCell(style: .textField)
		serverPortCell.textLabel?.text = "Server Port"
		serverPortCell.textField?.delegate = self
		serverPortCell.textField?.text = mainKeychain["shadowsocks_server_port"]
		serverPortCell.textField?.keyboardType = .numberPad
		serverPortCell.textField?.textAlignment = .right
		serverPortCell.textField?.clearButtonMode = .never
		shadowsocksSection.cells.append(serverPortCell)

		let localAddressCell = TableViewCell(style: .textField)
		localAddressCell.textLabel?.text = "Local Address"
		localAddressCell.textField?.delegate = self
		localAddressCell.textField?.text = mainKeychain["shadowsocks_local_address"] ?? "127.0.0.1"
		localAddressCell.textField?.keyboardType = .asciiCapable
		localAddressCell.textField?.textAlignment = .right
		localAddressCell.textField?.autocapitalizationType = .none
		localAddressCell.textField?.clearButtonMode = .never
		shadowsocksSection.cells.append(localAddressCell)

		let localPortCell = TableViewCell(style: .textField)
		localPortCell.textLabel?.text = "Local Port"
		localPortCell.textField?.delegate = self
		localPortCell.textField?.text = mainKeychain["shadowsocks_local_port"] ?? "1081"
		localPortCell.textField?.keyboardType = .numberPad
		localPortCell.textField?.textAlignment = .right
		localPortCell.textField?.clearButtonMode = .never
		shadowsocksSection.cells.append(localPortCell)

		let passwordCell = TableViewCell(style: .textField)
		passwordCell.textLabel?.text = "Password"
		passwordCell.textField?.delegate = self
		passwordCell.textField?.text = mainKeychain["shadowsocks_password"]
		passwordCell.textField?.keyboardType = .asciiCapable
		passwordCell.textField?.textAlignment = .right
		passwordCell.textField?.autocapitalizationType = .none
		passwordCell.textField?.clearButtonMode = .never
		shadowsocksSection.cells.append(passwordCell)

		let methodCell = TableViewCell(style: .textField)
		methodCell.textLabel?.text = "Method"
		methodCell.textField?.delegate = self
		methodCell.textField?.text = mainKeychain["shadowsocks_method"] ?? "AES-256-CFB"
		methodCell.textField?.keyboardType = .asciiCapable
		methodCell.textField?.textAlignment = .right
		methodCell.textField?.clearButtonMode = .never
		shadowsocksSection.cells.append(methodCell)

		let configureSection = TableViewSection()
		sections.append(configureSection)

		let configureCell = TableViewCell(style: .button)
		configureCell.textLabel?.text = "Configure"
		configureCell.didSelect = {
			let pacURL = urlCell.textField!.text!
			if pacURL.count == 0 || URL(string: pacURL) == nil {
				let alertController = UIAlertController(title: "Configuration Failed", message: "Please enter a valid PAC URL.", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "OK", style: .default))
				self.present(alertController, animated: true)
				return
			}

			let shadowsocksServerAddress = serverAddressCell.textField!.text!
			if shadowsocksServerAddress.count == 0 {
				let alertController = UIAlertController(title: "Configuration Failed", message: "Please enter a valid Shadowsocks server address.", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "OK", style: .default))
				self.present(alertController, animated: true)
				return
			}

			guard let shadowsocksServerPort = UInt16(serverPortCell.textField!.text!) else {
				let alertController = UIAlertController(title: "Configuration Failed", message: "Please enter a valid Shadowsocks server port", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "OK", style: .default))
				self.present(alertController, animated: true)
				return
			}

			let shadowsocksLocalAddress = localAddressCell.textField!.text!
			if shadowsocksLocalAddress.count == 0 {
				let alertController = UIAlertController(title: "Configuration Failed", message: "Please enter a valid Shadowsocks local address.", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "OK", style: .default))
				self.present(alertController, animated: true)
				return
			}

			guard let shadowsocksLocalPort = UInt16(localPortCell.textField!.text!) else {
				let alertController = UIAlertController(title: "Configuration Failed", message: "Please enter a valid Shadowsocks local port", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "OK", style: .default))
				self.present(alertController, animated: true)
				return
			}

			let shadowsocksPassword = passwordCell.textField!.text!
			if shadowsocksPassword.count == 0 {
				let alertController = UIAlertController(title: "Configuration Failed", message: "Please enter a valid Shadowsocks password.", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "OK", style: .default))
				self.present(alertController, animated: true)
				return
			}

			let shadowsocksMethod = methodCell.textField!.text!
			if shadowsocksMethod.count == 0 {
				let alertController = UIAlertController(title: "Configuration Failed", message: "Please enter a valid Shadowsocks method.", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "OK", style: .default))
				self.present(alertController, animated: true)
				return
			}

			configureCell.isDisabled = true
			NETunnelProviderManager.loadAllFromPreferences { providerManagers, _ in
				configureCell.isDisabled = false
				if let providerManagers = providerManagers {
					let configuringAlertController = UIAlertController(title: "Configuring...", message: nil, preferredStyle: .alert)
					self.present(configuringAlertController, animated: true)

					var providerManager = NETunnelProviderManager()
					if providerManagers.count > 0 {
						providerManager = providerManagers[0]
						if providerManagers.count > 1 {
							for index in 1 ..< providerManagers.count {
								providerManagers[index].removeFromPreferences()
							}
						}
					}

					let providerConfiguration = NETunnelProviderProtocol()
					providerConfiguration.serverAddress = "Ladder"
					providerConfiguration.providerConfiguration = [
						"pac_url": pacURL,
						"shadowsocks_server_address": shadowsocksServerAddress,
						"shadowsocks_server_port": shadowsocksServerPort,
						"shadowsocks_local_address": shadowsocksLocalAddress,
						"shadowsocks_local_port": shadowsocksLocalPort,
						"shadowsocks_password": shadowsocksPassword,
						"shadowsocks_method": shadowsocksMethod,
					]

					providerManager.localizedDescription = "Ladder"
					providerManager.protocolConfiguration = providerConfiguration
					providerManager.isEnabled = true
					providerManager.saveToPreferences { error in
						if error == nil {
							self.mainKeychain["pac_url"] = pacURL
							self.mainKeychain["shadowsocks_server_address"] = shadowsocksServerAddress
							self.mainKeychain["shadowsocks_server_port"] = String(stringInterpolationSegment: shadowsocksServerPort)
							self.mainKeychain["shadowsocks_local_address"] = shadowsocksLocalAddress
							self.mainKeychain["shadowsocks_local_port"] = String(stringInterpolationSegment: shadowsocksLocalPort)
							self.mainKeychain["shadowsocks_password"] = shadowsocksPassword
							self.mainKeychain["shadowsocks_method"] = shadowsocksMethod
						}
						configuringAlertController.dismiss(animated: true) {
							let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
							if error != nil {
								alertController.title = "Configuration Failed"
								alertController.message = "Please try again."
								alertController.addAction(UIAlertAction(title: "OK", style: .default))
							} else {
								alertController.title = "Configured!"
							}
							self.present(alertController, animated: true) {
								if error == nil {
									DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
										alertController.dismiss(animated: true)
									}
								}
							}
						}
					}
				}
			}
		}
		configureSection.cells.append(configureCell)
	}

	@objc func dismissKeyboard() {
		view.endEditing(true)
	}

	override func numberOfSections(in _: UITableView) -> Int {
		return sections.count
	}

	override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].cells.count
	}

	override func tableView(_: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		let header = view as! UITableViewHeaderFooterView
		header.textLabel?.text = sections[section].headerTitle
		header.textLabel?.font = .systemFont(ofSize: 15)
	}

	override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sections[section].headerTitle
	}

	override func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if let headerHeight = sections[section].headerHeight {
			return headerHeight
		}
		return tableView.sectionHeaderHeight
	}

	override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return sections[indexPath.section].cells[indexPath.row]
	}

	override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if let rowHeight = sections[indexPath.section].cells[indexPath.row].rowHeight {
			return rowHeight
		}
		return tableView.rowHeight
	}

	override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)

		let cell = sections[indexPath.section].cells[indexPath.row]
		if cell.isDisabled == nil || !cell.isDisabled! {
			cell.didSelect?()
		}
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

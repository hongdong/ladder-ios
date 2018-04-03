//
//  ViewController.swift
//  Ladder
//
//  Created by Aofei Sheng on 2018/3/23.
//  Copyright © 2018 Beijing Corestate Technology Co., Ltd. All rights reserved.
//

import Eureka
import KeychainAccess
import NetworkExtension

class ViewController: FormViewController {
	let mainKeychain = Keychain(service: Bundle.main.bundleIdentifier!)

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.title = "Ladder"
		navigationController?.navigationBar.barStyle = .black
		navigationController?.navigationBar.tintColor = .white
		navigationController?.navigationBar.barTintColor = UIColor(red: 80 / 255, green: 140 / 255, blue: 240 / 255, alpha: 1)
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

		form
			+++ Section { section in
				section.tag = "PAC"
				section.header = HeaderFooterView(title: "PAC")
				section.header?.height = { 33 }
			}
			<<< TextRow { row in
				row.tag = "PAC URL"
				row.title = "URL"
				row.placeholder = "Enter URL here"
				row.value = mainKeychain["pac_url"] ?? "https://aofei.org/pac"
				row.cell.textField.keyboardType = .URL
				row.cell.textField.autocapitalizationType = .none
			}

			+++ Section { section in
				section.tag = "Shadowsocks"
				section.header = HeaderFooterView(title: "Shadowsocks")
				section.header?.height = { 15 }
			}
			<<< TextRow { row in
				row.tag = "Shadowsocks Server Address"
				row.title = "Server Address"
				row.placeholder = "Enter server address here"
				row.value = mainKeychain["shadowsocks_server_address"]
				row.cell.textField.keyboardType = .asciiCapable
				row.cell.textField.autocapitalizationType = .none
			}
			<<< TextRow { row in
				row.tag = "Shadowsocks Server Port"
				row.title = "Server Port"
				row.placeholder = "Enter server port here"
				row.value = mainKeychain["shadowsocks_server_port"]
				row.cell.textField.keyboardType = .numberPad
				row.cell.textField.autocapitalizationType = .none
			}
			<<< TextRow { row in
				row.tag = "Shadowsocks Local Address"
				row.title = "Local Address"
				row.placeholder = "Enter local address here"
				row.value = mainKeychain["shadowsocks_local_address"] ?? "127.0.0.1"
				row.cell.textField.keyboardType = .asciiCapable
				row.cell.textField.autocapitalizationType = .none
			}
			<<< TextRow { row in
				row.tag = "Shadowsocks Local Port"
				row.title = "Local Port"
				row.placeholder = "Enter local port here"
				row.value = mainKeychain["shadowsocks_local_port"] ?? "1081"
				row.cell.textField.keyboardType = .numberPad
				row.cell.textField.autocapitalizationType = .none
			}
			<<< TextRow { row in
				row.tag = "Shadowsocks Password"
				row.title = "Password"
				row.placeholder = "Enter password here"
				row.value = mainKeychain["shadowsocks_password"]
				row.cell.textField.keyboardType = .asciiCapable
				row.cell.textField.autocapitalizationType = .none
			}
			<<< ActionSheetRow<String> { row in
				row.tag = "Shadowsocks Method"
				row.title = "Method"
				row.selectorTitle = "Method"
				row.options = ["AES-256-CFB"]
				row.value = mainKeychain["shadowsocks_method"] ?? "AES-256-CFB"
			}

			+++ Section { section in
				section.header = HeaderFooterView(title: "")
				section.header?.height = { 15 }
			}
			<<< ButtonRow { row in
				row.title = "Configure"
				row.cell.height = { 50 }
			}.onCellSelection { _, _ in
				guard let pacURL = (self.form.rowBy(tag: "PAC URL") as? TextRow)?.value, URL(string: pacURL) != nil else {
					let alertController = UIAlertController(title: "Configuration Failed", message: "Please enter a valid PAC URL.", preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "OK", style: .default))
					self.present(alertController, animated: true)
					return
				}

				guard let shadowsocksServerAddress = (self.form.rowBy(tag: "Shadowsocks Server Address") as? TextRow)?.value else {
					let alertController = UIAlertController(title: "Configuration Failed", message: "Please enter a valid Shadowsocks server address.", preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "OK", style: .default))
					self.present(alertController, animated: true)
					return
				}

				guard let shadowsocksServerPort = UInt16((self.form.rowBy(tag: "Shadowsocks Server Port") as? TextRow)?.value ?? "") else {
					let alertController = UIAlertController(title: "Configuration Failed", message: "Please enter a valid Shadowsocks server port.", preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "OK", style: .default))
					self.present(alertController, animated: true)
					return
				}

				guard let shadowsocksLocalAddress = (self.form.rowBy(tag: "Shadowsocks Local Address") as? TextRow)?.value else {
					let alertController = UIAlertController(title: "Configuration Failed", message: "Please enter a valid Shadowsocks local address.", preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "OK", style: .default))
					self.present(alertController, animated: true)
					return
				}

				guard let shadowsocksLocalPort = UInt16((self.form.rowBy(tag: "Shadowsocks Local Port") as? TextRow)?.value ?? "") else {
					let alertController = UIAlertController(title: "Configuration Failed", message: "Please enter a valid Shadowsocks local port.", preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "OK", style: .default))
					self.present(alertController, animated: true)
					return
				}

				guard let shadowsocksPassword = (self.form.rowBy(tag: "Shadowsocks Password") as? TextRow)?.value else {
					let alertController = UIAlertController(title: "Configuration Failed", message: "Please enter a valid Shadowsocks password.", preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "OK", style: .default))
					self.present(alertController, animated: true)
					return
				}

				guard let shadowsocksMethod = (self.form.rowBy(tag: "Shadowsocks Method") as? ActionSheetRow<String>)?.value else {
					let alertController = UIAlertController(title: "Configuration Failed", message: "Please enter a valid Shadowsocks method.", preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "OK", style: .default))
					self.present(alertController, animated: true)
					return
				}

				NETunnelProviderManager.loadAllFromPreferences { providerManagers, _ in
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
	}
}

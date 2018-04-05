//
//  ViewController.swift
//  Ladder
//
//  Created by Aofei Sheng on 2018/3/23.
//  Copyright © 2018 Aofei Sheng. All rights reserved.
//

import CoreTelephony
import Eureka
import KeychainAccess
import NetworkExtension

class ViewController: FormViewController {
	let mainKeychain = Keychain(service: Bundle.main.bundleIdentifier!)

	var notRestrictedCellularData = false
	var restrictedCellularDataAlertTimes = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.title = NSLocalizedString("Ladder", comment: "")
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Icons/Info"), style: .plain, target: self, action: #selector(openInfo))
		navigationController?.navigationBar.barStyle = .black
		navigationController?.navigationBar.tintColor = .white
		navigationController?.navigationBar.barTintColor = UIColor(red: 80 / 255, green: 140 / 255, blue: 240 / 255, alpha: 1)
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

		CTCellularData().cellularDataRestrictionDidUpdateNotifier = { state in
			self.notRestrictedCellularData = state == .notRestricted
		}

		form
			+++ Section { section in
				section.tag = "PAC"
				section.header = HeaderFooterView(title: NSLocalizedString("PAC", comment: ""))
				section.header?.height = { 33 }
			}
			<<< TextRow { row in
				row.tag = "PAC URL"
				row.title = "URL"
				row.placeholder = NSLocalizedString("Enter URL here", comment: "")
				row.value = mainKeychain["pac_url"] ?? "https://aofei.org/pac?proxies=SOCKS5+127.0.0.1%3A1081%3B+SOCKS+127.0.0.1%3A1081%3B+DIRECT%3B"
				row.cell.textField.keyboardType = .URL
				row.cell.textField.autocapitalizationType = .none
			}

			+++ Section { section in
				section.tag = "Shadowsocks"
				section.header = HeaderFooterView(title: NSLocalizedString("Shadowsocks", comment: ""))
				section.header?.height = { 15 }
			}
			<<< TextRow { row in
				row.tag = "Shadowsocks Server Address"
				row.title = NSLocalizedString("Server Address", comment: "")
				row.placeholder = NSLocalizedString("Enter server address here", comment: "")
				row.value = mainKeychain["shadowsocks_server_address"]
				row.cell.textField.keyboardType = .asciiCapable
				row.cell.textField.autocapitalizationType = .none
			}
			<<< TextRow { row in
				row.tag = "Shadowsocks Server Port"
				row.title = NSLocalizedString("Server Port", comment: "")
				row.placeholder = NSLocalizedString("Enter server port here", comment: "")
				row.value = mainKeychain["shadowsocks_server_port"]
				row.cell.textField.keyboardType = .numberPad
				row.cell.textField.autocapitalizationType = .none
			}
			<<< TextRow { row in
				row.tag = "Shadowsocks Local Address"
				row.title = NSLocalizedString("Local Address", comment: "")
				row.placeholder = NSLocalizedString("Enter local address here", comment: "")
				row.value = mainKeychain["shadowsocks_local_address"] ?? "127.0.0.1"
				row.cell.textField.keyboardType = .asciiCapable
				row.cell.textField.autocapitalizationType = .none
			}
			<<< TextRow { row in
				row.tag = "Shadowsocks Local Port"
				row.title = NSLocalizedString("Local Port", comment: "")
				row.placeholder = NSLocalizedString("Enter local port here", comment: "")
				row.value = mainKeychain["shadowsocks_local_port"] ?? "1081"
				row.cell.textField.keyboardType = .numberPad
				row.cell.textField.autocapitalizationType = .none
			}
			<<< PasswordRow { row in
				row.tag = "Shadowsocks Password"
				row.title = NSLocalizedString("Password", comment: "")
				row.placeholder = NSLocalizedString("Enter password here", comment: "")
				row.value = mainKeychain["shadowsocks_password"]
				row.cell.textField.keyboardType = .asciiCapable
				row.cell.textField.autocapitalizationType = .none
			}
			<<< ActionSheetRow<String> { row in
				row.tag = "Shadowsocks Method"
				row.title = NSLocalizedString("Method", comment: "")
				row.selectorTitle = NSLocalizedString("Shadowsocks Method", comment: "")
				row.options = ["AES-128-CFB", "AES-192-CFB", "AES-256-CFB", "ChaCha20", "Salsa20", "RC4-MD5"]
				row.value = mainKeychain["shadowsocks_method"] ?? "AES-256-CFB"
				row.cell.detailTextLabel?.textColor = .black
			}

			+++ Section { section in
				section.header = HeaderFooterView(title: "")
				section.header?.height = { 15 }
			}
			<<< ButtonRow { row in
				row.title = NSLocalizedString("Configure", comment: "")
				row.cell.height = { 50 }
			}.onCellSelection { _, _ in
				if !self.notRestrictedCellularData {
					let alertController = UIAlertController(
						title: NSLocalizedString("Configuration Failed", comment: ""),
						message: nil,
						preferredStyle: .alert
					)
					if self.restrictedCellularDataAlertTimes < 2 {
						alertController.message = NSLocalizedString("Please allow Ladder to access your wireless data in the system's \"Settings - Cellular\" option (remember to check the \"WLAN & Cellular Data\").", comment: "")
						self.restrictedCellularDataAlertTimes += 1
					} else {
						alertController.message = NSLocalizedString("You must restart your device so that Ladder can access your wireless data if you are in the China network and have Ladder installed for the very first time.", comment: "")
					}
					alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
					self.present(alertController, animated: true)
					return
				}

				guard let pacURL = (self.form.rowBy(tag: "PAC URL") as? TextRow)?.value, URL(string: pacURL) != nil else {
					let alertController = UIAlertController(
						title: NSLocalizedString("Configuration Failed", comment: ""),
						message: NSLocalizedString("Please enter a valid PAC URL.", comment: ""),
						preferredStyle: .alert
					)
					alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
					self.present(alertController, animated: true)
					return
				}

				guard let shadowsocksServerAddress = (self.form.rowBy(tag: "Shadowsocks Server Address") as? TextRow)?.value else {
					let alertController = UIAlertController(
						title: NSLocalizedString("Configuration Failed", comment: ""),
						message: NSLocalizedString("Please enter a valid Shadowsocks server address.", comment: ""),
						preferredStyle: .alert
					)
					alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
					self.present(alertController, animated: true)
					return
				}

				guard let shadowsocksServerPort = UInt16((self.form.rowBy(tag: "Shadowsocks Server Port") as? TextRow)?.value ?? "") else {
					let alertController = UIAlertController(
						title: NSLocalizedString("Configuration Failed", comment: ""),
						message: NSLocalizedString("Please enter a valid Shadowsocks server port.", comment: ""),
						preferredStyle: .alert
					)
					alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
					self.present(alertController, animated: true)
					return
				}

				guard let shadowsocksLocalAddress = (self.form.rowBy(tag: "Shadowsocks Local Address") as? TextRow)?.value else {
					let alertController = UIAlertController(
						title: NSLocalizedString("Configuration Failed", comment: ""),
						message: NSLocalizedString("Please enter a valid Shadowsocks local address.", comment: ""),
						preferredStyle: .alert
					)
					alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
					self.present(alertController, animated: true)
					return
				}

				guard let shadowsocksLocalPort = UInt16((self.form.rowBy(tag: "Shadowsocks Local Port") as? TextRow)?.value ?? "") else {
					let alertController = UIAlertController(
						title: NSLocalizedString("Configuration Failed", comment: ""),
						message: NSLocalizedString("Please enter a valid Shadowsocks local port.", comment: ""),
						preferredStyle: .alert
					)
					alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
					self.present(alertController, animated: true)
					return
				}

				guard let shadowsocksPassword = (self.form.rowBy(tag: "Shadowsocks Password") as? PasswordRow)?.value else {
					let alertController = UIAlertController(
						title: NSLocalizedString("Configuration Failed", comment: ""),
						message: NSLocalizedString("Please enter a valid Shadowsocks password.", comment: ""),
						preferredStyle: .alert
					)
					alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
					self.present(alertController, animated: true)
					return
				}

				guard let shadowsocksMethod = (self.form.rowBy(tag: "Shadowsocks Method") as? ActionSheetRow<String>)?.value else {
					let alertController = UIAlertController(
						title: NSLocalizedString("Configuration Failed", comment: ""),
						message: NSLocalizedString("Please select a valid Shadowsocks method.", comment: ""),
						preferredStyle: .alert
					)
					alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
					self.present(alertController, animated: true)
					return
				}

				NETunnelProviderManager.loadAllFromPreferences { providerManagers, _ in
					if let providerManagers = providerManagers {
						let configuringAlertController = UIAlertController(
							title: NSLocalizedString("Configuring...", comment: ""),
							message: nil,
							preferredStyle: .alert
						)
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

						providerManager.localizedDescription = NSLocalizedString("Ladder", comment: "")
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
								providerManager.loadFromPreferences { error in
									if error == nil {
										providerManager.connection.stopVPNTunnel()
										DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
											try? providerManager.connection.startVPNTunnel()
										}
									}
								}
							}
							configuringAlertController.dismiss(animated: true) {
								let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
								if error != nil {
									alertController.title = NSLocalizedString("Configuration Failed", comment: "")
									alertController.message = NSLocalizedString("Please try again.", comment: "")
									alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
								} else {
									alertController.title = NSLocalizedString("Configured!", comment: "")
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

	@objc func openInfo() {
		UIApplication.shared.openURL(URL(string: "https://aofei.org/posts/2018-04-05-immersive-wallless-experience")!)
	}
}

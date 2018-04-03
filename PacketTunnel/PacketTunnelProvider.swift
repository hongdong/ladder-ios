//
//  PacketTunnelProvider.swift
//  PacketTunnel
//
//  Created by Aofei Sheng on 2018/3/23.
//  Copyright © 2018 Beijing Corestate Technology Co., Ltd. All rights reserved.
//

import NetworkExtension

class PacketTunnelProvider: NEPacketTunnelProvider {
	var shadowsocks: Shadowsocks?

	override func startTunnel(options _: [String: NSObject]?, completionHandler: @escaping (Error?) -> Void) {
		guard let providerConfiguration = (self.protocolConfiguration as? NETunnelProviderProtocol)?.providerConfiguration,
			let pacURL = providerConfiguration["pac_url"] as? String,
			let shadowsocksServerAddress = providerConfiguration["shadowsocks_server_address"] as? String,
			let shadowsocksServerPort = providerConfiguration["shadowsocks_server_port"] as? UInt16,
			let shadowsocksLocalAddress = providerConfiguration["shadowsocks_local_address"] as? String,
			let shadowsocksLocalPort = providerConfiguration["shadowsocks_local_port"] as? UInt16,
			let shadowsocksPassword = providerConfiguration["shadowsocks_password"] as? String,
			let shadowsocksMethod = providerConfiguration["shadowsocks_method"] as? String else {
			completionHandler(nil)
			return
		}

		shadowsocks = Shadowsocks(
			serverAddress: shadowsocksServerAddress,
			serverPort: shadowsocksServerPort,
			localAddress: shadowsocksLocalAddress,
			localPort: shadowsocksLocalPort,
			password: shadowsocksPassword,
			method: shadowsocksMethod
		)

		let proxySettings = NEProxySettings()
		proxySettings.autoProxyConfigurationEnabled = true
		proxySettings.proxyAutoConfigurationURL = URL(string: pacURL)
		proxySettings.excludeSimpleHostnames = true
		proxySettings.matchDomains = [""]

		let networkSettings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "8.8.8.8")
		networkSettings.proxySettings = proxySettings
		networkSettings.ipv4Settings = NEIPv4Settings(addresses: ["10.0.0.1"], subnetMasks: ["255.255.255.0"])
		networkSettings.mtu = 1500

		setTunnelNetworkSettings(networkSettings) { error in
			if error == nil {
				do {
					try self.shadowsocks?.start()
				} catch let error {
					completionHandler(error)
					return
				}
			}
			completionHandler(error)
		}
	}

	override func stopTunnel(with _: NEProviderStopReason, completionHandler: @escaping () -> Void) {
		shadowsocks?.stop()
		completionHandler()
	}
}

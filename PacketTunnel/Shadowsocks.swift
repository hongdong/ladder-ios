//
//  Shadowsocks.swift
//  PacketTunnel
//
//  Created by Aofei Sheng on 2018/3/23.
//  Copyright © 2018 Beijing Corestate Technology Co., Ltd. All rights reserved.
//

import CryptoSwift

class Shadowsocks {
	let serverAddress: String
	let serverPort: UInt16
	let localAddress: String
	let localPort: UInt16
	let password: String
	let method: String
	let cipher: Cipher

	init(serverAddress: String, serverPort: UInt16, localAddress: String, localPort: UInt16, password: String, method: String) {
		self.serverAddress = serverAddress
		self.serverPort = serverPort
		self.localAddress = localAddress
		self.localPort = localPort
		self.password = password
		self.method = method

		switch method {
		default: // "AES-256-CFB"
			var key = Data(count: 48)
			let passwordData = password.data(using: String.Encoding.utf8)!
			var passwordMD5Data = passwordData.md5()
			var extendPasswordData = Data(count: passwordData.count + passwordMD5Data.count)
			extendPasswordData.replaceSubrange(passwordMD5Data.count ..< extendPasswordData.count, with: passwordData)
			var length = 0
			repeat {
				let copyLength = min(key.count - length, passwordMD5Data.count)
				key.withUnsafeMutableBytes {
					passwordMD5Data.copyBytes(to: $0.advanced(by: length), count: copyLength)
				}
				extendPasswordData.replaceSubrange(0 ..< passwordMD5Data.count, with: passwordMD5Data)
				passwordMD5Data = extendPasswordData.md5()
				length += copyLength
			} while length < key.count
			key = key.subdata(in: 0 ..< 32)
			var iv = Data(count: 16)
			for index in 0 ..< iv.count {
				iv[index] = UInt8(arc4random_uniform(256))
			}
			cipher = try! AES(key: key.bytes, blockMode: .CFB(iv: iv.bytes))
		}
	}

	func start() throws {
	}

	func stop() {
	}
}

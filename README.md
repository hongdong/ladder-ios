# Ladder

A solution for the IWE (Immersive Wallless Experience) on iOS platform.

Keep in mind:

> The scenery outside the wall is beautiful and dangerous.

## Features

* Hide VPN Icon
* PAC (Proxy auto-config)
* Multiple Shadowsocks Method
	* `AES-128-CFB`
	* `AES-192-CFB`
	* `AES-256-CFB` **(RECOMMENDED)**
	* `ChaCha20`
	* `Salsa20`
	* `RC4-MD5`

## Requirements

* iOS 9.3+
* Xcode 9.3+
* [Apple Developer Program](https://developer.apple.com/programs)
* [Carthage](https://github.com/carthage/carthage)

## Installation

1. Check out the latest version of the project:

```bash
$ git clone https://github.com/sheng/ladder-ios.git
```

2. Enter the project directory, check out the project's dependencies:

```bash
$ cd ladder-ios
$ carthage update --no-use-binaries --platform ios
```

3. Open the `Ladder.xcodeproj`.

4. Build and run the `Ladder` scheme.

5. Enjoy yourself.

## Community

If you want to discuss this project, or ask questions about it, simply post
questions or ideas [here](https://github.com/sheng/ladder-ios/issues).

## Contributing

If you want to help build this project, simply send pull requests
[here](https://github.com/sheng/ladder-ios/pulls).

## License

This project is licensed under the Unlicense.

License can be found [here](LICENSE).

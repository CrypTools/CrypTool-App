//
//  HashShift.swift
//  CrypTools
//
//  Created by Arthur Guiot on 18/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

/*********************************
*
* Use: "hello".encrypt(12).decrypt(12)
*
*********************************/
import Foundation


// HashShift lib
class PRNG {
	var s: Int;
	init(_ s: Int) {
		self.s = s
	}
	func rand() -> Float {
		let hash = String(self.s).sha256.prefix(10)
		let n = Int(hash, radix: 16)
		let r = (n! >> 13 * self.s) % 99371
		self.s = (r ^ n! << 2 + n!) % 70937
		return Float(abs(r)) / 99371
	}
}

extension Int {
	func genKey(_ c: Int) -> String {
		var gen = PRNG(self) // seed
		func getRandomNum(_ max: Int) -> Int {
			var c = gen.rand() * Float(max)
			c.round(.down)
			return Int(c)
		}
		let alphabet = Array("abcdefghijklmnopqrstuvwxyz")
		var out = "";
		for _ in 1...c {
			out += String(alphabet[getRandomNum(25)])
		}
		return out;
	}
}
extension String {
	func HashShiftEncrypt (_ k: Int) -> String {
		if self.count == 0 {
			return ""
		}
		let key = k.genKey(self.count)
		let alphabet = Array("abcdefghijklmnopqrstuvwxyz")
        let nText = Array(self.lowercased())
        let kText = Array(key.lowercased())
		var out = "";
		for i in 0...nText.count - 1 {
			if alphabet.contains(nText[i]) {
                out += String(alphabet[(alphabet.firstIndex(of: nText[i])! + alphabet.firstIndex(of: kText[i])!) % 26])
			} else {
				out += String(nText[i])
			}
		}
		return out;
	}
	func HashShiftDecrypt (_ k: Int) -> String {
		if self.count == 0 {
			return ""
		}
		let key = k.genKey(self.count)
		let alphabet = Array("abcdefghijklmnopqrstuvwxyz")
        let nText = Array(self.lowercased())
        let kText = Array(key.lowercased())
		var out = "";
		for i in 0...nText.count - 1 {
			if alphabet.contains(nText[i]) {
                let op = (alphabet.firstIndex(of: nText[i])! - alphabet.firstIndex(of: kText[i])!)
				out += String(alphabet[op < 0 ? 26 + op : op % 26])
			} else {
				out += String(nText[i])
			}
		}
		return out;
	}
}

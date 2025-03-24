//
//  WithdrawRequestDto.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 3/24/25.
//

import Foundation

struct WithdrawRequestDto: Encodable {
    let deviceToken: String
    let accessToken: String
}

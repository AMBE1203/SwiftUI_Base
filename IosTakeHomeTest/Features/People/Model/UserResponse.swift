//
//  UserResponse.swift
//  IosTakeHomeTest
//
//  Created by AMBE on 10/11/2022.
//

// MARK: - UserResponse
struct UserResponse: Codable {
    let page, perPage, total, totalPages: Int
    let data: [User]
    let support: Support

}

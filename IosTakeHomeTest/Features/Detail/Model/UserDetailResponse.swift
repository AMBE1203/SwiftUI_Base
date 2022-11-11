//
//  UserDetailResponse.swift
//  IosTakeHomeTest
//
//  Created by AMBE on 09/11/2022.
//

// MARK: - UserDetailResponse
struct UserDetailResponse: Codable {
    let data: User
    let support: Support
}

// MARK: - User
struct User: Codable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String

}

// MARK: - Support
struct Support: Codable {
    let url: String
    let text: String
}

//
//  Struct.swift
//  LoginRegister
//
//  Created by Joker on 2020/4/15.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case Error
}

enum GetProfileError: Error {
    case GPErr
}

enum GetPhotoURLError: Error {
    case GPUErr
}

struct Profile: Codable{
    var login:String
    var firstName:String
    var lastName:String
}

struct User: Codable{
    var id:String
    var profile: Profile
}

struct Embedded: Codable{
    var user:User
}

struct LoginDec: Codable {
    var status:String
    var sessionToken:String
    var _embedded: Embedded
}

struct ProfileR: Codable{
    var firstName:String
    var lastName:String
    var email:String
    var login:String
    var birthday:String
    var profileUrl:String
}

struct Password: Encodable {
    var value:String
}

struct Credentials: Encodable{
    var password: Password
}

struct RegisterDec: Codable {
    var status:String
    var id:String
    var profile:ProfileR
}

struct ProfileUG: Codable {
    var firstName:String
    var lastName:String
    var email:String
    var login:String
    var birthday:String
    var profileUrl:String
}

struct UGProfileDec: Codable{
    var id:String
    var status:String
    var created:String
    var lastLogin:String
    var profile:ProfileUG
}

struct UploadImageResult: Decodable {
    struct UIRData: Decodable {
        let link: String
    }
    let data: UIRData
}

struct MProfile: Codable{
    var firstName:String?
    var lastName:String?
    var birthday:String?
    var profileUrl:String?
}

struct OPD: Codable {
    var value:String
}

struct NPD: Codable {
    var value:String
}

struct Provider: Codable {
    var type:String
    var name:String
}

struct MPDDec: Codable {
    var provider:Provider
}

struct FindLoginProfile: Codable {
    var login:String
    var email:String
}

struct AllUserDec: Codable {
    var id:String
    var status:String
    var profile:FindLoginProfile
}

struct Recovery_Q: Codable {
    var question:String
    var answer:String
}

struct CRQDec: Codable {
    var provider:Provider
}

struct FPDec: Codable {
    var resetPasswordUrl:String
}

struct MyData: Codable{
    var userID:String
    var userName:String
    var time:String
    var content:String
    var pictureURL:String
    var pictureURL2:String
    var location:String
}

struct NewPostData: Codable{
    var data:MyData
}

struct PostDec: Codable {
    var created:Int
}

struct ImgurData: Decodable {
    var link:String
}

struct ImgurDec: Decodable {
    var data:ImgurData
    var success:Bool
}



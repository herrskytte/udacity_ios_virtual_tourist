//
//  Method: https://onthemap-api.udacity.com/v1/session
// Method Type: POST
// Required Parameters:
// udacity - (Dictionary) a dictionary containing a username/password pair used for authentication
//    username - (String) the username (email) for a Udacity student
// password - (String) the password for a Udacity student

import Foundation

struct LoginRequest: Codable {
    let udacity: CredentialsRequest
}

struct CredentialsRequest: Codable {
    let username: String
    let password: String
}

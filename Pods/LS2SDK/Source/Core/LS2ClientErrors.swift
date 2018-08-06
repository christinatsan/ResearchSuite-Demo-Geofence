//
//  LS2ClientErrors.swift
//  LS2SDK
//
//  Created by James Kizer on 12/26/17.
//
//
// Copyright 2018, Curiosity Health Company
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit

import UIKit

public enum LS2ClientError: Error {
    
    //our errors
    
    case serverError
    
    //credentials failure : signIn
    case credentialsFailure(descrition: String)
    //invalid access token: postSample
    case invalidAuthToken
//    //invalid refresh token: refreshAccessToken
//    case invalidRefreshToken
    
    //we've already uploaded a datapoint with this id
    //server returns a 409
    case dataPointConflict
    
    //server returns a 502
    case badGatewayError
    
    //invalid response for signIn / refreshAccessToken
    //e.g., expected field missing in json
    case malformedResponse(responseBody: Any)
    
    //other errors to watch out for
    
    //unreachable
    //convert into our own
    case unreachableError(underlyingError: NSError?)
    
    //others
    case otherError(underlyingError: NSError?)
    
    //If datapoint fails json serialization
    case invalidDatapoint
    
    case unknownError
}

extension LS2ClientError {
    
    /// The `underlyingError` associated with the error.
    public var underlyingError: NSError? {
        switch self {
        case .unreachableError(let error):
            return error
        case .otherError(let error):
            return error
        default:
            return nil
        }
    }
    
    public var malformedResponseBody: Any? {
        switch self {
        case .malformedResponse(let responseBody):
            return responseBody
        default:
            return nil
        }
    }
    
}

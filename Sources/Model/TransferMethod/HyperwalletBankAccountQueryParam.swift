//
// Copyright 2018 - Present Hyperwallet
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software
// and associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute,
// sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
// BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation

/// Representation of the bank account query parameters.
public class HyperwalletBankAccountQueryParam: HyperwalletTransferMethodQueryParam {
    /// The bank account type.
    public var type: QueryType?

    /// Represents the Bank Account types.
    public enum QueryType: String {
        /// The Bank account type
        case bankAccount = "BANK_ACCOUNT"
        /// The Wire account type
        case wireAccount = "WIRE_ACCOUNT"
    }

    enum QueryParam: String {
        case type
    }

    /// Representation of the bank account status
    public enum QueryStatus: String {
        /// Filter by activated bank accounts
        case activated = "ACTIVATED"
        /// Filter by deActivated bank accounts
        case deActivated = "DE_ACTIVATED"
        /// Filter only invalid bank accounts
        case invalid = "INVALID"
        /// Filter only verified bank accounts
        case verified = "VERIFIED"
    }

    override public func toQuery() -> [String: String] {
        var query = super.toQuery()
        if let type = type {
            query[QueryParam.type.rawValue] = type.rawValue
        }

        return query
    }
}

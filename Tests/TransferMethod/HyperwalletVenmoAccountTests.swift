import Hippolyte
@testable import HyperwalletSDK
import XCTest

class HyperwalletVenmoAccountTests: XCTestCase {
    override func setUp() {
        Hyperwallet.setup(HyperwalletTestHelper.authenticationProvider)
    }

    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
    }

    func testCreateVenmoAccount_success() {
        // Given
        let expectation = self.expectation(description: "Create Venmo account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "VenmoAccountResponse")
        let url = String(format: "%@/venmo-accounts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)
        let accountId = "1234567890"
        var venmoAccountResponse: HyperwalletVenmoAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let venmoAccount = HyperwalletVenmoAccount
            .Builder(transferMethodCountry: "US",
                     transferMethodCurrency: "USD",
                     transferMethodProfileType: "INDIVIDUAL")
            .accountId(accountId)
            .build()

        Hyperwallet.shared.createVenmoAccount(account: venmoAccount, completion: { (result, error) in
            venmoAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(venmoAccount, "Venmo Account should be created")
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(venmoAccountResponse?.getFields(), "Fields should not be nil")
        XCTAssertEqual(venmoAccountResponse?.accountId, accountId, "AccountId should be same")
    }

    func testCreateVenmoAccount_missingMandatoryField_returnBadRequest() {
        // Given
        let expectation = self.expectation(description: "Create Venmo account failed")
        let response = HyperwalletTestHelper.badRequestHTTPResponse(for: "VenmoAccountResponseWithMissingAccountId")
        let url = String(format: "%@/venmo-accounts", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var venmoAccountResponse: HyperwalletVenmoAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let venmoAccount = HyperwalletVenmoAccount.Builder(transferMethodCountry: "US",
                                                           transferMethodCurrency: "USD",
                                                           transferMethodProfileType: "INDIVIDUAL")
            .build()

        Hyperwallet.shared.createVenmoAccount(account: venmoAccount, completion: { (result, error) in
            venmoAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(venmoAccountResponse, "Venmo account should not be created")
        XCTAssertEqual(errorResponse?.getHttpCode(), 400, "Error response code should be 400")
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.code,
                       "CONSTRAINT_VIOLATIONS",
                       "The error code should be CONSTRAINT_VIOLATIONS")
    }

    func testGetVenmoAccount_success() {
        // Given
        let expectation = self.expectation(description: "Get Venmo account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "VenmoAccountResponse")
        let url = String(format: "%@/venmo-accounts/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var venmoAccountResponse: HyperwalletVenmoAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.getVenmoAccount(transferMethodToken: "trm-12345", completion: { (result, error) in
            venmoAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(venmoAccountResponse?.getFields(), "Venmo account should be fetched successfully")
        XCTAssertEqual(venmoAccountResponse?.accountId, "1234567890")
    }

    func testUpdateVenmoAccount_success() {
        // Given
        let expectation = self.expectation(description: "Update Venmo account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "VenmoAccountResponse")
        let url = String(format: "%@/venmo-accounts/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPutRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        let accountId = "1234567890"
        var venmoAccountResponse: HyperwalletVenmoAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let venmoAccount = HyperwalletVenmoAccount
            .Builder(token: "trm-12345")
            .accountId(accountId)
            .build()

        Hyperwallet.shared.updateVenmoAccount(account: venmoAccount, completion: { (result, error) in
            venmoAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(venmoAccountResponse?.getFields(), "Venmo Account should be updated successfully")
        XCTAssertEqual(venmoAccountResponse?.accountId, accountId, "Updated AccountId should match")
    }

    func testUpdateVenmoAccount_invalidAccountIdRegex() {
        // Given
        let expectation = self.expectation(description: "Update Venmo account failed")
        let response = HyperwalletTestHelper.badRequestHTTPResponse(for: "VenmoAccountResponseWithInvalidAccountId")
        let url = String(format: "%@/venmo-accounts/trm-12345", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPutRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var venmoAccountResponse: HyperwalletVenmoAccount?
        var errorResponse: HyperwalletErrorType?

        // When
        let venmoAccount = HyperwalletVenmoAccount.Builder(token: "trm-12345").accountId("123").build()

        Hyperwallet.shared.updateVenmoAccount(account: venmoAccount, completion: { (result, error) in
            venmoAccountResponse = result
            errorResponse = error
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(venmoAccountResponse, "The venmoAccountResponse should be nil")
        XCTAssertEqual(errorResponse?.getHttpCode(), 400, "The Error response code should be 400")
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.code,
                       "CONSTRAINT_VIOLATIONS",
                       "The error code should be CONSTRAINT_VIOLATIONS")
    }

    func testDeactivateVenmoAccount_success() {
        // Given
        let expectation = self.expectation(description: "Deactivate Venmo account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "StatusTransitionMockedResponseSuccess")
        let url = String(format: "%@/venmo-accounts/trm-12345/status-transitions", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var statusTransitionResponse: HyperwalletStatusTransition?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.deactivateVenmoAccount(transferMethodToken: "trm-12345",
                                                  notes: "deactivate Venmo account",
                                                  completion: { (result, error) in
                                                    statusTransitionResponse = result
                                                    errorResponse = error
                                                    expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(statusTransitionResponse, "The status transition should be successful")
        XCTAssertEqual(statusTransitionResponse?.transition, HyperwalletStatusTransition.Status.deactivated)
    }

    func testDeactivateVenmoAccount_invalidTransition() {
        // Given
        let expectation = self.expectation(description: "Deactivate Venmo account failed")
        let response = HyperwalletTestHelper
            .badRequestHTTPResponse(for: "StatusTransitionMockedResponseInvalidTransition")
        let url = String(format: "%@/venmo-accounts/trm-12345/status-transitions", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildPostRequest(baseUrl: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var statusTransitionResponse: HyperwalletStatusTransition?
        var errorResponse: HyperwalletErrorType?

        // When
        Hyperwallet.shared.deactivateVenmoAccount(transferMethodToken: "trm-12345",
                                                  notes: "deactivate Venmo account",
                                                  completion: { (result, error) in
                                                    statusTransitionResponse = result
                                                    errorResponse = error
                                                    expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNotNil(errorResponse, "The `errorResponse` should not be nil")
        XCTAssertNil(statusTransitionResponse, "The statusTransitionResponse should be nil")
        XCTAssertEqual(errorResponse?.getHttpCode(), 400)
        XCTAssertEqual(errorResponse?.getHyperwalletErrors()?.errorList?.first?.code, "INVALID_FIELD_VALUE")
    }

    func testListVenmoAccounts_success() {
        // Given
        let expectation = self.expectation(description: "List Venmo account completed")
        let response = HyperwalletTestHelper.okHTTPResponse(for: "ListVenmoAccountResponse")
        let url = String(format: "%@/venmo-accounts?+", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var venmoAccountList: HyperwalletPageList<HyperwalletVenmoAccount>?
        var errorResponse: HyperwalletErrorType?

        // When
        let venmoAccountQueryParam = HyperwalletVenmoAccountQueryParam()
        venmoAccountQueryParam.status = .activated
        venmoAccountQueryParam.createdAfter = ISO8601DateFormatter.ignoreTimeZone.date(from: "2018-12-15T00:30:11")

        Hyperwallet.shared.listVenmoAccounts(queryParam: venmoAccountQueryParam) { (result, error) in
            venmoAccountList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNotNil(venmoAccountList, "The `venmoAccountList` should not be nil")
        XCTAssertEqual(venmoAccountList?.count, 1, "The `count` should be 1")
        XCTAssertNotNil(venmoAccountList?.data, "The `data` should be not nil")

        XCTAssertNotNil(venmoAccountList?.links, "The `links` should be not nil")
        XCTAssertNotNil(venmoAccountList?.links?.first?.params?.rel)

        let venmoAccount = venmoAccountList?.data?.first
        XCTAssertEqual(venmoAccount?.token, "trm-123456789")
        XCTAssertEqual(venmoAccount?.accountId!, "1234567890")
    }

    func testListVenmoAccounts_emptyResult() {
        // Given
        let expectation = self.expectation(description: "List Venmo account completed")
        let response = HyperwalletTestHelper.noContentHTTPResponse()
        let url = String(format: "%@/venmo-accounts?+", HyperwalletTestHelper.userRestURL)
        let request = HyperwalletTestHelper.buildGetRequestRegexMatcher(pattern: url, response)
        HyperwalletTestHelper.setUpMockServer(request: request)

        var venmoAccountList: HyperwalletPageList<HyperwalletVenmoAccount>?
        var errorResponse: HyperwalletErrorType?

        // When
        let venmoAccountQueryParam = HyperwalletVenmoAccountQueryParam()
        venmoAccountQueryParam.status = .deActivated

        // When
        Hyperwallet.shared.listVenmoAccounts(queryParam: venmoAccountQueryParam) { (result, error) in
            venmoAccountList = result
            errorResponse = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertNil(errorResponse, "The `errorResponse` should be nil")
        XCTAssertNil(venmoAccountList, "The `venmoAccountList` should be nil")
    }
}

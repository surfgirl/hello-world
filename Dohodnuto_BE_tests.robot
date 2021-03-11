*** Settings ***
Library   SeleniumLibrary
Library   RequestsLibrary
Library   Collections
Library   OperatingSystem


Resource  ../../Resources/common.robot
Resource  ../../Resources/variables.robot
#Resource  ../../Resources/Dohodnuto_resources.robot
Resource  ../../Resources/Dohodnuto_Login_Registration.robot
Resource  ../../Resources/Dohodnuto_Variables.robot
Resource  ../../Resources/BE_resources.robot

Test Setup
Test Teardown     Closing the application

*** Test Cases ***

E2E Cancelled After Payment
    [Tags]  BE_Tests
    Get Access Token Buyer
    Create Deal
    Get Access Token Seller
    Attach To Deal
    Money On Jumbo Account
    Cancelled After Payment
  


E2E Cancelled Before Payment
    [Tags]  BE_Tests
    Get Access Token Buyer
    Create Deal
    Get Access Token Seller
    Attach To Deal
    Cancelled Before Payment


E2E Delivery OK
    [Tags]  BE_Tests
    Get Access Token Buyer
    Create Deal
    Get Access Token Seller
    Attach To Deal
    Money On Jumbo Account
    Shipped
    Delivery OK
    Deal Rating


E2E Delivery NOK To Be Returned
    [Tags]  BE_Tests
    Get Access Token Buyer
    Create Deal
    Get Access Token Seller
    Attach To Deal
    Money On Jumbo Account
    Shipped
    Delivery NOK To Be Returned
    Shipped Back
    Delivery Returned








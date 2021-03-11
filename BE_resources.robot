*** Variables ***
${payload_buyer}  _csrf=20ccd571-6f63-415e-8a15-a443b2eadc49&username=ewa.wala%40ext.csas.cz&password=Heslo123%26&cognitoAsfData=eyJwYXlsb2FkIjoie1wiY29udGV4dERhdGFcIjp7XCJVc2VyQWdlbnRcIjpcIk1vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdPVzY0OyBydjo1Ni4wKSBHZWNrby8yMDEwMDEwMSBGaXJlZm94LzU2LjBcIixcIkRldmljZUlkXCI6XCIwb2xsNmk5enJtN2lwMXo2NGc2NToxNTk5MjA5MDY0MjM4XCIsXCJEZXZpY2VMYW5ndWFnZVwiOlwiZW4tVVNcIixcIkRldmljZUZpbmdlcnByaW50XCI6XCJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXT1c2NDsgcnY6NTYuMCkgR2Vja28vMjAxMDAxMDEgRmlyZWZveC81Ni4wZW4tVVNcIixcIkRldmljZVBsYXRmb3JtXCI6XCJXaW4zMlwiLFwiQ2xpZW50VGltZXpvbmVcIjpcIjAyOjAwXCJ9LFwidXNlcm5hbWVcIjpcImV3YS53YWxhQGV4dC5jc2FzLmN6XCIsXCJ1c2VyUG9vbElkXCI6XCJcIixcInRpbWVzdGFtcFwiOlwiMTU5OTIwOTE3ODI4NlwifSIsInNpZ25hdHVyZSI6IkVWU1FXQTROdVQ1RnNxSVI0MTFnTmdoN0RhSGYrclJqeWFSa1czNUd0WGM9IiwidmVyc2lvbiI6IkpTMjAxNzExMTUifQ==&signInSubmitButton=Sign+in
${payload_seller}  _csrf=0392fa63-f09b-41af-9dee-cde358d69958&username=ewa.wala%2B13%40ext.csas.cz&password=Heslo123&cognitoAsfData=eyJwYXlsb2FkIjoie1wiY29udGV4dERhdGFcIjp7XCJVc2VyQWdlbnRcIjpcIk1vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQ7IHJ2OjgwLjApIEdlY2tvLzIwMTAwMTAxIEZpcmVmb3gvODAuMFwiLFwiRGV2aWNlSWRcIjpcIndibmoyOWhiODV1MGZqa2dlMGE4OjE1OTcwOTczMDUwMzNcIixcIkRldmljZUxhbmd1YWdlXCI6XCJlbi1VU1wiLFwiRGV2aWNlRmluZ2VycHJpbnRcIjpcIk1vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQ7IHJ2OjgwLjApIEdlY2tvLzIwMTAwMTAxIEZpcmVmb3gvODAuMGVuLVVTXCIsXCJEZXZpY2VQbGF0Zm9ybVwiOlwiV2luMzJcIixcIkNsaWVudFRpbWV6b25lXCI6XCIwMjowMFwifSxcInVzZXJuYW1lXCI6XCJld2Eud2FsYSsxM0BleHQuY3Nhcy5jelwiLFwidXNlclBvb2xJZFwiOlwiXCIsXCJ0aW1lc3RhbXBcIjpcIjE1OTgyNjc3MTg4MDNcIn0iLCJzaWduYXR1cmUiOiJJNTdlVmVTaElYNHUrTUhhbGcyTGx1S210Y0hvdlpPaFEyU0doRTFIOVU0PSIsInZlcnNpb24iOiJKUzIwMTcxMTE1In0%3D&signInSubmitButton=Sign+in
${url}  https://escrowbackend-dev-dohodnuto.auth.eu-central-1.amazoncognito.com
${path}  /login?response_type=token&client_id=4hf1cs4b3hk0aosrmu67gskf2g&redirect_uri=http://localhost/
${STATUS_CODE_OK}  302
${ENDPOINT_GRAPHQL}  https://api.dev.dohodnuto.cz/graphql
${STATUS_CODE_OK}  200

*** Settings ***
Library  RequestsLibrary
Library  String
Library  Collections
Library  OperatingSystem
Library  JSONLibrary

Library   ../Libraries/jsonLibrary.py

*** Keywords ***
Get Access Token Buyer
  ${headers} =  Create Dictionary  Content-Type=application/x-www-form-urlencoded  Connection=keep-alive  Cookie=XSRF-TOKEN=20ccd571-6f63-415e-8a15-a443b2eadc49; cognito-fl=""W10=""
  Create Session  cognito  ${url}
  ${res} =  Post Request  cognito  ${path}  data=${payload_buyer}  headers=${headers}  allow_redirects=${False}
  Should Be Equal As Strings  ${res.status_code}  ${STATUS_CODE_OK}
  #Status Should Be  302  ${res}
  Log  ${res.headers['Location']}
  ${access_token_buyer}=  Get substring  ${res.headers['Location']}  1198  2277
  Set Global Variable  ${access_token_buyer}

Get Access Token Seller
  ${headers} =  Create Dictionary  Content-Type=application/x-www-form-urlencoded  Connection=keep-alive  Cookie=XSRF-TOKEN=0392fa63-f09b-41af-9dee-cde358d69958; cognito-fl=""W10=""
  Create Session  cognito  ${url}
  ${res} =  Post Request  cognito  ${path}  data=${payload_seller}  headers=${headers}  allow_redirects=${False}
  Should Be Equal As Strings  ${res.status_code}  ${STATUS_CODE_OK}
  #Status Should Be  302  ${res}
  Log  ${res.headers['Location']}
  ${access_token_seller}=  Get substring  ${res.headers['Location']}  1136  2148
  Set Global Variable  ${access_token_seller}


Create Deal
   Create Session  graphqlsession  ${ENDPOINT_GRAPHQL}  verify=true
   ${headers}=  Create Dictionary  Authorization=${access_token_buyer}  Content-Type=application/json
   ${request_body}=  Get File  ./Data//create_deal.json
   ${resp}=  post request  graphqlsession  /  data=${request_body}  headers=${headers}
   #Should Be Equal As Strings  ${resp.status_code}  ${STATUS_CODE_OK}
   ${resp_json}=  Set Variable  ${resp.json()}
   ${dealId}=  get value from json    ${resp.json()}  $..data.createDeal.id
   ${new_obj}=    Convert JSON To String    ${dealId}
   ${dealId}=  Get substring  ${new_obj}  2  38
   set global variable  ${dealId}


Attach To Deal
    ${json_obj}=    Load JSON From File     ./Data//attach_to_deal.json
    ${json_obj}=    Update Value To Json     ${json_obj}    $..variables.AttachClientToRoleInput.dealId    ${dealId}
    ${new_obj}=     Convert JSON To String    ${json_obj}
    Create File     ./Data//attach_to_deal.json    ${new_obj}
    Create Session  graphqlsession  ${ENDPOINT_GRAPHQL}  verify=true
    ${headers}=  Create Dictionary  Authorization=${access_token_seller}  Content-Type=application/json
    ${request_body}=  Get File  ./Data//attach_to_deal.json
    ${resp}=  post request  graphqlsession  /  data=${request_body}  headers=${headers}
    #Should Be Equal As Strings  ${resp.status_code}  ${STATUS_CODE_OK}
    ${resp_json}=  Set Variable  ${resp.json()}

Update Request Payload With Current Deal ID
    ${json_obj}=    Load JSON From File     ./Data//money_on_jumbo.json
    ${json_obj}=    Update Value To Json     ${json_obj}    $..variables.backOfficeTransitionInput.dealId     ${dealId}
    ${new_obj}=    Convert JSON To String    ${json_obj}
    Create File    ./Data//money_on_jumbo.json    ${new_obj}


Money On Jumbo Account
   Update Request Payload With Current Deal ID
   Create Session  graphqlsession  ${ENDPOINT_GRAPHQL}  verify=true
   ${headers}=  Create Dictionary  Authorization=${access_token_buyer}  Content-Type=application/json
   ${request_body}=  Get File  ./Data//money_on_jumbo.json
   ${resp}=  post request  graphqlsession  /  data=${request_body}  headers=${headers}
   ${resp_json}=  Set Variable  ${resp.json()}
   ${deal_state}=  get value from json    ${resp.json()}  $..data.backOfficeTransition.state
   Should Be Equal As Strings  ${deal_state}  ['MONEY_ON_JUMBO_ACCOUNT']

Shipped
    ${json_obj}=    Load JSON From File     ./Data//shipped.json
    ${json_obj}=    Update Value To Json     ${json_obj}    $..variables.updatedealinput.id   ${dealId}
    ${new_obj}=     Convert JSON To String    ${json_obj}
    Create File     ./Data//shipped.json    ${new_obj}
    Create Session  graphqlsession  ${ENDPOINT_GRAPHQL}  verify=true
    ${headers}=  Create Dictionary  Authorization=${access_token_seller}  Content-Type=application/json
    ${request_body}=  Get File  ./Data//shipped.json
    ${resp}=  post request  graphqlsession  /  data=${request_body}  headers=${headers}
    #Should Be Equal As Strings  ${resp.status_code}  ${STATUS_CODE_OK}
    ${resp_json}=  Set Variable  ${resp.json()}
    ${deal_state}=  get value from json    ${resp.json()}  $..data.updateDeal.state
    Should Be Equal As Strings  ${deal_state}  ['SHIPPED']

Delivery OK
    ${json_obj}=    Load JSON From File     ./Data//delivery_ok.json
    ${json_obj}=    Update Value To Json     ${json_obj}    $..variables.updatedealinput.id   ${dealId}
    ${new_obj}=     Convert JSON To String    ${json_obj}
    Create File     ./Data//delivery_ok.json    ${new_obj}
    Create Session  graphqlsession  ${ENDPOINT_GRAPHQL}  verify=true
    ${headers}=  Create Dictionary  Authorization=${access_token_buyer}  Content-Type=application/json
    ${request_body}=  Get File  ./Data//delivery_ok.json
    ${resp}=  post request  graphqlsession  /  data=${request_body}  headers=${headers}
    #Should Be Equal As Strings  ${resp.status_code}  ${STATUS_CODE_OK}
    ${resp_json}=  Set Variable  ${resp.json()}
    ${deal_state}=  get value from json    ${resp.json()}  $..data.updateDeal.state
    Should Be Equal As Strings  ${deal_state}  ['DELIVERY_OK']

Deal Rating
    ${json_obj}=    Load JSON From File     ./Data//deal_rating.json
    ${json_obj}=    Update Value To Json     ${json_obj}    $..variables.dealRatingInput.dealId   ${dealId}
    ${new_obj}=     Convert JSON To String    ${json_obj}
    Create File     ./Data//deal_rating.json    ${new_obj}
    Create Session  graphqlsession  ${ENDPOINT_GRAPHQL}  verify=true
    ${headers}=  Create Dictionary  Authorization=${access_token_buyer}  Content-Type=application/json
    ${request_body}=  Get File  ./Data//deal_rating.json
    ${resp}=  post request  graphqlsession  /  data=${request_body}  headers=${headers}
    #Should Be Equal As Strings  ${resp.status_code}  ${STATUS_CODE_OK}
    ${resp_json}=  Set Variable  ${resp.json()}
    ${deal_rate}=  get value from json    ${resp.json()}  $..data.insertDealRating.dealRating.rating
    Should Be Equal As Strings  ${deal_rate}  [5]

Delivery NOK To Be Returned
    ${json_obj}=    Load JSON From File     ./Data//delivery_nok_tbr.json
    ${json_obj}=    Update Value To Json     ${json_obj}    $..variables.updatedealinput.id   ${dealId}
    ${new_obj}=     Convert JSON To String    ${json_obj}
    Create File     ./Data//delivery_nok_tbr.json    ${new_obj}
    Create Session  graphqlsession  ${ENDPOINT_GRAPHQL}  verify=true
    ${headers}=  Create Dictionary  Authorization=${access_token_buyer}  Content-Type=application/json
    ${request_body}=  Get File  ./Data//delivery_nok_tbr.json
    ${resp}=  post request  graphqlsession  /  data=${request_body}  headers=${headers}
    #Should Be Equal As Strings  ${resp.status_code}  ${STATUS_CODE_OK}
    ${resp_json}=  Set Variable  ${resp.json()}
    ${deal_state}=  get value from json    ${resp.json()}  $..data.updateDeal.state
    Should Be Equal As Strings  ${deal_state}  ['DELIVERY_NOK_TO_BE_RETURNED']

Shipped Back
    ${json_obj}=    Load JSON From File     ./Data//shipped_back.json
    ${json_obj}=    Update Value To Json     ${json_obj}    $..variables.updatedealinput.id   ${dealId}
    ${new_obj}=     Convert JSON To String    ${json_obj}
    Create File     ./Data//shipped_back.json    ${new_obj}
    Create Session  graphqlsession  ${ENDPOINT_GRAPHQL}  verify=true
    ${headers}=  Create Dictionary  Authorization=${access_token_buyer}  Content-Type=application/json
    ${request_body}=  Get File  ./Data//shipped_back.json
    ${resp}=  post request  graphqlsession  /  data=${request_body}  headers=${headers}
    #Should Be Equal As Strings  ${resp.status_code}  ${STATUS_CODE_OK}
    ${resp_json}=  Set Variable  ${resp.json()}
    ${deal_state}=  get value from json    ${resp.json()}  $..data.updateDeal.state
    Should Be Equal As Strings  ${deal_state}  ['SHIPPED_BACK']

Delivery Returned
    ${json_obj}=    Load JSON From File     ./Data//delivery_returned.json
    ${json_obj}=    Update Value To Json     ${json_obj}    $..variables.updatedealinput.id   ${dealId}
    ${new_obj}=     Convert JSON To String    ${json_obj}
    Create File     ./Data//delivery_returned.json    ${new_obj}
    Create Session  graphqlsession  ${ENDPOINT_GRAPHQL}  verify=true
    ${headers}=  Create Dictionary  Authorization=${access_token_seller}  Content-Type=application/json
    ${request_body}=  Get File  ./Data//delivery_returned.json
    ${resp}=  post request  graphqlsession  /  data=${request_body}  headers=${headers}
    #Should Be Equal As Strings  ${resp.status_code}  ${STATUS_CODE_OK}
    ${resp_json}=  Set Variable  ${resp.json()}
    ${deal_state}=  get value from json    ${resp.json()}  $..data.updateDeal.state
    Should Be Equal As Strings  ${deal_state}  ['DELIVERY_RETURNED']

Delivery Fraud
    ${json_obj}=    Load JSON From File     ./Data//delivery_nok_fraud.json
    ${json_obj}=    Update Value To Json     ${json_obj}    $..variables.updatedealinput.id   ${dealId}
    ${new_obj}=     Convert JSON To String    ${json_obj}
    Create File     ./Data//delivery_nok_fraud.json    ${new_obj}
    Create Session  graphqlsession  ${ENDPOINT_GRAPHQL}  verify=true
    ${headers}=  Create Dictionary  Authorization=${access_token_buyer}  Content-Type=application/json
    ${request_body}=  Get File  ./Data//delivery_nok_fraud.json
    ${resp}=  post request  graphqlsession  /  data=${request_body}  headers=${headers}
    #Should Be Equal As Strings  ${resp.status_code}  ${STATUS_CODE_OK}
    ${resp_json}=  Set Variable  ${resp.json()}
    ${deal_state}=  get value from json    ${resp.json()}  $..data.updateDeal.state
    Should Be Equal As Strings  ${deal_state}  ['DELIVERY_NOK_FRAUD']

Delivery Undelivered
    ${json_obj}=    Load JSON From File     ./Data//delivery_nok_undelivered.json
    ${json_obj}=    Update Value To Json     ${json_obj}    $..variables.updatedealinput.id   ${dealId}
    ${new_obj}=     Convert JSON To String    ${json_obj}
    Create File     ./Data//delivery_nok_undelivered.json    ${new_obj}
    Create Session  graphqlsession  ${ENDPOINT_GRAPHQL}  verify=true
    ${headers}=  Create Dictionary  Authorization=${access_token_buyer}  Content-Type=application/json
    ${request_body}=  Get File  ./Data//delivery_nok_undelivered.json
    ${resp}=  post request  graphqlsession  /  data=${request_body}  headers=${headers}
    #Should Be Equal As Strings  ${resp.status_code}  ${STATUS_CODE_OK}
    ${resp_json}=  Set Variable  ${resp.json()}
    ${deal_state}=  get value from json    ${resp.json()}  $..data.updateDeal.state
    Should Be Equal As Strings  ${deal_state}  ['DELIVERY_NOK_UNDELIVERED']

Delivery Damaged
    ${json_obj}=    Load JSON From File     ./Data//delivery_nok_damaged.json
    ${json_obj}=    Update Value To Json     ${json_obj}    $..variables.updatedealinput.id   ${dealId}
    ${new_obj}=     Convert JSON To String    ${json_obj}
    Create File     ./Data//delivery_nok_damaged.json    ${new_obj}
    Create Session  graphqlsession  ${ENDPOINT_GRAPHQL}  verify=true
    ${headers}=  Create Dictionary  Authorization=${access_token_buyer}  Content-Type=application/json
    ${request_body}=  Get File  ./Data//delivery_nok_damaged.json
    ${resp}=  post request  graphqlsession  /  data=${request_body}  headers=${headers}
    #Should Be Equal As Strings  ${resp.status_code}  ${STATUS_CODE_OK}
    ${resp_json}=  Set Variable  ${resp.json()}
    ${deal_state}=  get value from json    ${resp.json()}  $..data.updateDeal.state
    Should Be Equal As Strings  ${deal_state}  ['DELIVERY_NOK_DELIVERY_DAMAGED']

Cancelled Unreceived
    ${json_obj}=    Load JSON From File     ./Data//cancelled_unreceived.json
    ${json_obj}=    Update Value To Json     ${json_obj}    $..variables.updatedealinput.id   ${dealId}
    ${new_obj}=     Convert JSON To String    ${json_obj}
    Create File     ./Data//cancelled_unreceived.json    ${new_obj}
    Create Session  graphqlsession  ${ENDPOINT_GRAPHQL}  verify=true
    ${headers}=  Create Dictionary  Authorization=${access_token_buyer}  Content-Type=application/json
    ${request_body}=  Get File  ./Data//cancelled_unreceived.json
    ${resp}=  post request  graphqlsession  /  data=${request_body}  headers=${headers}
    #Should Be Equal As Strings  ${resp.status_code}  ${STATUS_CODE_OK}
    ${resp_json}=  Set Variable  ${resp.json()}
    ${deal_state}=  get value from json    ${resp.json()}  $..data.updateDeal.state
    Should Be Equal As Strings  ${deal_state}  ['CANCELLED_UNRECEIVED']

Cancelled After Payment
    ${json_obj}=    Load JSON From File     ./Data//cancelled_after_payment.json
    ${json_obj}=    Update Value To Json     ${json_obj}    $..variables.updatedealinput.id   ${dealId}
    ${new_obj}=     Convert JSON To String    ${json_obj}
    Create File     ./Data//cancelled_after_payment.json    ${new_obj}
    Create Session  graphqlsession  ${ENDPOINT_GRAPHQL}  verify=true
    ${headers}=  Create Dictionary  Authorization=${access_token_buyer}  Content-Type=application/json
    ${request_body}=  Get File  ./Data//cancelled_after_payment.json
    ${resp}=  post request  graphqlsession  /  data=${request_body}  headers=${headers}
    #Should Be Equal As Strings  ${resp.status_code}  ${STATUS_CODE_OK}
    ${resp_json}=  Set Variable  ${resp.json()}
    ${deal_state}=  get value from json    ${resp.json()}  $..data.updateDeal.state
    Should Be Equal As Strings  ${deal_state}  ['CANCELLED_AFTER_PAYMENT']


Cancelled Before Payment
    ${json_obj}=    Load JSON From File     ./Data//cancelled_before_payment.json
    ${json_obj}=    Update Value To Json     ${json_obj}    $..variables.updatedealinput.id   ${dealId}
    ${new_obj}=     Convert JSON To String    ${json_obj}
    Create File     ./Data//cancelled_before_payment.json    ${new_obj}
    Create Session  graphqlsession  ${ENDPOINT_GRAPHQL}  verify=true
    ${headers}=  Create Dictionary  Authorization=${access_token_seller}  Content-Type=application/json
    ${request_body}=  Get File  ./Data//cancelled_before_payment.json
    ${resp}=  post request  graphqlsession  /  data=${request_body}  headers=${headers}
    #Should Be Equal As Strings  ${resp.status_code}  ${STATUS_CODE_OK}
    ${resp_json}=  Set Variable  ${resp.json()}
    ${deal_state}=  get value from json    ${resp.json()}  $..data.updateDeal.state
    Should Be Equal As Strings  ${deal_state}  ['CANCELLED_BEFORE_PAYMENT']
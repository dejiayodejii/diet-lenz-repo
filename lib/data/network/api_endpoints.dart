class AppEndpoint {
  static const bool isLive = false;
  static const String baseUrl = "https://api.backend.vepayhq.com/";
  static const String stageUrl = "https://api.backend.vepayhq.com/";

  //Authentication
  static const String refreshAccessToken = "auth/refresh_access_token/";
  static const String login = "auth/login/";
  static const String delete = "auth/delete_account/";
  static const String signup = "auth/signup/";
  static const String verifyOtp = "auth/verify_otp/";
  static const String validateOtp = "auth/check_otp_status/";
  static const String resendOtp = "auth/resend_otp/";
  static const String resetPasswordOtp = "auth/request_reset_password_otp/";
  static const String resetPinRequest = "auth/request_reset_pin_otp/";
  static const String setPin = "auth/set_pin/";
  static const String verifyPin = "auth/verify_pin/";
  static const String setYafpayTag = "auth/yafpay_tag/";
  static const String getYafpayTag = "auth/yafpay_tag/";
  static const String two_fa = "auth/two_fa/";
  static const String notifications = "notifications/";
  static const String changePassword = "auth/change_password/";
  static const String creationDetails = "cards/create/";
  static const String vepayUsage = "usage_purpose/";
    static const String updatePicture = "auth/profile_image/";

    static const String accountStatement = "wallets/account_statement/";
    static const String accountProof = "wallets/proof_of_account/";
  //kyc
  static const String kyc = "auth/kyc_level_1/";
   static const String kycNIN = "auth/kyc_nin/";
  static const String kyc2 = "auth/kyc_level_2/";

    static const String countries = "countries/";

  static const String fcmRegistration = "notifications/devices/";

  //
  static const String bankList = "wallets/institutions/";
  static const String branchList =
      "wallets/send_money/institutions/bank_branches/";
  static const String verifyAcctNumber =
      "wallets/send_money/institutions/resolve_institution_account/";
  // "wallets/send_money/resolve_bank_account/";
  static const String sendMoneyDetails = "wallets/send_money/";
  static const String exchangeRate = "wallets/exchange_rate/";

  static const String virtualAccount = "wallets/virtual_accounts/";

  static const String exchangeCodes = "wallets/exchange_rate/codes/";
  static const String bankTransfer = "wallets/send_money/bank_transfer/";
  static const String mobileMoney = "wallets/send_money/mobile_money/";

  static const String bankTransferRecipients =
      "wallets/send_money/bank_transfer/";

  //

  //invoice
  static const String createCustomer = "wallets/customers/";
  static const String getCustomer = "wallets/customers/";
  static const String createInvoice = "wallets/invoices/";
  static const String getInvoice = "wallets/invoices/";
  static const String deleteInvoice = "wallets/invoices/";
  static const String deleteCustomer = "wallets/customers/";
  static const String createCardDetails = "auth/kyc_verification/";
  static const String createCard = "cards/create/";
  static const String getCard = "cards/";
  static const String changeCardPin = "cards/change_pin/";
  static const String getCardBalance = "cards/balance/";
  static const String getCardFundingDetails = "cards/fund/";
  static const String cardFunding = "auth/kyc_verification/";
  static const String getCardWithdrawDetails = "cards/withdraw/";
  static const String cardWithdrawal = "auth/kyc_verification/";
  static const String getCardTransactns = "cards/transactions/";
  static const String deleteCards = "cards/delete/";
  static const String freezeCards = "cards/freeze/";
  static const String unfreezeCards = "cards/unfreeze/";


    static const String referal = "referrals/user/";

  // virtual account
  static const String createVirtualAccount = "wallets/virtual_accounts/";
  static const String getVirtualAccount = "wallets/virtual_accounts/";
  static const String getVirtualTrans =
      "wallets/virtual_accounts/virtual_account_transactions/";

//add bank transfer
  static const String addMoneyBT = "wallets/add_money/bank_transfer/";
  static const String addMoneyFW = "wallets/add_money/flutterwave/";
  //General
  static const String getCurrency = "currencies/";
  static const String getCountries = "countries/";
  static const String getUser = "user_data/";
  static const String getBanks = "ng_banks/";
  static const String getCsrfToken = "csrf_token/";
  static const String getTagDetails = "wallets/send_money/yafpay_tag_details/";

  //static String personalProfile(String id) => "/profiles/$id";

  //bills payment
  static const String getBills = "bills/institutions/";
  static const String getBundles = "wallets/bill_payment/bundles/";
  static const String makePayment = "wallets/bill_payment/";
  static const String validateCustomer = "wallets/bill_payment/customer_details_validation/";
  static const String getBillsPaymentRecipient = "wallets/bill_payment/";

//Beneficiary
  static const String createBeneficiary = "beneficiaries/";
  static const String getBeneficiary = "beneficiaries/";
  static String updateBeneficiary(String id) => "beneficiaries/$id/";
  static String deleteBeneficiary(String id) => "beneficiaries/";
  static String multiplyBeneficiary = "beneficiaries/";

  //Wallet
  static const String getWallet = "wallets/";
  static const String createPaymentLink = 'wallets/payment_links/';
  static const String verifyTransactions = 'wallets/verify_payment';
  static const String changePaymentLinkStatus =
      'wallets/payment_links/payment_link_status/';
  static const String activateWallet = "wallets/activate_wallet/";
  static const String addMoney = "wallets/add_money/";
  static const String addMobileMoney = "wallets/add_money/mobile_money/";
  static const String directChange =
      "wallets/add_money/add_money_direct_charge/";
  static const String sendMoney = "wallets/send_money/";
  static const String mobileMoneyRecipient = "wallets/send_money/mobile_money/";
  static const String swap = "wallets/swap/";
  static const String getYafpay = "wallets/yafpay_to_yafpay/";
  static const String sendYafpayTag = "wallets/send_money/yafpay_tag/";

  static const String getPgoneNumber = 'wallets/virtual_account/';
  static const String getMobileMoneyPhone =
      'wallets/add_money/mobile_money_phone_numbers/';
  static const String getTagRecipients = 'wallets/send_money/yafpay_tag/';

  static const String getAllTransactions = "wallets/transactions/";

  static String getVRAccount(String code) => 'wallets/virtual_account/$code/';
}

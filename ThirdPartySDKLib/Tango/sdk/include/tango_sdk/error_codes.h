#ifndef _INCLUDED_tango_sdk_error_codes_h
#define _INCLUDED_tango_sdk_error_codes_h

/// Tango SDK error codes
///

/// Keep this file plain C because we use it in our Objective C code.
/// NOTE: Dont change the order or values.  Always add new entries at the end.
enum ErrorCode
{
  TANGO_SDK_SUCCESS = 0,
  TANGO_SDK_MESSAGE_SEND_PROGRESS = 1,
  TANGO_SDK_NO_SESSION = 2,
  TANGO_SDK_INVALID_APP_ID = 3,
  TANGO_SDK_INVALID_SECRET = 4,
  TANGO_SDK_SRV_ERROR = 5,
  TANGO_SDK_SRV_INVALID_JSON = 6,
  TANGO_SDK_SRV_NO_TOKEN = 7,
  TANGO_SDK_SRV_NO_CALLBACK_SCHEME = 8,
  TANGO_SDK_USER_DENIAL = 9,
  TANGO_SDK_WRONG_STATE = 10,
  TANGO_SDK_INVALID_TOKEN_FORMAT = 11,
  TANGO_SDK_SRV_CANT_CONNECT = 12,
  TANGO_SDK_TANGO_APP_NOT_INSTALLED = 13,
  TANGO_SDK_TANGO_APP_NO_SDK_SUPPORT = 14,
  TANGO_SDK_CANT_SEND_REQUEST_TO_TANGO = 15,
  TANGO_SDK_TANGO_AUTH_TIMEOUT = 16,
  TANGO_SDK_TANGO_DEVICE_NOT_VALIDATED = 17,
  TANGO_SDK_ADDRESS_BOOK_NOT_READY = 18,
  TANGO_SDK_MESSAGE_SEND_CANCELLED = 19,
  TANGO_SDK_INVALID_ARGUMENTS = 20,
  TANGO_SDK_SHUTTING_DOWN = 21,
  TANGO_SDK_INTERNAL_ERROR = 22,
  TANGO_SDK_SYNC_TIMEOUT = 23,
  TANGO_SDK_WRAPPER_INVALID_JSON = 24,
  TANGO_SDK_ADDRESS_BOOK_ACCESS_DENIED = 25,
  TANGO_SDK_ADDRESS_BOOK_SAVE_DENIED = 26,
  TANGO_SDK_ADDRESS_BOOK_TIMEOUT = 27,
  TANGO_SDK_ADDRESS_BOOK_BUSY = 28,
};

#endif // _INCLUDED_tango_sdk_error_codes_h

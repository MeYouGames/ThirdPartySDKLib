// Copyright 2012-2013, TangoMe Inc ("Tango").  The SDK provided herein includes 
// software and other technology provided by Tango that is subject to copyright and 
// other intellectual property protections. All rights reserved.  Use only in 
// accordance with the Evaluation License Agreement provided to you by Tango.
// 
// Please read Tango_SDK_Evaluation_License_agreement_v1-2.docx
//
#ifndef _INCLUDED_tango_sdk_session_h
#define _INCLUDED_tango_sdk_session_h

#include <string>
#include <vector>
#include <ostream>
#include <tango_sdk/error_codes.h>
#include <tango_sdk/event_codes.h>
#include <tango_sdk/message.h>

namespace tango_sdk {

/// Initialize Tango SDK.
/// This function must be called before any other call, and you must call it from your
/// main thread.
///
///   @param app_id          The app id from Tango SDK provisioning.
///   @param callback_scheme The callback scheme from Tango SDK provisioning.
///   @param optional_config Optional configuration encoded as a json string.

/// \return True if the Tango SDK initialized successfully
///         False if app_id or callback_scheme are empty strings or if the
///         optional json config is invalid
///
bool init(const std::string & app_id, const std::string & callback_scheme, const std::string & optional_config = "");

/// Uninititialize Tango SDK.
/// This function tells the SDK it can release resopurces
///
void uninit(); 

/// Return the current version of the SDK in the form:
///
/// major.minor.revision
///
/// For example: 1.0.12345
///
/// Version strings cannot be sorted or compared.  They must be decomposed into their
/// three parts as integers and each of these parts compared in order.
std::string get_version();

/// Return the current environment of the SDK as a string for debugging purposes. For production,
/// this will be an empty string. You should not generally display the environment to the user.
//const char * get_environment_name();
std::string get_environment_name();

/// Pass the URL to Tango SDK.
/// Call this function whenever the application receives an URL from the scheme 'callback_scheme'.
///
///  @param url                     An URL that was used to launch the app
///  @param user_url                Out parameter: returns the value of url parameter, except for
///                                 a case when user tried to launch the URL from Tango, but the
///                                 application was not installed. See following Remarks section.
///
///  Remarks:
///
///    using user_url parameter:
///
///    Assume the following scenario: my friend wants to play "Cool Chess" game with me.
///    He has the game installed on his device. He sends me his first move (e.g. E2->E4) using
///    send_message_to_recipients function call, while the move is encoded as a part of the URL.
///    I don't have "Cool Chess" installed, so a link from my chat window takes me to the
///    app store. I install the "Cool Chess" and open it. The url from the chat message describing
///    the move will be returned in userUrl parameter.
///
  
bool accept_url(const std::string & url, std::string * user_url = NULL);

typedef unsigned int RequestID;


/// Asynchronous callback from SDK

/// The semantics if the fields depends on the type if the Reply
///
/// type         id              content (JSON)                     ctx
///
/// RESULT       request_id       result of a successful request    context passed with the request
/// ERROR        request_id       error code and description        context passed with the request
/// PROGRESS     request_id       progress message                  context passed with the request
/// EVENT        event_code       event message                     context passed in Session::create()

enum CallbackType { RESULT=0, ERROR=1, PROGRESS=2, EVENT=3 };

/// CallbackInfo structure contains the information that is passed from SDK back to the user.
struct CallbackInfo
{
  CallbackType  type;           /// the type of the CallbackInfo
  union
  {
    RequestID     request_id;   /// unique request id is assigned at the request generation
    EventCode     event_code;   /// numeric code that identifies an event
  }             id;
  std::string   content;        /// JSON string with the content of the reply, see the table above
  void *        ctx;            /// callback user data
};

/// User has to create the CallbackHandler function and pass it to Session::create()
typedef void (*CallbackHandler)(CallbackInfo *);

/// Response and ResponseHandler are deprecated, please use CallbackInfo and CallbackHandler instead.
/// Response to the asynchronous request
struct Response
{
  RequestID     request_id;     /// unique request id is assigned at the request generation
  ErrorCode     error_code;     /// error code, SUCCESS if no errors
  std::string   error_text;     /// optional error message
  std::string   result;         /// result as JSON string or empty string in case of an errors
  void *        context;        /// callback user data
};

typedef void (*ResponseHandler)(Response *);


/// Helper functions to work with CallbackInfo structures
ErrorCode   error_code(const CallbackInfo * info);
std::string error_text(const CallbackInfo * info);


/// The interface to send messages accepts a list of acount ids to send
/// the message to.  We use a vector to represent that list.
///
/// Each item in the vector should be a ciphered Tango account ID
/// representing the user you want to send the message to.
///
/// Usually, you get account ids from the response to get_friends_profiles()
typedef std::vector<std::string> AccountIdVector;

/// SessionImpl is the delegate of Session
class SessionImpl;

/// Session in the main class to communicate with Tango
class Session
{
public:
  /// Deprecated, use create(CallbackHandler).
  ///
  static Session *  create(ResponseHandler handler);

  /// Create the session.
  ///
  static Session *  create(CallbackHandler handler, void * event_context = NULL);

  /// Destroys the session.
  ///
  static void       destroy(Session * s);

  /// Request the authentication token.
  /// Retrieve authentication token from Tango if necessary and store this internally
  /// for the future use.
  ///
  RequestID         authenticate(void * context = NULL);
  
  /// Check if the session is already authenticated
  /// The session is authenticated if we have an SDK token in local storage and it has not expired.
  bool              is_authenticated();

  /// Request the access token to be used to retrieve TangoID from Tango SSO.
  ///
  RequestID         get_access_token(void * context = NULL);

  /// Returns true if Tango is installed and supports the authentication for the SDK.
  ///
  bool              tango_has_sdk_support();

  /// Returns true is Tango is installed on device.
  ///
  bool              tango_is_installed();

  /// Open the Tango app store page so that the user can install the latest
  /// version of Tango. No prompt is shown.
  bool              install_tango();

  // Specific functionality

  /// Get the profile information about the registered Tango user.
  ///
  RequestID         get_my_profile(void * context = NULL);

  /// Get the list of Tango contacts for the registered Tango user
  ///
  RequestID         get_friends_profiles(void * context = NULL);

  /// Get the list of Cached Tango contacts for the registerd Tango user
  RequestID         get_cached_friends(void * context = NULL);

  /// User's Possessions

  /// Getter of all
  RequestID         get_all_possessions(void * context = NULL);

  /// Setter
  /// input : possessions in json
  ///
  ///        {
  ///          "Possessions":[
  ///            {
  ///              "LastModified":1366998173,
  ///              "ItemId":"coins",
  ///              "Value":"100",
  ///              "Version":"5",
  ///            },
  ///            {
  ///              "LastModified":1366998173,
  ///              "ItemId":"gems",
  ///              "Value":"2",
  ///              "Version":"5",
  ///            }
  ///            {
  ///              "ItemId":"a_new_item",
  ///              "Value":"1",
  ///            }
  ///          ]
  ///        }
  ///
  RequestID         set_possessions(const std::string& possessions, void * context = NULL);

  /// User's Metrics
  
  /// Getter
  /// input : metrics in json
  ///
  ///        {
  ///          "EncodedAccountIds":[
  ///             "a2NTygSrZjFiGdrDrbz4RA",
  ///             "MWGjTGUI75rWt5W5TH_5vw"
  ///          ],
  ///          "ComputedMetrics":[
  ///            {
  ///              "MetricId":"score",
  ///              "RollUps":[
  ///                "MAX_THIS_WEEK",
  ///                "MAX"
  ///              ]
  ///            },
  ///            {
  ///              "MetricId":"beastiesKilled",
  ///              "RollUps":[
  ///                "MAX_THIS_WEEK",
  ///                "MIN"
  ///              ]
  ///            }
  ///          ]
  ///        }
  ///
  RequestID         get_computed_metrics(const std::string& metrics, void * context = NULL);

  /// Setter
  /// input : metrics in json
  ///
  ///        {
  ///          "RawMetrics":[
  ///            {
  ///              "MetricId":"score",
  ///              "Value":"1000",
  ///              "RollUps":[
  ///                "MAX_LAST_WEEK",
  ///                "MAX_THIS_WEEK",
  ///                "MAX",
  ///                "AVE",
  ///                "SUM",
  ///                "COUNT",
  ///                "MIN"
  ///              ]
  ///            },
  ///            {
  ///              "MetricId":"beastiesKilled",
  ///              "Value":"20",
  ///              "RollUps":[
  ///                "MAX_LAST_WEEK",
  ///                "MAX_THIS_WEEK",
  ///                "MAX",
  ///                "MIN"
  ///              ]
  ///            }
  ///          ]
  ///        }
  ///


  RequestID         get_leaderboard(const std::string& metrics, void * context = NULL);

  RequestID         set_raw_metrics(const std::string& metrics, void * context = NULL);

  /// Send a message to a list of Tango users.
  /// The message will appear in the recipients's Tango client as if it was sent from your user,
  /// attributed with information identifying your app.
  ///    
  ///    @param context      Custom contextual information that you can use to identify events
  ///                        from the SDK.
  ///    @param recipients   A vector of ciphered Tango account IDs representing the users you
  ///                        want to send the message to. Call get_friends_profiles to retreive
  ///                        a list of account IDs.
  ///    @param message      The message that you want to send. See the Message class in message.h.
  ///
  RequestID send_message_to_recipients(const AccountIdVector& recipients,
                                       const Message& message,
                                       void * context = NULL);

  /// Returns approximation of time on Tango server
  /// The time is estimated based on a timestamp returned in server response. The accuracy
  /// is not guaranteed because of network delays. Current implementation is not affected
  /// by device local clock settings. However it will be affected by user changing local
  /// clock after synchronization was performed.
  /// In the current implementation the synchronization occurs when one of the following
  /// request completes successfully:
  ///
  ///   get_computed_metrics
  ///   set_raw_metrics
  ///   get_all_possessions
  ///   set_possessions
  ///
  /// Until the synchronization occurs, the function will return 0.
  ///
  /// \return Estimated time on Tango server. The time is elapsed number of seconds
  ///         since Unix epoch in GMT (01 Jan 1970, 00:00:00 GMT).
  ///         If synchronization with Tango server did not occur yet, 0 will be returned
  unsigned int get_server_time();
  
  /// Returns true if launch intent is known
  bool        has_launch_intent();
  
  /// Launch intent value.
  ///
  /// \return Currently the only values being supported are:
  ///         open_message - if the app was opened because user opened a message
  ///         previously sent with send_message_to_recipients
  ///         open - if user opened the app from a catalog or some promotional link
  ///
  ///         The intent value will be available only if Tango launch context is
  ///         passed to the external app by having LAUNCH_CONTEXT substring
  ///         in the URL.
  std::string get_launch_intent();
  
  /// Returns true if conversation context exists
  bool            has_launch_context_conversation_participants();
  
  /// Returns list of participants in a conversation
  ///
  /// \return The list contains account ids. These ids may be used to send
  ///         messages using send_message_to_recipients method calls.
  ///         The list will be available only if Tango launch context is
  ///         passed to the external app by having LAUNCH_CONTEXT substring
  ///         in the URL.
  AccountIdVector get_launch_context_conversation_participants();
  
private:
  Session(SessionImpl * impl);
  ~Session();

  // Forbid copying and assignment
  Session(const Session & rhs);
  const Session & operator=(const Session & rhs);

private:
  SessionImpl * _impl;
};

} // namespace tango_sdk

// Response is deprecated, please use CallbackInfo instead
std::ostream & operator<<(std::ostream & os, const tango_sdk::Response & obj);

std::ostream & operator<<(std::ostream & os, const tango_sdk::CallbackInfo & obj);

#endif // _INCLUDED_tango_sdk_session_h

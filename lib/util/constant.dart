class AuthStepsScreenConstant {
  static const AUTH_FAILURE_ERROR_MESSAGE = 'Authentication failed. Please try later.';
  static const CONFRIM_PASSWORD = 'Confirm Password';
  static const EMAIL = 'Email';
  static const INVALID_EMAIL_ERRROR_MESSAGE = 'Invalid Email';
  static const NEXT = 'Next';
  static const PASSWORD = 'Password';
  static const PASSWORD_HINT = '(At least 6 characters)';
  static const PASSWORD_TOO_SHORT_ERROR_MESSAGE = 'Password is too short!';
  static const PASSWORD_NOT_MATCH_ERROR_MESSAGE = 'Passwords not matched!';
  static const SIGNIN_TIMEOUT_ERROR_MESSAGE = 'Signin timeout. Please try later.';
  static const SIGNUP_TIMEOUT_ERROR_MESSAGE = 'Signup timeout. Please try later.';
  static const SIGN_UP_TITLE = 'Sign Up';
  static const SIGN_IN_TITLE = 'Sign In';
  static const SUBMIT = 'Submit';
  static const USER_NAME = 'User Name';
  static const USER_NAME_LENGTH_ERROR_MESSAGE = 'User name should be at least 4 characters';
  static const USER_NAME_SPACE_ERROR_MESSAGE = 'User name should not contain space';
  static const USER_NAME_UNDERLYING_ERROR_MESSAGE = 'user name should not contain "_"';
}

class ChatScreenConstant {
  static const HINT = 'Type a message...';
}

class NewPostScreenConstant {
  static const TITLE = 'New Post';
  static const TOPIC_MISSING_ERROR_MESSAGE = 'Please select a topic';
  static const POST_TEXT_HINT = 'Post something about what you see...';
}

class FriendRequestScreenConstant {
  static const TITLE = 'New Friends';
}

class FriendScreenConstant {
  static const DELETE_FRIEND_ERROR_MESSAGE = 'Failed to delete friend. Please try later.';
  static const ICON_SLIDE_DELETE_ACTION = 'Delete';
}

class SearchFriendScreenConstant {
  static const UNIQUE_NAME_HINT = 'Unique Name';
  static const FAILED_TO_FIND_USER_ERROR_MESSAGE = 'Failed to find user. Please try later.';
  static const FAILED_TO_SEND_FRIEND_REQUEST_ERROR_MESSAGE = 'Failed to send friend request. Please try later.';
  static const FAILED_TO_DELETE_FRIEND_ERROR_MESSAGE = 'Failed to delete friend. Please try later.';
  static const PENDING = 'Pending';
  static const MESSAGE = 'Message';
  static const SEARCH = 'Search';
}

class NotificationTabScreenConstant {
  static const TITLE = 'Notification';
  static const ALL = 'All';
  static const COMMENT = 'Comment';
  static const LIKES = 'Likes';
}

class PostDetailScreenConstant {
  static const TITLE = 'Detail';
  static const FAILED_TO_COMMENT_ERROR_MESSAGE = 'Failed to comment. Please try later.';
  static const FAILED_TO_GET_CURRENT_USER_ERROR_MESSAGE = 'Something wrong happened. Please try later.';
  static const ADD_COMMENT_HINT = '... Add comment';

  static String GET_COMMENTS_COUNT(int count) {
    return 'Comments ($count)';
  }
}

class LikedPostsScreenConstant {
  static const TITLE = 'Liked Posts';
}

class MyPostsScrrenConstant {
  static const TITLE = 'My Posts';
}

class PickLocationMapScreenConstant {
  static const TITLE = 'Map';
  static const OK = 'OK';
}

class PostLocationMapViewScreenConstant {
  static const TITLE = 'Post Location';
}

class EditSelfIntroductionScreenConstant {
  static const TITLE = 'Self Introduction';
  static const FAILED_TO_UPDATE_SLEF_INTRO_ERROR_MESSAGE = 'Failed to update self introduction. Please try later.';
  static const OK = 'OK';
  static const HINT = 'Write something about yourself...';
}

class ProfileScreenConstant {
  static const FAVORITE = 'Favorite';
  static const MY_POST = 'My Post';
  static const SETTING = 'Setting';
}

class SettingScreenConstant {
  static const TITLE = 'Settings';
  static const UNIQUE_NAME = 'Unique Name';
  static const EMAIL = 'Email';
  static const LOG_OUT = 'Log Out';
}

class TabScreenConstant {
  static const LIFE_ELSEWHERE = 'Life Elsewhere';
  static const LOCATION_BASED = 'Location Based';
  static const FRIENDS = 'Friends';
  static const CHATS = 'Chats';
  static const PROFILE = 'Profile';

  static const BOTTOM_NAV_LABEL_HOME = 'home';
  static const BOTTOM_NAV_LABEL_FRIENDS = 'friends';
  static const BOTTOM_NAV_LABEL_CHATS = 'chats';
  static const BOTTOM_NAV_LABEL_PROFILE = 'profile';
}

class DialogUtilConstant {
  static const ERROR_MESSAGE = 'An error occurred';
  static const OK = 'OK';
}
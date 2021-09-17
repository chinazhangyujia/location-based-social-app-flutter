class AuthStepsScreenConstant {
  static const AUTH_FAILURE_ERROR_MESSAGE = 'Authentication failed. Please try later.';
  static const SIGNIN_TIMEOUT_ERROR_MESSAGE = 'Signin timeout. Please try later.';
  static const SIGNUP_TIMEOUT_ERROR_MESSAGE = 'Signup timeout. Please try later.';
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
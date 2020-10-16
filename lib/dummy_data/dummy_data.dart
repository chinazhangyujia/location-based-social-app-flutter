import 'package:location_based_social_app/model/comment.dart';
import 'package:location_based_social_app/model/location_point.dart';
import 'package:location_based_social_app/model/notification.dart';
import 'package:location_based_social_app/model/post.dart';
import 'package:location_based_social_app/model/user.dart';

List<Post> DUMMY_POST = [
  Post(
    id: '1',
    user: DUMMY_USER[0],
    postedTimeStamp: DateTime.now(),
    photoUrls: [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg/800px-Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg',
      'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
      'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
      'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
    ],
    content: 'This is my first post This is my first post This is my first post This is my first post This is my first post This is my first post  This is my first post ' +
        'This is my first post This is my first post This is my first post This is my first post This is my first post' +
        'This is my first post This is my first post This is my first post This is my first post This is my first post',
    postLocation: LocationPoint(-122.048, 37.442)
  ),
  Post(
    id: '2',
    user: DUMMY_USER[1],
    postedTimeStamp: DateTime.now(),
    photoUrls: [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg/800px-Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg',
      'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
      'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
      'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
    ],
    content: 'This is my first post This is my first post This is my first post This is my first post This is my first post This is my first post  This is my first post ' +
        'This is my first post This is my first post This is my first post This is my first post This is my first post' +
        'This is my first post This is my first post This is my first post This is my first post This is my first post',
    postLocation: LocationPoint(-122.048, 37.442)
  ),
];

List<User> DUMMY_USER = [
  User(
      id: '1',
      name: 'Yujia',
      avatarUrl: 'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
      birthday: DateTime(1993, 6, 23),
      gender: Gender.MALE,
      introduction: 'My name is Yujia. I am a software engineer. I am a software engineer. I am a software engineer. I am a software engineer.'
  ),
  User(
      id: '2',
      name: 'Yujia123',
      avatarUrl: 'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
      birthday: DateTime(1993, 6, 23),
      gender: Gender.MALE,
      introduction: 'My name is Yujia. I am a software engineer. I am a software engineer. I am a software engineer. I am a software engineer.'
  ),
];

List<UserNotification> DUMMY_NOTIFICATION = [
  CommentNotification(
    post: DUMMY_POST[0],
    happenedOn: DateTime.now(),
    replier: DUMMY_USER[0],
  ),
  FollowStatusNotification(
    happenedOn: DateTime.now(),
    follower: DUMMY_USER[1],
    followee: DUMMY_USER[0],
  )
];

List<Comment> DUMMY_COMMENT = [
  Comment(id: '1', sendFrom: DUMMY_USER[0], content: 'I like your post. I like your post I like your '
      'post I like your post I like your post I like your post', postTime: DateTime.now()),
  Comment(id: '2', sendFrom: DUMMY_USER[1], content: 'I like your post too', postTime: DateTime.now()),
  Comment(id: '3', sendFrom: DUMMY_USER[1], content: 'I like your post too', postTime: DateTime.now()),
  Comment(id: '4', sendFrom: DUMMY_USER[1], content: 'I like your post too', postTime: DateTime.now()),
];

List<User> DUMMY_FRIENDS = [
  User(
      id: '1',
      name: 'Yujia',
      avatarUrl: 'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
      birthday: DateTime(1993, 6, 23),
      gender: Gender.MALE,
      introduction: 'My name is Yujia. I am a software engineer. I am a software engineer. I am a software engineer. I am a software engineer.'
  ),
  User(
      id: '2',
      name: 'Yujia123',
      avatarUrl: 'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
      birthday: DateTime(1993, 6, 23),
      gender: Gender.MALE,
      introduction: 'My name is Yujia. I am a software engineer. I am a software engineer. I am a software engineer. I am a software engineer.'
  ),
];
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
        'This is my first post This is my first post This is my first post This is my first post This is my first post')
];

List<User> DUMMY_USER = [
  User(
      id: '1',
      name: 'Yujia',
      avatarUrl: 'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
      birthday: DateTime(1993, 6, 23),
      gender: Gender.MALE,
      introduction: 'My name is Yujia. I am a software engineer. I am a software engineer. I am a software engineer. I am a software engineer.'
  )
];
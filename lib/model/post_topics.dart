import 'package:location_based_social_app/model/post_topic.dart';

final List<PostTopic> _postTopics = [
  PostTopic(id: 1, name: 'FOOD', displayName: 'Food'),
  PostTopic(id: 2, name: 'WORK', displayName: 'Work'),
  PostTopic(id: 3, name: 'STREET_VIEW', displayName: 'Street View'),
  PostTopic(id: 4, name: 'ENTERTAINMENT', displayName: 'Entertainment'),
  PostTopic(id: 5, name: 'SOCIAL', displayName: 'Social'),
  PostTopic(id: 6, name: 'RELAXATION', displayName: 'Relaxation'),
  PostTopic(id: 7, name: 'FRIENDS', displayName: 'Friends'),
  PostTopic(id: 8, name: 'FAMILY', displayName: 'Family'),
];

final Map<String, PostTopic> _postTopicByName = {
  'FOOD': PostTopic(id: 1, name: 'FOOD', displayName: 'Food'),
  'WORK': PostTopic(id: 2, name: 'WORK', displayName: 'Work'),
  'STREET_VIEW':
      PostTopic(id: 3, name: 'STREET_VIEW', displayName: 'Street View'),
  'ENTERTAINMENT':
      PostTopic(id: 4, name: 'ENTERTAINMENT', displayName: 'Entertainment'),
  'SOCIAL': PostTopic(id: 5, name: 'SOCIAL', displayName: 'Social'),
  'RELAXATION': PostTopic(id: 6, name: 'RELAXATION', displayName: 'Relaxation'),
  'FRIENDS': PostTopic(id: 7, name: 'FRIENDS', displayName: 'Friends'),
  'FAMILY': PostTopic(id: 8, name: 'FAMILY', displayName: 'Family'),
};

List<PostTopic> getTopics() {
  return _postTopics;
}

PostTopic getTopicByName(String name) {
  return _postTopicByName[name];
}

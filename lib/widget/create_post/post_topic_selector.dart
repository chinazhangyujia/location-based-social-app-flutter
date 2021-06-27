import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/post_topic.dart';

class PostTopicSelector extends StatelessWidget {
  static final _topics = [
    PostTopic(id: 1, name: 'FOOD', displayName: 'Food'),
    PostTopic(id: 2, name: 'WORK', displayName: 'Word'),
    PostTopic(id: 3, name: 'STREET_VIEW', displayName: 'Street View'),
    PostTopic(id: 4, name: 'ENTERTAINMENT', displayName: 'Entertainment'),
    PostTopic(id: 5, name: 'SOCIAL', displayName: 'Social'),
    PostTopic(id: 6, name: 'RELAXTION', displayName: 'Relaxtion'),
    PostTopic(id: 7, name: 'FRIENDS', displayName: 'Friends'),
    PostTopic(id: 8, name: 'FAMILY', displayName: 'Family'),
  ];

  final String selectedTopic;
  final void Function(String) onSelectTopic;

  const PostTopicSelector({this.selectedTopic, this.onSelectTopic});

  List<ChoiceChip> _getTopicOptions(BuildContext context) {
    return _topics.map((topic) => 
      ChoiceChip(
        label: Text(topic.displayName),
        selected: topic.name == selectedTopic,
        onSelected: (bool selected) {
          onSelectTopic(topic.name);
        },
        selectedColor: Theme.of(context).accentColor,
      )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: _getTopicOptions(context),
    );
  }
}

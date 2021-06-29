import 'package:flutter/material.dart';
import 'package:location_based_social_app/model/post_topics.dart';

class PostTopicSelector extends StatelessWidget {
  static final _topics = getTopics();

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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactobot/bloc/area/area_bloc.dart';
import 'package:reactobot/bloc/area/area_model.dart';
import 'package:reactobot/widgets/user_requests/user_requests.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List<List<AreaModel>>? areaList = context.watch<AreaBloc>().state.areaList;
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Your reactobots')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: areaList!.length,
          itemBuilder: (BuildContext context, int listIndex) {
            List<AreaModel>? sublist = areaList[listIndex];
            return Dismissible(
              key: Key(sublist.first.action.id),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm'),
                      content: const Text('Are you sure you want to delete this item?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) {
                UserRequests(context: context).deleteArea(sublist.first.id);
              },
              background: Container(
                color: Colors.red,
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
              ),
              child: ExpansionTile(
                shape: const RoundedRectangleBorder(
                  side: BorderSide(width: 1),
                ),
                title: _textBoldNormal('Title', sublist.first.action.description),
                children: sublist.map((AreaModel area) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Action:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            _textDetail('Service', area.action.service),
                            _textDetail('Name', area.action.name),
                            _textDetail('Description', area.action.description),
                            _textDetail('Data', area.action.data.toString()),
                            const SizedBox(height: 10),
                            const Text(
                              'Reactions:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ...area.reactions.map((reaction) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _textDetail('Service', reaction.service),
                                  _textDetail('Name', reaction.name),
                                  _textDetail('Description', reaction.description),
                                  _textDetail('Data', reaction.data.toString()),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _textDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$title: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textBoldNormal(String name, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$name: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

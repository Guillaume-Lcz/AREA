import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:reactobot/widgets/local_storage/send_get_from_local_storage.dart';

class SendServerUrl extends StatefulWidget {
  const SendServerUrl({
    super.key,
    required this.url,
  });

  final String url;

  @override
  State<SendServerUrl> createState() => _SendServerUrlState();
}

class _SendServerUrlState extends State<SendServerUrl> {
  late TextEditingController _serverAddressController;

  @override
  void initState() {
    super.initState();
    _serverAddressController = TextEditingController(text: widget.url);
  }

  @override
  void dispose() {
    _serverAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Add a server adress')),
      content: MaterialTextField(
        keyboardType: TextInputType.url,
        hint: 'url',
        labelText: 'url',
        textInputAction: TextInputAction.done,
        suffixIcon: const Icon(FontAwesomeIcons.link),
        controller: _serverAddressController,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              _serverAddressController = TextEditingController(text: '');
            });
            LocalStorage().removeValue('urlServer');
          },
          child: const Text('Delete'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            LocalStorage().saveStringToLocalStorage('urlServer', _serverAddressController.text);
            Navigator.of(context).pop(true);
          },
          child: const Text('Save'),
        ),
      ],
    );
    ;
  }
}

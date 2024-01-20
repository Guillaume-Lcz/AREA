import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_text_fields/material_text_fields.dart';

import '../../../bloc/service/service_bloc.dart';

class DiscordInput extends StatefulWidget {
  const DiscordInput({
    super.key,
    required this.index,
    required this.actionKey,
    required this.service,
  });

  final int index;
  final String actionKey;
  final String service;

  @override
  State<DiscordInput> createState() => _DiscordInputState();
}

class _DiscordInputState extends State<DiscordInput> {
  late final TextEditingController _textEditingController1 = TextEditingController();
  late final TextEditingController _textEditingController2 = TextEditingController();

  @override
  void dispose() {
    _textEditingController1.dispose();
    _textEditingController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialTextField(
                keyboardType: TextInputType.number,
                hint: 'id',
                labelText: 'id',
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(FontAwesomeIcons.idBadge),
                controller: _textEditingController1,
              ),
              const SizedBox(height: 16),
              MaterialTextField(
                hintMaxLines: 4,
                keyboardType: TextInputType.text,
                hint: 'Text',
                labelText: 'Your message',
                textInputAction: TextInputAction.send,
                prefixIcon: const Icon(Icons.note),
                controller: _textEditingController2,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<ServiceBloc>().add(
                        ReactionsSubmitEvent(
                          channelIdDiscord: _textEditingController1.text,
                          body: _textEditingController2.text,
                          index: widget.index,
                          reactionKey: widget.actionKey,
                          service: widget.service,
                        ),
                      );
                  Navigator.of(context).popUntil((Route route) => route.isFirst);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Send informations',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

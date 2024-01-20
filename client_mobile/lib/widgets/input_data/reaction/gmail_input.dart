import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_text_fields/material_text_fields.dart';

import '../../../bloc/service/service_bloc.dart';

class GmailInput extends StatefulWidget {
  const GmailInput({
    super.key,
    required this.index,
    required this.actionKey,
    required this.service,
  });

  final int index;
  final String actionKey;
  final String service;

  @override
  State<GmailInput> createState() => _GmailInputState();
}

class _GmailInputState extends State<GmailInput> {
  late final TextEditingController _idEditingController = TextEditingController();
  late final TextEditingController _subjectEditingController = TextEditingController();
  late final TextEditingController _bodyEditingController = TextEditingController();

  @override
  void dispose() {
    _idEditingController.dispose();
    _subjectEditingController.dispose();
    _bodyEditingController.dispose();
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
                keyboardType: TextInputType.emailAddress,
                hint: 'Email',
                labelText: 'exemple@gmail.com',
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(FontAwesomeIcons.idBadge),
                controller: _idEditingController,
              ),
              const SizedBox(height: 16),
              MaterialTextField(
                keyboardType: TextInputType.text,
                hint: 'Subject',
                labelText: 'Text',
                textInputAction: TextInputAction.send,
                prefixIcon: const Icon(Icons.subject),
                controller: _subjectEditingController,
              ),
              MaterialTextField(
                hintMaxLines: 4,
                keyboardType: TextInputType.text,
                hint: 'Body',
                labelText: 'Text',
                textInputAction: TextInputAction.send,
                prefixIcon: const Icon(Icons.text_snippet),
                controller: _subjectEditingController,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<ServiceBloc>().add(
                        ReactionsSubmitEvent(
                          idGmail: _idEditingController.text,
                          subjectGmail: _subjectEditingController.text,
                          body: _bodyEditingController.text,
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

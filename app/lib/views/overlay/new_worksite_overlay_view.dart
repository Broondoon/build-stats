// View Imports:

import 'package:build_stats_flutter/resources/app_style.dart';
import 'package:build_stats_flutter/views/overlay/overlay_interface.dart';
import 'package:flutter/material.dart';

class NewWorksite extends StatefulWidget implements OverlayImpInterface {
  const NewWorksite({
    super.key,
    required this.changeInfoFunct,
    required this.removeOverlayFunct,
  });

  final Function changeInfoFunct;
  final Function removeOverlayFunct;

  @override
  void timeToClose() {
    // ...suposedly implemented by the State class?
    print('STATED POORLY');
  }

  @override
  State<NewWorksite> createState() => _NewWorksiteState();
}

class _NewWorksiteState extends State<NewWorksite> {
  bool readyToSave = false;

  TextEditingController worknameEdit = TextEditingController();
  TextEditingController intIdEdit = TextEditingController();
  TextEditingController contractorEdit = TextEditingController();

  List<(TextEditingController, TextEditingController)> peopleEdit = [];
  List<Widget> peopleWidgets = [];
  
  @override
  void initState() {
    super.initState();
    TextEditingController newPersonTitleEdit = TextEditingController();
    TextEditingController newPersonNameEdit = TextEditingController();

    worknameEdit.addListener(canWeSave);
    intIdEdit.addListener(canWeSave);
    contractorEdit.addListener(canWeSave);

    newPersonTitleEdit.addListener(canWeSave);
    newPersonNameEdit.addListener(canWeSave);

    peopleEdit.add((newPersonTitleEdit, newPersonNameEdit));
    peopleWidgets.add(
      NewWorksitePersonRow(
        newPersonTitleEdit: newPersonTitleEdit,
        newPersonNameEdit: newPersonNameEdit, 
        titleHint: 'Title', 
        nameHint: 'Name',
      )
    );
  }

  @override
  void dispose() {
    worknameEdit.dispose();
    intIdEdit.dispose();
    contractorEdit.dispose();

    // I didn't want to define a new class, so we're using "Records"
    // ...aka fancy tuples
    for (var editRecord in peopleEdit) {
      editRecord.$1.dispose();
      editRecord.$2.dispose();
      // personEdit.dispose();
    }

    super.dispose();
  }

  void addPerson() {
    if (peopleWidgets.length > 3) {
      return;
    }

    print('ADDING PERSON TO LIST');
    // int newIndex = peopleEdit.length;
    TextEditingController newPersonTitleEdit = TextEditingController();
    TextEditingController newPersonNameEdit = TextEditingController();

    setState(() {
      peopleEdit.add((newPersonNameEdit, newPersonTitleEdit));
      peopleWidgets.add(
        NewWorksitePersonRow(
          newPersonTitleEdit: newPersonTitleEdit,
          newPersonNameEdit: newPersonNameEdit, 
          titleHint: 'Title', 
          nameHint: 'Name',
        )
      );
    });
  }

  Widget? getAddContactButton() {
    if (peopleWidgets.length < 4) {
      return TextButton(
        style: MyAppStyle.buttonStyle,
        onPressed: addPerson,
        child: const Text(
          'Add Contact',
          style: MyAppStyle.regularFont, 
        ),
      );
    }
    return null;
  }

  Widget? getTextWarning() {
    if (!readyToSave) {
      return const Text(
        'Fields Missing!',
        style: TextStyle(
          fontSize: 18,
          color: Colors.red,
        ),
      );
    }
    return null;
  }

  void canWeSave() {
    setState(() {
      readyToSave = checkSave();
    });
  }

  bool checkSave() {
    if (worknameEdit.text == '') {
      print('Missing workname');
      return false;
    }
    if (intIdEdit.text == '') {
      print('Missing internal ID');
      return false;
    }
    if (contractorEdit.text == '') {
      print('Missing contractor');
      return false;
    }
    if (peopleEdit[0].$1.text == '') {
      print('Missing foremans... title?');
      return false;
    }
    if (peopleEdit[0].$2.text == '') {
      print('Missing foremans name');
      return false;
    }

    print('GOOD TO SAVE WORKSITE');
    return true;
  }

  void createNewWorksite() {
    canWeSave();

    if (!readyToSave) {
      print('NOT READY TO SAVE WORKSITE');
      return;
    }

    List<(String, String)> peopleToStringRecord = [];

    for ((TextEditingController, TextEditingController) rec in peopleEdit) {
      peopleToStringRecord.add((rec.$1.text, rec.$2.text));
    }

    widget.changeInfoFunct(
      true,
      worknameEdit.text,
      intIdEdit.text,
      contractorEdit.text,
      peopleToStringRecord,
    );

    widget.removeOverlayFunct();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // const Text(
        //   'New Worksite',
        //   style: MyAppStyle.largeFont,
        // ),
        const SizedBox(
          height: 20,
        ),
        NewWorksiteInputRow(
          inputLabel: 'Project Name:', 
          editController: worknameEdit,
        ),
        const SizedBox(
          height: 4,
        ),
        NewWorksiteInputRow(
          inputLabel: 'Internal ID:', 
          editController: intIdEdit,
        ),
        const SizedBox(
          height: 4,
        ),
        NewWorksiteInputRow(
          inputLabel: 'Contractor:',
          editController: contractorEdit,
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Points of Contact:',
          style: MyAppStyle.regularFont,
        ),
        const SizedBox(
          height: 8,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: peopleWidgets.length,
          itemBuilder: (context, index) {
            return peopleWidgets[index];
          }
        ),
        const SizedBox(
          height: 8,
        ),
        getAddContactButton() ?? Container(),
        const Spacer(),
        getTextWarning() ?? Container(),
        TextButton(
          // style: MyAppStyle.buttonStyle,
          style: TextButton.styleFrom(
            // backgroundColor: readyToSave
            //   ? const Color.fromARGB(255, 227, 227, 227)
            //   : Colors.black,
            padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              side: BorderSide(
                width: 1,
                color: readyToSave
                  ? Colors.black
                  : const Color.fromARGB(255, 202, 202, 202),
              ),
            ),
          ),
          onPressed: () {
            print('SAVE BUTTON PRESSED');
            createNewWorksite();
          },
          child: Text(
            'Create Worksite',
            style: TextStyle(
              fontSize: 18,
              color: readyToSave
                ? Colors.black
                : const Color.fromARGB(255, 202, 202, 202),
            )
          ),
        ),
      ],
    );
  }
}

class NewWorksitePersonRow extends StatelessWidget {
  const NewWorksitePersonRow({
    super.key,
    required this.newPersonTitleEdit,
    required this.newPersonNameEdit,
    required this.titleHint,
    required this.nameHint,
  });

  final TextEditingController newPersonTitleEdit;
  final TextEditingController newPersonNameEdit;
  final String titleHint;
  final String nameHint;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          width: 150,
          child: TextFormField(
            controller: newPersonTitleEdit,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              // border: InputBorder.none,
              hintText: titleHint,
            ),
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        SizedBox(
          height: 50,
          width: 150,
          child: TextFormField(
            controller: newPersonNameEdit,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              // border: InputBorder.none,
              hintText: nameHint,
            ),
          ),
        ),
      ],
    );
  }
}

class NewWorksiteInputRow extends StatelessWidget {
  const NewWorksiteInputRow({
    super.key,
    required this.inputLabel,
    required this.editController,
  });

  final String inputLabel;
  final TextEditingController editController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 140,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              inputLabel,
              style: MyAppStyle.regularFont,
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        SizedBox(
          height: 50,
          width: 200,
          child: TextFormField(
            controller: editController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              // border: InputBorder.none,
              hintText: '',
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_hive/models/notes_model.dart';
import 'package:hive_flutter/adapters.dart';
import 'boxes/boxes.dart';

class Lecture3 extends StatefulWidget {
  const Lecture3({Key? key}) : super(key: key);

  @override
  State<Lecture3> createState() => _Lecture3State();
}

class _Lecture3State extends State<Lecture3> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Database'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMyDialog();
        },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                return Card(
                 color: Colors.deepPurple.shade200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                     // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7)

                              ),
                              child: const Icon(Icons.person, size: 40,),
                            ),
                            const SizedBox(width: 20,),
                            Text(
                              data[index].title.toString(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500,),
                            ),
                            const Spacer(),
                             InkWell(
                              onTap: (){
                                _editDialog(data[index], data[index].title.toString(), data[index].description.toString(),);

                              },
                                child: const Icon(Icons.edit)),
                            const SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              onTap: (){
                                delete(data[index]);
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),


                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                       data[index].description.toString(),
                          style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w300),
                       ),
                        ),

                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  void delete(NotesModel notesModel)async{
    await notesModel.delete();
  }
  Future<void> _editDialog(NotesModel notesModel, String title, String description) async {

    titleController.text = title;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Enter title', border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        hintText: 'Enter description',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: ()async{
                  notesModel.title = titleController.text.toString();
                  notesModel.description = descriptionController.text.toString();
                  notesModel.save();
                  titleController.clear();
                  descriptionController.clear();

                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
  }

  Future<void> _showMyDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Enter title', border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        hintText: 'Enter description',
                        border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final data = NotesModel(
                      title: titleController.text,
                      description: descriptionController.text,

                  );
                  final box = Boxes.getData();
                  box.add(data);
                  data.save();
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }
}

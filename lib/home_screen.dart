import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Hive Database'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: Hive.openBox('Ukasha'),
                builder: (context, snapshot){
                  return Column(
                    children: [
                      ListTile(
                        title: Text(snapshot.data!.get('name').toString()),
                        subtitle:Text(snapshot.data!.get('age').toString()),
                        trailing: IconButton(
                          onPressed: (){
                            setState(() {

                            });
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      )

                    ],
                  );
                }),
            FutureBuilder(
                future: Hive.openBox('zain'),
                builder: (context, snapshot){
                  return Column(
                    children: [
                      ListTile(
                        title: Text(snapshot.data!.get('department').toString()),
                        subtitle:Text(snapshot.data!.get('session').toString()),
                        trailing: IconButton(
                          onPressed: (){
                            snapshot.data!.put('session', '2020-2024');
                            setState(() {

                            });
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      )

                    ],
                  );
                })



          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          var newBox = await Hive.openBox('zain');

          newBox.put('department', 'BBA');
          newBox.put('session', '2020-24');


          var box = await Hive.openBox('Ukasha');
          box.put('name', 'Ukasha Anwar');
          box.put('age', '25');

          box.put('details', {
            'pro' : 'developer',
            'type' : 'junior developer'
          });
          print (box.get('name'));
          print(box.get('age'));

          print(box.get('details')['type']);

        },
        child: const Icon(Icons.add),
      ),

    );
  }
}

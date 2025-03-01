import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swdquiz/firebase_options.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swdquiz/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("✅ Firebase initialized successfully!");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  int? selectedOption; // Stores the selected radio button option

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  // 🔥 Fetch questions from Firestore
  Future<void> fetchQuestions() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('QuizQuestions').get();

      if (snapshot.docs.isEmpty) {
        print("🚫 No questions found in Firestore.");
      } else {
        setState(() {
          questions = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        });
      }
    } catch (error) {
      print("❌ Firestore read error: $error");
    }
  }

  // ✅ Submit answer and check correctness
  void submitAnswer(BuildContext context) {
    if (selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Please select an option")),
      );
      return;
    }

    int correctAnswer = questions[currentQuestionIndex]['correct_answer'];

    if (selectedOption == correctAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Correct Answer!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Wrong Answer! Try Again.")),
      );
    }

    // Move to next question or show completion message
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOption = null; // Reset selection
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🎯 Quiz Completed! Well Done!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Quiz App")),
        body: Builder(
          builder: (context) {
            return questions.isEmpty
                ? Center(child: CircularProgressIndicator()) // Show loader if no questions
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          questions[currentQuestionIndex]['question'],
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),

                      // 🔘 Display multiple-choice options using RadioListTile
                      Column(
                        children: List.generate(
                          (questions[currentQuestionIndex]['options'] as List).length,
                          (index) => RadioListTile(
                            title: Text(questions[currentQuestionIndex]['options'][index].toString()),
                            value: index,
                            groupValue: selectedOption,
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value as int?;
                              });
                            },
                          ),
                        ),
                      ),

                      // ✅ Submit Answer Button
                      ElevatedButton(
                        onPressed: () => submitAnswer(context),
                        child: Text("Submit Answer"),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swdquiz/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully!");
  } catch (e) {
    print("Firebase initialization error: $e");
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState(); // ✅ Always call super.initState()
    testFirestoreRead(); // ✅ Add this to check Firestore connection
  }

  Future<void> testFirestoreRead() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('QuizQuestions').get();

      if (querySnapshot.docs.isEmpty) {
        print("❌ No documents found in 'QuizQuestions'. Firestore might not be connected.");
      } else {
        for (var doc in querySnapshot.docs) {
          print("📄 Found document: ${doc.id}, Data: ${doc.data()}");
        }
      }
    } catch (e) {
      print("❌ Firestore read error: $e");
    }
  }

  Future<void> createCollectionAndAddDocument() async {
  try {
    print("🟡 Button pressed, attempting to add document...");

    DocumentReference docRef = await _firestore.collection('QuizQuestions').add({
      'question': 'What is 5 + 3?',
      'options': ['5', '6', '8', '10'],
      'correct_answer': 2,
      'created_at': FieldValue.serverTimestamp(),
    });

    print("✅ Document added with ID: ${docRef.id}");
  } catch (error) {
    print("❌ Firestore write error: $error");
    print("🔥 Possible Causes: 1) Firestore rules 2) Internet connection 3) Firebase setup");
  }

}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Quiz App")),
        body: Center(
          child: ElevatedButton(
            onPressed: createCollectionAndAddDocument,
            child: Text("Create Collection"),
          ),
        ),
      ),
    );
  }
}
*/

/* 
USE THIS IF ERROR
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    
  } catch (e) {
    print("Firebase Init Error: $e"); // Logs error
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Hello World App")),
        body: Center(
          child: Text(
            "Hello, World!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
 */




/* import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final CollectionReference quizCollection =
      FirebaseFirestore.instance.collection('Quiz');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firestore Data")),
      body: StreamBuilder<QuerySnapshot>(
        stream: quizCollection.snapshots(), // Real-time data updates
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No Data Found"));
          }

          // Convert Firestore documents to a ListView
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['question'] ?? "No Question"),
                subtitle: Text(data['correct answer1'] ?? "No Answer"),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
 */
/* 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
} */

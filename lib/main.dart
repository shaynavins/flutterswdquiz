import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swdquiz/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Firebase initialized");
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
  int correct = 0;
  int? selectedOption;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('QuizQuestions').get();

      if (snapshot.docs.isEmpty) {
        print("No questions found in Firestore.");
      } else {
        setState(() {
          questions = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        });
      }
    } catch (error) {
      print("Firestore read error: $error");
    }
  }

  void submitAnswer(BuildContext context) {
    if (selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an option")),
      );
      return;
    }

    int correctAnswer = questions[currentQuestionIndex]['correct_answer'];

    if (selectedOption == correctAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Correct Answer!")),
      );
      correct++;
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOption = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Quiz Completed! Score: $correct")),
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

                      
                      ElevatedButton(
                        onPressed: () => submitAnswer(context),
                        child: Text("Submit"),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

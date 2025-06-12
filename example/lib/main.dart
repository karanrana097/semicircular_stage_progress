import 'package:flutter/material.dart';
import 'package:semicircular_stage_progress/semicircular_stage_progress.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Semicircular Stage Progress Demo',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentStage = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semicircular Stage Progress Example')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Default configuration
              const Text(
                'Default Style',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const SemicircularStageProgress(totalStages: 5, currentStage: 3),
              const SizedBox(height: 40),
              // Customized configuration
              const Text(
                'Customized Style',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SemicircularStageProgress(
                totalStages: 7,
                currentStage: _currentStage,
                width: 320,
                height: 220,
                arcWidth: 18,
                padding: 12,
                gapFactor: 0.7,
                completedColor: Colors.green,
                currentColor: Colors.teal,
                futureColor: Colors.grey.shade200,
                showCurrentIndicator: true,
                indicatorOuterSize: 14,
                indicatorInnerSize: 9,
                indicatorOuterColor: Colors.teal,
                indicatorInnerColor: Colors.white,
                stageText: 'Level $_currentStage',
                stageTextStyle: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
                statusText: _currentStage <= (_currentStage - 1)
                    ? 'Done'
                    : 'Ongoing',
                statusTextStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.teal,
                ),
                textSpacing: 25,
              ),
              const SizedBox(height: 30),
              // Interactive buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _currentStage > 1
                        ? () => setState(() => _currentStage--)
                        : null,
                    child: const Text('Previous Stage'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _currentStage < 7
                        ? () => setState(() => _currentStage++)
                        : null,
                    child: const Text('Next Stage'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:widgets_ui/widget/empty/empty_state_simple_widget.dart';

void main() => runApp(const TestTest());

class TestTest extends StatefulWidget {
  const TestTest({super.key});

  @override
  State<TestTest> createState() => _TestTestState();
}

class _TestTestState extends State<TestTest> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home:EmptyStateSimpleWidget(text: Text("EMTY"), icon: Icon(Icons.add)));
  }
}

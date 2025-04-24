import 'package:flutter/material.dart';
import 'container_widget.dart';

class ContainerUsageExample extends StatelessWidget {
  const ContainerUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Container Widget Example'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Basic usage with default properties
              ContainerWidget(
                margin: const EdgeInsets.all(16),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Default Container',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              
              // Container with custom height, width and padding
              ContainerWidget(
                height: 100,
                width: 300,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                child: const Center(
                  child: Text(
                    'Custom Size Container',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              
              // Custom styling
              ContainerWidget(
                margin: const EdgeInsets.all(16),
                backgroundColor: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue, width: 2),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 6),
                    blurRadius: 8,
                    spreadRadius: 0,
                    color: Colors.blue.withOpacity(0.3),
                  ),
                ],
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Custom Styled Container',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              // Container with complex content
              ContainerWidget(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Container with Multiple Children',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'This container has multiple child widgets arranged in a column.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Button 1'),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Button 2'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
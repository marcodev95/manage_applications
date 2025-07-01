import 'package:flutter/material.dart';
import 'package:manage_applications/models/errors/ui_message.dart';

class DataLoadErrorScreenWidget extends StatelessWidget {
  const DataLoadErrorScreenWidget({
    super.key,
    this.errorMessage,
    this.appBarTitle = '',
    required this.onPressed,
    this.buttonLabel = 'Riprova',
    this.onGoBack,
  });

  final String? errorMessage;
  final String appBarTitle;
  final VoidCallback onPressed;
  final String buttonLabel;
  final VoidCallback? onGoBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent, size: 64),
            const SizedBox(height: 20),
            Text(
              errorMessage ?? ErrorsMessage.dataLoading,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              spacing: 20.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: onPressed,
                  icon: Icon(Icons.refresh),
                  label: Text(buttonLabel),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
                if (onGoBack != null)
                  OutlinedButton.icon(
                    onPressed: onGoBack,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Torna indietro'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

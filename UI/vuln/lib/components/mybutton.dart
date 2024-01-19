import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String buttonText;
  final String descriptionText;
  final Size size;
  final VoidCallback? onPressed;

  const MyButton({
    required this.buttonText,
    required this.descriptionText,
    required this.size,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: size.height * 0.3,
      width: size.width * 0.35,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(color: Theme.of(context).cardColor),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          SizedBox(
            width: size.width * 0.33,
            height: size.height * 0.22,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: onPressed,
                child: Text(
                  buttonText,
                  style: TextStyle(
                      color: Theme.of(context).indicatorColor,
                      fontSize: size.height * .05),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(descriptionText),
        ],
      ),
    );
  }
}

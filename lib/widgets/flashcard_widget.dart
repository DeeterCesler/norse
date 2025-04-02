import 'dart:math';
import 'package:flutter/material.dart';
import 'package:norse_flashcards/models/flashcard.dart';

class FlashcardWidget extends StatefulWidget {
  final Flashcard card;
  final bool showNorse;
  final VoidCallback onTap;
  final double slideOffset;

  const FlashcardWidget({
    super.key,
    required this.card,
    required this.showNorse,
    required this.onTap,
    this.slideOffset = 0.0,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> {
  late bool _preShowNorse;
  late bool _showNorse;

  @override
  void initState() {
    super.initState();
    _preShowNorse = widget.showNorse;
    _showNorse = widget.showNorse;
  }

  @override
  void didUpdateWidget(FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showNorse != widget.showNorse) {
      setState(() {
        _showNorse = widget.showNorse;
      });
      
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          setState(() {
            _preShowNorse = widget.showNorse;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..translate(150.0 + widget.slideOffset)
          ..rotateY(_showNorse ? 0 : pi)
          ..translate(-150.0),
        child: Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform(
                transform: Matrix4.identity()
                  ..rotateY(_preShowNorse ? 0 : pi),
                alignment: Alignment.center,
                child: Text(
                  _preShowNorse ? widget.card.norse : widget.card.english,
                  style: TextStyle(
                    fontSize: _preShowNorse ? 120 : 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Transform(
                transform: Matrix4.identity()
                  ..rotateY(_preShowNorse ? 0 : pi),
                alignment: Alignment.center,
                child: Text(
                  _preShowNorse ? 'Old Norse' : 'English',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
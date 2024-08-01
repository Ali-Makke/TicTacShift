import 'package:flutter/material.dart';
import 'package:tic_tac_shift/common/constants.dart';

class GameDetailPage extends StatefulWidget {
  final Map<String, dynamic> game;
  final int index;

  const GameDetailPage({super.key, required this.game, required this.index});

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  late List<String> _boardStates;
  late List<String> _processedBoardStates;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _boardStates = widget.game['board_states'].split(',');
    _processedBoardStates =
        _boardStates[_currentStep].substring(0, 9).split("");
    if (_boardStates.isEmpty) {
      _boardStates = ['---------'];
    }
    _currentStep = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: sandText('Game ${widget.index}'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: BoardWidget(
                board: _processedBoardStates,
                onTileTap: (_) {},
                lastThirdMoveX: 0,
                lastThirdMoveO: 0,
                moveCount: 0,
                size: 'Small',
              ),
            ),
          ),
          _buildNavigationControls(),
        ],
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _currentStep > 0
                ? () {
                    setState(() {
                      _currentStep--;
                      _processedBoardStates =
                          _boardStates[_currentStep].substring(0, 9).split("");
                    });
                  }
                : null,
          ),
          Text('Step ${_currentStep + 1} of ${_boardStates.length}'),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _currentStep < _boardStates.length - 1
                ? () {
                    setState(() {
                      _currentStep++;
                      _processedBoardStates =
                          _boardStates[_currentStep].substring(0, 9).split("");
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

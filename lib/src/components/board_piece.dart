import 'package:flutter_xadrez/src/controllers/app_controller.dart';
import 'package:flutter_xadrez/src/models/piece.dart';
import 'package:flutter_xadrez/src/models/position.dart';
import 'package:flutter_xadrez/src/utils/dimensions.dart';
import 'package:flutter_xadrez/src/utils/notations.dart';
import 'package:flutter/material.dart';

class BoardPiece extends StatefulWidget {
  final Piece piece;
  final Position position;
  final void Function(Position, [double]) setMarkerPosition;

  BoardPiece({
    @required this.piece,
    @required this.position,
    @required this.setMarkerPosition,
  });

  @override
  _BoardPieceState createState() => _BoardPieceState();
}

class _BoardPieceState extends State<BoardPiece> {
  Position _position;
  String _from;

  @override
  void initState() {
    _position = Position(x: widget.position.x, y: widget.position.y);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BoardPiece oldWidget) {
    _position = Position(x: widget.position.x, y: widget.position.y);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double size = getSquareSize(context);
    bool isPiecePlayable = widget.piece.color == AppController().player;

    return Positioned(
      top: _position.y,
      left: _position.x,
      child: !isPiecePlayable
          ? Container(
              child: _pieceAsset(size),
            )
          : GestureDetector(
              onPanStart: (DragStartDetails details) {
                widget.setMarkerPosition(_position, size);
                setState(() {
                  _from = positionToSquare(_position, size);
                });
              },
              onPanUpdate: (DragUpdateDetails details) {
                setState(() {
                  _position = Position(
                    x: _position.x + details.delta.dx,
                    y: _position.y + details.delta.dy,
                  );
                });
              },
              onPanEnd: (DragEndDetails details) {
                String to = positionToSquare(_position, size);
                bool isMoveValid = AppController().isMoveValid(_from, to);

                setState(() {
                  if (!isMoveValid) {
                    _position = widget.position;
                  } else {
                    widget.setMarkerPosition(null);
                  }
                });
              },
              child: _pieceAsset(size),
            ),
    );
  }

  _pieceAsset(double size) {
    return Image(
      height: size,
      width: size,
      image: AssetImage(
        'assets/images/${widget.piece.color}${widget.piece.type}.png',
      ),
    );
  }
}

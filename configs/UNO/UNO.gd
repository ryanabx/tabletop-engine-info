class_name UNO
extends TabletopGame

const COLORS: Array[String] = [
    "RED", "BLUE", "YELLOW", "GREEN"
]

const CARD_TYPES: Array[String] = [
    "0", "1", "2", "3", "4", "5", "6",
    "7", "8", "9", "DRAW2", "SKIP", "TURN"
]

const SPECIAL_CARDS: Array[String] = [
    "DRAW4", "WILD"
]

func add_board(_board: Board) -> void:
    self.background_image = "images/bg.jpg"
    self.board = _board
    board.scale = Vector2(20, 20)

func game_start() -> void:
    board.clear_board()
    board.create_collection(
        {
            "name": "DRAW_PILE",
            "position": Vector2(-1.5, 0),
            "size": Vector2(2.5, 3.5),
            "coll_type": "stack",
            "rotation": 0.0,
            "permanent": true,
            "force_state": false,
            "view_perms": [false, false, false, false]
        }
    )
    for color in COLORS:
        for type in CARD_TYPES:
            for i in range(2):
                board.create_piece(
                    {
                        "face_up": false,
                        "collection": "DRAW_PILE",
                        "image_up": str("images/UNO_",color,type,".png"),
                        "image_down": "images/UNO_FLIPPED.png",
                        "size": Vector2(2.5, 3.5),
                        "rotation": 0.0
                    }
                )
    for type in SPECIAL_CARDS:
        for i in range(4):
            board.create_piece(
                {
                    "face_up": false,
                    "collection": "DRAW_PILE",
                    "image_up": str("images/UNO_",type,".png"),
                    "image_down": "images/UNO_FLIPPED.png",
                    "size": Vector2(2.5, 3.5),
                    "rotation": 0.0
                }
            )
    
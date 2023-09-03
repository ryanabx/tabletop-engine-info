class_name UNO
extends TabletopGame

const COLORS: Array[String] = [
    "RED", "BLUE", "YELLOW", "GREEN"
]

const BASE_SIZE: float = 64.0

const CARD_TYPES: Array[String] = [
    "0", "1", "2", "3", "4", "5", "6",
    "7", "8", "9", "DRAW2", "SKIP", "TURN"
]

const SPECIAL_CARDS: Array[String] = [
    "DRAW4", "WILD"
]

func _init() -> void:
    pass

func settings() -> Dictionary:
    return {
        "max_players": 4,
        "min_players": 1
    }

func export_settings() -> Dictionary:
    return {
        "name":"UNO",
        "schema_version": 1,
        "game_version": 1,
        "include_folders": [],
        "include_types": [],
        "include_image_folders": ["images"],
        "include_image_types": [".png", ".jpg"]
    }

func add_board(_board: Board) -> void:
    self.board = _board
    board.set_border(Rect2(-10 * BASE_SIZE, -10 * BASE_SIZE, 20 * BASE_SIZE, 20 * BASE_SIZE))
    board.set_background("images/bg.jpg")

func game_start() -> void:
    board.clear_board()
    board.create_collection(
        {
            "name": "DRAW_PILE",
            "position": Vector2(-1.5 * BASE_SIZE, 0 * BASE_SIZE),
            "size": Vector2(2.5 * BASE_SIZE, 3.5 * BASE_SIZE),
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
                        "size": Vector2(2.5 * BASE_SIZE, 3.5 * BASE_SIZE),
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
                    "size": Vector2(2.5 * BASE_SIZE, 3.5 * BASE_SIZE),
                    "rotation": 0.0
                }
            )
    
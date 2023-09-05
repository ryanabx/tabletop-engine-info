class_name DefaultConfig
extends TabletopGame

const BASE_SIZE: float = 96

func _init() -> void:
    pass

func settings() -> Dictionary:
    return {
        "max_players": 1,
        "min_players": 1
    }

func export_settings() -> Dictionary:
    return {
        "name":"Default Config",
        "schema_version": 1,
        "game_version": 1,
        "include_folders": [],
        "include_types": [],
        "include_image_folders": ["images"],
        "include_image_types": [".svg"]
    }

func add_board(_board: Board) -> void:
    self.board = _board
    board.border = Rect2(-10 * BASE_SIZE, -10 * BASE_SIZE,\
    20 * BASE_SIZE, 20 * BASE_SIZE)

func game_start() -> void:
    board.clear_board()
    var draw_pile: Collection = board.new_game_object(
        Collection,
        {
            "name": "DRAW_PILE",
            "position": Vector2.ZERO * BASE_SIZE,
            "size": Vector2.ONE * BASE_SIZE,
            "permanent": true,
            "lock_state": true,
            "face_up": false
        }
    )

    var place_pile: Collection = board.new_game_object(
        Collection,
        {
            "name": "PLACE_PILE",
            "position": Vector2.ONE * 2 * BASE_SIZE,
            "size": Vector2.ONE * BASE_SIZE,
            "permanent": true,
            "lock_state": true,
            "face_up": true
        }
    )

    for i in range(20):
        var pc: Piece = board.new_game_object(
            Piece,
            {
                "size": Vector2.ONE * BASE_SIZE,
                "image_up": "images/icon.svg",
                "image_down": "images/icon.svg",
                "face_up": false
            }
        )
        draw_pile.add_piece(pc)
    
    for i in range(20):
        var pc: Piece = board.new_game_object(
            Piece,
            {
                "size": Vector2.ONE * BASE_SIZE,
                "image_up": "images/icon.svg",
                "image_down": "images/icon.svg",
                "face_up": false
            }
        )
        place_pile.add_piece(pc)
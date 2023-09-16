class_name UNO
extends TabletopGame

const BASE_SIZE: float = 64.0

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

func can_stack_piece(piece: Piece, collection: Collection) -> bool:
    if collection.name != "PLACE_PILE" or collection.get_inside().is_empty():
        return true
    var types_1 = collection.get_inside().back().types
    var types_2 = piece.types

    if "WILD" in types_1 or "WILD" in types_2\
    or "DRAW4" in types_1 or "DRAW4" in types_2:
        return true
    
    for type in types_1:
        if type in types_2:
            return true
    
    return false


func add_board(_board: Board) -> void:
    self.board = _board
    board.border = Rect2(-10 * BASE_SIZE, -10 * BASE_SIZE,\
    20 * BASE_SIZE, 20 * BASE_SIZE)
    board.background = "images/bg.jpg"

func game_start() -> void:
    board.clear_board()
    var draw_pile: Collection = board.new_game_object(
        board.GameObjectType.DECK,
        {
            "name": "DRAW_PILE",
            "position": Vector2(-1.5 * BASE_SIZE, 0 * BASE_SIZE),
            "size": Vector2(2.5 * BASE_SIZE, 3.5 * BASE_SIZE),
            "rotation": 0.0,
            "permanent": true,
            "lock_state": true,
            "face_up": false
        }
    )
    for color in COLORS:
        for type in CARD_TYPES:
            for i in range(2):
                var pc: Piece = board.new_game_object(
                    board.GameObjectType.PIECE,
                    {
                        "face_up": false,
                        "image_up": str("images/UNO_",color,type,".png"),
                        "image_down": "images/UNO_FLIPPED.png",
                        "size": Vector2(2.5 * BASE_SIZE, 3.5 * BASE_SIZE),
                        "rotation": 0.0,
                        "types": [color, type]
                    }
                )
                draw_pile.add_piece(pc)
                
    for type in SPECIAL_CARDS:
        for i in range(4):
            var pc: Piece = board.new_game_object(
                board.GameObjectType.PIECE,
                {
                    "face_up": false,
                    "image_up": str("images/UNO_",type,".png"),
                    "image_down": "images/UNO_FLIPPED.png",
                    "size": Vector2(2.5 * BASE_SIZE, 3.5 * BASE_SIZE),
                    "rotation": 0.0,
                    "types": [type]
                }
            )
            draw_pile.add_piece(pc)
    board.new_game_object(
        board.GameObjectType.DECK,
        {
            "name": "PLACE_PILE",
            "position": Vector2(1.5 * BASE_SIZE, 0 * BASE_SIZE),
            "size": Vector2(2.5 * BASE_SIZE, 3.5 * BASE_SIZE),
            "rotation": 0.0,
            "permanent": true,
            "lock_state": true,
            "face_up": true
        }
    )

    board.new_game_object(
        board.GameObjectType.HAND,
        {
            "name": "PLAYER_1_HAND",
            "position": Vector2(0 * BASE_SIZE, 7 * BASE_SIZE),
            "size": Vector2(8 * BASE_SIZE, 3.5 * BASE_SIZE),
            "size_pieces": Vector2(2.5 * BASE_SIZE, 3.5 * BASE_SIZE),
            "visibility": Hand.VisibilitySetting.DESIGNATED,
            "designated_players": [1],
            "size_option": Hand.SizeOption.GROW_FIXED
        }
    )

    board.new_game_object(
        board.GameObjectType.HAND,
        {
            "name": "PLAYER_2_HAND",
            "position": Vector2(7 * BASE_SIZE, 0 * BASE_SIZE),
            "rotation_degrees": 270,
            "size": Vector2(8 * BASE_SIZE, 3.5 * BASE_SIZE),
            "size_pieces": Vector2(2.5 * BASE_SIZE, 3.5 * BASE_SIZE),
            "visibility": Hand.VisibilitySetting.DESIGNATED,
            "designated_players": [2],
            "size_option": Hand.SizeOption.GROW_FIXED
        }
    )

    board.new_game_object(
        board.GameObjectType.HAND,
        {
            "name": "PLAYER_3_HAND",
            "position": Vector2(0 * BASE_SIZE, -7 * BASE_SIZE),
            "rotation_degrees": 180,
            "size": Vector2(8 * BASE_SIZE, 3.5 * BASE_SIZE),
            "size_pieces": Vector2(2.5 * BASE_SIZE, 3.5 * BASE_SIZE),
            "visibility": Hand.VisibilitySetting.DESIGNATED,
            "designated_players": [3],
            "size_option": Hand.SizeOption.GROW_FIXED
        }
    )

    board.new_game_object(
        board.GameObjectType.HAND,
        {
            "name": "PLAYER_4_HAND",
            "position": Vector2(-7 * BASE_SIZE, 0 * BASE_SIZE),
            "rotation_degrees": 90,
            "size": Vector2(8 * BASE_SIZE, 3.5 * BASE_SIZE),
            "size_pieces": Vector2(2.5 * BASE_SIZE, 3.5 * BASE_SIZE),
            "visibility": Hand.VisibilitySetting.DESIGNATED,
            "designated_players": [4],
            "size_option": Hand.SizeOption.GROW_FIXED
        }
    )

    call_deferred("deal_cards")

const START_HAND: int = 7

func deal_cards() -> void:
    board.get_gobject("DRAW_PILE").shuffle()
    board.move_piece(board.get_gobject("DRAW_PILE"), board.get_gobject("PLACE_PILE"))
    for hand in ["PLAYER_1_HAND", "PLAYER_2_HAND", "PLAYER_3_HAND", "PLAYER_4_HAND"]:
        for i in range(START_HAND):
            board.move_piece(board.get_gobject("DRAW_PILE"), board.get_gobject(hand))
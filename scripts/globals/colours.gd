extends Node

const hex = {
	1: "de3627",
	2: "ffd32a",
	4: "005ee5",
	3: "f67f0d",
	6: "8ac926",
	5: "7f55bc",
	7: "613e13",
}

func colour_of(mask: int) -> Color:
	return Color.from_string(hex.get(mask, "#ff00ff"), Color.MAGENTA)

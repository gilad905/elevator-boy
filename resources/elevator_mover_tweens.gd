extends Resource

var tweens = {
	start = {
		abs_from = 0,
		abs_to = 1,
		trans = Tween.TRANS_SINE,
		ease = Tween.EASE_IN,
	},
	move = {
		abs_from = 1,
		abs_to = 1,
		trans = Tween.TRANS_LINEAR,
		ease = Tween.EASE_IN_OUT, # irrelevant
	},
	stop = {
		abs_from = 1,
		abs_to = 0,
		trans = Tween.TRANS_SINE,
		ease = Tween.EASE_OUT,
	},
	start_stop = {
		abs_from = 0,
		abs_to = 0,
		trans = Tween.TRANS_SINE,
		ease = Tween.EASE_IN_OUT,
	},
}
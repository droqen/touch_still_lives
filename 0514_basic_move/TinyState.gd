extends Reference
class_name TinyState

var _state
var state setget _set_state, _get_state

var _mut_call_owner
var _mut_call_method_name

func _init(state, mut_call_owner : Node, mut_call_method_name, skip_mut = false):
	_state = state
	_mut_call_owner = mut_call_owner
	_mut_call_method_name = mut_call_method_name
	if not skip_mut: _mut_call_owner.call(_mut_call_method_name, null, state)

func goto(state, force_mut = false, skip_mut = false):
	var prev_state = _state
	var callmut = (((_state == state) or force_mut) and not skip_mut)
	_state = state
	if callmut: _mut_call_owner.call(_mut_call_method_name, prev_state, state)
func at(state) -> bool:
	return _state == state

func _set_state(state):
	goto(state)
func _get_state():
	return _state

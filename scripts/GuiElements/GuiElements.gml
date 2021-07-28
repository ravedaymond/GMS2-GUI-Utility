// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function GuiElement(_sprite) constructor {
	sprite = _sprite;
	hover = false;
}

function GuiElementWindowButtonAction(_sprite, _position) : GuiElement(_sprite) constructor {
	position = _position;
}

function GuiElementWindowButtonToggle(_sprite,  _position) : GuiWindowButtonSingleAction(_sprite, _position) constructor {
	enabled = false;
}

function GuiElementCheckBox(_sprite, _value) : GuiElement(_sprite) constructor {
	enabled = false;
	value = _value;
}

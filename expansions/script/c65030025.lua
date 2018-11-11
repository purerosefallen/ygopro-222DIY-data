--醒觉的二重阴影
function c65030025.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsXyzType,TYPE_NORMAL),5,3)
	c:EnableReviveLimit()
end
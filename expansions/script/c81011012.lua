--爽了鸽
function c81011012.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),2)
	c:EnableReviveLimit()
end

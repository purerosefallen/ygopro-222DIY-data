--原数黑姬 公主
function c12011020.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c12011020.matfilter,2)
	c:EnableReviveLimit()
end
function c12011020.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT)
end
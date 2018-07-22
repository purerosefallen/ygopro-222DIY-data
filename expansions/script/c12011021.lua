--原数黑姬 公主
function c12011021.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c12011021.matfilter,3,2)
	c:EnableReviveLimit()
end
function c12011021.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
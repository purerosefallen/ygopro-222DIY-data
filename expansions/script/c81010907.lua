--Answer·服部瞳子
function c81010907.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c81010907.mfilter,1,1)
	c:EnableReviveLimit()
end
function c81010907.mfilter(c)
	return c:IsSummonType(SUMMON_TYPE_NORMAL) and c:IsLinkType(TYPE_NORMAL)
end
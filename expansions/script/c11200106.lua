--虚空之黯
function c11200106.initial_effect(c)
	aux.AddRitualProcGreater2Code2(c,11200103,11200104,nil,c11200106.mfilter)
	--spsummon
	local e3=aux.AddRitualProcGreater2Code2(c,11200103,11200104,LOCATION_REMOVED+LOCATION_GRAVE,c11200106.mfilter)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(0)
	e3:SetCountLimit(1,11200106)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(aux.exccon)
	e3:SetCost(aux.bfgcost)
end
function c11200106.mfilter(c)
	return c:IsType(TYPE_MONSTER)
end

--Celestial Tears
function c26807006.initial_effect(c)
	local e1=aux.AddRitualProcGreater2(c,c26807006.ritual_filter,nil,nil,c26807006.ritual_filter)
	e1:SetCountLimit(1,26807006+EFFECT_COUNT_CODE_OATH)	
end
function c26807006.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)
end
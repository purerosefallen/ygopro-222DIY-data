--HappySky·星辉子
function c81007015.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--lock
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetTargetRange(LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA+LOCATION_OVERLAY+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA+LOCATION_OVERLAY+LOCATION_ONFIELD)  
	c:RegisterEffect(e2)
end

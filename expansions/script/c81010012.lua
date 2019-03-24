--Inverse World
function c81010012.initial_effect(c)
	e1=aux.AddRitualProcGreater(c,c81010012.ritual_filter)
	e1:SetCountLimit(1,81010012+EFFECT_COUNT_CODE_OATH)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c81010012.handcon)
	c:RegisterEffect(e2)
end
function c81010012.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)
end
function c81010012.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end

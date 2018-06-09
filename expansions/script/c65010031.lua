--虚数魔域 薇汀
function c65010031.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,1,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(c65010031.limit)
	c:RegisterEffect(e1) 
	--link limit
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c65010031.regcon)
	e3:SetOperation(c65010031.regop)
	c:RegisterEffect(e3)
end
function c65010031.limit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_CYBERSE)
end
function c65010031.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c65010031.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c65010031.linklimit)
	Duel.RegisterEffect(e1,tp)
end
function c65010031.linklimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(65010031) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
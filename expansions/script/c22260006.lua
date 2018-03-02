--退魔末裔 七夜志贵
function c22260006.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22260006)
	e1:SetCondition(c22260006.sprcon)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c22260006.val)
	c:RegisterEffect(e2)
end
c22260006.named_with_NanayaShiki=1
function c22260006.IsNanayaShiki(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_NanayaShiki
end
function c22260006.sprfilter1(c)
	return c:IsFaceup() and c:IsCode(22260007)
end
function c22260006.sprfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function c22260006.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetMZoneCount(tp)
	local ct1=Duel.GetMatchingGroupCount(c22260006.sprfilter1,tp,LOCATION_MZONE,0,nil)
	local ct2=Duel.GetMatchingGroupCount(c22260006.sprfilter2,tp,LOCATION_MZONE,0,nil)
	local ct3=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	return ft>0 and (ct1>0 or (ct2==ct3 and ct3>0))
end
function c22260006.val(e,c)
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)*700
end
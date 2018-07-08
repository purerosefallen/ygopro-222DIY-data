--色彩艳丽的门番
function c1156606.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1156606.mfilter,1)
--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c1156606.tg1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1156606,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c1156606.tg2)
	e2:SetOperation(c1156606.op2)
	c:RegisterEffect(e2)
--
end
--
function c1156606.mfilter(c)
	return c:GetSequence()>4
end
--
function c1156606.tg1(e,c)
	return c~=e:GetHandler()
end
--
function c1156606.tfilter2(c)
	return c:IsSpecialSummonable(SUMMON_TYPE_LINK)
end
--
function c1156606.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local checknum=0
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e2_1:SetValue(1)
		c:RegisterEffect(e2_1,true)
		if Duel.IsExistingMatchingCard(c1156606.tfilter2,tp,LOCATION_EXTRA,0,1,nil) then checknum=1 end
		e2_1:Reset()
		return checknum==1
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
--
function c1156606.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2_2=Effect.CreateEffect(c)
	e2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2_2:SetType(EFFECT_TYPE_SINGLE)
	e2_2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2_2:SetValue(1)
	c:RegisterEffect(e2_2,true)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c1156606.tfilter2,tp,LOCATION_EXTRA,0,1,1,nil)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_LINK)
	end
	e2_2:Reset()
end
--

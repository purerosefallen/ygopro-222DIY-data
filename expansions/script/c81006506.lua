--tricoro·本田未央
function c81006506.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c81006506.value)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c81006506.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,81006506)
	e4:SetCondition(c81006506.spcon)
	e4:SetTarget(c81006506.sptg)
	e4:SetOperation(c81006506.spop)
	c:RegisterEffect(e4)
end
function c81006506.filter(c)
	return c:IsType(TYPE_TOKEN)
end
function c81006506.value(e,c)
	return Duel.GetMatchingGroupCount(c81006506.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)*1200
end
function c81006506.indcon(e)
	return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end
function c81006506.spfilter(c,tp)
	return c:IsType(TYPE_TOKEN)
end
function c81006506.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81006506.spfilter,1,nil,tp)
end
function c81006506.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81006507,0,0x4011,1000,1000,4,RACE_FAIRY,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c81006506.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,81006507,0,0x4011,1000,1000,4,RACE_FAIRY,ATTRIBUTE_FIRE) then
		local token=Duel.CreateToken(tp,81006507)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end

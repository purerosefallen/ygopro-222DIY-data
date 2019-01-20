function c81019015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,81019015)
	e1:SetCondition(c81019015.condition)
	e1:SetTarget(c81019015.target)
	e1:SetOperation(c81019015.activate)
	c:RegisterEffect(e1)
end
function c81019015.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:GetPreviousControler()==tp
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetPreviousCodeOnField()==81010019
end
function c81019015.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81019015.cfilter,1,nil,tp)
end
function c81019015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81019016,0,0x4011,1400,1400,7,RACE_FAIRY,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c81019015.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81019016,0,0x4011,1400,1400,7,RACE_FAIRY,ATTRIBUTE_WATER) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,81019016)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end

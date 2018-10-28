--星夜的祈愿
function c81009050.initial_effect(c)
	--Draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(c81009050.drcon)
	e4:SetTarget(c81009050.target)
	e4:SetOperation(c81009050.activate)
	c:RegisterEffect(e4)
end
function c81009050.drcfilter(c)
	return c:IsFaceup() and c:IsCode(81010038,81010042,81010003,81007002)
end
function c81009050.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81009050.drcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81009050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81009052,0,0x4011,1000,1000,4,RACE_FAIRY,ATTRIBUTE_FIRE,POS_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c81009050.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81009052,0,0x4011,1000,1000,4,RACE_FAIRY,ATTRIBUTE_FIRE,POS_FACEUP_DEFENSE) then return end
	local token=Duel.CreateToken(tp,81009052)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end

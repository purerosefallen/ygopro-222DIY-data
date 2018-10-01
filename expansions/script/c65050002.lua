--唤灵影姬 俄索
function c65050002.initial_effect(c)
	c:EnableReviveLimit()
	--ritual level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(c65050002.rlevel)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,65050002)
	e2:SetTarget(c65050002.sptg)
	e2:SetOperation(c65050002.spop)
	c:RegisterEffect(e2)
end
function c65050002.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x3da1) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c65050002.thfil(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3da1) and c:IsAbleToHand()
end
function c65050002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,65050012,0,0x4011,0,0,2,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c65050002.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c65050002.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,65050012,0,0x4011,0,0,2,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,65050012)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1)
	if Duel.SpecialSummonComplete()~=0 then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c65050002.thfil,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
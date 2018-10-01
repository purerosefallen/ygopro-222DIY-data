--唤灵幻姬 茶
function c65050004.initial_effect(c)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65050004,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c65050004.atkcost)
	e1:SetOperation(c65050004.operation)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,65050004)
	e2:SetTarget(c65050004.sptg)
	e2:SetOperation(c65050004.spop)
	c:RegisterEffect(e2)
end

function c65050004.atkcofil(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasable()
end

function c65050004.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050004.atkcofil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	local sg=Duel.SelectMatchingCard(tp,c65050004.atkcofil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=sg:GetFirst()
	Duel.Release(sg,REASON_COST)
end
function c65050004.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x3da1)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c65050004.thfil(c)
	return c:IsSetCard(0x3da1) and c:IsAbleToHand()
end
function c65050004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,65050012,0,0x4011,0,0,4,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c65050004.thfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE)
end
function c65050004.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,65050012,0,0x4011,0,0,4,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,65050012)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(4)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1)
	if Duel.SpecialSummonComplete()~=0 then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c65050004.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
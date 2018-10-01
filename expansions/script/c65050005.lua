--唤灵祈姬 菲莉
function c65050005.initial_effect(c)
	c:EnableReviveLimit()
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c65050005.cost)
	e1:SetTarget(c65050005.target)
	e1:SetOperation(c65050005.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,65050005)
	e2:SetTarget(c65050005.sptg)
	e2:SetOperation(c65050005.spop)
	c:RegisterEffect(e2)
end

function c65050005.cofil(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasable()
end

function c65050005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050005.cofil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	local sg=Duel.SelectMatchingCard(tp,c65050005.cofil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=sg:GetFirst()
	e:SetLabel(tc:GetAttack())
	Duel.Release(sg,REASON_COST)
end
function c65050005.filter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c65050005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c65050005.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65050005.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c65050005.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c65050005.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		Duel.AdjustInstantly(tc)
	end
end

function c65050005.thfil(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x3da1) and c:IsAbleToHand()
end
function c65050005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,65050012,0,0x4011,0,0,5,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c65050005.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c65050005.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,65050012,0,0x4011,0,0,5,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,65050012)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(5)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1)
	if Duel.SpecialSummonComplete()~=0 then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c65050005.thfil,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
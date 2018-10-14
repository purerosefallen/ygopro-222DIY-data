--炫灵姬 A
function c12016011.initial_effect(c)
	c:SetSPSummonOnce(12016011,1156018)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c12016011.matfilter,2,2)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12016011,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c12016011.thtg)
	e2:SetOperation(c12016011.thop)
	c:RegisterEffect(e2)
	 --return
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c12016011.retreg)
	c:RegisterEffect(e3)
end
function c12016011.matfilter(c)
	return c:IsLinkSetCard(0xfb9) or c:IsType(TYPE_TOKEN)
end
function c12016011.thfilter1(c)
	return c:IsType(TYPE_SPIRIT) and c:IsType(TYPE_PENDULUM)
end
function c12016011.thfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c12016011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12016011.thfilter1,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c12016011.thfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12016011.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12016011.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	local tg=Duel.SelectMatchingCard(tp,c12016011.thfilter2,tp,LOCATION_GRAVE,0,1,1,g)
	if g:GetCount()>0 and tg:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.SendtoHand(tg,tp,REASON_EFFECT)
	end
end
function c12016011.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(aux.SpiritReturnCondition)
	e1:SetTarget(c12016011.rettg)
	e1:SetOperation(c12016011.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e2)
end
function c12016011.retfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsFaceup()
end
function c12016011.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
			return true
		else
			return Duel.GetMatchingGroupCount(c12016011.retfilter,tp,LOCATION_EXTRA,0,nil)>0
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c12016011.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
	   Duel.SendtoDeck(c,nil,2,REASON_EFFECT) end
	if Duel.GetMatchingGroupCount(c12016011.retfilter,tp,LOCATION_EXTRA,0,nil)>0 then
		local g=Duel.GetMatchingGroup(c12016011.retfilter,tp,LOCATION_EXTRA,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c12016011.retfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(12016011,5)) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12016008,0,0x4011,1600,1600,4,RACE_WINDBEAST,ATTRIBUTE_LIGHT) then
			local token=Duel.CreateToken(tp,12016008)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
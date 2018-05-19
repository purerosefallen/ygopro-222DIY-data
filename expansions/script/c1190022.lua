--深绿之心·波拉
--
c1190022.dfc_front_side=1190021
c1190022.dfc_back1_side=1190022
c1190022.dfc_back2_side=1190023
--
function c1190022.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCountLimit(1)
	e0:SetCondition(c1190022.backon)
	e0:SetOperation(c1190022.backop)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1190022,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c1190022.tg1)
	e1:SetOperation(c1190022.op1)
	c:RegisterEffect(e1)
--
end
--
function c1190022.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c.dfc_front_side and c:GetOriginalCode()==c.dfc_back1_side
end
function c1190022.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=c.dfc_front_side
	c:SetEntityCode(tcode)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(tcode,0,0)
end
--
function c1190022.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local sg=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
end
--
function c1190022.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_PUBLIC)
		e1_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_1)
		tc:RegisterFlagEffect(1190022,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,66)
		local e1_2=Effect.CreateEffect(c)
		e1_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1_2:SetType(EFFECT_TYPE_FIELD)
		e1_2:SetCode(EFFECT_ACTIVATE_COST)
		e1_2:SetRange(LOCATION_HAND)
		e1_2:SetReset(RESET_EVENT+0x1fe0000)
		e1_2:SetTargetRange(1,0)
		e1_2:SetTarget(c1190022.tg1_2)
		e1_2:SetCost(c1190022.cost1_2)
		e1_2:SetOperation(c1190022.op1_2)
		tc:RegisterEffect(e1_2)
		tc:RegisterFlagEffect(1190023,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(1190022,1))
	end
end
--
function c1190022.tg1_2(e,te,tp)
	return te:GetHandler()==e:GetHandler()
end
function c1190022.cost1_2(e,c,tp)
	return Duel.IsCanRemoveCounter(tp,1,0,0x1119,1,REASON_COST)
end
function c1190022.op1_2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(tp,1,0,0x1,1,REASON_COST)
end
--

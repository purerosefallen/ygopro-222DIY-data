--六曜 赤口的完红丘依儿
function c12001018.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12001018,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12001018)
	e1:SetCost(c12001018.cost1)
	e1:SetOperation(c12001018.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12001018,2))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,12001104)
	e2:SetCondition(c12001018.con2)
	e2:SetOperation(c12001018.op2)
	c:RegisterEffect(e2)
--
end
--
function c12001018.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
--
function c12001018.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1_1:SetLabelObject(c)
	e1_1:SetCondition(c12001018.con1_1)
	e1_1:SetOperation(c12001018.op1_1)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_1,tp)
--
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1_2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1_2:SetCondition(c12001018.con1_2)
	e1_2:SetOperation(c12001018.op1_2)
	e1_2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_2,tp)
	local e1_3=Effect.CreateEffect(c)
	e1_3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1_3:SetCode(EVENT_CHAIN_SOLVED)
	e1_3:SetLabelObject(c)
	e1_3:SetCondition(c12001018.con1_3)
	e1_3:SetOperation(c12001018.op1_3)
	e1_3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_3,tp)
--
end
--
function c12001018.cfilter1_1(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c12001018.con1_1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12001018.cfilter1_1,1,nil,tp) 
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c12001018.op1_1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(12001018,1)) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	local c=e:GetLabelObject()
	if tc:IsSetCard(0xfb0) then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
	else
		if c:IsLocation(LOCATION_GRAVE) and tc:IsAbleToHand() then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
			Duel.ShuffleHand(tp)
		else
			Duel.ShuffleDeck(tp)
		end
	end
end
--
function c12001018.con1_2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12001018.cfilter1_1,1,nil,tp) 
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c12001018.op1_2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,12001018,RESET_CHAIN,0,1)
end
function c12001018.con1_3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,12001018)>0
end
function c12001018.op1_3(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,12001018)
	Duel.ResetFlagEffect(tp,12001018)
	while n>0 do
		if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
		if not Duel.SelectYesNo(tp,aux.Stringid(12001018,1)) then return end
		Duel.ConfirmDecktop(tp,1)
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst()
		local c=e:GetLabelObject()
		if tc:IsSetCard(0xfb0) then
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
		else
			if c:IsLocation(LOCATION_GRAVE) and tc:IsAbleToHand() then
				Duel.DisableShuffleCheck()
				Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
				Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
				Duel.ShuffleHand(tp)
			else
				Duel.ShuffleDeck(tp)
			end
		end
		n=n-1
	end
end
--
function c12001018.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsReason(REASON_REVEAL)
end
--
function c12001018.tfilter2(c)
	return c:IsAbleToRemove()
end
function c12001018.op2(e,tp,eg,ep,ev,re,r,rp)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(1-tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	local tc=g:GetFirst()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_RULE)
	end
end

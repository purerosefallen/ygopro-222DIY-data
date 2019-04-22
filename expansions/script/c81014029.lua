--平行少女世界
function c81014029.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c81014029.matfilter,nil,nil,aux.NonTuner(Card.IsType,TYPE_RITUAL),1,99)
	c:EnableReviveLimit()
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,81014029)
	e1:SetTarget(c81014029.tdtg)
	e1:SetOperation(c81014029.tdop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,81014929)
	e2:SetTarget(c81014029.tgtg)
	e2:SetOperation(c81014029.tgop)
	c:RegisterEffect(e2)
end
function c81014029.matfilter(c)
	return c:IsSynchroType(TYPE_TUNER) or (c:IsAttack(1550) and c:IsDefense(1050))
end
function c81014029.tdfilter(c,e)
	return c:IsType(TYPE_RITUAL) and (c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_SPELL)) and c:IsAbleToDeck() and (not e or c:IsCanBeEffectTarget(e))
end
function c81014029.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c81014029.tdfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=3 end
	local tg=Group.CreateGroup()
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		tg:Merge(sg)
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
	until tg:GetCount()==3
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,tg:GetCount(),0,0)
end
function c81014029.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==0 then return end
	if Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)==0 then return end
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	if ct>0 then Duel.SortDecktop(tp,tp,ct) end
end
function c81014029.tgfilter1(c,tp)
	return c:IsType(TYPE_RITUAL) and (c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_SPELL))
		and Duel.IsExistingMatchingCard(c81014029.tgfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c81014029.tgfilter2(c,cd)
	return c:IsCode(cd) and c:IsAbleToHand()
end
function c81014029.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsCode(e:GetLabel()) end
	if chk==0 then return Duel.IsExistingTarget(c81014029.tgfilter1,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c81014029.tgfilter1,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81014029.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c81014029.tgfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end

--樱色乐章 二宫飞鸟
function c18734605.initial_effect(c)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(52068432,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c18734605.con)
	e1:SetTarget(c18734605.tdtg)
	e1:SetOperation(c18734605.tdop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17393207,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,18734605)
	e2:SetCost(c18734605.cost)
	e2:SetTarget(c18734605.target)
	e2:SetOperation(c18734605.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e3)
end
function c18734605.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c18734605.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c18734605.tdop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
		local sg=g:Select(p,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		Duel.ShuffleHand(1-p)
		local tc=sg:GetFirst()
		if tc:IsType(TYPE_MONSTER) then
			Duel.Recover(tp,tc:GetLevel()*300,REASON_EFFECT)
		end
	end
end
function c18734605.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c18734605.filter1(c,e)
	return c:IsSetCard(0xab4) and c:IsAbleToGrave() and c:IsCanBeEffectTarget(e) and c:IsFaceup()
end
function c18734605.filter(c,e)
	return c:IsAbleToGrave() and c:IsCanBeEffectTarget(e)
end
function c18734605.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c18734605.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if chk==0 then return Duel.IsExistingMatchingCard(c18734605.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e) and Duel.IsExistingMatchingCard(c18734605.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil,e)
	end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c18734605.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e)
		g:Sub(g1)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g2=g:Select(tp,1,1,nil)
			g1:Merge(g2)
		end
		Duel.SetTargetCard(g1)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,g1:GetCount(),0,0)
end
function c18734605.operation(e,tp,eg,ep,ev,re,r,rp)
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
		if not sg or sg:FilterCount(Card.IsRelateToEffect,nil,e)<1 then return end
		Duel.SendtoGrave(sg,REASON_EFFECT)
end
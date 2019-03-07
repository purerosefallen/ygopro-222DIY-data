--无法回头的命运
function c75646315.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,75646315)
	e1:SetCondition(c75646315.condition)
	e1:SetTarget(c75646315.target)
	e1:SetOperation(c75646315.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,75646315)
	e2:SetCondition(c75646315.con)
	e2:SetTarget(c75646315.tg)
	e2:SetOperation(c75646315.op)
	c:RegisterEffect(e2)
	c75646315.act_effect=e2
end
function c75646315.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x62c1)
end
function c75646315.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c75646315.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c75646315.remfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0x62c1)
end
function c75646315.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c75646315.remfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c75646315.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		if Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)~=0 and ec:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
			local g=Duel.GetMatchingGroup(c75646315.remfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local sg=g:Select(tp,1,1,nil)
				if sg:GetFirst():IsLocation(LOCATION_HAND) then 
				Duel.ConfirmCards(1-tp,sg)
				end
				Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	end
end
function c75646315.con(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x62c1) 
		and re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c75646315.setfilter(c)
	return c:IsSetCard(0x62c1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c75646315.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c75646315.setfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c75646315.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c75646315.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c75646315.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsSSetable() then
	   Duel.SSet(tp,tc)
	   Duel.ConfirmCards(1-tp,tc)
		if tc~=e:GetHandler() and e:GetHandler():IsRelateToEffect(e)
		and e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
		end
	end
end
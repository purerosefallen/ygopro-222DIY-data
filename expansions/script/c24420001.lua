--圣晶石召唤
function c24420001.initial_effect(c)
	aux.AddRitualProcEqual2(c,c24420001.ritual_filter)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,24420001)
	e1:SetCost(c24420001.thcost)
	e1:SetTarget(c24420001.thtg)
	e1:SetOperation(c24420001.thop)
	c:RegisterEffect(e1)
end
function c24420001.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x244) 
end
function c24420001.cfilter(c)
	return c:IsSetCard(0x244) and c:IsAbleToDeckAsCost()
end
function c24420001.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24420001.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c24420001.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c24420001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c24420001.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
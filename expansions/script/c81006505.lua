--不经意间被吓个半死
function c81006505.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,81006505)
	e1:SetCondition(c81006505.condition)
	e1:SetTarget(c81006505.target)
	e1:SetOperation(c81006505.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,81006595)
	e2:SetCondition(c81006505.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81006505.thtg)
	e2:SetOperation(c81006505.thop)
	c:RegisterEffect(e2)
end
function c81006505.cfilter(c)
	return not c:IsType(TYPE_EFFECT)
end
function c81006505.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81006505.cfilter,1,nil)
end
function c81006505.filter(c)
	return c:IsType(TYPE_EFFECT)
end
function c81006505.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c81006505.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c81006505.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81006505.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c81006505.thcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c81006505.thfilter(c)
	return (c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT)) and c:IsAbleToHand()
end
function c81006505.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c81006505.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81006505.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c81006505.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81006505.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

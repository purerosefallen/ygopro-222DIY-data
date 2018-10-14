--聚镒素 风风
function c10110013.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c10110013.ffilter,2,true)
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10110013,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c10110013.tdtg)
	e1:SetOperation(c10110013.tdop)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10110013,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10110013)
	e2:SetLabel(0)
	e2:SetCost(c10110013.thcost)
	e2:SetTarget(c10110013.thtg)
	e2:SetOperation(c10110013.thop)
	c:RegisterEffect(e2)  
end
function c10110013.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10110013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   if e:GetLabel()~=100 then return false end
	   e:SetLabel(0)
	   return Duel.IsExistingMatchingCard(c10110013.cfilter,tp,LOCATION_REMOVED,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10110013,2))
	local g=Duel.SelectMatchingCard(tp,c10110013.cfilter,tp,LOCATION_REMOVED,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST+REASON_RETURN)
	e:SetLabel(g:GetFirst():GetAttribute())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10110013.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10110013.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	e:SetLabel(0)
	if g:GetCount()>0 then
	   Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c10110013.cfilter(c,tp)
	return c:IsSetCard(0x9332) and c:IsFaceup() and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c10110013.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute())
end
function c10110013.thfilter(c,att)
	return c:IsSetCard(0x9332) and c:IsType(TYPE_MONSTER) and c:IsAttribute(att) and c:IsAbleToHand()
end
function c10110013.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10110013.tdfilter,1,nil,tp) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c10110013.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 and Duel.GetOperatedGroup():IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
	   Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c10110013.tdfilter(c,tp)
	return not c:IsControler(tp) and c:IsAbleToDeck()
end
function c10110013.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionAttribute(ATTRIBUTE_WIND) and (not sg or sg:IsExists(Card.IsFusionSetCard,1,nil,0x9332))
end
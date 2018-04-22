--红豆椰子奶茶
function c4210022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,4210022)
	e1:SetCondition(c4210022.condition)
	e1:SetTarget(c4210022.target)
	e1:SetOperation(c4210022.operation)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4210022,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,4210022)
	e2:SetCost(c4210022.cost)
	e2:SetTarget(c4210022.tg)
	e2:SetOperation(c4210022.op)
	c:RegisterEffect(e2)
end
function c4210022.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c4210022.filter(c)
	return (c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_EARTH)) and c:IsType(TYPE_MONSTER)
end
function c4210022.condition(e,c)
	return (not Duel.IsExistingMatchingCard(c4210022.filter,tp,LOCATION_MZONE,0,1,nil))
		or Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_MZONE,0)==0 
end
function c4210022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(c4210022.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c4210022.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c4210022.operation(e,tp,eg,ep,ev,re,r,rp)
	local gs=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=gs:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT) and sg:Filter(Card.IsSetCard,nil,0x2af):GetCount()>0 then
		local g=Duel.SelectMatchingCard(tp,function(c)return c:IsSetCard(0x2af) and c:IsAbleToHand()end,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end		
	end	
end
function c4210022.rmfilter(c)
	return (c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_EARTH)) and c:IsType(TYPE_MONSTER)
end
function c4210022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4210022.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c4210022.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c4210022.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c4210022.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end
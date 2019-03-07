--繁华之晶月魔印
function c65020074.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--negate activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c65020074.cost)
	e1:SetTarget(c65020074.target)
	e1:SetOperation(c65020074.operation)
	c:RegisterEffect(e1)
end
function c65020074.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and c:GetFlagEffect(65020074)==0 end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	c:RegisterFlagEffect(65020074,RESET_CHAIN,0,1)
end
function c65020074.setfil(c)
	return c:IsAbleToHand() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x9da3)
end
function c65020074.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c65020074.setfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65020074.setfil,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c65020074.setfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c65020074.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

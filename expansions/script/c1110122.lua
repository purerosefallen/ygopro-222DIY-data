--灵都·佑梦帷幕
local m=1110122
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1110122.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.TRUE,3,2,c1110122.ovfilter,aux.Stringid(1110122,0),2,c1110122.xyzop)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1110122,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c1110122.cost1)
	e1:SetTarget(c1110122.tg1)
	e1:SetOperation(c1110122.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c1110122.con2)
	e2:SetOperation(c1110122.op2)
	c:RegisterEffect(e2)
--
end
--
function c1110122.ovfilter(c)
	return c:IsFaceup() and c:IsCode(1110002)
end
function c1110122.ofilter(c)
	return muxu.check_set_Urban(c) and c:IsType(TYPE_FIELD)
end
function c1110122.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110122.ofilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
--
function c1110122.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local num=c:GetOverlayCount()
	if chk==0 then return c:GetOverlayCount()>0 and c:CheckRemoveOverlayCard(tp,num,REASON_COST) end
	c:RemoveOverlayCard(tp,num,num,REASON_COST)
end
--
function c1110122.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD)
end
--
function c1110122.ofilter1(c)
	return c:IsSSetable() and muxu.check_set_Lines(c)
end
function c1110122.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,1,nil)
	if sg:GetCount()<1 then return end
	if Duel.SendtoHand(sg,tp,REASON_EFFECT)<1 then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	if Duel.IsExistingMatchingCard(c1110122.ofilter1,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1110122,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tg=Duel.SelectMatchingCard(tp,c1110122.ofilter1,tp,LOCATION_DECK,0,1,1,nil)
		if tg:GetCount()<1 then return end
		Duel.SSet(tp,tg)
		Duel.ConfirmCards(1-tp,tg)
	end
end
--
function c1110122.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
--
function c1110122.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2_1:SetCode(EVENT_PHASE+PHASE_END)
	e2_1:SetCountLimit(1)
	e2_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e2_1:SetRange(LOCATION_GRAVE)
--	e2_1:SetCondition(c1110122.con2_1)
	e2_1:SetOperation(c1110122.op2_1)
	c:RegisterEffect(e2_1)
end
--
function c1110122.cfilter2_1(c)
	return c:IsCode(1110002) and c:IsAbleToHand()
end
--
--function c1110122.con2_1(e,tp,eg,ep,ev,re,r,rp)
--	return Duel.IsExistingMatchingCard(c1110122.cfilter2_1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
--end
--
function c1110122.op2_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return end
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c1110122.cfilter2_1,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
	if sg:GetCount()<1 then return end
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
--

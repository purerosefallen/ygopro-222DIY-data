--灵都·铭心之忆
local m=1110121
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1110121.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.TRUE,3,2,c1110121.ovfilter,aux.Stringid(1110121,0),2,c1110121.xyzop)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1110121,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c1110121.cost1)
	e1:SetTarget(c1110121.tg1)
	e1:SetOperation(c1110121.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c1110121.con2)
	e2:SetOperation(c1110121.op2)
	c:RegisterEffect(e2)
--
end
--
function c1110121.ovfilter(c)
	return c:IsFaceup() and c:IsCode(1110001)
end
function c1110121.ofilter(c)
	return muxu.check_set_Urban(c) and c:IsType(TYPE_FIELD)
end
function c1110121.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110121.ofilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
--
function c1110121.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local num=c:GetOverlayCount()
	if chk==0 then return c:GetOverlayCount()>0 and c:CheckRemoveOverlayCard(tp,num,REASON_COST) end
	c:RemoveOverlayCard(tp,num,num,REASON_COST)
end
--
function c1110121.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,LOCATION_ONFIELD)
end
--
function c1110121.ofilter1(c,code)
	return c:IsCode(code) and c:IsAbleToRemove()
end
function c1110121.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local code=tc:GetCode()
	local sg=Duel.GetMatchingGroup(c1110121.ofilter1,tp,0,LOCATION_HAND+LOCATION_EXTRA,nil,code)
	sg:AddCard(tc)
	if sg:GetCount()<1 then return end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
--
function c1110121.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
--
function c1110121.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2_1:SetCode(EVENT_PHASE+PHASE_END)
	e2_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e2_1:SetRange(LOCATION_GRAVE)
	e2_1:SetCountLimit(1)
--  e2_1:SetCondition(c1110121.con2_1)
	e2_1:SetOperation(c1110121.op2_1)
	c:RegisterEffect(e2_1)
end
--
function c1110121.cfilter2_1(c)
	return c:IsCode(1110001) and c:IsAbleToHand()
end
--
--function c1110121.con2_1(e,tp,eg,ep,ev,re,r,rp)
--  return Duel.IsExistingMatchingCard(c1110121.cfilter2_1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
--end
--
function c1110121.op2_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return end
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c1110121.cfilter2_1,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
	if sg:GetCount()<1 then return end
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
--

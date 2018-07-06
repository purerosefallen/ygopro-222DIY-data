--蝶舞·梦落
local m=1111004
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Butterfly=true
--
function c1111004.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c1111004.cost1)
	e1:SetTarget(c1111004.tg1)
	e1:SetOperation(c1111004.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c1111004.con2)
	e2:SetCost(c1111004.cost2)
	e2:SetTarget(c1111004.tg2)
	e2:SetOperation(c1111004.op2)
	c:RegisterEffect(e2)
--
end
--
function c1111004.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():GetOriginalCode()~=1111004 then return end
	Duel.RegisterFlagEffect(tp,1111004,RESET_PHASE+PHASE_END,0,0)
end
--
function c1111004.tfilter1(c)
	return c:IsAbleToDeck() and c:IsCode(1111001)
end
function c1111004.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return Duel.IsExistingMatchingCard(c1111004.tfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	local num=Duel.GetMatchingGroupCount(c1111004.tfilter1,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectTarget(tp,c1111004.tfilter1,tp,LOCATION_GRAVE,0,1,num,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
--
function c1111004.ofilter1(c,atk)
	return c:IsAbleToHand() and c:GetBaseAttack()<=atk and c:IsFaceup()
end
function c1111004.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gn=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if gn:GetCount()<1 then return end
	local num=Duel.SendtoDeck(gn,nil,2,REASON_EFFECT)
	if num<1 then return end
	local atk=num*1500
	local sg=Duel.GetMatchingGroup(c1111004.ofilter1,tp,0,LOCATION_MZONE,nil,atk)
	if sg:GetCount()<1 then return end
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
--
function c1111004.cfilter2(c)
	return muxu.check_set_Urban(c) and c:IsType(TYPE_FUSION) and c:IsFaceup()
end
function c1111004.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c1111004.cfilter2,tp,LOCATION_MZONE,0,nil)
	return ((c:CheckActivateEffect(false,true,false)~=nil and not c:GetActivateEffect():IsActivatable(tp)) or g:GetClassCount(Card.IsCode)>1) and Duel.GetFlagEffect(tp,1111004)<1
end
--
function c1111004.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
--
function c1111004.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
--
function c1111004.op2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
--

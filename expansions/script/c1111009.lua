--秘谈·彷徨的旅程
local m=1111009
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Legend=true
--
function c1111009.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c1111009.cost1)
	e1:SetTarget(c1111009.tg1)
	e1:SetOperation(c1111009.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c1111009.con2)
	e2:SetTarget(c1111009.tg2)
	e2:SetOperation(c1111009.op2)
	c:RegisterEffect(e2)
--
end
--
function c1111009.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckOrExtraAsCost,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckOrExtraAsCost,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
	local sg=Duel.GetOperatedGroup()
	local sc=sg:GetFirst()
	if sc:IsLocation(LOCATION_EXTRA) then e:SetLabel(100) end
end
--
function c1111009.tfilter1_1(c,tp)
	return muxu.check_set_Butterfly(c) and c:IsAbleToGrave() 
		and Duel.IsExistingMatchingCard(c1111009.tfilter1_2,tp,LOCATION_DECK,0,1,nil,c)
end
function c1111009.tfilter1_2(c,tc)
	return muxu.check_set_Soul(c) and c:IsAbleToGrave() and c~=tc
end
function c1111009.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1111009.tfilter1_1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
--
function c1111009.op1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel() and e:GetLabel()==100
		and Duel.IsChainDisablable(0) then
			Duel.NegateEffect(0)
			return
	end
	local lg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg1=Duel.SelectMatchingCard(tp,c1111009.tfilter1_1,tp,LOCATION_DECK,0,1,1,nil)
	if sg1:GetCount()>0 then
		local tc1=sg1:GetFirst()
		lg:AddCard(tc1)
	end
	local sg2=Duel.SelectMatchingCard(tp,c1111009.tfilter1_2,tp,LOCATION_DECK,0,1,1,nil,tc1)
	if sg2:GetCount()>0 then
		local tc2=sg2:GetFirst()
		lg:AddCard(tc2)
	end
	if lg:GetCount()<1 then return end
	Duel.SendtoGrave(lg,REASON_EFFECT)
end
--
function c1111009.cfilter2(c)
	return c:IsPreviousLocation(LOCATION_GRAVE)
		and c:IsType(TYPE_MONSTER) and muxu.check_set_Urban(c)
end
function c1111009.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1111009.cfilter2,1,nil)
end
--
function c1111009.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_GRAVE)
end
--
function c1111009.op2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
--

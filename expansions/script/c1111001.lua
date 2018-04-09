--三叶草 or 四叶草
local m=1111001
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1111001.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_COIN+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1111001)
	e1:SetTarget(c1111001.tg1)
	e1:SetOperation(c1111001.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c1111001.cost2)
	e2:SetTarget(c1111001.tg2)
	e2:SetOperation(c1111001.op2)
	c:RegisterEffect(e2)
--
end
--
function c1111001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
--
function c1111001.ofilter1_1(c)
	return c:IsAbleToGrave() and muxu.check_set_Legend(c)
end
function c1111001.ofilter1_2(c)
	return c:IsAbleToHand() and muxu.check_set_Butterfly(c)
end
function c1111001.ofilter1_3(c)
	return c:IsAbleToHand() and c:GetSequence()<5
end
function c1111001.op1(e,tp,eg,ep,ev,re,r,rp)
	local r1,r2,r3=Duel.TossCoin(tp,3)
	local num=Duel.GetFlagEffect(tp,1111001)
	if r1+r2+r3+num>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=Duel.SelectMatchingCard(tp,c1111001.ofilter1_1,tp,LOCATION_DECK,0,1,1,nil)
		if sg1:GetCount()>0 then
			Duel.SendtoGrave(sg1,REASON_EFFECT)
		end
	end
	if r1+r2+r3+num>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=Duel.SelectMatchingCard(tp,c1111001.ofilter1_2,tp,LOCATION_DECK,0,1,1,nil)
		if sg2:GetCount()>0 then
			Duel.SendtoHand(sg2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg2)
		end
	end
	if r1+r2+r3+num==3 then
		local sg3=Duel.GetMatchingGroup(c1111001.ofilter1_3,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
		if sg3:GetCount()>0 then
			Duel.SendtoHand(sg3,nil,REASON_EFFECT)
		end
	end
	if num<1 then return end
	Duel.ResetFlagEffect(tp,1111001)
end
--
function c1111001.cfilter2(c)
	return c:IsCode(1111001) and c:IsAbleToGraveAsCost()
end
function c1111001.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1111001.cfilter2,tp,LOCATION_HAND,0,1,nil) and c:IsAbleToDeckAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1111001.cfilter2,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SendtoDeck(c,nil,2,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(1111001,0))
end
--
function c1111001.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
--
function c1111001.op2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.RegisterFlagEffect(p,1111001,0,0,0)
	Duel.RegisterFlagEffect(p,1111001,0,0,0)
	Duel.RegisterFlagEffect(p,1111001,0,0,0)
end
--

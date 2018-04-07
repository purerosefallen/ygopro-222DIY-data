--守护·白猫
local m=1110003
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1110003.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,1110003)
	e1:SetCondition(c1110003.con1)
	e1:SetCost(c1110003.cost1)
	e1:SetTarget(c1110003.tg1)
	e1:SetOperation(c1110003.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c1110003.cost2)
	e2:SetTarget(c1110003.tg2)
	e2:SetOperation(c1110003.op2)
	c:RegisterEffect(e2)
--
end
--
function c1110003.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
--
function c1110003.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,400) end
	Duel.PayLPCost(tp,400)
end
--
function c1110003.tfilter1_1(c)
	return muxu.check_set_Butterfly(c) and c:IsSSetable()
end
function c1110003.tfilter1_2(c)
	return c:IsAbleToHand() and muxu.check_set_Urban(c) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM)
end
function c1110003.tfilter1_3(c,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	return muxu.check_set_Urban(c) and c:IsType(TYPE_SPELL) and (ft>0 or c:IsType(TYPE_FIELD)) and not c:IsForbidden()
end
function c1110003.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c1110003.tfilter1_1,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b2=Duel.IsExistingMatchingCard(c1110003.tfilter1_2,tp,LOCATION_DECK,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(c1110003.tfilter1_3,tp,LOCATION_DECK,0,1,nil,tp)
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1110003,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1110003,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(1110003,2)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
	elseif sel==2 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
	end
end
--
function c1110003.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c1110003.tfilter1_1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1110003.tfilter1_2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1110003,3))
		local g=Duel.SelectMatchingCard(tp,c1110003.tfilter1_3,tp,LOCATION_DECK,0,1,1,nil,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
--
function c1110003.cfilter2(c)
	return not c:IsPublic()
end
function c1110003.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1110003.cfilter2,tp,LOCATION_HAND,0,1,nil) and c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1110003,4))
	local g=Duel.SelectMatchingCard(tp,c1110003.cfilter2,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetCode(EFFECT_PUBLIC)
	e2_1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2_1)
	tc:RegisterFlagEffect(1110003,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,66)
end
--
function c1110003.tfilter2(c)
	return not c:IsPublic()
end
function c1110003.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1110003.tfilter2,tp,0,LOCATION_HAND,1,nil) end
end
--
function c1110003.op2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c1110003.tfilter2,tp,0,LOCATION_HAND,nil)
	if sg:GetCount()<1 then return end
	local gn=sg:RandomSelect(tp,1)
	Duel.ConfirmCards(tp,gn)
	Duel.ShuffleHand(1-tp)
end
--

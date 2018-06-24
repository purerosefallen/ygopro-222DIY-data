--祈愿祭
local m=1131004
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1131004.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c1131004.con1)
	e1:SetCost(c1131004.cost1)
	e1:SetTarget(c1131004.tg1)
	e1:SetOperation(c1131004.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c1131004.con2)
	e2:SetTarget(c1131004.tg2)
	e2:SetOperation(c1131004.op2)
	c:RegisterEffect(e2)
--
end
--
function c1131004.cfilter1_1(c)
	return muxu.check_set_Hinbackc(c) and c:IsFaceup()
end
function c1131004.cfilter1_2(c)
	return muxu.check_set_Hinbackc(c) and not c:IsPublic()
end
function c1131004.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c1131004.cfilter1_1,tp,LOCATION_MZONE,0,1,nil) or Duel.IsExistingMatchingCard(c1131004.cfilter1_2,tp,LOCATION_HAND,0,1,nil)
end
--
function c1131004.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1131004.cfilter1_1,tp,LOCATION_MZONE,0,1,nil) or Duel.IsExistingMatchingCard(c1131004.cfilter1_2,tp,LOCATION_HAND,0,1,nil) end
	if Duel.IsExistingMatchingCard(c1131004.cfilter1_1,tp,LOCATION_MZONE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local sg=Duel.SelectMatchingCard(tp,c1131004.cfilter1_2,tp,LOCATION_HAND,0,1,63,nil)
	local sc=sg:GetFirst()
	while sc do
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_PUBLIC)
		e1_1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e1_1)
		sc:RegisterFlagEffect(1131004,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,66)
		sc=sg:GetNext()
	end
end
--
function c1131004.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetDecktopGroup(tp,1):GetFirst():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1131004.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return end
	local sg=Duel.GetDecktopGroup(tp,1)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
--
function c1131004.cfilter2(c,tp)
	return muxu.check_set_Hinbackc(c) and c:GetSummonPlayer()==tp
end
function c1131004.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1131004.cfilter2,1,nil,tp)
end
--
function c1131004.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
--
function c1131004.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(c,nil,REASON_EFFECT)<1 then return end
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2_1:SetCode(EVENT_CHAIN_SOLVING)
	e2_1:SetCondition(c1131004.con2_1)
	e2_1:SetOperation(c1131004.op2_1)
	e2_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2_1,tp)
end
--
function c1131004.con2_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	local p=tc:GetControler()
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and p==tp and tc:IsCode(1131004)
end
--
function c1131004.op2_1(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c1131004.op2_1_1)
	e:Reset()
end
--
function c1131004.op2_1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
	end
	local e2_1_1_1=Effect.CreateEffect(c)
	e2_1_1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_1_1_1:SetType(EFFECT_TYPE_FIELD)
	e2_1_1_1:SetCode(EFFECT_HAND_LIMIT)
	e2_1_1_1:SetTargetRange(1,0)
	e2_1_1_1:SetValue(100)
	if Duel.GetTurnPlayer()~=tp then
		e2_1_1_1:SetReset(RESET_PHASE+PHASE_END)
	else
		e2_1_1_1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN)
	end
	Duel.RegisterEffect(e2_1_1_1,tp)
	local e2_1_1_2=Effect.CreateEffect(c)
	e2_1_1_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_1_1_2:SetType(EFFECT_TYPE_FIELD)
	e2_1_1_2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2_1_1_2:SetTargetRange(0,1)
	e2_1_1_2:SetValue(c1131004.val2_1_1_2)
	e2_1_1_2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2_1_1_2,tp)
end
--
function c1131004.val2_1_1_2(e,re,tp)
	local rc=re:GetHandler()
	return c:IsLocation(LOCATION_ONFIELD) and c:IsFacedown()
end
--

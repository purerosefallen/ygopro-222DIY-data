--午后通知
local m=1131001
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1131001.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c1131001.con1)
	e1:SetCost(c1131001.cost1)
	e1:SetTarget(c1131001.tg1)
	e1:SetOperation(c1131001.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c1131001.con2)
	e2:SetCost(c1131001.cost2)
	e2:SetTarget(c1131001.tg2)
	e2:SetOperation(c1131001.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c1131001.con3)
	e3:SetCost(c1131001.cost2)
	e3:SetTarget(c1131001.tg2)
	e3:SetOperation(c1131001.op2)
	c:RegisterEffect(e3)
--
end
--
function c1131001.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,1130002) and c:IsCode(1131001) then return true end
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)<1
end
--
function c1131001.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_2:SetType(EFFECT_TYPE_FIELD)
	e1_2:SetCode(EFFECT_HAND_LIMIT)
	e1_2:SetTargetRange(1,0)
	e1_2:SetValue(100)
	if Duel.GetTurnPlayer()~=tp then
		e1_2:SetReset(RESET_PHASE+PHASE_END)
	else
		e1_2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN)
	end
	Duel.RegisterEffect(e1_2,tp)
end
--
function c1131001.tfilter1(c)
	return c:IsAbleToRemove() and muxu.check_set_Hinbackc(c) and c:IsFaceup()
end
function c1131001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1131001.tfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE)
end
--
function c1131001.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=Duel.GetMatchingGroupCount(c1131001.tfilter1,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c1131001.tfilter1,tp,LOCATION_MZONE,0,1,num,nil)
	if sg:GetCount()<1 then return end
	if Duel.Remove(sg,POS_FACEUP,REASON_COST+REASON_TEMPORARY)>0 then
		local fid=c:GetFieldID()
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(1131001,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			oc=og:GetNext()
		end
		og:KeepAlive()
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1_1:SetCode(EVENT_PHASE+PHASE_END)
		e1_1:SetCountLimit(1)
		e1_1:SetLabel(fid)
		e1_1:SetLabelObject(og)
		e1_1:SetCondition(c1131001.con1_1)
		e1_1:SetOperation(c1131001.op1_1)
		e1_1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1_1,tp)
		local cnum=Duel.GetMatchingGroupCount(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
		if cnum>0 and Duel.SelectYesNo(tp,aux.Stringid(1131001,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,cnum,nil)
			if tg:GetCount()<1 then return end
			Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,tg:GetCount()+2,REASON_EFFECT)
		end
	end
end
--
function c1131001.cfilter1_1(c,fid)
	return c:GetFlagEffectLabel(1131001)==fid
end
function c1131001.con1_1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c1131001.cfilter1_1,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c1131001.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c1131001.cfilter1_1,nil,e:GetLabel())
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
		tc=sg:GetNext()
	end
end
--
function c1131001.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,1130002) and c:IsCode(1131001) then return false end
	return true
end
--
function c1131001.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sg=Group.CreateGroup()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	sg:AddCard(c)
	Duel.HintSelection(sg)
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
--
function c1131001.tfilter2(c)
	return c:IsFaceup() and muxu.check_set_Hinbackc(c) and c:IsType(TYPE_MONSTER)
end
function c1131001.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c1131001.tfilter2(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c1131001.tfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local sg=Duel.SelectTarget(tp,c1131001.tfilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
--
function c1131001.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) then return end
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetDescription(aux.Stringid(1131001,0))
	e2_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetCode(EFFECT_IMMUNE_EFFECT)
	e2_1:SetRange(LOCATION_MZONE)
	e2_1:SetValue(c1131001.val2_1)
	e2_1:SetOwnerPlayer(tp)
	e2_1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2_1)
	local e2_2=Effect.CreateEffect(c)
	e2_2:SetDescription(aux.Stringid(1131001,1))
	e2_2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2_2:SetCategory(CATEGORY_TOHAND)
	e2_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2_2:SetCode(EVENT_PHASE+PHASE_END)
	e2_2:SetRange(LOCATION_MZONE)
	e2_2:SetCountLimit(1)
	e2_2:SetOperation(c1131001.op2_2)
	e2_2:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2_2)
end
--
function c1131001.val2_1(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c1131001.op2_2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
--
function c1131001.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,1130002) and c:IsCode(1131001) then return true end
	return false
end
--

--莱姆狐-报社队伍
local m=1130002
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Hinbackc=true
--
function c1130002.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1130002,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c1130002.cost1)
	e1:SetTarget(c1130002.tg1)
	e1:SetOperation(c1130002.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(1130002)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
--
end
--
function c1130002.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(1130002,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1_1:SetCode(EVENT_PHASE+PHASE_END)
	e1_1:SetCountLimit(1)
	e1_1:SetLabel(fid)
	e1_1:SetLabelObject(c)
	e1_1:SetCondition(c1130002.con1_1)
	e1_1:SetOperation(c1130002.op1_1)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_1,tp)
end
--
function c1130002.con1_1(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local tc=e:GetLabelObject()
	if not tc:GetFlagEffectLabel(1130002)==fid then
		e:Reset()
		return false
	else return true end
end
function c1130002.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local tc=e:GetLabelObject()
	if tc and tc:GetFlagEffectLabel(1130002)==fid then 
		Duel.ReturnToField(tc)
	end
end
--
function c1130002.tfilter1(c)
	return not c:IsPublic()
end
function c1130002.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1130002.tfilter1,tp,0,LOCATION_HAND,1,nil) end
end
--
function c1130002.op1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local tg=sg:Filter(c1130002.tfilter1,nil)
	if tg:GetCount()<1 then return end
	Duel.ConfirmCards(tp,tg)
	Duel.ShuffleHand(1-tp)
	sg:KeepAlive()
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_FIELD)
	e1_2:SetCode(EFFECT_IMMUNE_EFFECT)
	e1_2:SetTargetRange(LOCATION_MZONE,0)
	e1_2:SetTarget(c1130002.tg1_2)
	e1_2:SetLabelObject(sg)
	e1_2:SetValue(c1130002.val1_2)
	e1_2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1_2,tp)
end
--
function c1130002.tg1_2(e,c)
	return muxu.check_set_Hinbackc(c) and c:IsFaceup()
end
function c1130002.val1_2(e,te)
	local sg=e:GetLabelObject()
	local code=te:GetHandler():GetCode()
	local checknum=0
	local sc=sg:GetFirst()
	while sc do
		if sc:IsCode(code) then checknum=1 end
		sc=sg:GetNext()
	end
	return checknum==1
end
--

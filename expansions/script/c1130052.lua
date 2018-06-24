--莱姆狐-圈外搜救队
local m=1130052
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Hinbackc=true
--
function c1130052.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_HAND_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(100)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c1130052.tg2)
	e2:SetValue(c1130052.val2)
	e2:SetOperation(c1130052.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1130052,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c1130052.tg3)
	e3:SetOperation(c1130052.op3)
	c:RegisterEffect(e3)
--
end
--
c1130052.toss_coin=true
--
function c1130052.tfilter2(c,tp)
	return c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:IsControler(tp)
end
function c1130052.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=Group.CreateGroup()
	local checknum=0
	local sg=eg:Filter(c1130052.tfilter2,0,nil,tp)
	if sg:GetCount()>0 then
		local sc=sg:GetFirst()
		while sc do
			sc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
			if sc:IsAbleToHand() then tg:AddCard(sc) end
			sc:SetStatus(STATUS_DESTROY_CONFIRMED,true)
			sc=sg:GetNext()
		end
	end
	if chk==0 then return c:GetFlagEffect(1130052)<1 and tg:GetCount()>0 and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		tg:KeepAlive()
		e:SetLabelObject(tg)
		return true
	else return false end
end
--
function c1130052.val2(e,c)
	local tg=e:GetLabelObject()
	return tg
end
--
function c1130052.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=e:GetLabelObject()
	local tc=tg:GetFirst()
	while tc do
		tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
		tc=tg:GetNext()
	end
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	c:RegisterFlagEffect(1130052,RESET_EVENT+0x1fe0000,0,0)
end
--
function c1130052.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
--
function c1130052.ofilter3(c)
	return c:IsAbleToHand() and c:IsRace(RACE_BEAST)
end
function c1130052.op3(e,tp,eg,ep,ev,re,r,rp)
	local coin=Duel.SelectOption(tp,60,61)
	local res=Duel.TossCoin(tp,1)
	if coin~=res and Duel.IsExistingMatchingCard(c1130052.ofilter3,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c1130052.ofilter3,tp,LOCATION_GRAVE,0,1,1,nil)
		if sg:GetCount()<1 then return end
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
--

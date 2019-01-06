--伞符『细雪的过客』
local m=1141201
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Umbrella=true
--
function c1141201.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1141201.tg1)
	e1:SetOperation(c1141201.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c1141201.con2)
	e2:SetOperation(c1141201.op2)
	c:RegisterEffect(e2)
--
	if not c1141201.global_check then
		c1141201.global_check=true
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAINING)
		e3:SetOperation(c1141201.op3)
		Duel.RegisterEffect(e3,0)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CANNOT_INACTIVATE)
		e4:SetValue(c1141201.efilter4)
		Duel.RegisterEffect(e4,0)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CANNOT_DISEFFECT)
		e5:SetValue(c1141201.efilter4)
		Duel.RegisterEffect(e5,0)
	end
--
end
--
c1141201.muxu_ih_KTatara=1
--
function c1141201.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.disfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
--
function c1141201.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_DISABLE)
		e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1_1)
		local e1_2=Effect.CreateEffect(c)
		e1_2:SetType(EFFECT_TYPE_SINGLE)
		e1_2:SetCode(EFFECT_DISABLE_EFFECT)
		e1_2:SetValue(RESET_TURN_SET)
		e1_2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1_2)
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(1141201,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1_3=Effect.CreateEffect(c)
		e1_3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_3:SetCode(EVENT_PHASE+PHASE_END)
		e1_3:SetCountLimit(1)
		e1_3:SetLabel(fid)
		e1_3:SetLabelObject(tc)
		e1_3:SetCondition(c1141201.con1_3)
		e1_3:SetOperation(c1141201.op1_3)
		Duel.RegisterEffect(e1_3,tp)
	end
end
function c1141201.con1_3(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(1141201)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c1141201.op1_3(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end
--
function c1141201.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,0x4040)~=0 and c:IsPreviousLocation(LOCATION_HAND)
end
--
function c1141201.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_FIELD)
	e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_1:SetCode(EFFECT_SKIP_TURN)
	e2_1:SetTargetRange(0,1)
	e2_1:SetLabel(Duel.GetTurnCount())
	e2_1:SetCondition(c1141201.con2_1)
	e2_1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	Duel.RegisterEffect(e2_1,tp)
	local e2_2=Effect.CreateEffect(c)
	e2_2:SetType(EFFECT_TYPE_FIELD)
	e2_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_2:SetCode(EFFECT_SKIP_TURN)
	e2_2:SetTargetRange(1,0)
	e2_2:SetLabel(Duel.GetTurnCount())
	e2_2:SetCondition(c1141201.con2_1)
	e2_2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	Duel.RegisterEffect(e2_2,tp)
	Duel.RegisterFlagEffect(tp,1141201,nil,0,0)
end
function c1141201.con2_1(e,tp,eg,ep,ev,re,r,rp)
	local num1=e:GetLabel()
	local num2=Duel.GetTurnCount()
	return (num2==num1+1) or (num2==num1+2)
end
--
function c1141201.op3(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local p=rc:GetControler()
	if not rc.muxu_ih_Tatara then return end
	if Duel.GetFlagEffect(p,1141201)<1 then return end
	rc:RegisterFlagEffect(1141202,RESET_CHAIN,0,0)
end
--
function c1141201.efilter4(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return tc:GetFlagEffect(1141202)>0
end
--

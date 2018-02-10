--MARRIAGE
function c1150035.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150035+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1150035.tg1)
	e1:SetOperation(c1150035.op1)
	c:RegisterEffect(e1)  
--  
end
--
function c1150035.tfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c1150035.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c1150035.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c1150035.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g1:GetFirst()
	e:SetLabelObject(g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp,c1150035.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc)
end
--
function c1150035.ofilter1(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c1150035.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=e:GetLabelObject()
	if cg:GetCount()>0 then local tc1=cg:GetFieldCard() end
	if not tc1 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c1150035.ofilter1,tc1,e)
	if g:GetFirst()>0 then local tc2=g:GetFirst() end
	if tc2 and tc1:IsRelateToEffect(e) and tc2:IsRelateToEffect(e) then
		tc1:RegisterFlagEffect(1150035,RESET_EVENT+0x1fe0000,0,0,fid)
		tc2:RegisterFlagEffect(1150035,RESET_EVENT+0x1fe0000,0,0,fid)
--
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_DESTROY_REPLACE)
		e1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1_1:SetRange(LOCATION_MZONE)
		e1_1:SetLabel(fid)
		e1_1:SetLabelObject(tc2)
		e1_1:SetReset(RESET_EVENT+0x1fe0000)
		e1_1:SetTarget(c1150035.tg1_1)
		e1_1:SetOperation(c1150035.op1_1)
		tc1:RegisterEffect(e1_1)
		local e1_2=Effect.CreateEffect(c)
		e1_2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e1_2:SetCode(EFFECT_DESTROY_REPLACE)
		e1_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1_2:SetRange(LOCATION_MZONE)
		e1_2:SetLabel(fid)
		e1_2:SetLabelObject(tc1)
		e1_2:SetReset(RESET_EVENT+0x1fe0000)
		e1_2:SetTarget(c1150035.tg1_2)
		e1_2:SetOperation(c1150035.op1_2)
		tc2:RegisterEffect(e1_2)
--
		local e1_3=Effect.CreateEffect(c)
		e1_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_3:SetCode(EVENT_CHAINING)
		e1_3:SetRange(LOCATION_MZONE)
		e1_3:SetLabel(fid)
		e1_3:SetLabelObject(tc2)
		e1_3:SetReset(RESET_EVENT+0x1fe0000)
		e1_3:SetTarget(c1150035.tg1_3)
		e1_3:SetOperation(c1150035.op1_3)
		tc1:RegisterEffect(e1_3)
--
		local e1_4=Effect.CreateEffect(c)
		e1_4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_4:SetCode(EVENT_CHAINING)
		e1_4:SetRange(LOCATION_MZONE)
		e1_4:SetLabel(fid)
		e1_4:SetLabelObject(tc1)
		e1_4:SetReset(RESET_EVENT+0x1fe0000)
		e1_4:SetTarget(c1150035.tg1_4)
		e1_4:SetOperation(c1150035.op1_4)
		tc2:RegisterEffect(e1_4)
--
	end
end
--
function c1150035.tg1_1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc2=e:GetLabelObject()
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE) and tc2:IsLocation(LOCATION_MZONE) and tc2:IsFaceup() and tc2:GetFlagEffectLabel(1150035)==fid and not tc2:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return true
end
function c1150035.op1_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,e:GetHandler():GetCode())
end
--
function c1150035.tg1_2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc1=e:GetLabelObject()
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE) and tc1:IsLocation(LOCATION_MZONE) and tc1:IsFaceup() and tc1:GetFlagEffectLabel(1150035)==fid and not tc1:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return true
end
function c1150035.op1_2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,e:GetHandler():GetCode())
end
--
function c1150035.tg1_3(e,tp,eg,ep,ev,re,r,rp,chk)
	local np=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if chk==0 then return np~=tp and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE end
end
--
function c1150035.op1_3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc2=e:GetLabelObject()
	if tc2:IsLocation(LOCATION_MZONE) and tc2:IsFaceup() and tc2:GetFlagEffectLabel(1150035)==fid and c:GetAttack()>999 and Duel.SelectYesNo(tp,aux.Stringid(1150035,0)) then
		Duel.Hint(HINT_CARD,0,c:GetCode())
--
		local e1_3_1=Effect.CreateEffect(c)
		e1_3_1:SetType(EFFECT_TYPE_SINGLE)
		e1_3_1:SetCode(EFFECT_UPDATE_ATTACK)
		e1_3_1:SetReset(RESET_EVENT+0x1fe0000)
		e1_3_1:SetValue(-800)
		c:RegisterEffect(e1_3_1)
--
		local e1_3_2=Effect.CreateEffect(c)
		e1_3_2:SetType(EFFECT_TYPE_SINGLE)
		e1_3_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1_3_2:SetRange(LOCATION_MZONE)
		e1_3_2:SetCode(EFFECT_IMMUNE_EFFECT)
		e1_3_2:SetValue(c1150035.efilter1_3_2)
		e1_3_2:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
		tc2:RegisterEffect(e1_3_2)
--
	end
end
function c1150035.efilter1_3_2(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--
function c1150035.op1_4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=e:GetLabelObject()
	if tc1:IsLocation(LOCATION_MZONE) and tc1:IsFaceup() and tc1:GetFlagEffectLabel(1150035)==fid and c:GetAttack()>999 and Duel.SelectYesNo(tp,aux.Stringid(1150035,0)) then
		Duel.Hint(HINT_CARD,0,c:GetCode())
--
		local e1_4_1=Effect.CreateEffect(c)
		e1_4_1:SetType(EFFECT_TYPE_SINGLE)
		e1_4_1:SetCode(EFFECT_UPDATE_ATTACK)
		e1_4_1:SetReset(RESET_EVENT+0x1fe0000)
		e1_4_1:SetValue(-800)
		c:RegisterEffect(e1_4_1)
--
		local e1_4_2=Effect.CreateEffect(c)
		e1_4_2:SetType(EFFECT_TYPE_SINGLE)
		e1_4_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1_4_2:SetRange(LOCATION_MZONE)
		e1_4_2:SetCode(EFFECT_IMMUNE_EFFECT)
		e1_4_2:SetValue(c1150035.efilter1_4_2)
		e1_4_2:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
		tc1:RegisterEffect(e1_4_2)
--
	end
end
function c1150035.efilter1_4_2(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--

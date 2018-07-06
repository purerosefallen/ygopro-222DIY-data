--灵纹·星屑辉芒
local m=1111403
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Lines=true
--
function c1111403.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1111403.tg1)
	e1:SetOperation(c1111403.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetValue(c1111403.limit2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_EQUIP)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c1111403.op3)
	c:RegisterEffect(e3) 
--
end
--
function c1111403.tfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and muxu.check_set_Urban(c)
end
function c1111403.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1111403.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1111403.tfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c1111403.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end
--
function c1111403.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	c:CancelToGrave()
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_CHANGE_TYPE)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetValue(TYPE_EQUIP+TYPE_SPELL)
	e1_1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1_1) 
	if not Duel.Equip(tp,c,tc,true) then return end
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetCode(EFFECT_IMMUNE_EFFECT)
	e1_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1_2:SetRange(LOCATION_MZONE)
	e1_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1_2:SetValue(c1111403.efilter1_2)
	tc:RegisterEffect(e1_2)
end
--
function c1111403.efilter1_2(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if (te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)) or ec:IsHasCardTarget(c) then return false end
	return te:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
--
function c1111403.limit2(e,c)
	return muxu.check_set_Urban(c)
end
--
function c1111403.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:GetFirst()~=c then return end
	local tc=c:GetEquipTarget()
	if tc then
		local e3_1=Effect.CreateEffect(c)
		e3_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3_1:SetCode(EVENT_CHAINING)
		e3_1:SetRange(LOCATION_MZONE)
		e3_1:SetCountLimit(1)
		e3_1:SetLabelObject(c)
		e3_1:SetCondition(c1111403.con3_1)
		e3_1:SetOperation(c1111403.op3_1)
		tc:RegisterEffect(e3_1,true)
		if e3_1:GetHandler()==nil then return end
	end
	if tc then
		local e3_2=Effect.CreateEffect(c)
		e3_2:SetDescription(aux.Stringid(1111403,1))
		e3_2:SetCategory(CATEGORY_ATKCHANGE)
		e3_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e3_2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
		e3_2:SetRange(LOCATION_SZONE)
		e3_2:SetLabelObject(c)
		e3_2:SetCondition(c1111403.con3_2)
		e3_2:SetOperation(c1111403.op3_2)
		tc:RegisterEffect(e3_2)
		if e3_2:GetHandler()==nil then return end
	end
end
--
function c1111403.con3_1(e)
	local g=e:GetHandler():GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else return false end
end
--
function c1111403.op3_1(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(re:GetActivateLocation(),LOCATION_ONFIELD)~=0 then return end
	local c=e:GetHandler()
	local e3_1_1=Effect.CreateEffect(c)
	e3_1_1:SetType(EFFECT_TYPE_FIELD)
	e3_1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3_1_1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3_1_1:SetTargetRange(1,1)
	e3_1_1:SetValue(c1111403.val3_1_1)
	e3_1_1:SetReset(RESET_PHASE+RESET_CHAIN)
	Duel.RegisterEffect(e3_1_1,tp)
end
--
function c1111403.val3_1_1(e,re,tp)
	return not re:GetHandler():IsLocation(LOCATION_ONFIELD)
end
--
function c1111403.con3_2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetEquipGroup()
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if bc:IsControler(1-tp) then bc=tc end
	if g:IsContains(e:GetLabelObject()) then
		return bc:IsFaceup() and muxu.check_set_Urban(bc) and not e:GetLabelObject():IsDisabled()
	else return false end
end
--
function c1111403.op3_2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	local gn=Group.CreateGroup()
	if tc:IsRelateToBattle() and tc:IsFaceup() then gn:AddCard(tc) end
	if bc:IsRelateToBattle() and bc:IsFaceup() then gn:AddCard(bc) end
	if gn:GetCount()<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1111403,2))
	local sg=gn:Select(tp,1,1,nil)
	local sc=sg:GetFirst()
	local e3_2_1=Effect.CreateEffect(c)
	e3_2_1:SetType(EFFECT_TYPE_SINGLE)
	e3_2_1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3_2_1:SetValue(0)
	e3_2_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	tc:RegisterEffect(e3_2_1)
end
--

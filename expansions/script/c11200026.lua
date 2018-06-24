--『幻胧月睨』
function c11200026.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetValue(1)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11200026+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11200026.tg1)
	e1:SetOperation(c11200026.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_SET_CONTROL)
	e4:SetCondition(c11200026.con4)
	e4:SetValue(c11200026.val4)
	c:RegisterEffect(e4)
--
	if not c11200026.global_check then
		c11200026.global_check=true
		local e5=Effect.GlobalEffect()
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_CHAINING)
		e5:SetCondition(c11200026.con5)
		e5:SetOperation(c11200026.op5)
		Duel.RegisterEffect(e5,0)
	end
--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_EQUIP)
	e6:SetRange(LOCATION_SZONE)
	e6:SetOperation(c11200026.op6)
	c:RegisterEffect(e6)
--
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCost(aux.bfgcost)
	e7:SetTarget(c11200026.tg7)
	e7:SetOperation(c11200026.op7)
	c:RegisterEffect(e7)
--
end
--
function c11200026.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
--
function c11200026.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
--
function c11200026.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),11200026)<1
end
--
function c11200026.val4(e,c)
	return e:GetHandlerPlayer()
end
--
function c11200026.con5(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsCode(11200019)
end
--
function c11200026.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,11200026,0,0,0)
end
--
function c11200026.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:GetFirst()~=c then return end
	local tc=c:GetEquipTarget()
	if not tc then return end
	local e6_1=Effect.CreateEffect(c)
	e6_1:SetType(EFFECT_TYPE_SINGLE)
	e6_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6_1:SetCode(EFFECT_CHANGE_CODE)
	e6_1:SetRange(LOCATION_MZONE)
	e6_1:SetLabelObject(c)
	e6_1:SetCondition(c11200026.con6_1)
	e6_1:SetValue(11200019)
	tc:RegisterEffect(e6_1)
	if e6_1:GetHandler()==nil then return end
	local e6_2=Effect.CreateEffect(c)
	e6_2:SetType(EFFECT_TYPE_SINGLE)
	e6_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6_2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e6_2:SetValue(1)
	e6_2:SetLabelObject(c)
	e6_2:SetCondition(c11200026.con6_2)
	tc:RegisterEffect(e6_2)
	if e6_2:GetHandler()==nil then return end
	local e6_3=Effect.CreateEffect(c)
	e6_3:SetType(EFFECT_TYPE_SINGLE)
	e6_3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6_3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e6_3:SetValue(1)
	e6_3:SetLabelObject(c)
	e6_3:SetCondition(c11200026.con6_2)
	tc:RegisterEffect(e6_3)
	if e6_3:GetHandler()==nil then return end
	local e6_4=Effect.CreateEffect(c)
	e6_4:SetType(EFFECT_TYPE_SINGLE)
	e6_4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6_4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e6_4:SetValue(1)
	e6_4:SetLabelObject(c)
	e6_4:SetCondition(c11200026.con6_2)
	tc:RegisterEffect(e6_4)
	if e6_4:GetHandler()==nil then return end
end
--
function c11200026.con6_1(e)
	local c=e:GetHandler()
	local g=c:GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else return false end
end
--
function c11200026.con6_2(e)
	local c=e:GetHandler()
	local g=c:GetEquipGroup()
	local p=e:GetLabelObject():GetControler()
	if g:IsContains(e:GetLabelObject()) then
		return c:IsControler(p) and c:GetOwner()~=p
			and not e:GetLabelObject():IsDisabled()
	else return false end
end
--
function c11200026.tfilter7(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c11200026.tg7(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and c11200026.tfilter7(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11200026.tfilter7,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectTarget(tp,c11200026.tfilter7,tp,LOCATION_MZONE,0,1,1,nil)
end
--
function c11200026.op7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e7_1=Effect.CreateEffect(c)
		e7_1:SetType(EFFECT_TYPE_SINGLE)
		e7_1:SetCode(EFFECT_UPDATE_ATTACK)
		e7_1:SetValue(1100)
		e7_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e7_1)
	end
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if sg:GetCount()<1 then return end
	local d=Duel.TossDice(tp,1)*100
	local sc=sg:GetFirst()
	while sc do
		local e7_2=Effect.CreateEffect(c)
		e7_2:SetType(EFFECT_TYPE_SINGLE)
		e7_2:SetCode(EFFECT_UPDATE_ATTACK)
		e7_2:SetValue(-d)
		e7_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		sc:RegisterEffect(e7_2)
		local e7_3=e7_2:Clone()
		e7_3:SetCode(EFFECT_UPDATE_DEFENSE)
		sc:RegisterEffect(e7_3)
		sc=sg:GetNext()
	end
end
--
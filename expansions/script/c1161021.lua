--
function c1161021.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1161021,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c1161021.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1161021,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c1161021.cost2)
	e2:SetTarget(c1161021.tg2)
	e2:SetOperation(c1161021.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c1161021.con3)
	e3:SetValue(1161022)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_EQUIP)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c1161021.op4)
	c:RegisterEffect(e4)
--
end
--
function c1161021.ofilter1(c)
	return c:IsAbleToHand()
end
function c1161021.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetColumnGroup()
	local sg=g:Filter(c1161021.ofilter1,c)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
--
function c1161021.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
--
function c1161021.tfilter2(c)
	return c:IsFaceup() and c:GetLevel()==1
end
function c1161021.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetOperationInfo(ev,CATEGORY_DISABLE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c1161021.tfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c1161021.tfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
--
function c1161021.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,aux.NULL)
	if c:IsRelateToEffect(e) then
		local tc=Duel.GetFirstTarget()
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsFaceup() and tc:IsRelateToEffect(e) then
			Duel.Equip(tp,c,tc,true)
			local e2_1=Effect.CreateEffect(c)
			e2_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1:SetCode(EFFECT_CHANGE_TYPE)
			e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2_1:SetValue(TYPE_EQUIP+TYPE_SPELL)
			e2_1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e2_1)
			local e2_2=Effect.CreateEffect(c)
			e2_2:SetType(EFFECT_TYPE_SINGLE)
			e2_2:SetCode(EFFECT_EQUIP_LIMIT)
			e2_2:SetReset(RESET_EVENT+0x1fe0000)
			e2_2:SetLabelObject(tc)
			e2_2:SetValue(c1161021.limit2_2)
			c:RegisterEffect(e2_2)
			local e2_3=Effect.CreateEffect(c)
			e2_3:SetType(EFFECT_TYPE_SINGLE)
			e2_3:SetCode(EFFECT_UPDATE_DEFENSE)
			e2_3:SetReset(RESET_EVENT+0x1fe0000)
			e2_3:SetValue(800)
			tc:RegisterEffect(e2_3)
		else
			Duel.SendtoGrave(c,REASON_EFFECT)
		end
	end
end
function c1161021.limit2_2(e,c)
	return c==e:GetLabelObject()
end
--
function c1161021.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_EQUIP)
end
--
function c1161021.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:GetFirst()~=e:GetHandler() then return end
	local tc=c:GetEquipTarget()
	if tc then
		local e4_1=Effect.CreateEffect(c)
		e4_1:SetType(EFFECT_TYPE_FIELD)
		e4_1:SetCode(EFFECT_SET_POSITION)
		e4_1:SetRange(LOCATION_MZONE)
		e4_1:SetLabelObject(e:GetHandler())
		e4_1:SetCondition(c1161021.con4_1)
		e4_1:SetTarget(c1161021.tg4_1)
		e4_1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e4_1:SetValue(POS_FACEUP_DEFENSE)
		tc:RegisterEffect(e4_1)
		if e4_1:GetHandler()==nil then return end
		local e4_2=Effect.CreateEffect(c)
		e4_2:SetType(EFFECT_TYPE_FIELD)
		e4_2:SetCode(EFFECT_IMMUNE_EFFECT)
		e4_2:SetRange(LOCATION_MZONE)
		e4_2:SetTargetRange(LOCATION_MZONE,0)
		e4_2:SetLabelObject(e:GetHandler())
		e4_2:SetCondition(c1161021.con4_1)
		e4_2:SetTarget(c1161021.tg4_2)
		e4_2:SetValue(c1161021.efilter4_2)
		tc:RegisterEffect(e4_2)
		if e4_2:GetHandler()==nil then return end
		local e4_3=Effect.CreateEffect(c)
		e4_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4_3:SetCode(EVENT_CHAIN_SOLVED)
		e4_3:SetRange(LOCATION_MZONE)
		e4_3:SetLabelObject(e:GetHandler())
		e4_3:SetCondition(c1161021.con4_1)
		e4_3:SetOperation(c1161021.op4_3)
		tc:RegisterEffect(e4_3)
		if e4_3:GetHandler()==nil then return end
	end
end
--
function c1161021.con4_1(e)
	local g=e:GetHandler():GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else 
		return false
	end
end
function c1161021.tg4_1(e,c)
	return c==e:GetHandler() and c:IsFaceup() and not c:IsType(TYPE_LINK)
end
--
function c1161021.tg4_2(e,c)
	return true
end
function c1161021.efilter4_2(e,re,rp)
	if re:IsActiveType(TYPE_MONSTER) and re:GetOwnerPlayer()~=e:GetHandlerPlayer() then
		local def=e:GetHandler():GetDefense()
		local ec=re:GetOwner()
		return ec:GetAttack()<def
	else
		return false
	end
end
--
function c1161021.op4_3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:GetHandler() then return end
	if re:GetHandler():GetControler()~=c:GetControler() and c:IsOnField() and c:IsFaceup() then
		local e4_3=Effect.CreateEffect(c)
		e4_3:SetType(EFFECT_TYPE_SINGLE)
		e4_3:SetCode(EFFECT_UPDATE_DEFENSE)
		e4_3:SetValue(80)
		e4_3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e4_3)
	end
end
--
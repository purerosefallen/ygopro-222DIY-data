--梦游仙境·爱丽丝
function c1160001.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1160001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c1160001.tg1)
	e1:SetOperation(c1160001.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_EQUIP)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c1160001.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1160001,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(c1160001.tg3)
	e3:SetOperation(c1160001.op3)
	c:RegisterEffect(e3)
--
end
--
function c1160001.tfilter1(c,e,tp)
	return c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(1160001)
end
function c1160001.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c1160001.tfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
--
function c1160001.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1160001.tfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsFaceup() then
			Duel.Equip(tp,c,tc,true)
			local e1_1=Effect.CreateEffect(c)
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetCode(EFFECT_CHANGE_TYPE)
			e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1_1:SetValue(TYPE_EQUIP)
			e1_1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1_1)
			local e1_2=Effect.CreateEffect(c)
			e1_2:SetType(EFFECT_TYPE_SINGLE)
			e1_2:SetCode(EFFECT_EQUIP_LIMIT)
			e1_2:SetReset(RESET_EVENT+0x1fe0000)
			e1_2:SetLabelObject(tc)
			e1_2:SetValue(c1160001.limit1_2)
			c:RegisterEffect(e1_2)
			local e1_3=Effect.CreateEffect(c)
			e1_3:SetType(EFFECT_TYPE_EQUIP)
			e1_3:SetCode(EFFECT_UPDATE_ATTACK)
			e1_3:SetValue(300)
			e1_3:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1_3)
			local e1_4=Effect.CreateEffect(c)
			e1_4:SetType(EFFECT_TYPE_SINGLE)
			e1_4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1_4:SetValue(LOCATION_HAND)
			e1_4:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1_4)
		end
	end
end
function c1160001.limit1_2(e,c)
	return c==e:GetLabelObject()
end
--
function c1160001.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:GetFirst()~=e:GetHandler() then return end
	local tc=c:GetEquipTarget()
	if tc then
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetDescription(aux.Stringid(1160001,1))
		e2_1:SetCategory(CATEGORY_ATKCHANGE)
		e2_1:SetType(EFFECT_TYPE_IGNITION)
		e2_1:SetRange(LOCATION_MZONE)
		e2_1:SetLabelObject(c)
		e2_1:SetCountLimit(1)
		e2_1:SetCondition(c1160001.con2_1)
		e2_1:SetTarget(c1160001.tg2_1)
		e2_1:SetOperation(c1160001.op2_1)
		tc:RegisterEffect(e2_1)
		if e2_1:GetHandler()==nil then return end
	end
end
--
function c1160001.con2_1(e)
	local g=e:GetHandler():GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else 
		return false
	end
end
function c1160001.tfilter2_1(c)
	return c:IsFaceup() and c:GetAttack()>0 and c:IsType(TYPE_MONSTER)
end
function c1160001.tg2_1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c1160001.tfilter2_1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c1160001.tfilter2_1,tp,0,LOCATION_MZONE,1,1,nil)	
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(1160001,1))
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,0,LOCATION_MZONE)
end
function c1160001.op2_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e2_1_1=Effect.CreateEffect(c)
		e2_1_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1_1:SetCode(EFFECT_CANNOT_TRIGGER)
		e2_1_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_1_1)
		local e2_1_2=Effect.CreateEffect(c)
		e2_1_2:SetType(EFFECT_TYPE_SINGLE)
		e2_1_2:SetCode(EFFECT_UPDATE_ATTACK)
		e2_1_2:SetReset(RESET_EVENT+0x1fe0000)
		e2_1_2:SetValue(-200)
		tc:RegisterEffect(e2_1_2)
		Duel.BreakEffect()
		local count=11
		while count>0 and tc:GetAttack()>=c:GetAttack() do
			if count<12 then Duel.BreakEffect() end
			if count>1 then
				local e2_1_2=Effect.CreateEffect(c)
				e2_1_2:SetType(EFFECT_TYPE_SINGLE)
				e2_1_2:SetCode(EFFECT_UPDATE_ATTACK)
				e2_1_2:SetReset(RESET_EVENT+0x1fe0000)
				e2_1_2:SetValue(-200)
				tc:RegisterEffect(e2_1_2)
			else
				local e2_1_2=Effect.CreateEffect(c)
				e2_1_2:SetType(EFFECT_TYPE_SINGLE)
				e2_1_2:SetCode(EFFECT_UPDATE_ATTACK)
				e2_1_2:SetReset(RESET_EVENT+0x1fe0000)
				e2_1_2:SetValue(-1400)
				tc:RegisterEffect(e2_1_2)
			end
			count=count-1
		end
	end
end
--
function c1160001.tfilter3(c)
	return c:GetType()==TYPE_SPELL and c:IsAbleToHand()
end
function c1160001.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1160001.tfilter3,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
--
function c1160001.op3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1160001.tfilter3,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
--
			local e3_2=Effect.CreateEffect(c)
			e3_2:SetType(EFFECT_TYPE_SINGLE)
			e3_2:SetCode(EFFECT_PUBLIC)
			e3_2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3_2)
--
			local e3_1=Effect.CreateEffect(c)
			e3_1:SetType(EFFECT_TYPE_SINGLE)
			e3_1:SetCode(EFFECT_CANNOT_SSET)
			e3_1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3_1)
--
			local e3_3=Effect.CreateEffect(c)
			e3_3:SetType(EFFECT_TYPE_FIELD)
			e3_3:SetCode(EFFECT_ACTIVATE_COST)
			e3_3:SetRange(LOCATION_HAND)
			e3_3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3_3:SetReset(RESET_EVENT+0x1fe0000)
			e3_3:SetTargetRange(1,1)
			e3_3:SetTarget(c1160001.tg3_3)
			e3_3:SetCost(c1160001.cost3_3)
			e3_3:SetOperation(c1160001.op3_3)
			tc:RegisterEffect(e3_3)
--
		end
	end
end
--
function c1160001.cfilter3_3_1(c)
	return c:GetType()==TYPE_SPELL and c:IsAbleToRemoveAsCost()
end
function c1160001.cfilter3_3_2(c)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()==1 and c:IsAbleToRemoveAsCost()
end
function c1160001.tg3_3(e,te,tp)
	return te:GetHandler()==e:GetHandler()
end
function c1160001.cost3_3(e,te_or_c,tp)
	return Duel.IsExistingMatchingCard(c1160001.cfilter3_3_1,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c1160001.cfilter3_3_2,tp,LOCATION_GRAVE,0,1,nil)
end
function c1160001.op3_3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1160001)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c1160001.cfilter3_3_1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c1160001.cfilter3_3_2,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
--
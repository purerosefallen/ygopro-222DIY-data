--妖精的呼朋引伴
function c1191001.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1191001.tg1)
	e1:SetOperation(c1191001.op1)
	c:RegisterEffect(e1)
--
end
--
function c1191001.tfilter1(c,e,tp)
	return c:IsCanAddCounter(0x1119,2) and c:IsFaceup()
end
function c1191001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c1191001.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1191001.tfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local sg=Duel.SelectTarget(tp,c1191001.tfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x1119)
end
--
function c1191001.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	if not tc:IsFaceup() then return end
	if not tc:IsRelateToEffect(e) then return end
	if tc:AddCounter(0x1119,2) then
--
		if not tc:IsType(TYPE_EFFECT) then
			local e1_0=Effect.CreateEffect(c)
			e1_0:SetType(EFFECT_TYPE_SINGLE)
			e1_0:SetCode(EFFECT_ADD_TYPE)
			e1_0:SetValue(TYPE_EFFECT)
			e1_0:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1_0)
		end
--
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetDescription(aux.Stringid(1191001,0))
		e1_1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1_1:SetValue(1)
		e1_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_1)
--
		local e1_2=Effect.CreateEffect(c)
		e1_2:SetDescription(aux.Stringid(1191001,1))
		e1_2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_2:SetCode(EVENT_PHASE+PHASE_END)
		e1_2:SetRange(LOCATION_MZONE)
		e1_2:SetCountLimit(1)
		e1_2:SetCondition(c1191001.con1_2)
		e1_2:SetOperation(c1191001.op1_2)
		e1_2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_2)
--
		local e1_3=Effect.CreateEffect(c)
		e1_3:SetDescription(aux.Stringid(1191001,2))
		e1_3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_LVCHANGE)
		e1_3:SetType(EFFECT_TYPE_IGNITION)
		e1_3:SetRange(LOCATION_MZONE)
		e1_3:SetCost(c1191001.cost1_3)
		e1_3:SetTarget(c1191001.tg1_3)
		e1_3:SetOperation(c1191001.op1_3)
		e1_3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_3)
--   
	end
end
--
function c1191001.con1_2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsCanAddCounter(0x1119,2)
end
--
function c1191001.op1_2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x1119,2)
end
--
function c1191001.cost1_3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x1119,1,REASON_COST) end
	c:RemoveCounter(tp,0x1119,1,REASON_COST)
end
--
function c1191001.tg1_3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1190003,0,0x4011,800,800,1,RACE_FAIRY,ATTRIBUTE_LIGHT) and c:GetLevel()>1 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
--
function c1191001.op1_3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	if c:GetLevel()<2 then return end
	if c:IsImmuneToEffect(e) then return end
	if not c:IsRelateToEffect(e) then return end
	local e1_3_1=Effect.CreateEffect(c)
	e1_3_1:SetType(EFFECT_TYPE_SINGLE)
	e1_3_1:SetCode(EFFECT_UPDATE_LEVEL)
	e1_3_1:SetReset(RESET_EVENT+0x1fe0000)
	e1_3_1:SetValue(-1)
	c:RegisterEffect(e1_3_1)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<1 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,1190003,0,0x4011,800,800,1,RACE_FAIRY,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,1190003)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local e1_3_2=Effect.CreateEffect(c)
	e1_3_2:SetDescription(aux.Stringid(1191001,0))
	e1_3_2:SetType(EFFECT_TYPE_SINGLE)
	e1_3_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
	e1_3_2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1_3_2:SetValue(1)
	token:RegisterEffect(e1_3_2)
	Duel.SpecialSummonComplete()
end
--

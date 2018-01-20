--竹取物语·辉夜姬
function c1160041.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetOperation(c1160041.op0)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,1160041)
	e1:SetCondition(c1160041.con1)
	e1:SetOperation(c1160041.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1160041,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1160042)
	e2:SetCost(c1160041.cost2)
	e2:SetOperation(c1160041.op2)
	c:RegisterEffect(e2)
--
end
--
function c1160041.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		c:RegisterFlagEffect(1160041,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,2)
	else
		c:RegisterFlagEffect(1160041,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,1)
	end
end
--
function c1160041.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(1160041)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--
function c1160041.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) then
		if Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)~=0 then
			local lp=Duel.GetLP(1-tp)
			Duel.SetLP(1-tp,lp-400)
--
			local e1_1=Effect.CreateEffect(e:GetHandler())
			e1_1:SetType(EFFECT_TYPE_FIELD)
			e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1_1:SetReset(RESET_PHASE+PHASE_END)
			e1_1:SetTargetRange(1,0)
			e1_1:SetTarget(c1160041.tg1_1)
			Duel.RegisterEffect(e1_1,tp)
--
		end
	end
end
function c1160041.tg1_1(e,c)
	return not (c:GetLevel()==1 or c:IsLocation(LOCATION_EXTRA))
end
--
function c1160041.cfilter2(c)
	return c:IsAbleToDeckAsCost() and (c:GetType()==TYPE_SPELL or (c:IsType(TYPE_MONSTER) and c:GetLevel()==1 and c:IsAttribute(ATTRIBUTE_LIGHT) and c:GetAttack()>399))
end
function c1160041.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1160041.cfilter2,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1160041.cfilter2,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
--
function c1160041.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetTurnPlayer()~=tp then
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2_1:SetCode(EVENT_LEAVE_FIELD)
		e2_1:SetCondition(c1160041.con2_1)
		e2_1:SetOperation(c1160041.op2_1)
		e2_1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2_1,tp)
	else
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2_1:SetCode(EVENT_LEAVE_FIELD)
		e2_1:SetOperation(c1160041.op2_1)
		e2_1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2_1,tp)
	end
end
--
function c1160041.cfilter2_1(c)
	return c:IsCode(1160041) and c:IsFaceup()
end
function c1160041.con2_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1160041.cfilter2_1,tp,LOCATION_MZONE,0,1,nil)
end
--
function c1160041.ofilter2_1(c,tp)
	return c:GetPreviousControler()~=tp and not (c:GetType()==TYPE_SPELL or c:IsType(TYPE_SPELL+TYPE_QUICKPLAY) or c:IsType(TYPE_SPELL+TYPE_RITUAL))
end
function c1160041.op2_1(e,tp,eg,ep,ev,re,r,rp)
	local num=eg:FilterCount(c1160041.ofilter2_1,nil,tp)
	if num>0 then
		local lp=Duel.GetLP(1-tp)
		Duel.SetLP(1-tp,lp-num*200)
	end
end
--

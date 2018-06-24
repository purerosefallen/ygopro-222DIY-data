--上神契约
function c1131301.initial_effect(c)
--
	if not c1131301.global_check then
		c1131301.global_check=true
		local e0=Effect.GlobalEffect()
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_LEAVE_FIELD)
		e0:SetCondition(c1131301.con0)
		e0:SetOperation(c1131301.op0)
		Duel.RegisterEffect(e0,0)
	end
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c1131301.con1)
	e1:SetTarget(c1131301.tg1)
	e1:SetOperation(c1131301.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DRAW)
	e2:SetCondition(c1131301.con2)
	e2:SetOperation(c1131301.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_HAND)
	e3:SetTarget(c1131301.tg3)
	e3:SetValue(c1131301.val3)
	e3:SetOperation(c1131301.op3)
	c:RegisterEffect(e3)
--
end
--
function c1131301.cfilter0(c,rp)
	return c:IsCode(1131301) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()~=rp
end
function c1131301.con0(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1131301.cfilter0,1,nil,rp)
end
--
function c1131301.op0(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(1-rp,1131301,0,0,0)
end
--
function c1131301.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,1131301)>0
end
--
function c1131301.tfilter1_1(c)
	return muxu.check_set_Hinbackc(c) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_RITUAL)
end
function c1131301.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local sg=Duel.GetMatchingGroup(c1131301.tfilter1_1,tp,LOCATION_HAND,0,nil)
		if sg:GetCount()<1 then return false end
		local sc=sg:GetFirst()
		local checknum=0
		while sc do
			local e1_1=Effect.CreateEffect(sc)
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetCode(EFFECT_CHANGE_TYPE)
			e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1_1:SetValue(TYPE_RITUAL+TYPE_MONSTER+TYPE_EFFECT)
			e1_1:SetReset(RESET_EVENT+0x47c0000)
			sc:RegisterEffect(e1_1,true)
			if sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false) then checknum=1 end
			e1_1:Reset()
			sc=sg:GetNext()
		end
		return checknum==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
--
function c1131301.op1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c1131301.tfilter1_1,tp,LOCATION_HAND,0,nil)
	if sg:GetCount()<1 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local sc=sg:GetFirst()
	local tg=Group.CreateGroup()
	while sc do
		local e1_1=Effect.CreateEffect(sc)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_CHANGE_TYPE)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_1:SetValue(TYPE_RITUAL+TYPE_MONSTER+TYPE_EFFECT)
		e1_1:SetReset(RESET_EVENT+0x47c0000)
		sc:RegisterEffect(e1_1,true)
		if sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false) then tg:AddCard(sc) end
		e1_1:Reset()
		sc=sg:GetNext()
	end
	if tg:GetCount()<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ng=tg:Select(tp,1,1,nil)
	local nc=ng:GetFirst()
	local e1_2=Effect.CreateEffect(nc)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetCode(EFFECT_CHANGE_TYPE)
	e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_2:SetValue(TYPE_RITUAL+TYPE_MONSTER+TYPE_EFFECT)
	e1_2:SetReset(RESET_EVENT+0xfe0000)
	nc:RegisterEffect(e1_2,true)
	nc:SetMaterial(nil)
	Duel.SpecialSummon(nc,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
	local e1_5=Effect.CreateEffect(nc)
	e1_5:SetDescription(aux.Stringid(1131301,0))
	e1_5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1_5:SetType(EFFECT_TYPE_SINGLE)
	nc:RegisterEffect(e1_5,true)
	local e1_3=Effect.CreateEffect(nc)
	e1_3:SetType(EFFECT_TYPE_SINGLE)
	e1_3:SetCode(EFFECT_UPDATE_ATTACK)
	e1_3:SetReset(RESET_EVENT+0xfe0000)
	e1_3:SetValue(1200)
	nc:RegisterEffect(e1_3,true)
	local e1_4=Effect.CreateEffect(nc)
	e1_4:SetDescription(aux.Stringid(1131301,1))
	e1_4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1_4:SetType(EFFECT_TYPE_SINGLE)
	e1_4:SetCode(EFFECT_IMMUNE_EFFECT)
	e1_4:SetValue(c1131301.efilter1_4)
	e1_4:SetOwnerPlayer(tp)
	e1_4:SetReset(RESET_EVENT+0xfe0000)
	nc:RegisterEffect(e1_4,true)
	nc:CompleteProcedure()
end
--
function c1131301.efilter1_4(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--
function c1131301.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,1131301)==0 and Duel.GetCurrentPhase()==PHASE_DRAW and c:IsReason(REASON_RULE)
end
--
function c1131301.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetCode(EFFECT_PUBLIC)
	e2_1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2_1)
	c:RegisterFlagEffect(1131301,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
end
--
function c1131301.tfilter3(c,tp)
	return c:IsFaceup() and muxu.check_set_Hinbackc(c) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c1131301.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and eg:IsExists(c1131301.tfilter3,1,nil,tp) end
	return c:GetFlagEffect(1131301)>0 and Duel.SelectEffectYesNo(tp,c,96)
end
--
function c1131301.val3(e,c)
	return c1131301.tfilter3(c,e:GetHandlerPlayer())
end
--
function c1131301.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT)
end
--

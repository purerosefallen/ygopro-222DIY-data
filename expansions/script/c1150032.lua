--玫瑰花园
function c1150032.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,1150032)
	e1:SetCost(c1150032.cost1)
	e1:SetTarget(c1150032.tg1)
	e1:SetOperation(c1150032.op1)
	c:RegisterEffect(e1)	
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c1150032.tg2)
	e2:SetOperation(c1150032.op2)
	c:RegisterEffect(e2)
--
end
--
function c1150032.cfilter1(c)
	return c:IsRace(RACE_PLANT) and c:IsReleasable()
end
function c1150032.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1150032.cfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c1150032.cfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,2,2,nil)
	Duel.Release(g,REASON_COST)
end
--
function c1150032.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if chk==0 then return ct>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1150034,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
end
--
function c1150032.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if (ct1>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1150034,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_DARK)) and (ct2>0 and Duel.IsPlayerCanSpecialSummonMonster(1-tp,1150034,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_DARK)) then
		local i=0
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct1=1 end
		for i=1,ct1 do
			local token=Duel.CreateToken(tp,1150034)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1_2=Effect.CreateEffect(e:GetHandler())
			e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1_2:SetType(EFFECT_TYPE_SINGLE)
			e1_2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e1_2:SetValue(1)
			token:RegisterEffect(e1_2,true)
		end
		if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ct2=1 end
		for i=1,ct2 do
			local token=Duel.CreateToken(1-tp,1150034)
			Duel.SpecialSummonStep(token,0,1-tp,1-tp,false,false,POS_FACEUP)
			local e1_2=Effect.CreateEffect(e:GetHandler())
			e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1_2:SetType(EFFECT_TYPE_SINGLE)
			e1_2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e1_2:SetValue(1)
			token:RegisterEffect(e1_2,true)
		end
		Duel.SpecialSummonComplete()
		local e1_1=Effect.CreateEffect(e:GetHandler())
		e1_1:SetType(EFFECT_TYPE_FIELD)
		e1_1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1_1:SetTargetRange(LOCATION_HAND,0)
		e1_1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PLANT))
		e1_1:SetValue(0x1)
		e1_1:SetReset(EVENT_PHASE+PHASE_END)
		Duel.RegisterEffect(e1_1,tp)
	else
		if ct1>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1150034,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_DARK) then
			local i=0
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct1=1 end
			for i=1,ct1 do
				local token=Duel.CreateToken(tp,1150034)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
				local e1_2=Effect.CreateEffect(e:GetHandler())
				e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1_2:SetType(EFFECT_TYPE_SINGLE)
				e1_2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				e1_2:SetValue(1)
				token:RegisterEffect(e1_2,true)
			end
			Duel.SpecialSummonComplete()
			local e1_1=Effect.CreateEffect(e:GetHandler())
			e1_1:SetType(EFFECT_TYPE_FIELD)
			e1_1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
			e1_1:SetTargetRange(LOCATION_HAND,0)
			e1_1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PLANT))
			e1_1:SetValue(0x1)
			e1_1:SetReset(EVENT_PHASE+PHASE_END)
			Duel.RegisterEffect(e1_1,tp)
		else
			if ct2>0 and Duel.IsPlayerCanSpecialSummonMonster(1-tp,1150034,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_DARK) then
				local i=0
				if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ct2=1 end
				for i=1,ct2 do
					local token=Duel.CreateToken(1-tp,1150034)
					Duel.SpecialSummonStep(token,0,1-tp,1-tp,false,false,POS_FACEUP)
					local e1_2=Effect.CreateEffect(e:GetHandler())
					e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
					e1_2:SetType(EFFECT_TYPE_SINGLE)
					e1_2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
					e1_2:SetValue(1)
					token:RegisterEffect(e1_2,true)
				end
				Duel.SpecialSummonComplete()
				local e1_1=Effect.CreateEffect(e:GetHandler())
				e1_1:SetType(EFFECT_TYPE_FIELD)
				e1_1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
				e1_1:SetTargetRange(LOCATION_HAND,0)
				e1_1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PLANT))
				e1_1:SetValue(0x1)
				e1_1:SetReset(EVENT_PHASE+PHASE_END)
				Duel.RegisterEffect(e1_1,tp)
			end
		end
	end
end
--
function c1150032.tfilter2(c)
	return c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_PLANT)
end
function c1150032.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	return eg:IsExists(c1150032.tfilter2,1,nil)
end
--
function c1150032.op2(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c1150032.tfilter2,nil)
	local tc=sg:GetFirst()
	local check1=0
	local check2=0
	while tc do
		local p=tc:GetPreviousControler()
		if p==tp then check1=1 end
		if p~=tp then check2=1 end
		tc=sg:GetNext()
	end
	if check1==1 then 
		local lp=Duel.GetLP(tp)
		if lp>300 then lp=lp-300
		else lp=0 end
		Duel.SetLP(tp,lp)
	end
	if check2==1 then
		local lp=Duel.GetLP(1-tp)
		if lp>300 then lp=lp-300
		else lp=0 end
		Duel.SetLP(1-tp,lp)
	end
end
--

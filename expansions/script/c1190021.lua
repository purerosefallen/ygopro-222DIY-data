--纯爱妖精·波拉
--
c1190021.dfc_front_side=1190021
c1190021.dfc_back1_side=1190022
c1190021.dfc_back2_side=1190023
--
function c1190021.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1190021,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1190021.con1)
	e1:SetTarget(c1190021.tg1)
	e1:SetOperation(c1190021.op1)
	c:RegisterEffect(e1)
--
	if not c1190021.global_check1 then
		c1190021.global_check1=true
		local e0_1=Effect.CreateEffect(c)
		e0_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0_1:SetCode(EVENT_CHAINING)
		e0_1:SetOperation(c1190021.op0_1)
		Duel.RegisterEffect(e0_1,0)
	end
--
	if not c1190021.global_check2 then
		c1190021.global_check2=true
		c1190021[0]=0
		c1190021[1]=0
		local e0_3=Effect.CreateEffect(c)
		e0_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0_3:SetCode(EVENT_SUMMON_SUCCESS)
		e0_3:SetOperation(c1190021.op0_3)
		Duel.RegisterEffect(e0_3,0)
		local e0_4=Effect.CreateEffect(c)
		e0_4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0_4:SetCode(EVENT_SPSUMMON_SUCCESS)
		e0_4:SetOperation(c1190021.op0_4)
		Duel.RegisterEffect(e0_4,0)
		local e0_5=Effect.GlobalEffect()
		e0_5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0_5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e0_5:SetCountLimit(1)
		e0_5:SetOperation(c1190021.clear0_5)
		Duel.RegisterEffect(e0_5,0)
	end
--
end
--
function c1190021.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetFlagEffect(tp,1190021)>1
end
--
function c1190021.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and ((Duel.GetFlagEffect(tp,1190022)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or (Duel.GetFlagEffect(tp,1190022)<1 and (Duel.IsPlayerCanSpecialSummonMonster(tp,1190022,0,0x21,0,0,2,RACE_FAIRY,ATTRIBUTE_WIND) or Duel.IsPlayerCanSpecialSummonMonster(tp,1190022,0,0x21,0,0,2,RACE_FAIRY,ATTRIBUTE_FIRE)))) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
--
function c1190021.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetMZoneCount(tp)<1 then return end
	if Duel.GetFlagEffect(tp,1190022)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	else
		local b1=Duel.IsPlayerCanSpecialSummonMonster(tp,1190022,0,0x21,0,0,2,RACE_FAIRY,ATTRIBUTE_WIND)
		local b2=Duel.IsPlayerCanSpecialSummonMonster(tp,1190022,0,0x21,0,0,2,RACE_FAIRY,ATTRIBUTE_FIRE)
		if not (b1 or b2) then return end
		local off=1
		local ops={}
		local opval={}
		if b1 then
			ops[off]=aux.Stringid(1190021,1)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(1190021,2)
			opval[off-1]=2
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		local sel=opval[op]
		e:SetLabel(sel)
		if sel==1 then
			local tcode=c.dfc_back1_side
			c:SetEntityCode(tcode,true)
			c:ReplaceEffect(tcode,0,0)
			Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
		else
			local tcode=c.dfc_back2_side
			c:SetEntityCode(tcode,true)
			c:ReplaceEffect(tcode,0,0)
			Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
		end
	end
end
--
function c1190021.op0_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,1190021,RESET_PHASE+PHASE_END,0,1)
end
--
function c1190021.op0_3(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local p=tc:GetSummonPlayer()
		local num=tc:GetLevel()+tc:GetRank()+tc:GetLink()
		if c1190021[rp]<=1 then
			Duel.RegisterFlagEffect(rp,1190022,RESET_PHASE+PHASE_END,0,1)
		else
			c1190021[rp]=c1190021[rp]-num
		end
		tc=eg:GetNext()
	end
end
--
function c1190021.op0_4(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local p=tc:GetSummonPlayer()
		local num=tc:GetLevel()+tc:GetRank()+tc:GetLink()
		if c1190021[rp]<=1 then
			Duel.RegisterFlagEffect(rp,1190022,RESET_PHASE+PHASE_END,0,1)
		else
			c1190021[rp]=c1190021[rp]-num
		end
		tc=eg:GetNext()
	end
end
--
function c1190021.clear0_5(e,tp,eg,ep,ev,re,r,rp)
	c1190021[0]=Duel.GetTurnCount()
	c1190021[1]=Duel.GetTurnCount()
end
--

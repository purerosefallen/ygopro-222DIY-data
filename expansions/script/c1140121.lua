--无名之丘
function c1140121.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(c1140121.tg1)
	e1:SetOperation(c1140121.op1)
	c:RegisterEffect(e1)
--
end
--
function c1140121.tfilter1(c,tp)
	return c:IsFaceup() 
		and c:IsReleasable()
		and c:GetSummonPlayer()==tp
		and c:IsLocation(LOCATION_MZONE) 
		and not muxu.check_set_Poison(c)
		and not muxu.check_set_Medicine(c)
		and not c:IsCode(1140901)
end
function c1140121.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c1140121.tfilter1,1,nil,tp) end
	local sg=eg:Filter(c1140121.tfilter1,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,sg,sg:GetCount(),0,0)
end
--
function c1140121.ofilter1(c,e,tp)
	return c:IsFaceup() 
		and c:GetSummonPlayer()==tp
		and c:IsLocation(LOCATION_MZONE) 
		and not muxu.check_set_Poison(c)
		and not muxu.check_set_Medicine(c)
		and not c:IsCode(1140901)
		and c:IsRelateToEffect(e)
end
function c1140121.op1(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c1140121.ofilter1,nil,e,tp)
	if sg:GetCount()<1 then return end
	local rnum=Duel.Release(sg,REASON_EFFECT)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft1<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft1=1 end
	local tnum=math.min(rnum,ft1)
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,1140901,nil,0x4011,400,600,1,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP,tp) then return end
	if tnum<1 then return end
	Duel.BreakEffect()
	while tnum>0 do
		local token=Duel.CreateToken(tp,1140901)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		tnum=tnum-1
	end
	Duel.SpecialSummonComplete()
end
--

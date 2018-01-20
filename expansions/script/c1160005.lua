--圣夜颂歌·爱丽丝
function c1160005.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1160005,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1160005.con1)
	e1:SetOperation(c1160005.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1160005,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1160005)
	e2:SetCost(c1160005.cost2)
	e2:SetTarget(c1160005.tg2)
	e2:SetOperation(c1160005.op2)
	c:RegisterEffect(e2)
--
	if not c1160005.gchk then
		c1160005.gchk=true
		c1160005[0]=3
		c1160005[1]=3
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetCondition(c1160005.con3)
		e3:SetOperation(c1160005.op3)
		Duel.RegisterEffect(e3,0)
		local e4=Effect.GlobalEffect()
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e4:SetCountLimit(1)
		e4:SetOperation(c1160005.clear4)
		Duel.RegisterEffect(e4,0)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_CUSTOM+1160005)
		e5:SetOperation(c1160005.op5)
		Duel.RegisterEffect(e5,0)
	end
--
end
--
function c1160005.cfilter1(c)
	return c:IsAbleToRemoveAsCost()
end
function c1160005.con1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c1160005.cfilter1,tp,LOCATION_GRAVE,0,1,nil)
end
--
function c1160005.op1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1160005.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e1_1=Effect.CreateEffect(e:GetHandler())
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetCode(EFFECT_REVERSE_UPDATE)
	e1_1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1_1:SetReset(RESET_PHASE+PHASE_END,2)
	e1_1:SetTargetRange(0,LOCATION_MZONE)
	Duel.RegisterEffect(e1_1,tp)
end
--
function c1160005.ofilter3(c)
	return c:IsPreviousLocation(LOCATION_EXTRA)
end
function c1160005.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(c1160005.ofilter3,nil)>0
end
function c1160005.op3(e,tp,eg,ep,ev,re,r,rp)
	if c1160005[rp]<=1 then
		Duel.RaiseEvent(eg,EVENT_CUSTOM+1160005,re,r,rp,ep,ev)
	else
		c1160005[rp]=c1160005[rp]-1
	end
end
function c1160005.clear4(e,tp,eg,ep,ev,re,r,rp)
	c1160005[0]=3
	c1160005[1]=3
end
function c1160005.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,1160005,RESET_PHASE+PHASE_END,0,2)
end
--
function c1160005.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(1-tp,1160005)>0 or c:IsAbleToHandAsCost() end
	if Duel.GetFlagEffect(1-tp,1160005)>0 and Duel.SelectYesNo(tp,aux.Stringid(1160005,2)) then
		e:SetLabel(0)
	else
		e:SetLabel(1)
		Duel.SendtoHand(c,nil,REASON_COST)
	end
end
--
function c1160005.tfilter2(c,e,tp)
	return c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup() and c:GetAttack()>399 and c:IsRace(RACE_WARRIOR)
end
function c1160005.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return ((c:GetSequence()>4 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or c:GetSequence()<5) 
		and Duel.IsExistingMatchingCard(c1160005.tfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
--
function c1160005.ofilter2(c,tp)
	return c:IsFaceup() and c:GetControler()~=tp and not c:IsDisabled()
end
function c1160005.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1160005.tfilter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1160005,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local gn=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_REMOVED,0,1,1,nil)
			if gn:GetCount()>0 then
				Duel.SendtoGrave(gn,REASON_EFFECT+REASON_RETURN)
			end
		end
	end
	local checkcost=e:GetLabel()
	if c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and checkcost==0 then
		local g2=c:GetColumnGroup(1,1)
		local gn2=g2:Filter(c1160005.ofilter2,nil,tp)
		if gn2:GetCount()>0 then
			local tc2=gn2:GetFirst()
			while tc2 do
--
				local e2_1=Effect.CreateEffect(c)
				e2_1:SetType(EFFECT_TYPE_SINGLE)
				e2_1:SetCode(EFFECT_DISABLE)
				e2_1:SetReset(RESET_EVENT+0xfe0000)
				tc2:RegisterEffect(e2_1)
				local e2_2=Effect.CreateEffect(c)
				e2_2:SetType(EFFECT_TYPE_SINGLE)
				e2_2:SetCode(EFFECT_DISABLE_EFFECT)
				e2_2:SetReset(RESET_EVENT+0xfe0000)
				tc2:RegisterEffect(e2_2)
--
				tc2=gn2:GetNext()
			end
		end
	end
end


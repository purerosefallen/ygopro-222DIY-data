--梦坠
function c71400013.initial_effect(c)
	--Activate(nofield)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400013,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCondition(c71400013.condition1)
	e1:SetTarget(c71400013.target1)
	e1:SetCost(c71400013.cost)
	e1:SetOperation(c71400013.operation1)
	e1:SetCountLimit(1,71400013+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--Activate(field)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400013,2))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c71400013.condition2)
	e2:SetTarget(c71400013.target2)
	e2:SetCost(c71400013.cost)
	e2:SetOperation(c71400013.operation2)
	e2:SetCountLimit(1,71400013+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e2)
end
function c71400013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c71400013.condition1(e,tp,eg,ep,ev,re,r,rp)
	tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	return tc==nil or tc:IsFacedown() or not tc:IsSetCard(0x3714)
end
function c71400013.condition2(e,tp,eg,ep,ev,re,r,rp)
	tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	return tc and tc:IsFaceup() and tc:IsSetCard(0x3714)
end
function c71400013.filter1(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp) and c:IsSetCard(0xb714)
end
function c71400013.filter1a(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function c71400013.filter2(c)
	return c:IsSetCard(0x714) and c:IsAbleToGrave() and not c:IsCode(71400013)
end
function c71400013.filter2a(c)
	return (not c:IsDisabled() or c:IsType(TYPE_TRAPMONSTER)) and not (c:IsType(TYPE_NORMAL) and bit.band(c:GetOriginalType(),TYPE_NORMAL))
end
function c71400013.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71400013,0))
	local tc=Duel.SelectMatchingCard(tp,c71400013.filter1,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		local flag=Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,71400013,te,0,tp,tp,Duel.GetCurrentChain())
		local dg=Duel.GetMatchingGroup(c71400013.filter1a,tp,0,LOCATION_ONFIELD,nil)
		if dg:GetCount()>0 and flag and Duel.SelectYesNo(tp,aux.Stringid(71400013,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local des=dg:Select(tp,1,1,nil)
			Duel.HintSelection(des)
			Duel.BreakEffect()
			Duel.SendtoGrave(des,REASON_EFFECT)
		end
	end
	local el1=Effect.CreateEffect(c)
	el1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	el1:SetType(EFFECT_TYPE_FIELD)
	el1:SetCode(EFFECT_CANNOT_SUMMON)
	el1:SetTarget(c71400013.sumlimit)
	el1:SetTargetRange(1,0)
	el1:SetReset(RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(el1,tp)
	local el2=el1:Clone()
	el2:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(el2)
	local el3=el1:Clone()
	el3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(el3)
end
function c71400013.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c71400013.filter2,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,nil,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if og:GetCount()>0 then
			local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
			if g1:GetCount()>0 then
				Duel.BreakEffect()
			end
			local ng=g1:Filter(c71400013.filter2a,nil)
			local nc=ng:GetFirst()
			while nc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_PHASE+PHASE_END)
				nc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e1:SetReset(RESET_PHASE+PHASE_END)
				nc:RegisterEffect(e2)
				if nc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_PHASE+PHASE_END)
					nc:RegisterEffect(e3)
				end
				nc=ng:GetNext()
			end
		end
	end
	local el1=Effect.CreateEffect(c)
	el1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	el1:SetType(EFFECT_TYPE_FIELD)
	el1:SetCode(EFFECT_CANNOT_SUMMON)
	el1:SetTarget(c71400013.sumlimit)
	el1:SetTargetRange(1,0)
	el1:SetReset(RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(el1,tp)
	local el2=el1:Clone()
	el2:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(el2)
	local el3=el1:Clone()
	el3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(el3)
end
function c71400013.sumlimit(e,c)
	return not c:IsSetCard(0x714)
end
function c71400013.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400013.filter1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,LOCATION_ONFIELD)
end
function c71400013.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400013.filter2,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
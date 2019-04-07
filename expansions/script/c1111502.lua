--灵都·幻想天地
local m=1111502
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1111502.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1111502,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c1111502.con1)
	e1:SetCost(c1111502.cost1)
	e1:SetTarget(c1111502.tg1)
	e1:SetOperation(c1111502.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c1111502.con2)
	e2:SetTarget(c1111502.tg2)
	e2:SetOperation(c1111502.op2)
	c:RegisterEffect(e2)
--
end
--
function c1111502.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil)
end
--
function c1111502.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
--
function c1111502.tfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and muxu.check_set_Urban(c) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsRace(RACE_FAIRY)
end
function c1111502.ofilter1(c,tp)
	return muxu.check_set_Urban(c) and c:IsType(TYPE_SPELL) 
		and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE,0)>0) and not c:IsForbidden()
end
function c1111502.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1111502.tfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c1111502.ofilter1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
--
function c1111502.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c1111502.tfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if sg:GetCount()<1 then return end
	if Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP)>0 then
		if Duel.IsExistingMatchingCard(c1111502.ofilter1,tp,LOCATION_DECK,0,1,nil,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1111502,2))
			local tg=Duel.SelectMatchingCard(tp,c1111502.ofilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
			if tg:GetCount()<1 then return end
			Duel.BreakEffect()
			local tc=tg:GetFirst()
			if tc:IsType(TYPE_FIELD) then
				local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc then Duel.SendtoGrave(fc,REASON_RULE) end
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
--
function c1111502.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
		and c:GetPreviousControler()==tp and rp==1-tp
end
--
function c1111502.tfilter2(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c1111502.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111502.tfilter2,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c1111502.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1111502,3))
	local tc=Duel.SelectMatchingCard(tp,c1111502.tfilter2,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
--

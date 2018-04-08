--伊始·梦蝶
local m=1110006
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1110006.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,1110006)
	e1:SetCost(c1110006.cost1)
	e1:SetTarget(c1110006.tg1)
	e1:SetOperation(c1110006.op1)
	c:RegisterEffect(e1)  
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1110006,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c1110006.cost2)
	e2:SetTarget(c1110006.tg2)
	e2:SetOperation(c1110006.op2)
	c:RegisterEffect(e2)
--
end
--
function c1110006.cfilter1(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and muxu.check_set_Soul(c)
end
function c1110006.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1110006.cfilter1,tp,LOCATION_DECK,0,1,nil) and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	local g=Duel.GetMatchingGroup(c1110006.cfilter1,tp,LOCATION_DECK,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	local gn=Group.CreateGroup()
	for i=1,ct do
		if i==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g:Select(tp,1,1,nil)
			g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
			gn:Merge(sg)
		else
			if Duel.SelectYesNo(tp,aux.Stringid(1110006,3)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=g:Select(tp,1,1,nil)
				g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
				gn:Merge(sg)
			else
				break
			end
		end
	end
	Duel.SendtoGrave(gn,REASON_COST)
end
--
function c1110006.tfilter1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c1110006.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110006.tfilter1,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c1110006.tfilter1,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
--
function c1110006.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c1110006.tfilter1,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()<=0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1_1:SetTargetRange(0,1)
	e1_1:SetValue(1)
	e1_1:SetCondition(c1110006.con1_1)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_1,tp)
end
function c1110006.con1_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
--
function c1110006.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end
--
function c1110006.tfilter2(c,e,tp)
	return muxu.check_set_Urban(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER) and c:GetLevel()==3
end
function c1110006.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ((seq>4 and ft>0) or seq<5) and Duel.IsExistingMatchingCard(c1110006.tfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
--
function c1110006.ofilter2(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and muxu.check_set_Urban(c)
end
function c1110006.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1110006.tfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()<=0 then return end
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if Duel.IsExistingMatchingCard(c1110006.ofilter2,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1110006,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1110006,2))
		local gn=Duel.SelectMatchingCard(tp,c1110006.ofilter2,tp,LOCATION_DECK,0,1,1,nil)
		if gn:GetCount()>0 then
			local tc=gn:GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
--

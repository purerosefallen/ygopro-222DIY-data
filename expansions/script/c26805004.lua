--凛世秋千·杜野凛世
function c26805004.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_WIND),2)
	c:EnableReviveLimit()
	--synchro effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26805004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26805004)
	e1:SetCondition(c26805004.sccon)
	e1:SetTarget(c26805004.sctg)
	e1:SetOperation(c26805004.scop)
	c:RegisterEffect(e1)
	--activate Zombie World
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26805004,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,26805904)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c26805004.actg)
	e3:SetOperation(c26805004.acop)
	c:RegisterEffect(e3)
end
function c26805004.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_TUNER)
end
function c26805004.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c26805004.scfilter(c,mg)
	return c:IsSynchroSummonable(nil,mg)
end
function c26805004.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=e:GetHandler():GetLinkedGroup()
		return Duel.IsExistingMatchingCard(c26805004.scfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26805004.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local mg=c:GetLinkedGroup()
	local g=Duel.GetMatchingGroup(c26805004.scfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end
function c26805004.filter(c,tp)
	return c:IsCode(81010004) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26805004.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26805004.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
end
function c26805004.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c26805004.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
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

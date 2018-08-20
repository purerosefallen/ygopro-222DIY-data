--火枪手
function c12013003.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xfb6),aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),true)
	 --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12013003,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12013003+100)
	e2:SetCost(c12013003.spcost)
	e2:SetTarget(c12013003.sptg)
	e2:SetOperation(c12013003.spop)
	c:RegisterEffect(e2)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12013003,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,12013003)
	e1:SetCost(c12013003.cost)
--  e1:SetCondition(c12013003.target)
	e1:SetOperation(c12013003.operation)
	c:RegisterEffect(e1)
end
function c12013003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,3) end
	Duel.DiscardDeck(tp,3,REASON_COST)
	local g=Duel.GetOperatedGroup()
	local tt=0
	local tc=g:GetFirst()
	while tc do
		  if tc:IsType(TYPE_MONSTER) then
		  local atk=tc:GetAttack()
		  tt=tt+atk end
		  tc=g:GetNext()
	end  
	   e:SetLabel(tt)
end
function c12013003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tt=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(tt)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,tt)
end
function c12013003.operation(e,tp,eg,ep,ev,re,r,rp)
	local tt=e:GetLabel()
	Duel.Recover(tp,tt,REASON_EFFECT)
end
function c12013003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c12013003.spfilter(c,e,tp)
	return c:IsSetCard(0xfb6) and not c:IsCode(12013003) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12013003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c12013003.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	if chk==0 then return ft>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and g:GetClassCount(Card.GetCode)>=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=g:Select(tp,1,1,nil)
	g1:Merge(g2)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
end
function c12013003.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() or (#g>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	local tc=g:GetFirst()
	while tc do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
--古记龙鲨 淢
function c76121006.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--nontuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76121006,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCountLimit(1,76121006)
	e2:SetTarget(c76121006.sctg)
	e2:SetOperation(c76121006.scop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(76121006,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,76121006)
	e3:SetCondition(c76121006.sccon2)
	e3:SetTarget(c76121006.sctg)
	e3:SetOperation(c76121006.scop)
	c:RegisterEffect(e3)
end
function c76121006.sccon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c76121006.scfilter1(c,e,tp,mc)
	local mg=Group.FromCards(c,mc)
	return c:IsSetCard(0xea1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c76121006.scfilter2,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function c76121006.scfilter2(c,mg)
	return c:IsType(TYPE_SYNCHRO) and c:IsSynchroSummonable(nil,mg)
end
function c76121006.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c76121006.scfilter1,tp,LOCATION_HAND,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c76121006.scop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c76121006.scfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp,c)
	local tc=g:GetFirst()
	if not tc or not Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	tc:RegisterEffect(e2)
	Duel.SpecialSummonComplete()
	if not c:IsRelateToEffect(e) then return end
	local mg=Group.FromCards(c,tc)
	local g=Duel.GetMatchingGroup(c76121006.scfilter2,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end
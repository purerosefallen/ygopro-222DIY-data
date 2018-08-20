--御龙的降灵术
function c11115021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,11115021+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11115021.condition)
	e1:SetCost(c11115021.cost)
	e1:SetTarget(c11115021.target)
	e1:SetOperation(c11115021.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(11115021,ACTIVITY_SPSUMMON,c11115021.counterfilter)
end
function c11115021.counterfilter(c)
	return c:IsSetCard(0x15e)
end
function c11115021.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c11115021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(11115021,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11115021.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c11115021.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x15e)
end
function c11115021.rmfilter1(c,tp)
	return c:IsSetCard(0x115e) and c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
	    and Duel.IsExistingMatchingCard(c11115021.rmfilter2,tp,LOCATION_GRAVE,0,1,c)
end
function c11115021.rmfilter2(c)
	return c:IsSetCard(0x215e) and not c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
end
function c11115021.rmfilter3(c,tp)
	return c:IsSetCard(0x115e) and c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
	    and Duel.IsExistingMatchingCard(c11115021.rmfilter4,tp,LOCATION_GRAVE,0,1,c,tp)
end
function c11115021.rmfilter4(c,tp)
	return c:IsSetCard(0x115e) and c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
	    and Duel.IsExistingMatchingCard(c11115021.rmfilter5,tp,LOCATION_GRAVE,0,1,nil)
end
function c11115021.rmfilter5(c)
	return c:IsSetCard(0xa15e) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
end
function c11115021.spfilter1(c,e,tp)
	return c:IsSetCard(0xa15e) and c:IsType(TYPE_SYNCHRO)
	    and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11115021.spfilter2(c,e,tp)
	return c:IsCode(11115018) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c11115021.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.IsExistingMatchingCard(c11115021.rmfilter1,tp,LOCATION_GRAVE,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c11115021.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c11115021.rmfilter3,tp,LOCATION_GRAVE,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c11115021.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
	    and (b1 or b2) end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(11115021,0),aux.Stringid(11115021,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(11115021,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(11115021,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=Duel.SelectMatchingCard(tp,c11115021.rmfilter1,tp,LOCATION_GRAVE,0,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,c11115021.rmfilter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst())
		g1:Merge(g2)
		Duel.Remove(g1,POS_FACEUP,REASON_COST)
	else
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=Duel.SelectMatchingCard(tp,c11115021.rmfilter3,tp,LOCATION_GRAVE,0,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,c11115021.rmfilter4,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),tp)
		g1:Merge(g2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g3=Duel.SelectMatchingCard(tp,c11115021.rmfilter5,tp,LOCATION_GRAVE,0,1,1,nil)
		g1:Merge(g3)
		Duel.Remove(g1,POS_FACEUP,REASON_COST)
    end	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11115021.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local op=e:GetLabel()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c11115021.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c11115021.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		end
	end
end
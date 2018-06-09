--觉醒后的坚强 丘依儿
function c12005002.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12005002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c12005002.spcon)
	e1:SetTarget(c12005002.sptg)
	e1:SetOperation(c12005002.spop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12005002,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12005102)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.CheckReleaseGroup(tp,c12005002.cfilter1,1,nil,tp) end
		local g1=Duel.SelectReleaseGroup(tp,c12005002.cfilter1,1,1,nil,tp)
		Duel.Release(g1,REASON_COST)
	end) 
	e2:SetTarget(c12005002.sptg1)
	e2:SetOperation(c12005002.spop1)
	c:RegisterEffect(e2)
end
function c12005002.cfilter1(c,e,tp)
	return c:IsSetCard(0xfbb) and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c))>0
end
function c12005002.spfilter(c,e,tp)
	return c:IsSetCard(0xfbb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12005002.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c12005002.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12005002.spop1(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCountFromEx(tp)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c12005002.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c12005002.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfbb)
end
function c12005002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12005002.cfilter,1,nil)
end
function c12005002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12005002.filter(c,e,tp)
	return c:IsSetCard(0xfbb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12005002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(c12005002.filter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	   if Duel.SelectYesNo(tp,aux.Stringid(12005002,2)) then
		   local g=Duel.SelectMatchingCard(tp,c12005002.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			   if g:GetCount()>0 then
					  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			   end
	   end
	end
end
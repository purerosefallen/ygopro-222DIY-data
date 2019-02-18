--指甲油涂抹课程
c81008028.card_code_list={81010019}
function c81008028.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81008028+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81008028.cost)
	e1:SetTarget(c81008028.target)
	e1:SetOperation(c81008028.activate)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
end
function c81008028.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c81008028.costfilter(c,e,tp)
	return c:IsFaceup() and c:IsCode(81010019) and c:GetOriginalLevel()>0 and Duel.IsExistingMatchingCard(c81008028.spfilter,tp,LOCATION_DECK,0,1,nil,c,e,tp)
		and Duel.GetMZoneCount(tp,c)>0
end
function c81008028.spfilter(c,tc,e,tp)
	return c:GetOriginalLevel()==tc:GetOriginalLevel() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c81008028.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.CheckReleaseGroup(tp,c81008028.costfilter,1,nil,e,tp)
	end
	e:SetLabel(0)
	local g=Duel.SelectReleaseGroup(tp,c81008028.costfilter,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c81008028.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81008028.spfilter,tp,LOCATION_DECK,0,1,1,nil,tc,e,tp)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
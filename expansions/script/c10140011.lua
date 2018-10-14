--凶恶龙·狱炎龙
function c10140011.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10140011,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,10140011)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10140011.spcon)
	e1:SetTarget(c10140011.sptg)
	e1:SetOperation(c10140011.spop)
	c:RegisterEffect(e1)   
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)   
end
function c10140011.cfilter(c,tp)
	return c:IsSetCard(0x3333) and c:IsFaceup() and c:GetSummonPlayer()==tp
end
function c10140011.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x6333) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c10140011.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10140011.cfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c10140011.cfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c10140011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10140011.spfilter(c,e,tp)
	return c:IsSetCard(0x5333) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c10140011.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)<=0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10140011.spfilter),tp,0x13,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10140011,1)) then
		Duel.BreakEffect() 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEUP)   
	end
end
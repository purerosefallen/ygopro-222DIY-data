--天狐族佣兵-莉莉奈
function c2161005.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2161005,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,2161005)
	e1:SetCondition(c2161005.con)
	e1:SetTarget(c2161005.tg)
	e1:SetOperation(c2161005.op)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,2161012)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c2161005.spcon)
	e2:SetTarget(c2161005.sptg)
	e2:SetOperation(c2161005.spop)
	c:RegisterEffect(e2)
end
function c2161005.con(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetTurnPlayer()==tp
end
function c2161005.filter(c)
	return c:IsSetCard(0x21e) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c2161005.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c2161005.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c2161005.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c2161005.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c2161005.spcon(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetTurnPlayer()==1-tp
end
function c2161005.spfilter(c,e,tp)
	return  c:IsSetCard(0x21e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2161005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.GetLocationCountFromEx(tp)>0 and
	Duel.IsExistingMatchingCard(c2161005.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c2161005.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c2161005.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
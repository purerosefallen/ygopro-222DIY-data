--LA Da'ath 美麗的丘依兒
function c12010004.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12010004,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND+LOCATION_ONFIELD)
	e1:SetCountLimit(1,12010004)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c12010004.thcost)
	e1:SetTarget(c12010004.thtg)
	e1:SetOperation(c12010004.thop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(12010004,1))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_RELEASE)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e8:SetCountLimit(1)
	e8:SetTarget(c12010004.sptg)
	e8:SetOperation(c12010004.spop)
	c:RegisterEffect(e8)
end
function c12010004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c12010004.thfilter(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfba)
end
function c12010004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12010004.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function c12010004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12010004.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
			Duel.SendtoGrave(g,nil,REASON_EFFECT)
	end
end
function c12010004.spfilter(c,e,tp)
	return c:IsSetCard(0xfba) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_PENDULUM)
end
function c12010004.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingTarget(c12010004.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12010004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp)<=0 then return false end
	if not Duel.IsExistingTarget(c12010004.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return false end
	local g=Duel.SelectMatchingCard(tp,c12010004.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+0xfe0000)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end







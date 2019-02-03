local m=12031001
local cm=_G["c"..m]
--原数黑姬 2
function c12031001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12031001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,12031001)
	e1:SetCondition(c12031001.spcon)
	e1:SetTarget(c12031001.sptg)
	e1:SetOperation(c12031001.spop)
	c:RegisterEffect(e1)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(12031001,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,12031001+100)
	e5:SetTarget(c12031001.destg)
	e5:SetOperation(c12031001.desop)
	c:RegisterEffect(e5)
end
function c12031001.gfilter(c)
	return c:IsReason(REASON_COST) and c:IsPreviousLocation(LOCATION_HAND) and c:IsType(TYPE_MONSTER)
end
function c12031001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12031001.gfilter,1,nil) and re and re:IsHasType(0x7e0)
end
function c12031001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12031001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c12031001.thfilter(c)
	return c:IsCode(12031000)
end
function c12031001.thfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xfa0)
end
function c12031001.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_EXTRA,0,1,nil) and ( ( not Duel.IsExistingMatchingCard(c12031001.thfilter,tp,LOCATION_MZONE,0,2,nil) ) or Duel.IsExistingMatchingCard(c12031001.thfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) ) end
	if Duel.IsExistingMatchingCard(c12031001.thfilter,tp,LOCATION_MZONE,0,2,nil) then
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function c12031001.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(nil,tp,LOCATION_EXTRA,0,1,nil)
	if tg:GetCount()>0 then
		tc=tg:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		local code=tc:GetOriginalCode()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(code)
	c:RegisterEffect(e2)
		if Duel.IsExistingMatchingCard(c12031001.thfilter,tp,LOCATION_MZONE,0,2,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c12031001.thfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		end
	end
end
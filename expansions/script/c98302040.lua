--EXEC_RE=NATION/.
function c98302040.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c98302040.actcon)
	e1:SetTarget(c98302040.acttg)
	e1:SetOperation(c98302040.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c98302040.actcon2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c98302040.cost)
	e3:SetCondition(c98302040.actcon3)
	c:RegisterEffect(e3)
end
function c98302040.mzfilter(c,tp)
	return c:IsSetCard(0xad2) and c:IsFaceup() and c:IsControler(tp)
end
function c98302040.spfilter(c,e,tp)
	return c:IsSetCard(0xad2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c98302040.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98302040.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and (e:GetHandler():IsLocation(LOCATION_SZONE) or not Duel.IsPlayerAffectedByEffect(tp,98300000))
end
function c98302040.actcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98302040.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,98300000)
end
function c98302040.actcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98302040.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,98300000) and Duel.GetTurnPlayer()~=tp
end
function c98302040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c98302040.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98302040.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c98302040.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,LOCATION_GRAVE+LOCATION_HAND)
end
function c98302040.activate(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(c98302040.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return false end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(98302040,1))
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

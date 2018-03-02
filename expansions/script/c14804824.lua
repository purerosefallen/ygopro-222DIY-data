--IDOL 珮爷
function c14804824.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	c:SetUniqueOnField(1,1,aux.FilterBoolFunction(Card.IsCode,14804824),LOCATION_MZONE)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(1)
	e2:SetCondition(c14804824.condition)
	e2:SetTarget(c14804824.imtg)
	c:RegisterEffect(e2)
	
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(14804824,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c14804824.atkcon)
	e3:SetOperation(c14804824.atkop)
	c:RegisterEffect(e3)
	 --spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,14804823)
	e4:SetCondition(c14804824.spcon)
	e4:SetTarget(c14804824.sptg)
	e4:SetOperation(c14804824.spop)
	c:RegisterEffect(e4)
	 --Pspsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(14804824,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCountLimit(1,148048231)
	e5:SetTarget(c14804824.target)
	e5:SetOperation(c14804824.operation)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function c14804824.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x4848)
end
function c14804824.imtg(e,c)
	return c:IsSetCard(0x4848)
end

function c14804824.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) 
end
function c14804824.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c14804824.cfilter,1,nil,1-tp)
end
function c14804824.cfilter2(c)
	return c:IsSetCard(0x4848)
end
function c14804824.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c14804824.cfilter2,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(200)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end
function c14804824.spcon(e,tp,eg,ep,ev,re,r,rp)
	   local ec=eg:GetFirst()
	return ec:IsFaceup() and ec:IsControler(tp) and ec:IsSetCard(0x4848)
end
function c14804824.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c14804824.spop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON) 
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end 
function c14804824.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x4848) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14804824.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c14804824.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c14804824.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c14804824.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,400)
end
function c14804824.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.BreakEffect()
		Duel.Recover(1-tp,400,REASON_EFFECT)
	end
end
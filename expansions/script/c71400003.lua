--梦之中的孕妇
function c71400003.initial_effect(c)
	--summon limit
	local el1=Effect.CreateEffect(c)
	el1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	el1:SetType(EFFECT_TYPE_SINGLE)
	el1:SetCode(EFFECT_CANNOT_SUMMON)
	el1:SetCondition(c71400003.sumlimit)
	c:RegisterEffect(el1)
	local el2=el1:Clone()
	el2:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(el2)
	local el3=el1:Clone()
	el3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(el3)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,71400003)
	e1:SetCondition(c71400003.condition1)
	e1:SetTarget(c71400003.target1)
	e1:SetOperation(c71400003.operation1)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400003,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c71400003.condition2)
	e2:SetTarget(c71400003.target2)
	e2:SetOperation(c71400003.operation2)
	c:RegisterEffect(e2)
end
function c71400003.lfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3714)
end
function c71400003.sumlimit(e)
	return not Duel.IsExistingMatchingCard(c71400003.lfilter,e:GetHandlerPlayer(),LOCATION_FZONE,0,1,nil)
end
function c71400003.condition1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c71400003.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c71400003.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		c:RegisterFlagEffect(11223344,RESET_EVENT+0x17a0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71400003,2))
		Duel.SpecialSummonComplete()
	end
end
function c71400003.condition2(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(11223344)~=0
end
function c71400003.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,1000)
end
function c71400003.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,1000,REASON_EFFECT,true)
	Duel.Damage(1-tp,1000,REASON_EFFECT,true)
	Duel.RDComplete()
end
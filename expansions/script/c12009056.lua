--机械妨碍者
function c12009056.initial_effect(c)
	--spsummon opp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12009056,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,12009056)
	e3:SetCondition(c12009056.condition1)
	e3:SetTarget(c12009056.target)
	e3:SetOperation(c12009056.operation1)
	c:RegisterEffect(e3)
	--spsummon opp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12009056,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,12009156)
	e3:SetCondition(c12009056.condition2)
	e3:SetTarget(c12009056.target)
	e3:SetOperation(c12009056.operation)
	c:RegisterEffect(e3)
end
function c12009056.condition1(e,tp,eg,ep,ev,re,r,rp)
   return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():GetPreviousControler()==1-tp
end
function c12009056.condition2(e,tp,eg,ep,ev,re,r,rp)
   return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():GetPreviousControler()==tp
end
function c12009056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c12009056.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c12009056.operation1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
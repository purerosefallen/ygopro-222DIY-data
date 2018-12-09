--传说的羁绊
function c33350001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33350001)
	e1:SetCondition(c33350001.condition)
	e1:SetCost(c33350001.cost)
	e1:SetTarget(c33350001.target)
	e1:SetOperation(c33350001.activate)
	c:RegisterEffect(e1)
	--sad
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33350001,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c33350001.rmcon)
	e2:SetTarget(c33350001.rmtg)
	e2:SetOperation(c33350001.rmop)
	c:RegisterEffect(e2)
end
--c33350001.setname="TaleSouls"
function c33350001.cfilter3(c,tp)
	return c33350001.cfilter(c) and c:IsControler(tp)
end
function c33350001.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:IsExists(c33350001.cfilter3,1,nil,tp)
end
function c33350001.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and eg:GetFirst():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,tp,0)
end
function c33350001.rmop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or Duel.Remove(c,POS_FACEUP,REASON_EFFECT)<=0 or not tc:IsRelateToEffect(e) or not tc:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return end
	tc:RemoveOverlayCard(tp,1,1,REASON_COST)
	local tc2=Duel.GetOperatedGroup():GetFirst()
	if tc2:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc2:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(33350001,1)) then
	   Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c33350001.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c33350001.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c33350001.cfilter(c)
	return c:IsFaceup() and c.setname=="TaleSouls"
end
function c33350001.cfilter2(c)
	return c:IsCode(33351001) and c:IsAbleToGraveAsCost()
end
function c33350001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33350001.cfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c33350001.cfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c33350001.filter(c,e,tp)
	return c:IsCode(33350002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33350001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33350001.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c33350001.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33350001.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

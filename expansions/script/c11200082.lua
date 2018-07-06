--月狂之枪 清兰
function c11200082.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x131),2,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetOperation(c11200082.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11200082)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c11200082.sptg)
	e2:SetOperation(c11200082.spop)
	c:RegisterEffect(e2)
	
end
function c11200082.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		Duel.Damage(1-tp,1100,REASON_EFFECT)
	end
end
function c11200082.rfilter(c)
	return c:IsSetCard(0x131) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c11200082.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c11200082.rfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,e:GetHandler())
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>ct-2 and g:GetCount()>1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
end
function c11200082.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c11200082.rfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,2,2,e:GetHandler())
	if g2:GetCount()==2 and Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)==2 and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,true,POS_FACEUP)>0 then
		e:GetHandler():CompleteProcedure()
	end
end

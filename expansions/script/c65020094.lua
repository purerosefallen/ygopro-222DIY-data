--恶噬祖原
function c65020094.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xada3),2,2)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c65020094.con)
	e1:SetTarget(c65020094.tg)
	e1:SetOperation(c65020094.op)
	c:RegisterEffect(e1)
end
function c65020094.tffilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsForbidden() and c:IsSSetable()
end
function c65020094.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2 
end
function c65020094.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,0,LOCATION_GRAVE,1,nil,e,0,1-tp,false,false) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,LOCATION_GRAVE,0,1,nil,e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c65020094.tffilter,tp,0,LOCATION_GRAVE,1,nil,1-tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c65020094.tffilter,tp,LOCATION_GRAVE,0,1,nil,tp)
	if chk==0 then return b1 or b2 end
	local m=2
	if b1 and b2 then
		m=Duel.SelectOption(tp,aux.Stringid(65020094,0),aux.Stringid(65020094,1))
	elseif b1 then
		m=0
	elseif b2 then
		m=1
	end
	if chk==0 then return b1 or b2 end
	if m==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
	e:SetLabel(m)
end
function c65020094.op(e,tp,eg,ep,ev,re,r,rp)
	local m=e:GetLabel()
	if m==0 and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,0,LOCATION_GRAVE,1,nil,e,0,1-tp,false,false) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,LOCATION_GRAVE,0,1,nil,e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g1=Duel.SelectMatchingCard(1-tp,Card.IsCanBeSpecialSummoned,tp,0,LOCATION_GRAVE,1,1,nil,e,0,1-tp,false,false)
		local g2=Duel.SelectMatchingCard(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_GRAVE,0,1,1,nil,e,0,tp,false,false)
		Duel.SpecialSummon(g1,0,1-tp,1-tp,false,false,POS_FACEUP)
		Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
	elseif m==1 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c65020094.tffilter,tp,0,LOCATION_GRAVE,1,nil,1-tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c65020094.tffilter,tp,LOCATION_GRAVE,0,1,nil,tp) then
		 local tc1=Duel.SelectMatchingCard(1-tp,c65020094.tffilter,tp,0,LOCATION_GRAVE,1,1,nil,1-tp):GetFirst()
		local tc2=Duel.SelectMatchingCard(tp,c65020094.tffilter,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		Duel.SSet(1-tp,tc1)
		 Duel.SSet(tp,tc2)
	end
end

--link2
function c4200012.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_UNION),2)
	c:EnableReviveLimit()
	--spirit
	aux.EnableSpiritReturn(c,EVENT_SPSUMMON_SUCCESS,EVENT_FLIP)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4200012,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c4200012.target)
	e1:SetOperation(c4200012.operation)
	c:RegisterEffect(e1)	
end
function c4200012.filter(c,e,sp)
	return c:IsType(TYPE_UNION) and c:GetLevel()<=4 and c:IsCanBeSpecialSummoned(e,0,sp,true,false)
end
function c4200012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	    local zone=e:GetHandler():GetLinkedZone(tp)
	    return zone~=0 and Duel.IsExistingMatchingCard(c4200012.filter,tp,LOCATION_HAND,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c4200012.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c4200012.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP,zone)
	end
end






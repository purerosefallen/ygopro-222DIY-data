--事龙人 2
function c12018001.initial_effect(c)
	--c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x1fbe),LOCATION_MZONE)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,12018001)
	e2:SetCondition(c12018001.hspcon)
	e2:SetOperation(c12018001.hspop)
	c:RegisterEffect(e2)  
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12018001,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,12018101)
	e1:SetCost(c12018001.thcost)
	e1:SetTarget(c12018001.thtg)
	e1:SetOperation(c12018001.thop)
	c:RegisterEffect(e1)  
	--selfdes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c12018001.descon)
	c:RegisterEffect(e5)
end
function c12018001.ccfilter(c)
	return c:IsSetCard(0x1fbe) and c:IsFaceup()
end
function c12018001.descon(e)
	return Duel.IsExistingMatchingCard(c12018001.ccfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
end
function c12018001.cfilter(c)
	return c:IsSetCard(0x1fbe) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c12018001.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12018001.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12018001.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c12018001.thfilter(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsAbleToHand() and c:IsLevelBelow(4)
end
function c12018001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12018001.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12018001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12018001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c12018001.spfilter(c,tp)
	return (( c:IsRace(RACE_DINOSAUR) and c:IsLevelAbove(9) ) or  c:IsSetCard(0x1fbe) ) and (c:IsControler(tp) or c:IsFaceup()) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c12018001.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetReleaseGroup(tp):Filter(c12018001.spfilter,nil,tp)
	local g2=Duel.GetReleaseGroup(1-tp):Filter(c12018001.spfilter,nil,tp)
	g1:Merge(g2)
	return g1:GetCount()>0
end
function c12018001.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetReleaseGroup(tp):Filter(c12018001.spfilter,nil,tp)
	local g2=Duel.GetReleaseGroup(1-tp):Filter(c12018001.spfilter,nil,tp)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	Duel.Release(tc,REASON_COST)
	c:CopyEffect(tc:GetOriginalCodeRule(),RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,1)
end


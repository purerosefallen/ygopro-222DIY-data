--事龙人 4
function c12018003.initial_effect(c)
	--c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x1fbe),LOCATION_MZONE)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,12018003)
	e2:SetCondition(c12018003.hspcon)
	e2:SetOperation(c12018003.hspop)
	c:RegisterEffect(e2)	  
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12018003,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,12018103)
	e3:SetTarget(c12018003.tgtg)
	e3:SetOperation(c12018003.tgop)
	c:RegisterEffect(e3)
	--selfdes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c12018003.descon)
	c:RegisterEffect(e5)
end
function c12018003.ccfilter(c)
	return c:IsSetCard(0x1fbe) and c:IsFaceup()
end
function c12018003.descon(e)
	return Duel.IsExistingMatchingCard(c12018003.ccfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
end
function c12018003.tgfilter(c)
	return c:IsSetCard(0x1fbe) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c12018003.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12018003.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c12018003.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12018003.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c12018003.spfilter(c,tp)
	return (( c:IsRace(RACE_DRAGON) and c:IsLevelAbove(9) ) or  c:IsSetCard(0x1fbe) ) and (c:IsControler(tp) or c:IsFaceup()) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c12018003.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetReleaseGroup(tp):Filter(c12018003.spfilter,nil,tp)
	local g2=Duel.GetReleaseGroup(1-tp):Filter(c12018003.spfilter,nil,tp)
	g1:Merge(g2)
	return g1:GetCount()>0
end
function c12018003.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetReleaseGroup(tp):Filter(c12018003.spfilter,nil,tp)
	local g2=Duel.GetReleaseGroup(1-tp):Filter(c12018003.spfilter,nil,tp)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	Duel.Release(tc,REASON_COST)
	c:CopyEffect(tc:GetOriginalCodeRule(),RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,1)
end


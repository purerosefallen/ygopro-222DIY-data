--事龙人 1
function c12018000.initial_effect(c)
	--c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x1fbe),LOCATION_MZONE)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,12018000)
	e2:SetCondition(c12018000.hspcon)
	e2:SetOperation(c12018000.hspop)
	c:RegisterEffect(e2)
	--tohandd
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12018000,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,12018100)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(c12018000.target)
	e1:SetOperation(c12018000.operation)
	c:RegisterEffect(e1)
	--selfdes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c12018000.descon)
	c:RegisterEffect(e5)
end
function c12018000.ccfilter(c)
	return c:IsSetCard(0x1fbe) and c:IsFaceup()
end
function c12018000.descon(e)
	return Duel.IsExistingMatchingCard(c12018000.ccfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
end
function c12018000.cfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAbleToHand()
end
function c12018000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re and re:GetHandler():IsRace(RACE_WYRM) and eg:IsExists(c12018000.cfilter,1,nil) end
	local tg=eg:Filter(c12018000.cfilter,nil)
	Duel.SetTargetCard(tg)
	Duel.HintSelection(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,tg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,tg:GetCount(),0,0)
end
function c12018000.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
	   Duel.ShuffleHand(tp)
	   Duel.ConfirmCards(1-tp,g)
	   Duel.Destroy(g,REASON_EFFECT)
	end
end
function c12018000.spfilter(c,tp)
	return (( c:IsRace(RACE_WYRM) and c:IsLevelAbove(9) ) or  c:IsSetCard(0x1fbe) ) and (c:IsControler(tp) or c:IsFaceup()) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c12018000.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetReleaseGroup(tp):Filter(c12018000.spfilter,nil,tp)
	local g2=Duel.GetReleaseGroup(1-tp):Filter(c12018000.spfilter,nil,tp)
	g1:Merge(g2)
	return g1:GetCount()>0
end
function c12018000.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetReleaseGroup(tp):Filter(c12018000.spfilter,nil,tp)
	local g2=Duel.GetReleaseGroup(1-tp):Filter(c12018000.spfilter,nil,tp)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	Duel.Release(tc,REASON_COST)
	c:CopyEffect(tc:GetOriginalCodeRule(),RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,1)
end


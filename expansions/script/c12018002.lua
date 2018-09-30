--事龙人 3
function c12018002.initial_effect(c)
	--c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x1fbe),LOCATION_MZONE)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,12018002)
	e2:SetCondition(c12018002.hspcon)
	e2:SetOperation(c12018002.hspop)
	c:RegisterEffect(e2)  
	--cannot be target/battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SEASERPENT))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)  
	--selfdes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c12018002.descon)
	c:RegisterEffect(e5)
end
function c12018002.ccfilter(c)
	return c:IsSetCard(0x1fbe) and c:IsFaceup()
end
function c12018002.descon(e)
	return Duel.IsExistingMatchingCard(c12018002.ccfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
end
function c12018002.spfilter(c,tp)
	return (( c:IsRace(RACE_SEASERPENT) and c:IsLevelAbove(9) ) or  c:IsSetCard(0x1fbe) ) and (c:IsControler(tp) or c:IsFaceup()) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c12018002.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetReleaseGroup(tp):Filter(c12018002.spfilter,nil,tp)
	local g2=Duel.GetReleaseGroup(1-tp):Filter(c12018002.spfilter,nil,tp)
	g1:Merge(g2)
	return g1:GetCount()>0
end
function c12018002.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetReleaseGroup(tp):Filter(c12018002.spfilter,nil,tp)
	local g2=Duel.GetReleaseGroup(1-tp):Filter(c12018002.spfilter,nil,tp)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	Duel.Release(tc,REASON_COST)
	c:CopyEffect(tc:GetOriginalCodeRule(),RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,1)
end


--最后的决战·田中琴叶
function c81013019.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c81013019.matfilter,2)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.lnklimit)
	c:RegisterEffect(e0)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,81013019)
	e2:SetCondition(c81013019.descon)
	e2:SetTarget(c81013019.destg)
	e2:SetOperation(c81013019.desop)
	c:RegisterEffect(e2)
end
function c81013019.matfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and not c:IsLinkType(TYPE_PENDULUM)
end
function c81013019.descon(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c81013019.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(c81013019.cfilter,tp,0,LOCATION_ONFIELD,nil)
	return #g2>#g1 and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c81013019.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c81013019.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c81013019.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81013019.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function c81013019.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end

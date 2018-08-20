--火枪手
function c12013006.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xfb6),2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c12013006.aclimit)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12013006,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c12013006.tdcon)
	e2:SetCost(c12013006.tdcost)
	e2:SetTarget(c12013006.tdtg)
	e2:SetOperation(c12013006.tdop)
	c:RegisterEffect(e2)  
end
function c12013006.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
function c12013006.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c12013006.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c12013006.filter(c)
	return  c:IsAbleToRemove()
end
function c12013006.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12013006.filter,tp,0,LOCATION_GRAVE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c12013006.filter,tp,0,LOCATION_GRAVE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c12013006.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c12013006.filter,tp,0,LOCATION_GRAVE,nil)
	Duel.Remove(g,nil,2,POS_FACEUP,REASON_EFFECT)
end

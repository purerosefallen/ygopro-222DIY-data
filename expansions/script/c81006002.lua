--Saki Yoshioka, Boyish Elegance
function c81006002.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c81006002.matfilter,2,2)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81006002)
	e2:SetCondition(c81006002.condition)
	e2:SetTarget(c81006002.target)
	e2:SetOperation(c81006002.operation)
	c:RegisterEffect(e2)
	--link target indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c81006002.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c81006002.matfilter(c)
	return c:GetSummonLocation()==LOCATION_DECK
end
function c81006002.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsControler(tp)
end
function c81006002.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81006002.filter,1,nil,tp) and #eg==1
end
function c81006002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c81006002.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c81006002.indtg(e,c)
	return c:GetSummonLocation()==LOCATION_DECK and e:GetHandler():GetLinkedGroup():IsContains(c)
end

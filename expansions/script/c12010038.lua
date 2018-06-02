--靜儀式 忘卻的都市
function c12010038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--ind
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12010038,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,12010038)
	e1:SetCost(c12010038.cost)
	e1:SetTarget(c12010038.target)
	e1:SetOperation(c12010038.operation)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12010038,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1)
	e2:SetCondition(c12010038.drcon)
	e2:SetTarget(c12010038.drtg)
	e2:SetOperation(c12010038.drop)
	c:RegisterEffect(e2)
end
function c12010038.cfilter(c)
	return c:IsSetCard(0xfba) and c:IsReleasable()
end
function c12010038.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12010038.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	local cg=Duel.SelectMatchingCard(tp,c12010038.cfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Release(cg,REASON_COST)
end
function c12010038.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER)
end
function c12010038.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c12010038.indfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c12010038.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	--cannot be destroyed
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xfba))
    e1:SetValue(1)
    Duel.RegisterEffect(e1,tp)
end
function c12010038.ccfilter(c,tp)
	return c:IsReason(REASON_RELEASE) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c12010038.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12010038.ccfilter,1,nil,tp)
end
function c12010038.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c12010038.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end



















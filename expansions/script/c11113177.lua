--超次元立方体 代号XX
function c11113177.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c11113177.mfilter,c11113177.xyzcheck,3,3)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11113177,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c11113177.drcon)
	e2:SetCost(c11113177.drcost)
	e2:SetTarget(c11113177.drtg)
	e2:SetOperation(c11113177.drop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c11113177.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(11113177,1))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCountLimit(1,11113177)
	e5:SetCondition(c11113177.discon)
	e5:SetCost(c11113177.discost)
	e5:SetTarget(c11113177.distg)
	e5:SetOperation(c11113177.disop)
	c:RegisterEffect(e5)
	--flip
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(11113177,2))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,11113178)
	e6:SetTarget(c11113177.mttg)
	e6:SetOperation(c11113177.mtop)
	c:RegisterEffect(e6)
end
function c11113177.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ)
end
function c11113177.xyzfilter(c,g)
	return g:IsExists(Card.IsAttribute,1,c,c:GetAttribute())
end
function c11113177.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1 and g:GetClassCount(Card.GetAttribute)>2 and not g:IsExists(c11113177.xyzfilter,1,nil,g)
end
function c11113177.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c11113177.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
end
function c11113177.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c11113177.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==2
       and e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFacedown() 
	   and Duel.SelectYesNo(tp,aux.Stringid(11113177,3)) then
	    Duel.BreakEffect()
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_ATTACK)
	end
end
function c11113177.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c11113177.discon(e,tp,eg,ep,ev,re,r,rp)
    if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:GetHandler():IsOnField() and Duel.IsChainNegatable(ev)
end
function c11113177.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11113177.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11113177.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end
function c11113177.mtfilter(c,e)
	return c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN) and not c:IsImmuneToEffect(e)
end
function c11113177.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c11113177.mtfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,e) end
end
function c11113177.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c11113177.mtfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil,e)
	if g:GetCount()>0 then
	    Duel.HintSelection(g)
		Duel.Overlay(c,g)
	end
end
--IDOL 章鱼哥
function c14804816.initial_effect(c)
	--link summon
	c:SetUniqueOnField(1,1,aux.FilterBoolFunction(Card.IsCode,14804816),LOCATION_MZONE)
	aux.AddLinkProcedure(c,c14804816.matfilter,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c14804816.atktg)
	e1:SetValue(c14804816.atkval)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c14804816.condition)
	e2:SetTarget(c14804816.imtg)
	e2:SetValue(c14804816.efilter)
	c:RegisterEffect(e2)
	--TODECK
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c14804816.spcon)
	e3:SetTarget(c14804816.target2)
	e3:SetOperation(c14804816.operation2)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(14804816,0))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c14804816.target)
	e4:SetOperation(c14804816.activate)
	c:RegisterEffect(e4)
end
function c14804816.matfilter(c)
	return c:IsSetCard(0x4848) and c:IsLinkType(TYPE_LINK)
end
function c14804816.atktg(e,c)
	return not c:IsSetCard(0x4848)
end
function c14804816.vfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4848)
end
function c14804816.atkval(e,c)
	return Duel.GetMatchingGroupCount(c14804816.vfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*-500
end

function c14804816.cfilter1(c)
	return c:IsSetCard(0x4848)
end
function c14804816.condition(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c14804816.cfilter1,tp,LOCATION_MZONE,0,4,nil)
end
function c14804816.imtg(e,c)
	return c:IsSetCard(0x4848)
end
function c14804816.efilter(e,te)
	return  not te:GetOwner():IsSetCard(0x4848) and te:IsActiveType(TYPE_MONSTER) 
end
function c14804816.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) 
end
function c14804816.spcon(e,tp,eg,ep,ev,re,r,rp)
   return ep~=tp and bit.band(r,REASON_DRAW)==0 and re
		and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x4848) and eg:IsExists(c14804816.cfilter,1,nil,1-tp)
end
function c14804816.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,400)
end
function c14804816.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(1-tp,1)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Recover(1-tp,400,REASON_EFFECT)
	end
end

function c14804816.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
end
function c14804816.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c14804816.filter,tp,LOCATION_EXTRA,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c14804816.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c14804816.filter),tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,3,3,nil)
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

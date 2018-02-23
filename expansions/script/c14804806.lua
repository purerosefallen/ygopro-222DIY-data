--IDOL momo
function c14804806.initial_effect(c)
	--link summon
	c:SetUniqueOnField(1,1,aux.FilterBoolFunction(Card.IsCode,14804806),LOCATION_MZONE)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x4848),2)
	c:EnableReviveLimit()
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c14804806.atktg)
	e1:SetValue(c14804806.atkval)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c14804806.condition)
	e2:SetTarget(c14804806.imtg)
	e2:SetValue(c14804806.efilter)
	c:RegisterEffect(e2)
	 --todeck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(14804806,0))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c14804806.target)
	e4:SetOperation(c14804806.operation)
	c:RegisterEffect(e4)
end

function c14804806.atktg(e,c)
	return not c:IsSetCard(0x4848)
end
function c14804806.vfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4848)
end
function c14804806.atkval(e,c)
	return Duel.GetMatchingGroupCount(c14804806.vfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*-300
end

function c14804806.cfilter(c)
	return c:IsSetCard(0x4848)
end
function c14804806.condition(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c14804806.cfilter,tp,LOCATION_MZONE,0,4,nil)
end
function c14804806.imtg(e,c)
	return c:IsSetCard(0x4848)
end
function c14804806.efilter(e,te)
	return  not te:GetOwner():IsSetCard(0x4848) and te:IsActiveType(TYPE_SPELL) 
end

function c14804806.filter(c)
	return c:IsSetCard(0x4848) and c:IsAbleToDeck()
end
function c14804806.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c14804806.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c14804806.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(1-tp,1) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c14804806.filter,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c14804806.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA)
	local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if ct>0 and dg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rg=dg:Select(tp,1,ct,nil)
		Duel.HintSelection(rg)
		Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
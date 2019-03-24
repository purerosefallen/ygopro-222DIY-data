--STSS·深呼吸
function c107898497.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--draw rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898497,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c107898497.drrcon)
	e1:SetOperation(c107898497.drrop)
	c:RegisterEffect(e1)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(107898497,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c107898497.hdcon)
	e3:SetTarget(c107898497.hdtg)
	e3:SetOperation(c107898497.hdop)
	c:RegisterEffect(e3)
end
function c107898497.tdfilter(c)
	return not c:IsType(TYPE_EQUIP) and not c:IsType(TYPE_FUSION) and not c:IsType(TYPE_LINK) and c:IsSetCard(0x575) and c:IsFaceup() and c:IsAbleToDeck()
end
function c107898497.ptdfilter(c)
	return not c:IsType(TYPE_EQUIP) and not c:IsType(TYPE_FUSION) and not c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsSetCard(0x575)
end
function c107898497.drrcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_DRAW) and re:IsHasProperty(EFFECT_FLAG_PLAYER_TARGET) and Duel.GetChainInfo(ev,CHAININFO_TARGET_PLAYER)==tp
end
function c107898497.drrop(e,tp,eg,ep,ev,re,r,rp)
	local dct=Duel.GetChainInfo(ev,CHAININFO_TARGET_PARAM)
	local ct=10-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ptdc=Duel.GetMatchingGroupCount(c107898497.ptdfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	local dect=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dct>ct then dct=ct end
	if dct>(dect+ptdc) then dct=(dect+ptdc) end
	if dect<dct and Duel.IsExistingMatchingCard(c107898497.tdfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) then
		local g=Duel.GetMatchingGroup(c107898497.tdfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
	if dct<0 then dct=0 end
	Duel.ChangeTargetParam(ev,dct)
end
function c107898497.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>10
end
function c107898497.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c107898497.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	local gct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if gct>10 then
		local sg=g:RandomSelect(tp,gct-10)
		Duel.SendtoDeck(sg,POS_FACEUP,0,REASON_EFFECT)
	end
end
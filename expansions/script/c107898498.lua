--STSS·战略大师
function c107898498.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--confirm deck
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(107898498,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCode(EVENT_PREDRAW)
	e6:SetCountLimit(1)
	e6:SetCondition(c107898498.cfcon)
	e6:SetOperation(c107898498.cfop)
	c:RegisterEffect(e6)
end
function c107898498.cfcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c107898498.cfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c107898498.drfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()<=0 then return end
	local ct=10-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ptdc=Duel.GetMatchingGroupCount(c107898498.ptdfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	local dect=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local dct=5+Duel.GetFlagEffect(tp,107898501)+Duel.GetFlagEffect(tp,107898313)*2
	if dct>ct then dct=ct end
	if dct>(dect+ptdc) then dct=(dect+ptdc) end
	if dect<dct and Duel.IsExistingMatchingCard(c107898498.tdfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) then
		local g=Duel.GetMatchingGroup(c107898498.tdfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
	dct=dct-Duel.GetFlagEffect(tp,107898202)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetValue(dct)
	Duel.RegisterEffect(e1,tp)
end
function c107898498.drfilter(c)
	return c:IsSetCard(0x575) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c107898498.tdfilter(c)
	return not c:IsType(TYPE_EQUIP) and not c:IsType(TYPE_FUSION) and not c:IsType(TYPE_LINK) and c:IsSetCard(0x575) and c:IsFaceup() and c:IsAbleToDeck()
end
function c107898498.ptdfilter(c)
	return not c:IsType(TYPE_EQUIP) and not c:IsType(TYPE_FUSION) and not c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsSetCard(0x575)
end
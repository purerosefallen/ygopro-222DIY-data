--link2
function c4200013.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_UNION),1)
	c:EnableReviveLimit()
	--spirit
	aux.EnableSpiritReturn(c,EVENT_SPSUMMON_SUCCESS,EVENT_FLIP)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4200013,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c4200013.eqcon)
	e1:SetTarget(c4200013.eqtg)
	e1:SetOperation(c4200013.eqop)
	c:RegisterEffect(e1)
end
function c4200013.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c4200013.mgfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsLevelBelow(4) and c:IsType(TYPE_UNION)
	and bit.band(c:GetReason(),0x10000008)==0x10000008
end
function c4200013.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)	
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c4200013.mgfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c4200013.mgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c4200013.mgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,g:GetCount(),0,0)
end
function c4200013.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	--local mg=c:GetMaterial()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<sg:GetCount() then return end
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local tc=sg:GetFirst()
	Duel.Equip(tp,tc,c,false)	
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c4200013.eqlimit)
	tc:RegisterEffect(e1)
end
function c4200013.eqlimit(e,c)
	return e:GetOwner()==c
end
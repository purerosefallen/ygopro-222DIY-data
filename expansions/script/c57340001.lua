--灵樱的永眠
local m=57340001
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c57300000") end,function() require("script/c57300000") end)
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_DARK),3)
	miyuki.AddSummonMusic(c,aux.Stringid(m,1),SUMMON_TYPE_LINK)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.discon)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.discon1)
	e1:SetTarget(cm.distg1)
	e1:SetOperation(cm.disop1)
	c:RegisterEffect(e1)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc,np=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_CONTROLER)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and (loc & 0x0c)~=0 and np~=tp and re:IsActiveType(TYPE_MONSTER)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local zone=bit.band(c:GetLinkedZone(),0x1f)
		return zone>0 and re:GetHandler():IsControlerCanBeChanged(false,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then 
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,re:GetHandler(),1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=bit.band(c:GetLinkedZone(),0x1f)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and zone>0 then
		Duel.GetControl(re:GetHandler(),tp,0,0,zone)
	end
end
function cm.discon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function cm.GetSpellLinkedZones(c)
	local zone=0
	local seq=c:GetSequence()
	if seq>4 or not c:IsLocation(LOCATION_MZONE) then return zone end
	if c:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) and seq>0 then
		zone=zone|(1<<(seq-1))
	end
	if c:IsLinkMarker(LINK_MARKER_BOTTOM) then
		zone=zone|(1<<(seq))
	end
	if c:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) and seq<4 then
		zone=zone|(1<<(seq+1))
	end
	return zone
end
function cm.distg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local zone=cm.GetSpellLinkedZones(c)
		return zone>0 and re:GetHandler():IsSSetable(true,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.disop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=cm.GetSpellLinkedZones(c)
	local rc=re:GetHandler()
    if rc:IsRelateToEffect(re) and zone>0 and rc:IsSSetable(true,tp,zone) and Duel.NegateActivation(ev) then
		rc:CancelToGrave()
		Duel.SSet(tp,rc,tp,false,zone)
		Duel.ConfirmCards(1-tp,rc)
	end
end

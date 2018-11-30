--Answer·莱昂纳多·高垣·迪卡普里枫
function c81009011.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3,c81009011.ovfilter,aux.Stringid(81009011,0))
	c:EnableReviveLimit()
	--battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetOperation(c81009011.baop)
	c:RegisterEffect(e1)
	--discard deck & draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81009011)
	e2:SetCost(c81009011.drcost)
	e2:SetTarget(c81009011.distg)
	e2:SetOperation(c81009011.drop)
	c:RegisterEffect(e2)
end
function c81009011.ovfilter(c)
	return c:IsFaceup() and c:IsLinkAbove(3) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_LINK)
end
function c81009011.baop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=c:GetBattleTarget()
	if d and c:IsFaceup() and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and d:IsStatus(STATUS_BATTLE_DESTROYED) and not d:IsType(TYPE_TOKEN) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_SEND_REPLACE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetTarget(c81009011.reptg)
		e1:SetOperation(c81009011.repop)
		e1:SetLabelObject(c)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		d:RegisterEffect(e1)
	end
end
function c81009011.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_BATTLE) and not c:IsImmuneToEffect(e) end
	return true
end
function c81009011.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
		 if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		 end
	Duel.Overlay(e:GetLabelObject(),Group.FromCards(c))
end
function c81009011.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,3,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,3,3,REASON_COST)
end
function c81009011.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,5) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(5)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,5)
end
function c81009011.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_SPELL)
end
function c81009011.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c81009011.cfilter,nil)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
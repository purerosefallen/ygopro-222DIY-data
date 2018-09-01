--预言者旋转木马
local m=77707003
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	c39913299.announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCardFilter(tp,table.unpack(c39913299.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac_=Duel.AnnounceCardFilter(tp,table.unpack(c39913299.announce_filter))
	e:SetLabel(ac_)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local code=e:GetLabel()
	local c=e:GetHandler()
	local function filter(c)
		return c:IsCode(ac) or c:IsCode(code)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
		if #hg==0 then return end
		Duel.ConfirmCards(1-ep,hg)
		Duel.ShuffleHand(ep)
		local dg=hg:Filter(filter,nil)
		if #dg>0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_DRAW
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
		if #hg==0 then return end
		Duel.ConfirmCards(1-ep,hg)
		Duel.ShuffleHand(ep)
		local dg=hg:Filter(filter,nil)
		if #dg>0 then
			Duel.SendtoHand(dg,tp,REASON_EFFECT)
		end
	end)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
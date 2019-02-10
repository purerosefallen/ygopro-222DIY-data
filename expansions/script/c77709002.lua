local m=77709002
local cm=_G["c"..m]
xpcall(function() require("expansions/script/lap") end,function() require("expansions/sekka1217/script/lap") end)
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Sekka_name_with_lap=true
function cm.initial_effect(c)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(0x14000)
    e1:SetCode(EVENT_DISCARD)
    e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
        if chk==0 then return true end
    end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_M2)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase<HASE_MAIN2 and 1 or 2)
		e1:SetValue(1)
		Duel.RegisterEffect(e1,tp)
    end)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,1,2,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end

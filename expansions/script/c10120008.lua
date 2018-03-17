--天选圣女 神圣之奥特琳德
if not pcall(function() require("expansions/script/c10120001") end) then require("script/c10120001") end
local m=10120008
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_FAIRY),1)
	c:EnableReviveLimit()
	dsrsv.DanceSpiritSummonSucessEffect(c,m,CATEGORY_REMOVE,cm.sstg,cm.ssop,cm.sscon)
	dsrsv.DanceSpiritNegateEffect(c,m,CATEGORY_RECOVER,cm.ntg,cm.nop,EFFECT_FLAG_PLAYER_TARGET)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetCondition(cm.necon)
	e1:SetTarget(cm.netg)
	e1:SetOperation(cm.neop)
	c:RegisterEffect(e1)
end
function cm.necon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev)
end
function cm.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,nil,0,0,0)
end
function cm.neop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsChainDisablable(0) then
		local sel=1
		if Duel.CheckLPCost(rp,1000) and Duel.SelectYesNo(rp,aux.Stringid(m,4)) then
		   Duel.PayLPCost(rp,1000)
		   Duel.NegateEffect(0)
		   return
		end
	end
	Duel.NegateActivation(ev)
end
function cm.ntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function cm.nop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function cm.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE+LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_MZONE+LOCATION_HAND)
end
function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE+LOCATION_HAND)
	if sg:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,562)
	local rc=Duel.AnnounceRace(tp,1,0xffffff)
	local g=sg:Filter(Card.IsRace,nil,rc)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local rg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_RULE)
	end
end

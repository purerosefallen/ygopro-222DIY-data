--拟魂电路 K2心R
if not pcall(function() require("expansions/script/c18005001") end) then require("script/c18005001") end
local m=18005012
local cm=_G["c"..m]
cm.rssetcode="PseudoSoul"
function cm.initial_effect(c)
	local e2=rsef.FV_CANNOT_BE_TARGET(c,"effect",aux.tgoval,aux.TargetBoolFunction(rscf.CheckSetCard,"PseudoSoul"),{LOCATION_ONFIELD,0},cm.con)
	local e4=rsef.QO(c,nil,{m,0},1,nil,nil,LOCATION_FZONE,cm.pcon,nil,rstg.target(rsop.list(cm.cfilter,nil,LOCATION_HAND)),cm.pop)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(cm.atkcon)
	e3:SetTarget(aux.TargetBoolFunction(rscf.CheckSetCard,"PseudoSoul"))
	e3:SetValue(450)
	c:RegisterEffect(e3)
end
function cm.cfilter(c)
	return c:CheckSetCard("PseudoSoul") and c:IsLevelAbove(5)
end
function cm.pcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	end
end
function cm.pop(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsLevelAbove,tp,LOCATION_HAND,0,nil,5)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsLocation(LOCATION_HAND) then Duel.ShuffleHand(tp) end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		e1:SetValue(-2)
		tc:RegisterEffect(e1)
	end
end
function cm.atkcon(e)
	local d=Duel.GetAttackTarget()
	local tp=e:GetHandlerPlayer()
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and d and d:IsControler(1-tp) and cm.con(e)
end
function cm.con(e,tp)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0
end 
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,nil)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
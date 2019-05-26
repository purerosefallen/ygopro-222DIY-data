--心之怪盗团-总攻击
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873635
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c)	
	local e1=rsef.ACT(c,nil,nil,{1,m},"des,dam",nil,cm.con,nil,rstg.target2(cm.fun,rsop.list(aux.TRUE,"des",0,LOCATION_ONFIELD,true)),cm.activate)
end 
function cm.con(e,tp)
	local g=Duel.GetMatchingGroup(rscf.FilterFaceUp(rsphh.set),tp,LOCATION_MZONE,0,nil)
	return #g>=4 and g:IsExists(Card.IsCode,1,nil,15873611)
end
function cm.fun(g,e,tp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,#g*500)
end
function cm.activate(e,tp)
	local ph=Duel.GetCurrentPhase()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	if Duel.GetTurnPlayer()~=tp and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(cm.skipcon)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if #g<=0 then return end
	local ct=Duel.Destroy(g,REASON_EFFECT)
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end
function cm.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
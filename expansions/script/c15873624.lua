--人格面具-齐天大圣
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873624
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c,true)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(rsphh.mset),1)
	local e1=rsphh.ImmueFun(c,ATTRIBUTE_DARK)
	local e2=rsphh.EndPhaseFun(c,15873612)  
	local e3=rsef.I(c,{m,0},1,"des,dam","tg",LOCATION_MZONE,nil,cm.descost,rstg.target2(cm.fun,aux.TRUE,"des",0,LOCATION_ONFIELD,1),cm.desop)
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function cm.fun(g,e,tp)
	local dg=g:Filter(rscf.FilterFaceUp(Card.IsAttribute,ATTRIBUTE_DARK),nil) 
	if #dg>0 then
		local atk=dg:GetSum(Card.GetBaseAttack)/2
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	end
end
function cm.desop(e,tp)
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
	--Duel.RegisterEffect(e1,tp)
	local g=rsgf.GetTargetGroup()
	if #g<=0 or Duel.Destroy(g,REASON_EFFECT)<=0 then return end
	local og=Duel.GetOperatedGroup():Filter(aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),nil)
	if #og>0 then
		local atk=og:GetSum(Card.GetBaseAttack)/2
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
function cm.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
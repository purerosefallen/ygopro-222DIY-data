--拟魂 意识
if not pcall(function() require("expansions/script/c18005001") end) then require("script/c18005001") end
local m=18005008
local cm=_G["c"..m]
cm.rssetcode="PseudoSoul"
function cm.initial_effect(c)
	rsps.EndPhasePFun(c,true)
	rsps.EndPhaseMFun(c)
	rsps.FieldToHandFun(c)
	rsps.SummonSucessFun(c,m,nil,0,aux.TRUE,cm.op)
end
function cm.op(e,tp)
	local c=rscf.GetRelationThisCard(e)
	if not c then return end
	local atk=c:GetBaseAttack()*2
	local e1=rsef.SV_SET(c,"batk",atk,nil,rsreset.est_pend+RESET_DISABLE)
end
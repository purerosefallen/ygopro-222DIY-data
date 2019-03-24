--龙棋兵团防御阵型
if not pcall(function() require("expansions/script/c18006001") end) then require("script/c18006001") end
local m=18006008
local cm=_G["c"..m]
cm.rssetcode="DragonChessCorps"
function cm.initial_effect(c)
	local e1=rsdcc.Activate(c,m,"atk",cm.op)	
	local e2=rsef.FV_INDESTRUCTABLE(c,"effect",aux.indoval,rsdcc.tg,{LOCATION_ONFIELD,LOCATION_ONFIELD })
	local e3=rsef.FV_CANNOT_BE_TARGET(c,"effect",aux.tgoval,rsdcc.tg,{LOCATION_ONFIELD,LOCATION_ONFIELD })
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e4:SetTarget(rsdcc.tg2)
	e4:SetLabel(TYPE_SPELL)
	c:RegisterEffect(e4)
end
function cm.op(e,tp)
	local c,tc=e:GetHandler(),rscf.GetTargetCard()
	if not tc then return end
	local e1=rsef.SV_UPDATE({c,tc},"atk",-500,nil,rsreset.est_pend)
	local e2=rsef.SV_IMMUNE_EFFECT({c,tc},rsval.imoe,nil,rsreset.est_pend)
end

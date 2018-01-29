--残留于世的美术
local m=37564043
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_elem=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,63)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	local e1,e2=Senya.CopySpellModule(c,0,0,Senya.check_set_rose,nil,nil,1,m,nil,true)
	local e3,e4=Senya.CopySpellModule(c,LOCATION_GRAVE,0,Senya.check_set_rose,nil,Senya.RemoveOverlayCost(2),1,m-4000,nil)
	e1:SetDescription(m*16)
	e2:SetDescription(m*16)
	e3:SetDescription(m*16+1)
	e4:SetDescription(m*16+1)
end